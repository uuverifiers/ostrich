/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ap.basetypes.IdealInt
import ap.PresburgerTools
import ap.terfor.{Formula, Term, TerForConvenience, TermOrder, OneTerm}
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.conjunctions.{Conjunction, ReduceWithConjunction}

import scala.collection.mutable.{
  BitSet => MBitSet,
  HashMap => MHashMap,
  HashSet => MHashSet,
  ArrayStack
}

import ap.{SimpleAPI}
import ap.parser.{IExpression, IFormula}
import ap.terfor.{TerForConvenience, Formula}
import ap.terfor.substitutions.ConstantSubst

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
   * Complementation
   */
  def unary_! : Automaton

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

  /**
   * Compute the length abstraction of this automaton.
   */
  def getLengthAbstraction : IFormula

}

////////////////////////////////////////////////////////////////////////////////


trait TLabelOps[TLabel] {
  /**
   * Nr. of bits of letters in the vocabulary.
   */
  def vocabularyWidth : Int

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

  /**
   * Remove a given character from the label.  E.g. [1,10] - 5 is
   * [1,4],[6,10]
   */
  def subtractLetters(as : Iterable[Char], l : TLabel) : Iterable[TLabel]

  /**
   * Shift characters by n, do not wrap.  E.g. [1,2].shift 3 = [4,5]
   */
  def shift(lbl : TLabel, n : Int) : TLabel

  /**
   * Get representation of interval [min,max]
   */
  def interval(min : Char, max : Char) : TLabel
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

  /**
   * Takes disjoint enumeration and splits it at the point defined by
   * Char.  E.g. [1,10] split at 5 is [1,4][5][6,10]
   */
  def split(a : Char) : TLabelEnumerator[TLabel]
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
  def getTransducerBuilder : TransducerBuilder[State, TLabel]

  /**
   * String representation of automaton in full gory detail
   */
  def toDetailedString : String

  //////////////////////////////////////////////////////////////////////////
  // Derived methods

  class AutomatonGraph(val aut: AtomicStateAutomaton)
      extends Graphable[State, TLabel] {

    def allNodes() = states.to
    def edges() = transitions.to
    def transitionsFrom(node: State) =
      outgoingTransitions(node).map(t => (node, t._2, t._1)).toSeq
    // FIXME this is ugly we should *not* change type
    def subgraph(selectedNodes: Set[State]): Graphable[State, TLabel] =
      this.dropEdges(Set()).subgraph(selectedNodes)
    def dropEdges(edgesToDrop: Set[(State, TLabel, State)]) = {
      new MapGraph(edges.toSet &~ edgesToDrop)
    }

    def addEdges(edgesToAdd: Iterable[(State, TLabel, State)]) = {
      val selectedEdges: Set[(State, TLabel, State)] = this
        .edges()
        .toSet ++ edgesToAdd
      new MapGraph(selectedEdges.toSeq)
    }
  }

  lazy val toGraph = new AutomatonGraph(this)

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

  /**
   * Compute states that can only be reached through words with some
   * unique length
   */
  lazy val uniqueLengthStates : Map[State, Int] = {
    val uniqueLengthStates = new MHashMap[State, Int]
    val nonUniqueLengthStates = new MHashSet[State]
    val todo = new ArrayStack[State]

    uniqueLengthStates.put(initialState, 0)
    todo push initialState

    while (!todo.isEmpty) {
      val s = todo.pop
      if (nonUniqueLengthStates contains s) {
        for ((to, _) <- outgoingTransitions(s)) {
          uniqueLengthStates -= to
          if (nonUniqueLengthStates add to)
            todo push to
        }
      } else {
        val sLen = uniqueLengthStates(s)
        for ((to, _) <- outgoingTransitions(s))
          (uniqueLengthStates get to) match {
            case Some(oldLen) =>
              if (oldLen != sLen + 1) {
                uniqueLengthStates -= to
                nonUniqueLengthStates += to
                todo push to
              }
            case None =>
              if (!(nonUniqueLengthStates contains to)) {
                uniqueLengthStates.put(to, sLen + 1)
                todo push to
              }
        }
      }
    }

    uniqueLengthStates.toMap
  }

  /**
   * Field that is defined if the automaton only accepts words of some length l
   * (and the language accepted by the automaton is non-empty)
   */
  lazy val uniqueAcceptedWordLength : Option[Int] = {
    val lengths = for (s <- acceptingStates) yield (uniqueLengthStates get s)
    if (lengths.size == 1 && !(lengths contains None))
      lengths.iterator.next
    else
      None
  }

  /**
   * Compute the length abstraction of this automaton.
   */
  lazy val getLengthAbstraction: IFormula = {
    val length = IExpression.v(0)
    (new ParikhTheory(this)) allowsRegisterValues Seq(length)
  }
}

trait AtomicStateAutomatonBuilder[State, TLabel] {
  /**
   * Operations on labels
   */
  val LabelOps : TLabelOps[TLabel]

  /**
   * By default one can assume built automata are minimised before the
   * are returned.  Use this to enable or disable it
   */
  def setMinimize(minimize : Boolean) : Unit

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
   * Iterate over outgoing transitions from state
   */
  def outgoingTransitions(q : State) : Iterator[(State, TLabel)]

  /**
   * Ask if state is accepting
   */
  def isAccept(q : State) : Boolean

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
