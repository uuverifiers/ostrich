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

  import GlushkovPFA.completeInfo

  def apply(index : Int, pat : completeInfo) : PreOp = 
    StreamingTransducerPreOp(buildPSST(index, pat))

  def buildPSST(index: Int, pat : completeInfo) : PrioStreamingTransducer = {
    val (aut, numCap, numStar, state2Caps, states2Stars, star2Caps) = pat

    // we only need one string variable for the 'index'-th capture group
    // Here it's numbered '0'
    val builder = PrioStreamingTransducer.getBuilder(1)
    type tranState = PrioStreamingTransducer#State
    type autState = GlushkovPFA.State
    type TLabel = PrioStreamingTransducer#TLabel
    val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

    // some common update operations
    def nochange : Seq[UpdateOp] = List(RefVariable(0))
    def append_after : Seq[UpdateOp] = List(RefVariable(0), Offset(0))
    def clear : Seq[UpdateOp] = List()
    def single : Seq[UpdateOp] = List(Offset(0))

    // PSST simply simulate the pNFA, thus with identical state set
    val sMap = new MHashMap[tranState, autState]
    val sMapRev = new MHashMap[autState, tranState]

    // states of new transducer to be constructed
    val worklist = new MStack[tranState]

    def mapState(s : tranState, q : autState) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    def isAccept(s : autState) : Boolean = {
      aut.end.contains(s)
    }

    // creates and adds to worklist any new states if needed
    def getState(as : autState) : tranState = {
      sMapRev.getOrElse(as, {
        val s = builder.getNewState
        mapState(s, as)

        // Here, every state is accepting. For those PSST states which corresponds to non-accepted states in pNFA, the output is empty (It's UB in this case actually). For others, output the string variable directly.
        // Note that it is possible the run of pNFA get stuck, so there should also be a 'dead state', which is handled specially
        val output = {
          if (isAccept(as)) {
            List(RefVariable(0))
          } else {
            List()
          }
        }
        builder.setAccept(s, true, output)

        worklist.push(s)
        s
      })
    }

    val tranInit = builder.initialState
    builder.setAccept(tranInit, true, List()) // if the string is empty, then the output must also be empty

    // dead state is important for correct semantics.
    // every state should have a transition to this state,
    // which should be of lowest priority so that failing
    // a match is considered last.
    val deadState = builder.getNewState
    builder.setAccept(deadState, true, List())
    builder.addTransition(deadState, LabelOps.sigmaLabel, List(clear), Int.MinValue, deadState)

    // Handle the initial transition
    var priority = Int.MaxValue
    for ((lbl, s) <- aut.initialTrans) {
      val ts = getState(s)
      // for initial transition, we do not need to consider Klenne Stars
      val caps = state2Caps.getOrElse(s, Set())
      if (caps contains index)
        builder.addTransition(tranInit, lbl, List(append_after), priority, ts) // append
      else
        builder.addTransition(tranInit, lbl, List(nochange), priority, ts) // keep unchanged
      builder.addTransition(tranInit, LabelOps.sigmaLabel, List(clear), Int.MinValue, deadState)
      priority -= 1
    }

    // Now the main dfs
    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val as = sMap(ts)

      priority = Int.MaxValue

      for (trans <- aut.trans.get(as).iterator; (lbl, next) <- trans) {
        val tnext = getState(next)

        // we have to consider which Klenne Stars are reset
        // and how variables are thus updated
        val caps_activated = state2Caps.getOrElse(next, Set())
        val stars_reset : Set[Int] = states2Stars.getOrElse((as, next), Set.empty[Int])
        val caps_in_stars : Set[Int] = 
          (for (star <- stars_reset; starcaps = (star2Caps.getOrElse(star, Set())); cap <- starcaps) yield cap).toSet

        val ops : Seq[UpdateOp] = {
          val is_activated = caps_activated contains index
          val is_in_stars = caps_in_stars contains index
          (is_activated, is_in_stars) match {
            case (true, true) => single
            case (true, false) => append_after
            case (false, true) => clear
            case (false, false) => nochange
          }
        }

        builder.addTransition(ts, lbl, List(ops), priority, tnext)
        builder.addTransition(ts, LabelOps.sigmaLabel, List(clear), Int.MinValue, deadState)
        priority -= 1
      }
    }

    val tran = builder.getTransducer
    tran
  }
}
