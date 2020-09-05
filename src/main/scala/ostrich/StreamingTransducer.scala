/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2020  Zhilei Han
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
  def preImage(aut : BricsAutomaton) : AtomicStateAutomaton =
    preImage(aut, Iterable.empty[(aut.State, aut.State)])

  /**
   * Calculates regular language that is pre-image of the given regular
   * language.  I.e. Pre_T(aut) for transducer T
   *
   * internal is a map indicating which states should be considered to
   * have an Internal character between them.  I.e. map(s) contains s'
   * if there is an internal transition between s and s'
   */
  def preImage[A <: BricsAutomaton]
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

