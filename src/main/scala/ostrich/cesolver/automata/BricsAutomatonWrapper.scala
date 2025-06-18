/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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

package ostrich.cesolver.automata

import dk.brics.automaton.{
  BasicAutomata,
  RegExp,
  Automaton => BAutomaton
}

import scala.collection.JavaConverters.asScala
import ostrich.cesolver.util.ParikhUtil

object BricsAutomatonWrapper {

  type State = BricsAutomatonWrapper#State
  type TLabel = BricsAutomatonWrapper#TLabel

  def apply(): BricsAutomatonWrapper =
    BricsAutomatonWrapper(new BAutomaton)

  def apply(underlying: BAutomaton): BricsAutomatonWrapper = 
    new BricsAutomatonWrapper(underlying)

  def apply(pattern: String): BricsAutomatonWrapper = {
    ParikhUtil.log("BricsAutomatonWrapper.apply: build automaton from regex pattern " + pattern)
    BricsAutomatonWrapper(new RegExp(pattern).toAutomaton(false))
  }

  def fromString(str: String): BricsAutomatonWrapper = {
    ParikhUtil.log("BricsAutomatonWrapper.fromString: build automaton from string " + str)
    BricsAutomatonWrapper(BasicAutomata makeString str)
  }

  def makeAnyString(): BricsAutomatonWrapper =
    BricsAutomatonWrapper(BAutomaton.makeAnyString)
  
  def makeEmpty(): BricsAutomatonWrapper =
    BricsAutomatonWrapper(BAutomaton.makeEmpty)

  def makeEmptyString(): BricsAutomatonWrapper = 
    BricsAutomatonWrapper(BAutomaton.makeEmptyString())
}

/** Wrapper for the dk.brics.automaton. Extend dk.brics.automaton with
  * registers and update for each transition.
  */
class BricsAutomatonWrapper(val underlying: BAutomaton)
    extends CostEnrichedAutomatonBase {

  private val old2new = asScala(underlying.getStates()).map(s => (s, newState())).toMap

  // initialize
  initialState = old2new(underlying.getInitialState())
  for (s <- asScala(underlying.getStates())){
    for (t <- asScala(s.getTransitions()))
      addTransition(old2new(s), (t.getMin(), t.getMax()), old2new(t.getDest()), Seq())
  }
  for (s <- asScala(underlying.getAcceptStates()))

  setAccept(old2new(s),true)
}
