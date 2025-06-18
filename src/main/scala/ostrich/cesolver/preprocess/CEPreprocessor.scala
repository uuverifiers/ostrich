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
import ap.basetypes.IdealInt
import ap.theories.bitvectors.ModuloArithmetic

class CEPreprocessor(theory: CEStringTheory)
    extends ContextAwareVisitor[Unit, IExpression] {
  import theory._

  object ConstChar {
    def unapply(t: IExpression): Option[IdealInt] = t match {
      case IFunApp(
            `str_cons`,
            Seq(
              IFunApp(
                ModuloArithmetic.mod_cast,
                Seq(IIntLit(_), IIntLit(_), Const(c))
              ),
              IFunApp(`str_empty`, Seq())
            )
          ) =>
        Some(c)
      case _ => None
    }
  }

  object IndexOfC0 {
    def unapply(t: IExpression): Option[(ITerm, ITerm)] = t match {
      case IFunApp(
            `str_indexof`,
            Seq(s, char @ ConstChar(_), Const(IdealInt(0)))
          ) =>
        Some((s, char))
      case _ => None
    }
  }

  object IndexOfC0Plus1 {
    def unapply(t: IExpression): Option[(ITerm, ITerm)] = t match {
      case IPlus(Const(IdealInt(1)), IndexOfC0(s, constChar)) =>
        Some((s, constChar))
      case IPlus(IndexOfC0(s, constChar), Const(IdealInt(1))) =>
        Some((s, constChar))
      case _ => None
    }
  }

  object Length {
    def unapply(t: ITerm): Option[ITerm] = t match {
      case IFunApp(`str_len`, Seq(s)) => Some(s)
      case _                          => None
    }
  }

  private val simplifier = new Simplifier

  private def reCat(ts: ITerm*): ITerm = ts match {
    case Seq() => re_eps()
    case ts    => ts reduceLeft (re_++(_, _))
  }

  

  

  def apply(f: IFormula): IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  private def equalIExps(exps: ITerm*): Boolean = {
    if (exps.length < 2) return true
    val firstTerm = exps.head
    exps.tail.forall(simplifier(_) == simplifier(firstTerm))
  }

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

      case (IFunApp(`str_at`, _), Seq(bigStr: ITerm, index: ITerm)) => {
        val simplifiedIdx = simplifier(index)
        simplifiedIdx match {
          // str_at(x, len(x) - 1)
          case Difference(IFunApp(`str_len`, Seq(bigStr2)), Const(IdealInt(1)))
              if equalIExps(bigStr, bigStr2) => {
            str_substr_lenMinus1_1(bigStr)
          }
          case _ => str_substr(bigStr, index, 1)
        }
      }
      case (
            IFunApp(`str_substr`, _),
            Seq(bigStr: ITerm, begin: ITerm, len: ITerm)
          ) => {
        val simplifiedBegin = simplifier(begin)
        val simplifiedLen = simplifier(len)
        (simplifiedBegin, simplifiedLen) match {
          // substr(x, 0, len(x) - 1)
          case (
                Const(IdealInt(0)),
                Difference(Length(s), Const(IdealInt(1)))
              ) if equalIExps(s, bigStr) => {
            str_substr_0_lenMinus1(bigStr)
          }
          // substr(x, n, len(x) - m)
          case (
            beginIdx@Const(_),
            Difference(Length(s), offset@Const(_))
          ) if equalIExps(s, bigStr) => {
            str_substr_n_lenMinusM(bigStr, beginIdx, offset)
          }
          // substr(x, 0, indexof_c(x,0))
          case (
                Const(IdealInt(0)),
                IndexOfC0(s, constChar)
              ) if equalIExps(s, bigStr) => {
            str_substr_0_indexofc0(bigStr, constChar)
          }
          // substr(x, 0, indexof_c(x,0) + 1)
          case (
                Const(IdealInt(0)),
                IndexOfC0Plus1(s, constChar)
              ) if equalIExps(s, bigStr) => {
            str_substr_0_indexofc0Plus1(bigStr, constChar)
          }
          // substr(x, indexof_c(x,0) + 1, len(x) - indexof_c(x,0) - 1)
          case (
                IndexOfC0Plus1(s, constChar),
                Difference(
                  Difference(Length(s2), IndexOfC0(s3, constChar2)),
                  Const(IdealInt(1))
                )
              )
              if equalIExps(s, s2, s3, bigStr) && equalIExps(
                constChar,
                constChar2
              ) => {
            str_substr_indexofc0Plus1_tail(bigStr, constChar)
          }
          case _ => t update subres
        }
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

      case (t, _) => // do nothing now
        t update subres
    }
  }
}
