/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2023 Philipp Ruemmer. All rights reserved.
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

package ostrich.automata.afa2.concrete

import ap.util.Combinatorics
import ostrich.automata.afa2.StepTransition
import ostrich.automata.afa2.symbolic.SymbEpsReducer
import ostrich.automata.{AutomataUtils, BricsAutomaton, BricsAutomatonBuilder}

import java.util.concurrent.atomic.{AtomicBoolean, AtomicInteger}
import java.util.concurrent.{ConcurrentHashMap, ConcurrentLinkedQueue, Executors, LinkedBlockingQueue, TimeUnit}
import scala.collection.mutable.{MultiMap, HashMap => MHashMap, HashSet => MHashSet, Set => MSet}

object NFATranslatorParallel {
  def apply(afa: AFA2): BricsAutomaton =
    new ParallelNFATranslator(afa).result
}


class ParallelNFATranslator(afa : AFA2) {

  import afa._
  import ostrich.automata.afa2.{Left, Right, Step}

  // union of categorised states
  private val categorisedStates =
    irStates ++ llStates ++ lrStates ++ rlStates ++ rrStates ++ rfStates

  // state set and union of categorized state sets must be the same
  assert(states.toSet == categorisedStates &&
    states.size == irStates.size + llStates.size + lrStates.size +
      rlStates.size + rrStates.size + rfStates.size,
    "2AFA states cannot be classified into ir, ll, lr, rl, rr, rf. " +
      "Problem states: " +
      (states filterNot categorisedStates).mkString(", "))

  // only one inital state
  assert(irStates.size == 1)

  assert(transitions forall {
    case (_, ts) => ts forall {
      case StepTransition(_, _, targets) => targets.nonEmpty
    }},
    "Transitions with zero target states are not supported")

  // TODO: check that automaton is not looping
  // (requires Parikh image computation)

  private val activeWorkers = new AtomicInteger(0)
  private val maxActiveWorkers = new AtomicInteger(0)

  type MacroState = Set[Int]
  case class Edge(from: MacroState,  label: Int, to: MacroState)
  case class EpsilonEdge(from: MacroState, to: MacroState)

  // states that leave by moving right
  private val xrStates = irStates ++ rrStates ++ lrStates

  // states that leave by moving left
  private val xlStates = llStates ++ rlStates

  // states that were entered by moving right
  private val rxStates = rfStates ++ rrStates ++ rlStates

  // states that were entered by moving left
  private val lxStates = llStates ++ lrStates

  // get all transitions from state that read the given label
  def outgoing(state: Int, label: Int): Seq[(Step, Seq[Int])] = {
    transitions.getOrElse(state, List())
      .filter(_.label == label)
      .map(t => (t.step, t.targets))
  }

  // check if there is a left-moving transition whose targets satisfy the condition
  def existsGoingLeft(transitions: Seq[(Step, Seq[Int])], condition: Seq[Int] => Boolean): Boolean =
    transitions.exists(t => t._1 == Left && condition(t._2))

  // check if there is a right-moving transition whose targets satisfy the condition
  def existsGoingRight(transitions: Seq[(Step, Seq[Int])], condition: Seq[Int] => Boolean): Boolean =
    transitions.exists(t => t._1 == Right && condition(t._2))

  // Condition 3: (no sink states in Q)
  // Final-right and right-left states cannot occur in the source macro-state
  def possibleFromState(state : Int) : Boolean = {
    (!(rfStates contains state)) && (!(rlStates contains state))
  }

