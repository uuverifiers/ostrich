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
 * Interface for different implementations of finite-state automata.
 */
trait Automaton {

  /**
   * Nr. of bits of letters in the vocabulary. Letters are
   * interpreted as numbers in the range <code>[0, 2^vocabularyWidth)</code>
   */
  val vocabularyWidth : Int

  /**
   * Union
   */
  def |(that : Automaton) : Automaton

  /**
   * Intersection
   */
  def &(that : Automaton) : Automaton

  /**
   * Check whether this automaton accepts any word.
   */
  def isEmpty : Boolean

  /**
   * Check whether the automaton accepts a given word.
   */
  def apply(word : Seq[Int]) : Boolean

  /**
   * Get any word accepted by this automaton, or <code>None</code>
   * if the language is empty
   */
  def getAcceptedWord : Option[Seq[Int]]

}

////////////////////////////////////////////////////////////////////////////////

/**
 * Trait for automata with atomic/nominal states; i.e., states
 * don't have any structure and are not composite, there is a unique
 * initial state, and a set of accepting states.
 */
trait AtomicStateAutomaton extends Automaton {
  /**
   * Type of states
   */
  type State

  /**
   * Type of labels on transitions
   * (e.g., concrete letters, intervals, bit-vector formulas)
   */
  type TransitionLabel

  /**
   * Iterate over automaton states
   */
  def getStates : Iterator[State]

  /**
   * The unique initial state
   */
  val initialState : State

  /**
   * The set of accepting states
   */
  val acceptingStates : Set[State]

  /**
   * Given a state, iterate over all outgoing transitions
   */
  def outgoingTransitions(from : State) : Iterator[(State, TransitionLabel)]

  /**
   * Enumerate all letters accepted by a transition label
   */
  def enumLetters(label : TransitionLabel) : Iterator[Int]

  /*
   * Replace a-transitions with new a-transitions between pairs of
   * states.  Returns a new automaton.
   */
  def replaceTransitions(a : Char,
                         states : Iterator[(State, State)]) : Automaton

  /**
   * Change initial and final states to s0 and sf respectively.  Returns a new
   * automaton.
   */
  def setInitAccept(s0 : State, sf : State) : Automaton

  /**
   * Apply f(q1, min, max, q2) to each transition q1 -[min,max]-> q2
   */
  def foreachTransition(f : (State, TransitionLabel, State) => Any)
}