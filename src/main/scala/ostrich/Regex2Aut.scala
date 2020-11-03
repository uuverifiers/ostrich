/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2018-2020  Philipp Ruemmer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package ostrich

import ap.basetypes.IdealInt
import ap.parser._
import ap.theories.strings.StringTheory
import ap.theories.ModuloArithmetic

import dk.brics.automaton.{BasicAutomata, BasicOperations, RegExp,
                           Automaton => BAutomaton}

import scala.collection.mutable.ArrayBuffer

object Regex2Aut {

  private val RegexClassSpecialChar = """\[[^\[\]]*(\\[wsd])""".r
  private val LookAheadBehind = """\(\?[=!<]""".r

  private object SmartConst {
    import IExpression._
    def unapply(t : ITerm) : Option[IdealInt] = t match {
      case Const(value) =>
        Some(value)
      case IFunApp(ModuloArithmetic.mod_cast,
                   Seq(Const(lower), Const(upper), SmartConst(value))) =>
        Some(ModuloArithmetic.evalModCast(lower, upper, value))
      case _ =>
        None
    }
  }

}

class Regex2Aut(theory : OstrichStringTheory) {

  import theory.{re_none, re_all, re_eps, re_allchar, re_charrange,
                 re_++, re_union, re_inter, re_*, re_+, re_opt, re_comp,
                 re_loop, str_to_re, re_from_str}
  import Regex2Aut._

  def buildBricsRegex(t : ITerm) : String = t match {
    case IFunApp(`re_none`, _) =>
      "#"
    case IFunApp(`re_eps`, _) =>
      "()"
    case IFunApp(`re_all`, _) =>
      ".*"
    case IFunApp(`re_allchar`, _) =>
      "."
    case IFunApp(`re_charrange`,
                 Seq(SmartConst(IdealInt(a)), SmartConst(IdealInt(b)))) =>
      "[\\" + numToUnicode(a) + "-" + "\\" + numToUnicode(b) + "]"
    case IFunApp(`re_++`, Seq(a, b)) =>
      buildBricsRegex(a) + buildBricsRegex(b)
    case IFunApp(`re_union`, Seq(a, b)) =>
      "(" + buildBricsRegex(a) + "|" + buildBricsRegex(b) + ")"
    case IFunApp(`re_inter`, Seq(a, b)) =>
      "(" + buildBricsRegex(a) + "&" + buildBricsRegex(b) + ")"
    case IFunApp(`re_*`, Seq(a)) =>
      "(" + buildBricsRegex(a) + ")*"
    case IFunApp(`re_+`, Seq(a)) =>
      "(" + buildBricsRegex(a) + ")+"
    case IFunApp(`re_opt`, Seq(a)) =>
      "(" + buildBricsRegex(a) + ")?"
    case IFunApp(`re_comp`, Seq(a)) =>
      "~(" + buildBricsRegex(a) + ")"
    case IFunApp(`re_loop`, Seq(IIntLit(n1), IIntLit(n2), a)) =>
      "(" + buildBricsRegex(a) + "){" + n1 + "," + n2 + "}"

    case IFunApp(`str_to_re`, Seq(a)) =>
      StringTheory.term2List(a) match {
        case Seq() =>
          "()"
        case str => 
          (for (v <- str;
                c <- "[\\" + numToUnicode(v) + "]")
           yield c).mkString
      }

    case IFunApp(`re_from_str`, Seq(a)) => {
      // TODO: this translation has to be checked more carefully, there might
      // be problems due to escaping. The processing of regexes can also
      // only be done correctly within a proper regex parser.

      val str = StringTheory.term2String(a)

      // BRICS cannot handle anchors, so currently we are just removing them
      // TODO: find a better solution for this

      var begin = 0
      while (begin < str.size && str(begin) == '^') {
        Console.err.println("Warning: ignoring anchor ^")
        begin = begin + 1
      }

      var end = str.size
      while (end > 0 && str(end - 1) == '$') {
        Console.err.println("Warning: ignoring anchor $")
        end = end - 1
      }

      val str2 = str.slice(begin, end)

      // handle some of the PCRE sequences, inside character classes
      // TODO: do this more systematically
      val str3 = {
        var curStr = str2
        var cont = true
        while (cont)
          RegexClassSpecialChar.findFirstMatchIn(curStr) match {
            case Some(m) => {
              val repl = m.group(1) match {
                case "\\w" => "A-Za-z0-9_"
                case "\\s" => " "
                case "\\d" => "0-9"
              }
              curStr =
                curStr.take(m.start(1)) + repl + curStr.drop(m.end(1))
            }
            case None =>
              cont = false
          }
        curStr
      }

      // handle some of the PCRE sequences, outside of character classes
      // TODO: do this more systematically
      val str4 = str3.replaceAll("""\\w""", "[A-Za-z0-9_]")
                     .replaceAll("""\\W""", "[^A-Za-z0-9_]")
                     .replaceAll("""\\s""", "[ ]")
                     .replaceAll("""\\S""", "[^ ]")
                     .replaceAll("""\\d""", "[0-9]")
                     .replaceAll("""\\D""", "[^0-9]")
                     .replaceAll("""\(\?:""", "(")
                     .replaceAll("""@""", "\\\\@")
                     .replaceAll("""<""", "\\\\<")

      // encode some simple cases of look-aheads, and eliminate the more
      // complicated cases
      val str5 = {
        val curStr = str4
        val lookAheads = new ArrayBuffer[String]
        var curInd = 0

        var cont = true
        while (cont) {
          curStr.substring(curInd, (curInd + 3) min curStr.size) match {
            case "(?=" => { // positive look-ahead
              val endInd = findRegexClosingParen(curStr, curInd)
              lookAheads += "(" + curStr.substring(curInd + 3, endInd) + "@)"
              curInd = endInd + 1
            }
            case "(?!" => { // negative look-ahead
              val endInd = findRegexClosingParen(curStr, curInd)
              lookAheads += "~(" + curStr.substring(curInd + 3, endInd) + "@)"
              curInd = endInd + 1
            }
            case _ =>
              cont = false
          }
          if (curInd >= curStr.size)
            cont = false
        }

        if (!lookAheads.isEmpty)
          lookAheads.mkString("&") + "&(" + curStr.substring(curInd) + ")"
        else
          curStr
      }

      // eliminate the more complicated cases of look-ahead/behind
      val str6 = {
        var curStr = str5
        var cont = true

        while (cont)
          LookAheadBehind.findFirstMatchIn(curStr) match {
            case Some(m) => {
              val ind = m.start
              curStr =
                curStr.take(ind) +
                  curStr.drop(findRegexClosingParen(curStr, ind) + 1)
              Console.err.println(
                "Warning: ignoring look-ahead/behind in regular expression")
            }
            case None =>
              cont = false
          }

        curStr
      }

      str6
    }

    case _ =>
      throw new IllegalArgumentException(
        "could not translate " + t + " to an automaton")
  }

