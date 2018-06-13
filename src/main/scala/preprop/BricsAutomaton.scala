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

import strsolver.Regex2AFA

import ap.terfor.Term
import ap.terfor.preds.PredConj

import dk.brics.automaton.{BasicAutomata, BasicOperations, RegExp,
                           Automaton => BAutomaton, State => BState, Transition}

import scala.collection.JavaConversions.{asScalaIterator,
                                         iterableAsScalaIterable}
import scala.collection.mutable.{HashMap => MHashMap,
                                 HashSet => MHashSet,
                                 Stack => MStack,
                                 TreeSet => MTreeSet}

object BricsAutomaton {
  private def toBAutomaton(aut : Automaton) : BAutomaton = aut match {
    case that : BricsAutomaton =>
      that.underlying
    case _ =>
      throw new IllegalArgumentException
  }

  def apply(c : Term, context : PredConj) : BricsAutomaton = {
    val converter = new Regex2AFA(context)
    new BricsAutomaton(converter.buildBricsAut(c))
  }

  def apply() : BricsAutomaton = new BricsAutomaton(new BAutomaton)

  /**
   * A new automaton that accepts any string
   */
  def makeAnyString() : BricsAutomaton =
      new BricsAutomaton(BAutomaton.makeAnyString)


}

/**
 * Wrapper for the BRICS automaton class
 */
class BricsAutomaton(val underlying : BAutomaton) extends AtomicStateAutomaton {

  import BricsAutomaton.toBAutomaton

  type State = BState

  type TransitionLabel = (Char, Char)

  override def toString : String = underlying.toString

  /**
   * Keep track of disjoint labels for fast range lookups in
   * enumLabelOverlap.  Access with getDisjointLabels.
   *
   * Make sure to call resetDisjointLabels when updating transition
   * structure.
   */
  private var disjointLabels : Option[MTreeSet[TransitionLabel]] = None

  /**
   * Nr. of bits of letters in the vocabulary. Letters are
   * interpreted as numbers in the range <code>[0, 2^vocabularyWidth)</code>
   */
  val vocabularyWidth : Int = 16  // really?

  val minChar : Int = 0

  val maxChar : Int = Char.MaxValue - 1

  val internalChar : Int = Char.MaxValue

  /**
   * Union
   */
  def |(that : Automaton) : Automaton =
    new BricsAutomaton(BasicOperations.union(this.underlying,
                                             toBAutomaton(that)))

  /**
   * Intersection
   */
  def &(that : Automaton) : Automaton =
    new BricsAutomaton(BasicOperations.intersection(this.underlying,
                                                    toBAutomaton(that)))

  /**
   * Check whether this automaton describes the empty language.
   */
  def isEmpty : Boolean =
    underlying.isEmpty

  /**
   * Check whether the automaton accepts a given word.
   */
  def apply(word : Seq[Int]) : Boolean =
    BasicOperations.run(
      this.underlying,
      SeqCharSequence(for (c <- word.toIndexedSeq) yield c.toChar).toString)

  /**
   * Replace a-transitions with new a-transitions between pairs of states
   */
  def replaceTransitions(a : Char,
                         states : Iterator[(State, State)]) : AtomicStateAutomaton = {
    // A \ a-transitions
    val (newAut, map) = substWithStateMap((label, addTran) => {
      val (min, max) = label
      if (min <= a && a <= max)
        if (min < a) addTran((min, (a-1).toChar))
        if (a < max) addTran(((a+1).toChar, max))
      else
        addTran(label)
    })
    // (A \ a-transition) + {q1 -a-> q2 | (q1,q2) in box}
    for ((q1, q2) <- states)
      map(q1).addTransition(new Transition(a, a, map(q2)))

    newAut.underlying.restoreInvariant

    newAut
  }

  /**
   * Change initial and final states to s0 and sf respectively.  Returns
   * a new automaton.
   */
  def setInitAccept(s0 : State, sf : State) : AtomicStateAutomaton = {
      // TODO: painful to copy, can we improve?
      val (newAut, map) = cloneWithStateMap
      newAut.underlying.setInitialState(map(s0))
      newAut.underlying.getAcceptStates.foreach(_.setAccept(false))
      map(sf).setAccept(true)
      newAut.underlying.restoreInvariant
      newAut
  }

  /**
   * Iterate over automaton states
   */
  def getStates : Iterator[State] = underlying.getStates.iterator

