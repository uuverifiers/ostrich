/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020 Zhilei Han. All rights reserved.
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

package ostrich

import scala.collection.mutable.{HashSet => MHashSet,
                                 LinkedHashSet => MLinkedHashSet,
                                 HashMap => MHashMap,
                                 Stack => MStack,
                                 MultiMap => MMultiMap,
                                 TreeSet => MTreeSet,
                                 Set => MSet}

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}
import Function.unlift

import java.lang.StringBuilder

object PrioStreamingTransducer {
  def apply() : PrioStreamingTransducer =
    getBuilder(0).getTransducer

  def getBuilder(numvars: Int) : PrioStreamingTransducerBuilder =
    new PrioStreamingTransducerBuilder(numvars)

  class TransducerState extends BState {
    override def toString = "q" + hashCode
  }

  def time[R](str : String) (block: => R): R = {
    val t0 = System.nanoTime()
    val result = block    // call-by-name
    val t1 = System.nanoTime()
    println(str + (t1 - t0) + "ns")
    result
  }
}

/**
 * Implementation of prioritised streaming transducers.
 * All transitions have priority.
 * A state is associated with three groups of transitions: pre epsilon, sigma, and post epsilon, with descending priority.
 * 'numvars' is the number of string variables, which are internally labeled by indexes 0 ... (numvars - 1).
 * Note that PSST is intrinsically functional (but not necessarily total), on the condition that there is no epsilon-circle (this property is not checked on transducer level).
 */
