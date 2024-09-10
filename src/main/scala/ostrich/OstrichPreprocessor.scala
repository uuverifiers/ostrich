/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2023 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

    case (IAtom(`str_prefixof`, _), Seq(x,y)) if (x == y) => {
        IBoolLit(true)
    }

    case (IAtom(`str_suffixof`, _), Seq(x,y)) if (x == y) => {
      IBoolLit(true)
    }

    case (IAtom(`str_contains`, _), Seq(x,y)) if (x == y) => {
      IBoolLit(true)
    }

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
          Seq(bigStr : ITerm,
              subStr@ConcreteString(subStrStr),
              startIndex : ITerm)) => {
      // we need one epsilon and 5 quantifiers, so shift by 6
      val shift = 6

      val shiftedBigStr      = VariableShiftVisitor(bigStr, 0, shift)
      val shiftedStartIndex  = VariableShiftVisitor(startIndex, 0, shift)

      val resultVar          = v(5)
      val bigStrVar          = v(0, StringSort)
      val skippedPrefixVar   = v(3, StringSort)
      val matchedSuffixVar   = v(4, StringSort)
      val unmatchedPrefixVar = v(1, StringSort)
      val unmatchedSuffixVar = v(2, StringSort)

      val (bigStrSuffix, suffixDef1, suffixDef2, suffixDef3) =
        startIndex match {
          case Const(IdealInt.ZERO) =>
            (bigStrVar,
             bigStrVar === shiftedBigStr,
             IBoolLit(false),
             IBoolLit(true))
          case _ => {
            (matchedSuffixVar,
             (bigStrVar === shiftedBigStr) &
               (strCat(skippedPrefixVar, matchedSuffixVar) === bigStrVar),
             (shiftedStartIndex < 0) | (shiftedStartIndex > str_len(bigStrVar)),
             str_len(skippedPrefixVar) === shiftedStartIndex)
          }
        }

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
        if (subStrStr.isEmpty)
          reCat(re_allchar(), re_all())
        else
          reUnion(List(containingStr) ++ forbiddenSuffixREs : _*)

      eps(StringSort.ex(StringSort.ex(StringSort.ex(StringSort.ex(StringSort.ex(
        suffixDef1 &
         ((resultVar === -1 &
            suffixDef3 &
            !str_in_re(bigStrSuffix, containingStr)) |
          (resultVar === -1 &
             suffixDef2) |
          (suffixDef3 &
             resultVar === str_len(unmatchedPrefixVar) + shiftedStartIndex &
             strCat(unmatchedPrefixVar, subStr,
                    unmatchedSuffixVar) === bigStrSuffix &
             !str_in_re(unmatchedPrefixVar, containingOrSuffix)))
      ))))))
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

/*
    Some attempts to rewrite substr to replace; needs more thinking

    case (IFunApp(`str_substr`, _),
          Seq(bigStr : ITerm,
              Const(IdealInt.ZERO),
              IFunApp(`str_indexof`,
                      Seq(bigStr2,
                          ConcreteString(searchStr),
                          Const(IdealInt.ZERO)))))
        if bigStr == bigStr2 =>
      ite(str_in_re(bigStr, reCat(re_all(), str_to_re(searchStr), re_all())),
          str_replacere(bigStr, reCat(str_to_re(searchStr), re_all()), ""),
          "")

    case (IFunApp(`str_substr`, _),
          Seq(bigStr : ITerm,
              Const(IdealInt.ZERO),
              Difference(IFunApp(`str_indexof`,
                                 Seq(bigStr2,
                                     ConcreteString(searchStr),
                                     Const(IdealInt.ZERO))),
                         Const(IdealInt(offset)))))
        if bigStr == bigStr2 && (-offset) >= 1 && (-offset) <= searchStr.size =>
      // TODO
      ite(str_in_re(bigStr, reCat(re_all(), str_to_re(searchStr), re_all())),
          str_replacere(bigStr,
                        reCat(str_to_re(searchStr), re_all()),
                        searchStr take (-offset)),
          "")

    case (IFunApp(`str_substr`, _),
          Seq(bigStr : ITerm,
              start@Difference(IFunApp(`str_indexof`,
                                       Seq(bigStr2,
                                           ConcreteString(searchStr),
                                           Const(IdealInt.ZERO))),
                               Const(IdealInt.MINUS_ONE)),
              Difference(IFunApp(`str_len`, Seq(bigStr3)), start2)))
        if bigStr == bigStr2 && bigStr == bigStr3 && searchStr.size == 1 &&
           start == start2 =>
      str_replacere(bigStr,
                    reCat(re_*(re_comp(str_to_re(searchStr))),
                          str_to_re(searchStr)),
                    "")
*/

    case (IFunApp(`str_substr`, _),
          Seq(bigStr : ITerm, begin : ITerm, len : ITerm)) => {
      // we need one epsilon and 5 quantifiers, so shift by 6
      val shift = 6

      val shiftedBigStr = VariableShiftVisitor(bigStr, 0, shift)
      val shiftedBegin  = VariableShiftVisitor(begin, 0, shift)
      val shiftedLen    = VariableShiftVisitor(len, 0, shift)

      val resultVar     = v(5, StringSort)
      val bigStrVar     = v(2, StringSort)
      val beginVar      = v(3)
      val lenVar        = v(4)

      StringSort.eps(ex(ex(StringSort.ex(StringSort.ex(StringSort.ex(
        bigStrVar === shiftedBigStr &
        beginVar  === shiftedBegin &
        lenVar    === shiftedLen &
	ite(
	  lenVar >= 0 & beginVar >= 0 & beginVar + lenVar <= str_len(bigStrVar),
          strCat(v(1, StringSort), resultVar, v(0, StringSort)) === bigStrVar &
          str_len(v(1, StringSort)) === beginVar & str_len(resultVar) === lenVar,
	  ite(
	    lenVar >= 0 & beginVar >= 0,
	    strCat(v(1, StringSort), resultVar) === bigStrVar &
            str_len(v(1, StringSort)) === beginVar,
	    resultVar === ""
	  )
	)
/*
        ite(
          lenVar < 0 | beginVar < 0 | beginVar >= str_len(bigStrVar),
          resultVar === "",
          strCat(v(1, StringSort), resultVar, v(0, StringSort)) === bigStrVar &
          str_len(v(1, StringSort)) === beginVar &
          (str_len(resultVar) === lenVar |
           (str_len(resultVar) < lenVar & v(0, StringSort) === ""))
        )
*/
      ))))))
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

    case (IAtom(`str_<`, _), Seq(s : ITerm, t : ITerm)) =>
      str_<=(s, t) & (s =/= t)

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


/*
//TODO: how to control the translation from length constraints to regexes, and vice versa?

    case (t, _) =>
      // TODO: generalise
      (t update subres) match {
        case Geq(Const(bound), IFunApp(`str_len`, Seq(w))) if bound < 0 =>
          false
        case Geq(Const(bound), IFunApp(`str_len`, Seq(w))) if bound <= 1000 =>
          // encode an upper bound using a regular expression
          str_in_re(w, re_loop(0, bound, re_allchar()))
        case Geq(IFunApp(`str_len`, Seq(w)), Const(bound)) if bound <= 1000 =>
          // encode a lower bound using a regular expression
          str_in_re(w, re_++(re_loop(bound, bound, re_allchar()), re_all()))
        case Eq(IFunApp(`str_len`, Seq(w)), Const(bound)) if bound < 0 =>
          false
        case Eq(Const(bound), IFunApp(`str_len`, Seq(w))) if bound < 0 =>
          false
        case Eq(IFunApp(`str_len`, Seq(w)), Const(bound)) if bound <= 1000 =>
          // encode length constraint using regular expression
          str_in_re(w, re_loop(bound, bound, re_allchar()))
        case Eq(Const(bound), IFunApp(`str_len`, Seq(w))) if bound <= 1000 =>
          // encode length constraint using regular expression
          str_in_re(w, re_loop(bound, bound, re_allchar()))
        case newT =>
          newT
      }
 */

    case (t, _) => t update subres
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

