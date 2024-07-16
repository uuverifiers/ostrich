/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2024 Matthew Hague, Philipp Ruemmer, Oliver Markgraf. All rights reserved.
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

package ostrich.automata

import ostrich.OFlags
import dk.brics.automaton.{BasicAutomata, BasicOperations, RegExp, Transition, Automaton => BAutomaton, State => BState}
import ostrich.automata.AutomataUtils.buildEpsilons

import scala.collection.JavaConversions.{asScalaIterator, iterableAsScalaIterable}
import scala.collection.mutable.{HashMap => MHashMap, HashSet => MHashSet, LinkedHashSet => MLinkedHashSet, MultiMap => MMultiMap, Set => MSet, Stack => MStack, TreeSet => MTreeSet}

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
   * Build brics automaton that accepts exactly the prefixes of the given
   * string.
   */
  def prefixAutomaton(str : String) : BricsAutomaton = {
    val builder = new BricsAutomatonBuilder

    val states =
      (for (n <- 0 to str.size) yield builder.getNewState).toIndexedSeq

    builder setInitialState states(0)

    for ((c, n) <- str.iterator.zipWithIndex)
      builder.addTransition(states(n),
                            builder.LabelOps singleton c,
                            states(n+1))

    for (s <- states)
      builder.setAccept(s, true)

    builder.getAutomaton
  }

  /**
   * Build brics automaton that accepts exactly the suffix of the given
   * string.
   */
  def suffixAutomaton(str : String) : BricsAutomaton = {
    val builder = new BricsAutomatonBuilder

    val states =
      (for (n <- 0 to str.length) yield builder.getNewState).toIndexedSeq

    builder setInitialState states(0)

    for ((c, n) <- str.iterator.zipWithIndex)
      builder.addTransition(states(n),
        builder.LabelOps singleton c,
        states(n+1))

    builder.setAccept(states(str.length), true)

    val epsilons = new MHashMap[BState, MSet[BState]]()
                    with MMultiMap[BState , BState]

    for (n <- 1 to str.length)
      epsilons.addBinding(states(0), states(n))
    buildEpsilons(builder, epsilons)

    builder.getAutomaton
  }

  /**
   * Build brics automaton that accepts exactly the suffix of the given
   * string.
   */
  def containsAutomaton(str : String) : BricsAutomaton = {
    val builder = new BricsAutomatonBuilder

    val states =
      (for (n <- 0 to str.length) yield builder.getNewState).toIndexedSeq

    builder setInitialState states(0)

    for ((c, n) <- str.iterator.zipWithIndex)
      builder.addTransition(states(n),
        builder.LabelOps singleton c,
        states(n+1))

    for (s <- states)
      builder.setAccept(s, true)

    val epsilons = new MHashMap[BState, MSet[BState]]()
      with MMultiMap[BState , BState]

    for (n <- 1 to str.length) {
      epsilons.addBinding(states(0), states(n))
      epsilons.addBinding(states(n),states(str.length))
    }
    buildEpsilons(builder, epsilons)

    builder.getAutomaton
  }

  /**
   * A new automaton that accepts any string
   */
  def makeAnyString() : BricsAutomaton =
      new BricsAutomaton(BAutomaton.makeAnyString)

  def eqLengthAutomata(length : Int) : BricsAutomaton = {
    val builder = new BricsAutomatonBuilder

    val states =
      (for (n <- 0 to length) yield builder.getNewState).toIndexedSeq


    builder.setInitialState(states(0))
    for (i <- 0 until length){
      builder.addTransition(states(i), BricsTLabelOps.sigmaLabel,states(i+1))
    }
    builder.setAccept(states(length), isAccepting = true)
    builder.getAutomaton
  }

  def boundedLengthAutomata(lowerBound : Int,
                            upperBound : Option[Int]) : BricsAutomaton = {
    val upperBoundValue = upperBound.getOrElse(-1)
    val numberOfStates = math.max(lowerBound,upperBoundValue)

    val builder = new BricsAutomatonBuilder
    // lb k -> have k+1 states and last state with sigma and accept
    // ub k -> return k+1 states, every state up to k accept, no loop on last
    val states =
      (for (_ <- 0 to numberOfStates) yield builder.getNewState).toIndexedSeq

    builder.setInitialState(states(0))
    for (i <- 0 until numberOfStates){
      builder.addTransition(states(i), BricsTLabelOps.sigmaLabel,states(i+1))
      if (i >= lowerBound && i <= upperBoundValue){
        builder.setAccept(states(i), isAccepting = true)
      }
    }
    builder.setAccept(states(numberOfStates), isAccepting = true)
    // no upper bound -> last state has loop
    if (upperBoundValue == -1){
      builder.addTransition(states(numberOfStates),
                            BricsTLabelOps.sigmaLabel,states(numberOfStates))
    }
    builder.getAutomaton
  }

  /**
   * A new automaton that accepts all strings x <= str (lexicographical ordering)
   */

  def smallerEqAutomaton(str : String) : BricsAutomaton = {
    /*
    Initial state is accepting.
    Have one accepting sink state where every letter can be read because we are already smaller.
    Have additional state per char 'c' in the string to check for equality.
      Each of those additional states have one transition to the sink state reading ['c'+1, 65535]
      Each of those additional states have one transition to the next state reading ['c', 'c']
    The last state has no outgoing transitions.
     */
    val builder = new BricsAutomatonBuilder
    val initital_state = builder.getNewState

    builder.setInitialState(initital_state)
    builder.setAccept(initital_state, isAccepting = true)
    if (str.isEmpty){
      return builder.getAutomaton
    }

    val sink_state = builder.getNewState
    builder.setAccept(sink_state, isAccepting = true)


    val first_letter = str.head

    builder.addTransition(initital_state, builder.LabelOps.interval(Char.MinValue, (first_letter-1).toChar), sink_state)
    builder.addTransition(sink_state, builder.LabelOps.sigmaLabel, sink_state)

    val states =
      (for (n <- 0 until str.length) yield builder.getNewState).toIndexedSeq

    // add transition to rest of the automaton
    builder.addTransition(initital_state, builder.LabelOps.singleton(first_letter), states(0))
    val remaining_str = str.tail

    for ((c,n) <- remaining_str.iterator.zipWithIndex) {
      // we read x = c -> keep parsing
      builder.addTransition(states(n),builder.LabelOps.singleton(c), states(n+1))
      // we read x <= c -> go to sink state
      builder.addTransition(states(n),builder.LabelOps.interval(Char.MinValue, (c-1).toChar), sink_state)
      builder.setAccept(states(n), isAccepting = true)
    }

    builder.getAutomaton
  }
  /**
   * A new automaton that accepts all strings str <= x (lexicographical ordering)
   */
  def greaterEqAutomaton(str : String) : BricsAutomaton = {
    /*
    Initial state is NOT accepting.
    Have one accepting sink state where every letter can be read because we are already smaller.
    Have additional state per char 'c' in the string to check for equality.
      Each of those additional states have one transition to the sink state reading ['c'+1, 65535]
      Each of those additional states have one transition to the next state reading ['c', 'c']
    The last state has no outgoing transitions.
     */
    val builder = new BricsAutomatonBuilder
    val initital_state = builder.getNewState

    builder.setInitialState(initital_state)

    if (str.isEmpty){
      builder.setAccept(initital_state, isAccepting = true)
      builder.addTransition(initital_state, builder.LabelOps.sigmaLabel, initital_state)
      return builder.getAutomaton
    }

    val sink_state = builder.getNewState
    builder.setAccept(sink_state, isAccepting = true)

    val first_letter = str.head

    builder.addTransition(initital_state, builder.LabelOps.interval((first_letter+1).toChar, Char.MaxValue), sink_state)
    builder.addTransition(sink_state, builder.LabelOps.sigmaLabel, sink_state)

    val states =
      (for (n <- 0 until str.length) yield builder.getNewState).toIndexedSeq

    builder.addTransition(initital_state, builder.LabelOps.singleton(first_letter), states.head)
    val remaining_str = str.tail

    for ((c,n) <- remaining_str.iterator.zipWithIndex) {
      // we read c = x -> keep parsing
      builder.addTransition(states(n),builder.LabelOps.singleton(c), states(n+1))
      // we read c < x -> go to sink state
      builder.addTransition(states(n),builder.LabelOps.interval((c+1).toChar, Char.MaxValue), sink_state)
      builder.setAccept(states(n), isAccepting = true)
    }
    // we are equal up to this point -> can read any letter afterwards and be bigger
    builder.setAccept(states.last, isAccepting = true)
    builder.addTransition(states.last, builder.LabelOps.sigmaLabel, states.last)

    builder.getAutomaton
  }

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
    if (disjointLabels.isEmpty) {
      List((Char.MinValue, Char.MaxValue))
    } else {
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
}

/**
 * Wrapper for the BRICS automaton class
 */
class BricsAutomaton(val underlying : BAutomaton) extends AtomicStateAutomaton {

  import BricsAutomaton.toBAutomaton
  import OFlags.debug

  if (debug)
    Console.err.println("New automaton with " + underlying.getNumberOfStates +
                          " states")

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


