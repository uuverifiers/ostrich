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
  val vocabularyWidth : Int = 8  // really?

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
                         states : Iterator[(State, State)]) : Automaton = {
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
  def setInitAccept(s0 : State, sf : State) : Automaton = {
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
    (Char.MinValue, Char.MaxValue)

  /**
   * Intersection of two labels
   */
  def intersectLabels(l1 : TransitionLabel,
                      l2 : TransitionLabel) : TransitionLabel =
    (l1._1 max l2._1, l1._2 min l2._2)

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

  def getInitialState = underlying.getInitialState

  def getNewState = new BState

  /**
   * Assumes q1 already appears in the automaton
   */
  def addTransition(q1 : State, minMax : (Char, Char), q2 : State) : Unit = {
    val t = new Transition(minMax._1, minMax._2, q2)
    q1.addTransition(t)
    underlying.restoreInvariant
  }

  /**
   * Product this automaton with a number of given automaton.  Returns
   * new automaton.
   */
  def productWithMap(auts : Seq[AtomicStateAutomaton]) :
    (AtomicStateAutomaton, Map[State, (State, Seq[State])]) = {
    val bauts = auts.map(aut => aut match {
      case baut : BricsAutomaton => baut.underlying
      case _ => throw new IllegalArgumentException("BricsAutomaton can only product with BricsAutomata")
    })

    val newBAut = new BAutomaton
    val initBState = newBAut.getInitialState
    val sMap = new MHashMap[BState, (BState, Seq[BState])]
    val sMapRev = new MHashMap[(BState, Seq[BState]), BState]

    val initState = underlying.getInitialState
    val initStates = bauts.map(_.getInitialState)
    sMap += initBState -> (initState, initStates)
    sMapRev += (initState, initStates) -> initBState

    val worklist = MStack((initBState, (initState, initStates)))
    val seenlist = MHashSet[(BState, Seq[BState])]()
    while (!worklist.isEmpty) {
      val (bs, (s, ss)) = worklist.pop()

      // collects transitions from (s, ss)
      // min, max is current range
      // sp and ssp are s' and ss' (ss' is reversed for efficiency)
      // ss are elements of ss from which a transition is yet to be
      // searched
      def addTransitions(min : Char, max : Char,
                         sp : BState, ssp : List[BState],
                         ss : Seq[BState]) : Unit = {
        if (ss.size == 0) {
            val nextState = (sp, ssp.reverse)
            if (!seenlist.contains(nextState)) {
                val nextBState = new State
                nextBState.setAccept(sp.isAccept && ssp.forall(_.isAccept))
                sMap += nextBState -> nextState
                sMapRev += nextState -> nextBState
                worklist.push((nextBState, nextState))
                seenlist += nextState
            }
            val nextBState = sMapRev(nextState)
            bs.addTransition(new Transition(min, max, nextBState))
        } else {
            val ssTail = ss.tail
            ss.head.getTransitions.foreach(t => {
                val newMin = Math.max(min, t.getMin).toChar
                val newMax = Math.min(max, t.getMax).toChar
                val s = t.getDest
                if (newMin <= newMax)
                    addTransitions(newMin, newMax, sp, s::ssp, ssTail)
            })
        }
      }

      s.getTransitions.foreach(t =>
        addTransitions(t.getMin, t.getMax, t.getDest, List(), ss)
      )
    }

    (new BricsAutomaton(newBAut), sMap.toMap)
  }

  def getAcceptStates : Iterable[State] = underlying.getAcceptStates

  def getEmpty : BricsAutomaton = BricsAutomaton()

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
     * Initial state of the automaton being built
     */
    def getInitialState : BricsAutomaton#State =
      underlying match {
        case Some(aut) => aut.getInitialState
        case None => throw new RuntimeException("Automaton already returned")
      }

    /**
     * Add a new transition q1 --label--> q2
     */
    def addTransition(q1 : BricsAutomaton#State,
                      label : BricsAutomaton#TransitionLabel,
                      q2 : BricsAutomaton#State) : Unit = {
      val (min, max) = label
      q1.addTransition(new Transition(min, max, q2))
    }

    /**
     * Set state accepting
     */
    def setAccept(q : BricsAutomaton#State, isAccepting : Boolean) : Unit =
      q.setAccept(isAccepting)

    /**
     * Returns built automaton.  Can only be used once after which the
     * automaton cannot change
     */
    def getAutomaton : BricsAutomaton =
      underlying match {
        case Some(aut) => new BricsAutomaton(aut)
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

