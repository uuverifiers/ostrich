/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2018-2020  Matthew Hague, Philipp Ruemmer
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

import dk.brics.automaton.{BasicAutomata, BasicOperations, RegExp, Transition,
                           Automaton => BAutomaton, State => BState}

import scala.collection.JavaConversions.{asScalaIterator,
                                         iterableAsScalaIterable}
import scala.collection.mutable.{HashMap => MHashMap,
                                 HashSet => MHashSet,
                                 LinkedHashSet => MLinkedHashSet,
                                 Stack => MStack,
                                 TreeSet => MTreeSet,
                                 MultiMap => MMultiMap,
                                 Set => MSet}

object BricsAutomaton {
  private def toBAutomaton(aut : Automaton) : BAutomaton = aut match {
    case that : BricsAutomaton =>
      that.underlying
    case that : AtomicStateAutomatonAdapter[_] =>
      toBAutomaton(that.internalise)
    case _ =>
      throw new IllegalArgumentException
  }

  def apply() : BricsAutomaton = new BricsAutomaton(new BAutomaton)

  /**
   * Build brics automaton from a regular expression in brics format
   */
  def apply(pattern: String): BricsAutomaton =
    new BricsAutomaton(new RegExp(pattern).toAutomaton(true))

  /**
   * Build brics automaton that accepts exactly the given word
   */
  def fromString(str : String) : BricsAutomaton =
    new BricsAutomaton(BasicAutomata makeString str)

  /**
   * A new automaton that accepts any string
   */
  def makeAnyString() : BricsAutomaton =
      new BricsAutomaton(BAutomaton.makeAnyString)

  /**
   * Check whether we should avoid ever minimising the given automaton.
   */
  def neverMinimize(aut : BAutomaton) : Boolean =
    aut.getSingleton != null || aut.getNumberOfStates > MINIMIZE_LIMIT

  private val MINIMIZE_LIMIT = 100000
}

object BricsTLabelOps extends TLabelOps[(Char, Char)] {

  val vocabularyWidth : Int = 16  // really?

  /**
   * Check whether the given label accepts any letter
   */
  def isNonEmptyLabel(label : (Char, Char)) : Boolean =
    label._1 <= label._2

  /**
   * Label accepting all letters
   */
  val sigmaLabel : (Char, Char) =
    (Char.MinValue, Char.MaxValue)

  def singleton(a : Char) = (a, a)

  /**
   * Intersection of two labels
   */
  def intersectLabels(l1 : (Char, Char),
                      l2 : (Char, Char)) : Option[(Char, Char)] = {
    Option(l1._1 max l2._1, l1._2 min l2._2).filter(isNonEmptyLabel(_))
  }

  /**
   * True if labels overlap
   */
  def labelsOverlap(l1 : (Char, Char),
                    l2 : (Char, Char)) : Boolean = {
    val (min1, max1) = l1
    val (min2, max2) = l2
    (min2 <= max1 && max2 >= min1)
  }

  /**
   * Can l represent a?
   */
  def labelContains(a : Char, l : (Char, Char)) : Boolean = {
    val (min, max) = l
    (min <= a && a <= max)
  }

  /**
   * Enumerate all letters accepted by a transition label
   */
  def enumLetters(label : (Char, Char)) : Iterator[Int] =
    for (c <- (label._1 to label._2).iterator) yield c.toInt

  /**
   * Remove a given character from the label.  E.g. [1,10] - 5 is
   * [1,4],[6,10]
   */
  def subtractLetter(a : Char, lbl : (Char, Char)) : Iterable[(Char, Char)] = {
    val (min, max) = lbl
    if (min <= a && a <= max) {
      // surely a cuter solution than this exists...
      var res = List[(Char, Char)]()
      if (min < a)
        res = (min, (a-1).toChar)::res
      if (a < max)
        res = ((a+1).toChar, max)::res
      res
    } else {
      Seq(lbl)
    }
  }

  def subtractLetters(as : Iterable[Char],
                      lbl : (Char, Char)) : Iterable[(Char, Char)] = {
    val (min, max) = lbl
    var curMax = max
    var res = List[(Char, Char)]()

    // reverse order for list pushing
    val revSortedChars : List[Char] = as.toList.sortWith(_ > _)

    for (a <- revSortedChars) {
      if (a < min)
        return (min, curMax)::res

      if (a < curMax)
        res = ((a+1).toChar, curMax)::res

      curMax = (a-1).toChar
      if (curMax < min)
        return res
    }

    return (min, curMax)::res
  }

