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

import scala.collection.mutable.{MultiMap, HashMap => MHashMap, HashSet => MHashSet, Set => MSet}

object NFATranslator {

  // Impose stricter conditions on transitions introduced in the
  // NFA. The resulting minimized automaton should always be the same.
  val StrictConditions = true

  def apply(afa : AFA2, epsRed: SymbEpsReducer) : BricsAutomaton =
    apply(afa, epsRed, None)

  def apply(afa: AFA2, epsRed: SymbEpsReducer, charMap: Option[Map[Int, Range]]): BricsAutomaton =
    new LazyNFATranslator(afa, epsRed, charMap).result

}


class LazyNFATranslator(afa : AFA2, epsRed : SymbEpsReducer, charMap: Option[Map[Int, Range]]) {

  import afa._
  import ostrich.automata.afa2.{Left, Right, Step}

  val categorisedStates =
    irStates ++ llStates ++ lrStates ++ rlStates ++ rrStates ++ rfStates

  assert(states.toSet == categorisedStates &&
         states.size == irStates.size + llStates.size + lrStates.size +
           rlStates.size + rrStates.size + rfStates.size,
         "2AFA states cannot be classified into ir, ll, lr, rl, rr, rf. " +
           "Problem states: " +
           (states filterNot categorisedStates).mkString(", "))

  assert(irStates.size == 1)

  assert(transitions forall {
           case (_, ts) => ts forall {
             case StepTransition(_, _, targets) => !targets.isEmpty
         }},
         "Transitions with zero target states are not supported")

  // TODO: check that automaton is not looping
  // (requires Parikh image computation)

  val xrStates = irStates ++ rrStates ++ lrStates
  val xlStates = llStates ++ rlStates
  val rxStates = rfStates ++ rrStates ++ rlStates
  val lxStates = llStates ++ lrStates


  def outgoing(state : Int, l : Int) : Seq[(Step, Seq[Int])] =
    for (StepTransition(`l`, step, ts) <- transitions.getOrElse(state, List())) yield {
      (step, ts)
    }

  def existsGoingLeft(ts : Seq[(Step, Seq[Int])],
                      f : Seq[Int] => Boolean) : Boolean = {
    ts exists {
      case (Left, targets) => f(targets)
      case _                    => false
    }
  }

  def existsGoingRight(ts : Seq[(Step, Seq[Int])],
                       f : Seq[Int] => Boolean) : Boolean = {
    ts exists {
      case (Right, targets) => f(targets)
      case _                     => false
    }
  }

  def possibleFromState(state : Int) : Boolean = {
    (
      !(rfStates contains state)
    ) && (
      !(rlStates contains state)
    )
  }

  def possibleFromState(state    : Int,
                        label    : Int,
                        toStates : Set[Int]) : Boolean = {
    possibleFromState(state) && (
      // ?r states have successors in toStates
      !(xrStates contains state) ||
        existsGoingRight(outgoing(state, label),
                         targets => targets forall toStates)
    ) && (
      // l? states have predecessors in toStates
      !(lxStates contains state) ||
        (toStates exists { toState =>
           existsGoingLeft(outgoing(toState, label),
                           targets => targets contains state)
         })
    )
  }

  /**
   * If <code>state</code> is contained in a from-state, then one of
   * the given result sets has to be contained in the corresponding
   * to-state.
   */
  val fromStateImplications : Map[(Int /* state */, Int /* label */),
                                  Seq[Seq[Set[Int]]]] =
    (for (label <- letters.iterator; state <- states.iterator) yield {
       (state, label) -> {
         (if (xrStates contains state)
            List(minElements(for ((Right, targets) <- outgoing(state, label))
                             yield targets))
          else
            List()) ++
         (if (lxStates contains state)
            List(for (toState <- states.toList;
                      if existsGoingLeft(outgoing(toState, label),
                                         targets => targets contains state))
                 yield Set(toState))
          else
            List())
       }
     }).toMap

  def minElements(sets : Seq[Seq[Int]]) : Seq[Set[Int]] = {
    var imps : List[Set[Int]] = List()
    def addImp(s : Set[Int]) : Unit =
      if (!(imps exists {t => t subsetOf s})) {
        imps = imps filterNot { t => s subsetOf t }
        imps = s :: imps
      }

    for (s <- sets)
      addImp(s.toSet)

    imps
  }

  def possibleToState(state : Int) : Boolean = {
    (
      !(irStates contains state)
    ) && (
      !(lrStates contains state)
    )
  }

  def possibleToState(state      : Int,
                      label      : Int,
                      fromStates : Set[Int]) : Boolean = {
    possibleToState(state) && (
      // ?l states have successors in fromStates
      !(xlStates contains state) ||
        existsGoingLeft(outgoing(state, label),
                        targets => targets forall fromStates)
    ) && (
      // r? states have predecessors in fromStates
      !(rxStates contains state) ||
        (fromStates exists { fromState =>
           existsGoingRight(outgoing(fromState, label),
                            targets => targets contains state)
         })
    )
  }

