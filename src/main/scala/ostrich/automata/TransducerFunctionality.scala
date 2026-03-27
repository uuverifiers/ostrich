/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Matthew Hague, Philipp Ruemmer, Oliver Markgraf.
 * All rights reserved.
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

import ap.util.Tarjan

import scala.collection.mutable.{ArrayBuffer,
                                 HashMap => MHashMap,
                                 HashSet => MHashSet,
                                 Queue => MQueue,
                                 Stack => MStack}

/**
 * Lightweight sanity check for declared non-functional transducers.
 *
 * The implementation is intentionally modest: it explores the transducer
 * self-product while synchronising runs on consumed input, keeps a bounded
 * explicit residue, and uses SCC reachability on the underlying product graph
 * to recognise accepting continuations for conflicting prefixes.
 */
object TransducerFunctionality {

  sealed trait Result
  case object NoIssueFound extends Result
  case object NonFunctional extends Result

  private val MaxExplicitDelay = 8

  private sealed trait Delay
  private case object Equal extends Delay
  private case class LeftExtra(word : String) extends Delay
  private case class RightExtra(word : String) extends Delay
  private case object Conflict extends Delay

  private sealed trait DelayUpdate
  private case class NextDelay(delay : Delay) extends DelayUpdate
  private case object DelayOverflow extends DelayUpdate

