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

import scala.collection.mutable.{
  HashMap => MHashMap,
  ArrayStack,
  HashSet => MHashSet,
  LinkedHashSet => MLinkedHashSet
}

import ostrich.cesolver.util.TermGenerator
import ostrich.cesolver.util.ParikhUtil

abstract class CostEnrichedAutomatonAdapter[A <: CostEnrichedAutomatonBase](
    val underlying: A
) extends CostEnrichedAutomatonBase {

  val termGen = TermGenerator()

  // initialize registers
  this.registers = Seq.fill(underlying.registers.size)(termGen.registerTerm)

  def computeReachableStates(
      initState: State,
      accStates: Set[State]
  ): Iterable[State] = {
    val fwdReachable, bwdReachable = new MLinkedHashSet[State]
    fwdReachable += initState

    val worklist = new ArrayStack[State]
    worklist push initState

    while (!worklist.isEmpty)
      for ((s, _, _) <- underlying.outgoingTransitionsWithVec(worklist.pop))
        if (fwdReachable add s)
          worklist push s

    val backMapping = new MHashMap[State, MHashSet[State]]

    for (s <- fwdReachable)
      for ((t, _, _) <- underlying.outgoingTransitionsWithVec(s))
        backMapping.getOrElseUpdate(t, new MHashSet) += s

    for (_s <- accStates; s = _s.asInstanceOf[State])
      if (fwdReachable contains s) {
        bwdReachable += s
        worklist push s
      }

    while (!worklist.isEmpty)
      for (list <- backMapping get worklist.pop; s <- list)
        if (bwdReachable add s)
          worklist push s

    if (bwdReachable.isEmpty)
      bwdReachable add initState

    bwdReachable
  }

  lazy val internalise: CostEnrichedAutomaton = {
    val smap = new MHashMap[underlying.State, underlying.State]
    val ceAut = new CostEnrichedAutomaton

    for (s <- states)
      smap.put(s, ceAut.newState())

    for (from <- states) {
      for ((to, label, update) <- outgoingTransitionsWithVec(from))
        ceAut.addTransition(smap(from), label, smap(to), update)
      ceAut.setAccept(smap(from), isAccept(from))
    }

    ceAut.registers = _registers
    ceAut.regsRelation = _regsRelation
    ceAut.initialState = smap(initialState)
    ceAut
  }

}

object CostEnrichedInitFinalAutomaton {
  def apply[A <: CostEnrichedAutomatonBase](
      aut: A,
      initialState: A#State,
      acceptingStates: Set[A#State]
  ): CostEnrichedAutomatonBase = {
    ParikhUtil.log(
      "CostEnrichedInitFinalAutomaton.apply ... aut: " + aut.hashCode() +
      ", initialState: " + initialState + ", acceptingStates: " + acceptingStates
    )
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, _, _) =>
        _CostEnrichedInitFinalAutomaton(a, initialState, acceptingStates)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, initialState, acceptingStates)
    }
  }

  def setInitial[A <: CostEnrichedAutomatonBase](
      aut: A,
      initialState: A#State
  ): _CostEnrichedInitFinalAutomaton[_ >: A <: CostEnrichedAutomatonBase] = {
    ParikhUtil.log(
      "CostEnrichedInitFinalAutomaton.setInitial ... aut: " + aut.hashCode() +
      ", initialState: " + initialState
    )
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, _, oldFinal) =>
        _CostEnrichedInitFinalAutomaton(a, initialState, oldFinal)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, initialState, aut.acceptingStates)
    }
  }

  def setFinal[A <: CostEnrichedAutomatonBase](
      aut: A,
      acceptingStates: Set[CostEnrichedAutomatonBase#State]
  ): _CostEnrichedInitFinalAutomaton[_ >: A <: CostEnrichedAutomatonBase] = {
    ParikhUtil.log(
      "CostEnrichedInitFinalAutomaton.setFinal ... aut: " + aut.hashCode() +
      ", acceptingStates: " + acceptingStates
    )
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, oldInit, _) =>
        _CostEnrichedInitFinalAutomaton(a, oldInit, acceptingStates)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, aut.initialState, acceptingStates)
    }
  }
}

case class _CostEnrichedInitFinalAutomaton[A <: CostEnrichedAutomatonBase](
    override val underlying: A,
    val startState: A#State,
    val _acceptingStates: Set[A#State]
) extends CostEnrichedAutomatonAdapter[A](underlying) {

  initialState = startState

  override lazy val states =
    computeReachableStates(_initialState, _acceptingStates)


  override lazy val acceptingStates: Set[State] =
    _acceptingStates & states.toSet

  override def isAccept(s: State): Boolean = acceptingStates.contains(s)

  override def outgoingTransitionsWithVec(q: State) = {
    for (
      p @ (s, _, _) <- underlying.outgoingTransitionsWithVec(q);
      if states.toSet.contains(s)
    )
      yield p
  }

  override def incomingTransitionsWithVec(
      t: State
  ) = {
    for (
      p @ (s, _, _) <- underlying.incomingTransitionsWithVec(t);
      if states.toSet.contains(s)
    )
      yield p
  }
}
