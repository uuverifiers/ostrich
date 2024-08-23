/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Philipp Ruemmer. All rights reserved.
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
import ap.terfor.TerForConvenience
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.{Atom, PredConj}
import ap.terfor.{Term, TermOrder, ConstantTerm}
import ap.terfor.conjunctions.Conjunction
import ap.types.SortedPredicate

import ostrich._
import ostrich.automata.{
  AtomicStateAutomaton, AutomataUtils, BricsAutomaton, LengthBoundedAutomaton
}

/**
 * Class to pick concrete values of string variables. This proof rule
 * is currently only applied when everything else has finished.
 */
class OstrichCut(theory : OstrichStringTheory) {

  import theory._

  def handleGoal(goal : Goal) : Seq[Plugin.Action] = {
    val predConj = goal.facts.predConj
    val allAtoms = predConj.positiveLits ++ predConj.negativeLits

    // TODO: is it better to sort function application, start with
    // picking values from the leaves?

    // TODO: we probably do not need cuts for all string variables.

    val stringVariables =
      for (a <- allAtoms.iterator;
           sorts = SortedPredicate argumentSorts a;
           (LinearCombination.SingleTerm(c : ConstantTerm), StringSort) <-
             a.iterator zip sorts.iterator)
      yield c

    if (stringVariables.hasNext) {
      cutForVar(goal, stringVariables.next())
    } else {
      List()
    }
  }

  private def cutForVar(goal : Goal,
                        stringVar : ConstantTerm) : Seq[Plugin.Action] = {
    import TerForConvenience._
    implicit val order = goal.order
    val predConj = goal.facts.predConj

    // TODO: assumes only one len constraint per term?
    val strLenMap =
      predConj.positiveLitsWithPred(_str_len).map(a => (a(0), a(1))).toMap

    val stringVarLC = l(stringVar)

    val regexes =
      for (a <- predConj.positiveLitsWithPred(str_in_re_id);
           if a.head == stringVarLC)
      yield a.last

    val auts =
      for (LinearCombination.Constant(IdealInt(id)) <- regexes)
      yield autDatabase.id2Automaton(id).get

    // also take length constraints into account
    val reducer = goal.reduceWithFacts
    val lowerLenBound = strLenMap
      .get(stringVar)
      .map(reducer.lowerBound)
      .flatten
      .map(_.intValue)
    val upperLenBound = strLenMap
      .get(stringVar)
      .map(reducer.upperBound)
      .flatten
      .map(_.intValue)
println(auts)
    val acceptedWord =
      AutomataUtils.findAcceptedWord(auts, lowerLenBound, upperLenBound)

    if (acceptedWord.isDefined) {
      val acceptedWordId =
        strDatabase.list2Id(acceptedWord.get)

      val negAutomaton =
        !BricsAutomaton.fromString(strDatabase.id2Str(acceptedWordId))
      val negAutomatonId =
        autDatabase.automaton2Id(negAutomaton)

      if (OFlags.debug)
        Console.err.println(
          f"Performing cut: $stringVar == ${"\""}${strDatabase.id2Str(acceptedWordId)}${"\""}")

      List(Plugin.AxiomSplit(
            List(),
            List((stringVar === acceptedWordId, List()),
                 (str_in_re_id(List(stringVarLC, l(negAutomatonId))), List())),
            theory))
    } else {
      if (OFlags.debug)
        Console.err.println("OstrichCut closed a proof goal")

      val rcons =
        predConj.positiveLitsWithPred(str_in_re_id)
          .filter(_.head == stringVarLC)
          .toSeq
      // TODO: this will not catch all relevant assumptions:
      // the lowerBound/upperBound functions might rely on further formulas
      val lcons =
        predConj.positiveLitsWithPred(_str_len)
          .filter(_(0) == stringVar)
          .toSeq
      List(Plugin.CloseByAxiom(rcons ++ lcons, theory))
    }
  }

}
