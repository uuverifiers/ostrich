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


trait TLabelOps[TLabel] {
  /**
   * Nr. of bits of letters in the vocabulary. Letters are
   * interpreted as numbers in the range <code>[0, 2^vocabularyWidth)</code>
   * See max/minChar and internalChar
   */
  def vocabularyWidth : Int

  /**
   * A minimum character value in the range given by vocabularyWidth
   */
  def minChar : Int

  /**
   * A minimum character value in the range given by vocabularyWidth
   */
  def maxChar : Int

  /**
   * A special character outside of [minChar, maxChar] for internal use
   */
  def internalChar : Int

  /**
   * Check whether the given label accepts some letter
   */
  def isNonEmptyLabel(label : TLabel) : Boolean

  /**
   * Label accepting all letters
   */
  val sigmaLabel : TLabel

  /**
   * Label representing a single char a
   */
  def singleton(a : Char) : TLabel

  /**
   * Intersection of two labels, None if not overlapping
   */
  def intersectLabels(l1 : TLabel,
                      l2 : TLabel) : Option[TLabel]

  /**
   * True if labels overlap
   */
  def labelsOverlap(l1 : TLabel,
                    l2 : TLabel) : Boolean

  /**
   * Can l represent a?
   */
  def labelContains(a : Char, l : TLabel) : Boolean

  /**
   * Enumerate all letters accepted by a transition label
   */
  def enumLetters(label : TLabel) : Iterator[Int]

  /**
   * Remove a given character from the label.  E.g. [1,10] - 5 is
   * [1,4],[6,10]
   */
  def subtractLetter(a : Char, l : TLabel) : Iterable[TLabel]
}

/**
 * A label enumerator is used to enumerate labels appearing in an
 * automaton and derived label sets
 */
trait TLabelEnumerator[TLabel] {
  /**
   * Enumerate all labels with overlaps removed.
   * E.g. for min/max labels [1,3] [5,10] [8,15] would result in [1,3]
   * [5,7] [8,10] [11,15]
   */
  def enumDisjointLabels : Iterable[TLabel]

  /**
   * Enumerate all labels with overlaps removed such that the whole
   * alphabet is covered (including internal characters)
   * E.g. for min/max labels [1,3] [5,10] [8,15] would result in [1,3]
   * [4,4] [5,7] [8,10] [11,15] [15,..]
   */
  def enumDisjointLabelsComplete : Iterable[TLabel]

  /**
   * iterate over disjoint labels of the automaton that overlap with lbl
   */
  def enumLabelOverlap(lbl : TLabel) : Iterable[TLabel]
}

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
   * Type of labels
   */
  type TLabel

  /**
   * Operations on labels
   */
  val LabelOps : TLabelOps[TLabel]

  /**
   * Iterate over automaton states
   */
  def states : Iterable[State]

  /**
   * The unique initial state
   */
  val initialState : State

  /**
   * The set of accepting states
   */
  val acceptingStates : Set[State]

  /**
   * To enumerate the labels used
   */
  val labelEnumerator : TLabelEnumerator[TLabel]

  /**
   * Given a state, iterate over all outgoing transitions
   */
  def outgoingTransitions(from : State) : Iterator[(State, TLabel)]

  /**
   * Test if state is accepting
   */
  def isAccept(s : State) : Boolean

  /**
   * Return new automaton builder of compatible type
   */
  def getBuilder : AtomicStateAutomatonBuilder[State, TLabel]

  /**
   * Return new automaton builder of compatible type
   */
  def getTransducerBuilder : AtomicStateTransducerBuilder[State, TLabel]

  //////////////////////////////////////////////////////////////////////////
  // Derived methods

  /**
   * Iterate over all transitions
   */
  def transitions : Iterator[(State, TLabel, State)] =
    for (s1 <- states.iterator; (s2, lbl) <- outgoingTransitions(s1))
      yield (s1, lbl, s2)

  /**
   * Get image of a set of states under a given label
   */
  def getImage(states : Set[State], lbl : TLabel) : Set[State] = {
    for (s1 <- states;
         (s2, lbl2) <- outgoingTransitions(s1);
         if LabelOps.labelsOverlap(lbl, lbl2))
      yield s2
  }

  /**
   * Get image of a state under a given label
   */
  def getImage(s1 : State, lbl : TLabel) : Set[State] = {
    outgoingTransitions(s1).collect({
      case (s2, lbl2) if (LabelOps.labelsOverlap(lbl, lbl2)) => s2
    }).toSet
  }
}

trait AtomicStateAutomatonBuilder[State, TLabel] {
  /**
   * Operations on labels
   */
  val LabelOps : TLabelOps[TLabel]

  /**
   * The initial state of the automaton being built
   */
  def initialState : State

  /**
   * Create a fresh state that can be used in the automaton
   */
  def getNewState : State

  /**
   * Set the initial state
   */
  def setInitialState(q : State) : Unit

  /**
   * Add a new transition q1 --label--> q2
   */
  def addTransition(s1 : State, label : TLabel, s2 : State) : Unit

  /**
   * Set state accepting
   */
  def setAccept(s : State, isAccepting : Boolean) : Unit

  /**
   * Returns built automaton.  Can only be used once after which the
   * automaton cannot change
   */
  def getAutomaton : AtomicStateAutomaton
}
