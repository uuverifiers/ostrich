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

import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression
import ap.parser.IExpression._
import scala.collection.mutable.ArrayBuffer
import ostrich.cesolver.util.TermGenerator
import scala.collection.mutable.{HashSet => MHashSet}
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IBinJunctor
import ostrich.OFlags
import ap.basetypes.IdealInt
import ap.api.PartialModel
import ostrich.automata.AutomataUtils.findAcceptedWord

class BaselineFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase],
    flags: OFlags
) extends FinalConstraints {
  val regsTerms: Seq[ITerm] = auts.flatMap(_.registers)

  lazy val getCompleteLIA: IFormula = {
    connectSimplify(
      Seq(ParikhUtil.parikhImage(auts.reduce(_ product _)), getRegsRelation),
      IBinJunctor.And
    )
  }

  def getRegsRelation: IFormula =
    connectSimplify(auts.map(_.regsRelation), IBinJunctor.And)

  def getModel(partialModel: PartialModel): Option[Seq[Int]] = {
    var registersModel = Map[ITerm, IdealInt]()
    for (term <- auts.flatMap(_.registers))
      registersModel += (term -> FinalConstraints.evalTerm(term, partialModel))
    ParikhUtil.findAcceptedWord(auts, registersModel, flags)
  }

}
