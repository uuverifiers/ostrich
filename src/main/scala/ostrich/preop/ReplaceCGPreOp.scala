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

package ostrich.preop

import ostrich.automata.{Regex2PFA, StreamingTransducer,
                         PrioStreamingTransducer, PFA, TLabelOps,
                         AnchoredLabels}
import StreamingTransducer._
import AnchoredLabels._

import scala.collection.mutable.{HashSet => MHashSet,
                                 LinkedHashSet => MLinkedHashSet,
                                 HashMap => MHashMap,
                                 Stack => MStack,
                                 MultiMap => MMultiMap,
                                 Set => MSet}

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}

object ReplaceCGPreOp {

  import Regex2PFA.completeInfo

  def apply(pat : completeInfo, rep : Seq[UpdateOp]) : PreOp = 
    StreamingTransducerPreOp(buildPSST(pat, rep))

  def buildPSST(pat : completeInfo, rep : Seq[UpdateOp]) : PrioStreamingTransducer = {
    val (aut, numCap, state2Caps, cap2Init) = pat

    // for each capture group, we have a string variable.
    // Besides, we have a special variable 'res' for the result, indexed by 'numCap'
    val builder = PrioStreamingTransducer.getBuilder(numCap + 1)

    type tranState = PrioStreamingTransducer#State
    type autState = PFA.State
    type TLabel = PFA.TLabel
    val LabelOps : TLabelOps[TLabel] = AnchoredLabelOps

    // some common update operations
    def nochange(index : Int) : Seq[UpdateOp] = List(RefVariable(index))
    def append_after(index: Int) : Seq[UpdateOp] = List(RefVariable(index), Offset(0))
    def clear : Seq[UpdateOp] = List()
    def single : Seq[UpdateOp] = List(Offset(0))
    val output = List(RefVariable(numCap))

    def updateWithIndex (f: Int => Seq[UpdateOp]) : Seq[Seq[UpdateOp]] = {
      0.to(numCap).map(f)
    }
    def default : Seq[Seq[UpdateOp]] = updateWithIndex(o => nochange(o))
    def only(index: Int, op: Seq[UpdateOp]) : Seq[Seq[UpdateOp]] = 
      updateWithIndex(o => {
        if (o == index) {
          op
        } else {
          nochange(o)
        }
      })

    val sMap = new MHashMap[tranState, autState]
    val sMapRev = new MHashMap[autState, tranState]

    // states of new transducer to be constructed
    val worklist = new MStack[tranState]

    def mapState(s : tranState, q : autState) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    // creates and adds to worklist any new states if needed
    def getState(as : autState) : tranState = {
      sMapRev.getOrElse(as, {
        val s = builder.getNewState
        mapState(s, as)
        builder.setAccept(s, false, output)
        worklist.push(s)
        s
      })
    }

    val q0 = builder.initialState // q0'
    val qf = builder.getNewState // qf'
    builder.setAccept(q0, true, output)
    builder.setAccept(qf, true, output)
    builder.addTransition(q0, LabelOps.sigmaLabel, only(numCap, append_after(numCap)), q0)
    builder.addTransition(qf, LabelOps.sigmaLabel, only(numCap, append_after(numCap)), qf)

    val tranInit = getState(aut.initial)
    builder.addPreETransition(q0, default, tranInit)

    val opCache = new MHashMap[(autState, autState), Seq[Seq[UpdateOp]]]

    def getOps(current : autState, next: autState) = {
      val caps_activated = state2Caps.getOrElse(next, Set())
      val caps_activated_old = state2Caps.getOrElse(current, Set())

      val ops : Seq[Seq[UpdateOp]] = updateWithIndex {
        index => {
          val is_activated = caps_activated contains index
          val is_activated_old = caps_activated_old contains index
          if (is_activated && is_activated_old) {
            // now check inital states:
            val caps_initials = cap2Init.getOrElse(index, Set())
            val is_initial = caps_initials contains current
            if (is_initial) {
              clear
            } else {
              append_after(index)
            }
          } else {
            // `index` is not relevant here
            nochange(index)
          }
        }
      }
      ops
    }

    // dfs
    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val as = sMap(ts)

      var priority = Int.MaxValue
      for (trans <- aut.preTran.get(as).iterator; next <- trans) {
        builder.addPreETransition(ts, getOps(as, next), priority, getState(next))
        priority -= 1
      }

      priority = Int.MaxValue
      for (trans <- aut.postTran.get(as).iterator; next <- trans) {
        builder.addPostETransition(ts, getOps(as, next), priority, getState(next))
        priority -= 1
      }

      priority = Int.MaxValue
      for (trans <- aut.sTran.get(as).iterator; (lbl, next) <- trans) {
        builder.addTransition(ts, lbl, getOps(as, next), priority, getState(next))
        priority -= 1
      }
    }

    val (f1, f2) = aut.accepting
    for (s <- f1) {
      val tranEnd = getState(s)
      builder.addPreETransition(tranEnd, updateWithIndex(o => {
        if (o == numCap) {
          List(RefVariable(numCap)) ++ rep
        } else {
          clear
        }
      }), qf)
    }
    for (s <- f2) {
      val tranEnd = getState(s)
      builder.addPreETransition(tranEnd, updateWithIndex(o => {
        if (o == numCap) {
          List(RefVariable(numCap)) ++ rep
        } else {
          clear
        }
      }), qf)
    }
    val tran = builder.getTransducer
    tran
  }
}
