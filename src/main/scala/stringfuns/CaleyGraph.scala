/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
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

package stringfuns

import dk.brics.automaton.{Automaton, State}
import scala.collection.mutable.{HashMap, Set, MultiMap}
import scala.collection.immutable.HashSet

/**
 * Box in a Caley graph [w] = { (q,q') | q -- w --> q' }
 */
class Box() {
    val arrows = new HashMap[State, Set[State]] with MultiMap[State, State]

    /**
     * Add a new edge (q1, q2) to the box
     *
     * @param q1
     * @param q2
     * @return same box object (this)
     */
    def addEdge(q1 : State, q2 : State) : Box.this.type = {
        arrows.addBinding(q1, q2)
        this
    }

    def hasEdge(q1 : State, q2 : State) : Boolean = 
        arrows.isDefinedAt(q1) && arrows(q1).contains(q2)

    /**
     * Iterate over all edges (q1, q2) in the box
     *
     * @return an iterator over all edges in the box
     */
    def edges : Iterator[Pair[State, State]] = 
        for ((q1, qs) <- arrows.iterator; q2 <- qs )
            yield (q1, q2)

    /**
     * Iterator over all states q2 such that (q1, q2) is an edge
     *
     * @param q1 
     * @return iterator over states q2 reachable by an edge (q1, q2)
     */
    def targetStates(q1 : State) : Iterator[State] =
        if (arrows.isDefinedAt(q1))
            for (q2 <- arrows(q1).iterator)
                yield q2
        else
            return Iterator()

    /**
     * Compose this box with that box
     *
     * @param that
     * @return a new Box that is the composition of this and that
     */
    def ++(that: Box) : Box = {
        val comp = new Box()

        for ((q1, q2) <- edges; q3 <- that.targetStates(q2))
            comp.addEdge(q1, q3)

        return comp
    }

    /**
     * returns the set of states q2 with and edge (q, q2)
     *
     * @param q
     * @return a Set of all states that are the target of an edge from q
     */
    def apply(q : State) : Set[State] = arrows(q)

    override def toString : String = arrows.toString
}

class CaleyGraph {
    def getOne() : Integer = 1
}