  /**
   * Shift characters by n, do not wrap.  E.g. [1,2].shift 3 = [4,5]
   */
  def shift(lbl : (Char, Char), n : Int) : (Char, Char) = {
    val (cmin, cmax) = lbl
    (Math.max(Char.MinValue, cmin + n).toChar,
     Math.min(Char.MaxValue, cmax + n).toChar)
  }

  /**
   * Get representation of interval [min,max]
   */
  def interval(min : Char, max : Char) : (Char, Char) = (min, max)
}

class BricsTLabelEnumerator(labels: Iterator[(Char, Char)])
    extends TLabelEnumerator[(Char, Char)] {
  /**
   * Keep track of disjoint labels for fast range lookups in
   * enumLabelOverlap.  Access with enumDisjointlabels.
   */
  private lazy val disjointLabels : MTreeSet[(Char, Char)] =
    calculateDisjointLabels
  /**
   * Like disjoint labels but covers whole alphabet including internal
   * char.
   */
  private lazy val disjointLabelsComplete : List[(Char, Char)] =
    calculateDisjointLabelsComplete

  /**
   * Enumerate all labels with overlaps removed.
   * E.g. for min/max labels [1,3] [5,10] [8,15] would result in [1,3]
   * [5,8] [8,10] [10,15]
   */
  def enumDisjointLabels : Iterable[(Char, Char)] =
    disjointLabels.toIterable

  /**
   * Enumerate all labels with overlaps removed such that the whole
   * alphabet is covered (including internal characters)
   * E.g. for min/max labels [1,3] [5,10] [8,15] would result in [1,3]
   * [4,4] [5,7] [8,10] [11,15] [15,..]
   */
  def enumDisjointLabelsComplete : Iterable[(Char, Char)] =
    disjointLabelsComplete

  /**
   * iterate over the instances of lbls that overlap with lbl
   */
  def enumLabelOverlap(lbl : (Char, Char)) : Iterable[(Char, Char)] = {
    val (lMin, lMax) = lbl
    disjointLabels.
      from((lMin, Char.MinValue)).
      to((lMax, Char.MaxValue)).
      toIterable
  }

  /**
   * Takes disjoint enumeration and splits it at the point defined by
   * Char.  E.g. [1,10] split at 5 is [1,4][5][6,10]
   */
  def split(a : Char) : TLabelEnumerator[(Char, Char)] =
    new BricsTLabelEnumerator(disjointLabels.iterator ++ Iterator((a, a)))

  private def calculateDisjointLabels() : MTreeSet[(Char,Char)] = {
    var disjoint = new MTreeSet[(Char, Char)]()

    val mins = new MTreeSet[Char]
    val maxes = new MTreeSet[Char]
    for ((min, max) <- labels) {
      mins += min
      maxes += max
    }

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

  private def calculateDisjointLabelsComplete() : List[(Char, Char)] = {
    val labelsComp = disjointLabels.foldRight(List[(Char, Char)]()) {
      case ((min, max), Nil) => {
        // using Char.MaxValue since we include internal chars
        if (max < Char.MaxValue)
          List((min,max), ((max + 1).toChar, Char.MaxValue))
        else
          List((min, max))
      }
      case ((min, max), (minLast, maxLast)::lbls) => {
        val minLastPrev = (minLast - 1).toChar
        if (max < minLastPrev)
          (min, max)::((max + 1).toChar, minLastPrev)::(minLast, maxLast)::lbls
        else
          (min, max)::(minLast, maxLast)::lbls
      }
    }
    if (Char.MinValue < labelsComp.head._1) {
      val nextMin = (labelsComp.head._1 - 1).toChar
      (Char.MinValue, nextMin)::labelsComp
    } else {
      labelsComp
    }
  }
}

/**
 * Wrapper for the BRICS automaton class
 */
class BricsAutomaton(val underlying : BAutomaton) extends AtomicStateAutomaton {

  import BricsAutomaton.toBAutomaton

//  Console.err.println("Automata states: " + underlying.getNumberOfStates)

  type State = BState
  type TLabel = (Char, Char)

  override val LabelOps = BricsTLabelOps

  override def toString : String = underlying.toString

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
   * Complementation
   */
  def unary_! : Automaton =
    new BricsAutomaton(BasicOperations.complement(this.underlying))

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
   * Iterate over automaton states, return in deterministic order
   */
  lazy val states : Iterable[State] = {
    // do this the hard way to give a deterministic ordering
    val worklist = new MStack[State]
    val seenstates = new MLinkedHashSet[State]

    worklist.push(initialState)
    seenstates.add(initialState)

    while(!worklist.isEmpty) {
      val s = worklist.pop

      val dests = new MHashMap[TLabel, MSet[State]] with MMultiMap[TLabel, State]

      for ((to, _) <- outgoingTransitions(s)) {
        if (!seenstates.contains(to)) {
          worklist.push(to)
          seenstates += to
        }
      }
    }

    seenstates
  }

  /**
   * The unique initial state
   */
  lazy val initialState : State = underlying.getInitialState

  /**
   * Given a state, iterate over all outgoing transitions, try to be
   * deterministic
   */
  def outgoingTransitions(from : State) : Iterator[(State, TLabel)] = {
    val dests = new MHashMap[TLabel, MSet[State]] with MMultiMap[TLabel, State]

    for (t <- from.getTransitions)
      dests.addBinding((t.getMin, t.getMax), t.getDest)

    val outgoing = new MLinkedHashSet[(State, TLabel)]

    for (lbl <- dests.keys.toList.sorted) {

      def sortingFn(s1 : State, s2 : State) : Boolean = {
        // sort by lowest outgoing transition
        for ((t1, t2) <- s1.getSortedTransitions(false)
                         zip
                         s2.getSortedTransitions(false)) {
          import scala.math.Ordering.Implicits._
          val lbl1 = (t1.getMin, t1.getMax)
          val lbl2 = (t2.getMin, t2.getMax)
          if (lbl1 < lbl2)
            return true
          else if (lbl2 < lbl1)
            return false
        }
        // if all else fails, make an arbitrary choice
        return true
      }

      val sortedDests = dests(lbl).toList.sortWith(sortingFn)

      for (s <- sortedDests) {
        outgoing += ((s, lbl))
      }
    }

    outgoing.iterator
  }

  /**
   * The set of accepting states
   */
  lazy val acceptingStates : Set[State] =
    (for (s <- states; if s.isAccept) yield s).toSet

  lazy val labelEnumerator =
    new BricsTLabelEnumerator(for ((_, lbl, _) <- transitions) yield lbl)

  /*
   * Get any word accepted by this automaton, or <code>None</code>
   * if the language is empty
   */
  def getAcceptedWord : Option[Seq[Int]] =
    (this.underlying getShortestExample true) match {
      case null => None
      case str  => Some(for (c <- str) yield c.toInt)
    }

  def isAccept(s : State) : Boolean = s.isAccept

  def toDetailedString : String = underlying.toString

  def getBuilder : BricsAutomatonBuilder = new BricsAutomatonBuilder

  def getTransducerBuilder : BricsTransducerBuilder = BricsTransducer.getBuilder
}


/**
 * For constructing manually (immutable) BricsAutomaton objects
 */
class BricsAutomatonBuilder
    extends AtomicStateAutomatonBuilder[BricsAutomaton#State,
                                        BricsAutomaton#TLabel] {
  val LabelOps : TLabelOps[BricsAutomaton#TLabel] = BricsTLabelOps

  var minimize = true

  val baut : BAutomaton = {
    val baut = new BAutomaton
    baut.setDeterministic(false)
    baut
  }

  /**
   * The initial state of the automaton being built
   */
  def initialState : BricsAutomaton#State = baut.getInitialState

  /**
   * By default one can assume built automata are minimised before the
   * are returned.  Use this to enable or disable it
   */
  def setMinimize(minimize : Boolean) : Unit = { this.minimize = minimize }

  /**
   * Create a fresh state that can be used in the automaton
   */
  def getNewState : BricsAutomaton#State = new BState()

  /**
   * Set the initial state
   */
  def setInitialState(q : BricsAutomaton#State) : Unit =
    baut.setInitialState(q)

  /**
   * Add a new transition q1 --label--> q2
   */
  def addTransition(q1 : BricsAutomaton#State,
                    label : BricsAutomaton#TLabel,
                    q2 : BricsAutomaton#State) : Unit = {
    if (LabelOps.isNonEmptyLabel(label)) {
      val (min, max) = label
      q1.addTransition(new Transition(min, max, q2))
    }
  }

  def outgoingTransitions(q : BricsAutomaton#State)
        : Iterator[(BricsAutomaton#State, BricsAutomaton#TLabel)] =
    for (t <- q.getTransitions.iterator)
      yield (t.getDest, (t.getMin, t.getMax))

  def setAccept(q : BricsAutomaton#State, isAccepting : Boolean) : Unit =
    q.setAccept(isAccepting)

  def isAccept(q : BricsAutomaton#State) : Boolean = q.isAccept

  /**
   * Returns built automaton.  Can only be used once after which the
   * automaton cannot change
   */
  def getAutomaton : BricsAutomaton = {
    baut.restoreInvariant
    if (minimize && !BricsAutomaton.neverMinimize(baut))
      baut.minimize
    new BricsAutomaton(baut)
  }
}


