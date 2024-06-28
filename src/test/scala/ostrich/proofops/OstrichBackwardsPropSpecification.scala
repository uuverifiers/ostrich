/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Matthew Hague, Philipp Ruemmer. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from this software without specific prior written permission.
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

import ap.SimpleAPI
import ap.parameters.{GoalSettings, Param}
import ap.parser._
import ap.proof.goal.{AddFactsTask, Goal}
import ap.proof.theoryPlugins.Plugin.AddAxiom
import ap.proof.tree._
import ap.proof.{ConstraintSimplifier, Vocabulary}
import ap.util.Debug
import org.scalacheck.Properties
import ostrich.automata.{Automaton, BricsAutomaton}
import ostrich.{OFlags, OstrichStringTheory}

object OstrichBackwardsPropSpecification
  extends Properties("OstrichForwardsPropSpecification"){
  Debug.enableAllAssertions(true)

  val p = SimpleAPI.spawnWithAssertions
  import p._

  private val theory = new OstrichStringTheory (Seq(), OFlags())
  import IExpression._
  import theory._

  addTheory(theory)

  val x = createConstant("x", StringSort)
  val y = createConstant("y", StringSort)

  val autA: Automaton  = BricsAutomaton.fromString("a")
  val autB: Automaton  = BricsAutomaton.fromString("b")
  val autAorB: Automaton  = autA | autB

  val idAutA: Int = autDatabase.automaton2Id(autA)
  val idAutB: Int = autDatabase.automaton2Id(autB)
  val idAutAorB: Int = autDatabase.automaton2Id(autAorB)
  import ap.terfor.TerForConvenience._
  val formulaXinAorB = str_in_re_id(x, idAutAorB)
  val formulaYinAorB = str_in_re_id(y, idAutA)

  val concat = _str_++(x,x,y)
  val formulaYreplaceX = y === str_replaceall(x, "a", "d")

  val simplifier = ConstraintSimplifier.FAIR_SIMPLIFIER
  val settings
    = Param.CONSTRAINT_SIMPLIFIER.set(GoalSettings.DEFAULT, simplifier)
  val ptf = new SimpleProofTreeFactory(true, simplifier)

  def createGoalFor(f : IFormula) : Goal = {
    var goal = Goal(
      List(asConjunction(!f)),
      Set(),
      Vocabulary(p.order),
      settings
    )

    // run the rule applications to turn formulas into facts
    var cont = true
    while (cont && goal.stepPossible) {
      cont = goal.tasks.max match {
          case _ : AddFactsTask => true
          case _ => false
        }
      if (cont)
        goal = (goal step ptf).asInstanceOf[Goal]
    }

    goal
  }

  val goalSimpleReplace = createGoalFor(concat & formulaYinAorB)

  val fwdsPropSimpleReplace
    = new OstrichForwardsProp(goalSimpleReplace, theory, theory.theoryFlags)
  val fwdsResSimpleReplace = fwdsPropSimpleReplace.backwardsProp

  // should be fine to stop the prover again at this point
  p.shutDown
/*
  def seq(s : String) = s.map(_.toInt)

  property("Test Simple Replace") = {
    // get data from propagation result
    val axioms = fwdsResSimpleReplace.toList
    val (assumptions, conclusion) = axioms(0) match {
      case AddAxiom(assumptions, conclusion, _) => (assumptions, conclusion)
      case _ => throw new RuntimeException("Was expecting an AddAxiom action")
    }
    val newXConstraint = conclusion.predConj.positiveLits.head
    val iY = InputAbsy2Internal(y, p.order)
    val newAut
      = autDatabase.id2Automaton(newXConstraint(1).constant.intValue) match {
          case Some(aut) => aut
          case _ => throw new RuntimeException("Could not find aut in db")
        }

    // construct terms to check against result
    val iXinAorB = InputAbsy2Internal(formulaXinAorB, order)
    // @Philipp: what is the proper way to check
    // str_replaceall(x, 1, 2, y) is an assumption?
    // InputAbsy2Internal crashes with a MatchError for str_replaceall
    val pstr_replaceall
      = functionPredicateMapping.toMap.get(str_replaceall) match {
          case Some(p) => p
          case _ => str_replaceall.toPredicate
        }
    val iYreplaceX = InputAbsy2Internal(pstr_replaceall(
      x, strDatabase.str2Id("a"), strDatabase.str2Id("d"), y
    ), p.order)

    // finally, the property
    (
      axioms.size == 1
        // correct assumptions
        && assumptions.size == 2
        && assumptions.contains(iXinAorB)
        && assumptions.contains(iYreplaceX)
        // one correct conclusion
        && conclusion.size == 1
        && newXConstraint.pred == str_in_re_id
        && newXConstraint(0) == iY
        && !newAut(seq("a"))
        && newAut(seq("b"))
        && newAut(seq("d"))
        && !newAut(seq("aa"))
        && !newAut(seq("c"))
    )
  }*/
}
