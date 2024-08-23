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
import ap.theories.TheoryRegistry
import ap.types.SortedPredicate
import ap.parameters.Param
import ap.util.{Tarjan, Seqs}

import LinearCombination.SingleTerm

import ostrich._
import ostrich.automata.{
  AtomicStateAutomaton, AutomataUtils, BricsAutomaton, LengthBoundedAutomaton
}

import scala.collection.mutable.{HashSet => MHashSet}

/**
 * Class to pick concrete values of string variables. This proof rule
 * is currently only applied when everything else has finished.
 */
class OstrichCut(val theory : OstrichStringTheory)
      extends PropagationSaturationUtils {

  import theory._

  def handleGoal(goal : Goal, cutEverything : Boolean) : Seq[Plugin.Action] = {
    val stringVariables =
      if (cutEverything) findAllStringVars(goal) else findCutVars(goal)

    if (stringVariables.nonEmpty) {
      val rand = Param.RANDOM_DATA_SOURCE(goal.settings)
      cutForVar(goal, rand.pick(stringVariables))
    } else {
      List()
    }
  }

  private def findAllStringVars(goal : Goal) : IndexedSeq[ConstantTerm] = {
    val predConj = goal.facts.predConj
    val allAtoms = predConj.positiveLits ++ predConj.negativeLits

    (for (a <- allAtoms.iterator;
          sorts = SortedPredicate argumentSorts a;
          (LinearCombination.SingleTerm(c : ConstantTerm), StringSort) <-
            a.iterator zip sorts.iterator)
     yield c).toVector.distinct
  }

  /**
   * Find cut variables by building the dependency graph induced by
   * string function applications and computing its strongly connected
   * components. There are three cases in which we need to introduce
   * cuts for the possible values of string variable <code>x</code>:
   * <code>x</code> occurs in an SCC together with other string variables;
   * <code>x</code> occurs as the result variable of multiple function
   * applications; or there are other formulas (not belonging to the theory
   * of strings) that refer to <code>x</code>. We return the set of all
   * string variables that such variables <code>x</code> depend on.
   */
  private def findCutVars(goal : Goal) : IndexedSeq[ConstantTerm] = {
    val predConj = goal.facts.predConj
    val allAtoms = predConj.positiveLits ++ predConj.negativeLits

    val funApps = getFunApps(goal)
    val stringVars =
      (for ((_, args, res, _) <- funApps;
            Some(SingleTerm(c : ConstantTerm)) <- args ++ List(Some(res)))
       yield c).toIndexedSeq.distinct

    // build the dependency graph

    def containsArg(t : FunAppTuple, c : ConstantTerm) =
      t._2.exists {
        case Some(SingleTerm(`c`)) => true
        case _ => false
      }

    type GraphNode = Either[ConstantTerm, FunAppTuple]
    val depGraph = new Tarjan.Graph[GraphNode] {
      val nodes =
        stringVars.map(Left(_)) ++ funApps.map(Right(_))
      def successors(n : GraphNode) =
        n match {
          case Left(c) =>
            for (t <- funApps.iterator; if containsArg(t, c)) yield Right(t)
          case Right((_, _, SingleTerm(c : ConstantTerm), _)) =>
            Iterator(Left(c))
          case _ =>
            Iterator()
        }
    }

    // compute strongly connected components

    val sccs = Tarjan(depGraph)

    println(sccs)

    // string variables that occur as the result of multiple function
    // applications

    val multiplyAssignedVars =
      (for ((SingleTerm(c : ConstantTerm), apps) <- funApps.groupBy(_._3);
            if apps.size > 1)
       yield c).toSet

    // compute string variables that are used by non-theory atoms

    val nonTheoryAtoms =
      allAtoms filterNot {
        a => TheoryRegistry.lookupSymbol(a.pred) match {
          case Some(`theory`) => true
          case _ => false
        }
      }

    val nonTheoryAtomVars =
      (for (a <- nonTheoryAtoms; c <- a.constants) yield c).toSet

    // compute all string variables to be considered in cuts
    
    val cutNodes = new MHashSet[GraphNode]

    for (scc <- sccs.reverse) {
      val sccVars =
        for (Left(c) <- scc) yield c
      if (sccVars.size > 1 ||
          !Seqs.disjointSeq(nonTheoryAtomVars, sccVars) ||
          !Seqs.disjointSeq(multiplyAssignedVars, sccVars) ||
          scc.exists(n => depGraph.successors(n) exists cutNodes))
        cutNodes ++= scc
    }

    println(cutNodes)

    val cutVars = for (Left(c) <- cutNodes.toSeq) yield c
    goal.order.sort(cutVars).toVector
  }

  /**
   * Perform a cut for one specific string variable: split the proof into
   * the cases <code>x = w</code> and <code>x != w</code>, for some string
   * <code>w</code> in the domain of <code>x</code>.
   */
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

    val acceptedWord =
      AutomataUtils.findAcceptedWord(auts, lowerLenBound, upperLenBound)

    if (acceptedWord.isDefined) {
      val acceptedWordId =
        strDatabase.list2Id(acceptedWord.get)

      val negAutomaton =
        !BricsAutomaton.fromString(strDatabase.id2Str(acceptedWordId))
      val negAutomatonId =
        autDatabase.automaton2Id(negAutomaton)

      if (OFlags.debug) {
        val str = strDatabase.id2Str(acceptedWordId)
        Console.err.println(
          f"Performing cut: $stringVar == ${"\""}${str}${"\""} (length ${str.size})")
      }

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
