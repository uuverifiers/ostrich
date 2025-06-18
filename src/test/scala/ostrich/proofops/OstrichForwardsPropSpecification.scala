/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Oliver Markgraf, Matthew Hague, Philipp Ruemmer. All rights reserved.
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
import ap.util.Debug
import org.scalacheck.Properties
import ostrich.automata.{Automaton, BricsAutomaton}
import ostrich.{OFlags, OstrichStringTheory}

object OstrichForwardsPropSpecification
  extends Properties("OstrichForwardsPropSpecification")
          with TestProverUtils {

  import prover._
  import IExpression._
  import theory._

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
  shutdown

  val iXinAorB = makeInternal(formulaXinAorB)
  val iXinABCstar = makeInternal(formulaXinABCstar)
  val iXinABThenCstar = makeInternal(formulaXinABThenCstar)
  val iYreplaceX = makeReplaceAll(x, "a", "d", y)
  val iZreplaceX = makeReplaceAll(x, "b", "c", z)

  property("Test Simple Replace") = {
    fwdsResSimpleReplace match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinAorB, iYreplaceX) &&
           isCorrectRegex(newConstraint, y,
                          List("b", "d"), List("a", "aa", "c")) => true
      case _ =>
        false
    }
  }

  property("Test Two X Constraints") = {
    fwdsResReplaceTwoCons match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABCstar, iXinABThenCstar, iYreplaceX) &&
           isCorrectRegex(newConstraint, y,
                          List("db", "dbcccc"), List("ab", "abccc", "dd")) => true
      case _ =>
        false
    }
  }

  property("Test Two Fun Apps") = {
    fwdsResTwoFuns match {
      case Seq(AddAxiom(assumptionsY, SingleAtom(newYConstraint), _),
               AddAxiom(assumptionsZ, SingleAtom(newZConstraint), _))
        if assumptionsY.toSet == Set(iXinABCstar, iXinABThenCstar, iYreplaceX) &&
           assumptionsZ.toSet == Set(iXinABCstar, iXinABThenCstar, iZreplaceX) &&
           isCorrectRegex(newYConstraint, y,
                          List("db", "dbcccc"), List("ab", "abccc", "dd")) &&
           isCorrectRegex(newZConstraint, z,
                          List("ac", "accccc"), List("ab", "abccc", "cc")) => true
      case _ =>
        false
    }
  }

}
