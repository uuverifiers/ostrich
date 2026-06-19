/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
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

package ostrich.proofops

import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.theories.{SaturationProcedure, Theory}
import ap.terfor.{TerForConvenience, Term, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.{Atom, Predicate}

import ostrich.OstrichStringTheory
import ostrich.automata.{
  AtomicStateAutomaton,
  BricsAutomaton,
  BricsTransducer,
  ProductAutomaton,
  Transducer
}

import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet,
  Queue => MQueue
}

/**
 * Lightweight abstraction for pairs of transducer applications sharing
 * the same input:
 *
 *   T1(x, y1) & T2(x, y2) & x in A  ==>  c1 <= |y1|-|y2| <= c2
 *
 * Bounds are obtained from a weighted product of A and the two Brics
 * transducers. The procedure is intentionally conservative: unsupported
 * transducer features, unbounded directions, or large products simply
 * suppress the corresponding lemma.
 */
class TransducerLengthRelations(
  val theory : OstrichStringTheory
) extends SaturationProcedure("TransducerLengthRelations")
  with PropagationSaturationUtils {

  private val MaxProductStates = 20000

  private val transducersByPred : Map[Predicate, BricsTransducer] =
    (for ((_, pred, transducer : BricsTransducer) <-
            theory.transducersWithPreds.iterator)
     yield (pred, transducer)).toMap

  private case class TransducerAtom(atom : Atom) {
    def input  : Term = atom(0)
    def output : Term = atom(1)
  }

  type ApplicationPoint = (Atom, Atom, Seq[Atom])

  private case class ProductNode(
    inputState : Any,
    leftState  : BricsAutomaton#State,
    rightState : BricsAutomaton#State
  )

  private case class ProductEdge(to : ProductNode, weight : Int)

  private sealed trait RelationResult
  private case object EmptyRelation extends RelationResult
  private case class BoundedRelation(min : Option[Int], max : Option[Int])
      extends RelationResult

  override def extractApplicationPoints(goal : Goal)
                                      : Iterator[ApplicationPoint] = {
    val termConstraints = getInitialConstraints(goal)

    val transducerAtoms =
      for (atom <- goal.facts.predConj.positiveLits.iterator;
           if transducersByPred contains atom.pred)
      yield TransducerAtom(atom)

    val byInput = transducerAtoms.toIndexedSeq.groupBy(_.input)

    for {
      (input, atoms) <- byInput.iterator
      if atoms.size >= 2
      sortedAtoms = atoms.sortBy(_.atom)(goal.order.atomOrdering)
      Seq(left, right) <- sortedAtoms.combinations(2)
    } yield (left.atom, right.atom, termConstraints.getOrElse(input, Seq()))
  }

  override def applicationPriority(goal : Goal, p : ApplicationPoint) : Int =
    100 + p._3.map({
      case a if a.pred == theory.str_in_re_id =>
        getAutomatonSize(decodeRegexId(a, false))
      case _ =>
        1
    }).sum

  override def handleApplicationPoint(
    goal : Goal,
    p    : ApplicationPoint
  ) : Seq[Plugin.Action] = {
    val (leftAtom, rightAtom, inputConstraints) = p
    val posAtoms = goal.facts.predConj.positiveLitsAsSet
    val assumptions = (Seq(leftAtom, rightAtom) ++ inputConstraints).distinct

    if (!assumptions.forall(posAtoms.contains) || leftAtom(0) != rightAtom(0))
      return List()

    val maybeResult =
      for {
        leftTransducer  <- transducersByPred.get(leftAtom.pred)
        rightTransducer <- transducersByPred.get(rightAtom.pred)
        inputAut        <- buildInputAutomaton(leftAtom(0), inputConstraints)
        result          <- computeRelation(inputAut,
                                           leftTransducer,
                                           rightTransducer)
      } yield result

    val actions = maybeResult match {
      case Some(EmptyRelation) =>
        Seq(Plugin.AddAxiom(assumptions, Conjunction.FALSE, theory))

      case Some(BoundedRelation(min, max))
          if min.isDefined || max.isDefined =>
        implicit val order : TermOrder = goal.order
        import TerForConvenience._

        val builder = new FormulaBuilder(goal, theory)
        val leftLen = builder.lengthOfTerm(leftAtom(1))
        val rightLen = builder.lengthOfTerm(rightAtom(1))
        val diff = leftLen - rightLen

        for (bound <- min)
          builder.addConjunct(diff >= bound)
        for (bound <- max)
          builder.addConjunct(diff <= bound)

        Seq(Plugin.AddAxiom(assumptions, builder.result, theory))

      case _ =>
        List()
    }

    logSaturation("transducer length relations") {
      actions
    }
  }

  override def isSoundForSat(
    theories : Seq[Theory],
    config : Theory.SatSoundnessConfig.Value
  ) : Boolean = true

  private def buildInputAutomaton(
    input       : Term,
    constraints : Seq[Atom]
  ) : Option[AtomicStateAutomaton] = {
    val auts =
      if (constraints.isEmpty) {
        Seq(atomConstraintToAut(input, None))
      } else {
        constraints.map(a => atomConstraintToAut(input, Some(a)))
      }

    val atomicAuts = new ArrayBuffer[AtomicStateAutomaton]

    for (aut <- auts)
      aut match {
        case atomic : AtomicStateAutomaton =>
          atomicAuts += atomic
        case _ =>
          return None
      }

    Some(ProductAutomaton(atomicAuts.toSeq))
  }

  private def computeRelation(
    inputAut : AtomicStateAutomaton,
    left     : BricsTransducer,
    right    : BricsTransducer
  ) : Option[RelationResult] = {
    val start =
      ProductNode(inputAut.initialState, left.initialState, right.initialState)

    val todo = MQueue[ProductNode](start)
    val seen = MHashSet[ProductNode](start)
    val outgoing = new MHashMap[ProductNode, Vector[ProductEdge]]
    val reverse = new MHashMap[ProductNode, ArrayBuffer[ProductNode]]

    while (todo.nonEmpty) {
      val node = todo.dequeue()

      successorEdges(inputAut, left, right, node) match {
        case Some(edges) =>
          outgoing.put(node, edges)

          for (edge <- edges) {
            reverse.getOrElseUpdate(edge.to, new ArrayBuffer[ProductNode]) +=
              node

            if (seen.add(edge.to)) {
              if (seen.size > MaxProductStates)
                return None
              todo.enqueue(edge.to)
            }
          }

        case None =>
          return None
      }
    }

    val nodes = seen.toVector
    val finalNodes =
      nodes.filter(node =>
        inputAccepts(inputAut, node.inputState) &&
        left.isAccept(node.leftState) &&
        right.isAccept(node.rightState))

    if (finalNodes.isEmpty)
      return Some(EmptyRelation)

    val canReachFinal = reachableBackwards(finalNodes, reverse)
    val max = finiteExtreme(start, nodes, outgoing, canReachFinal,
                            finalNodes, 1)
    val min = finiteExtreme(start, nodes, outgoing, canReachFinal,
                            finalNodes, -1)

    Some(BoundedRelation(min, max))
  }

  private def successorEdges(
    inputAut : AtomicStateAutomaton,
    left     : BricsTransducer,
    right    : BricsTransducer,
    node     : ProductNode
  ) : Option[Vector[ProductEdge]] = {
    val edges = new ArrayBuffer[ProductEdge]

    val inputTransitions =
      inputOutgoingTransitions(inputAut, node.inputState) match {
        case Some(transitions) => transitions
        case None              => return None
      }

    for {
      (inputNext, inputLabel) <-
        inputTransitions.iterator
      (leftLabel, leftOp, leftNext) <-
        left.lblTrans.getOrElse(node.leftState, Set.empty).iterator
      (rightLabel, rightOp, rightNext) <-
        right.lblTrans.getOrElse(node.rightState, Set.empty).iterator
      if labelsOverlap(inputLabel, leftLabel, rightLabel)
    } {
      val leftLen = outputLength(leftOp, consumesInput = true)
      val rightLen = outputLength(rightOp, consumesInput = true)

      if (leftLen.isEmpty || rightLen.isEmpty)
        return None

      edges += ProductEdge(
        ProductNode(inputNext, leftNext, rightNext),
        leftLen.get - rightLen.get
      )
    }

    for ((leftOp, leftNext) <-
           left.eTrans.getOrElse(node.leftState, Set.empty).iterator) {
      val len = outputLength(leftOp, consumesInput = false)
      if (len.isEmpty)
        return None
      edges += ProductEdge(
        ProductNode(node.inputState, leftNext, node.rightState),
        len.get
      )
    }

    for ((rightOp, rightNext) <-
           right.eTrans.getOrElse(node.rightState, Set.empty).iterator) {
      val len = outputLength(rightOp, consumesInput = false)
      if (len.isEmpty)
        return None
      edges += ProductEdge(
        ProductNode(node.inputState, node.leftState, rightNext),
        -len.get
      )
    }

    Some(edges.toVector)
  }

  private def inputOutgoingTransitions(
    aut   : AtomicStateAutomaton,
    state : Any
  ) : Option[Vector[(Any, (Char, Char))]] = {
    val res = new ArrayBuffer[(Any, (Char, Char))]

    for ((next, label) <-
           aut.outgoingTransitions(state.asInstanceOf[aut.State])) {
      intervalLabel(label) match {
        case Some(interval) =>
          res += ((next, interval))
        case None =>
          return None
      }
    }

    Some(res.toVector)
  }

  private def inputAccepts(aut : AtomicStateAutomaton, state : Any) : Boolean =
    aut.isAccept(state.asInstanceOf[aut.State])

  private def intervalLabel(label : Any) : Option[(Char, Char)] = label match {
    case (min : Char, max : Char) =>
      Some((min, max))
    case _ =>
      None
  }

  private def labelsOverlap(
    input : (Char, Char),
    left  : (Char, Char),
    right : (Char, Char)
  ) : Boolean = {
    val min = input._1 max left._1 max right._1
    val max = input._2 min left._2 min right._2
    min <= max
  }

  private def outputLength(
    op            : Transducer.OutputOp,
    consumesInput : Boolean
  ) : Option[Int] = {
    val opLen = op.op match {
      case Transducer.NOP =>
        Some(0)
      case Transducer.Plus(_) if consumesInput =>
        Some(1)
      case Transducer.Plus(_) =>
        Some(0)
      case Transducer.Internal =>
        None
    }

    opLen.map(_ + op.preW.size + op.postW.size)
  }

  private def reachableBackwards(
    finalNodes : Seq[ProductNode],
    reverse    : MHashMap[ProductNode, ArrayBuffer[ProductNode]]
  ) : Set[ProductNode] = {
    val res = MHashSet[ProductNode]()
    val todo = MQueue[ProductNode]()

    for (node <- finalNodes)
      if (res.add(node))
        todo.enqueue(node)

    while (todo.nonEmpty) {
      val node = todo.dequeue()
      for (pred <- reverse.getOrElse(node, ArrayBuffer.empty[ProductNode]))
        if (res.add(pred))
          todo.enqueue(pred)
    }

    res.toSet
  }

  private def finiteExtreme(
    start         : ProductNode,
    nodes         : Vector[ProductNode],
    outgoing      : MHashMap[ProductNode, Vector[ProductEdge]],
    canReachFinal : Set[ProductNode],
    finalNodes    : Seq[ProductNode],
    sign          : Int
  ) : Option[Int] = {
    val dist = new MHashMap[ProductNode, Long]
    dist.put(start, 0L)

    for (_ <- 1 until nodes.size) {
      var changed = false

      for {
        from <- nodes.iterator
        if canReachFinal(from)
        base <- dist.get(from).iterator
        edge <- outgoing.getOrElse(from, Vector.empty).iterator
        if canReachFinal(edge.to)
      } {
        val candidate = base + sign.toLong * edge.weight
        if (candidate > dist.getOrElse(edge.to, Long.MinValue / 4)) {
          dist.put(edge.to, candidate)
          changed = true
        }
      }

      if (!changed) {
        val best = finalNodes.flatMap(dist.get).max
        val signedBest = if (sign > 0) best else -best
        return intBound(signedBest)
      }
    }

    for {
      from <- nodes.iterator
      if canReachFinal(from)
      base <- dist.get(from).iterator
      edge <- outgoing.getOrElse(from, Vector.empty).iterator
      if canReachFinal(edge.to)
    } {
      val candidate = base + sign.toLong * edge.weight
      if (candidate > dist.getOrElse(edge.to, Long.MinValue / 4))
        return None
    }

    val best = finalNodes.flatMap(dist.get).max
    val signedBest = if (sign > 0) best else -best
    intBound(signedBest)
  }

  private def intBound(value : Long) : Option[Int] =
    if (Int.MinValue <= value && value <= Int.MaxValue)
      Some(value.toInt)
    else
      None
}
