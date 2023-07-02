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

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.parser.Internal2InputAbsy._
import ostrich.cesolver.convenience.CostEnrichedConvenience._
import FinalConstraints._
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IExpression._
import ostrich.cesolver.util.ParikhUtil

class BaselineSolver(val lProver: SimpleAPI)
    extends FinalConstraintsSolver[BaselineFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(baselineACs(t, auts))
  }

  def solve: Result = {
    val f = and(constraints.map(_.getCompleteLIA))
    import FinalConstraints.evalTerm
    val res = new Result
    val regsRelation = and(constraints.map(_.getRegsRelation))
    val finalArith = and(Seq(f, regsRelation))

    lProver.push
    val newConsts = SymbolCollector.constants(finalArith) &~ lProver.order.orderedConstants 
    lProver.addConstantsRaw(newConsts)
    lProver !! finalArith
    val status = measure(
      s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
    ) {
      lProver.???
    }
    lProver.pop
    status match {
      case ProverStatus.Sat =>
        val partialModel = lProver.partialModel
        // update string model
        for (singleString <- constraints) {
          singleString.setInterestTermModel(partialModel)
          val value = measure(
            s"${this.getClass.getSimpleName}::findStringModel"
          )(singleString.getModel)
          value match {
            case Some(v) => res.updateModel(singleString.strId, v)
            case None    => throw UnknownException("Cannot find string model")
          }

        }
        // update integer model
        for (term <- integerTerms) {
          val value = evalTerm(term, partialModel)
          res.updateModel(term, value)
        }

        res.setStatus(ProverStatus.Sat)
      case _ => res.setStatus(_)
    }
    res
  }
}
