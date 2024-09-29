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
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.CEBasicOperations
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.automata.BricsTLabelOps
import ostrich.cesolver.util.ParikhUtil.debugPrintln

object SubStrPreImageUtil {
  // An Automaton that accepts all strings not containing c
  def noMatch(c: Char): CostEnrichedAutomatonBase = {
    val noCLabels = BricsTLabelOps.subtractLetter(c, (0.toChar, 65535.toChar))
    val ceAut = new CostEnrichedAutomatonBase
    ceAut.setAccept(ceAut.initialState, true)
    for (lbl <- noCLabels)
      ceAut.addTransition(ceAut.initialState, lbl, ceAut.initialState, Seq())
    ceAut
  }
}

// substring(s, 0, len(s) - 1)
class SubStr_0_lenMinus1 extends CEPreOp {
  override def toString = "subStr(0, len - 1)"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val nonEpsResPre = CEBasicOperations.concatenate(
      Seq(
        res,
        PreOpUtil.automatonWithLen(1)
      )
    )
    val epsResPre = BricsAutomatonWrapper.makeEmptyString()
    epsResPre.regsRelation = res.regsRelation
    epsResPre.registers = res.registers

    val preImages = 
    if (res.isAccept(res.initialState))
      Seq(epsResPre, nonEpsResPre)
    else
      Seq(nonEpsResPre)

    debugPrintln("preImage.regsRelation: " + nonEpsResPre.regsRelation)
    nonEpsResPre.toDot("preImage_of" + res.hashCode())

    (Iterator(Seq(nonEpsResPre)), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(arguments(0).slice(0, arguments(0).length - 1))
  }
}

// substring(s, len(s) - 1, 1)
class SubStr_lenMinus1_1 extends CEPreOp {
  override def toString = "subStr(len - 1, 1)"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val suffix = CEBasicOperations.intersection(
      res,
      PreOpUtil.automatonWithLen(1)
    )
    val nonEpsResPreImage = CEBasicOperations.concatenate(
      Seq(
        BricsAutomatonWrapper.makeAnyString(),
        suffix
      )
    )
    val epsResPreImage = BricsAutomatonWrapper.makeEmptyString()
    for (r <- res.registers) {
      epsResPreImage.regsRelation &= (r === 0)
    }
    epsResPreImage.regsRelation &= res.regsRelation
    
    val preImages =
      if (res.isAccept(res.initialState))
        Iterator(Seq(nonEpsResPreImage), Seq(epsResPreImage))
      else
        Iterator(Seq(nonEpsResPreImage))
    (preImages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(arguments(0).slice(arguments(0).length - 1, arguments(0).length))
  }
}

// substring(s, n, len(s) - m), where n >= 0 and m >= 0
class SubStr_n_lenMinusM(beginIdx: Integer, offset: Integer) extends CEPreOp {

  override def toString = s"subStr(${beginIdx}, len - ${offset})"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val beginPlus1 = beginIdx + 1
    val offsetPlus1 = offset + 1
    val nonEpsResPreImage =
      if (beginIdx >= offset)
        CEBasicOperations.concatenate(
          Seq(PreOpUtil.automatonWithLen(beginIdx), res)
        )
      else
        CEBasicOperations.concatenate(
          Seq(
            PreOpUtil.automatonWithLen(beginIdx),
            res,
            PreOpUtil.automatonWithLen(offset - beginIdx)
          )
        )

    val epsResPreImage =
      PreOpUtil.automatonWithLenLessThan(beginPlus1.max(offsetPlus1))
    for (r <- res.registers) {
      epsResPreImage.regsRelation &= (r === 0)
    }
    epsResPreImage.regsRelation &= res.regsRelation

    val preImages =
      if (res.isAccept(res.initialState))
        Iterator(Seq(nonEpsResPreImage), Seq(epsResPreImage))
      else
        Iterator(Seq(nonEpsResPreImage))

    (preImages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(
      arguments(0)
        .slice(
          beginIdx,
          arguments(0).length - offset + beginIdx
        )
    )
  }
}

