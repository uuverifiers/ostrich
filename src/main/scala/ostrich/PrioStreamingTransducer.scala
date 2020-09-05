/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2020  Zhilei Han
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
import Function.unlift

object PrioStreamingTransducer {
  def apply() : PrioStreamingTransducer =
    getBuilder(0).getTransducer

  def getBuilder(numvars: Int) : PrioStreamingTransducerBuilder =
    new PrioStreamingTransducerBuilder(numvars)

  class TransducerState extends BState {
    override def toString = "q" + hashCode
  }
}

/**
 * Implementation of prioritised streaming transducers
 * all transitions have priority. And states with both input transitions and epsilon transitions
 * are not allowed.
 * 'numvars' is the number of string variables, which are labeled by indexes 0 .. numvars - 1
 * Note that PSST is intrinsically functional, on the condition that there is no epsilon-circle
 */
class PrioStreamingTransducer(val initialState : PrioStreamingTransducer#State,
                          val numvars : Int,
                          val lblTrans: Map[PrioStreamingTransducer#State,
                                        Set[PrioStreamingTransducer#Transition]],
                          val eTrans: Map[PrioStreamingTransducer#State,
                                      Set[PrioStreamingTransducer#ETransition]],
                          val acceptingStates : Map[PrioStreamingTransducer#State, Seq[UpdateOp]])
    extends StreamingTransducer {

  type State = BricsAutomaton#State
  type TLabel = BricsAutomaton#TLabel

  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  // input transitions
  type Transition = (TLabel, Seq[Seq[UpdateOp]], Int, State)
  type ETransition = (Seq[Seq[UpdateOp]], Int, State)

  private def label(t : Transition) = t._1
  private def operation(t : Transition) = t._2
  private def priority(t : Transition) = t._3
  private def dest(t : Transition) : BricsAutomaton#State = t._4

  private def operation(t : ETransition) = t._1
  private def priority(t : ETransition) = t._2
  private def dest(t : ETransition) : BricsAutomaton#State = t._3

  def apply(input: String, internal: String = ""): Option[String] = {
    if (input.size == 0 && isAccept(initialState))
      return Some("")

    // current state, currently processed input index, string variable values
    val worklist = new MStack[(State, Int, Seq[String])]
    val seenlist = new MHashSet[(State, Int)]

    val emptyVal = (for (i <- 0 until numvars) yield "").toSeq

    worklist.push((initialState, 0, emptyVal))

    def evalUpdateOps(oldv: Seq[String], ops: Seq[UpdateOp], offsetHandle: Int => String) : String = {
      ops.foldLeft ("") {
        (res, op) => op match {
          case Constant(c) => res + c.toString
          case RefVariable(n) => res + oldv(n)
          case InternalOp => res + internal
          case Offset(o) => res + offsetHandle(o)
        }
      }
    }

    def getNewVal(oldv: Seq[String], ops: Seq[Seq[UpdateOp]], offsetHandle: Int => String) : Seq[String] = 
      (for (i <- 0 until numvars) yield evalUpdateOps(oldv, ops(i), offsetHandle)).toSeq

    def sortTransitions(trans: Set[Transition]) : Seq[Transition] = {
      trans.toSeq.sortWith((ta, tb) => priority(ta) < priority(tb))
    }

    def sortETransitions(trans: Set[ETransition]) : Seq[ETransition] = {
      trans.toSeq.sortWith((ta, tb) => priority(ta) < priority(tb))
    }

    // find the output by dfs,
    // push configurations to stack by priority, 
    // configuration with highest priority is pushed last thus processed first
    while (!worklist.isEmpty) {
      val (s, pos, values) = worklist.pop

      if (pos < input.size) {
        val inc = input(pos)
        for (ts <- lblTrans.get(s); t <- sortTransitions(ts)) {
          val pnext = pos + 1
          val snext = dest(t)
          val lbl = label(t)
          if (LabelOps.labelContains(inc, lbl) && !seenlist.contains((snext, pnext))) {
            val tOps = operation(t)
            val valueNext = getNewVal(values, tOps, (o) => (inc + o).toChar.toString)
            if (pnext >= input.length && isAccept(snext))
              return Some(evalUpdateOps(valueNext, acceptingStates.get(snext).get, (o) => ""))
            worklist.push((snext, pnext, valueNext))
          }
        }
      }

      for (ts <- eTrans.get(s); t <- sortETransitions(ts)) {
        val pnext = pos
        val snext = dest(t)
        if (!seenlist.contains((snext, pnext))) {
          val tOps = operation(t)
          val valueNext = getNewVal(values, tOps, (o) => "")
          if (pnext >= input.length && isAccept(snext))
            return Some(evalUpdateOps(valueNext, acceptingStates.get(snext).get, (o) => ""))
          worklist.push((snext, pnext, valueNext))
        }
      }
    }

    return None
  }

  def preImage[A <: BricsAutomaton]
              (aut: A,
               internal: Iterable[(A#State, A#State)]): AtomicStateAutomaton = {

    type trace = Seq[Set[(aut.State,aut.State)]]
    val preBuilder = aut.getBuilder

    // just a cast:
    val internal2 =
      (for ((s1, s2) <- internal)
        yield ((s1.asInstanceOf[aut.State],
          s2.asInstanceOf[aut.State])))

    val sMapRev = new MHashMap[(State, trace, Set[State]), aut.State]

    val defaultSet = (for (s <- aut.states) yield (s, s)).toSet
    val emptyTrace = (for (v <- 0 until numvars) yield defaultSet).toSeq

    val initAutState = aut.initialState

    def evalUpdateOps(tr: trace, ops: Seq[UpdateOp], offsetHandle: Int => Set[(aut.State, aut.State)]) : Set[(aut.State, aut.State)] = {
      ops.foldLeft (defaultSet) { 
        (S, op) => {
          val T = op match { 
            case Constant(c) => {
              (for (s <- aut.states;
                    (target, lbl) <- aut.outgoingTransitions(s);
                   if aut.LabelOps.labelContains(c, lbl))
                     yield (s, target)).toSet
            }
            case RefVariable(v) => tr(v)
            case InternalOp => internal2
            case Offset(o) => offsetHandle(o)
          }
          (for ((fst, snd) <- S;
            (fst2, snd2) <- T;
            if snd == fst2) yield (fst, snd2)).toSet
        }
      }
    }

    def getNewTrace(tr: trace, ops : Seq[Seq[UpdateOp]], offsetHandle: Int => Set[(aut.State, aut.State)]) : trace =
      (for (i <- 0 until numvars) yield evalUpdateOps(tr, ops(i), offsetHandle)).toSeq

    def isAcceptingState(ts : State, tr : trace, s : Set[State]) : Boolean = {
      lazy val traceValid = {
        val ops = (acceptingStates get ts).get
        val trans = evalUpdateOps(tr, ops, (o) => defaultSet)
        trans exists {case (src, tgt) => src == initAutState && (aut isAccept tgt)}
      }
      isAccept(ts) && (s forall { a => !isAccept(a)}) && traceValid
    }

    // (ts, tr, s, ps)
    // current state of transducer reached
    // trace
    // prohibition set
    // state of preimage aut to add new transitions from
    val worklist = new MStack[(State,
                               trace,
                               Set[State],
                               aut.State)]

    // transducer state, trace, automaton state set
    def getState(ts : State, tr : trace, as : Set[State]) = {
      sMapRev.getOrElseUpdate((ts, tr, as), {
        val ps = preBuilder.getNewState
        preBuilder.setAccept(ps, isAcceptingState(ts, tr, as))
        worklist.push((ts, tr, as, ps))
        ps
      })
    }

    val newInitState = getState(initialState, emptyTrace, Set())
    preBuilder setInitialState newInitState

    // collect silent transitions during main loop and eliminate them
    // after (TODO: think of more efficient solution)
    val silentTransitions = new MHashMap[aut.State, MSet[aut.State]]
                            with MMultiMap[aut.State, aut.State]

    val autLabels = (for (s <- aut.states;
                          (_, lbl) <- aut.outgoingTransitions(s))
                     yield (lbl)).toSet

    def splitLabels (tlabel : TLabel, offset: Set[Int], blocked: Set[State], priority: Int, trans: Set[Transition]) : Iterable[TLabel] = {
      val outgoingLabels =
        Iterator(tlabel) ++
      (for (s <- blocked.iterator;
        transitions <- (lblTrans get s).iterator;
        (l, _, _, _) <- transitions.iterator;
        intLabel <- LabelOps.intersectLabels(l, tlabel).iterator)
      yield intLabel) ++ 
      (for ((l, _, priority2, _) <- trans; 
        if priority2 > priority;
        intLabel <- LabelOps.intersectLabels(l, tlabel).iterator)
      yield intLabel) ++
      (for (o <- offset;
        albl <- autLabels;
        shiftLbl = aut.LabelOps.shift(albl, -o);
        intLabel <- LabelOps.intersectLabels(shiftLbl, tlabel).iterator)
      yield intLabel)

      val enum =
        new BricsTLabelEnumerator(outgoingLabels)
      enum.enumDisjointLabels
    }

    def findOffset(update: Seq[Seq[UpdateOp]]) : Set[Int] = {
      update.flatten.toSet.collect(unlift {
        (o : UpdateOp) => o match {
           case Offset(o) => Some(o)
           case _ => None
        }
      })
    }

    while (!worklist.isEmpty) {
      val (ts, tr, blocked, ps) = worklist.pop()

      (lblTrans get ts) match {
        case Some(transitions) => {

          if (eTrans contains ts)
            throw new Exception(
              "Cannot have both normal transitions and epsilon transitions " +
              "from state " + ts)

          for ((lbl, ops, priority, nextState) <- transitions) {
            for (nlbl <- splitLabels(lbl, findOffset(ops), blocked, priority, transitions)) {
              val newTrace = getNewTrace(tr, ops, (o) => {
                (for (s <- aut.states;
                      (target, lbl) <- aut.outgoingTransitions(s);
                      shiftLbl = aut.LabelOps.shift(lbl, -o);
                      if aut.LabelOps.labelsOverlap(shiftLbl, nlbl))
                      yield (s, target)).toSet
              })
              val newBlocked = postStates(blocked, nlbl, priority, transitions)
              preBuilder.addTransition(ps,
                                    nlbl,
                                    getState(nextState, newTrace, newBlocked))
            }
          }
        }

        case None => {
          (eTrans get ts) match {
            case Some(etransitions) => {
              for ((ops, priority, nextState) <- etransitions) {
                val newTrace = getNewTrace(tr, ops, (o) => defaultSet)
                val newBlocked = blocked ++ epsClosure(
                  (for ((_, priority2, s) <- etransitions.iterator;
                    if priority2 > priority)
                      yield s))

                silentTransitions.addBinding(ps, getState(nextState, newTrace, newBlocked))
              }
            }
            case None => // nothing
          }
        }
      }
    }

    AutomataUtils.buildEpsilons(preBuilder, silentTransitions)

    preBuilder.getAutomaton
  }

  def isAccept(s : State) = acceptingStates contains s

  // compute the post image of old blocked states,
  // and add new blocked states which are of higher priority
  private def postStates(states : Iterable[State],
                         label : TLabel, 
                         priority: Int, 
                         trans: Iterable[Transition]) : Set[State] = {
      val targetStates =
        (for (s <- states.iterator;
              transitions <- (lblTrans get s).iterator;
              (sLabel, _, _, target) <- transitions.iterator;
              if LabelOps.labelsOverlap(label, sLabel))
         yield target) ++ 
        (for ((l, _, priority2, s) <- trans; 
          if (priority2 > priority) 
          && LabelOps.labelsOverlap(l, label))
          yield s)
      (epsClosure(targetStates))
    }

  private def epsClosure(states : Iterator[State]) : Set[State] = {
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

class PrioStreamingTransducerBuilder(val numvars : Int)
    extends StreamingTransducerBuilder[PrioStreamingTransducer#State,
                              PrioStreamingTransducer#TLabel] {

  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  var initialState : State = getNewState
  val acceptingStates
    = new MHashMap[State, Seq[UpdateOp]]

  val lblTrans
    = new MHashMap[State, MSet[PrioStreamingTransducer#Transition]]
      with MMultiMap[State, PrioStreamingTransducer#Transition] {
      override def default(q : State) : MSet[PrioStreamingTransducer#Transition] =
        MLinkedHashSet.empty[PrioStreamingTransducer#Transition]
    }
  val eTrans
    = new MHashMap[State, MSet[PrioStreamingTransducer#ETransition]]
      with MMultiMap[State, PrioStreamingTransducer#ETransition] {
      override def default(q : State) : MSet[PrioStreamingTransducer#ETransition] =
        MLinkedHashSet.empty[PrioStreamingTransducer#ETransition]
    }

  def getNewState : State = new PrioStreamingTransducer.TransducerState

  def setInitialState(s : State) = {
    initialState = s
  }

  def isAccept(s : State) = acceptingStates.contains(s)

  def setAccept(s : State, isAccept : Boolean, ops: Seq[UpdateOp]) =
    if (isAccept)
      acceptingStates.+=((s, ops))
    else
      acceptingStates -= s

  def addTransition(s1 : State,
                    lbl : TLabel,
                    ops : Seq[Seq[UpdateOp]],
                    s2 : State) =
      addTransition(s1, lbl, ops, 0, s2)

  def addTransition(s1 : State,
                    lbl : TLabel,
                    ops : Seq[Seq[UpdateOp]],
                    priority : Int,
                    s2 : State) =
    if (LabelOps.isNonEmptyLabel(lbl))
      lblTrans.addBinding(s1, (lbl, ops, priority, s2))

  def addETransition(s1 : State,
                     ops : Seq[Seq[UpdateOp]],
                     s2 : State) =
    addETransition(s1, ops, 0, s2)

  def addETransition(s1 : State,
                     ops : Seq[Seq[UpdateOp]],
                     priority : Int,
                     s2 : State) =
    eTrans.addBinding(s1, (ops, priority, s2))

  def getTransducer = {
    // TODO: restrict to live reachable states
    new PrioStreamingTransducer(initialState,
                            numvars,
                            lblTrans.toMap.mapValues(_.toSet),
                            eTrans.toMap.mapValues(_.toSet),
                            acceptingStates.toMap)
  }

}