  private case class PairState(left : BricsAutomaton#State,
                               right : BricsAutomaton#State)
  private case class Config(pair : PairState, delay : Delay)

  private sealed trait PairStep {
    def next : PairState
    def advance(delay : Delay) : Iterator[DelayUpdate]
  }

  private case class LeftEpsilonStep(op : Transducer.OutputOp,
                                     next : PairState) extends PairStep {
    def advance(delay : Delay) : Iterator[DelayUpdate] =
      for (leftOut <- epsilonOutput(op).iterator)
      yield combineDelay(delay, leftOut, "")
  }

  private case class RightEpsilonStep(op : Transducer.OutputOp,
                                      next : PairState) extends PairStep {
    def advance(delay : Delay) : Iterator[DelayUpdate] =
      for (rightOut <- epsilonOutput(op).iterator)
      yield combineDelay(delay, "", rightOut)
  }

  private case class LabelSyncStep(leftLabel : (Char, Char),
                                   leftOp : Transducer.OutputOp,
                                   rightLabel : (Char, Char),
                                   rightOp : Transducer.OutputOp,
                                   next : PairState) extends PairStep {
    def advance(delay : Delay) : Iterator[DelayUpdate] =
      BricsTLabelOps.intersectLabels(leftLabel, rightLabel) match {
        case Some(overlap) =>
          val candidates = candidateChars(overlap, delay, leftOp, rightOp)
          for (inChar <- candidates.iterator;
               leftOut <- labelOutput(leftOp, inChar).iterator;
               rightOut <- labelOutput(rightOp, inChar).iterator)
          yield combineDelay(delay, leftOut, rightOut)
        case None =>
          Iterator.empty
      }
  }

  def sanityCheck(transducer : Transducer) : Result =
    transducer match {
      case t : BricsTransducer =>
        sanityCheckBrics(t)
      case t : BricsPrioTransducer =>
        sanityCheckBrics(t.bricsTransducer)
      case _ =>
        NoIssueFound
    }

  private def sanityCheckBrics(transducer : BricsTransducer) : Result = {
    val initial = PairState(transducer.initialState, transducer.initialState)

    val stepsForState = new MHashMap[PairState, Vector[PairStep]]
    val reachableStates = new MHashSet[PairState]
    val todoStates = new MStack[PairState]

    reachableStates += initial
    todoStates push initial

    while (!todoStates.isEmpty) {
      val pair = todoStates.pop
      val steps = computeSteps(transducer, pair).toVector
      stepsForState += (pair -> steps)

      for (step <- steps; if reachableStates.add(step.next))
        todoStates push step.next
    }

    val acceptingStates =
      reachableStates filter { pair =>
        transducer.isAccept(pair.left) && transducer.isAccept(pair.right)
      }

    val depGraph = new Tarjan.Graph[PairState] {
      val nodes = reachableStates.toIndexedSeq
      def successors(n : PairState) =
        stepsForState.getOrElse(n, Vector.empty).iterator.map(_.next)
    }

    val sccs = Tarjan(depGraph)

    val sccIndex = new MHashMap[PairState, Int]
    for ((scc, index) <- sccs.iterator.zipWithIndex;
         state <- scc.iterator)
      sccIndex += (state -> index)

    val cyclicSccs = new MHashSet[Int]
    for ((scc, index) <- sccs.iterator.zipWithIndex) {
      val hasSelfLoop =
        scc exists { state =>
          stepsForState.getOrElse(state, Vector.empty) exists (_.next == state)
        }
      if (scc.size > 1 || hasSelfLoop)
        cyclicSccs += index
    }

    val reverseSuccs = new MHashMap[Int, MHashSet[Int]]
    val reachableAcceptingSccs = new MHashSet[Int]
    val sccTodo = new MQueue[Int]

    for (state <- acceptingStates) {
      val index = sccIndex(state)
      if (reachableAcceptingSccs.add(index))
        sccTodo enqueue index
    }

    for ((state, steps) <- stepsForState.iterator;
         succ <- steps.iterator.map(_.next)) {
      val from = sccIndex(state)
      val to = sccIndex(succ)
      if (from != to)
        reverseSuccs.getOrElseUpdate(to, new MHashSet[Int]) += from
    }

    while (!sccTodo.isEmpty) {
      val current = sccTodo.dequeue
      for (preds <- reverseSuccs.get(current);
           pred <- preds.iterator;
           if reachableAcceptingSccs.add(pred))
        sccTodo enqueue pred
    }

    def canReachAccepting(pair : PairState) =
      reachableAcceptingSccs contains sccIndex(pair)

    def inCyclicScc(pair : PairState) =
      cyclicSccs contains sccIndex(pair)

    if (!canReachAccepting(initial))
      return NoIssueFound

    val seenConfigs = new MHashSet[Config]
    val todoConfigs = new MStack[Config]

    val initConfig = Config(initial, Equal)
    seenConfigs += initConfig
    todoConfigs push initConfig

    while (!todoConfigs.isEmpty) {
      val config = todoConfigs.pop

      config.delay match {
        case Conflict =>
          if (canReachAccepting(config.pair))
            return NonFunctional
        case Equal | LeftExtra(_) | RightExtra(_) =>
          if ((config.delay != Equal) &&
              transducer.isAccept(config.pair.left) &&
              transducer.isAccept(config.pair.right))
            return NonFunctional

          for (step <- stepsForState.getOrElse(config.pair, Vector.empty);
               if canReachAccepting(step.next)) {
            for (delayUpdate <- step.advance(config.delay)) {
              delayUpdate match {
                case NextDelay(Conflict) =>
                  if (canReachAccepting(step.next))
                    return NonFunctional
                case NextDelay(nextDelay) =>
                  val nextConfig = Config(step.next, nextDelay)
                  if (seenConfigs.add(nextConfig))
                    todoConfigs push nextConfig
                case DelayOverflow =>
                  if (inCyclicScc(step.next))
                    return NonFunctional
              }
            }
          }
      }
    }

    NoIssueFound
  }

  private def computeSteps(transducer : BricsTransducer,
                           pair : PairState) : Iterator[PairStep] = {
    val epsilonSteps =
      (for (transitions <- transducer.eTrans.get(pair.left).iterator;
            (op, nextLeft) <- transitions.iterator)
       yield LeftEpsilonStep(op, PairState(nextLeft, pair.right))) ++
      (for (transitions <- transducer.eTrans.get(pair.right).iterator;
            (op, nextRight) <- transitions.iterator)
       yield RightEpsilonStep(op, PairState(pair.left, nextRight)))

    val syncSteps =
      for (leftTransitions <- transducer.lblTrans.get(pair.left).iterator;
           (leftLabel, leftOp, nextLeft) <- leftTransitions.iterator;
           rightTransitions <- transducer.lblTrans.get(pair.right).iterator;
           (rightLabel, rightOp, nextRight) <- rightTransitions.iterator;
           if BricsTLabelOps.labelsOverlap(leftLabel, rightLabel))
      yield LabelSyncStep(leftLabel, leftOp, rightLabel, rightOp,
                          PairState(nextLeft, nextRight))

    epsilonSteps ++ syncSteps
  }

  private def epsilonOutput(op : Transducer.OutputOp) : Option[String] =
    op.op match {
      case Transducer.NOP =>
        Some(op.preW.mkString + op.postW.mkString)
      case Transducer.Plus(_) =>
        Some(op.preW.mkString + op.postW.mkString)
      case Transducer.Internal =>
        None
    }

  private def labelOutput(op : Transducer.OutputOp,
                          inChar : Char) : Option[String] =
    op.op match {
      case Transducer.NOP =>
        Some(op.preW.mkString + op.postW.mkString)
      case Transducer.Plus(n) =>
        Some(op.preW.mkString + (inChar + n).toChar + op.postW.mkString)
      case Transducer.Internal =>
        None
    }

  private def candidateChars(overlap : (Char, Char),
                             delay : Delay,
                             leftOp : Transducer.OutputOp,
                             rightOp : Transducer.OutputOp) : Seq[Char] = {
    val (lower, upper) = overlap
    val candidates = new MHashSet[Char]

    candidates += lower
    candidates += upper

    val residualChars = delay match {
      case LeftExtra(word)  => word
      case RightExtra(word) => word
      case _                => ""
    }
    val explicitChars =
      residualChars ++ leftOp.preW.mkString ++ leftOp.postW.mkString ++
      rightOp.preW.mkString ++ rightOp.postW.mkString
    val offsets =
      List(leftOp, rightOp) flatMap {
        case Transducer.OutputOp(_, Transducer.Plus(n), _) => Some(n)
        case _ => None
      }

    for (c <- explicitChars.iterator;
         n <- offsets.iterator) {
      val candidate = c.toInt - n
      if (candidate >= lower.toInt && candidate <= upper.toInt)
        candidates += candidate.toChar
    }

    candidates.toVector.sortBy(_.toInt)
  }

  private def combineDelay(delay : Delay,
                           leftOut : String,
                           rightOut : String) : DelayUpdate = {
    val (leftPrefix, rightPrefix) = delay match {
      case Equal             => ("", "")
      case LeftExtra(word)   => (word, "")
      case RightExtra(word)  => ("", word)
      case Conflict          => return NextDelay(Conflict)
    }

    val leftWord = leftPrefix + leftOut
    val rightWord = rightPrefix + rightOut

    var commonPrefix = 0
    val limit = math.min(leftWord.length, rightWord.length)

    while (commonPrefix < limit &&
           leftWord.charAt(commonPrefix) == rightWord.charAt(commonPrefix))
      commonPrefix = commonPrefix + 1

    val leftRem = leftWord.substring(commonPrefix)
    val rightRem = rightWord.substring(commonPrefix)

    if (leftRem.nonEmpty && rightRem.nonEmpty)
      NextDelay(Conflict)
    else if (leftRem.length > MaxExplicitDelay || rightRem.length > MaxExplicitDelay)
      DelayOverflow
    else if (leftRem.nonEmpty)
      NextDelay(LeftExtra(leftRem))
    else if (rightRem.nonEmpty)
      NextDelay(RightExtra(rightRem))
    else
      NextDelay(Equal)
  }
}
