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
import ap.proof.theoryPlugins.Plugin.AxiomSplit
import ap.proof.tree._
import ap.proof.{ConstraintSimplifier, Vocabulary}
import ap.terfor._
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.util.Debug
import org.scalacheck.Properties
import ostrich.automata.{Automaton, BricsAutomaton}
import ostrich.{OFlags, OstrichStringTheory}

object BackwardsSaturationSpecification
  extends Properties("BackwardsSaturationSpecification")
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
  val autABstar: Automaton  = BricsAutomaton("(a|b)*")
  val autABThenCstar: Automaton  = BricsAutomaton("abc*")

  val idAutA: Int = autDatabase.automaton2Id(autA)
  val idAutB: Int = autDatabase.automaton2Id(autB)
  val idAutAorB: Int = autDatabase.automaton2Id(autAorB)
  val idAutABCstar: Int = autDatabase.automaton2Id(autABCstar)
  val idAutABstar: Int = autDatabase.automaton2Id(autABstar)
  val idAutABThenCstar: Int = autDatabase.automaton2Id(autABThenCstar)

  val formulaYinAorB = str_in_re_id(y, idAutAorB)
  val formulaYinABCstar = str_in_re_id(y, idAutABCstar)
  val formulaYinABThenCstar = str_in_re_id(y, idAutABThenCstar)
  val formulaZinAorB = str_in_re_id(z, idAutAorB)
  val formulaZinABstar = str_in_re_id(z, idAutABstar)
  val formulaYreplaceX = y === str_replaceall(x, "a", "d")
  val formulaZreplaceX = z === str_replaceall(x, "b", "c")
  val formulaZreplaceXY = z === str_replaceall(x, "a", y)

  val bwdsSat = new BackwardsSaturation(theory)
  val (
    appPointsSimpleReplace,
    prioritiesSimpleReplace,
    appliedSimpleReplace
  ) = getSaturationDataFor(bwdsSat, formulaYinAorB & formulaYreplaceX)

  val (
    appPointsReplaceTwoYCons,
    prioritiesReplaceTwoYCons,
    appliedReplaceTwoYCons
  ) = getSaturationDataFor(
    bwdsSat,
    formulaYinABThenCstar & formulaYinABCstar & formulaYreplaceX
  )

  val (
    appPointsTwoFuns,
    prioritiesTwoFuns,
    appliedTwoFuns
  ) = getSaturationDataFor(
    bwdsSat,
    formulaYinABThenCstar & formulaYinABCstar & formulaZinABstar
      & formulaYreplaceX & formulaZreplaceX
  )

  // z = replace(x, "a", y) and z in a|b should split cases
  // x in a|b and y in a|b
  // x in b and y in .*
  val (
    appPointsSplit,
    prioritiesSplit,
    appliedSplit
  ) = getSaturationDataFor(bwdsSat, formulaZreplaceXY & formulaZinAorB)

  // should be fine to stop the prover again at this point
  shutdown

  val iYinAorB = makeInternal(formulaYinAorB)
  val iYinABCstar = makeInternal(formulaYinABCstar)
  val iYinABThenCstar = makeInternal(formulaYinABThenCstar)
  val iZinAorB = makeInternal(formulaZinAorB)
  val iZinABstar = makeInternal(formulaZinABstar)
  val iYreplaceX = makeReplaceAll(x, "a", "d", y)
  val iZreplaceX = makeReplaceAll(x, "b", "c", z)
  val iZreplaceXY = makeReplaceAll(x, "a", y, z)

  property("Test Simple Replace App Points") = {
    appPointsSimpleReplace == List((iYreplaceX, Some(iYinAorB)))
  }

  property("Test Simple Replace Priorities") = {
    // TODO: check
    prioritiesSimpleReplace == List(3)
  }

  property("Test Simple Replace Applied") = {
    appliedSimpleReplace.exists(_ match {
      case Seq(AxiomSplit(assumptions, cases, _))
        if {
          val correctAssumptions = assumptions.toSet == Set(iYinAorB, iYreplaceX)
          val correctCases = isSplitCases(cases.map(_._1).toSeq, Seq(Seq(
            (strDatabase.str2Id("d"), List("a", "bc", "xyz"), List()),
              (x, List("b"), List("a", "d", "bb"))

          )))
          correctAssumptions && correctCases
        } => true
      case _ => {
        false
      }
    })
  }


  property("Test Two Y Constraints App Points") = {
    appPointsReplaceTwoYCons.toSet == Set(
      (iYreplaceX, Some(iYinABThenCstar)),
      (iYreplaceX, Some(iYinABCstar))
    )
  }

  property("Test Two Y Constraints Priorities") = {
    // TODO: check
    prioritiesReplaceTwoYCons.toSet == Set(1, 3)
  }

  property("Test Two Y Constraints Applied") = {
    appliedReplaceTwoYCons.size == 2 && appliedReplaceTwoYCons.forall(_ match {
      case Seq(AxiomSplit(assumptions, cases, _))
        if assumptions.toSet == Set(iYinABThenCstar, iYreplaceX)
          && isSplitCases(
            cases.map(_._1).toSeq,
            Seq(Seq(
              // should not accept anything
              (x, List(), List("a", "ab", "abc", "c", "b")),
              // d in Sigma*..
              (strDatabase.str2Id("d"), List("a", "bc", "xyz"), List())
            ))
          ) => true
      case Seq(AxiomSplit(
        assumptions, cases, _
      ))
        if assumptions.toSet == Set(iYinABCstar, iYreplaceX)
          && isSplitCases(
            cases.map(_._1).toSeq,
            Seq(Seq(
              // should be (b|c)*
              (x, List("c", "b", "cb", "bcbb"), List("a", "ab", "bac")),
              // d in Sigma*..
              (strDatabase.str2Id("d"), List("a", "bc", "xyz"), List())
            ))
          ) => true
      case _ =>
        false
    })
  }

  property("Test Two Fun Apps App Points") = {
    appPointsTwoFuns.toSet == Set(
      (iYreplaceX, Some(iYinABCstar)),
      (iYreplaceX, Some(iYinABThenCstar)),
      (iZreplaceX, Some(iZinABstar))
    )
  }

  property("Test Two Fun Apps Priorities") = {
    // TODO: verify
    prioritiesTwoFuns.toSet == Set(1, 3)
  }

  property("Test Two Fun Apps") = {
    appliedTwoFuns.size == 3 && appliedTwoFuns.forall(_ match {
      case Seq(AxiomSplit(assumptions, cases, _))
        if assumptions.toSet == Set(iYinABThenCstar, iYreplaceX)
          && isSplitCases(
            cases.map(_._1).toSeq,
            Seq(Seq(
              // should not accept anything
              (x, List(), List("a", "ab", "abc", "c", "b")),
              // d in Sigma*..
              (strDatabase.str2Id("d"), List("a", "bc", "xyz"), List())
            ))
          ) => true
      case Seq(AxiomSplit(
        assumptions, cases, _
      ))
        if assumptions.toSet == Set(iYinABCstar, iYreplaceX)
          && isSplitCases(
            cases.map(_._1).toSeq,
            Seq(Seq(
              // should be (b|c)*
              (x, List("c", "b", "cb", "bcbb"), List("a", "ab", "bac")),
              // d in Sigma*..
              (strDatabase.str2Id("d"), List("a", "bc", "xyz"), List())
            ))
          ) => true
      case Seq(AxiomSplit(
        assumptions, cases, _
      ))
        if assumptions.toSet == Set(iZinABstar, iZreplaceX)
          && isSplitCases(
            cases.map(_._1).toSeq,
            Seq(Seq(
              // should be a*
              (x, List("a", "", "aaaa"), List("b", "ab", "bac", "c")),
              // c in Sigma*..
              (strDatabase.str2Id("c"), List("a", "bc", "xyz"), List())
            ))
          ) => true
      case _ =>
        false
    })
  }

  property("Test Split App Points") = {
    appPointsSplit.toSet == Set((iZreplaceXY, Some(iZinAorB)))
  }

  property("Test Split Priorities") = {
    // TODO: verify
    prioritiesSplit.toSet == Set(3)
  }

  property("Test Split Apps") = {
    appliedSplit.size == 1 && appliedSplit.forall(_ match {
      case Seq(AxiomSplit(assumptions, cases, _))
        if assumptions.toSet == Set(iZinAorB, iZreplaceXY)
          && isSplitCases(
            cases.map(_._1).toSeq,
            // x in a*ba* and y in empty
            // x in b and y in .*
            // x in a|b and y in a
            // x in a|b and y in b
            Seq(
              Seq(
                (x, List("aba", "baa", "abaa"), List("bb", "abc", "c")),
                (y, List(""), List("a", "ab", "abc", "c", "ba", "b"))
              ),
              Seq(
                (x, List("b"), List("", "a", "ab", "ba")),
                (y, List("a", "", "b", "bc", "abc"), List())
              ),
              Seq(
                (x, List("a", "b"), List("", "ab", "abc", "c", "ba")),
                (y, List("a"), List("", "ab", "abc", "c", "ba", "b"))
              ),
              Seq(
                (x, List("a", "b"), List("", "ab", "abc", "c", "ba")),
                (y, List("b"), List("", "ab", "abc", "c", "ba", "a"))
              )
            )
          ) => true
      case _ =>
        false
    })
  }

  /**
   * Test cases of  AxiomSplit are as expected
   *
   * Each conjunction in cases should pass at least one test in tests.
   * Careful, several conjunctions may end pass the same test.
   *
   * @param cases the conjunction for each case
   * @param Sequence of conjunction tests, where a conjunction test is a
   * sequence of tuples as passed to isConjunctionOf
   */
  private def isSplitCases(
                            cases: Seq[Conjunction],
                            tests: Seq[Seq[(ITerm, Seq[String], Seq[String])]]
                          ): Boolean = {
    cases.zipWithIndex.forall { case (conj, index) =>
      val result = tests.exists(test => isConjunctionOf(conj, test))
      result
    }
  }



  /**
   * Tests the conjunction asserts each of the tests
   *
   * Tests are passed to isCorrectRegex
   *
   * @param cases the conjunction for each case
   * @param tests tuple of (term, positiveEgs, negativeEgs) for each
   * str_in_re_id constraint that the conjunction should enforce. See
   * isCorrectRegex.
   */
  private def isConjunctionOf(
                               conj: Conjunction,
                               tests: Seq[(ITerm, Seq[String], Seq[String])]
                             ): Boolean = {

    tests.forall { case (term, pos, neg) =>
      val result = (conj.groundAtoms).exists { atom =>
        val regexResult = isCorrectRegex(atom, term, pos, neg)
        regexResult
      }
      val result2 = (conj.arithConj.positiveEqs).exists {atom =>
        //println(s" strDatabase 1 ${strDatabase.id2Str(atom.constant.intValueSafe)}")
        val equalString = strDatabase.id2Str(atom.constant.intValueSafe.abs)
        var returnResult = true
        for (positive <- pos){
          if (positive != equalString){
            returnResult = false
          }
        }
        for (negative <- neg){
          if (negative == equalString){
            returnResult = false
          }
        }
        returnResult
      }
      result || result2
    }
  }


}
