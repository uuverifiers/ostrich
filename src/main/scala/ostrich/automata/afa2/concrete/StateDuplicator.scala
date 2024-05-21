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

object AFA2StateDuplicator {

  def apply(afa : AFA2) : AFA2 =
    new AFA2StateDuplicator(afa).result

}

/**
 * Class to duplicate states in such a way that they can be
 * categorised into ir, ll, lr, rl, rr, rf.
 */
class AFA2StateDuplicator(afa : AFA2) {

  import ostrich.automata.afa2.{Step, Left, Right}
  import afa.{finalStates, initialStates, transitions}

  def ir(s : Int) = 6*s + 0
  def ll(s : Int) = 6*s + 1
  def lr(s : Int) = 6*s + 2
  def rl(s : Int) = 6*s + 3
  def rr(s : Int) = 6*s + 4
  def rf(s : Int) = 6*s + 5

  val newInitial =
    for (s <- initialStates) yield ir(s)

  val newFinal =
    (for (s <- finalStates) yield rf(s)) ++
    (for (s <- initialStates; if finalStates contains s) yield ir(s))

  val flatNewTransitions =
    (for ((source, ts)                     <- transitions.iterator;
          trans@StepTransition(_, step, _) <- ts.iterator;
          newSource                        <- rewrSources(source, step);
          newTrans                         <- rewrTransition(trans))
     yield (newSource, newTrans)).toList

  val newTransitions =
    flatNewTransitions groupBy (_._1) mapValues { l => l map (_._2) }

  def rewrSources(s : Int, step : Step) : Iterator[Int] =
    step match {
      case Left  =>
        Iterator(ll(s), rl(s))
      case Right =>
        Iterator(lr(s), rr(s)) ++
        (if (initialStates contains s) Iterator(ir(s)) else Iterator())
    }

  def rewrTransition(t : StepTransition) : Iterator[StepTransition] = {
    val StepTransition(label, step, targets) = t
    val domains =
      for (s <- targets) yield {
        step match {
          case Left  =>
            List(ll(s), lr(s))
          case Right =>
            List(rl(s), rr(s)) ++
            (if (finalStates contains s) List(rf(s)) else List())
        }
      }
    for (comb <- Combinatorics.cartesianProduct(domains.toList))
    yield StepTransition(label, step, comb)
  }

  val result =
    new AFA2(newInitial, newFinal, newTransitions.toMap).restrictToReachableStates

}
