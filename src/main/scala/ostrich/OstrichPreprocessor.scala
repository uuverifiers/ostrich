/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2025 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import scala.collection.mutable.ArrayBuffer

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
        // it helps to keep the function application around, since it enforces
        // functional consistency of the results
        (str_indexof(shiftedBigStr, subStr, shiftedStartIndex) === resultVar) &
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

    // Encoding of (str.substr s i n):
    // Evaluates to the longest contiguous substring of s of length ≤ n starting at index i.
    // - If i or n is negative, or if i is out of bounds (i ≥ |s|), result is "".
    // - If i and n are valid and i + n ≤ |s|, result is substring of length n.
    // - If i and n are valid but i + n > |s|, result is suffix of s starting at i.
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
          (str_len(resultVar) <= lenVar | str_len(resultVar) <= 0) &
          ite(
            lenVar >= 0 & beginVar >= 0 & beginVar < str_len(bigStrVar),
            ite(
              beginVar + lenVar <= str_len(bigStrVar),
              /* full match */
              strCat(v(1, StringSort), resultVar, v(0, StringSort)) === bigStrVar &
                str_len(v(1, StringSort)) === beginVar &
                str_len(resultVar) === lenVar,
              /* truncated match */
              strCat(v(1, StringSort), resultVar) === bigStrVar &
                str_len(v(1, StringSort)) === beginVar
            ),
            /* default to "" if out of bounds or negative */
            resultVar === ""
          )
      ))))))
    }

    case (IFunApp(`str_at`, _),
          Seq(bigStr : ITerm, index : ITerm)) => {
      val shBigStr3 = VariableShiftVisitor(bigStr, 0, 3)
      val shIndex3  = VariableShiftVisitor(index, 0, 3)

      StringSort.eps(StringSort.ex(StringSort.ex(
        str_len(v(2, StringSort)) <= 1 &
        ite(
          shIndex3 < 0 | shIndex3 >= str_len(shBigStr3),
          v(2, StringSort) === "",
          strCat(v(1, StringSort), v(2, StringSort), v(0, StringSort)) === shBigStr3 &
          str_len(v(1, StringSort)) === shIndex3 &
          str_in_re(v(2, StringSort), re_allchar()) &
          str_len(v(2, StringSort)) === 1
        )
      )))
    }

    case (IFunApp(`str_++`, _), Seq(ConcreteString(""), t)) => t
    case (IFunApp(`str_++`, _), Seq(t, ConcreteString(""))) => t

    case (IFunApp(`str_++`, _),
          Seq(ConcreteString(str1), ConcreteString(str2))) =>
      string2Term(str1 + str2)

    case (IFunApp(`str_from_char`, _), Seq(c : ITerm)) =>
      str_cons(c, str_empty())

    case (IAtom(`str_<`, _), Seq(s : ITerm, t : ITerm)) =>
      str_<=(s, t) & (s =/= t)

    case (IFunApp(`str_to_code`, _), Seq(str : ITerm)) => {
      eps((v(0) === shiftVars(str_to_code(str), 1)) &
          (v(0) >= -1) & (v(0) < theory.alphabetSize))
    }

    case (IFunApp(`str_from_code`, _), Seq(Const(code))) =>
      if (code >= 0 & code < theory.alphabetSize)
        str_cons(code, str_empty())
      else
        str_empty()

    case (IFunApp(`str_from_code`, _), Seq(c : ITerm)) => {
      eps(ite(shiftVars(c, 1) >= 0 & shiftVars(c, 1) < theory.alphabetSize,
              shiftVars(c, 1) === str_to_code(v(0)),
              v(0) === str_empty()))
    }

    case (IFunApp(`re_range`, _),
          Seq(IFunApp(`str_cons`, Seq(lower, IFunApp(`str_empty`, _))),
              IFunApp(`str_cons`, Seq(upper, IFunApp(`str_empty`, _))))) =>
      re_charrange(lower, upper)

    case (IAtom(`str_is_digit`, _), Seq(str : ITerm)) =>
      str_in_re(str, re_charrange(0x0030, 0x0039))


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

/**
 * Factor out certain common sub-expressions, whose translation
 * to more basic string functions is complicated.
 */
class OstrichFactorizer(theory : OstrichStringTheory) {
  import IExpression._
  import theory._

  def apply(f : IFormula) : IFormula = {
    val parts =
    for (INamedPart(name, f) <- PartExtractor(f)) yield {
      val skeleton = SubExprAbbreviator(f, factor _).asInstanceOf[IFormula]
      val newF = quanConsts(Quantifier.ALL, newConsts.toSeq,
                           factoredExpressions ==> skeleton)
      clear()
      INamedPart(name, newF)
    }
    or(parts)
  }

  def clear() = {
    newConsts.clear()
    factoredExpressions = i(true)
  }

  private val newConsts = new ArrayBuffer[ConstantTerm]
  private var factoredExpressions : IFormula = i(true)

  private def factor(e : IExpression) : IExpression = e match {
    case e@IFunApp(`str_indexof` | `str_at` | `str_substr`, _)
              if ContainsSymbol.isClosed(e) => {
      val sort = Sort.sortOf(e)
      val c = sort.newConstant("X")
      newConsts += c
      factoredExpressions = factoredExpressions &&& (e === c)
      c
    }
    case e => e
  }

}
