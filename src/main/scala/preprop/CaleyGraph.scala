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

package strsolver.preprop

import scala.collection.mutable.{HashMap, HashSet, Set, Stack, MultiMap}
import scala.collection.JavaConversions._
import scala.collection.IterableView

object Box {
  /**
   * Create a box from a number of edges.  E.g.
   * Box((q1, q2), (q2, q3))
   */
  def apply[A <: AtomicStateAutomaton](edges : (A#State, A#State)*) : Box[A] = {
    edges.foldLeft(new Box[A]) {
      case (box, (q1, q2)) => box.addEdge(q1, q2)
    }
  }
}

/**
 * Box in a Caley graph [w] = { (q,q') | q -- w --> q' }
 */
class Box[A <: AtomicStateAutomaton] {
  private val arrows =
    new HashMap[A#State, Set[A#State]] with MultiMap[A#State, A#State] {
      override def default(q : A#State) : Set[A#State] = Set.empty[A#State]
    }

  /**
   * Add a new edge (q1, q2) to the box.  Updates box and returns this.
   */
  def addEdge(q1 : A#State, q2 : A#State) : Box.this.type = {
      arrows.addBinding(q1, q2)
      this
  }

  /**
   * Checks if an edge (q1, q2) is contained in the box
   */
  def hasEdge(q1 : A#State, q2 : A#State) : Boolean =
    arrows.isDefinedAt(q1) && arrows(q1).contains(q2)

  /**
   * Iterate over all edges (q1, q2) in the box
   */
  def getEdges : Iterator[(A#State, A#State)] =
    for ((q1, qs) <- arrows.iterator; q2 <- qs )
      yield (q1, q2)

  /**
   * Compose this box with that box.  Returns a new box.
   */
  def ++(that: Box[A]) : Box[A] =
    getEdges.foldLeft(new Box[A]) { case (box, (q1, q2)) =>
      that(q2).foldLeft(box)((box, q3) =>
        box.addEdge(q1, q3)
      )
    }

  /**
   * returns the set of states q2 with and edge (q, q2)
   */
  def apply(q : A#State) : Set[A#State] = arrows(q)

  override def toString : String = getEdges.mkString("[", ", ", "]")

  def canEqual(a : Any) : Boolean = a.isInstanceOf[Box[A]]

  override def equals(that : Any) : Boolean =
    that match {
      case that : Box[A] => that.canEqual(this) && arrows == that.arrows
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
  def apply[A <: AtomicStateAutomaton](aut : A) : CaleyGraph[A] = {
    val boxes = new HashSet[Box[A]]
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

    new CaleyGraph[A](aut, boxes)
  }

  /**
   * Gets boxes for single characters [a] of the automaton
   */
  private def getCharacterBoxes[A <: AtomicStateAutomaton](aut : A)
      : Iterable[Box[A]] = {
    val boxes = HashMap[Char,Box[A]]()

    aut.foreachTransition((q1, label, q2) => {
        for (_a <- aut.enumLetters(label); a = _a.toChar) {
          if (!boxes.isDefinedAt(a))
            boxes += (a -> new Box[A])
          boxes(a).addEdge(q1, q2)
        }
      }
    )

    boxes.values
  }

  /**
   * Make [] box for empty word (i.e. all edges (q,q))
   *
   * @return the box
   */
  private def getEpsilonBox[A <: AtomicStateAutomaton](aut : A) : Box[A] = {
    Box[A](aut.getStates.zip(aut.getStates).toSeq:_*)
  }
}


/**
 * Representation of CaleyGraph corresponding to aut with given nodes.
 * Can be constructed by companion object
 * Graphs are considered equal by nodes, regardless of aut
 */
class CaleyGraph[A <: AtomicStateAutomaton](private val aut : A,
                                            private val nodes : Set[Box[A]]) {
    /**
     * The number of boxes/nodes in the graph
     */
    def numNodes : Int = nodes.size

    /**
     * Get a view on the nodes in the Caley graph
     */
    def getNodes : IterableView[Box[A], Set[Box[A]]] = nodes.view

    override def toString : String = nodes.mkString("\n")

    def canEqual(a : Any) : Boolean = a.isInstanceOf[CaleyGraph[A]]

    override def equals(that : Any) : Boolean =
      that match {
        case that : CaleyGraph[A] =>
          that.canEqual(this) && nodes == that.nodes
        case _ => false
      }

    override def hashCode : Int = nodes.hashCode
}
