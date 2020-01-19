/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2019-2020  Matthew Hague, Philipp Ruemmer
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

class OstrichPreprocessor(theory : OstrichStringTheory)
      extends ContextAwareVisitor[Unit, IExpression] {

  import IExpression._
  import theory._
  import StringTheory.ConcreteString

  private def reCat(ts : ITerm*) : ITerm = ts match {
    case Seq() => re_eps()
    case ts    => ts reduceLeft (re_++(_, _))
  }

  private def reUnion(ts : ITerm*) : ITerm = ts match {
    case Seq() => re_none()
    case ts    => ts reduceLeft (re_union(_, _))
  }

  private def strCat(ts : ITerm*) : ITerm = ts match {
    case Seq() => str_empty()
    case ts    => ts reduceLeft (str_++(_, _))
  }

  def apply(f : IFormula) : IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(t : IExpression,
                ctxt : Context[Unit],
                subres : Seq[IExpression]) : IExpression = (t, subres) match {
    case (IAtom(`str_contains`, _),
          Seq(bigStr : ITerm, subStr@ConcreteString(_))) => {
      val asRE = reCat(re_all(), str_to_re(subStr), re_all())
      str_in_re(bigStr, asRE)
    }
/*
    case (IAtom(`str_contains`, _),
          Seq(bigStr, subStr)) => {
      println(subStr)
      println(bigStr)
      t update subres
    }
 */

    case (IAtom(`str_prefixof`, _),
          Seq(subStr@ConcreteString(_), bigStr : ITerm)) => {
      val asRE = re_++(str_to_re(subStr), re_all())
      str_in_re(bigStr, asRE)
    }
    case (IAtom(`str_prefixof`, _),
          Seq(subStr : ITerm, bigStr : ITerm)) if ctxt.polarity < 0 => {
      val s = VariableShiftVisitor(subStr, 0, 1)
      val t = VariableShiftVisitor(bigStr, 0, 1)
      StringSort.ex(str_++(s, v(0)) === t)
    }

    case (IFunApp(`str_indexof`, _),
          Seq(bigStr : ITerm, subStr@ConcreteString(subStrStr),
              IIntLit(IdealInt.ZERO) /* startIndex : ITerm */ )) => {
      val shBigStr3 = VariableShiftVisitor(bigStr, 0, 3)
      val ind = v(2)

      // the search string must not occur in the prefix
      // of the big string concatenated with the search string
      val containingStr =
        reCat(re_all(), str_to_re(subStr), re_all())
      val forbiddenSuffixes =
        for (n <- 1 until subStrStr.size;
             s = subStrStr substring n;
             if subStrStr startsWith s)
        yield subStrStr.substring(0, n)
      val forbiddenSuffixREs =
        for (s <- forbiddenSuffixes) yield re_++(re_all(), str_to_re(s))
      val containingOrSuffix =
        reUnion(List(containingStr) ++ forbiddenSuffixREs : _*)

      val res = eps(StringSort.ex(StringSort.ex(
        (ind === -1 & !str_in_re(shBigStr3, containingStr)) |
        (ind === str_len(v(0)) &
           strCat(v(0), subStr, v(1)) === shBigStr3 &
           !str_in_re(v(0), containingOrSuffix))
      )))

      res
    }

    case (t, _) =>
      t update subres
  }

}
