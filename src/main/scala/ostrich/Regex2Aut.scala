/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2021 Matthew Hague, Philipp Ruemmer. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich

import ap.basetypes.IdealInt
import ap.parser._
import ap.theories.strings.StringTheory
import ap.theories.ModuloArithmetic

import dk.brics.automaton.{BasicAutomata, BasicOperations, RegExp,
                           Automaton => BAutomaton}

import scala.collection.mutable.{ArrayBuffer, ArrayStack}
import scala.collection.immutable.VectorBuilder
import collection.JavaConverters._

object Regex2Aut {

  private val RegexClassSpecialChar = """\[[^\[\]]*(\\[wsd])""".r
  private val LookAheadBehind = """\(\?[=!<]""".r

  object SmartConst {
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
                 re_++, re_union, re_inter, re_diff, re_*, re_+, re_opt,
                 re_comp, re_loop, str_to_re, re_from_str, re_from_ecma2020,
                 re_case_insensitive}
  import Regex2Aut._

  def toBricsRegexString(t : ITerm) : String =
    Regex2BricsVisitor.visit(t, ())

  //////////////////////////////////////////////////////////////////////////////

  private object Regex2BricsVisitor extends CollectingVisitor[Unit, String] {

    override def preVisit(t : IExpression,
                          arg : Unit) : PreVisitResult = t match {
      case SmartConst(_) =>
        ShortCutResult("")

      case IFunApp(`re_charrange`,
                   Seq(SmartConst(IdealInt(a)), SmartConst(IdealInt(b)))) =>
        ShortCutResult(
          "[\\" + numToUnicode(a) + "-" + "\\" + numToUnicode(b) + "]")

      case IFunApp(`str_to_re`, Seq(a)) => {
        System.out.println(a);
        val res =
          StringTheory.term2List(a) match {
            case Seq() =>
              "()"
            case str =>
              (for (v <- str;
                    c <- "[\\" + numToUnicode(v) + "]")
               yield c).mkString
          }
        ShortCutResult(res)
      }

      case IFunApp(`re_from_str`, Seq(a)) => {
        System.out.println(a);
        // TODO: this translation has to be checked more carefully, there might
        // be problems due to escaping. The processing of regexes can also
        // only be done correctly within a proper regex parser.
  
        ShortCutResult(jsRegex2BricsRegex(StringTheory.term2String(a)))
      }

      case _ =>
        KeepArg
    }

