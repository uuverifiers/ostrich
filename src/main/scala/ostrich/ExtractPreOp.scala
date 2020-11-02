/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2020 Zhilei Han
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
