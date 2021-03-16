/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2021 Zhilei Han. All rights reserved.
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
  type TLabel = AnchoredLabel
  private val LabelOps = AnchoredLabelOps

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

  def apply(input: String, internal: String = ""): Option[String] = { // concrete evaluation
    /*
     * auxiliary functions
     */
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

    lazy val emptyVal = (for (i <- 0 until numvars) yield "").toSeq

    def sortSTransitions(trans: Set[SigmaTransition]) : Seq[SigmaTransition] = {
      trans.toSeq.sortWith((ta, tb) => priority(ta) < priority(tb))
    }

    def sortETransitions(trans: Set[ETransition]) : Seq[ETransition] = {
      trans.toSeq.sortWith((ta, tb) => priority(ta) < priority(tb))
    }

    // we choose the first (most prioritized) run which:
    // 1. consumes all input string
    // 2. halt in an accepting state
    // and output a string based on its accepting condition

    // maintain a stack with following elements:
    // current state,
    // input index to process next,
    // prohibition set of epsilon transitions,
    // string variable values,
    val worklist = new MStack[(State, Int, Set[(State, State)], Seq[String])]

    worklist.push((initialState, 0, Set.empty[(State, State)], emptyVal))

    // find the output by dfs,
    // push configurations to stack by priority,
    // configuration with highest priority is pushed last thus processed first
    while (!worklist.isEmpty) {
      val (s, pos, blocked, values) = worklist.pop

      if (pos >= input.size && isAccept(s))
        return Some(evalUpdateOps(values, acceptingStates.get(s).get, (o) => ""))

      lblTrans.get(s) match {
        case Some((pre, ts, post)) => {

          // process the post epsilon transitions first,
          // in a reverse order
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

          // then comes sigma transitions
          for (t <- sortSTransitions(ts)) {
            val snext = dest(t)
            val l = label(t)
            l match {
              case NormalLabel(lbl) => { // a normal sigma transition
                if (pos < input.size) {
                  val inc = input(pos)
                  val pnext = pos + 1
                  if (BricsTLabelOps.labelContains(inc, lbl)) {
                    val tOps = operation(t)
                    val valueNext = getNewVal(values, tOps, (o) => (inc + o).toChar.toString)
                    worklist.push((snext, pnext, Set.empty[(State, State)], valueNext))
                  }
                }
              }
              case BeginAnchor => {
                // the begin anchor ^ is matched against the beginning
                // of the input string. And we assume that the input string
                // has only one such 'anchor' position.
                // So, ^ can only be matched once at the beginning, indicated by
                // the boolean 'beginMatched'.

                // Note that it is possible to take several epsilon transitions
                // before ^ is matched.
                // this is crucial for regex like 'a|^b'

                val pnext = pos
                if (pos == 0) {
                  val tOps = operation(t)
                  // ^ is not a real char, exclude it in capture groups
                  val valueNext = getNewVal(values, tOps, (o) => "")
                  // we assume ^ and $ resets the blocked set:
                  worklist.push((snext, pnext, Set.empty[(State, State)], valueNext))
                }
              }
              case EndAnchor => {
                // the end anchor $ is matched against the end
                // of the input string. And we assume that the input string
                // has only one such 'anchor' position.
                // So, $ can only be matched once at the end.
                val pnext = pos
                // note that if pos == input.size and current state is accepting
                // dfs will end before reaching here(see loop head)
                // so this only makes sense if the current state is not accepting

                // Also, after the match of $, it is still possible to take
                // several (only) epsilon transitions before halting.
                // like when regex is 'b | c$'
                if (pos == input.size) {
                  val tOps = operation(t)
                  // $ is not a real char, exclude it in capture groups
                  val valueNext = getNewVal(values, tOps, (o) => "")
                  worklist.push((snext, pnext, Set.empty[(State, State)], valueNext))
                }
              }
            }
          }

          // pre epsilon transitions processed last
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

  type ProhibitionSet = Set[(State, Boolean, Boolean)]
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
    val sMapRev = new MHashMap[(State, Trace, ProhibitionSet, Set[(State, State)], Boolean, Boolean), aut.State]

    val defaultTrace = (for (s <- aut.states) yield (s, s)).toSet
    val initTrace = (for (v <- 0 until numvars) yield defaultTrace).toSeq

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
          // this slow relation composition operation might be the bottleneck
          (for ((fst, snd) <- S;
            (fst2, snd2) <- T;
            if snd == fst2) yield (fst, snd2)).toSet
        }
      }
    }

    def getNewTrace(tr: Trace, ops : Assignment, offsetHandle: Int => Set[(aut.State, aut.State)]) : Trace =
      (for (i <- 0 until numvars) yield evalUpdateOps(tr, ops(i), offsetHandle)).toSeq

    val initAutState = aut.initialState

    def isAcceptingPreState(ts : State, tr : Trace, s : ProhibitionSet) : Boolean = {
      lazy val traceValid = {
        val ops = (acceptingStates get ts).get
        val trans = evalUpdateOps(tr, ops, (o) => defaultTrace)
        trans exists {
          case (src, tgt) => src == initAutState && (aut isAccept tgt)
        }
      }
      isAccept(ts) && (s forall { case (a, _, _) => !isAccept(a)}) && traceValid
    }

    // (ts, tr, s, bs, b1, b2, ps)
    // current state of transducer reached
    // trace
    // prohibition set
    // blocked e-transition
    // ^ allowed? => sigma trans. happened
    // $ occurred? => no sigma trans. allowed
    // state of preimage aut to add new transitions from
    val worklist = new MStack[(State,
                               Trace,
                               ProhibitionSet,
                               Set[(State, State)],
                               Boolean,
                               Boolean,
                               aut.State)]

    // transducer state, trace, automaton state set
    def getState(ts : State, tr : Trace, as : ProhibitionSet, bs : Set[(State, State)],
      beginAllowed : Boolean, endOccurred : Boolean) = {
      sMapRev.getOrElseUpdate((ts, tr, as, bs, beginAllowed, endOccurred), {
        val ps = preBuilder.getNewState
        // bs, beginAllowed and endOccurred only restricts the run,
        // they are irrelevant to the acceptance of a run.
        preBuilder.setAccept(ps, isAcceptingPreState(ts, tr, as))
        worklist.push((ts, tr, as, bs, beginAllowed, endOccurred, ps))
        ps
      })
    }

    val newInitState = getState(initialState, initTrace,
      Set.empty[(State, Boolean, Boolean)],
      Set.empty[(State, State)],
      true, false)
    preBuilder setInitialState newInitState

    // collect silent transitions during main loop and eliminate them after
    val silentTransitions = new MHashMap[aut.State, MSet[aut.State]]
                            with MMultiMap[aut.State, aut.State]

    val autLabels = (for (s <- aut.states;
                          (_, lbl) <- aut.outgoingTransitions(s))
                     yield lbl).toSet

    val offsetSplitCache = new MHashMap[((Char, Char), Int), Iterable[(Char, Char)]]

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

    def splitLabels (tlabel : (Char, Char), offset: Set[Int], blocked: ProhibitionSet, priority: Int, trans: Set[SigmaTransition]) : Iterable[(Char, Char)] = {
      var outgoingLabels :
        Iterator[(Char, Char)] =
      (for ((s, _, _) <- blocked.iterator;
        (_, transitions, _) <- (lblTrans get s).iterator;
        (l, _, _, _) <- transitions.iterator;
        lbl <- LabelOps.weaken(l).iterator;
        intLabel <- BricsTLabelOps.intersectLabels(lbl, tlabel).iterator)
      yield intLabel) ++
      (for ((l, _, priority2, _) <- trans;
        if priority2 > priority;
        lbl <- LabelOps.weaken(l).iterator;
        intLabel <- BricsTLabelOps.intersectLabels(lbl, tlabel).iterator)
      yield intLabel)

      for (o <- offset) {
        outgoingLabels =
          outgoingLabels ++
          offsetSplitCache.getOrElseUpdate((tlabel, o), {
          for (albl <- autLabels;
               shiftLbl = aut.LabelOps.shift(albl, -o).asInstanceOf[(Char, Char)];
               intLabel <- BricsTLabelOps.intersectLabels(shiftLbl, tlabel).iterator)
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

    val offsetTraceCache = new MHashMap[((Char, Char), Int), Set[(aut.State, aut.State)]]

    /*
     * the main loop
     * constructing preimage aut. in a dfs.
     */
    while (!worklist.isEmpty) {
      ap.util.Timeout.check

      val (ts, tr, blocked, etrans, beginAllowed, endOccurred, ps) = worklist.pop()

      (lblTrans get ts) match {
        case None => // nothing
        case Some((pre, transitions, post)) => {

          // the prefix group of epsilon transitions
          for ((ops, priority, nextState) <- pre; if !etrans.contains((ts, nextState))) {
            val newTrace = getNewTrace(tr, ops, (o) => defaultTrace)
            val newBlocked = blocked ++ epsClosure(
              (for ((_, priority2, s) <- pre.iterator;
                if (priority2 > priority) && !etrans.contains((ts, s)) )
                  yield (s, beginAllowed, endOccurred)), etrans)
            val newEtrans = etrans ++ Set((ts, nextState))

            // epsilon transitions does not alter anchor usability status.
            silentTransitions.addBinding(ps, getState(nextState, newTrace, newBlocked, newEtrans, beginAllowed, endOccurred))
          }

          // if the end anchor $ is already matched, it signifies the end of the run!
          // thus only when endAllowed is true, sigma transitions are allowed.
          //if (endAllowed) {

            // sigma transitions
            for ((l, ops, priority, nextState) <- transitions) {
              l match {
                case NormalLabel(lbl) => {
                  if (!endOccurred) {
                    val preBlock = blocked ++ epsClosure(
                      (for ((_, _, s) <- pre.iterator)
                        yield (s, beginAllowed, endOccurred)), etrans)

                    for (nlbl <- splitLabels(lbl, findOffset(ops), preBlock, priority, transitions); if BricsTLabelOps.isNonEmptyLabel(nlbl)) {
                      // nlbl : (Char, Char)
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
                                            getState(nextState, newTrace, newBlocked, Set.empty[(State, State)], false, endOccurred)) // sigma transition always disable the start anchor ^

                    }
                  }
                }
                case BeginAnchor => {
                  if (beginAllowed) {
                    // if ^ is still possible, then proceed
                    // note that ^ is never a char in 'aut', so its trace is empty. But
                    // since ^ is not a real char, it should be regarded as "" when computing trace
                    val newTrace = getNewTrace(tr, ops, (o) => defaultTrace)
                    // should ^ and $ be considered as epsilon transitions when
                    // computing the blocked set???
                    val itr = (for ((_, _, s) <- pre.iterator)
                      yield (s, true, endOccurred)) ++
                    (for ((lbl, _, priority2, s) <- transitions; if lbl == BeginAnchor && priority2 > priority)
                      yield (s, true, endOccurred))

                    val preBlock = blocked ++ epsClosure(itr, etrans)
                    silentTransitions.addBinding(ps, getState(nextState, newTrace, preBlock, Set.empty[(State, State)], true, endOccurred))
                  }
                }
                case EndAnchor => {
                  // likewise for $
                  val newTrace = getNewTrace(tr, ops, (o) => defaultTrace)
                  val itr = (for ((_, _, s) <- pre.iterator)
                    yield (s, beginAllowed, endOccurred)) ++
                  (for ((lbl, _, priority2, s) <- transitions; if lbl == EndAnchor && priority2 > priority)
                    yield (s, beginAllowed, true))

                  val preBlock = blocked ++ epsClosure(itr, etrans)
                  silentTransitions.addBinding(ps, getState(nextState, newTrace, preBlock, Set.empty[(State, State)], beginAllowed, true)) // $ disables sigma
                }
              }
            }
         

          // the postfix group of epsilon transitions
          for ((ops, priority, nextState) <- post; if !etrans.contains((ts, nextState))) {
            val newTrace = getNewTrace(tr, ops, (o) => defaultTrace)
            val itr : Iterator[(State, Boolean, Boolean)] =
              (for ((_, _, s) <- pre; if !etrans.contains((ts, s)))
                  yield (s, beginAllowed, endOccurred)).iterator ++
              (for ((_, priority2, s) <- post;
                if (priority2 > priority) && !etrans.contains((ts, s)) )
                  yield (s, beginAllowed, endOccurred))

            val newBlocked : ProhibitionSet = blocked ++ epsClosure(itr, etrans) ++ Set((ts, beginAllowed, endOccurred))
            val newEtrans = etrans ++ Set((ts, nextState))

            silentTransitions.addBinding(ps, getState(nextState, newTrace, newBlocked, newEtrans, beginAllowed, endOccurred))
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
  // this function only applies to sigma transition!
  private def postStates(states : Iterable[(State, Boolean, Boolean)],
                         label : (Char, Char),
                         priority: Int,
                         trans: Iterable[SigmaTransition]) : ProhibitionSet = {
      val targetStates =
        // 'advance' the old blocked states with 'label'
        // only consider trace where $ has not occurred
        (for ((s, _, endOccurred) <- states.iterator; if !endOccurred;
              (_, transitions, _) <- (lblTrans get s).iterator;
              (sLabel, _, _, target) <- transitions.iterator;
              l <- LabelOps.weaken(sLabel).iterator;
              if BricsTLabelOps.labelsOverlap(label, l))
                // ^ is always disabled by a sigma transition
                // as for $, it is guaranteed to be enabled, otherwise
                // current transition is impossible
         yield (target, false, false)) ++
        // add new blocked states
        (for ((l, _, priority2, s) <- trans;
          lbl <- LabelOps.weaken(l).iterator;
          if (priority2 > priority)
          && BricsTLabelOps.labelsOverlap(lbl, label))
          yield (s, false, false)) //likewise
      (epsClosure(targetStates, Set.empty[(State, State)]))
    }

  private def epsClosure(states : Iterator[(State, Boolean, Boolean)], Lambda : Set[(State, State)]) : ProhibitionSet = {
    val res = new MHashSet[(State, Boolean, Boolean)]
    val todo = new MStack[(State, Boolean, Boolean)]

    for (s <- states)
      if (res add s)
        todo push s

    while (!todo.isEmpty) {
      val (s, beginAllowed, endOccurred) = todo.pop
      for ((pre, transitions, post) <- (lblTrans get s).iterator) {
        for ((_, _, t) <- pre; if !Lambda.contains((s, t))) {
          val ts = (t, beginAllowed, endOccurred)
          if (res add ts)
            todo push ts
        }
        for ((_, _, t) <- post; if !Lambda.contains((s, t))) {
          val ts = (t, beginAllowed, endOccurred)
          if (res add ts)
            todo push ts
        }
        for ((lbl, _, _, s) <- transitions) {
          lbl match {
            case BeginAnchor => {
              if (beginAllowed) {
                val ts = (s, true, endOccurred)
                if (res add ts)
                  todo push ts
              }
            }
            case EndAnchor => {
              val ts = (s, beginAllowed, true)
              if (res add ts)
                todo push ts
            }
            case _ =>
          }
        }
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

  val LabelOps = AnchoredLabelOps

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