  /** Checks whether a state can be part of Q while satisfying conditions 3, 5, and 7. */
  def possibleFromState(state : Int, label : Int, toStates : Set[Int]) : Boolean = {
    // Condition 3: (no sink states in Q)
    possibleFromState(state) && (
      // Condition 5: Right-successors.
      // Every xr state (left from left to right) in Q must have a right transition whose
      // existential target is in Q' or whose universal targets are all in Q'.
      !(xrStates contains state) || outgoing(state, label).exists(t => t._1 == Right && t._2.forall(toStates.contains))
      ) && (
      // Condition 7: every lx state in Q (entered from right to left)
      // must have a matching left-moving transition from some state in Q' back to it
      !(lxStates contains state) || toStates.exists(toState =>
        outgoing(toState, label).exists(t => t._1 == Left && t._2.contains(state)))
      )
  }

  // Condition 4: no source states in Q'
  def possibleToState(state : Int) : Boolean = {
    (!(irStates contains state)) && (!(lrStates contains state))
  }

  /** Checks whether a state can be part of Q' while satisfying conditions 4, 6, and 8. */
  def possibleToState(state : Int, label : Int, fromStates : Set[Int]) : Boolean = {
    // Condition 4: no source states in Q'
    possibleToState(state) && (
      // Condition 6: every xl state in Q' (leaves by moving left)
      // must have a left-moving transition whose targets are contained in Q
      !(xlStates contains state) ||
        outgoing(state, label).exists(t => t._1 == Left && t._2.forall(fromStates.contains))
      ) && (
      // Condition 8: every rx state in Q' (entered from left to right)
      // must have a matching right-moving transition from some state in Q to this state
      !(rxStates contains state) || fromStates.exists(fromState =>
          outgoing(fromState, label).exists(t => t._1 == Right && t._2.contains(state)))
      )
  }

  private val edges = new ConcurrentLinkedQueue[Edge]()
  private val epsilonEdges = new ConcurrentLinkedQueue[EpsilonEdge]()
  private val discovered = ConcurrentHashMap.newKeySet[Set[Int]]()
  private val workQueue = new LinkedBlockingQueue[Set[Int]]()
  private val pendingStates = new AtomicInteger(0)

  // initial state is {init}
  private val initialMacroStates = irStates.map(s => Set(s))
  for (state <- initialMacroStates)
    schedule(state)

  // schedules the successor states that are reachable via epsilon transitions
  // defined by Condition 1 and 2
  def addEPSReachableStates(state: MacroState): Unit = {
    // lr states can be added anytime
    for (lrState <- lrStates.iterator;
         if !(state contains lrState)) {

      val target = state + lrState
      epsilonEdges.add(EpsilonEdge(state, target))
      schedule(target)
    }

    // rl states can be removed anytime
    for (rlState <- rlStates.iterator;
         if (state contains rlState)) {

      val target = state - rlState
      epsilonEdges.add(EpsilonEdge(state, target))
      schedule(target)
    }
  }

  // Computes the possible Q' states that can support each lx state in Q.
  // A state can support an lx state if it has a left-moving transition
  // that contains the lx state and whose targets are all contained in Q.
  def leftPredecessorChoices(fromStates: MacroState, label: Int): Seq[Seq[Set[Int]]] = {
    for {
      state <- fromStates.toSeq
      if lxStates contains state
    } yield {
      for {
        toState <- states
        if existsGoingLeft(
          outgoing(toState, label),
          targets =>
            (targets contains state) &&
              (targets forall fromStates)
        )
      } yield Set(toState)
    }
  }

  // Computes the possible right-successor sets that support a state in Q'.
  // The state must occur in the target set of a right-moving transition from Q.
  // The complete target set is returned because all targets must be contained in Q'.
  def rightSuccessorChoices(state: Int, fromStates: MacroState, label: Int): Seq[Set[Int]] = {
    if (!(rxStates contains state))
      return Seq(Set.empty)

    for {
      fromState <- fromStates.toSeq
      (Right, targets) <- outgoing(fromState, label)
      if targets contains state
    } yield targets.toSet
  }

