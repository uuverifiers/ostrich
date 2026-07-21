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
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED.
 */

package ostrich.automata

import ostrich.automata.Transducer.{NOP, OutputOp, Plus}

import scala.collection.mutable.{HashMap => MHashMap, HashSet => MHashSet}

object CertifiedModuloExtractor {

  type Certificate = ExtractorCertificate
  val Certificate = ExtractorCertificate

  private type State = BricsAutomaton#State

  private case class CycleState(next : State, stop : Option[Int])
  private case class Piece(lower : Int,
                           upper : Int,
                           operation : OutputOp,
                           destination : State) {
    val size : Long = upper.toLong - lower.toLong + 1L
  }

  /**
   * Recognise the exact stop-on-character modulo extractor used by the
   * automatic-island rule. Predicate names are deliberately irrelevant.
   */
  def certify(transducer : Transducer) : Option[ExtractorCertificate] =
      transducer match {
    case transducer : BricsTransducer => certifyBrics(transducer)
    case _                            => None
  }

  private def certifyBrics(
      transducer : BricsTransducer) : Option[ExtractorCertificate] = {
    if (transducer.eTrans.valuesIterator.exists(_.nonEmpty))
      return None

    val states = MHashSet[State](transducer.initialState)
    states ++= transducer.acceptingStates
    states ++= transducer.lblTrans.keys
    for (transitions <- transducer.lblTrans.valuesIterator;
         (_, _, destination) <- transitions)
      states += destination

    if (states.size < 2 || transducer.acceptingStates != states.toSet)
      return None

    val partitions = new MHashMap[State, Vector[Piece]]
    for (state <- states)
      transitionPartition(state, transducer) match {
        case Some(partition) => partitions.put(state, partition)
        case None            => return None
      }

    val drains = states.iterator.filter { state =>
      partitions(state).forall {
        case Piece(_, _, OutputOp(pre, NOP, post), destination) =>
          pre.isEmpty && post.isEmpty && destination == state
        case _ => false
      }
    }.toVector

    if (drains.size != 1)
      return None
    val drain = drains.head
    val cycle = states.toSet - drain
    if (!cycle.contains(transducer.initialState))
      return None

    val analyses = new MHashMap[State, CycleState]
    for (state <- cycle) {
      analyseCycleState(state, drain, cycle, partitions(state)) match {
        case Some(analysis) => analyses.put(state, analysis)
        case None           => return None
      }
    }

    val copyingStates = analyses.iterator.collect {
      case (state, CycleState(_, Some(stop))) => (state, stop)
    }.toVector
    if (copyingStates.size != 1)
      return None

    val ordered = Vector.newBuilder[State]
    val seen = MHashSet[State]()
    var current = transducer.initialState
    for (_ <- 0 until cycle.size) {
      if (!seen.add(current))
        return None
      ordered += current
      current = analyses.get(current) match {
        case Some(CycleState(next, _)) => next
        case None                      => return None
      }
    }
    val order = ordered.result()
    if (current != transducer.initialState || seen.toSet != cycle)
      return None

    val (copyingState, stop) = copyingStates.head
    val phase = order.indexOf(copyingState)
    if (phase < 0)
      None
    else
      Some(ExtractorCertificate(order.size, phase, stop))
  }

  private def analyseCycleState(
      state : State,
      drain : State,
      cycle : Set[State],
      partition : Vector[Piece]) : Option[CycleState] = {
    var plusDestination : Option[State] = None
    var nopDestination : Option[State] = None
    var plusCount = 0L
    var nopCount = 0L
    var stop : Option[Int] = None
    var valid = true

    for (piece <- partition; if valid) piece match {
        case Piece(_, _, OutputOp(pre, Plus(0), post), destination)
            if pre.isEmpty && post.isEmpty && cycle.contains(destination) =>
          plusDestination match {
            case Some(previous) if previous != destination => valid = false
            case None => plusDestination = Some(destination)
            case _ =>
          }
          plusCount += piece.size

        case Piece(lower, upper, OutputOp(pre, NOP, post), destination)
            if pre.isEmpty && post.isEmpty && destination == drain =>
          if (stop.nonEmpty || lower != upper)
            valid = false
          else
            stop = Some(lower)
          nopCount += piece.size

        case Piece(_, _, OutputOp(pre, NOP, post), destination)
            if pre.isEmpty && post.isEmpty && cycle.contains(destination) =>
          nopDestination match {
            case Some(previous) if previous != destination => valid = false
            case None => nopDestination = Some(destination)
            case _ =>
          }
          nopCount += piece.size

        case _ =>
          valid = false
      }

    if (!valid)
      None
    else if (plusCount == 0 && nopCount == OstrichAlphabetSize && stop.isEmpty)
      nopDestination.map(CycleState(_, None))
    else if (plusCount == OstrichAlphabetSize - 1 && nopCount == 1 &&
             stop.nonEmpty && nopDestination.isEmpty)
      plusDestination.map(CycleState(_, stop))
    else
      None
  }

  /** Check exact totality and determinism without enumerating all characters. */
  private def transitionPartition(
      state : State,
      transducer : BricsTransducer) : Option[Vector[Piece]] = {
    val pieces = transducer.lblTrans.getOrElse(state, Set.empty).toVector.map {
      case ((lower, upper), operation, destination) =>
        Piece(lower.toInt, upper.toInt, operation, destination)
    }.sortBy(piece => (piece.lower, piece.upper))

    var next = Char.MinValue.toInt
    for (piece <- pieces) {
      if (piece.lower != next || piece.upper < piece.lower)
        return None
      next = piece.upper + 1
    }
    if (next != Char.MaxValue.toInt + 1)
      None
    else
      Some(pieces)
  }

  private val OstrichAlphabetSize = Char.MaxValue.toInt + 1
}
