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
import ostrich.cesolver._
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ostrich.cesolver.util.TermGenerator

object LengthCEPreOp {

  private val termGen = TermGenerator(hashCode())

  def apply(length: ITerm): LengthCEPreOp = new LengthCEPreOp(length)

  def lengthPreimage(length: ITerm) : CostEnrichedAutomatonBase = {
    val preimage = new CostEnrichedAutomaton
    val initalState = preimage.initialState

    // 0 -> (sigma, 1) -> 0
    preimage.addTransition(
      initalState,
      preimage.LabelOps.sigmaLabel,
      initalState,
      Seq(1)
    )
    preimage.setAccept(initalState, true)
    // registers: (r0)
    preimage.registers = Seq(termGen.registerTerm)
    // intFormula : r0 === `length`
    preimage.regsRelation = length === preimage.registers(0)
    preimage
  }
}

/**
  * Pre-op for length constraints. 
  * @param length The length 
  */
class LengthCEPreOp(length: ITerm) extends CEPreOp {

  override def toString = "lengthCEPreOp"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    (Iterator(Seq(LengthCEPreOp.lengthPreimage(length))), Seq())
  }

  /** Evaluate the described function; return <code>None</code> if the function
    * is not defined for the given arguments.
    */
  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(Seq(arguments(0).length))
  }
}
