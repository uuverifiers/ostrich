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

import ostrich.automata.afa2.{Step, Left, Right, StepTransition}

/** Can convert more 2AFA then StateDuplicator, but might produce bigger automata. */
object AFA2StateExpander {

  def apply(aut: AFA2): AFA2 = {
    if (aut.states.toSet == aut.irStates ++ aut.llStates ++ aut.lrStates ++
      aut.rlStates ++ aut.rrStates ++ aut.rfStates) {
      aut
    } else {
      construct(aut, aut.letters)
    }
  }

  def construct(aut: AFA2, alphabet: Seq[Int]): AFA2 = {
    assert(aut.initialStates.nonEmpty, "2AFA must have at least one initial state")
    assert(aut.finalStates.nonEmpty, "2AFA must have at least one final state")
    assert(alphabet.nonEmpty, "Alphabet must not be empty")
    assert((aut.initialStates.toSet & aut.finalStates.toSet).isEmpty, "Initial and final states must be disjoint")
    assert(
      aut.initialStates.forall { state =>
        val outgoing = aut.transitions.getOrElse(state, Seq())
        outgoing.nonEmpty && outgoing.forall(_.step == Right)
      },
      "Initial states must have at least one outgoing transition and all outgoing transitions must move right"
    )
    assert(
      aut.finalStates.forall { state =>
        val incoming =
          for {
            (_, transitions) <- aut.transitions.toSeq
            transition <- transitions
            if transition.targets.contains(state)
          } yield transition

        incoming.nonEmpty && incoming.forall(_.step == Right)
      },
      "Final states must have at least one incoming transition and all incoming transitions must move right"
    )

    var newInitialStates = Seq[Int]()
    var newFinalStates = Seq[Int]()
    var newTransitions = Map[Int, Seq[StepTransition]]()

    val oldStates: Seq[Int] = aut.states.sorted
    val stateToIndex: Map[Int, Int] = oldStates.zipWithIndex.toMap

    // decide which states need expansion
    // a state can stay unchanged if it is already in exactly one S2AFA category
    // inital and final states allways need to be expanded
    val alreadyCategorizedStates =
      aut.irStates ++ aut.llStates ++ aut.lrStates ++
        aut.rlStates ++ aut.rrStates ++ aut.rfStates

    val statesToExpand = aut.states.filter(state => !alreadyCategorizedStates.contains(state)).toSet ++
      aut.initialStates ++ aut.finalStates

    // OPTIMIZATION: Only expand the states that need to be expanded
    def isExpanded(state: Int): Boolean = {
      statesToExpand.contains(state)
    }

    // four copies for every state (start from safe offset)
    val firstCopyState = oldStates.max + 1
    def ll(s: Int): Int = firstCopyState + 4 * stateToIndex(s)
    def lr(s: Int): Int = firstCopyState + 4 * stateToIndex(s) + 1
    def rl(s: Int): Int = firstCopyState + 4 * stateToIndex(s) + 2
    def rr(s: Int): Int = firstCopyState + 4 * stateToIndex(s) + 3

    // create fresh dummy states for simulated epsilon transitions
    var firstDummyState = firstCopyState + 5 * (oldStates.size + 1)
    def freshState(): Int = {
      val state = firstDummyState
      firstDummyState = firstDummyState + 1
      state
    }

    // add one transition to the transition map
    def addTransition(source: Int, transition: StepTransition): Unit = {
      val oldTransitions = newTransitions.getOrElse(source, Seq())
      newTransitions = newTransitions + (source -> (oldTransitions :+ transition))
    }

    // choose the source copies based on the outgoing direction.
    def getSourceCopyStates(source: Int, step: Step): Seq[Int] = {
      if (!isExpanded(source)) {
        Seq(source)
      } else {
        step match {
          case Left =>
            Seq(ll(source), rl(source))

          case Right =>
            Seq(lr(source), rr(source))
        }
      }
    }

    // choose the target copies based on the incoming direction.
    def getTargetCopyStates(target: Int, step: Step): Seq[Int] = {
      if (!isExpanded(target)) {
        Seq(target)
      } else {
        step match {
          case Left =>
            Seq(ll(target), lr(target))

          case Right =>
            Seq(rl(target), rr(target))
        }
      }
    }

    // simulate epsilon transition with:
    // source --Right--> dummy --Left--> target
    def addFirstCaseSimulatedEpsilon(source: Int, target: Int): Unit = {
      val dummy = freshState()

      for (label <- alphabet) {
        addTransition(source, StepTransition(label, Right, Seq(dummy)))
        addTransition(dummy, StepTransition(label, Left, Seq(target)))
      }
    }

    // simulate epsilon transition with:
    // source --Left--> dummy --Right--> target
    def addSecondCaseSimulatedEpsilon(source: Int, target: Int): Unit = {
      val dummy = freshState()

      for (label <- alphabet) {
        addTransition(source, StepTransition(label, Left, Seq(dummy)))
        addTransition(dummy, StepTransition(label, Right, Seq(target)))
      }
    }

    // === STATE EXPANSION ===
    // let copy states inherit the transitions
    for ((oldSource, oldOutgoingTransitions) <- aut.transitions) {
      for (oldTransition <- oldOutgoingTransitions) {

        val label = oldTransition.label
        val step = oldTransition.step
        val oldTargets = oldTransition.targets

        // get new source states
        val newSources = getSourceCopyStates(oldSource, step)

        // get new target states
        val newTargets =
          for (oldTarget <- oldTargets) yield {
            getTargetCopyStates(oldTarget, step)
          }

        // add one updated transition for every new source state
        for (newSource <- newSources) {
          addTransition(newSource, StepTransition(label, step, newTargets.flatten))
        }
      }
    }

    // add simulated epsilon transitions between the four copies of every old state
    for (oldState <- statesToExpand) {
      addFirstCaseSimulatedEpsilon(rr(oldState), lr(oldState))
      addFirstCaseSimulatedEpsilon(lr(oldState), ll(oldState))
      addSecondCaseSimulatedEpsilon(ll(oldState), rl(oldState))
      addSecondCaseSimulatedEpsilon(rl(oldState), rr(oldState))
    }

    // === FINAL STATES ===
    // create one fresh state that becomes a final state
    val freshFinalState = freshState()
    newFinalStates = Seq(freshFinalState)

    // add a simulated epsilon transition to the fresh final state
    // from the ll copy of all old final states
    // but only if the old final state was expanded,
    // otherwise drop the fresh final and use the old as final
    for (oldFinalState <- aut.finalStates) {
      addSecondCaseSimulatedEpsilon(ll(oldFinalState), freshFinalState)
    }

    // === INITIAL STATES ===
    // create one fresh state that becomes an initial state
    val freshInitialState = freshState()
    newInitialStates = Seq(freshInitialState)

    // add a simulated epsilon transition from the fresh initial state
    // to the lr copies of the old inital states
    for (oldInitialState <- aut.initialStates) {
      addFirstCaseSimulatedEpsilon(freshInitialState, lr(oldInitialState))
    }

    AFA2(newInitialStates, newFinalStates, newTransitions).restrictToReachableStates
  }
}