    def postVisit(t : IExpression,
                  arg : Unit,
                  subres : Seq[String]) : String = t match {
      case IFunApp(`re_none`, _) =>
        "#"
      case IFunApp(`re_eps`, _) =>
        "()"
      case IFunApp(`re_all`, _) =>
        ".*"
      case IFunApp(`re_allchar`, _) =>
        "."
      case IFunApp(`re_++`, _) =>
        subres(0) + subres(1)
      case IFunApp(`re_union`, _) =>
        "(" + subres(0) + "|" + subres(1) + ")"
      case IFunApp(`re_inter`, _) =>
        "(" + subres(0) + "&" + subres(1) + ")"
      case IFunApp(`re_*`, _) =>
        "(" + subres(0) + ")*"
      case IFunApp(`re_+`, _) =>
        "(" + subres(0) + ")+"
      case IFunApp(`re_opt`, _) =>
        "(" + subres(0) + ")?"
      case IFunApp(`re_comp`, _) =>
        "~(" + subres(0) + ")"
      case IFunApp(`re_loop`, Seq(IIntLit(n1), IIntLit(n2), _)) =>
        "(" + subres(2) + "){" + n1 + "," + n2 + "}"

    case _ =>
      throw new IllegalArgumentException(
        "could not translate " + t + " to an automaton")
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  private def toBAutomaton(t : ITerm,
                           minimize : Boolean) : BAutomaton = t match {
    case IFunApp(`re_charrange`,
    Seq(SmartConst(IdealInt(a)), SmartConst(IdealInt(b)))) =>
      BasicAutomata.makeCharRange(a.toChar, b.toChar)

    case IFunApp(`str_to_re`, Seq(a)) => {
      // modified by Riccardo
      a match {
        case IIntLit(value) => BasicAutomata.makeString(theory.strDatabase.listInt2String(theory.strDatabase.id2Str(value.intValueSafe)))
        case _ => BasicAutomata.makeString(StringTheory.term2String(a))
      }
    }

    case IFunApp(`re_from_str`, Seq(a)) => {
      // TODO: this translation has to be checked more carefully, there might
      // be problems due to escaping. The processing of regexes can also
      // only be done correctly within a proper regex parser.
  
      val bricsPattern = jsRegex2BricsRegex(StringTheory.term2String(a))
      new RegExp(bricsPattern).toAutomaton(minimize)
    }

    case IFunApp(`re_from_ecma2020`, Seq(a)) => {
      val parser = new ECMARegexParser(theory)
      val t = parser.string2Term(StringTheory.term2String(a))
      toBAutomaton(t, minimize)
    }

    case IFunApp(`re_case_insensitive`, Seq(a)) => {
      val aut = toBAutomaton(a, minimize)
      maybeMin(AutomataUtils.makeCaseInsensitive(
                 new BricsAutomaton(aut))
                 .asInstanceOf[BricsAutomaton].underlying,
               minimize)
    }

    case IFunApp(`re_none`, _) =>
      BasicAutomata.makeEmpty
    case IFunApp(`re_eps`, _) =>
      BasicAutomata.makeString("")
    case IFunApp(`re_all`, _) =>
      BasicAutomata.makeAnyString
    case IFunApp(`re_allchar`, _) =>
      BasicAutomata.makeAnyChar

    case IFunApp(`re_++`, _) =>
      maybeMin(BasicOperations.concatenate(translateLeaves(t, re_++, minimize)),
               minimize)

    case IFunApp(`re_union`, _) => {
      val leaves = collectLeaves(t, re_union)
      val (singletons, nonSingletons) = leaves partition {
        case IFunApp(`str_to_re`, _) => true
        case _                       => false
      }

      val singletonAuts =
        if (singletons.isEmpty) {
          List()
        } else {
          val strings =
            (for (IFunApp(_, Seq(a)) <- singletons)
             yield StringTheory.term2String(a)).toArray
          List(BasicAutomata.makeStringUnion(strings : _*))
        }

      val nonSingletonAuts =
        for (s <- nonSingletons) yield toBAutomaton(s, minimize)

      (singletonAuts, nonSingletonAuts) match {
        case (Seq(aut), Seq()) => aut
        case (Seq(), Seq(aut)) => aut
        case (auts1, auts2) =>
          maybeMin(BasicOperations.union((auts1 ++ auts2).asJava), minimize)
      }
    }

    case IFunApp(`re_inter`, _) => {
      val leaves = collectLeaves(t, re_inter)
      val leaveAuts = for (s <- leaves) yield toBAutomaton(s, minimize)
      leaveAuts reduceLeft {
        (aut1, aut2) =>
        maybeMin(BasicOperations.intersection(aut1, aut2), minimize)
      }
    }

    case IFunApp(`re_diff`, Seq(t1, t2)) =>
      maybeMin(BasicOperations.minus(toBAutomaton(t1, minimize),
                                     toBAutomaton(t2, minimize)), minimize)

    case IFunApp(`re_*`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).repeat, minimize)
    case IFunApp(`re_+`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).repeat(1), minimize)
    case IFunApp(`re_opt`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).optional, minimize)
    case IFunApp(`re_comp`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).complement, minimize)
    case IFunApp(`re_loop`,
                 Seq(IIntLit(IdealInt(n1)), IIntLit(IdealInt(n2)), t)) =>
      maybeMin(toBAutomaton(t, minimize).repeat(n1, n2), minimize)

  }

  private def maybeMin(aut : BAutomaton, minimize : Boolean) : BAutomaton = {
    if (minimize && !BricsAutomaton.neverMinimize(aut))
      aut.minimize
    aut
  }

  private def translateLeaves(t        : ITerm,
                              op       : IFunction,
                              minimize : Boolean)
                            : java.util.List[BAutomaton] = {
    val leaves = collectLeaves(t, re_++)
    val leaveAuts = for (s <- leaves) yield toBAutomaton(s, minimize)
    leaveAuts.asJava
  }

  private def collectLeaves(t : ITerm, op : IFunction) : Seq[ITerm] = {
    val todo = new ArrayStack[ITerm]
    todo push t

    val res = new VectorBuilder[ITerm]

    while (!todo.isEmpty)
      todo.pop match {
        case IFunApp(`op`, args) =>
          for (s <- args.reverseIterator)
            todo push s
        case s =>
          res += s
      }

    res.result
  }

  //////////////////////////////////////////////////////////////////////////////

  /**
   * Translate a string representing a JavaScript/ECMA regex to a
   * Brics regex.
   *  TODO: this translation has to be checked more carefully, there might
   *  be problems due to escaping. The processing of regexes can also
   *  only be done correctly within a proper regex parser.
   */
  private def jsRegex2BricsRegex(str : String) : String = {
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
            curStr = curStr.take(m.start(1)) + repl + curStr.drop(m.end(1))
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
    toBAutomaton(t, true)

  def buildAut(t : ITerm) : AtomicStateAutomaton =
    new BricsAutomaton(toBAutomaton(t, true))

  private def numToUnicode(num : Int) : String =
    new String(Character.toChars(num))

}
