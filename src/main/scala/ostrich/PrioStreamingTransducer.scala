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

object PrioStreamingTransducer {
  def apply() : PrioStreamingTransducer =
    getBuilder.getTransducer

  def getBuilder : PrioStreamingTransducerBuilder =
    new PrioStreamingTransducerBuilder

  class TransducerState extends BState {
    override def toString = "q" + hashCode
  }
}

// operators which update the values of string variables in PSST
abstract class UpdateOp

// Append a constant character
case class Constant(val c: Char) extends UpdateOp

// Refer to the current value of a string variable
case class RefVariable(val v: Int) extends UpdateOp

/**
 * Implementation of prioritised streaming transducers
 * all transitions have priority, and no epsilon-transition is allowed
 * 'vars' is the number of string variables, which are labeled by indexes 0 .. vars - 1
 * Note that PSST is intrinsically functional
 */
class PrioStreamingTransducer(val initialState : PrioStreamingTransducer#State,
                          val vars : Int,
                          val lblTrans: Map[PrioStreamingTransducer#State,
                                        Set[PrioStreamingTransducer#Transition]],
                          val acceptingStates : Map[PrioStreamingTransducer#State, Seq[UpdateOp]])
    extends Transducer {

  type State = BricsAutomaton#State
  type TLabel = BricsAutomaton#TLabel

  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  // input transitions
  type Transition = (TLabel, Seq[Seq[UpdateOp]], Int, State)

  private def label(t : Transition) = t._1
  private def operation(t : Transition) = t._2
  private def priority(t : Transition) = t._3
  private def dest(t : Transition) : BricsAutomaton#State = t._4

  // NOTE: internal character is not implemented yet. It is not used by unary replaceAll
  def apply(input: String, internal: String = ""): Option[String] = {
    if (input.size == 0 && isAccept(initialState))
      return Some("")

    // current state, currently processed input index, string variable values
    val worklist = new MStack[(State, Int, Seq[String])]
    val seenlist = new MHashSet[(State, Int)]

    val emptyVal = (for (i <- 0 until vars) yield "").toSeq

    worklist.push((initialState, 0, emptyVal))

    def evalUpdateOps(oldv: Seq[String], ops: Seq[UpdateOp]) : String = {
      ops.foldLeft ("") {
        (res, op) => op match {
          case Constant(c) => res + c.toString
          case RefVariable(n) => res + oldv(n)
        }
      }
    }

    def getNewVal(oldv: Seq[String], ops: Seq[Seq[UpdateOp]]) : Seq[String] = 
      (for (i <- 0 until vars) yield evalUpdateOps(oldv, ops(i))).toSeq

    def sortTransitions(trans: Set[Transition]) : Seq[Transition] = {
      trans.toSeq.sortWith((ta, tb) => priority(ta) < priority(tb))
    }

    // find the output by dfs,
    // push configurations to stack by priority, 
    // configuration with highest priority is pushed last thus processed first
    while (!worklist.isEmpty) {
      val (s, pos, values) = worklist.pop

      if (pos < input.size) {
        val a = input(pos)
        for (ts <- lblTrans.get(s); t <- sortTransitions(ts)) {
          val pnext = pos + 1
          val snext = dest(t)
          val lbl = label(t)
          if (LabelOps.labelContains(a, lbl) && !seenlist.contains((snext, pnext))) {
            val tOps = operation(t)
            val valueNext = getNewVal(values, tOps)
            if (pnext >= input.length && isAccept(snext))
              return Some(evalUpdateOps(valueNext, acceptingStates.get(snext).get))
            worklist.push((snext, pnext, valueNext))
          }
        }
      }
    }

    return None
  }

  // TODO
  def postImage[A <: ostrich.AtomicStateAutomaton]
               (aut: A,
                internalApprox: Option[A]): ostrich.AtomicStateAutomaton = ???

  def preImage[A <: AtomicStateAutomaton]
              (aut: A,
               internal: Iterable[(A#State, A#State)]): AtomicStateAutomaton = {

    type trace = Seq[Set[(aut.State,aut.State)]]
    val preBuilder = aut.getBuilder

    val sMapRev = new MHashMap[(State, trace, Set[State]), aut.State]

    val defaultSet = (for (s <- aut.states) yield (s, s)).toSet
    val emptyTrace = (for (v <- 0 until vars) yield defaultSet).toSeq

    val initAutState = aut.initialState

    def evalUpdateOps(tr: trace, ops: Seq[UpdateOp]) : Set[(aut.State, aut.State)] = {
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
          }
          (for ((fst, snd) <- S;
            (fst2, snd2) <- T;
            if snd == fst2) yield (fst, snd2)).toSet
        }      
      }
    }
    def getNewTrace(tr: trace, ops : Seq[Seq[UpdateOp]]) : trace =
      (for (i <- 0 until vars) yield evalUpdateOps(tr, ops(i))).toSeq

    def isAcceptingState(ts : State, tr : trace, s : Set[State]) = {
      lazy val traceValid = {
        val ops = (acceptingStates get ts).get
        val trans = evalUpdateOps(tr, ops)
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

    while (!worklist.isEmpty) {
      val (ts, tr, blocked, ps) = worklist.pop()

      (lblTrans get ts) match {
        case Some(transitions) => {
          for ((lbl, ops, priority, nextState) <- transitions) {
            lazy val newTrace = getNewTrace(tr, ops)
            for ((intLabel, newBlocked) <- postStates(blocked, lbl, priority, transitions)) {
              val (min, max) = intLabel
              val tlbl = aut.LabelOps.interval(min, max)
              preBuilder.addTransition(ps,
                                    tlbl,
                                    getState(nextState, newTrace, newBlocked))
            }
          }
        }

        case None => 
          // do nothing
      }
    }

    preBuilder.getAutomaton
  }

  def isAccept(s : State) = acceptingStates contains s

  // compute the post image of old blocked states,
  // and add new blocked states which are of higher priority
  // split labels if necessary
  private def postStates(states : Iterable[State],
                         label : TLabel, priority: Int, 
                         trans: Set[Transition]) : Iterator[(TLabel, Set[State])] = {
    val outgoingLabels =
      Iterator(label) ++
      (for (s <- states.iterator;
            transitions <- (lblTrans get s).iterator;
            (l, _, _, _) <- transitions.iterator;
            intLabel <- LabelOps.intersectLabels(l, label).iterator)
      yield intLabel) ++ 
      (for ((l, _, priority2, _) <- trans; 
            if priority2 > priority;
            intLabel <- LabelOps.intersectLabels(l, label).iterator)
      yield intLabel)
    val enum =
      new BricsTLabelEnumerator(outgoingLabels)

    for (l <- enum.enumDisjointLabels.iterator) yield {
      val targetStates =
        (for (s <- states.iterator;
              transitions <- (lblTrans get s).iterator;
              (sLabel, _, _, target) <- transitions.iterator;
              if LabelOps.labelsOverlap(l, sLabel))
         yield target).toSet
      val prioblock =
        (for ((label, _, priority2, s) <- trans; 
          if (priority2 > priority) 
          && LabelOps.labelsOverlap(label, l))
          yield s).toSet
      (l, targetStates ++ prioblock)
    }
  }
}

class PrioStreamingTransducerBuilder
    extends TransducerBuilder[PrioStreamingTransducer#State,
                              PrioStreamingTransducer#TLabel] {
  val LabelOps : TLabelOps[PrioStreamingTransducer#TLabel] = BricsTLabelOps

  var numvars = 0
  var initialState : PrioStreamingTransducer#State = getNewState
  val acceptingStates
    = new MHashMap[PrioStreamingTransducer#State, Seq[UpdateOp]]

  val lblTrans
    = new MHashMap[PrioStreamingTransducer#State, MSet[PrioStreamingTransducer#Transition]]
      with MMultiMap[PrioStreamingTransducer#State, PrioStreamingTransducer#Transition] {
      override def default(q : PrioStreamingTransducer#State) : MSet[PrioStreamingTransducer#Transition] =
        MLinkedHashSet.empty[PrioStreamingTransducer#Transition]
    }

  def getNewState : PrioStreamingTransducer#State = new PrioStreamingTransducer.TransducerState

  def setInitialState(s : PrioStreamingTransducer#State) = {
    initialState = s
  }

  def setVarNum(v : Int) = {
    numvars = v
  }

  def isAccept(s : PrioStreamingTransducer#State) = acceptingStates.contains(s)

  def setAccept(s : PrioStreamingTransducer#State, isAccept : Boolean) =
    setAccept(s, isAccept, Seq.empty[UpdateOp])

  def setAccept(s : PrioStreamingTransducer#State, isAccept : Boolean, ops: Seq[UpdateOp]) =
    if (isAccept)
      acceptingStates.+=((s, ops))
    else
      acceptingStates -= s

  // dummy, DO NOT USE!
  def addTransition(s1 : PrioStreamingTransducer#State,
                    lbl : PrioStreamingTransducer#TLabel,
                    op : OutputOp,
                    s2 : PrioStreamingTransducer#State) : Unit = ()

  def addTransition(s1 : PrioStreamingTransducer#State,
                    lbl : PrioStreamingTransducer#TLabel,
                    ops : Seq[Seq[UpdateOp]],
                    priority : Int,
                    s2 : PrioStreamingTransducer#State) =
    if (LabelOps.isNonEmptyLabel(lbl))
      lblTrans.addBinding(s1, (lbl, ops, priority, s2))

  def getTransducer = {
    // TODO: restrict to live reachable states
    new PrioStreamingTransducer(initialState,
                            numvars,
                            lblTrans.toMap.mapValues(_.toSet),
                            acceptingStates.toMap)
  }

  // dummy, DO NOT USE!
  def addETransition(s1 : PrioStreamingTransducer#State,
                    op : OutputOp,
                    s2 : PrioStreamingTransducer#State) : Unit = () 

}
