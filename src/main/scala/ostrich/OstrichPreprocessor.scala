/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2021 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

/*
    case (IAtom(`str_prefixof`, _),
          Seq(subStr : ITerm, bigStr : ITerm)) if ctxt.polarity < 0 => {
      val s = VariableShiftVisitor(subStr, 0, 1)
      val t = VariableShiftVisitor(bigStr, 0, 1)
      StringSort.ex(str_++(s, v(0, StringSort)) === t)
    }
 */

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
          Seq(bigStr : ITerm,
              Const(begin),
              Difference(IFunApp(`str_len`, Seq(bigStr2)), Const(end))))
        if bigStr == bigStr2 && begin.signum >= 0 && end >= begin =>
      str_trim(bigStr, begin, end - begin)

      // TODO: need proper condition for length
/*
    case (IFunApp(`str_substr`, _),
          Seq(bigStr : ITerm,
              begin : ITerm,
              Difference(IFunApp(`str_len`, Seq(bigStr2)), end : ITerm)))
        if bigStr == bigStr2 =>
      ite(begin >= 0,
          str_trim(bigStr, begin, end - begin),
          "")
 */

    case (IFunApp(`str_substr`, _),
          Seq(bigStr : ITerm, begin : ITerm, len : ITerm)) => {
      val shBigStr3 = VariableShiftVisitor(bigStr, 0, 3)
      val shBegin3  = VariableShiftVisitor(begin, 0, 3)
      val shLen3    = VariableShiftVisitor(len, 0, 3)

      StringSort.eps(StringSort.ex(StringSort.ex(
        ite(
          shLen3 < 0 | shBegin3 < 0 | shBegin3 + shLen3 > str_len(shBigStr3),
          v(2, StringSort) === "",
          strCat(v(1, StringSort), v(2, StringSort), v(0, StringSort)) === shBigStr3 &
          str_len(v(1, StringSort)) === shBegin3 &
          str_len(v(2, StringSort)) === shLen3
        )
      )))
    }

    // keep str.at with concrete index, we will later translate it
    // to a transducer
    case (IFunApp(`str_at`, _), Seq(bigStr : ITerm, Const(_))) =>
      t update subres

    // keep str.at_last with concrete index, we will later translate it
    // to a transducer
    case (IFunApp(`str_at`, _),
          Seq(bigStr : ITerm,
              Difference(IFunApp(`str_len`, Seq(bigStr2)), Const(offset))))
        if bigStr == bigStr2 && offset >= 1 =>
      str_at_right(bigStr, offset - 1)

    case (IFunApp(`str_at`, _),
          Seq(bigStr : ITerm, index : ITerm)) => {
      val shBigStr3 = VariableShiftVisitor(bigStr, 0, 3)
      val shIndex3  = VariableShiftVisitor(index, 0, 3)

      StringSort.eps(StringSort.ex(StringSort.ex(
        ite(
          shIndex3 < 0 | shIndex3 >= str_len(shBigStr3),
          v(2, StringSort) === "",
          strCat(v(1, StringSort), v(2, StringSort), v(0, StringSort)) === shBigStr3 &
          str_len(v(1, StringSort)) === shIndex3 &
          str_in_re(v(2, StringSort), re_allchar())
        )
      )))
    }

    case (IFunApp(`str_++`, _), Seq(ConcreteString(""), t)) => t
    case (IFunApp(`str_++`, _), Seq(t, ConcreteString(""))) => t

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

    case (IFunApp(`str_from_char`, _), Seq(c : ITerm)) =>
      str_cons(c, str_empty())


/*
    // Currently we just under-approximate and assume that the considered
    // string is "0"
    case (IFunApp(`str_to_int`, _), Seq(str : ITerm)) => {
      Console.err.println(
        "Warning: str.to.int not fully supported")
      eps(shiftVars(str, 1) === string2Term("0") &&& v(0) === 0)
    }

    // Currently we just under-approximate and assume that the considered
    // integer is 0
    case (IFunApp(`int_to_str`, _), Seq(t : ITerm)) => {
      Console.err.println(
        "Warning: int.to.str not fully supported")
      eps(shiftVars(t, 1) === 0 &&& v(0) === string2Term("0"))
    }
*/

    case (IFunApp(`re_range`, _),
          Seq(IFunApp(`str_cons`, Seq(lower, IFunApp(`str_empty`, _))),
              IFunApp(`str_cons`, Seq(upper, IFunApp(`str_empty`, _))))) =>
      re_charrange(lower, upper)

    case (t, _) =>
      // TODO: generalise
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
      Console.err.println(
        "Warning: could not encode regular expression right away," +
          " post-poning: " + regex)
      t update subres
    }
    case _ =>
      t update subres
  }

}

/**
 * Stores constant string to strDatabase for easy access.
 */
class OstrichStringEncoder(theory : OstrichStringTheory)
  extends ContextAwareVisitor[Unit, IExpression] {
  import IExpression._
  import theory._

  def apply(f : IFormula) : IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(t : IExpression,
                ctxt : Context[Unit],
                subres : Seq[IExpression]) : IExpression =
    (t update subres) match {

      case emptyStr @ IFunApp(this.theory.str_empty, _) =>
        this.theory.strDatabase.iTerm2Id(emptyStr)

      case consStr @ IFunApp(this.theory.str_cons, _) =>
        this.theory.strDatabase.iTerm2Id(consStr)

      case t => t
    }
}

