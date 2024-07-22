/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2023 Denghang Hu, Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ostrich.automata.{Regex2PFA, JavascriptPrioAutomatonBuilder,
                         AtomicStateAutomaton, BricsTransducer}
import ostrich.preop._

import ap.parser.ITerm
import ap.terfor.{Term, Formula, TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.{Atom, Predicate}
import ap.terfor.linearcombination.LinearCombination
import ap.basetypes.IdealInt
import ostrich.cesolver.preop.ConcatCEPreOp
import ostrich.cesolver.preop.SubStringCEPreOp
import ostrich.cesolver.preop.IndexOfCEPreOp
import ostrich.cesolver.preop.LengthCEPreOp
import ostrich.cesolver.preop.ReplaceCEPreOp
import ostrich.cesolver.preop.ReplaceAllCEPreOp
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.Internal2InputAbsy

/**
 * Class for mapping string constraints to string functions.
 */
class CEStringFunctionTranslator(theory : CEStringTheory,
                                      facts : Conjunction) {
  import theory.{FunPred, strDatabase, ceAutDatabase,
                 str_++, str_at, str_at_right, str_trim,
                 str_len, str_substr, str_indexof,
                 str_replaceall, str_replace,
                 str_replaceallre, str_replacere,
                 str_replaceallcg, str_replacecg, str_extract}

  private val regexExtractor = theory.RegexExtractor(facts.predConj)
  private val builder        = new JavascriptPrioAutomatonBuilder(theory)
  private val cgTranslator   = builder.regex2pfa

  private def regexAsTerm(t : Term) : Option[ITerm] =
    try {
      Some(regexExtractor regexAsTerm t)
    } catch {
      case _ : theory.IllegalRegexException => None
    }

  val translatablePredicates : Seq[Predicate] =
    (for (f <- List(str_++, str_replace, str_replaceall,
                    str_replacere, str_replaceallre,
                    str_at, str_at_right, str_trim) ++
               theory.extraFunctionPreOps.keys)
     yield FunPred(f)) ++ theory.transducerPreOps.keys

  def apply(a : Atom) : Option[(() => PreOp, Seq[Term], Term)] = a.pred match {

    case FunPred(`str_len`) =>
      Some((() => LengthCEPreOp(Internal2InputAbsy(a(1))), Seq(a(0)), a(1)))

    case FunPred(`str_++`) =>
      Some((() => ConcatCEPreOp, List(a(0), a(1)), a(2)))

    case FunPred(`str_substr`) =>
      Some((() => SubStringCEPreOp(Internal2InputAbsy(a(1)), Internal2InputAbsy(a(2))), Seq(a(0), a(1), a(2)), a(3)))

    case FunPred(`str_indexof`) if strDatabase isConcrete a(1) =>
      val matchStr = strDatabase term2ListGet a(1)
      Some((() => IndexOfCEPreOp(Internal2InputAbsy(a(2)), Internal2InputAbsy(a(3)), matchStr.map(_.toChar).mkString), Seq(a(0), a(1), a(2)), a(3)))

    case FunPred(`str_replace`) if (strDatabase isConcrete a(2)) && (strDatabase isConcrete a(1)) =>
      val matchStr = strDatabase term2ListGet a(2) map(_.toChar)
      val patternStr = strDatabase term2ListGet a(1) map(_.toChar)
      Some((() => ReplaceCEPreOp(patternStr, matchStr), Seq(a(0)), a(3)))

    case FunPred(`str_replacere`) if (strDatabase isConcrete a(2)) =>
      val matchStr = strDatabase term2ListGet a(2) map(_.toChar)
      for (regex <- regexAsTerm(a(1))) yield {
          val op = () => {
            val aut = ceAutDatabase.regex2Automaton(regex).asInstanceOf[CostEnrichedAutomatonBase]
            ReplaceCEPreOp(aut, matchStr)
          }
          (op, List(a(0)), a(3))
        }
    case FunPred(`str_replaceall`) if (strDatabase isConcrete a(2)) && (strDatabase isConcrete a(1)) =>
      val matchStr = strDatabase term2ListGet a(2) map(_.toChar)
      val patternStr = strDatabase term2ListGet a(1) map(_.toChar)
      Some((() => ReplaceAllCEPreOp(patternStr, matchStr), Seq(a(0)), a(3)))

    case FunPred(`str_replaceallre`) if (strDatabase isConcrete a(2)) =>
      val matchStr = strDatabase term2ListGet a(2) map(_.toChar)
      for (regex <- regexAsTerm(a(1))) yield {
          val op = () => {
            val aut = ceAutDatabase.regex2Automaton(regex).asInstanceOf[CostEnrichedAutomatonBase]
            ReplaceAllCEPreOp(aut, matchStr)
          }
          (op, List(a(0)), a(3))
        }


    case FunPred(`str_trim`) => {
      val op = () => {
        val LinearCombination.Constant(IdealInt(trimLeft))  = a(1)
        val LinearCombination.Constant(IdealInt(trimRight)) = a(2)
        // TODO: generate length information
        new TransducerPreOp(BricsTransducer.getTrimTransducer(trimLeft,
                                                              trimRight)) {
          override def toString = "str.trim[" + trimLeft + ", " + trimRight +"]"
          override def lengthApproximation(arguments : Seq[Term], result : Term,
                                           order : TermOrder) : Formula = {
            import TerForConvenience._
            implicit val _ = order
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
