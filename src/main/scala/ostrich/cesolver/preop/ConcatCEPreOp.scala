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

package ostrich.cesolver.preop

import ostrich.automata.Automaton
import ostrich.cesolver.automata.CostEnrichedInitFinalAutomaton
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.IExpression._
import ap.parser.IBinJunctor

object ConcatCEPreOp extends CEPreOp {
  override def toString(): String = "concatCEPreOp"

  def addConcatPreRegsFormula(
      concatLeft: CostEnrichedAutomatonBase,
      concatRight: CostEnrichedAutomatonBase,
      result: CostEnrichedAutomatonBase
  ): Unit = {
    val leftRegs = concatLeft.registers
    val rightRegs = concatRight.registers
    val resultRegs = result.registers
    val derivedRegsRelation = connectSimplify(leftRegs.zipWithIndex.map { case (reg, i) =>
      (reg + rightRegs(i)) === resultRegs(i)
    }, IBinJunctor.And)
    val letfRegsRelation = concatLeft.regsRelation
    val resRegsRelation = result.regsRelation
    concatLeft.regsRelation = connectSimplify(
      Seq(letfRegsRelation, derivedRegsRelation, resRegsRelation),
      IBinJunctor.And
    )
  }

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val resultAut = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val argLengths = (
      for (argAuts <- argumentConstraints) yield {
        (for (
          aut <- argAuts;
          lengths <- aut.asInstanceOf[CostEnrichedAutomatonBase].uniqueAcceptedWordLengths
        )
          yield (aut, lengths)).toSeq.headOption
      }
    ).toSeq

    val res = argLengths(0) match {
      case Some((lenAut, lengths)) =>
        // the prefix needs to be of a certain length
        val preImage =
          for (
            s <- resultAut.states;
            if ((resultAut.uniqueLengthStates get s) match {
              case Some(l) => lengths.contains(l)
              case None    => true
            })
          ) yield {
            val concatLeft =
              CostEnrichedInitFinalAutomaton.setFinal(resultAut, Set(s))
            val concatRight =
              CostEnrichedInitFinalAutomaton.setInitial(resultAut, s)
            addConcatPreRegsFormula(concatLeft, concatRight, resultAut)
            List(concatLeft, concatRight)
          }
        val relatedArgs = List(List(lenAut), List())
        (preImage.iterator, relatedArgs)
      case None =>
        argLengths(1) match {
          case Some((lenAut, lengths))
              if resultAut.uniqueAcceptedWordLengths.isDefined => {
            // the suffix needs to be of a certain length
            val resLengths = resultAut.uniqueAcceptedWordLengths.get
            val preImage =
              for (
                s <- resultAut.states;
                if ((resultAut.uniqueLengthStates get s) match {
                  case Some(l) =>
                    resLengths
                      .find(resLength =>
                        lengths.find(_ + l == resLength).isDefined
                      )
                      .isDefined
                  case None => true
                })
              ) yield {
                val concatLeft =
                  CostEnrichedInitFinalAutomaton.setFinal(resultAut, Set(s))
                val concatRight =
                  CostEnrichedInitFinalAutomaton.setInitial(resultAut, s)
                addConcatPreRegsFormula(concatLeft, concatRight, resultAut)
                List(concatLeft, concatRight)
              }
            val relatedArgs = List(List(), List(lenAut))
            (preImage.iterator, relatedArgs)
          }
          case _ =>
            val preImage =
              for (s <- resultAut.states) yield {
                val concatLeft =
                  CostEnrichedInitFinalAutomaton.setFinal(resultAut, Set(s))
                val concatRight =
                  CostEnrichedInitFinalAutomaton.setInitial(resultAut, s)
                addConcatPreRegsFormula(concatLeft, concatRight, resultAut)
                List(concatLeft, concatRight)
              }
            (preImage.iterator, List())
        }
    }
    res
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] =
    Some(arguments(0) ++ arguments(1))
}
