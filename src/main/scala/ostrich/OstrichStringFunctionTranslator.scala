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

import ap.terfor.Term
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
                 str_++, str_at,
                 str_replaceall, str_replace,
                 str_replaceallre, str_replacere,
                 str_replaceallcg, str_replacecg, str_extract}

  private val regexExtractor = theory.RegexExtractor(facts.predConj)
  private val cgTranslator   = new Regex2PFA(theory, new JavascriptPFABuilder)

  val translatablePredicates : Seq[Predicate] =
    (for (f <- List(str_++, str_replace, str_replaceall,
                    str_replacere, str_replaceallre, str_at) ++
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
    case FunPred(`str_replaceallcg`) => {
      val op = () => {
        val pat = regexExtractor regexAsTerm a(1)
        val rep = regexExtractor regexAsTerm a(2)
        val (info, repStr) = cgTranslator.buildReplaceInfo(pat, rep)
        ReplaceAllCGPreOp(info, repStr)
      }
      Some((op, List(a(0)), a(3)))
    }
    case FunPred(`str_replacecg`) => {
      val op = () => {
        val pat = regexExtractor regexAsTerm a(1)
        val rep = regexExtractor regexAsTerm a(2)
        val (info, repStr) = cgTranslator.buildReplaceInfo(pat, rep)
        ReplaceCGPreOp(info, repStr)
      }
      Some((op, List(a(0)), a(3)))
    }
    case FunPred(`str_extract`) => {
      val op = () => {
        val index = a(0) match {
          case LinearCombination.Constant(IdealInt(v)) => v
          case _ => throw new IllegalArgumentException("Not an integer")
        }
        val regex = regexExtractor regexAsTerm a(2)
        val (newindex, info) = cgTranslator.buildExtractInfo(index, regex)
        ExtractPreOp(newindex, info)
      }
      Some((op, List(a(1)), a(3)))
    }
    case FunPred(`str_at`) => {
      val op = () => {
        val LinearCombination.Constant(IdealInt(ind)) = a(1)
        TransducerPreOp(BricsTransducer.getStrAtTransducer(ind))
      }
      Some((op, List(a(0)), a(2)))
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
