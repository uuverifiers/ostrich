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

import dk.brics.automaton.{BasicAutomata, BasicOperations, RegExp,
                           Automaton => BAutomaton}

object Regex2Aut {

  private val RegexClassSpecialChar = """\[[^\[\]]*(\\[wsd])""".r

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
                 Seq(IIntLit(IdealInt(a)), IIntLit(IdealInt(b)))) =>
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

      if ((str4 contains "(?=") || (str4 contains "(?!"))
        Console.err.println("Warning: look-ahead in regular expression not handled")
      if (str4 contains "(?<")
        Console.err.println("Warning: look-behind in regular expression not handled")

      str4
    }

    case _ =>
      throw new IllegalArgumentException(
        "could not translate " + t + " to an automaton")
  }

  def buildBricsAut(t : ITerm) : BAutomaton =
    new RegExp(buildBricsRegex(t)).toAutomaton

  def buildAut(t : ITerm) : AtomicStateAutomaton =
    BricsAutomaton(buildBricsRegex(t))

  private def numToUnicode(num : Int) : String =
    new String(Character.toChars(num))

}
