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
package ostrich.cesolver.core.finalConstraints

import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.automata.CEBasicOperations
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.OFlags
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._
import ap.parser.IBinJunctor
import ap.api.PartialModel
import ap.basetypes.IdealInt

class UnaryFinalConstraints(
    strDataBaseId: ITerm,
    auts: Seq[CostEnrichedAutomatonBase],
    flags: OFlags
) extends BaselineFinalConstraints(strDataBaseId, auts, flags) {

  private def removeDupTransitions(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    val ceAut = new CostEnrichedAutomatonBase
    val old2new = aut.states.map(_ -> ceAut.newState()).toMap
    ceAut.initialState = old2new(aut.initialState)
    for (state <- aut.states) {
      if (aut.isAccept(state))
        ceAut.setAccept(old2new(state), true)
      val outTrans = aut.outgoingTransitionsWithVec(state)
      val afterRemoveDup = outTrans
        .groupBy { case (outState, _, vec) =>
          (outState, vec)
        }
        .map { case (_, trans) =>
          trans.head
        }
      for ((outState, label, vec) <- afterRemoveDup) {
        ceAut.addTransition(old2new(state), label, old2new(outState), vec)
      }
    }
    ceAut.registers = aut.registers
    ceAut.regsRelation = aut.regsRelation
    ceAut
  }

  private val productAut = auts.reduce(_ product _)

  private lazy val findModelAut =
    if (!flags.simplyAutByVec) productAut
    else {
      val afterRemoveDup = removeDupTransitions(productAut)
      if (flags.minimizeAutomata)
        CEBasicOperations.minimizeHopcroft(
          afterRemoveDup
        )
      else CEBasicOperations.removeDuplicatedReg(afterRemoveDup)
    }

  private lazy val checkSatAut =
    if (!flags.simplyAutByVec) productAut
    else {
        CEBasicOperations.minimizeHopcroftByVec(
          productAut
        )
    }

  if (ParikhUtil.debugOpt) {
    checkSatAut.toDot(strDataBaseId + "_checkSatAut")
    findModelAut.toDot(strDataBaseId + "_findModelAut")
  }

  override lazy val getCompleteLIA: IFormula = {
    connectSimplify(
      Seq(ParikhUtil.parikhImage(checkSatAut), checkSatAut.regsRelation),
      IBinJunctor.And
    )
  }

  override def getRegsRelation: IFormula = checkSatAut.regsRelation

  override def getModel(partialModel: PartialModel): Option[Seq[Int]] = {
    ParikhUtil.log("Get model of string term " + strDataBaseId)
    var registersModel = Map[ITerm, IdealInt]()
    for (term <- auts.flatMap(_.registers))
      registersModel += (term -> FinalConstraints.evalTerm(term, partialModel))
    val res = ParikhUtil.findAcceptedWord(
      Seq(findModelAut),
      registersModel,
      flags
    )
    ParikhUtil.log(s"The model of ${strDataBaseId} is generated")
    res
  }
}
