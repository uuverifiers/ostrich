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

import scala.collection.mutable.{HashSet => MHashSet, ArrayStack,
                                 Stack => MStack, HashMap => MHashMap,
                                 ArrayBuffer}

/**
 * Collection of useful functions for automata
 */
object AutomataUtils {

  /**
   * Check whether there is some word accepted by all of the given automata.
   * The automata are required to all have the same label type (though this is
   * not checked statically)
   */
  def areConsistentAtomicAutomata(auts : Seq[AtomicStateAutomaton]) : Boolean = {
    val autsList = auts.toList
    val visitedStates = new MHashSet[List[Any]]
    val todo = new ArrayStack[List[Any]]

    def isAccepting(states : List[Any]) : Boolean =
          (auts.iterator zip states.iterator) forall {
             case (aut, state) =>
               aut.acceptingStates contains state.asInstanceOf[aut.State]
          }

    def enumNext(auts : List[AtomicStateAutomaton],
                 states : List[Any],
                 intersectedLabels : Any) : Iterator[List[Any]] =
      auts match {
        case List() =>
          Iterator(List())
        case aut :: otherAuts => {
          val state :: otherStates = states
          for ((to, label) <- aut.outgoingTransitions(
                                state.asInstanceOf[aut.State]);
               newILabel <- aut.LabelOps.intersectLabels(
                             intersectedLabels.asInstanceOf[aut.TLabel],
                             label).toSeq;
               tailNext <- enumNext(otherAuts, otherStates, newILabel))
          yield (to :: tailNext)
        }
      }

    val initial = (autsList map (_.initialState))

    if (isAccepting(initial))
      return true

    visitedStates += initial
    todo push initial

    while (!todo.isEmpty) {
      val next = todo.pop
      for (reached <- enumNext(autsList, next, auts.head.LabelOps.sigmaLabel))
        if (!(visitedStates contains reached)) {
          if (isAccepting(reached))
            return true
          visitedStates += reached
          todo push reached
        }
    }

    false
  }

  /**
   * Check whether there is some word accepted by all of the given automata.
   */
  def areConsistentAutomata(auts : Seq[Automaton]) : Boolean =
    if (auts.isEmpty) {
      true
    } else if (auts forall (_.isInstanceOf[AtomicStateAutomaton])) {
      areConsistentAtomicAutomata(
        auts map (_.asInstanceOf[AtomicStateAutomaton])
      )
    } else {
      !(auts reduceLeft (_ & _)).isEmpty
    }

  /**
   * Check whether there is some word accepted by all of the given automata.
   * If the intersection is empty, return an unsatisfiable core. The method
   * makes the assumption that <code>oldAuts</code> are consistent, but the
   * status of the combination with <code>newAut</code> is unknown.
   */
  def findUnsatCore(oldAuts : Seq[Automaton],
                    newAut : Automaton) : Option[Seq[Automaton]] = {

    val consideredAuts = new ArrayBuffer[Automaton]
    consideredAuts += newAut

    // add automata until we encounter a conflict
    var cont = areConsistentAutomata(consideredAuts)
    val oldAutsIt = oldAuts.iterator
    while (cont && oldAutsIt.hasNext) {
      consideredAuts += oldAutsIt.next
      cont = areConsistentAutomata(consideredAuts)
    }

    if (cont)
      return None

    // remove automata to get a small core
    for (i <- (consideredAuts.size - 2) to 1 by -1) {
      val removedAut = consideredAuts remove i
      if (areConsistentAutomata(consideredAuts))
        consideredAuts.insert(i, removedAut)
    }

    Some(consideredAuts)
  }

