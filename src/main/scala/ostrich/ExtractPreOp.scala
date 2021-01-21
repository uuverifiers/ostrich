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
                                 Set => MSet}

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}

object ExtractPreOp {

  import PFA.completeInfo

  def apply(index : Int, pat : completeInfo) : PreOp = 
    StreamingTransducerPreOp(buildPSST(index, pat))

  def buildPSST(index: Int, pat : completeInfo) : PrioStreamingTransducer = {
    val (aut, numCap, numStar, state2Caps, states2Stars, star2Caps) = pat

    // we just need one capture group
    val builder = PrioStreamingTransducer.getBuilder(1)

    type tranState = PrioStreamingTransducer#State
    type autState = PFA.State
    type TLabel = PFA.TLabel
    val LabelOps : TLabelOps[TLabel] = AnchoredLabelOps

    // some common update operations
    def nochange : Seq[Seq[UpdateOp]] = List(List(RefVariable(0)))
    def append_after : Seq[Seq[UpdateOp]] = List(List(RefVariable(0), Offset(0)))
    def clear : Seq[Seq[UpdateOp]] = List(List())
    def single : Seq[Seq[UpdateOp]] = List(List(Offset(0)))

    val output = List(RefVariable(0))

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

    val tranInit = builder.initialState
    builder.setInitialState(tranInit)

    val autInit = getState(aut.initial)
    builder.addPreETransition(tranInit, List(List(Constant('\u0000'))), autInit) // initialize to null

    val opCache = new MHashMap[(autState, autState), Seq[Seq[UpdateOp]]]

    def getOps(current : autState, next: autState) = {
      opCache.getOrElseUpdate((current, next), {
        val caps_activated_old = state2Caps.getOrElse(current, Set())
        val is_activated_old = caps_activated_old contains index

        val caps_activated = state2Caps.getOrElse(next, Set())
        val is_activated = caps_activated contains index

        if (is_activated && !is_activated_old) {
          single
        } else {
          val stars_reset : Set[Int] = states2Stars.getOrElse((current, next), Set.empty[Int])
          val caps_in_stars : Set[Int] =
            (for (star <- stars_reset; starcaps = (star2Caps.getOrElse(star, Set()));
              cap <- starcaps) yield cap).toSet

          val ops : Seq[Seq[UpdateOp]] = {
              val is_in_stars = caps_in_stars contains index
              (is_activated, is_in_stars) match {
                case (true, true) => single
                case (true, false) => append_after
                case (false, true) => clear
                case (false, false) => nochange
              }
          }
          ops
        }
      })
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

    val tranEnd = getState(aut.accepting)
    builder.setAccept(tranEnd, true, output)

    val tran = builder.getTransducer
    tran
  }
}
