/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2018  Matthew Hague, Philipp Ruemmer
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

package strsolver.preprop

/**
 * Symbolic operations on input
 */
abstract class InputOp
/**
 * Delete input character
 */
case object Delete extends InputOp
/**
 * Change input character by shifting (+0 to copy)
 */
case class Plus(val n : Int) extends InputOp

/**
 * Output operations for Brics Transducers: (u, o, v) where u is a
 * string to output first, o is an operation to translate the character
 * being read, and v is a string to output after.
 *
 * o can be +n or del
 */
case class OutputOp(val preW : Seq[Char], val op : InputOp, val postW : Seq[Char])


trait Transducer extends Automaton { }

trait AtomicStateTransducer extends AtomicStateAutomaton with Transducer {
  outer =>

  /**
   * Calculates regular language that is pre-image of the given regular
   * language.  I.e. Pre_T(aut) for transducer T
   */
  def preImage(aut : AtomicStateAutomaton) : AtomicStateAutomaton
}

trait AtomicStateTransducerBuilder[State, TransitionLabel] {
  /**
   * Nr. of bits of letters in the vocabulary. Letters are
   * interpreted as numbers in the range <code>[0, 2^vocabularyWidth)</code>
   * See max/minChar and internalChar
   */
  val vocabularyWidth : Int

  /**
   * A minimum character value in the range given by vocabularyWidth
   */
  val minChar : Int

  /**
   * A minimum character value in the range given by vocabularyWidth
   */
  val maxChar : Int

  /**
   * A special character outside of [minChar, maxChar] for internal use
   */
  val internalChar : Int

  /**
   * Initial state of transducer being built
   */
  def initialState : State

  /**
   * A fresh state that can be added to the transducer
   */
  def getNewState : State

  /**
   * Set whether a state is accepting
   */
  def setAccept(s : State, isAccept : Boolean) : Unit

  /**
   * Add a transition to the transducer
   */
  def addTransition(s1 : State,
                    lbl : TransitionLabel,
                    op : OutputOp,
                    s2 : State) : Unit

  /**
   * The transducer built.  Builder should not be used after call to
   * this
   */
  def getTransducer : AtomicStateTransducer
}

