/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022 Philipp Ruemmer. All rights reserved.
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

package ostrich

import ap.Signature
import ap.basetypes.IdealInt
import ap.theories.{Theory, TheoryRegistry}
import ap.terfor.{TerForConvenience, Term, Formula, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.{Predicate, Atom}
import ap.terfor.linearcombination.LinearCombination
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.{Plugin, TheoryProcedure}
import ap.parser.IFunction
import ap.parameters.Param
import ap.util.IdealRange

/**
 * A theory for explicitly enumerating all values of integer terms.
 */
class IntValueEnumTheory(name               : String,
                         splitterCost       : Int,
                         completeSplitBound : Int) extends Theory {

  def enumIntValuesOf(t : Term, order : TermOrder) : Formula =
    Atom(enumPred, List(LinearCombination(t, order)), order)

  val enumPred                 = new Predicate(name + "_enum", 1)

  // magnitudeBoundPred(n, t) expresses that |t| >= 2^n - 1
  val magnitudeBoundPred       = new Predicate(name + "_mag_bigger_than", 2)

  val splitterAdded            = new Predicate(name + "_splitter_added", 0)

  val functions                = List()
  val predicates               = List(enumPred, magnitudeBoundPred,
                                      splitterAdded)
  val axioms                   = Conjunction.TRUE
  val totalityAxioms           = Conjunction.TRUE
  val functionPredicateMapping = List()

  val predicateMatchConfig     : Signature.PredicateMatchConfig = Map()
  val triggerRelevantFunctions : Set[IFunction]                 = Set()
  val functionalPredicates     : Set[Predicate]                 = Set()

  def pow2MinusOne(s : Int) : IdealInt = (IdealInt(2) pow s) - IdealInt.ONE

  val initialBoundLog = {
    var b = 0
    while (completeSplitBound >= (1 << (b + 2)))
      b = b + 1
    b
  }

  object Splitter extends TheoryProcedure {
    def boundLitsFor(goal : Goal,
                     enumTerm : LinearCombination) : Seq[Atom] = {
      val facts     = goal.facts
      val boundLits = facts.predConj.positiveLitsWithPred(magnitudeBoundPred)

      boundLits filter { a => a(1) == enumTerm }
    }

    def elimBoundPreds(goal : Goal,
                       enumTerm : LinearCombination) : Seq[Plugin.Action] = {
      implicit val order = goal.order
      import TerForConvenience._

      val facts     = goal.facts
      val boundLits = facts.predConj.positiveLitsWithPred(magnitudeBoundPred)

      for (lit <- boundLitsFor(goal, enumTerm);
           bound = pow2MinusOne(lit(0).constant.intValueSafe);
           act <- List(Plugin.RemoveFacts(conj(lit)),
                       Plugin.AddAxiom(
                         List(lit),
                         !((enumTerm > -bound) & (enumTerm < bound)),
                         IntValueEnumTheory.this)))
      yield act
    }

    def splitInterval(goal     : Goal,
                      enumTerm : LinearCombination,
                      lb       : IdealInt,
                      lbAss    : Seq[LinearCombination],
                      ub       : IdealInt,
                      ubAss    : Seq[LinearCombination]) : Seq[Plugin.Action] ={
      implicit val order = goal.order
      import TerForConvenience._

      // TODO: randomize?

      if (ub - lb > IdealInt(completeSplitBound)) {
        val mid = (ub + lb) / 2
        List(Plugin.CutSplit(enumTerm <= mid, List(), List()))
      } else {
        List(Plugin.AxiomSplit(
               List(), // TODO!
               for (k <- IdealRange(lb, ub + 1)) yield {
                 (conj(enumTerm === k), List())
               },
               IntValueEnumTheory.this
             ))
      }
    }

    def magnitudeSplit(goal                : Goal,
                       enumTerm            : LinearCombination,
                       boundLog            : Int,
                       secondBranchActions : Seq[Plugin.Action])
                                           : Seq[Plugin.Action] = {
      assert(boundLog >= 0)
      val bound = pow2MinusOne(boundLog)

      implicit val order = goal.order
      import TerForConvenience._

      List(Plugin.AxiomSplit(
             List(),
             List(((enumTerm > -bound) & (enumTerm < bound),
                   List()),
                  (magnitudeBoundPred(List(l(boundLog), enumTerm)),
                   secondBranchActions)),
             IntValueEnumTheory.this))
    }


    override def handleGoal(goal : Goal) : Seq[Plugin.Action] = {
      implicit val order = goal.order
      import TerForConvenience._

      val facts     = goal.facts
      val enumLits  = facts.predConj.positiveLitsWithPred(enumPred)

      if (enumLits.isEmpty) {
        List(Plugin.RemoveFacts(conj(splitterAdded(List()))))
      } else {
        val rand      = Param.RANDOM_DATA_SOURCE(goal.settings)
        val reducer   = goal.reduceWithFacts
        val enumLit   = enumLits(rand nextInt enumLits.size)
        val enumTerm  = enumLit(0)

        val lbOpt     = reducer.lowerBoundWithAssumptions(enumTerm)
        val ubOpt     = reducer.upperBoundWithAssumptions(enumTerm)

        /*
        println(enumTerm)
        println(lbOpt)
        println(ubOpt)
         */

        val actions =
          (lbOpt, ubOpt) match {
            case (Some((lb, lbAss)), Some((ub, ubAss))) => {
              elimBoundPreds(goal, enumTerm) elseDo
              splitInterval(goal, enumTerm, lb, lbAss, ub, ubAss)
            }
            case _ => {
              boundLitsFor(goal, enumTerm) match {
                case Seq() => {
                  magnitudeSplit(goal, enumTerm, initialBoundLog, List())
                }
                case Seq(boundLit, _*) => {
                  assert(boundLit(0).isConstant)
                  val boundLog = boundLit(0).constant.intValueSafe
                  magnitudeSplit(goal, enumTerm, boundLog + 1,
                                 List(Plugin.RemoveFacts(boundLit)))
                }
              }
            }
          }

        List(scheduleSplitter) ++ actions
      }
    }
  }

  val scheduleSplitter = Plugin.ScheduleTask(Splitter, splitterCost)

  val plugin = Some(
    new Plugin {
      override def handleGoal(goal : Goal) : Seq[Plugin.Action] = {
        val facts    = goal.facts
        val enumLits = facts.predConj.positiveLitsWithPred(enumPred)

        if (enumLits.isEmpty) {
          List()
        } else {
          implicit val order = goal.order
          import TerForConvenience._

          val splitterActions =
            if (facts.predicates contains splitterAdded) {
              List()
            } else {
              List(scheduleSplitter,
                   Plugin.AddAxiom(List(),
                                   splitterAdded(List()),
                                   IntValueEnumTheory.this))
            }

          val enumActions =
            for (lit <- enumLits; if lit.last.isConstant)
            yield Plugin.RemoveFacts(conj(lit))

          val boundActions =
            for (lit <- facts.predConj.positiveLitsWithPred(magnitudeBoundPred);
                 if lit.last.isConstant;
                 bound = pow2MinusOne(lit.head.constant.intValueSafe);
                 constraint = lit.last <= -bound | lit.last >= bound;
                 act <- List(Plugin.RemoveFacts(conj(lit))) ++ (
                   if (constraint.isTrue)
                     List()
                   else
                     List(Plugin.AddAxiom(List(lit), constraint,
                                          IntValueEnumTheory.this))))
            yield act

          splitterActions ++ enumActions ++ boundActions
        }
      }
    })

  override def isSoundForSat(
    theories : Seq[Theory],
    config : Theory.SatSoundnessConfig.Value) : Boolean = true

  TheoryRegistry register this

}
