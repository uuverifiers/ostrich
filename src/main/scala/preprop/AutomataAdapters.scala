/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2018  Matthew Hague, Philipp Ruemmer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package strsolver.preprop

import scala.collection.mutable.{HashMap => MHashMap}

case class InitFinalAutomaton[A <: AtomicStateAutomaton]
                             (underlying : A,
                              val _initialState : A#State,
                              val _acceptingStates : Set[A#State])
     extends AtomicStateAutomaton {
  type State = underlying.State
  type TransitionLabel = underlying.TransitionLabel

  val vocabularyWidth : Int = underlying.vocabularyWidth
  val minChar = underlying.minChar
  val maxChar = underlying.maxChar
  val internalChar = underlying.internalChar

  def |(that : Automaton) : Automaton =
    this.internalise | that
  def &(that : Automaton) : Automaton =
    this.internalise & that

  def isEmpty : Boolean =
    !AutomataUtils.areConsistentAtomicAutomata(List(this))

  def apply(word : Seq[Int]) : Boolean =
    throw new UnsupportedOperationException

  def getAcceptedWord : Option[Seq[Int]] =
    throw new UnsupportedOperationException

  val initialState = _initialState.asInstanceOf[State]
  val acceptingStates = _acceptingStates.asInstanceOf[Set[State]]

  def getStates = underlying.getStates

  def outgoingTransitions(from : State) : Iterator[(State, TransitionLabel)] =
    underlying.outgoingTransitions(from)

  def isNonEmptyLabel(label : TransitionLabel) : Boolean =
    underlying.isNonEmptyLabel(label)

  val sigmaLabel = underlying.sigmaLabel

  def intersectLabels(l1 : TransitionLabel,
                      l2 : TransitionLabel) : Option[TransitionLabel] =
    underlying.intersectLabels(l1, l2)

  def labelsOverlap(l1 : TransitionLabel,
                    l2 : TransitionLabel) : Boolean =
    underlying.labelsOverlap(l1, l2)

  def labelContains(a : Char, l : TransitionLabel) : Boolean =
    underlying.labelContains(a, l)

  def enumLetters(label : TransitionLabel) : Iterator[Int] =
    underlying.enumLetters(label)

  def enumDisjointLabels : Iterable[TransitionLabel] =
    underlying.enumDisjointLabels

  def enumLabelOverlap(lbl : TransitionLabel) : Iterable[TransitionLabel] =
    underlying.enumLabelOverlap(lbl)

  def getImage(states : Set[State], lbl : TransitionLabel) : Set[State] =
    underlying.getImage(states, lbl)

  def getImage(state : State, lbl : TransitionLabel) : Set[State] =
    underlying.getImage(state, lbl)

  def replaceTransitions(a : Char,
                         states : Iterator[(State, State)]) : AtomicStateAutomaton = {
    val newUnderlying = underlying.replaceTransitions(a, states)
    InitFinalAutomaton(
      newUnderlying,
      initialState.asInstanceOf[newUnderlying.State],
      acceptingStates.asInstanceOf[Set[AtomicStateAutomaton#State]])
  }

  def foreachTransition(f : (State, TransitionLabel, State) => Any) =
    underlying.foreachTransition(f)

  def foreachTransition(q1 : State, f : (TransitionLabel, State) => Any) =
    underlying.foreachTransition(q1, f)

  def setInitAccept(s0 : State, sf : State) : AtomicStateAutomaton =
    InitFinalAutomaton(underlying, s0,
                       Set(sf).asInstanceOf[Set[AtomicStateAutomaton#State]])

  def productWithMap(auts : Seq[AtomicStateAutomaton]) :
    (AtomicStateAutomaton, Map[State, (State, Seq[State])]) =
    throw new UnsupportedOperationException

  def isAccept(s : State) : Boolean =
    acceptingStates contains s

  def getBuilder : AtomicStateAutomatonBuilder =
    throw new UnsupportedOperationException

  def internalise : AtomicStateAutomaton = {
    val builder = underlying.getBuilder
    val smap = new MHashMap[underlying.State, underlying.State]
    
    for (s <- getStates)
      smap.put(s, builder.getNewState)

    for (s <- getStates) {
      val t = smap(s)
      for ((to, label) <- outgoingTransitions(s))
        builder.addTransition(t, label, smap(to))
      builder.setAccept(t, isAccept(s))
    }

    builder.setInitialState(smap(initialState))

    builder.getAutomaton
  }

}