class PrioStreamingTransducer(val initialState : PrioStreamingTransducer#State,
  val numvars : Int,
  val lblTrans: Map[PrioStreamingTransducer#State,
                PrioStreamingTransducer#Transition],
  val acceptingStates : Map[PrioStreamingTransducer#State, Seq[UpdateOp]])
extends StreamingTransducer {

  type State = BricsAutomaton#State
  type TLabel = BricsAutomaton#TLabel
  private val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  type Assignment = Seq[Seq[UpdateOp]]
  type SigmaTransition = (TLabel, Assignment, Int, State)
  type ETransition = (Assignment, Int, State)
  type Transition = (Set[ETransition], Set[SigmaTransition], Set[ETransition])

  // utils
  private def label(t : SigmaTransition) = t._1
  private def operation(t : SigmaTransition) = t._2
  private def priority(t : SigmaTransition) = t._3
  private def dest(t : SigmaTransition) : BricsAutomaton#State = t._4

  private def operation(t : ETransition) = t._1
  private def priority(t : ETransition) = t._2
  private def dest(t : ETransition) : BricsAutomaton#State = t._3

  def apply(input: String, internal: String = ""): Option[String] = {
    if (input.size == 0 && isAccept(initialState))
      return Some("")

    // current state, input index to process next, prohibition set, string variable values
    val worklist = new MStack[(State, Int, Set[(State, State)], Seq[String])]

    val emptyVal = (for (i <- 0 until numvars) yield "").toSeq

    worklist.push((initialState, 0, Set.empty[(State, State)], emptyVal))

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

    def getNewVal(oldv: Seq[String], ops: Assignment, offsetHandle: Int => String) : Seq[String] =
      (for (i <- 0 until numvars) yield evalUpdateOps(oldv, ops(i), offsetHandle)).toSeq

    def sortSTransitions(trans: Set[SigmaTransition]) : Seq[SigmaTransition] = {
      trans.toSeq.sortWith((ta, tb) => priority(ta) < priority(tb))
    }

    def sortETransitions(trans: Set[ETransition]) : Seq[ETransition] = {
      trans.toSeq.sortWith((ta, tb) => priority(ta) < priority(tb))
    }

    // find the output by dfs,
    // push configurations to stack by priority,
    // configuration with highest priority is pushed last thus processed first
    while (!worklist.isEmpty) {
      val (s, pos, blocked, values) = worklist.pop
      if (pos >= input.size && isAccept(s))
        return Some(evalUpdateOps(values, acceptingStates.get(s).get, (o) => ""))

      lblTrans.get(s) match {
        case Some((pre, ts, post)) => {

          for (t <- sortETransitions(post)) {
            val pnext = pos
            val snext = dest(t)
            if (!blocked.contains((s, snext))) {
              val tOps = operation(t)
              val valueNext = getNewVal(values, tOps, (o) => "")
              val bnext = blocked ++ Set((s, snext))
              worklist.push((snext, pnext, bnext, valueNext))
            }
          }

          if (pos < input.size) {
            val inc = input(pos)
            for (t <- sortSTransitions(ts)) {
              val pnext = pos + 1
              val snext = dest(t)
              val lbl = label(t)
              if (LabelOps.labelContains(inc, lbl)) {
                val tOps = operation(t)
                val valueNext = getNewVal(values, tOps, (o) => (inc + o).toChar.toString)
                worklist.push((snext, pnext, Set.empty[(State, State)], valueNext))
              }
            }
          }

          for (t <- sortETransitions(pre)) {
            val pnext = pos
            val snext = dest(t)
            if (!blocked.contains((s, snext))) {
              val tOps = operation(t)
              val valueNext = getNewVal(values, tOps, (o) => "")
              val bnext = blocked ++ Set((s, snext))
              worklist.push((snext, pnext, bnext, valueNext))
            }
          }

        }

        case None => // nothing
      }
    }

    return None
  }

  def preImage[A <: AtomicStateAutomaton]
              (aut: A,
               internal: Iterable[(A#State, A#State)]): AtomicStateAutomaton = {

    type Trace = Seq[Set[(aut.State,aut.State)]]
    val preBuilder = aut.getBuilder

    // just a cast:
    val internal2 =
      (for ((s1, s2) <- internal)
        yield ((s1.asInstanceOf[aut.State],
          s2.asInstanceOf[aut.State])))

    // map rudiments to the preimage aut state
    val sMapRev = new MHashMap[(State, Trace, Set[State], Set[(State, State)]), aut.State]

    val defaultTrace = (for (s <- aut.states) yield (s, s)).toSet
    val initTrace = (for (v <- 0 until numvars) yield defaultTrace).toSeq

    val initAutState = aut.initialState

    // this cache is for constant character.
    val constantTraceCache = new MHashMap[Char, Set[(aut.State, aut.State)]]

    def evalUpdateOps(tr: Trace, ops: Seq[UpdateOp], offsetHandle: Int => Set[(aut.State, aut.State)]) : Set[(aut.State, aut.State)] = {
      ops.foldLeft (defaultTrace) {
        (S, op) => {
          val T = op match {
            case Constant(c) => {
              constantTraceCache.getOrElseUpdate(c, {
                (for (s <- aut.states;
                      (target, lbl) <- aut.outgoingTransitions(s);
                    if aut.LabelOps.labelContains(c, lbl))
                      yield (s, target)).toSet
              })
            }
            case RefVariable(v) => tr(v)
            case InternalOp => internal2
            case Offset(o) => offsetHandle(o)
          }
          // SLOW?
          (for ((fst, snd) <- S;
            (fst2, snd2) <- T;
            if snd == fst2) yield (fst, snd2)).toSet
        }
      }
    }

    def getNewTrace(tr: Trace, ops : Assignment, offsetHandle: Int => Set[(aut.State, aut.State)]) : Trace =
      (for (i <- 0 until numvars) yield evalUpdateOps(tr, ops(i), offsetHandle)).toSeq

    def isAcceptingState(ts : State, tr : Trace, s : Set[State]) : Boolean = {
      lazy val traceValid = {
        val ops = (acceptingStates get ts).get
        val trans = evalUpdateOps(tr, ops, (o) => defaultTrace)
        trans exists {
          case (src, tgt) => src == initAutState && (aut isAccept tgt)
        }
      }
      isAccept(ts) && (s forall { a => !isAccept(a)}) && traceValid
    }

    // (ts, tr, s, ps)
    // current state of transducer reached
    // trace
    // prohibition set
    // blocked e-transition
    // state of preimage aut to add new transitions from
    val worklist = new MStack[(State,
                               Trace,
                               Set[State],
                               Set[(State, State)],
                               aut.State)]

    // transducer state, trace, automaton state set
    def getState(ts : State, tr : Trace, as : Set[State], bs : Set[(State, State)]) = {
      sMapRev.getOrElseUpdate((ts, tr, as, bs), {
        val ps = preBuilder.getNewState
        preBuilder.setAccept(ps, isAcceptingState(ts, tr, as))
        worklist.push((ts, tr, as, bs, ps))
        ps
      })
    }

    val newInitState = getState(initialState, initTrace, Set.empty[State], Set.empty[(State, State)])
    preBuilder setInitialState newInitState

    // collect silent transitions during main loop and eliminate them after
    val silentTransitions = new MHashMap[aut.State, MSet[aut.State]]
                            with MMultiMap[aut.State, aut.State]

    val autLabels = (for (s <- aut.states;
                          (_, lbl) <- aut.outgoingTransitions(s))
                     yield lbl).toSet

    val offsetSplitCache = new MHashMap[(TLabel, Int), Iterable[TLabel]]

    def disjointLabels(sigma: (Char, Char), labels: Iterator[(Char, Char)]) : Iterable[(Char, Char)] = {
      var disjoint = new MTreeSet[(Char, Char)]()

      if (!labels.hasNext) {
        disjoint += sigma
        return disjoint
      }

      val (s, e) = sigma

      val mins = new MTreeSet[Int]
      val maxes = new MTreeSet[Int]
      for ((min, max) <- labels) {
        mins += min.toInt
        maxes += max.toInt
      }

      mins += (e + 1) // guard 1
      mins += (e + 2) // guard 2
      maxes += (e + 1)
      maxes += (e + 2)

      val imin = mins.iterator
      val imax = maxes.iterator

      var curMin : Int = s.toInt
      var nextMax : Int = imax.next
      var nextMin : Int = imin.next

      while (curMin <= e.toInt) {
        if (nextMin == curMin) {
          nextMin = imin.next
        } else {
          if (nextMin <= nextMax) {
            disjoint += ((curMin.toChar, (nextMin-1).toChar))
            curMin = nextMin
            nextMin = imin.next
          } else {
            disjoint += ((curMin.toChar, nextMax.toChar))
            curMin = (nextMax + 1)
            nextMax = imax.next
          }
        }
      }

      disjoint
    }

    def splitLabels (tlabel : TLabel, offset: Set[Int], blocked: Set[State], priority: Int, trans: Set[SigmaTransition]) : Iterable[TLabel] = {
      var outgoingLabels : Iterator[TLabel] =
      (for (s <- blocked.iterator;
        (_, transitions, _) <- (lblTrans get s).iterator;
        (l, _, _, _) <- transitions.iterator;
        intLabel <- LabelOps.intersectLabels(l, tlabel).iterator)
      yield intLabel) ++
      (for ((l, _, priority2, _) <- trans;
        if priority2 > priority;
        intLabel <- LabelOps.intersectLabels(l, tlabel).iterator)
      yield intLabel)

      for (o <- offset) {
        outgoingLabels =
          outgoingLabels ++
          offsetSplitCache.getOrElseUpdate((tlabel, o), {
          for (albl <- autLabels;
               shiftLbl = aut.LabelOps.shift(albl, -o).asInstanceOf[TLabel];
               intLabel <- LabelOps.intersectLabels(shiftLbl, tlabel).iterator)
             yield intLabel
        })
      }

      //val enum =
        //new BricsTLabelEnumerator(outgoingLabels)
      //enum.enumDisjointLabels
      disjointLabels(tlabel, outgoingLabels)
    }

    def findOffset(update: Seq[Seq[UpdateOp]]) : Set[Int] = {

      def select(op: UpdateOp) = {
        op match {
          case Offset(o) => (true, o)
          case _ => (false, 0)
        }
      }

      (for
        (ops <- update; op <- ops; (sel, o) = select(op); if sel)
        yield o).toSet
    }

    val offsetTraceCache = new MHashMap[(TLabel, Int), Set[(aut.State, aut.State)]]

    while (!worklist.isEmpty) {
      val (ts, tr, blocked, etrans, ps) = worklist.pop()

      (lblTrans get ts) match {
        case Some((pre, transitions, post)) => {

          // the prefix group of epsilon transitions
          for ((ops, priority, nextState) <- pre; if !etrans.contains((ts, nextState))) {
            val newTrace = getNewTrace(tr, ops, (o) => defaultTrace)
            val newBlocked = blocked ++ epsClosure(
              (for ((_, priority2, s) <- pre.iterator;
                if (priority2 > priority) && !etrans.contains((ts, s)) )
                  yield s), etrans)
            val newEtrans = etrans ++ Set((ts, nextState))

            silentTransitions.addBinding(ps, getState(nextState, newTrace, newBlocked, newEtrans))
          }

          // sigma transitions
          for ((lbl, ops, priority, nextState) <- transitions) {
            val preBlock = blocked ++ epsClosure((for ((_, _, s) <- pre.iterator) yield s), etrans)
            for (nlbl <- splitLabels(lbl, findOffset(ops), preBlock, priority, transitions); if LabelOps.isNonEmptyLabel(nlbl)) {
              val newTrace = getNewTrace(tr, ops, (o) => {
                offsetTraceCache.getOrElseUpdate((nlbl, o), {
                  (for (s <- aut.states;
                        (target, lbl) <- aut.outgoingTransitions(s);
                        shiftLbl = aut.LabelOps.shift(lbl, -o);
                        if aut.LabelOps.labelsOverlap(shiftLbl, nlbl.asInstanceOf[aut.TLabel]))
                        yield (s, target)).toSet
                })
              })
              val newBlocked = postStates(preBlock, nlbl, priority, transitions)
              preBuilder.addTransition(ps,
                                    nlbl.asInstanceOf[aut.TLabel],
                                    getState(nextState, newTrace, newBlocked, Set.empty[(State, State)]))
            }
          }
        }

        // the postfix group of epsilon transitions
        for ((ops, priority, nextState) <- post; if !etrans.contains((ts, nextState))) {
          val newTrace = getNewTrace(tr, ops, (o) => defaultTrace)
          val itr : Iterator[State] =
            (for ((_, _, s) <- pre; if !etrans.contains((ts, s)))
                yield s).iterator ++
            (for ((_, priority2, s) <- post;
              if (priority2 > priority) && !etrans.contains((ts, s)) )
                yield s)

          val newBlocked : Set[State] = blocked ++ epsClosure(itr, etrans) ++ Set(ts)
          val newEtrans = etrans ++ Set((ts, nextState))

          silentTransitions.addBinding(ps, getState(nextState, newTrace, newBlocked, newEtrans))
        }

        case None => // nothing
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
                         trans: Iterable[SigmaTransition]) : Set[State] = {
      val targetStates =
        (for (s <- states.iterator;
              (_, transitions, _) <- (lblTrans get s).iterator;
              (sLabel, _, _, target) <- transitions.iterator;
              if LabelOps.labelsOverlap(label, sLabel))
         yield target) ++
        (for ((l, _, priority2, s) <- trans;
          if (priority2 > priority)
          && LabelOps.labelsOverlap(l, label))
          yield s)
      (epsClosure(targetStates, Set.empty[(State, State)]))
    }

  private def epsClosure(states : Iterator[State], Lambda : Set[(State, State)]) : Set[State] = {
    val res = new MHashSet[State]
    val todo = new MStack[State]

    for (s <- states)
      if (res add s)
        todo push s

    while (!todo.isEmpty) {
      val s = todo.pop
      for ((pre, _, post) <- (lblTrans get s).iterator) {
        for ((_, _, t) <- pre; if !Lambda.contains((s, t)))
          if (res add t)
            todo push t
        for ((_, _, t) <- post; if !Lambda.contains((s, t)))
          if (res add t)
            todo push t
      }
    }

    res.toSet
  }

  override def toDot() : String = {
    val sb = new StringBuilder()
    sb.append("digraph PSST" + numvars + " {\n")

    sb.append(initialState + "[shape=square];\n")
    for ((f, op) <- acceptingStates)
        sb.append(f + "[peripheries=2];\n")

    for (trans <- lblTrans) {
      val (state, (pre, sigma, post)) = trans
      for (arrow <- sigma) {
        val (lbl, op, prio, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"" + lbl + "/" + prio + "/" + op + "\"];\n")
      }
      for (arrow <- pre) {
        val (op, prio, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"epsilon /" + prio + "\"];\n")
      }
      for (arrow <- post) {
        val (op, prio, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"epsilon /" + prio + "\"];\n")
      }
    }

    sb.append("}\n")

    return sb.toString()
  }
}

class PrioStreamingTransducerBuilder(val numvars : Int)
    extends StreamingTransducerBuilder[PrioStreamingTransducer#State,
                              PrioStreamingTransducer#TLabel] {

  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  private val states = new MLinkedHashSet[State]

  var initialState : State = getNewState
  val acceptingStates
    = new MHashMap[State, Seq[UpdateOp]]

  val sTrans = new MHashMap[State, MSet[PrioStreamingTransducer#SigmaTransition]]
              with MMultiMap[State, PrioStreamingTransducer#SigmaTransition] {
      override def default(q : State) : MSet[PrioStreamingTransducer#SigmaTransition] =
        MLinkedHashSet.empty[PrioStreamingTransducer#SigmaTransition]
    }

  val preTrans = new MHashMap[State, MSet[PrioStreamingTransducer#ETransition]]
              with MMultiMap[State, PrioStreamingTransducer#ETransition] {
      override def default(q : State) : MSet[PrioStreamingTransducer#ETransition] =
        MLinkedHashSet.empty[PrioStreamingTransducer#ETransition]
    }

  val postTrans = new MHashMap[State, MSet[PrioStreamingTransducer#ETransition]]
              with MMultiMap[State, PrioStreamingTransducer#ETransition] {
      override def default(q : State) : MSet[PrioStreamingTransducer#ETransition] =
        MLinkedHashSet.empty[PrioStreamingTransducer#ETransition]
    }

  def getNewState : State = {
    val s = new PrioStreamingTransducer.TransducerState
    states += s
    s
  }

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
      sTrans.addBinding(s1, (lbl, ops, priority, s2))

  def addPreETransition(s1 : State,
                     ops : Seq[Seq[UpdateOp]],
                     s2 : State) =
    addPreETransition(s1, ops, 0, s2)

  def addPreETransition(s1 : State,
                     ops : Seq[Seq[UpdateOp]],
                     priority : Int,
                     s2 : State) =
    preTrans.addBinding(s1, (ops, priority, s2))

  def addPostETransition(s1 : State,
                     ops : Seq[Seq[UpdateOp]],
                     s2 : State) =
    addPostETransition(s1, ops, 0, s2)

  def addPostETransition(s1 : State,
                     ops : Seq[Seq[UpdateOp]],
                     priority : Int,
                     s2 : State) =
    postTrans.addBinding(s1, (ops, priority, s2))

  def getTransducer = {
    // TODO: restrict to live reachable states
    def transform(s : State) : (Set[PrioStreamingTransducer#ETransition], Set[PrioStreamingTransducer#SigmaTransition], Set[PrioStreamingTransducer#ETransition]) = {
      val pre = (preTrans get s) match {
        case None => Set.empty[PrioStreamingTransducer#ETransition]
        case Some(ps) => ps.toSet
      }
      val post = (postTrans get s) match {
        case None => Set.empty[PrioStreamingTransducer#ETransition]
        case Some(ps) => ps.toSet
      }
      val sigma = (sTrans get s) match {
        case None => Set.empty[PrioStreamingTransducer#SigmaTransition]
        case Some(ss) => ss.toSet
      }
      (pre, sigma, post)
    }

    val lblTrans = (for (s <- states) yield (s, transform(s))).toMap
    new PrioStreamingTransducer(initialState,
                            numvars,
                            lblTrans,
                            acceptingStates.toMap)
  }

}