  /**
   * The unique initial state
   */
  lazy val initialState : State = underlying.getInitialState

  /**
   * Given a state, iterate over all outgoing transitions
   */
  def outgoingTransitions(from : State) : Iterator[(State, TransitionLabel)] =
    for (t <- from.getTransitions.iterator)
    yield (t.getDest, (t.getMin, t.getMax))

  /**
   * The set of accepting states
   */
  lazy val acceptingStates : Set[State] =
    (for (s <- getStates; if s.isAccept) yield s).toSet

  /**
   * Check whether the given label accepts any letter
   */
  def isNonEmptyLabel(label : TransitionLabel) : Boolean =
    label._1 <= label._2

  /**
   * Label accepting all letters
   */
  val sigmaLabel : TransitionLabel =
    (minChar.toChar, maxChar.toChar)

  /**
   * Intersection of two labels
   */
  def intersectLabels(l1 : TransitionLabel,
                      l2 : TransitionLabel) : Option[TransitionLabel] = {
    Option(l1._1 max l2._1, l1._2 min l2._2).filter(isNonEmptyLabel(_))
  }

  /**
   * True if labels overlap
   */
  def labelsOverlap(l1 : TransitionLabel,
                    l2 : TransitionLabel) : Boolean = {
    val (min1, max1) = l1
    val (min2, max2) = l2
    (min2 <= max1 && max2 >= min1)
  }

  /**
   * Can l represent a?
   */
  def labelContains(a : Char, l : TransitionLabel) : Boolean = {
    val (min, max) = l
    (min <= a && a <= max)
  }

  /**
   * Enumerate all letters accepted by a transition label
   */
  def enumLetters(label : TransitionLabel) : Iterator[Int] =
    for (c <- (label._1 to label._2).iterator) yield c.toInt

  /**
   * Enumerate all labels with overlaps removed.
   * E.g. for min/max labels [1,3] [5,10] [8,15] would result in [1,3]
   * [5,8] [8,10] [10,15]
   */
  def enumDisjointLabels : Iterable[TransitionLabel] =
    getDisjointLabels.toIterable

  /**
   * iterate over the instances of lbls that overlap with lbl
   */
  def enumLabelOverlap(lbl : TransitionLabel) : Iterable[TransitionLabel] = {
    val (lMin, lMax) = lbl
    getDisjointLabels.
      from((lMin, Char.MinValue)).
      to((lMax, Char.MaxValue)).
      toIterable
  }

  /**
   * Get image of a set of states under a given label
   */
  def getImage(states : Set[State], lbl : TransitionLabel) : Set[State] = {
    for (s1 <- states;
         (s2, lbl2) <- outgoingTransitions(s1);
         if labelsOverlap(lbl, lbl2))
      yield s2
  }

  /**
   * Get image of a state under a given label
   */
  def getImage(s1 : State, lbl : TransitionLabel) : Set[State] = {
    outgoingTransitions(s1).collect({
      case (s2, lbl2) if (labelsOverlap(lbl, lbl2)) => s2
    }).toSet
  }

  /**
   * Apply f(q1, min, max, q2) to each transition q1 -[min,max]-> q2
   */
  def foreachTransition(f : (State, TransitionLabel, State) => Any) =
    for (q <- underlying.getStates; t <- q.getTransitions)
      f(q, (t.getMin, t.getMax), t.getDest)

  /**
   * Apply f(min, max, q2) to each transition q1 -[min,max]-> q2 from q1
   */
  def foreachTransition(q1 : State, f : (TransitionLabel, State) => Any) =
    for (t <- q1.getTransitions)
      f((t.getMin, t.getMax), t.getDest)

  /*
   * Get any word accepted by this automaton, or <code>None</code>
   * if the language is empty
   */
  def getAcceptedWord : Option[Seq[Int]] =
    (this.underlying getShortestExample true) match {
      case null => None
      case str  => Some(for (c <- str) yield c.toInt)
    }

  /**
   * Clone automaton, and also return a map telling how the
   * states are related
   */
  def cloneWithStateMap : (BricsAutomaton, Map[State, State]) =
    substWithStateMap((label, addTran) => addTran(label._1, label._2))

