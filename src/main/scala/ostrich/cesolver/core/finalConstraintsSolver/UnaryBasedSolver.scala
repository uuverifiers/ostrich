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
package ostrich.cesolver.core.finalConstraintsSolver

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.core.finalConstraints.{
  FinalConstraints,
  UnaryFinalConstraints
}
import ostrich.OFlags
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IConstant
import ap.util.Timeout
import ap.parser.IBinJunctor

class UnaryBasedSolver(
    flags: OFlags,
    lProver: SimpleAPI,
    additionalLia: IFormula
) extends FinalConstraintsSolver[UnaryFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.unaryHeuristicACs(t, auts, flags))
  }

  def solve: Result = solveCompleteLIA

  def solveCompleteLIA: Result = solveFormula(
    connectSimplify(constraints.map(_.getCompleteLIA), IBinJunctor.And)
  )

  def solveFormula(f: IFormula, generateModel: Boolean = true): Result = {

    val res = new Result
    val finalArith = f & additionalLia

    lProver.push
    val integerInConstraints =
      (for (t <- integerTerms) yield SymbolCollector constants t).flatten
    val allConsts =
      (SymbolCollector.constants(
        finalArith
      ) ++ integerInConstraints)

    val newConsts = allConsts &~ lProver.order.orderedConstants

    lProver.addConstantsRaw(newConsts)
    lProver !! finalArith

    ParikhUtil.debugPrintln("finalArith is " + finalArith)

    lProver.checkSat(false)
    val status = measure(
      s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
    ) {
      while (lProver.getStatus(100) == ProverStatus.Running) {
        Timeout.check
      }
      lProver.???
    }
    status match {
      case ProverStatus.Sat if generateModel =>
        // generate model
        val partialModel = lProver.partialModel
        // update string model
        for (singleString <- constraints) {
          val value = measure(
            s"${this.getClass.getSimpleName}::findStringModel"
          )(singleString.getModel(partialModel))
          value match {
            case Some(v) => res.updateModel(singleString.strDataBaseId, v)
            case None    => throw UnknownException("Cannot find string model")
          }

        }
        // update integer model
        for (term <- allConsts) {
          val value = FinalConstraints.evalTerm(IConstant(term), partialModel)
          res.updateModel(term, value)
        }
      case _ => //do nothing
    }
    res.setStatus(status)
    lProver.pop
    res
  }

}
