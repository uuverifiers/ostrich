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

package ostrich.cesolver.stringtheory

import ostrich.automata.{
  Regex2PFA,
  JavascriptPrioAutomatonBuilder,
  BricsTransducer
}
import ostrich.preop._

import ap.parser.ITerm
import ap.terfor.{Term, Formula, TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.Atom
import ap.terfor.linearcombination.LinearCombination.Constant
import ap.basetypes.IdealInt
import ostrich.cesolver.preop._
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.Internal2InputAbsy
import ostrich.OstrichStringFunctionTranslator

/** Class for mapping string constraints to string functions.
  */
class CEStringFunctionTranslator(theory: CEStringTheory, facts: Conjunction)
    extends OstrichStringFunctionTranslator(theory, facts) {
  import theory._

  private val regexExtractor = theory.RegexExtractor(facts.predConj)
  new Regex2PFA(theory, new JavascriptPrioAutomatonBuilder)

  private def regexAsTerm(t: Term): Option[ITerm] =
    try {
      Some(regexExtractor regexAsTerm t)
    } catch {
      case _: theory.IllegalRegexException => None
    }

  override def apply(a: Atom): Option[(() => PreOp, Seq[Term], Term)] =
    a.pred match {

      case FunPred(`str_len`) =>
        Some((() => LengthCEPreOp(Internal2InputAbsy(a(1))), Seq(a(0)), a(1)))

      case FunPred(`str_++`) =>
        Some((() => ConcatCEPreOp, List(a(0), a(1)), a(2)))

      case FunPred(`str_substr`) =>
        Some(
          (
            () =>
              SubStringCEPreOp(
                Internal2InputAbsy(a(1)),
                Internal2InputAbsy(a(2))
              ),
            Seq(a(0), a(1), a(2)),
            a(3)
          )
        )

      // substring special cases ----------------------------------------------
      case FunPred(`str_substr_0_lenMinus1`) =>
        Some(
          (
            () => new SubStr_0_lenMinus1(),
            Seq(a(0)),
            a(1)
          )
        )
      case FunPred(`str_substr_n_lenMinusM`) =>
        val Constant(IdealInt(beginIdx)) = a(1)
        val Constant(IdealInt(offset)) = a(2)
        Some(
          (
            () => new SubStr_n_lenMinusM(beginIdx, offset),
            Seq(a(0)),
            a(3)
          )
        )

      case FunPred(`str_substr_lenMinus1_1`) =>
        Some(
          (
            () => new SubStr_lenMinus1_1(),
            Seq(a(0)),
            a(1)
          )
        )
      case FunPred(`str_substr_0_indexofc0`) if strDatabase isConcrete a(1) =>
        val matchStr = strDatabase term2ListGet a(1)
        assert(matchStr.length == 1)
        Some(
          (
            () => new SubStr_0_indexofc0(matchStr.head.toChar),
            Seq(a(0)),
            a(2)
          )
        )
      case FunPred(`str_substr_0_indexofc0Plus1`)
          if strDatabase isConcrete a(1) =>
        val matchStr = strDatabase term2ListGet a(1)
        assert(matchStr.length == 1)
        Some(
          (
            () => new SubStr_0_indexofc0Plus1(matchStr.head.toChar),
            Seq(a(0)),
            a(2)
          )
        )
      case FunPred(`str_substr_indexofc0Plus1_tail`)
          if strDatabase isConcrete a(1) =>
        val matchStr = strDatabase term2ListGet a(1)
        assert(matchStr.length == 1)
        Some(
          (
            () => new SubStr_indexofc0Plus1_tail(matchStr.head.toChar),
            Seq(a(0)),
            a(2)
          )
        )
      // substring special cases ----------------------------------------------

      case FunPred(`str_indexof`) if strDatabase isConcrete a(1) =>
        val matchStr = strDatabase term2ListGet a(1)
        Some(
          (
            () =>
              IndexOfCEPreOp(
                Internal2InputAbsy(a(2)),
                Internal2InputAbsy(a(3)),
                matchStr.map(_.toChar).mkString
              ),
            Seq(a(0), a(1), a(2)),
            a(3)
          )
        )

      case FunPred(`str_replace`)
          if (strDatabase isConcrete a(2)) && (strDatabase isConcrete a(1)) =>
        val matchStr = strDatabase term2ListGet a(2) map (_.toChar)
        val patternStr = strDatabase term2ListGet a(1) map (_.toChar)
        Some((() => ReplaceCEPreOp(patternStr, matchStr), Seq(a(0)), a(3)))

      case FunPred(`str_replacere`) if (strDatabase isConcrete a(2)) =>
        val matchStr = strDatabase term2ListGet a(2) map (_.toChar)
        for (regex <- regexAsTerm(a(1))) yield {
          val op = () => {
            val aut = ceAutDatabase
              .regex2Automaton(regex)
              .asInstanceOf[CostEnrichedAutomatonBase]
            ReplaceCEPreOp(aut, matchStr)
          }
          (op, List(a(0)), a(3))
        }
      case FunPred(`str_replaceall`)
          if (strDatabase isConcrete a(2)) && (strDatabase isConcrete a(1)) =>
        val matchStr = strDatabase term2ListGet a(2) map (_.toChar)
        val patternStr = strDatabase term2ListGet a(1) map (_.toChar)
        Some((() => ReplaceAllCEPreOp(patternStr, matchStr), Seq(a(0)), a(3)))

      case FunPred(`str_replaceallre`) if (strDatabase isConcrete a(2)) =>
        val matchStr = strDatabase term2ListGet a(2) map (_.toChar)
        for (regex <- regexAsTerm(a(1))) yield {
          val op = () => {
            val aut = ceAutDatabase
              .regex2Automaton(regex)
              .asInstanceOf[CostEnrichedAutomatonBase]
            ReplaceAllCEPreOp(aut, matchStr)
          }
          (op, List(a(0)), a(3))
        }

      case FunPred(`str_trim`) => {
        val op = () => {
          val Constant(IdealInt(trimLeft)) = a(1)
          val Constant(IdealInt(trimRight)) = a(2)
          // TODO: generate length information
          new TransducerPreOp(
            BricsTransducer.getTrimTransducer(trimLeft, trimRight)
          ) {
            override def toString =
              "str.trim[" + trimLeft + ", " + trimRight + "]"
            override def lengthApproximation(
                arguments: Seq[Term],
                result: Term,
                order: TermOrder
            ): Formula = {
              import TerForConvenience._
              implicit val o = order
              ((arguments(0) >= trimLeft + trimRight) &
                result === arguments(0) - (trimLeft + trimRight)) |
                ((arguments(0) < trimLeft + trimRight) &
                  result === 0)
            }
          }
        }
        Some((op, List(a(0)), a(3)))
      }

      case FunPred(f) if theory.extraFunctionPreOps contains f => {
        val (op, argSelector, resSelector) = theory.extraFunctionPreOps(f)
        Some((() => op, argSelector(a), resSelector(a)))
      }
      case pred if theory.transducerPreOps contains pred =>
        Some((() => theory.transducerPreOps(pred), List(a(0)), a(1)))
      case _ =>
        None
    }

}
