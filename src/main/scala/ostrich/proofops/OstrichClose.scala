/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Oliver Markgraf, Philipp Ruemmer. All rights reserved.
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

import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.{Atom, PredConj}
import ap.terfor.{Term, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ostrich._
import ostrich.automata.AutDatabase.{ComplementedAut, NamedAutomaton, PositiveAut}

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.{HashMap => MHashMap}

class OstrichClose(goal : Goal,
                         theory : OstrichStringTheory,
                         flags : OFlags)  {
  import theory.{str_in_re, str_in_re_id, autDatabase}

  implicit val order: TermOrder = goal.order


  val facts: Conjunction = goal.facts
  val predConj: PredConj = facts.predConj
  private val posRegularExpressions = predConj.positiveLitsWithPred(str_in_re_id)
  private val negRegularExpressions = predConj.negativeLitsWithPred(str_in_re_id)

  def isConsistent : Seq[Plugin.Action] = {

    val regexes    = new MHashMap[Term, ArrayBuffer[NamedAutomaton]]

    def decodeRegexId(a : Atom, complemented : Boolean) : Unit = a(1) match {
      case LinearCombination.Constant(id) => {
        val autOption =
          if (complemented)
            autDatabase.id2ComplementedAutomaton(id.intValueSafe)
          else
            autDatabase.id2Automaton(id.intValueSafe)

        autOption match {
          case Some(aut) => {
            if (regexes.contains(a.head)){
              if (complemented){
                regexes(a.head) += ComplementedAut(id.intValueSafe)
              }
              else {
                regexes(a.head) += PositiveAut(id.intValueSafe)
              }
            }
            else {
              if (complemented){
                regexes(a.head) = ArrayBuffer(ComplementedAut(id.intValueSafe))

              }
              else {
                regexes(a.head) = ArrayBuffer(PositiveAut(id.intValueSafe))
              }
            }

          }
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
        val id = autDatabase.automaton2Id(aut)
        if (regexes.contains(a.head)){
          regexes(a.head) += PositiveAut(id)
        }
        else {
          regexes(a.head) = ArrayBuffer(PositiveAut(id))
        }
      }
      case `str_in_re_id` =>
        decodeRegexId(a, complemented = false)
    }
    for (a <- negRegularExpressions) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2ComplementedAutomaton(regex)
        val id = autDatabase.automaton2Id(aut)

        if (regexes.contains(a.head)){
          regexes(a.head) += ComplementedAut(id)
        }
        else {
          regexes(a.head) = ArrayBuffer(ComplementedAut(id))
        }
      }
      case `str_in_re_id` =>
        decodeRegexId(a, complemented = true)
    }

    for ((term, autSequence) <- regexes) {
      for (i <- autSequence.indices){
        for (j <- i+1 until autSequence.length){
          if (autDatabase.emptyIntersection(autSequence(i),autSequence(j))){
            // TODO return only the constraints that lead to the close
            return Seq(Plugin.CloseByAxiom(goal.facts.iterator.toList, theory))
          }
        }
      }
    }
    Seq()
  }
}