  /**
   * Given an opening parenthesis at index <code>openInd</code> in a
   * regex string, find the matching closing parenthesis.
   */
  private def findRegexClosingParen(str : String, openInd : Int) : Int = {
    val N = str.size
    var nesting = 1
    var curInd = openInd
    var state = 0

    while (nesting > 0 && curInd < N - 1) {
      curInd = curInd + 1

      (str(curInd), state) match {
        case ('(', 0) =>            // opening paren
          nesting = nesting + 1
        case (')', 0) =>            // closing paren
          nesting = nesting - 1
        case ('[', 0) =>            // start of a character class
          state = 10
        case (']', 10) =>           // end of a character class
          state = 0
        case ('\\', 0) =>           // start of an escaped character
          state = 1
        case ('x', 1) =>            // pair of hex characters
          state = 4
        case ('u', 1) =>            // quadruple of hex characters
          state = 2
        case (_, 1) =>              // single escaped character
          state = 0
        case (_, n) if 2<=n && n<=4 => // hex characters
          state = n + 1
        case (_, 5) =>              // hex characters
          state = 0
        case _ =>
          // nothing
      }
    }

    curInd
  }

  def buildBricsAut(t : ITerm) : BAutomaton =
    new RegExp(buildBricsRegex(t)).toAutomaton

  def buildAut(t : ITerm) : AtomicStateAutomaton =
    BricsAutomaton(buildBricsRegex(t))

  private def numToUnicode(num : Int) : String =
    new String(Character.toChars(num))

}
