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

import dk.brics.automaton.{BasicAutomata, BasicOperations,
                           Automaton => BAutomaton, State => BState, Transition}

import scala.collection.mutable.{HashSet => MHashSet, ArrayStack,
                                 Stack => MStack,
                                 HashMap => MHashMap}

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
                 intersectedLabels : Any) : Iterator[List[Any]] = auts match {
      case List() =>
        Iterator(List())
      case aut :: otherAuts => {
        val state :: otherStates = states
        for ((to, label) <- aut.outgoingTransitions(
                              state.asInstanceOf[aut.State]);
             newILabel <- aut.intersectLabels(
                           intersectedLabels.asInstanceOf[aut.TransitionLabel],
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
      for (reached <- enumNext(autsList, next, auts.head.sigmaLabel))
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
      areConsistentAtomicAutomata(auts map (_.asInstanceOf[AtomicStateAutomaton]))
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
                    newAut : Automaton) : Option[Seq[Automaton]] =
    if (areConsistentAutomata(List(newAut) ++ oldAuts))
      None
    else
      // naive core
      Some(List(newAut) ++ oldAuts)

  /**
   * Product of a number of given automata.  Returns
   * new automaton.  Returns map from new states of result to (q0, [q1,
   * ..., qn]) giving states of this and auts respectively
   */
  def productWithMap(auts : Seq[AtomicStateAutomaton]) :
    (AtomicStateAutomaton, Map[Any, Seq[Any]]) = {

    if (auts.size == 1)
      return (auts.head,
              (for (s <- auts.head.getStates) yield (s -> List(s))).toMap)

    val autsList = auts.toList

    val newBAut = new BAutomaton
    val initBState = newBAut.getInitialState
    val sMap = new MHashMap[BState, List[Any]]
    val sMapRev = new MHashMap[List[Any], BState]

    val initStates = (auts.map(_.initialState)).toList
    sMap += initBState -> initStates
    sMapRev += initStates -> initBState

    val worklist = new MStack[(BState, List[Any])]
    worklist push ((initBState, initStates))
    
    val seenlist = MHashSet[List[Any]]()
    seenlist += initStates

    initBState.setAccept(auts forall { aut => aut.isAccept(aut.initialState) })

    while (!worklist.isEmpty) {
      val (bs, ss) = worklist.pop()

      // collects transitions from (s, ss)
      // min, max is current range
      // sp and ssp are s' and ss' (ss' is reversed for efficiency)
      // ss are elements of ss from which a transition is yet to be
      // searched
      def addTransitions(curMin : Char, curMax : Char,
                         ssp : List[Any],
                         remAuts : List[AtomicStateAutomaton],
                         ss : List[Any]) : Unit = ss match {
        case List() =>  {
            val nextState = ssp.reverse
            if (!seenlist.contains(nextState)) {
                val nextBState = new BState
                nextBState.setAccept(
                  (auts.iterator zip nextState.iterator) forall {
                    case (aut, s) => aut.isAccept(s.asInstanceOf[aut.State])
                  })
                sMap += nextBState -> nextState
                sMapRev += nextState -> nextBState
                worklist.push((nextBState, nextState))
                seenlist += nextState
            }
            val nextBState = sMapRev(nextState)
            bs.addTransition(new Transition(curMin, curMax, nextBState))
        }
        case _state :: ssTail => {
            val aut :: autsTail = remAuts
            val state = _state.asInstanceOf[aut.State]
            aut.outgoingTransitions(state) foreach {
              case (s, (lblMin : Char, lblMax : Char)) => {
                val newMin = (curMin max lblMin).toChar
                val newMax = (curMax min lblMax).toChar
                if (newMin <= newMax)
                    addTransitions(newMin, newMax, s::ssp, autsTail, ssTail)
              }
            }
        }
      }
 
      addTransitions(Char.MinValue, Char.MaxValue, List(), autsList, ss)
    }

    newBAut.restoreInvariant
    val res = new BricsAutomaton(newBAut)

    assert(res.isEmpty == !areConsistentAutomata(auts))
    
    (res, sMap.toMap)
  }

  /**
   * Form product of this automaton with given auts, returns a new
   * automaton
   */
  def product(auts : Seq[AtomicStateAutomaton]) : AtomicStateAutomaton =
    productWithMap(auts)._1


}
