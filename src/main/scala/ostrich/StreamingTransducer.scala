/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020 Zhilei Han. All rights reserved.
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

package ostrich

// operators which update the values of string variables in PSST
abstract class UpdateOp

// Append a constant character
case class Constant(val c: Char) extends UpdateOp

// Append a character by adding offset to the input character
case class Offset(val o: Int) extends UpdateOp

// Refer to the current value of a string variable
case class RefVariable(val v: Int) extends UpdateOp

// Append an 'internal' character
case object InternalOp extends UpdateOp

// A copyful SST is more expressive than 2FT, and
// encodes a non-regular relation
trait StreamingTransducer {
  /**
   * Calculates regular language that is pre-image of the given regular
   * language.  I.e. Pre_T(aut) for transducer T
   *
   * Convenience method for when there are no internal transitions
   */
  def preImage(aut : AtomicStateAutomaton) : AtomicStateAutomaton =
    preImage(aut, Iterable.empty[(aut.State, aut.State)])

  /**
   * Calculates regular language that is pre-image of the given regular
   * language.  I.e. Pre_T(aut) for transducer T
   *
   * internal is a map indicating which states should be considered to
   * have an Internal character between them.  I.e. map(s) contains s'
   * if there is an internal transition between s and s'
   */
  def preImage[A <: AtomicStateAutomaton]
              (aut : A,
               internal : Iterable[(A#State, A#State)]) : AtomicStateAutomaton

  /**
   * Apply the transducer to the input, replacing any internal
   * characters with the given string.
   *
   * Assumes transducer is functional, so returns the first found output
   * or None
   */
  def apply(input : String, internal : String = "") : Option[String]

  /**
   * Return a dot representation of the transducer (may not be
   * implemented)
   */
  def toDot : String = {
    return "Dot output not implemented."
  }
}

trait StreamingTransducerBuilder[S, T] {

  type State = S
  type TLabel = T

  /**
   * Operations on labels
   */
  val LabelOps : TLabelOps[TLabel]

  /**
   * Initial state of transducer being built
   */
  def initialState : State

  /**
   * Set the initial state of the transducer being built
   */
  def setInitialState(s : State) : Unit

  /**
   * A fresh state that can be added to the transducer
   */
  def getNewState : State

  /**
   * Set whether a state is accepting
   */
  def setAccept(s : State, isAccept : Boolean, outputOps : Seq[UpdateOp]) : Unit

  /**
   * Add a transition to the transducer
   */
  def addTransition(s1 : State,
                    lbl : TLabel,
                    ops : Seq[Seq[UpdateOp]],
                    s2 : State) : Unit

  /**
   * Add a e-transition to the transducer
   */
  def addETransition(s1 : State,
                    ops : Seq[Seq[UpdateOp]],
                    s2 : State) : Unit

  /**
   * The transducer built.  Builder should not be used after call to
   * this
   */
  def getTransducer : StreamingTransducer
}