  def transitionExists(fromStates : Set[Int],
                       label : Int,
                       toStates : Set[Int]) : Boolean = {
    (

      fromStates forall { state =>

        possibleFromState(state, label, toStates) && (

          // l? states have predecessors in toStates
          !(lxStates contains state) ||
            (toStates exists { toState =>
               existsGoingLeft(outgoing(toState, label),
                               targets =>
                                 (targets contains state) &&
                                 (targets forall fromStates))
             })

        )

    }) && (

      toStates forall { state =>

        possibleToState(state, label, fromStates) && (

          // r? states have predecessors in fromStates
          !(rxStates contains state) ||
            (fromStates exists { fromState =>
               existsGoingRight(outgoing(fromState, label),
                                targets =>
                                  (targets contains state) &&
                                  (targets forall toStates))
             })

        )

     }

    )
  }

  val builder = new BricsAutomatonBuilder
  val epsilons = new MHashMap[BricsAutomaton#State, MSet[BricsAutomaton#State]]
                     with MultiMap[BricsAutomaton#State, BricsAutomaton#State]

  builder.setMinimize(true)

  var transitionCnt = 0

  val setStates = new MHashMap[Set[Int], BricsAutomaton#State]
  var statesTodo : List[Set[Int]] = List()

  def getStateFor(s : Set[Int]) : BricsAutomaton#State =
    setStates.getOrElseUpdate(s, {
                                val res = builder.getNewState
                                // Accepting states are the sets of rf states
                                if (s subsetOf rfStates)
                                  builder.setAccept(res, true)
                                statesTodo = s :: statesTodo
                                res
                              })

  // Initial state is {init}
  for (s <- irStates)
    builder.setInitialState(getStateFor(Set(s)))

  def addEPSReachableStates(state : Set[Int],
                            bricsState : BricsAutomaton#State) : Unit = {
    // lr states can be added anytime
    for (lrState <- lrStates.iterator;
         if !(state contains lrState)) {
      epsilons.addBinding(bricsState, getStateFor(state + lrState))
      transitionCnt = transitionCnt + 1
    }

    // rl states can be removed anytime
    for (rlState <- rlStates.iterator;
         if (state contains rlState)) {
      epsilons.addBinding(bricsState, getStateFor(state - rlState))
      transitionCnt = transitionCnt + 1
    }
  }

  def addLabelReachableStates(fromStates : Set[Int],
                              bricsState : BricsAutomaton#State) : Unit = {
    if (fromStates exists { s => !possibleFromState(s) })
      return

    for (label <- letters) {
      val consideredToStates = new MHashSet[Set[Int]]

      def lowerBounds(cur : Set[Int],
                      imps : List[Seq[Set[Int]]]) : Iterator[Set[Int]] =
        imps match {
          case List() =>
            Iterator(cur)
          case Seq() :: _ =>
            Iterator.empty
          case imp :: rest if (imp exists { s => s subsetOf cur }) =>
            lowerBounds(cur, rest)
          case imp :: rest =>
            for (s <- imp.iterator; res <- lowerBounds(cur ++ s, rest))
            yield res
        }

      val upperToBound =
        (for (s <- states.iterator; if (possibleToState(s, label, fromStates)))
         yield s).toSet

      if (!upperToBound.isEmpty) {
        val lowerBoundDisjuncts =
          (for (s <- fromStates; imps <- fromStateImplications((s, label)))
           yield (imps filter { s =>
                    s subsetOf upperToBound })).toList.sortBy(_.size)

        for (lowerToBound <- lowerBounds(Set(), lowerBoundDisjuncts)) {
          assert(lowerToBound subsetOf upperToBound)
          if (!(consideredToStates contains lowerToBound)) {
            val diff = upperToBound -- lowerToBound
            for (s <- Combinatorics.genSubMultisets(diff.toSeq.sorted)) {
              val candidate = lowerToBound ++ s
              if (consideredToStates add candidate) {
                if (transitionExists(fromStates, label, candidate)) {
                  builder.addTransition(bricsState,
                                        (label.toChar, label.toChar),
                                        getStateFor(candidate))
                  transitionCnt = transitionCnt + 1
                }
              }
            }
          }
        }
      }
    }
  }

  while (!statesTodo.isEmpty) {
    ap.util.Timeout.check

    val state :: rem = statesTodo
    statesTodo = rem

    val bricsState = getStateFor(state)

    addEPSReachableStates(state, bricsState)
    addLabelReachableStates(state, bricsState)
  }

  /*println
  println("#states initially:               " + setStates.size)
  println("#transitions initially:          " + transitionCnt)*/

  AutomataUtils.buildEpsilons(builder, epsilons)

  val result = builder.getAutomaton

  /*println
  println("#states after minimization:      " + result.states.size)
  println("#transitions after minimization: " +
            (for (s <- result.states.toList;
                  t <- result.outgoingTransitions(s).toList)
             yield t).size)*/
}
