/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import java.util.Objects

import scala.collection.mutable.{HashMap => MHashMap, HashSet => MHashSet,Stack}

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
    new MHashMap[A#State, Set[A#State]] {
      override def default(q : A#State) : Set[A#State] = Set()
    }

  /**
   * Add a new edge (q1, q2) to the box.  Updates box and returns this.
   */
  def addEdge(q1 : A#State, q2 : A#State) : Box.this.type = {
      arrows.put(q1, arrows(q1) ++ List(q2))
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
  lazy val getEdges : Iterable[(A#State, A#State)] =
    for ((q1, qs) <- arrows.toSeq; q2 <- qs )
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
  /**
   * Build a Caley graph for aut.  Restrict to boxes representing words
   * that are prefixes of those accepted by all automata in wordBounds.
   */
  def apply[A <: AtomicStateAutomaton]
           (aut : A,
            wordBounds : Seq[AtomicStateAutomaton] = Seq()) : CaleyGraph[A] = /* Exploration.measure("build caley graph") */ {
    val boundAut = AutomataUtils.product(wordBounds)
    val graphBuilder = aut.getBuilder
    graphBuilder.setMinimize(false)
    val boxMap = new MHashMap[aut.State, Box[A]]
    val stateMap = new MHashMap[Box[A], aut.State]

    val eBox = getEpsilonBox(aut)
    val es = graphBuilder.getNewState
    graphBuilder setInitialState es
    graphBuilder.setAccept(es, boundAut.isAccept(boundAut.initialState))
    boxMap += (es -> eBox)
    stateMap += (eBox -> es)

    val characterBoxes = getCharacterBoxes(aut)

    // worklist contains (state of graph, corresponding box, a state
    // that boundAut may have reaced reading a word to es)
    val worklist = Stack((es, eBox, boundAut.initialState))
    // the boxes and states of boundAut we've explored before
    val seenlist = new MHashSet[(Box[A], boundAut.State)]

    while (!worklist.isEmpty) {
      val (s, w, bs) = worklist.pop()

      for ((box, as) <- characterBoxes) {
        val wa = w ++ box
        for ((bsNext, blbl) <- boundAut.outgoingTransitions(bs);
             if as.exists(a => boundAut.LabelOps.labelsOverlap(
                                 blbl, a.asInstanceOf[boundAut.TLabel]))) {
          if (!seenlist.contains((wa, bsNext))) {
            val sa = graphBuilder.getNewState
            graphBuilder.setAccept(sa, boundAut.isAccept(bsNext))
            boxMap += (sa -> wa)
            stateMap += (wa -> sa)
            worklist.push((sa, wa, bsNext))
            seenlist += ((wa, bsNext))
          }

          val sa = stateMap(wa)
          for (a <- as)
            graphBuilder.addTransition(s, a.asInstanceOf[aut.TLabel], sa)
        }
      }
    }

    val graph = graphBuilder.getAutomaton.asInstanceOf[aut.type]
    new CaleyGraph[A](aut, graph, boxMap.toMap, stateMap.toMap)
  }

  private def getCharacterBoxes[A <: AtomicStateAutomaton](aut : A)
      : Map[Box[A], Iterable[A#TLabel]] = {
    val ae = aut.labelEnumerator
    val boxes : Map[A#TLabel,Box[A]] =
      ae.enumDisjointLabelsComplete.view.map(i => i -> new Box[A]).toMap

    for ((q1, i, q2) <- aut.transitions;
         i2 <- ae.enumLabelOverlap(i))
      boxes(i2).addEdge(q1, q2)

    // reverse map
    boxes.groupBy(_._2).mapValues(_.keys).toMap
  }

  /**
   * Make [] box for empty word (i.e. all edges (q,q))
   *
   * @return the box
   */
  private def getEpsilonBox[A <: AtomicStateAutomaton](aut : A) : Box[A] = {
    Box[A](aut.states.zip(aut.states).toSeq:_*)
  }
}


/**
 * Representation of CaleyGraph corresponding to aut with given nodes.
 * Can be constructed by companion object
 * Graphs are considered equal by nodes, regardless of aut
 */
class CaleyGraph[A <: AtomicStateAutomaton](
  private val aut : A,
  private val graph : A,
  private val boxMap : Map[A#State, Box[A]],
  private val stateMap : Map[Box[A], A#State]
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
     * Returns boxes that are accepting according to how the caley graph
     * was built (see CaleyGraph.apply)
     */
    def getAcceptNodes : Iterable[Box[A]] =
      graph.acceptingStates.map(boxMap)
}