  def satisfyRequirement(candidates: Seq[MacroState],choices: Seq[Set[Int]],upperBound: MacroState):
    Seq[MacroState] = {

    var result: Seq[MacroState] = Seq()

    // Check every candidate Q' separately
    for (candidate <- candidates) {

      // If the candidate already contains one of the possible choices,
      // the requirement is already satisfied.
      var alreadySatisfied = false
      for (choice <- choices) {
        if (choice subsetOf candidate) {
          alreadySatisfied = true
        }
      }

      if (alreadySatisfied) {
        result = result :+ candidate
      } else {

        // Otherwise, try every possible choice by adding it to Q'.
        for (choice <- choices) {
          val newCandidate = candidate ++ choice

          // Only keep candidates containing states that are allowed in Q'.
          if (newCandidate subsetOf upperBound) {
            result = result :+ newCandidate
          }
        }
      }
    }

    // Different choices can produce the same macro-state.
    result.distinct
  }

  // Build Q' directly:
  // Condition 5  -> add required right-transition targets
  // Condition 7  -> add required left predecessors
  // Condition 8  -> repeatedly add required right-transition targets
  // Condition 6  -> guaranteed because every Q' stays inside upperToBound

  def addLabelReachableStates(fromStates: MacroState): Unit = {

    // if there is a state in the fromStates that has no valid successor
    // for example a right final state or a lr turn around state we can stop
    if (fromStates exists { s => !possibleFromState(s) })
      return

    // generate successors independently for every possible input letter
    for (label <- letters) {
      // start with the empty set
      var targetCandidates: Seq[MacroState] = Seq(Set.empty[Int])

      // compute the largest possible target macro state
      // any state that fails possibleToState can never occur in a successor
      val upperToBound =
        (for (s <- states.iterator; if possibleToState(s, label, fromStates))
          yield s).toSet

      if (upperToBound.nonEmpty) {
        // satisfy condition 5
        // Q -> Q'
        for (state <- fromStates if xrStates contains state) {
          var choices: Seq[Set[Int]] = Seq()
          for ((step, targets) <- outgoing(state, label)) {
            if (step == Right) {
              choices = choices :+ targets.toSet
            }
          }

          targetCandidates =
            satisfyRequirement(
              targetCandidates,
              choices,
              upperToBound
            )
        }

        // satisfy condition 7
        // Q <- Q'
        for (choices <- leftPredecessorChoices(fromStates, label)) {
          targetCandidates =
            satisfyRequirement(
              targetCandidates,
              choices,
              upperToBound
            )
        }

        // satisfy Condition 8
        // Every rx state in Q' needs a right-moving transition from Q
        // whose complete target set is contained in Q'
        // Adding such a target set can introduce new rx states, so this
        // has to be repeated until every candidate is fully supported
        var allCandidatesSupported = false
        while (!allCandidatesSupported) {
          allCandidatesSupported = true
          var nextCandidates: Seq[MacroState] = Seq()
          for (candidate <- targetCandidates) {
            // Find one rx state in this candidate that is not yet supported
            var unsupportedState: Option[Int] = None
            for (state <- candidate) {
              if ((rxStates contains state) && unsupportedState.isEmpty) {
                val supports = rightSuccessorChoices(state, fromStates, label)

                // Condition 8 is satisfied for this state if at least one
                // complete right-transition target set is contained in Q'
                val supported = supports.exists(support => support subsetOf candidate)

                if (!supported) {
                  unsupportedState = Some(state)
                }
              }
            }

            unsupportedState match {
              case None =>
                // Every rx state in this candidate is supported.
                nextCandidates = nextCandidates :+ candidate
              case Some(state) =>
                // This candidate still needs to be extended.
                allCandidatesSupported = false
                val supports = rightSuccessorChoices(state, fromStates, label)

                // Try every possible transition that could support the state.
                for (support <- supports) {
                  val newCandidate = candidate ++ support

                  // Conditions 4 and 6 must still hold for every state
                  // that was added to Q'.
                  if (newCandidate subsetOf upperToBound) {
                    nextCandidates = nextCandidates :+ newCandidate
                  }
                }
            }
          }

          // Different choices can result in the same Q'.
          targetCandidates = nextCandidates.distinct
        }

        // Avoid adding the same successor more than once for this Q and label
        val consideredToStates = new MHashSet[MacroState]
        for (candidate <- targetCandidates) {
          if (consideredToStates add candidate) {
            edges.add(
              Edge(fromStates, label, candidate)
            )
            schedule(candidate)
          }
        }
      }
    }
  }

