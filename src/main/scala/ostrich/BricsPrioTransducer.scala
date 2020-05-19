/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2020  Matthew Hague, Philipp Ruemmer
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

package ostrich

import scala.collection.mutable.{HashSet => MHashSet,
                                 LinkedHashSet => MLinkedHashSet,
                                 HashMap => MHashMap,
                                 Stack => MStack,
                                 MultiMap => MMultiMap,
                                 Set => MSet}

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}

object BricsPrioTransducer {
  def apply() : BricsPrioTransducer =
    getBuilder.getTransducer

  def getBuilder : BricsPrioTransducerBuilder =
    new BricsPrioTransducerBuilder

  class TransducerState extends BState {
    override def toString = "q" + hashCode
  }
}

/**
 * Implementation of prioritised transducers as automata with input and output
 * states.  That is, from an input state, all transitions read a
 * character from input.  From an output state, all transitions produce
 * a character of output, and the transitions have priorities.
 * The class mostly resembles BricsTransducer.
 */
class BricsPrioTransducer(val initialState : BricsAutomaton#State,
                          val lblTrans: Map[BricsAutomaton#State,
                                        Set[BricsPrioTransducer#TTransition]],
                          val eTrans: Map[BricsAutomaton#State,
                                        Set[BricsPrioTransducer#TETransition]],
                          val acceptingStates : Set[BricsAutomaton#State])
    extends Transducer {

  type State = BricsAutomaton#State
  type TLabel = BricsAutomaton#TLabel

  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  // input transitions
  type TTransition = (BricsAutomaton#TLabel, OutputOp, State)

  // e/output-transitions with priorities
  type TETransition = (OutputOp, Int, State)

  def apply(input: String, internal: String): Option[String] =
    bricsTransducer(input, internal)

  def postImage[A <: ostrich.AtomicStateAutomaton]
               (aut: A,
                internalApprox: Option[A]): ostrich.AtomicStateAutomaton =
    bricsTransducer.postImage(aut, internalApprox)

  def preImage[A <: ostrich.AtomicStateAutomaton]
              (aut: A,
               internal: Iterable[(A#State, A#State)]): ostrich.AtomicStateAutomaton =
    bricsTransducer.preImage(aut, internal)

  def isAccept(s : State) = acceptingStates.contains(s)

  // The equivalent standard transducer derived using subset construction
  lazy val bricsTransducer : BricsTransducer = {
    val builder = BricsTransducer.getBuilder

    val encStates  = new MHashMap[(State, Set[State]), State]
    val statesTodo = new MStack[(State, Set[State], State)]

    def getState(transState : State, pnfaStates : Set[State]) : State =
      encStates.getOrElseUpdate((transState, pnfaStates), {
        val newState = builder.getNewState
        builder.setAccept(newState,
                          isAccept(transState) &&
                          (pnfaStates forall { s => !isAccept(s) }))
        statesTodo push ((transState, pnfaStates, newState))
        newState
      })

    builder setInitialState getState(initialState, Set())

    while (!statesTodo.isEmpty) {
      val t@(oriState, blockedStates, newState) = statesTodo.pop

      //println("considering: " + t)

      (lblTrans get oriState) match {
        case Some(transitions) => {      // input transitions
          assert(!(eTrans contains oriState))
          //println("lbl: " + transitions)

          for ((label, op, nextState) <- transitions) {
            for ((intLabel, newBlocked) <- postStates(blockedStates, label))
              builder.addTransition(newState,
                                    intLabel, op,
                                    getState(nextState, newBlocked))
          }
        }

        case None =>
          (eTrans get oriState) match {
            case Some(transitions) => {  // output transitions
              //println("eps: " + transitions)

              for ((op, priority, nextState) <- transitions) {
                val blocked =
                  (for ((_, priority2, s) <- transitions.iterator;
                        if priority2 > priority)
                   yield s).toSet
                val newBlocked =
                  blockedStates ++ epsClosure(blocked)
                builder.addETransition(newState,
                                       op,
                                       getState(nextState, newBlocked))
              }
            }
            case None =>
              // nothing to do
          }
      }
    }

    builder.getTransducer
  }

  private def postStates(states : Iterable[State],
                         label : TLabel) : Iterator[(TLabel, Set[State])] = {
    val outgoingLabels =
      Iterator(label) ++
      (for (s <- states.iterator;
            transitions <- (lblTrans get s).iterator;
            (l, _, _) <- transitions.iterator;
            intLabel <- LabelOps.intersectLabels(l, label).iterator)
       yield intLabel)
    val enum =
      new BricsTLabelEnumerator(outgoingLabels)

    for (l <- enum.enumDisjointLabels.iterator) yield {
      val targetStates =
        (for (s <- states.iterator;
              transitions <- (lblTrans get s).iterator;
              (sLabel, _, target) <- transitions.iterator;
              if LabelOps.labelsOverlap(l, sLabel))
         yield target).toSet
      (l, epsClosure(targetStates))
    }
  }

  private def epsClosure(states : Iterable[State]) : Set[State] = {
    val res = new MHashSet[State]
    val todo = new MStack[State]

    for (s <- states)
      if (res add s)
        todo push s

    while (!todo.isEmpty) {
      val s = todo.pop
      for (transitions <- eTrans get s)
        for ((_, _, t) <- transitions)
          if (res add t)
            todo push t
    }

    res.toSet
  }

}



class BricsPrioTransducerBuilder
    extends TransducerBuilder[BricsAutomaton#State,
                              BricsAutomaton#TLabel] {
  val LabelOps : TLabelOps[BricsAutomaton#TLabel] = BricsTLabelOps

  var initialState : BricsAutomaton#State = getNewState
  val acceptingStates : MSet[BricsAutomaton#State]
    = new MLinkedHashSet[BricsAutomaton#State]

  val lblTrans
    = new MHashMap[BricsAutomaton#State, MSet[BricsPrioTransducer#TTransition]]
      with MMultiMap[BricsAutomaton#State, BricsPrioTransducer#TTransition] {
      override def default(q : BricsAutomaton#State) : MSet[BricsPrioTransducer#TTransition] =
        MLinkedHashSet.empty[BricsPrioTransducer#TTransition]
    }
  val eTrans
    = new MHashMap[BricsAutomaton#State, MSet[BricsPrioTransducer#TETransition]]
      with MMultiMap[BricsAutomaton#State, BricsPrioTransducer#TETransition] {
      override def default(q : BricsAutomaton#State) : MSet[BricsPrioTransducer#TETransition] =
        MLinkedHashSet.empty[BricsPrioTransducer#TETransition]
    }

  def getNewState : BricsAutomaton#State = new BricsPrioTransducer.TransducerState

  def setInitialState(s : BricsAutomaton#State) = {
    initialState = s
  }

  def isAccept(s : BricsAutomaton#State) = acceptingStates.contains(s)

  def setAccept(s : BricsAutomaton#State, isAccept : Boolean) =
    if (isAccept)
      acceptingStates += s
    else
      acceptingStates -= s

  def addTransition(s1 : BricsAutomaton#State,
                    lbl : BricsAutomaton#TLabel,
                    op : OutputOp,
                    s2 : BricsAutomaton#State) =
    if (LabelOps.isNonEmptyLabel(lbl))
      lblTrans.addBinding(s1, (lbl, op, s2))

  def addETransition(s1 : BricsAutomaton#State,
                     op : OutputOp,
                     s2 : BricsAutomaton#State) =
    addETransition(s1, op, 0, s2)

  /**
   * Add a e-transition to the transducer
   */
  def addETransition(s1 : BricsAutomaton#State,
                     op : OutputOp,
                     prio : Int,
                     s2 : BricsAutomaton#State) : Unit =
    eTrans.addBinding(s1, (op, prio, s2))

  def getTransducer = {
//    minimize()
    // TODO: restrict to live reachable states
    new BricsPrioTransducer(initialState,
                            lblTrans.toMap.mapValues(_.toSet),
                            eTrans.toMap.mapValues(_.toSet),
                            acceptingStates.toSet)
  }

}
