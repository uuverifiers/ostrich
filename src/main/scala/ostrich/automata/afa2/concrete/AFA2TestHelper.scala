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
import ostrich.automata.afa2.{Right, Left, Step, StepTransition}

object AFA2TestHelper  {
  /** Might also generate a smaller automaton than stateCount! */
  def superRandomAFA2(
                  seed: Long,
                  stateCount: Int,
                  universalProbability: Double = 0.8,
                  leftProbability: Double = 0.1,
                  alphabet: IndexedSeq[Int] = Vector('a'.toInt, 'b'.toInt, 'c'.toInt)
                ): AFA2 = {

    val random = new scala.util.Random(seed)

    // one inital and one final state
    val initialStates = Seq(0)
    val finalStates = Seq(stateCount - 1)

    var transitions = Map[Int, Seq[StepTransition]]()

    for (state <- 0 until stateCount) {
      var outgoingTransitions = Seq[StepTransition]()
      val transitionCount = random.nextInt(stateCount)

      for (_ <- 0 until transitionCount) {
        val label = alphabet(random.nextInt(alphabet.size))

        // no outgoing left transition from inital state
        val direction: Step = if (state != 0 && random.nextDouble() < leftProbability) Left else Right
        val targetCount =
          if (random.nextDouble() < universalProbability)
            2 + random.nextInt(stateCount - 1)
          else
            1

        // Left transitions may not enter a final state
        val possibleTargets =
          if (direction == Left)
            (0 until stateCount - 1)
          else
            (0 until stateCount)

        val targets =
          Seq.fill(targetCount)(
            possibleTargets(random.nextInt(possibleTargets.size))
          ).distinct

        outgoingTransitions :+= StepTransition(
          label,
          direction,
          targets
        )
      }

      transitions += state -> outgoingTransitions
    }

    // force one transition to make the initial and final state valid
    transitions += 0 -> (transitions(0) :+ StepTransition(alphabet(0), Right, Seq(stateCount - 1)))

    AFA2(initialStates, finalStates, transitions).restrictToReachableStates
  }

  // get a random 2AFA
  // we only use right-transitions
  // this avoids looping
  // the initial state only has outgoing transitions
  // the final state only incoming ones
  // so that StateDuplicator does not have any issues
  // we also remove all non-reachable state so that StateDuplicator does not have any issues
  def randomAFA2(
                          seed: Long,
                          stateCount: Int,
                          maxTargetCount: Int = 3,
                          universalProbability: Double = 0.4,
                          alphabet: IndexedSeq[Int] = Vector('a'.toInt, 'b'.toInt, 'c'.toInt)
                        ): AFA2 = {

    val random = new scala.util.Random(seed)

    val initialState = 0
    val finalState = stateCount - 1

    val initialStates = Seq(initialState)
    val finalStates = Seq(finalState)

    var transitions = Map[Int, Seq[StepTransition]]()

    // get random transitions
    for (state <- 0 until finalState) {
      var outgoingTransitions = Seq[StepTransition]()

      var attempt = 0
      while (attempt < 5) {
        if (random.nextDouble() <= 0.5) {
          val label = alphabet(random.nextInt(alphabet.size))

          val targets =
            randomForwardTargets(
              random = random,
              currentState = state,
              finalState = finalState,
              maxTargetCount = maxTargetCount,
              universalProbability = universalProbability
            )

          val transition = StepTransition(label, Right, targets)
          outgoingTransitions = outgoingTransitions :+ transition
        }

        attempt += 1
      }

      // at least one outgoing transition is needed
      if (outgoingTransitions.isEmpty) {
        val transition = StepTransition('a'.toInt, Right, Seq(state + 1))
        outgoingTransitions = outgoingTransitions :+ transition
      }

      transitions = transitions + (state -> outgoingTransitions)
    }

    AFA2(initialStates, finalStates, transitions).restrictToReachableStates
  }

  def randomForwardTargets(
                                    random: scala.util.Random,
                                    currentState: Int,
                                    finalState: Int,
                                    maxTargetCount: Int,
                                    universalProbability: Double
                                  ): Seq[Int] = {

    val firstPossibleTarget = currentState + 1
    val possibleTargets = firstPossibleTarget to finalState
    var targetCount = 1

    if (random.nextDouble() < universalProbability) {
      targetCount = 2 + random.nextInt(maxTargetCount - 1)
    }

    if (targetCount > possibleTargets.size) {
      targetCount = possibleTargets.size
    }

    var targets = Seq[Int]()

    while (targets.size < targetCount) {
      val randomIndex = random.nextInt(possibleTargets.size)
      val target = possibleTargets(randomIndex)

      if (!targets.contains(target)) {
        targets = targets :+ target
      }
    }

    targets
  }

}