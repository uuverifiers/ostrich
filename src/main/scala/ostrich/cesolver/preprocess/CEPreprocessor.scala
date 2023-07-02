/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu, Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.cesolver.preprocess

import ap.parser._
import IExpression._
import ap.theories.strings.StringTheory.ConcreteString
import ostrich.cesolver.stringtheory.CEStringTheory
import ostrich.cesolver.util.ParikhUtil

class CEPreprocessor(theory: CEStringTheory)
    extends ContextAwareVisitor[Unit, IExpression] {
  import theory._

  private def reCat(ts: ITerm*): ITerm = ts match {
    case Seq() => re_eps()
    case ts    => ts reduceLeft (re_++(_, _))
  }

  private def reUnion(ts: ITerm*): ITerm = ts match {
    case Seq() => re_none()
    case ts    => ts reduceLeft (re_union(_, _))
  }

  private def strCat(ts: ITerm*): ITerm = ts match {
    case Seq() => str_empty()
    case ts    => ts reduceLeft (str_++(_, _))
  }

  def apply(f: IFormula): IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(
      t: IExpression,
      ctxt: Context[Unit],
      subres: Seq[IExpression]
  ): IExpression = {
    (t, subres) match {
      case (
            IAtom(`str_contains`, _),
            Seq(bigStr: ITerm, subStr @ ConcreteString(_))
          ) => {
        val asRE = reCat(re_all(), str_to_re(subStr), re_all())
        str_in_re(bigStr, asRE)
      }

      case (
            IAtom(`str_prefixof`, _),
            Seq(subStr @ ConcreteString(_), bigStr: ITerm)
          ) => {
        val asRE = re_++(str_to_re(subStr), re_all())
        str_in_re(bigStr, asRE)
      }
      case (IAtom(`str_suffixof`, _), Seq(x, y)) if (x == y) => {
        IBoolLit(true)
      }
      case (IAtom(`str_contains`, _), Seq(x, y)) if (x == y) => {
        IBoolLit(true)
      }
      case (
            IAtom(`str_suffixof`, _),
            Seq(subStr @ ConcreteString(_), bigStr: ITerm)
          ) => {
        val asRE = re_++(re_all(), str_to_re(subStr))
        str_in_re(bigStr, asRE)
      }
      case (IAtom(`str_suffixof`, _), Seq(subStr: ITerm, bigStr: ITerm))
          if ctxt.polarity < 0 => {
        val s = VariableShiftVisitor(subStr, 0, 1)
        val t = VariableShiftVisitor(bigStr, 0, 1)
        StringSort.ex(str_++(v(0, StringSort), s) === t)
      }

      case (
            IFunApp(`str_at`, _),
            Seq(
              bigStr: ITerm,
              index@Difference(IFunApp(`str_len`, Seq(bigStr2)), Const(offset))
            )
          ) if bigStr == bigStr2 && offset >= 1 =>
        ParikhUtil.todo("optimise str_at_right")
        str_substr(bigStr, index, 1)
      // str_at_right(bigStr, offset - 1)

      case (IFunApp(`str_at`, _), Seq(bigStr: ITerm, index: ITerm)) => {
        str_substr(bigStr, index, 1)
      }
      case (IFunApp(`str_++`, _), Seq(ConcreteString(""), t)) => t
      case (IFunApp(`str_++`, _), Seq(t, ConcreteString(""))) => t

      case (
            IFunApp(`str_++`, _),
            Seq(ConcreteString(str1), ConcreteString(str2))
          ) =>
        string2Term(str1 + str2)

      case (IFunApp(`str_from_code`, _), Seq(Const(code))) =>
        if (code >= 0 & code < theory.alphabetSize)
          str_cons(code, str_empty())
        else
          str_empty()

      case (IFunApp(`str_from_code`, _), Seq(code: ITerm)) =>
        ite(
          code >= 0 & code < theory.alphabetSize,
          str_cons(code, str_empty()),
          str_empty()
        )

      case (IFunApp(`str_from_char`, _), Seq(c: ITerm)) =>
        str_cons(c, str_empty())

      case (
            IFunApp(`re_range`, _),
            Seq(
              IFunApp(`str_cons`, Seq(lower, IFunApp(`str_empty`, _))),
              IFunApp(`str_cons`, Seq(upper, IFunApp(`str_empty`, _)))
            )
          ) =>
        re_charrange(lower, upper)

      case _ => // do nothing now
        t update subres
    }
  }
}
