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

/**
 * Pre-processor for reducing some operators to more basic ones.
 */
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
      StringSort.ex(str_++(s, v(0, StringSort)) === t)
    }

    case (IAtom(`str_suffixof`, _),
          Seq(subStr@ConcreteString(_), bigStr : ITerm)) => {
      val asRE = re_++(re_all(), str_to_re(subStr))
      str_in_re(bigStr, asRE)
    }
    case (IAtom(`str_suffixof`, _),
          Seq(subStr : ITerm, bigStr : ITerm)) if ctxt.polarity < 0 => {
      val s = VariableShiftVisitor(subStr, 0, 1)
      val t = VariableShiftVisitor(bigStr, 0, 1)
      StringSort.ex(str_++(v(0, StringSort), s) === t)
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

      eps(StringSort.ex(StringSort.ex(
        (ind === -1 & !str_in_re(shBigStr3, containingStr)) |
        (ind === str_len(v(0, StringSort)) &
           strCat(v(0, StringSort), subStr, v(1, StringSort)) === shBigStr3 &
           !str_in_re(v(0, StringSort), containingOrSuffix))
      )))
    }

    case (IFunApp(`str_substr`, _),
          Seq(bigStr : ITerm, begin : ITerm, len : ITerm)) => {
      val shBigStr3 = VariableShiftVisitor(bigStr, 0, 3)
      val shBegin3  = VariableShiftVisitor(begin, 0, 3)
      val shLen3    = VariableShiftVisitor(len, 0, 3)

      StringSort.eps(StringSort.ex(StringSort.ex(
        strCat(v(1, StringSort), v(2, StringSort), v(0, StringSort)) === shBigStr3 &
        str_len(v(1, StringSort)) === shBegin3 &
        str_len(v(2, StringSort)) === shLen3     // TODO: what should happen when
                                                 // extracting more characters than
                                                 // a string contains?
      )))
    }

    case (IFunApp(`str_at`, _),
          Seq(bigStr : ITerm, index : ITerm)) => {
      val shBigStr3 = VariableShiftVisitor(bigStr, 0, 3)
      val shIndex3  = VariableShiftVisitor(index, 0, 3)

      StringSort.eps(StringSort.ex(StringSort.ex(
        strCat(v(1, StringSort), v(2, StringSort), v(0, StringSort)) === shBigStr3 &
        str_len(v(1, StringSort)) === shIndex3 &
        str_in_re(v(2, StringSort), re_allchar()) // TODO: what should happen when
                                                  // extracting a character outside of the
                                                  // string range?
      )))
    }

    case (IFunApp(`str_++`, _),
          Seq(ConcreteString(str1), ConcreteString(str2))) =>
      string2Term(str1 + str2)

    case (IFunApp(`str_from_code`, _), Seq(Const(code))) =>
      if (code >= 0 & code < theory.alphabetSize)
        str_cons(code, str_empty())
      else
        str_empty()

    case (IFunApp(`str_from_code`, _), Seq(code : ITerm)) =>
      ite(code >= 0 & code < theory.alphabetSize,
          str_cons(code, str_empty()),
          str_empty())

    case (IFunApp(`re_range`, _),
          Seq(IFunApp(`str_cons`, Seq(lower, IFunApp(`str_empty`, _))),
              IFunApp(`str_cons`, Seq(upper, IFunApp(`str_empty`, _))))) =>
      re_charrange(lower, upper)

    case (t, _) =>
      (t update subres) match {
        case Geq(Const(bound), IFunApp(`str_len`, Seq(w))) if bound <= 1000 =>
          // encode an upper bound using a regular expression
          str_in_re(w, re_loop(0, bound, re_allchar()))
        case Geq(IFunApp(`str_len`, Seq(w)), Const(bound)) if bound <= 1000 =>
          // encode a lower bound using a regular expression
          str_in_re(w, re_++(re_loop(bound, bound, re_allchar()), re_all()))
        case newT =>
          newT
      }
  }

}


/**
 * Pre-processor for replacing regular expressions with just numeric ids,
 * which streamlines the translation to automata.
 */
class OstrichRegexEncoder(theory : OstrichStringTheory)
      extends ContextAwareVisitor[Unit, IExpression] {
  import IExpression._
  import theory._

  def apply(f : IFormula) : IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(t : IExpression,
                ctxt : Context[Unit],
                subres : Seq[IExpression]) : IExpression = (t, subres) match {
    case (IAtom(`str_in_re`, _),
          Seq(s : ITerm, ConcreteRegex(regex))) =>
      str_in_re_id(s, theory.autDatabase.regex2Id(regex))
    case (IAtom(`str_in_re`, _), Seq(_, regex)) => {
      println("Warning: could not encode regular expression right away," +
                " post-poning: " + subres)
      t update subres
    }
    case _ =>
      t update subres
  }

}



/** Added by Riccardo
 * Stores constant string to strDatabase for easy access.
 * */
class OstrichStringEncoder(theory : OstrichStringTheory)
  extends ContextAwareVisitor[Unit, IExpression] {
  import IExpression._
  import theory._

  def apply(f : IFormula) : IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(t : IExpression,
                ctxt : Context[Unit],
                subres : Seq[IExpression]) : IExpression = t match {

    case emptyStr @ IFunApp(this.theory.str_empty, _) => this.theory.strDatabase.str2Id(emptyStr)

    case consStr @ IFunApp(this.theory.str_cons, _) => this.theory.strDatabase.str2Id(consStr)

    case _ => t update subres
  }
}

