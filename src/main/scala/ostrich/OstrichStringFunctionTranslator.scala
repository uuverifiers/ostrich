/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2021 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ap.terfor.{Term, Formula, TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.{Atom, Predicate}
import ap.terfor.linearcombination.LinearCombination
import ap.basetypes.IdealInt

/**
 * Class for mapping string constraints to string functions.
 */
class OstrichStringFunctionTranslator(theory : OstrichStringTheory,
                                      facts : Conjunction) {
  import theory.{FunPred, strDatabase, autDatabase,
                 str_++, str_at, str_at_right, str_trim,
                 str_replaceall, str_replace,
                 str_replaceallre, str_replacere}

  private val regexExtractor = theory.RegexExtractor(facts.predConj)

  val translatablePredicates : Seq[Predicate] =
    (for (f <- List(str_++, str_replace, str_replaceall,
                    str_replacere, str_replaceallre,
                    str_at, str_at_right, str_trim) ++
               theory.extraFunctionPreOps.keys)
     yield FunPred(f)) ++ theory.transducerPreOps.keys
  
  def apply(a : Atom) : Option[(() => PreOp, Seq[Term], Term)] = a.pred match {
    case FunPred(`str_++`) =>
      Some((() => ConcatPreOp, List(a(0), a(1)), a(2)))
    case FunPred(`str_replaceall`) => {
      val op = () => {
        val b = strDatabase term2ListGet a(1)
        ReplaceAllPreOp(b map (_.toChar))
      }
      Some((op, List(a(0), a(2)), a(3)))
    }
    case FunPred(`str_replace`) => {
      val op = () => {
        val b = strDatabase term2ListGet a(1)
        ReplacePreOp(b map (_.toChar))
      }
      Some((op, List(a(0), a(2)), a(3)))
    }
    case FunPred(`str_replaceallre`) => {
      val op = () => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex).asInstanceOf[AtomicStateAutomaton]
        ReplaceAllPreOp(aut)
      }
      Some((op, List(a(0), a(2)), a(3)))
    }
    case FunPred(`str_replacere`) => {
      val op = () => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex).asInstanceOf[AtomicStateAutomaton]
        ReplacePreOp(aut)
      }
      Some((op, List(a(0), a(2)), a(3)))
    }

    case FunPred(`str_at`) => {
      val op = () => {
        val LinearCombination.Constant(IdealInt(ind)) = a(1)
        // TODO: generate length information
        new TransducerPreOp(BricsTransducer.getStrAtTransducer(ind)) {
          override def toString = "str.at[" + ind + "]"
          override def lengthApproximation(arguments : Seq[Term], result : Term,
                                           order : TermOrder) : Formula = {
            import TerForConvenience._
            implicit val o = order
            result >= 0 & result <= 1 &
            ((arguments(0)) <= ind <=> (result === 0))
          }
        }
      }
      Some((op, List(a(0)), a(2)))
    }

    case FunPred(`str_at_right`) => {
      val op = () => {
        val LinearCombination.Constant(IdealInt(ind)) = a(1)
        // TODO: generate length information
        new TransducerPreOp(BricsTransducer.getStrAtRightTransducer(ind)) {
          override def toString = "str.at-right[" + ind + "]"
          override def lengthApproximation(arguments : Seq[Term], result : Term,
                                           order : TermOrder) : Formula = {
            import TerForConvenience._
            implicit val o = order
            result >= 0 & result <= 1 &
            ((arguments(0)) <= ind <=> (result === 0))
          }
        }
      }
      Some((op, List(a(0)), a(2)))
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
