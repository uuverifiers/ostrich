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
import ap.proof.theoryPlugins.Plugin.Action
import ap.proof.theoryPlugins.Plugin.AddAxiom
import ap.proof.tree._
import ap.proof.{ConstraintSimplifier, Vocabulary}
import ap.terfor._
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
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
  val z = createConstant("z", StringSort)

  val autA: Automaton  = BricsAutomaton.fromString("a")
  val autB: Automaton  = BricsAutomaton.fromString("b")
  val autAorB: Automaton  = autA | autB
  val autABCstar: Automaton  = BricsAutomaton("(a|b|c)*")
  val autABThenCstar: Automaton  = BricsAutomaton("abc*")

  val idAutA: Int = autDatabase.automaton2Id(autA)
  val idAutB: Int = autDatabase.automaton2Id(autB)
  val idAutAorB: Int = autDatabase.automaton2Id(autAorB)
  val idAutABCstar: Int = autDatabase.automaton2Id(autABCstar)
  val idAutABThenCstar: Int = autDatabase.automaton2Id(autABThenCstar)

  val formulaXinAorB = str_in_re_id(x, idAutAorB)
  val formulaXinABCstar = str_in_re_id(x, idAutABCstar)
  val formulaXinABThenCstar = str_in_re_id(x, idAutABThenCstar)
  val formulaYreplaceX = y === str_replaceall(x, "a", "d")
  val formulaZreplaceX = z === str_replaceall(x, "b", "c")

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

  val goalSimpleReplace = createGoalFor(formulaXinAorB & formulaYreplaceX)
  val fwdsPropSimpleReplace
    = new OstrichForwardsProp(goalSimpleReplace, theory, theory.theoryFlags)
  val fwdsResSimpleReplace = fwdsPropSimpleReplace.apply

  val goalReplaceTwoXCons = createGoalFor(
    formulaXinABThenCstar & formulaXinABCstar & formulaYreplaceX
  )
  val fwdsPropReplaceTwoCons
    = new OstrichForwardsProp(goalReplaceTwoXCons, theory, theory.theoryFlags)
  val fwdsResReplaceTwoCons = fwdsPropReplaceTwoCons.apply

  val goalTwoFuns = createGoalFor(
    formulaXinABThenCstar & formulaXinABCstar
      & formulaYreplaceX & formulaZreplaceX
  )
  val fwdsPropTwoFuns
    = new OstrichForwardsProp(goalTwoFuns, theory, theory.theoryFlags)
  val fwdsResTwoFuns = fwdsPropTwoFuns.apply

  // should be fine to stop the prover again at this point
  p.shutDown

  // @Philipp: what is the proper way to check
  // str_replaceall(x, 1, 2, y) is an assumption?
  // InputAbsy2Internal crashes with a MatchError for str_replaceall
  val pstr_replaceall
    = functionPredicateMapping.toMap.get(str_replaceall) match {
        case Some(p) => p
        case _ => str_replaceall.toPredicate
      }

  val iXinAorB = makeInternal(formulaXinAorB)
  val iXinABCstar = makeInternal(formulaXinABCstar)
  val iXinABThenCstar = makeInternal(formulaXinABThenCstar)
  val iYreplaceX = makeReplaceAll(x, "a", "d", y)
  val iZreplaceX = makeReplaceAll(x, "b", "c", z)
  val iY = makeInternal(y)
  val iZ = makeInternal(z)

  property("Test Simple Replace") = {
    val axioms = fwdsResSimpleReplace.toList
    val (assumptions, conclusion) = getAssumptionsConclusion(axioms(0))
    val newYConstraint = conclusion.predConj.positiveLits.head
    val newYAut = getAutomatonFromIntFormula(newYConstraint(1))

    (
      axioms.size == 1
        // correct assumptions
        && assumptions.size == 2
        && assumptions.contains(iXinAorB)
        && assumptions.contains(iYreplaceX)
        // one correct conclusion
        && conclusion.size == 1
        && newYConstraint.pred == str_in_re_id
        && newYConstraint(0) == iY
        && !newYAut(seq("a"))
        && newYAut(seq("b"))
        && newYAut(seq("d"))
        && !newYAut(seq("aa"))
        && !newYAut(seq("c"))
    )
  }

  property("Test Two X Constraints") = {
    val axioms = fwdsResReplaceTwoCons.toList
    val (assumptions, conclusion) = getAssumptionsConclusion(axioms(0))
    val newYConstraint = conclusion.predConj.positiveLits.head
    val newYAut = getAutomatonFromIntFormula(newYConstraint(1))

    (
      axioms.size == 1
        // correct assumptions
        && assumptions.size == 3
        && assumptions.contains(iXinABCstar)
        && assumptions.contains(iXinABThenCstar)
        && assumptions.contains(iYreplaceX)
        // one correct conclusion
        && conclusion.size == 1
        && newYConstraint.pred == str_in_re_id
        && newYConstraint(0) == iY
        && newYAut(seq("db"))
        && newYAut(seq("dbcccc"))
        && !newYAut(seq("ab"))
        && !newYAut(seq("abccc"))
        && !newYAut(seq("dd"))
    )
  }

  property("Test Two Fun Apps") = {
    val axioms = fwdsResTwoFuns.toList
    val (assumptionsY, conclusionY) = getAssumptionsConclusion(axioms(0))
    val (assumptionsZ, conclusionZ) = getAssumptionsConclusion(axioms(1))
    val newYConstraint = conclusionY.predConj.positiveLits.head
    val newYAut = getAutomatonFromIntFormula(newYConstraint(1))
    val newZConstraint = conclusionZ.predConj.positiveLits.head
    val newZAut = getAutomatonFromIntFormula(newZConstraint(1))

    print(newZAut)

    (
      axioms.size == 2
        // correct assumptions for y var
        && assumptionsY.size == 3
        && assumptionsY.contains(iXinABCstar)
        && assumptionsY.contains(iXinABThenCstar)
        && assumptionsY.contains(iYreplaceX)
        // one correct conclusion for y var
        && conclusionY.size == 1
        && newYConstraint.pred == str_in_re_id
        && newYConstraint(0) == iY
        && newYAut(seq("db"))
        && newYAut(seq("dbcccc"))
        && !newYAut(seq("ab"))
        && !newYAut(seq("abccc"))
        && !newYAut(seq("dd"))
        // correct assumptions for z var
        && assumptionsZ.size == 3
        && assumptionsZ.contains(iXinABCstar)
        && assumptionsZ.contains(iXinABThenCstar)
        && assumptionsZ.contains(iZreplaceX)
        // one correct conclusion for z var
        && conclusionZ.size == 1
        && newZConstraint.pred == str_in_re_id
        && newZConstraint(0) == iZ
        && newZAut(seq("ac"))
        && newZAut(seq("accccc"))
        && !newZAut(seq("ab"))
        && !newZAut(seq("abccc"))
        && !newZAut(seq("cc"))
    )
  }

  def seq(s : String) = s.map(_.toInt)

  def makeInternal(f : IExpression) = InputAbsy2Internal(f, p.order)

  def makeReplaceAll(
    inVar : ITerm,
    replaceString : String,
    newString : String,
    outVar : ITerm
  ) : Formula  = InputAbsy2Internal(
    pstr_replaceall(
      inVar,
      strDatabase.str2Id(replaceString),
      strDatabase.str2Id(newString),
      outVar
    ),
    p.order
  )

  def getAssumptionsConclusion(action : Action) = action match {
    case AddAxiom(assumptions, conclusion, _) => (assumptions, conclusion)
    case _ => throw new RuntimeException("Was expecting an AddAxiom action")
  }

  def getAutomatonFromIntFormula(i : LinearCombination)
      = autDatabase.id2Automaton(i.constant.intValue) match {
          case Some(aut) => aut
          case _ => throw new RuntimeException("Could not find aut in db")
        }
}
