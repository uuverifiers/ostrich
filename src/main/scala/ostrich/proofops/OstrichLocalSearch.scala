/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022 Oliver Markgraf, Philipp Ruemmer. All rights reserved.
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

package ostrich.proofops

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
import ap.terfor.{TerForConvenience, Term}
import ostrich._
import ostrich.automata.{AutomataUtils, Automaton, BricsAutomaton}

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.{HashMap => MHashMap}

class OstrichLocalSearch(goal : Goal,
                         theory : OstrichStringTheory,
                         flags : OFlags)  {
  import TerForConvenience._
  import theory.{FunPred, StringSort, _str_++, str_in_re, str_in_re_id, autDatabase, _str_len, int_to_str, strDatabase, str_prefixof, str_replace, str_suffixof, str_to_int}

  implicit val order = goal.order

  val facts        = goal.facts
  val predConj     = facts.predConj
  val concatLits   = predConj.positiveLitsWithPred(_str_++)
  val posRegularExpressions = predConj.positiveLitsWithPred(str_in_re_id)
  val negRegularExpressions = predConj.negativeLitsWithPred(str_in_re_id)
  val concatPerRes = concatLits groupBy (_(2))
  val lengthLits   = predConj.positiveLitsWithPred(_str_len)
  val lengthMap    = (for (a <- lengthLits.iterator) yield (a(0), a(1))).toMap
  private val equalityPropagator = new OstrichEqualityPropagator(theory)

  def resolveConcat(t : LinearCombination)
  : Option[(LinearCombination, LinearCombination)] =
    for (lits <- concatPerRes get t) yield (lits.head(0), lits.head(1))

  def explore : Seq[Plugin.Action] = {
    val model = new MHashMap[Term, Either[IdealInt, Seq[Int]]]

    val regexes    = new ArrayBuffer[(Term, Automaton)]

    def decodeRegexId(a : Atom, complemented : Boolean) : Unit = a(1) match {
      case LinearCombination.Constant(id) => {
        val autOption =
          if (complemented)
            autDatabase.id2ComplementedAutomaton(id.intValueSafe)
          else
            autDatabase.id2Automaton(id.intValueSafe)

        autOption match {
          case Some(aut) =>
            regexes += ((a.head, aut))
          case None =>
            throw new Exception ("Could not decode regex id " + a(1))
        }
      }
      case lc =>
        throw new Exception ("Could not decode regex id " + lc)
    }

    val regexExtractor =
      theory.RegexExtractor(goal)

    for (a <- posRegularExpressions) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, false)
    }
    for (a <- negRegularExpressions) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2ComplementedAutomaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, true)
    }
    for (regex <- regexes){
      val acceptedWord = regex._2.getAcceptedWord
      val isAccepted = regex._2.apply(acceptedWord.get)
      val product = AutomataUtils.product(Seq(regex._2))
      val concat = AutomataUtils.concat(regex._2.asInstanceOf[BricsAutomaton], regex._2.asInstanceOf[BricsAutomaton])
      model.put(regex._1, Right(acceptedWord.get))
    }
    for (concat <- concatPerRes){
      println(concat)
    }


    val foundSolution = false
    if (foundSolution){
      equalityPropagator.handleSolution(goal, model.toMap)
    }
    else{
      Seq()
    }
  }

}