  // parallel computation with worker pool
  private def schedule(state: Set[Int]): Unit = {
    if (discovered.add(state)) {
      pendingStates.incrementAndGet()
      workQueue.put(state)
    }
  }

  private val workerCount =
    math.max(1, Runtime.getRuntime.availableProcessors())

  private val executor =
    Executors.newFixedThreadPool(workerCount)

  private val workers =
    for (_ <- 0 until workerCount) yield {
      executor.submit(new Runnable {
        override def run(): Unit = {
          var running = true

          while (running) {
            if (pendingStates.get() == 0) {
              running = false
            } else {
              val state =
                workQueue.poll(50, TimeUnit.MILLISECONDS)

              if (state != null) {
                try {
                  ap.util.Timeout.check

                  val active = activeWorkers.incrementAndGet()
                  var old = maxActiveWorkers.get()
                  while (active > old &&
                    !maxActiveWorkers.compareAndSet(old, active))
                    old = maxActiveWorkers.get()

                  addEPSReachableStates(state)
                  addLabelReachableStates(state)

                } finally {
                  activeWorkers.decrementAndGet()
                  pendingStates.decrementAndGet()
                }
              }
            }
          }
        }
      })
    }

  executor.shutdown()

  for (worker <- workers)
    worker.get()

  // build the bricks automaton
  val forwardReachable = new MHashSet[MacroState]
  val backwardReachable = new MHashSet[MacroState]
  getReachableStates()
  val usefulStates = forwardReachable.intersect(backwardReachable)

  // print reachability stats
  val usefulPercent =
    if (discovered.size() == 0) 0.0
    else usefulStates.size.toDouble / discovered.size() * 100.0

  println("Total discovered states: " + discovered.size())
  println("Forward reachable states: " + forwardReachable.size)
  println("Backward reachable states: " + backwardReachable.size)
  println("Forward + backward reachable states: " + usefulStates.size)
  println(f"Useful states: $usefulPercent%.2f%%")

  // This takes way to long!
  /*
  // print dominated states after reachability pruning
  val relation = computeDominanceRelation(usefulStates.toSet)
  var dominatedStates: Set[MacroState] = Set()
  for ((p, q) <- relation) {
    if (p != q) {
      dominatedStates = dominatedStates + q
    }
  }

  val dominatedPercent =
    if (usefulStates.isEmpty) 0.0
    else dominatedStates.size.toDouble / usefulStates.size * 100.0

  println("Dominated useful states: " + dominatedStates.size)
  println(f"Dominated useful states: $dominatedPercent%.2f%%")
  **/

  // 1. Step: Add states and mark inital/final
  val statesStart = System.nanoTime()
  val builder = new BricsAutomatonBuilder
  builder.setMinimize(true)