// substring(s, 0, indexof_c(s, 0))
class SubStr_0_indexofc0(c: Char) extends CEPreOp {
  override def toString = s"subStr(0, indexof_${c}0)"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val cAut = BricsAutomatonWrapper.fromString(c.toString)
    val resInterNoC =
      CEBasicOperations.intersection(res, SubStrPreImageUtil.noMatch(c))
    val nonEpsResPreImage = CEBasicOperations.concatenate(
      Seq(resInterNoC, cAut, BricsAutomatonWrapper.makeAnyString())
    )
    val epsResPreImage1 = SubStrPreImageUtil.noMatch(c)
    val epsResPreImage2 = CEBasicOperations.concatenate(
      Seq(cAut, BricsAutomatonWrapper.makeAnyString())
    )
    for (r <- res.registers) {
      epsResPreImage1.regsRelation &= (r === 0)
      epsResPreImage2.regsRelation &= (r === 0)
    }
    epsResPreImage1.regsRelation &= res.regsRelation
    epsResPreImage2.regsRelation &= res.regsRelation

    val preImages =
      if (res.isAccept(res.initialState))
        Iterator(
          Seq(nonEpsResPreImage),
          Seq(epsResPreImage1),
          Seq(epsResPreImage2)
        )
      else Iterator(Seq(nonEpsResPreImage))
    (preImages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val s = arguments(0)
    val index = s.indexOf(c)
    Some(s.slice(0, index))
  }
}

// substring(s, 0, indexof_c(s, 0) + 1)
class SubStr_0_indexofc0Plus1(c: Char) extends CEPreOp {
  override def toString(): String = s"subStr(0, indexof_${c}0 + 1)"
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val cAut = BricsAutomatonWrapper.fromString(c.toString)
    val noMatchC = SubStrPreImageUtil.noMatch(c)
    val resInterNoCC = CEBasicOperations.intersection(
      res,
      CEBasicOperations.concatenate(Seq(noMatchC, cAut))
    )

    val nonEpsResPreImage = CEBasicOperations.concatenate(
      Seq(resInterNoCC, BricsAutomatonWrapper.makeAnyString())
    )
    val epsResPreImage = SubStrPreImageUtil.noMatch(c)
    for (r <- res.registers) {
      epsResPreImage.regsRelation &= (r === 0)
    }
    epsResPreImage.regsRelation &= res.regsRelation

    val preImages =
      if (res.isAccept(res.initialState))
        Iterator(Seq(nonEpsResPreImage), Seq(epsResPreImage))
      else
        Iterator(Seq(nonEpsResPreImage))

    (preImages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val s = arguments(0)
    val index = s.indexOf(c)
    Some(s.slice(0, index + 1))
  }
}

// substring(s, indexof_c(s, 0) + 1, len(s) - (indexof_c(s, 0) + 1))
class SubStr_indexofc0Plus1_tail(c: Char) extends CEPreOp {
  override def toString(): String = s"subStr(indexof_${c}0 + 1, tail)"
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val cAut = BricsAutomatonWrapper.fromString(c.toString)
    val noMatchC = SubStrPreImageUtil.noMatch(c)
    val prefix = CEBasicOperations.concatenate(
      Seq(noMatchC, cAut)
    )

    val nonEpsResPreImage1 = CEBasicOperations.concatenate(Seq(prefix, res))
    val nonEpsResPreImage2 = CEBasicOperations.intersection(res, noMatchC)
    val epsResPreImage = BricsAutomatonWrapper.makeEmptyString()
    for (r <- res.registers) {
      epsResPreImage.regsRelation &= (r === 0)
    }
    epsResPreImage.regsRelation &= res.regsRelation

    val preImages =
      if (res.isAccept(res.initialState))
        Iterator(Seq(nonEpsResPreImage1), Seq(nonEpsResPreImage2), Seq(epsResPreImage))
      else
        Iterator(Seq(nonEpsResPreImage1), Seq(nonEpsResPreImage2))
    (preImages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val s = arguments(0)
    val index = s.indexOf(c)
    Some(s.slice(index + 1, s.length))
  }
}
