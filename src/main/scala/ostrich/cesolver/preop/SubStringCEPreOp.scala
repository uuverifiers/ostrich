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
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.CEBasicOperations.{intersection, concatenate}
import ap.parser.ITerm
import ap.parser.IExpression._
import ostrich.cesolver.util.TermGenerator
import ap.basetypes.IdealInt
import ap.parser.IBinJunctor

object SubStringCEPreOp {
  

  def apply(beginIdx: ITerm, length: ITerm) = {
    new SubStringCEPreOp(beginIdx, length)
  }
}

/** Pre-operator for substring constraint.
  * @param beginIdx
  *   the begin index
  * @param length
  *   the max length of subtring
  */
class SubStringCEPreOp(beginIdx: ITerm, length: ITerm) extends CEPreOp {
  private val termGen = TermGenerator()

  override def toString(): String =
    "subStringCEPreOp"

  private def normalPreimage(res: CostEnrichedAutomatonBase): Automaton = {
    val resLen = termGen.lenTerm
    val resWithLen =
      intersection(res, LengthCEPreOp.lengthPreimage(resLen, false))
    val prefixLen = termGen.lenTerm
    val prefix = LengthCEPreOp.lengthPreimage(prefixLen, false)
    val suffixLen = termGen.lenTerm
    val suffix = LengthCEPreOp.lengthPreimage(suffixLen, false)
    val preimage = concatenate(Seq(prefix, resWithLen, suffix))
    val argLen = prefixLen + resLen + suffixLen
    val epsilonResFormula =
      (length <= 0 | beginIdx < 0 | beginIdx > argLen - 1) & resLen === 0
    val nonEpsilonResFormula =
      ((resLen <= length & suffixLen === 0) | (resLen === length & suffixLen > 0)) & beginIdx === prefixLen
    preimage.regsRelation = connectSimplify(
      Seq(preimage.regsRelation, (epsilonResFormula | nonEpsilonResFormula)),
      IBinJunctor.And
    )
    preimage
  }

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {

    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    (beginIdx, length) match {
      // substring(x, 0, 1)
      case (Const(IdealInt(0)), Const(IdealInt(1))) => {
        val preImage = concatenate(
          Seq(
            intersection(res, LengthCEPreOp.lengthPreimage(1)),
            BricsAutomatonWrapper.makeAnyString()
          )
        )
        if (res.isAccept(res.initialState))
          preImage.setAccept(preImage.initialState, true)
        (Iterator(Seq(preImage)), Seq())
      }
      // normal case
      case _ => (Iterator(Seq(normalPreimage(res))), Seq())
    }
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val beginIdx = arguments(1)(0)
    val length = arguments(2)(0)
    val bigString = arguments(0)
    if (beginIdx < 0 || length < 0 || beginIdx > bigString.length - 1) {
      Some(Seq()) // empty string
    } else {
      Some(bigString.slice(beginIdx, beginIdx + length))
    }
  }

}