  /**
   * Product of a number of given automata.  Returns
   * new automaton.  Returns map from new states of result to (q0, [q1,
   * ..., qn]) giving states of this and auts respectively
   */
  def productWithMap(auts : Seq[AtomicStateAutomaton]) :
    (AtomicStateAutomaton, Map[Any, Seq[Any]]) = {

    if (auts.size == 0)
      return (BricsAutomaton.makeAnyString, Map.empty[Any, Seq[Any]])

    if (auts.size == 1)
      return (auts.head,
              (for (s <- auts.head.states) yield (s -> List(s))).toMap)

    val autsList = auts.toList

    val head = auts.head
    val builder = head.getBuilder
    val initState = builder.initialState
    val sMap = new MHashMap[head.State, List[Any]]
    val sMapRev = new MHashMap[List[Any], head.State]

    val initStates = (auts.map(_.initialState)).toList
    sMap += initState -> initStates
    sMapRev += initStates -> initState

    val worklist = new MStack[(head.State, List[Any])]
    worklist push ((initState, initStates))

    val seenlist = MHashSet[List[Any]]()
    seenlist += initStates

    builder.setAccept(initState, auts forall { aut => aut.isAccept(aut.initialState) })

    while (!worklist.isEmpty) {
      val (ps, ss) = worklist.pop()

      // collects transitions from (s, ss)
      // min, max is current range
      // sp and ssp are s' and ss' (ss' is reversed for efficiency)
      // ss are elements of ss from which a transition is yet to be
      // searched
      def addTransitions(lbl : head.TLabel,
                         ssp : List[Any],
                         remAuts : List[AtomicStateAutomaton],
                         ss : List[Any]) : Unit = ss match {
        case List() =>  {
            val nextState = ssp.reverse
            if (!seenlist.contains(nextState)) {
                val nextPState = builder.getNewState
                val isAccept = (auts.iterator zip nextState.iterator) forall {
                  case (aut, s) => aut.isAccept(s.asInstanceOf[aut.State])
                }
                builder.setAccept(nextPState, isAccept)
                sMap += nextPState -> nextState
                sMapRev += nextState -> nextPState
                worklist.push((nextPState, nextState))
                seenlist += nextState
            }
            val nextPState = sMapRev(nextState)
            builder.addTransition(ps, lbl, nextPState)
        }
        case _state :: ssTail => {
            val aut :: autsTail = remAuts
            val state = _state.asInstanceOf[aut.State]
            aut.outgoingTransitions(state) foreach {
              case (s, nextLbl) => {
                val newLbl =
                    builder.LabelOps.intersectLabels(lbl,
                                                     nextLbl.asInstanceOf[head.TLabel])
                for (l <- newLbl)
                  addTransitions(l, s::ssp, autsTail, ssTail)
              }
            }
        }
      }

      addTransitions(builder.LabelOps.sigmaLabel, List(), autsList, ss)
    }

    (builder.getAutomaton, sMap.toMap)
  }

  /**
   * Form product of this automaton with given auts, returns a new
   * automaton
   */
  def product(auts : Seq[AtomicStateAutomaton]) : AtomicStateAutomaton =
    productWithMap(auts)._1

  /**
   * Replace a-transitions with new a-transitions between pairs of states
   */
  def replaceTransitions[A <: AtomicStateAutomaton](
        aut : A,
        a : Char,
        states : Iterable[(A#State, A#State)]) : AtomicStateAutomaton = {
    val builder = aut.getBuilder
    val smap : Map[A#State, aut.State] =
      aut.states.map(s => (s -> builder.getNewState))(collection.breakOut)

    for ((s1, lbl, s2) <- aut.transitions)
      for (newLbl <- aut.LabelOps.subtractLetter(a, lbl))
        builder.addTransition(smap(s1), newLbl, smap(s2))

    val aLbl = aut.LabelOps.singleton(a)
    for ((s1, s2) <- states)
      builder.addTransition(smap(s1), aLbl, smap(s2))

    builder.setInitialState(smap(aut.initialState))
    for (f <- aut.acceptingStates)
      builder.setAccept(smap(f), true)

    val res = builder.getAutomaton
    res
  }

  /**
   * Build automaton accepting reverse language of given automaton
   */
  def reverse(aut : AtomicStateAutomaton) : AtomicStateAutomaton = {
    val builder = aut.getBuilder

    val smap : Map[aut.State, aut.State] =
      aut.states.map(s => (s -> builder.getNewState))(collection.breakOut)

    val initState = builder.initialState
    builder.setAccept(smap(aut.initialState), true)

    val autAccept = aut.acceptingStates
    for ((s1, l, s2) <- aut.transitions) {
      if (autAccept contains s2)
        builder.addTransition(initState, l, smap(s1))
      builder.addTransition(smap(s2), l, smap(s1))
    }

    builder.getAutomaton
  }
}
