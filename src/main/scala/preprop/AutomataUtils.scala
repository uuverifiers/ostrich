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

import scala.collection.mutable.{HashSet => MHashSet, ArrayStack}

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

    val initial = (autsList map (_.initialState))
    visitedStates += initial
    todo push initial

    def enumNext(auts : List[AtomicStateAutomaton],
                 states : List[Any],
                 intersectedLabels : Any) : Iterator[List[Any]] = auts match {
      case List() =>
        Iterator(List())
      case aut :: otherAuts => {
        val state :: otherStates = states
        for ((to, label) <- aut.outgoingTransitions(
                              state.asInstanceOf[aut.State]);
             newILabel = aut.intersectLabels(
                           intersectedLabels.asInstanceOf[aut.TransitionLabel],
                           label);
             if aut.isNonEmptyLabel(newILabel);
             tailNext <- enumNext(otherAuts, otherStates, newILabel))
        yield (to :: tailNext)
      }
    }

    while (!todo.isEmpty) {
      val next = todo.pop
      for (reached <- enumNext(autsList, next, auts.head.sigmaLabel))
        if (!(visitedStates contains reached)) {
          if ((auts.iterator zip reached.iterator) forall {
                case (aut, state) =>
                  aut.acceptingStates contains state.asInstanceOf[aut.State]
              })
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
}
