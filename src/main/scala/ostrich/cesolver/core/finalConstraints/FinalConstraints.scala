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


import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.parser.IExpression._
import ap.parser.IFormula
import ap.parser.ITerm
import ostrich.OFlags
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IBinJunctor


object FinalConstraints {
  def unaryHeuristicACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): UnaryFinalConstraints = {
    new UnaryFinalConstraints(t, auts, flags)
  }

  def baselineACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): BaselineFinalConstraints = {
    new BaselineFinalConstraints(t, auts, flags)
  }

  def evalTerm(t: ITerm, model: PartialModel): IdealInt = {
    val value = evalTerm(t)(model)
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

trait FinalConstraints {
  type State = CostEnrichedAutomatonBase#State

  val strDataBaseId: ITerm

  val auts: Seq[CostEnrichedAutomatonBase]

  val regsTerms: Seq[ITerm]

  // protected var regTermsModel: Map[ITerm, IdealInt]

  // accessors and mutators-------------------------------------------
  def getModel(partialModel: PartialModel): Option[Seq[Int]]

  def getRegsRelation: IFormula 

  // def setRegTermsModel(partialModel: PartialModel): Unit = {
  //   regTermsModel = Map()
  //   for (term <- getRegisters)
  //     regTermsModel += (term -> evalTerm(term, partialModel))
  // }

  // def setRegTermsModel(termModel: Map[ITerm, IdealInt]): Unit = {
  //   regTermsModel = Map()
  //   for (term <- getRegisters)
  //     regTermsModel += (term -> termModel(term))
  // }
  // accessors and mutators-------------------------------------------
}
