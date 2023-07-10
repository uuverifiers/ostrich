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
import ostrich.cesolver.automata.CostEnrichedAutomaton
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import PreOpUtil.{automatonWithLen, automatonWithLenLessThan}
import ostrich.cesolver.automata.CEBasicOperations.{intersection, concatenate}
import ostrich.automata.BricsAutomaton
import ap.parser.ITerm
import ap.parser.IExpression._
import ap.parser.IIntLit
import ostrich.cesolver.util.TermGenerator
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.convenience.CostEnrichedConvenience.automaton2CostEnriched

object SubStringCEPreOp {
  def apply(beginIdx: ITerm, length: ITerm) =
    new SubStringCEPreOp(beginIdx, length)
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

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimages = Iterator[Seq[Automaton]]()
    var preimagesOfEmptyStr = Iterator[Seq[Automaton]]()
    val res = automaton2CostEnriched(resultConstraint)
    if (res.isAccept(res.initialState)) {
      // empty string result
      val preimageOfEmp1 = BricsAutomatonWrapper.makeAnyString
      preimageOfEmp1.regsRelation = and(Seq(
        preimageOfEmp1.regsRelation,
        length <= 0
      ))
      val preimageOfEmp2 = beginIdx match {
        case  IIntLit(value) => {
          automatonWithLenLessThan(value.intValueSafe)
        }
        case _ => {
          val searchedStrLen = termGen.lenTerm
          val preimage = LengthCEPreOp.lengthPreimage(searchedStrLen)
          preimage.regsRelation = and(Seq(
            preimage.regsRelation,
            searchedStrLen <= beginIdx
          ))
          preimage
        }
      }
      for (r <- res.registers) {
        // tansmit the empty string integer info
        preimageOfEmp1.regsRelation =
          and(Seq(preimageOfEmp1.regsRelation, r === 0))
        preimageOfEmp2.regsRelation =
          and(Seq(preimageOfEmp2.regsRelation, r === 0))
      }
      preimagesOfEmptyStr =
        Iterator(Seq(preimageOfEmp1), Seq(preimageOfEmp2))
    }
    val beginIdxPrefix = beginIdx match {
      case IIntLit(value) => {
        automatonWithLen(value.intValueSafe)
      }
      case _ => {
        LengthCEPreOp.lengthPreimage(beginIdx)
      }
    }

    val middleSubStr = length match {
      case IIntLit(value) => {
        intersection(
          automatonWithLen(value.intValueSafe),
          res
        )
      }
      case _ => {
        intersection(
          LengthCEPreOp.lengthPreimage(length),
          res
        )
      }
    }

    val smallLenSuffix = length match {
      case IIntLit(value) => {
        intersection(
          automatonWithLenLessThan(value.intValueSafe),
          res
        )
      }
      case _ => {
        val smallLen = termGen.lenTerm
        val smallLenSuffix = intersection(
          LengthCEPreOp.lengthPreimage(smallLen),
          res
        )
        smallLenSuffix.regsRelation = and(Seq(
          smallLenSuffix.regsRelation,
          smallLen <= length
        ))
        smallLenSuffix
      }
    }
    val anyStrSuffix = BricsAutomatonWrapper.makeAnyString

    val preimage1 = concatenate(Seq(
      beginIdxPrefix,
      middleSubStr,
      anyStrSuffix
    ))

    val preimage2 = concatenate(
      Seq(beginIdxPrefix, smallLenSuffix)
    )

    preimages = Iterator(Seq(preimage1), Seq(preimage2))

    (preimagesOfEmptyStr ++ preimages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val beginIdx = arguments(1)(0)
    val length = arguments(2)(0)
    val bigString = arguments(0)
    if (beginIdx < 0 || length < 0) {
      Some(Seq()) // empty string
    } else {
      Some(bigString.slice(beginIdx, beginIdx + length))
    }
  }

}
