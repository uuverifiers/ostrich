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
import scala.collection.mutable.{HashMap, HashSet, Set, Stack, MultiMap}
import scala.collection.JavaConversions._


object Box {
    /**
     * Create a box from a number of edges.  E.g.
     *
     *   Box((q1, q2), (q2, q3))
     *
     * @param edges
     * @return a Box with the given edges
     */
    def apply(edges : (State, State)*) : Box = {
        edges.foldLeft(new Box) { case (box, (q1, q2)) => box.addEdge(q1, q2) }
    }
}

/**
 * Box in a Caley graph [w] = { (q,q') | q -- w --> q' }
 */
class Box {
    private val arrows = new HashMap[State, Set[State]] with MultiMap[State, State] {
        override def default(q : State) : Set[State] = Set.empty[State]
    }

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

    /**
     * Checks if an edge is contained in the box
     *
     * @param q1
     * @param q2
     * @return true iff (q1, q2) is an edge in the box
     */
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
     * Compose this box with that box
     *
     * @param that
     * @return a new Box that is the composition of this and that
     */
    def ++(that: Box) : Box =
        edges.foldLeft(new Box) { case (box, (q1, q2)) =>
            that(q2).foldLeft(box)((box, q3) =>
                box.addEdge(q1, q3)
            )
        }

    /**
     * returns the set of states q2 with and edge (q, q2)
     *
     * @param q
     * @return a Set of all states that are the target of an edge from q
     */
    def apply(q : State) : Set[State] = arrows(q)

    override def toString : String = edges.mkString("[", ", ", "]")

    def canEqual(a : Any) : Boolean = a.isInstanceOf[Box]

    override def equals(that : Any) : Boolean =
        that match {
            case that : Box => that.canEqual(this) && arrows == that.arrows
            case _ => false
        }

    override def hashCode : Int = arrows.hashCode
}

/**
 * Constructs the Caley graph of the given automaton
 *
 * @param aut
 */
object CaleyGraph {
    def apply(aut : Automaton) = {
        val boxes = new HashSet[Box]
        val characterBoxes = getCharacterBoxes(aut)
        val eBox = getEpsilonBox(aut)

        val worklist = Stack(eBox)
        while (!worklist.isEmpty) {
            val w = worklist.pop()
            boxes += w
            for (a <- characterBoxes) {
                val wa = w ++ a
                if (!boxes.contains(wa))
                    worklist.push(wa)
            }
        }

        new CaleyGraph(aut, boxes)
    }

    /**
     * Gets boxes for single characters [a] of the automaton
     *
     * @param aut
     * @return an iterable of boxes [a] for each character of the automaton
     */
    private def getCharacterBoxes(aut : Automaton) : Iterable[Box] = {
        val boxes = HashMap[Char,Box]()

        for (q <- aut.getStates();
                t <- q.getTransitions();
                    a <- t.getMin to t.getMax) {
            if (!boxes.isDefinedAt(a))
                boxes += (a -> new Box)
            boxes(a).addEdge(q, t.getDest())
        }

        boxes.values
    }

    /**
     * Make [] box for empty word (i.e. all edges (q,q))
     *
     * @return the box
     */
    private def getEpsilonBox(aut : Automaton) : Box = {
        val qs = aut.getStates
        Box(qs.zip(qs)(collection.breakOut):_*)
    }
}


/**
 * Representation of CaleyGraph, can be constructed by companion object
 *
 * Graphs are considered equal by nodes, regardless of aut
 *
 * @param aut the automaton this graph represents.
 * @param nodes the nodes of the graph
 */
class CaleyGraph (private val aut : Automaton, private val nodes : Set[Box]) {
    /**
     * The number of boxes/nodes in the graph
     * @return as above
     */
    def numNodes : Int = nodes.size

    override def toString : String = nodes.mkString("\n")

    def canEqual(a : Any) : Boolean = a.isInstanceOf[CaleyGraph]

    override def equals(that : Any) : Boolean =
        that match {
            case that : CaleyGraph => that.canEqual(this) && nodes == that.nodes
            case _ => false
        }

    override def hashCode : Int = nodes.hashCode
}
