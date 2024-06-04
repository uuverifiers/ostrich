/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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

package ostrich.cesolver.core


import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.terfor.ConstantTerm
import ap.terfor.OneTerm
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.IExpression
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet
}
import ostrich.OFlags
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._
import ap.parser.IConstant
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.util.TermGenerator

object FinalConstraints {

  private val termGen = TermGenerator(hashCode())

  def unaryHeuristicACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): UnaryFinalConstraints = {
    new UnaryFinalConstraints(t, auts, flags)
  }

  def baselineACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase]
  ): BaselineFinalConstraints = {
    new BaselineFinalConstraints(t, auts)
  }

/*
  def catraACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase]
  ): CatraFinalConstraints = {
    new CatraFinalConstraints(t, auts)
  }

  def nuxmvACs(
    t: ITerm,
    auts: Seq[CostEnrichedAutomatonBase]
  ): NuxmvFinalConstraints = {
    new NuxmvFinalConstraints(t, auts)
  }
*/

  def evalTerm(t: ITerm, model: PartialModel): IdealInt = {
    var value = evalTerm(t)(model)
    if (!value.isDefined) {
      // TODO: NEED NEW FEATURE!
      // Do not generate model of variables without constraints now
      throw new Exception("ITerm " + t + " is not defined in the model")
    }
    value.get
  }

  def evalTerm(t: ITerm)(model: PartialModel): Option[IdealInt] = t match {
    case _: ITerm =>
      model eval t
  }
}

import FinalConstraints._
trait FinalConstraints {
  type State = CostEnrichedAutomatonBase#State

  val strId: ITerm

  val auts: Seq[CostEnrichedAutomatonBase]

  val interestTerms: Seq[ITerm]

  def getModel: Option[Seq[Int]]

  protected var interestTermsModel: Map[ITerm, IdealInt] = Map()
  // accessors and mutators
  def getRegsRelation: IFormula

  def setInterestTermModel(partialModel: PartialModel): Unit =
    for (term <- interestTerms)
      interestTermsModel += (term -> evalTerm(term, partialModel))

  def setInterestTermModel(termModel: Map[ITerm, IdealInt]): Unit =
    for (term <- interestTerms)
      interestTermsModel = interestTermsModel + (term -> termModel(term))

  lazy val getCompleteLIA: IFormula = getCompleteLIA(auts.reduce(_ product _))

  def getCompleteLIA(aut: CostEnrichedAutomatonBase): IFormula = {
    ParikhUtil.debugPrintln("getCompleteLIA")
    lazy val transtion2Term =
      aut.transitionsWithVec.map(t => (t, termGen.transitionTerm)).toMap
    def outFlowTerms(from: State): Seq[ITerm] = {
      val outFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
      aut.outgoingTransitionsWithVec(from).foreach { case (to, lbl, vec) =>
        outFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      outFlowTerms.toSeq
    }

    def inFlowTerms(to: State): Seq[ITerm] = {
      val inFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
      aut.incomingTransitionsWithVec(to).foreach { case (from, lbl, vec) =>
        inFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      inFlowTerms.toSeq
    }

    val zTerm = aut.states.map((_, termGen.zTerm)).toMap

    val preStatesWithTTerm = new MHashMap[State, MHashSet[(State, ITerm)]]
    for ((from, lbl, to, vec) <- aut.transitionsWithVec) {
      val set = preStatesWithTTerm.getOrElseUpdate(to, new MHashSet)
      val tTerm = transtion2Term(from, lbl, to, vec)
      set += ((from, tTerm))
    }
    // consistent flow ///////////////////////////////////////////////////////////////
    var consistentFlowFormula = or(
      for (acceptState <- aut.acceptingStates)
        yield {
          val consistentFormulas =
            for (s <- aut.states)
              yield {
                val inFlow =
                  if (s == aut.initialState)
                    inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0)) + i(
                      1
                    )
                  else inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
                val outFlow =
                  if (s == acceptState)
                    outFlowTerms(s)
                      .reduceLeftOption(_ + _)
                      .getOrElse(i(0)) + i(1)
                  else outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
                inFlow === outFlow
              }
          and(consistentFormulas)
        }
    )

    // every transtion term should greater than 0
    val transtionTerms = transtion2Term.map(_._2).toSeq
    transtionTerms.foreach { term =>
      consistentFlowFormula = and(Seq(consistentFlowFormula, term >= 0))
    }
    /////////////////////////////////////////////////////////////////////////////////

    // connection //////////////////////////////////////////////////////////////////
    val zVarInitFormulas = aut.transitionsWithVec.map {
      case (from, lbl, to, vec) => {
        val tTerm = transtion2Term(from, lbl, to, vec)
        if (from == aut.initialState)
          (zTerm(from) === 0)
        else
          (tTerm === 0) | (zTerm(from) > 0)
      }
    }

    val connectFormulas = aut.states.map {
      case s if s != aut.initialState =>
        (zTerm(s) === 0) | or(
          preStatesWithTTerm(s).map { case (from, tTerm) =>
            if (from == aut.initialState)
              and(Seq(tTerm > 0, zTerm(s) === 1))
            else
              and(
                Seq(
                  zTerm(from) > 0,
                  tTerm > 0,
                  zTerm(s) === zTerm(from) + 1
                )
              )
          }
        )
      case _ => IExpression.Boolean2IFormula(true)
    }

    val connectionFormula = and(zVarInitFormulas ++ connectFormulas)
    /////////////////////////////////////////////////////////////////////////////////

    // registers update formula ////////////////////////////////////////////////////
    // registers update map
    val registerUpdateMap: Map[ITerm, ArrayBuffer[ITerm]] = {
      val registerUpdateMap =
        new MHashMap[ITerm, ArrayBuffer[ITerm]]
      aut.transitionsWithVec.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transtion2Term(from, lbl, to, vec)
        vec.zipWithIndex.foreach {
          case (veci, i) => {
            val registeri = aut.registers(i)
            val update =
              registerUpdateMap.getOrElseUpdate(
                registeri,
                new ArrayBuffer[ITerm]
              )
            update.append(trasitionTerm * veci)
          }
        }
      }
      registerUpdateMap.toMap
    }

    val registerUpdateFormula =
      if (registerUpdateMap.size == 0)
        and(for (r <- aut.registers) yield r === 0)
      else
        and(
          for ((r, update) <- registerUpdateMap)
            yield {
              r === update.reduce { (t1, t2) => sum(Seq(t1, t2)) }
            }
        )

    /////////////////////////////////////////////////////////////////////////////////
    and(
      Seq(
        registerUpdateFormula,
        consistentFlowFormula,
        connectionFormula,
        getRegsRelation
      )
    )
  }
}
