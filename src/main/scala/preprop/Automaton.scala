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

import ap.basetypes.IdealInt
import ap.terfor.{Formula, Term, TerForConvenience, TermOrder, OneTerm}
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.conjunctions.{Conjunction, ReduceWithConjunction}

import scala.collection.mutable.{BitSet => MBitSet}

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

  /**
   * Compute the length abstraction of this automaton.
   */
  def getLengthAbstraction : Formula

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

  /**
   * Compute the length abstraction of this automaton. Special case of
   * Parikh images, following the procedure in Verma et al, CADE 2005
   */
  lazy val getLengthAbstraction : Formula = Exploration.measure("length abstraction") {
    import TerForConvenience._
    implicit val order = TermOrder.EMPTY

    val stateSeq = states.toIndexedSeq
    val state2Index = stateSeq.iterator.zipWithIndex.toMap

    val preStates, transPreStates = Array.fill(stateSeq.size)(new MBitSet)

    for ((from, _, to) <- transitions)
      preStates(state2Index(to)) += state2Index(from)

    for ((s1, s2) <- preStates.iterator zip transPreStates.iterator)
      s2 ++= s1

    for ((s, n) <- transPreStates.iterator.zipWithIndex)
      s += n

    {
      // fixed-point iterator, to find transitively referenced states
      var changed = true
      while (changed) {
        changed = false

        for (i <- 0 until transPreStates.size) {
          val set = transPreStates(i)

          val oldSize = set.size
          for (j <- 0 until transPreStates.size)
            if (set contains j)
              set |= transPreStates(j)

          if (set.size > oldSize)
            changed = true
        }
      }
    }

    val initialStateInd = state2Index(initialState)

    disj(for (finalState <- acceptingStates) yield {
      val finalStateInd = state2Index(finalState)
      val refStates = transPreStates(finalStateInd)

      val productions : List[(Int, Option[Int])] =
        (if (refStates contains initialStateInd)
           List((initialStateInd, None))
         else List()) :::
        (for (state <- refStates.iterator;
              preState <- preStates(state).iterator)
         yield (state, Some(preState))).toList

      val (prodVars, zVars, sizeVar) = {
        val prodVars = for ((_, num) <- productions.zipWithIndex) yield v(num)
        var nextVar = prodVars.size
        val zVars = (for (state <- refStates.iterator) yield {
          val ind = nextVar
          nextVar = nextVar + 1
          state -> v(ind)
        }).toMap
        (prodVars, zVars, v(nextVar))
      }

      // equations relating the production counters
      val prodEqs =
        (for (state <- refStates.iterator) yield {
          LinearCombination(
             (if (state == finalStateInd)
                Iterator((IdealInt.ONE, OneTerm))
              else
                Iterator.empty) ++
             (for (((source, targets), prodVar) <-
                      productions.iterator zip prodVars.iterator;
                    mult = (if (targets contains state) 1 else 0) -
                           (if (source == state) 1 else 0))
              yield (IdealInt(mult), prodVar)),
             order)
        }).toList

      val sizeEq =
        LinearCombination(
          (for (((_, Some(_)), v) <- productions.iterator zip prodVars.iterator)
           yield (IdealInt.ONE, v)) ++
          Iterator((IdealInt.MINUS_ONE, sizeVar)),
          order)

      val entryZEq =
        zVars(finalStateInd) - 1

      val allEqs = eqZ(entryZEq :: sizeEq :: prodEqs)

      val prodNonNeg =
        prodVars >= 0

      val prodImps =
        (for (((source, _), prodVar) <-
                productions.iterator zip prodVars.iterator;
              if source != finalStateInd)
         yield ((prodVar === 0) | (zVars(source) > 0))).toList

      val zImps =
        (for (state <- refStates.iterator; if state != finalStateInd) yield {
           disjFor(Iterator(zVars(state) === 0) ++
                   (for (((source, targets), prodVar) <-
                           productions.iterator zip prodVars.iterator;
                         if targets contains state)
                    yield conj(zVars(state) === zVars(source) + 1,
                               geqZ(List(prodVar - 1, zVars(source) - 1)))))
         }).toList

      val matrix =
        conj(allEqs :: prodNonNeg :: prodImps ::: zImps)
      val rawConstraint =
        exists(prodVars.size + zVars.size, matrix)
      val constraint =
        ReduceWithConjunction(Conjunction.TRUE, order)(rawConstraint)

      constraint
    })
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
   * Iterate over outgoing transitions from state
   */
  def outgoingTransitions(q : State) : Iterator[(State, TLabel)]

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