  val setStates = new MHashMap[MacroState, BricsAutomaton#State]

  private val stateIterator = usefulStates.iterator
  while (stateIterator.hasNext) {
    val state = stateIterator.next()
    val bricsState = builder.getNewState

    if (state subsetOf rfStates)
      builder.setAccept(bricsState, true)

    setStates.put(state, bricsState)
  }

  for (state <- initialMacroStates)
    builder.setInitialState(setStates(state))

  println("Add states: " + (System.nanoTime() - statesStart) / 1000000 + " ms")

  // 2. Step: Add epsilon edges
  val epsilonStart = System.nanoTime()
  val epsilons =
    new MHashMap[BricsAutomaton#State, MSet[BricsAutomaton#State]]
      with MultiMap[BricsAutomaton#State, BricsAutomaton#State]

  private val epsilonIterator = epsilonEdges.iterator()
  while (epsilonIterator.hasNext) {
    val edge = epsilonIterator.next()
    if ((usefulStates contains edge.from) &&
      (usefulStates contains edge.to)) {
      epsilons.addBinding(
        setStates(edge.from),
        setStates(edge.to)
      )
    }
  }

  println("Collect epsilon edges: " + (System.nanoTime() - epsilonStart) / 1000000 + " ms")

  // 3. Step: Add sigma transitions
  val transitionStart = System.nanoTime()
  private val edgeIterator = edges.iterator()
  while (edgeIterator.hasNext) {
    val edge = edgeIterator.next()
    if ((usefulStates contains edge.from) &&
      (usefulStates contains edge.to)) {
      builder.addTransition(
        setStates(edge.from),
        (edge.label.toChar, edge.label.toChar),
        setStates(edge.to)
      )
    }
  }
  println("Add sigma transitions: " + (System.nanoTime() - transitionStart) / 1000000 + " ms")

  val buildEpsilonStart = System.nanoTime()
  AutomataUtils.buildEpsilons(builder, epsilons)
  println("Build epsilons: " + (System.nanoTime() - buildEpsilonStart) / 1000000 + " ms")

  val getAutomatonStart = System.nanoTime()
  val result: BricsAutomaton = builder.getAutomaton
  println("Get/minimize automaton: " + (System.nanoTime() - getAutomatonStart) / 1000000 + " ms")

  println("Max active workers: " + maxActiveWorkers.get())
  println("Parallel-NFA size: " + result.states.size)

  def getReachableStates(): Unit = {
    val forwardEdges =  new MHashMap[MacroState, MHashSet[MacroState]]
    val backwardEdges = new MHashMap[MacroState, MHashSet[MacroState]]

    // Add sigma transitions
    val edgeIterator = edges.iterator()
    while (edgeIterator.hasNext) {
      val edge = edgeIterator.next()
      val forward = forwardEdges.getOrElseUpdate(edge.from, new MHashSet[MacroState])
      forward.add(edge.to)
      val backward = backwardEdges.getOrElseUpdate(edge.to, new MHashSet[MacroState])
      backward.add(edge.from)
    }

    // Add epsilon transitions
    val epsilonIterator = epsilonEdges.iterator()
    while (epsilonIterator.hasNext) {
      val edge = epsilonIterator.next()
      val forward = forwardEdges.getOrElseUpdate(edge.from, new MHashSet[MacroState])
      forward.add(edge.to)
      val backward = backwardEdges.getOrElseUpdate(edge.to, new MHashSet[MacroState])
      backward.add(edge.from)
    }

    // Compute forward reachable states
    val forwardQueue = new scala.collection.mutable.Queue[MacroState]

    for (state <- initialMacroStates) {
      forwardReachable.add(state)
      forwardQueue.enqueue(state)
    }

    while (forwardQueue.nonEmpty) {
      val state = forwardQueue.dequeue()
      for (next <- forwardEdges.getOrElse(state, MHashSet.empty)) {
        if (forwardReachable.add(next)) {
          forwardQueue.enqueue(next)
        }
      }
    }

    // Compute backward reachable states
    val backwardQueue = new scala.collection.mutable.Queue[MacroState]

    val discoveredIterator = discovered.iterator()
    while (discoveredIterator.hasNext) {
      val state = discoveredIterator.next()
      if (state subsetOf rfStates) {
        backwardReachable.add(state)
        backwardQueue.enqueue(state)
      }
    }

    while (backwardQueue.nonEmpty) {
      val state = backwardQueue.dequeue()
      for (previous <- backwardEdges.getOrElse(state, MHashSet.empty)) {
        if (backwardReachable.add(previous)) {
          backwardQueue.enqueue(previous)
        }
      }
    }
  }

  def computeDominanceRelation(states: Set[MacroState]): MHashSet[(MacroState, MacroState)] = {

    // Collect outgoing sigma transitions.
    val sigmaTransitions = new MHashMap[MacroState, MHashSet[(Int, MacroState)]]
    val edgeIterator = edges.iterator()
    while (edgeIterator.hasNext) {
      val edge = edgeIterator.next()
      if ((states contains edge.from) &&
        (states contains edge.to)) {
        val targets = sigmaTransitions.getOrElseUpdate(edge.from, new MHashSet[(Int, MacroState)])
        targets.add((edge.label, edge.to))
      }
    }

    // Collect outgoing epsilon transitions.
    val epsilonTransitions = new MHashMap[MacroState, MHashSet[MacroState]]
    val epsilonIterator = epsilonEdges.iterator()
    while (epsilonIterator.hasNext) {
      val edge = epsilonIterator.next()
      if ((states contains edge.from) &&
        (states contains edge.to)) {
        val targets = epsilonTransitions.getOrElseUpdate(edge.from, new MHashSet[MacroState])
        targets.add(edge.to)
      }
    }

    // Check whether p can locally dominate q.
    def pairIsLocallyValid(p: MacroState, q: MacroState): Boolean = {
      // A non-final state cannot dominate a final state.
      val pFinal = p subsetOf rfStates
      val qFinal = q subsetOf rfStates
      if (qFinal && !pFinal)
        return false

      // Every sigma label available at q must also be available at p.
      val pLabels = sigmaTransitions.getOrElse(p, Seq()).map(t => t._1).toSet
      val qLabels = sigmaTransitions.getOrElse(q, Seq()).map(t => t._1).toSet
      if (!(qLabels subsetOf pLabels))
        return false

      // If q can take an epsilon transition, p must also be able to.
      val pHasEpsilon = epsilonTransitions.getOrElse(p, Seq()).nonEmpty
      val qHasEpsilon =  epsilonTransitions.getOrElse(q, Seq()).nonEmpty
      if (qHasEpsilon && !pHasEpsilon)
        return false

      true
    }

    // Initially assume every locally valid pair is in the relation.
    var relation = new MHashSet[(MacroState, MacroState)]
    for (p <- states) {
      for (q <- states) {
        if (pairIsLocallyValid(p, q)) {
          relation.add((p, q))
        }
      }
    }

    // Check whether p can simulate all transitions of q.
    def pairIsValid(p: MacroState, q: MacroState): Boolean = {
      val pSigma = sigmaTransitions.getOrElse(p, Seq())
      val qSigma = sigmaTransitions.getOrElse(q, Seq())

      // Every sigma transition of q must be matched by
      // a sigma transition of p with the same label
      // and the target states also need to be in the relation.
      // So the target of p must dominate the target of q.
      for ((qLabel, qTarget) <- qSigma) {
        var matched = false
        for ((pLabel, pTarget) <- pSigma) {
          if (pLabel == qLabel && relation.contains((pTarget, qTarget))) {
            matched = true
          }
        }

        if (!matched)
          return false
      }

      val pEpsilon = epsilonTransitions.getOrElse(p, Seq())
      val qEpsilon = epsilonTransitions.getOrElse(q, Seq())

      // Every epsilon transition of q must be matched by
      // an epsilon transition of p.
      for (qTarget <- qEpsilon) {
        var matched = false
        for (pTarget <- pEpsilon) {
          if (relation.contains((pTarget, qTarget))) {
            matched = true
          }
        }

        if (!matched)
          return false
      }

      true
    }

    // Compute the greatest fixpoint.
    var changed = true
    while (changed) {
      val newRelation = new MHashSet[(MacroState, MacroState)]
      for ((p, q) <- relation) {
        if (pairIsValid(p, q)) {
          newRelation.add((p, q))
        }
      }

      changed = newRelation.size != relation.size
      relation = newRelation
    }

    relation
  }
}

