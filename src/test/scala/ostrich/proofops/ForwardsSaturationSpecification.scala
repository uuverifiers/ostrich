/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Oliver Markgraf, Matthew Hague, Philipp Ruemmer.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
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

import ap.parameters.{GoalSettings, Param}
import ap.parser._
import ap.proof.goal.{AddFactsTask, Goal}
import ap.proof.theoryPlugins.Plugin
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

object ForwardsSaturationSpecification
  extends Properties("ForwardsSaturationSpecification")
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
  val formulaXchar = str_len(x) === 1

  val fwdsSat = new ForwardsSaturation(theory)

  val (
    appPointsSimpleReplace,
    prioritiesSimpleReplace,
    appliedSimpleReplace
  ) = getSaturationDataFor(fwdsSat, formulaXinAorB & formulaYreplaceX)

  val (
    appPointsReplaceTwoXCons,
    prioritiesReplaceTwoXCons,
    appliedReplaceTwoXCons
  ) = getSaturationDataFor(
    fwdsSat,
    formulaXinABThenCstar & formulaXinABCstar & formulaYreplaceX
  )

  val (
    appPointsTwoFuns,
    prioritiesTwoFuns,
    appliedTwoFuns
  ) = getSaturationDataFor(
    fwdsSat,
    formulaXinABThenCstar & formulaXinABCstar
      & formulaYreplaceX & formulaZreplaceX
  )

  val (
    appPointsStrLen,
    prioritiesStrLen,
    appliedStrLen
  ) = getSaturationDataFor(fwdsSat, formulaYreplaceX & formulaXchar)

  // should be fine to stop the prover again at this point
  shutdown

  val iXinAorB = makeInternal(formulaXinAorB)
  val iXinABCstar = makeInternal(formulaXinABCstar)
  val iXinABThenCstar = makeInternal(formulaXinABThenCstar)
  val iYreplaceX = makeReplaceAll(x, "a", "d", y)
  val iZreplaceX = makeReplaceAll(x, "b", "c", z)

  property("Test Simple Replace App Points") = {
    appPointsSimpleReplace == List((iYreplaceX, List(List(iXinAorB), List())))
  }
/*
  property("Test Simple Replace Priorities") = {
    prioritiesSimpleReplace == List(3)
  }*/

  /* TODO: bad matching
  property("Test Simple Replace Applied") = {
    println("Starting test: Test Simple Replace Applied")

    val result = appliedSimpleReplace.exists { item =>
      println(s"Checking item: $item")
      item match {
        case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _)) =>
          println(s"Matched case with assumptions: $assumptions and newConstraint: $newConstraint")
          val assumptionsSet = assumptions.toSet
          val correctRegex = isCorrectRegex(newConstraint, y, List("b", "d"), List("a", "aa", "c"))

          println(s"assumptionsSet: $assumptionsSet")
          println(s"Expected assumptions: ${Set(iXinAorB, iYreplaceX)}")
          println(s"isCorrectRegex result: $correctRegex")

          if (assumptionsSet == Set(iXinAorB, iYreplaceX) && correctRegex) {
            println("Item matches the expected conditions")
            true
          } else {
            println("Item does not match the expected conditions")
            false
          }
        case _ =>
          println("Item did not match the expected pattern")
          false
      }
    }

    println(s"Test result: $result")
    result
  }*/


  property("Test Two X Constraints App Points") = {
    equalAppPoints(
      appPointsReplaceTwoXCons,
      List(
        (iYreplaceX, List(List(iXinABThenCstar), List())),
        (iYreplaceX, List(List(iXinABCstar), List())),
        (iYreplaceX, List(List(iXinABCstar, iXinABThenCstar), List()))
      )
    )
  }
