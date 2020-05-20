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

class Regex2Aut(theory : OstrichStringTheory) {

  import theory.{re_none, re_all, re_eps, re_allchar, re_charrange,
                 re_++, re_union, re_inter, re_*, re_+, re_opt, re_comp,
                 re_loop, str_to_re}

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
    case _ =>
      throw new IllegalArgumentException
  }

  def buildBricsAut(t : ITerm) : BAutomaton =
    new RegExp(buildBricsRegex(t)).toAutomaton

  def buildAut(t : ITerm) : AtomicStateAutomaton =
    BricsAutomaton(buildBricsRegex(t))

  private def numToUnicode(num : Int) : String =
    new String(Character.toChars(num))

}
