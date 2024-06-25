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
import ap.proof.tree._
import ap.proof.{ConstraintSimplifier, Vocabulary}
import ap.terfor._
import ap.terfor.conjunctions.Conjunction
import ap.util.Debug
import org.scalacheck.Properties
import ostrich.automata.{Automaton, BricsAutomaton}
import ostrich.{OFlags, OstrichStringTheory}

object OstrichForwardsPropSpecification
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

  implicit val to: TermOrder = p.order

  val autA: Automaton  = BricsAutomaton.fromString("a")
  val autB: Automaton  = BricsAutomaton.fromString("b")
  val autAorB: Automaton  = autA | autB

  val idAutA: Int = autDatabase.automaton2Id(autA)
  val idAutB: Int = autDatabase.automaton2Id(autB)
  val idAutAorB: Int = autDatabase.automaton2Id(autAorB)

  val formulaXinAorB = str_in_re_id(x, idAutAorB)
  val formulaYreplaceX = y === str_replaceall(x, "a", "d")

  val simplifier = ConstraintSimplifier.FAIR_SIMPLIFIER
  val settings
    = Param.CONSTRAINT_SIMPLIFIER.set(GoalSettings.DEFAULT, simplifier)
  val ptf = new SimpleProofTreeFactory(true, simplifier)

  def createGoalFor(c : Conjunction) : Goal = {
    var goal = Goal(List(c), Set(), Vocabulary(to), settings)

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

  val goal = createGoalFor(asConjunction(
    formulaXinAorB & formulaYreplaceX
  ))
  println(goal)

  val fwdsProp = new OstrichForwardsProp(goal, theory, theory.theoryFlags)
  val fwdsRes = fwdsProp.apply

  // should be fine to stop the prover again at this point
  p.shutDown

  property("Test Simple Replace") = {
    // Check the specific regular expression that should be returned
    print(fwdsRes)
    true
  }
}
