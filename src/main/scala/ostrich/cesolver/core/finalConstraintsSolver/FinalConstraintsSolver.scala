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

import ap.api.SimpleAPI.ProverStatus
import ap.basetypes.IdealInt
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ostrich.cesolver.util.ParikhUtil

class Result {
  protected var status = ProverStatus.Unknown

  private val model = new OstrichModel

  def isSat = status == ProverStatus.Sat

  def isUnsat = status == ProverStatus.Unsat

  def setStatus(s: ProverStatus.Value): Unit = status = s

  def getStatus = status

  def updateModel(t: ITerm, v: IdealInt): Unit = model.update(t, v)

  def updateModel(t: ITerm, v: Seq[Int]): Unit = model.update(t, v)

  def getModel = model.getModel

  override def toString : String =
    "" + status + ", " + model

}


trait FinalConstraintsSolver[A <: FinalConstraints] {

  def solve: Result

  def measureTimeSolve: Result =
    measure(s"${this.getClass.getSimpleName}::solve") {
      ParikhUtil.debugPrintln("begin solve")
      val res = solve
      ParikhUtil.debugPrintln("end solve")
      res
    }

  protected var constraints: Seq[A] = Seq()

  protected var integerTerms: Set[ITerm] = Set()

  def setIntegerTerm(terms: Set[ITerm]): Unit = integerTerms = terms

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit

  def addConstraint(c: A) = constraints = constraints :+ c

}
