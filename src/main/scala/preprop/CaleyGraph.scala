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

import java.util.Objects

import scala.collection.mutable.{HashMap, HashSet, Set, Stack, MultiMap}
import scala.collection.JavaConversions._
import scala.collection.IterableView

import spire.math.Interval
import spire.math.interval.Closed
import spire.math.extras.interval.IntervalTrie._

object Box {
  /**
   * Create a box from a number of edges.  E.g.
   * Box((q1, q2), (q2, q3))
   */
  def apply[A <: Automaton](edges : (A#State, A#State)*) : Box[A] = {
    edges.foldLeft(new Box[A]) {
      case (box, (q1, q2)) => box.addEdge(q1, q2)
    }
  }
}

/**
 * Box in a Caley graph [w] = { (q,q') | q -- w --> q' }
 */
class Box[A <: Automaton] {
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
  def apply[A <: Automaton](aut : A) : CaleyGraph[A] = {
    val graph = BricsAutomaton()
    val boxMap = new HashMap[BricsAutomaton#State, Box[A]]
    val stateMap = new HashMap[Box[A], BricsAutomaton#State]

    val eBox = getEpsilonBox(aut)
    val es = graph.getInitialState
    es.setAccept(true)
    boxMap += (es -> eBox)
    stateMap += (eBox -> es)

    val characterBoxes = getCharacterBoxes(aut)

    val worklist = Stack((es, eBox))
    val donelist = new HashSet[Box[A]]

    while (!worklist.isEmpty) {
      val (s, w) = worklist.pop()
      donelist += w
      for ((a, intervals) <- characterBoxes) {
        val wa = w ++ a
        if (!donelist.contains(wa)) {
          val sa = graph.getNewState
          sa.setAccept(true)
          boxMap += (sa -> wa)
          stateMap += (wa -> sa)
          worklist.push((sa, wa))
        }

        val sa = stateMap(wa)
        for ((min, max) <- intervals) {
          graph.addTransition(s, min, max, sa)
        }
      }
    }

    new CaleyGraph[A](aut, graph, boxMap.toMap, stateMap.toMap)
  }

  /**
   * Gets boxes for characters [a] of the automaton.
   *
   * @return map from each box to the intervals that have that box
   */
  private def getCharacterBoxes[A <: Automaton](aut : A)
      : Map[Box[A], Iterable[(Char, Char)]] = {
    // i know, we need foldTransition
    var intervals = empty[Char]
    aut.foreachTransition((q1, min, max, q2) =>
      intervals = intervals | (atOrAbove(min) & atOrBelow(max))
    )

    val boxes : Map[(Char,Char),Box[A]] =
      intervals.intervals.map(i =>
        intervalPair(i) -> new Box[A]
      )(collection.breakOut)

    aut.foreachTransition((q1, min, max, q2) =>
      for (i <- (intervals & atOrAbove(min) & atOrBelow(max)).intervals)
        boxes(intervalPair(i)).addEdge(q1, q2)
    )

    // reverse map
    boxes.groupBy(_._2).mapValues(_.keys)
  }

  /**
   * Make [] box for empty word (i.e. all edges (q,q))
   *
   * @return the box
   */
  private def getEpsilonBox[A <: Automaton](aut : A) : Box[A] = {
    Box[A](aut.getStates.zip(aut.getStates).toSeq:_*)
  }

  /**
   * extract upper and lower bound from interval object, assuming only
   * closed intervals
   */
  private def intervalPair(i : Interval[Char]) : (Char, Char) = {
    val lower : Char = i.lowerBound match {
      case c : Closed[Char] => c.a
      case _ => '\0' /* never occurs */
    }
    val upper : Char = i.upperBound match {
      case c : Closed[Char] => c.a
      case _ => '\0' /* never occurs */
    }
    (lower, upper)
  }
}


/**
 * Representation of CaleyGraph corresponding to aut with given nodes.
 * Can be constructed by companion object
 * Graphs are considered equal by nodes, regardless of aut
 */
class CaleyGraph[A <: Automaton](
  private val aut : A,
  private val graph : BricsAutomaton,
  private val boxMap : Map[BricsAutomaton#State, Box[A]],
  private val stateMap : Map[Box[A], BricsAutomaton#State]
) {
    /**
     * The number of boxes/nodes in the graph
     */
    def numNodes : Int = stateMap.size

    /**
     * Get a view on the nodes in the Caley graph
     */
    def getNodes : Iterable[Box[A]] = stateMap.keys

    override def toString : String = stateMap.mkString("\n")

    def canEqual(a : Any) : Boolean = a.isInstanceOf[CaleyGraph[A]]

    override def equals(that : Any) : Boolean =
      that match {
        case that : CaleyGraph[A] =>
          that.canEqual(this) &&
          stateMap == that.stateMap &&
          boxMap == that.boxMap &&
          graph == that.graph
        case _ => false
      }

    override def hashCode : Int = Objects.hash(boxMap, stateMap, graph)

    /**
     * Returns boxes representing words accepted by the product of auts
     */
    def getAcceptNodes(auts : Seq[Automaton]) : Iterable[Box[A]] = {
      val (prodAut, sMap) = graph.productWithMap(auts)
      prodAut.getAcceptStates.map(ps => boxMap(sMap(ps)._1))
    }
}
