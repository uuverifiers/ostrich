/**
 * This file is part of Princess, a theorem prover for Presburger
 * arithmetic with uninterpreted predicates.
 * <http://www.philipp.ruemmer.org/princess.shtml>
 *
 * Copyright (C) 2009-2011 Philipp Ruemmer <ph_r@gmx.net>
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
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ap.proof;

import ap.SimpleAPI
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.util.{APTestCase, Debug, Logic, PlainRange}
import ap.proof.goal.{CompoundFormulas, FactsNormalisationTask, Goal, TaskManager}
import ap.proof.tree._
import ap.proof.certificates.BranchInferenceCollection
import ap.terfor._
import ap.terfor.conjunctions.{Conjunction, NegatedConjunctions, Quantifier}
import ap.terfor.substitutions.{ConstantSubst, IdentitySubst}
import ap.terfor.equations.{EquationConj, NegEquationConj}
import ap.terfor.inequalities.InEqConj
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.arithconj.ArithConj
import ap.basetypes.IdealInt
import ap.parameters.{GoalSettings, Param}
import ap.terfor.preds.PredConj
import ap.theories.strings.StringTheory
import ap.types.Sort
import org.scalacheck.Properties
import ostrich.automata.{AutomataUtils, Automaton, BricsAutomaton}
import ostrich.proofops.OstrichClose
import ostrich.{OFlags, OstrichStringTheory, OstrichStringTheoryBuilder}

import scala.collection.mutable.ArrayBuffer

object OstrichCloseSpecification extends Properties("ostrichCloseSpecification"){

  private val theory =     new OstrichStringTheory (Seq(),
    OFlags())
  import ap.basetypes.IdealInt
  import ap.theories.strings.StringTheory
  import ostrich.automata.AutDatabase
  import theory._
  import TerForConvenience._
  import StringTheory.ConcreteString

  private val consts = for (i <- Array.range(0, 10)) yield new ConstantTerm("c" + i)
  implicit val to: TermOrder = (TermOrder.EMPTY /: consts)((o, c) => o.extend(c))

  val aut1: Automaton  = BricsAutomaton.fromString("a")
  val aut2: Automaton  = BricsAutomaton.fromString("b")
  val aut3: Automaton  = BricsAutomaton.fromString("c")
  val aut4: Automaton  = aut1 | aut2
  val aut5: Automaton  = aut2 | aut3
  val aut6: Automaton  = aut1 | aut3

  val idAut1: Int = autDatabase.automaton2Id(aut1)
  val idAut2: Int = autDatabase.automaton2Id(aut2)
  val idAut3: Int = autDatabase.automaton2Id(aut3)
  val idAut4: Int = autDatabase.automaton2Id(aut4)
  val idAut5: Int = autDatabase.automaton2Id(aut5)
  val idAut6: Int = autDatabase.automaton2Id(aut6)

  val formula2 : Formula = str_in_re_id(List(l(consts(0)), l(idAut1)))
  val formula3 : Formula = str_in_re_id(List(l(consts(1)), l(idAut2)))
  println(formula2)



  private val settings =
    Param.CONSTRAINT_SIMPLIFIER.set(GoalSettings.DEFAULT,
      ConstraintSimplifier.FAIR_SIMPLIFIER)
  private val prover = new ExhaustiveProver(settings)

  val facts: Conjunction = Conjunction.TRUE
  // Why does this fail?
  // val facts1: Conjunction = conj(Seq(formula2, formula3))



  val goal: Goal = Goal(facts, CompoundFormulas.EMPTY(Map()),
    TaskManager.EMPTY,  0, Set.empty, Vocabulary(to), new IdentitySubst(to),
    BranchInferenceCollection.EMPTY, settings
  )
  val closeTest = new OstrichClose(goal, theory, theory.theoryFlags)
  val valueClose = closeTest.isConsistent
  println(valueClose)
}