/*
  property("Test Two X Constraints Priorities") = {
    prioritiesReplaceTwoXCons.toSet == Set(1, 3, 4)
  }*/

  /* TODO bad matching
  property("Test Two X Constraints Applied") = {
    appliedReplaceTwoXCons.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABCstar, iYreplaceX) &&
           isCorrectRegex(
             newConstraint, y,
             List("db", "dbcccc"), List("ab", "abccc", "da")
           ) => true
      case _ =>
        false
    }) && appliedReplaceTwoXCons.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABThenCstar, iYreplaceX) &&
           isCorrectRegex(
             newConstraint, y,
             List("db", "dbcccc"), List("ab", "abccc", "dd")
           ) => true
      case _ =>
        false
    }) && appliedReplaceTwoXCons.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABThenCstar, iYreplaceX, iXinABCstar) &&
           isCorrectRegex(
             newConstraint, y,
             List("db", "dbcccc"), List("ab", "abccc", "dd")
           ) => true
      case _ =>
        false
    })
  }*/

  property("Test Two Fun Apps App Points") = {
    appPointsTwoFuns.toSet == Set(
      (iYreplaceX, List(List(iXinABCstar), List())),
      (iYreplaceX, List(List(iXinABThenCstar), List())),
      (iYreplaceX, List(List(iXinABCstar, iXinABThenCstar), List())),
      (iZreplaceX, List(List(iXinABCstar), List())),
      (iZreplaceX, List(List(iXinABThenCstar), List())),
      (iZreplaceX, List(List(iXinABCstar, iXinABThenCstar), List()))
    )
  }
/*
  property("Test Two Fun Apps Priorities") = {
    prioritiesTwoFuns.toSet == Set(1, 3, 4)
  }*/

  /* TODO bad matching
  property("Test Two Fun Apps") = {
    appliedTwoFuns.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABCstar, iYreplaceX) &&
           isCorrectRegex(
             newConstraint, y,
             List("db", "dbcccc"), List("ab", "abccc", "da")
           ) => true
      case _ =>
        false
    }) && appliedTwoFuns.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABThenCstar, iYreplaceX) &&
           isCorrectRegex(
             newConstraint, y,
             List("db", "dbcccc"), List("ab", "abccc", "dd")
           ) => true
      case _ =>
        false
    }) && appliedTwoFuns.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABCstar, iXinABThenCstar, iYreplaceX) &&
           isCorrectRegex(
             newConstraint, y,
             List("db", "dbcccc"), List("ab", "abccc", "dd")
           ) => true
      case _ =>
        false
    }) && appliedTwoFuns.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABCstar, iZreplaceX) &&
           isCorrectRegex(
             newConstraint, z,
             List("ac", "accccc"), List("ab", "abccc", "bc")
           ) => true
      case _ =>
        false
    }) && appliedTwoFuns.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABThenCstar, iZreplaceX) &&
           isCorrectRegex(
             newConstraint, z,
             List("ac", "accccc", "acc"), List("ab", "abccc", "cb")
           ) => true
      case _ =>
        false
    }) && appliedTwoFuns.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iXinABCstar, iXinABThenCstar, iZreplaceX) &&
           isCorrectRegex(
             newConstraint, z,
             List("ac", "accccc", "acc"), List("ab", "abccc", "cb")
           ) => true
      case _ =>
        false
    })
  }*/

  property("Test Str Len App Points") = {
    // the str_len(x) === 1 doesn't get translated to anything
    // propagatable at the moment
    appPointsStrLen == List((iYreplaceX, List(List(), List())))
  }
/*
  property("Test Simple Replace Priorities") = {
    prioritiesStrLen == List(0)
  }*/
/* TODO bad matching
  property("Test Simple Replace Applied") = {
    // only asserts no "a" in y since it's been replaced and str_len(x)
    // === 1 was thrown away
    appliedStrLen.exists(_ match {
      case Seq(AddAxiom(assumptions, SingleAtom(newConstraint), _))
        if assumptions.toSet == Set(iYreplaceX) &&
           isCorrectRegex(newConstraint, y,
                          List("c", "d", "ed"), List("a", "ca", "dea")) => true
      case _ =>
        false
    })
  }*/

  private def equalAppPoints(
    points1 : Seq[fwdsSat.ApplicationPoint],
    points2 : Seq[(Formula, Seq[Seq[TerFor]])]
  ) : Boolean = {
    points1.map({ case (a, cons) =>
      (a, cons.map(_.toSet))
    }).toSet == points2.map({ case (a, cons) =>
      (a, cons.map(_.toSet))
    }).toSet
  }
}