  /**
   * Subst aut and provides a mapping between equivalent states.
   *
   * Allows the transitions to be transformed via a function
   * transformTran(min, max, addTran), which can use addTran(newMin,
   * newMax) to replace transitions q --min, max--> q' with q --newMin,
   * newMax -> q' (can use addTran multiple times)
   *
   * @param transformTran a function processing transitions
   * @return (aut', map) where aut' is a clone of aut and map takes a
   * state of aut into its equivalent state in aut'
   */
  private def substWithStateMap(
    transformTran: (TransitionLabel, TransitionLabel => Unit) => Unit
  ) : (BricsAutomaton, Map[State, State]) = {
    val newAut = new BAutomaton
    val smap = new MHashMap[State, State]

    val states = underlying.getStates
    val s0 = underlying.getInitialState

    for (s <- states) {
      val p = new State
      p.setAccept(s.isAccept)
      smap += s -> p
    }
    for ((s, p) <- smap; t <- s.getTransitions)
      transformTran((t.getMin, t.getMax), {
        case (min, max) =>
          p.addTransition(new Transition(min, max, smap(t.getDest)))
      })
    newAut.setInitialState(smap(s0))
    newAut.restoreInvariant
    (new BricsAutomaton(newAut), smap.toMap)
  }

  def getNewState = new BState

  def isAccept(s : State) : Boolean = s.isAccept

  /**
   * Set state accepting
   */
  def setAccept(q : State, isAccepting : Boolean) : Unit =
    q.setAccept(isAccepting)

  private def calculateDisjointLabels() : MTreeSet[(Char,Char)] = {
    var disjoint = new MTreeSet[TransitionLabel]()

    val mins = new MTreeSet[Char]
    val maxes = new MTreeSet[Char]
    foreachTransition({ case (_, (min, max), _) =>
      mins += min
      maxes += max
    })

    val imin = mins.iterator
    val imax = maxes.iterator

    if (!imin.hasNext)
      return disjoint

    var curMin = imin.next
    var nextMax = imax.next
    while (imin.hasNext) {
      val nextMin = imin.next
      if (nextMin <= nextMax) {
        disjoint += ((curMin, (nextMin-1).toChar))
        curMin = nextMin
      } else {
        disjoint += ((curMin, nextMax))
        curMin = nextMin
        nextMax = imax.next
      }
    }

    disjoint += ((curMin, nextMax))
    curMin = (nextMax + 1).toChar

    while (imax.hasNext) {
      val nextMax = imax.next
      disjoint += ((curMin, nextMax))
      curMin = (nextMax + 1).toChar
    }

    disjoint
  }

  def getBuilder : BricsAutomatonBuilder = new BricsAutomatonBuilder

  /**
   * For constructing manually (immutable) BricsAutomaton objects
   */
  class BricsAutomatonBuilder extends AtomicStateAutomatonBuilder {

    var underlying : Option[BAutomaton] = Some(new BAutomaton)

    /**
     * Create a fresh state that can be used in the automaton
     */
    def getNewState : BricsAutomaton#State = new BState()

    /**
     * Add a new transition q1 --label--> q2
     */
    def addTransition(q1 : BricsAutomaton#State,
                      label : BricsAutomaton#TransitionLabel,
                      q2 : BricsAutomaton#State) : Unit = {
      if (isNonEmptyLabel(label)) {
        val (min, max) = label
        q1.addTransition(new Transition(min, max, q2))
      }
    }

    /**
     * Set state accepting
     */
    def setAccept(q : BricsAutomaton#State, isAccepting : Boolean) : Unit =
      q.setAccept(isAccepting)

    /**
     * Set the initial state
     */
    def setInitialState(q : BricsAutomaton#State) : Unit =
      underlying.get.setInitialState(q)

    /**
     * Returns built automaton.  Can only be used once after which the
     * automaton cannot change
     */
    def getAutomaton : BricsAutomaton =
      underlying match {
        case Some(aut) => {
          aut.restoreInvariant
          new BricsAutomaton(aut)
        }
        case None => throw new RuntimeException("Automaton already returned")
      }
  }

  /**
   * To be called whenever the transition structure changes as cached
   * disjoint labels will be outdated
   */
  private def resetDisjointLabels : Unit = disjointLabels = None

  private def getDisjointLabels : MTreeSet[TransitionLabel] =
    disjointLabels match {
      case Some(labels) => labels
      case None => {
        val labels = calculateDisjointLabels()
        disjointLabels = Some(labels)
        labels
      }
    }
}

