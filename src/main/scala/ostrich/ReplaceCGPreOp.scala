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

object ReplaceCGPreOp {

  import GlushkovPFA.completeInfo

  def apply(pat : completeInfo, rep : Seq[UpdateOp]) : PreOp = 
    StreamingTransducerPreOp(buildPSST(pat, rep))

  def buildPSST(pat : completeInfo, rep : Seq[UpdateOp]) : PrioStreamingTransducer = {
    val (aut, numCap, numStar, state2Caps, states2Stars, star2Caps) = pat

    // for each capture group, we have a string variable.
    // Besides, we have a special variable 'res' for the result, indexed by 'numCap'
    val builder = PrioStreamingTransducer.getBuilder(numCap + 1)
    type tranState = PrioStreamingTransducer#State
    type autState = GlushkovPFA.State
    type TLabel = GlushkovPFA.TLabel
    val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

    val labelEnumerator =
      new BricsTLabelEnumerator(
        (for ((_, t) <- aut.trans; (lbl, s) <- t)
          yield lbl).iterator ++
        (for ((lbl, s) <- aut.initialTrans)
          yield lbl).iterator)
    val labels = labelEnumerator.enumDisjointLabelsComplete

    // some common update operations
    def nochange(index : Int) : Seq[UpdateOp] = List(RefVariable(index))
    def append_after(index: Int) : Seq[UpdateOp] = List(RefVariable(index), Offset(0))
    def clear : Seq[UpdateOp] = List()
    def single : Seq[UpdateOp] = List(Offset(0))

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

    val output = List(RefVariable(numCap))

    abstract class Mode
    // not matching (left)
    case object NotMatching extends Mode
    // matching (long), word read so far leads to state 'frontier'
    case class Matching(val frontier : autState) extends Mode
    // last transition finished a match and reached frontier
    // 'EndMatch' behaves just like in left mode, 
    // the only difference is the way prohibition set is regarded
    case class EndMatch(val frontier : autState) extends Mode
    // copy the remaining characters
    case object CopyLeft extends Mode

    // a state of PSST consists of mode, and a set of states
    // that should not be reached, a.k.a. prohibition set
    val sMap = new MHashMap[tranState, (Mode, Set[autState])]
    val sMapRev = new MHashMap[(Mode, Set[autState]), tranState]

    // states of new transducer to be constructed
    val worklist = new MStack[tranState]

    def mapState(s : tranState, q : (Mode, Set[autState])) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    def isAccept(s : autState) : Boolean = {
      aut.end.contains(s)
    }

    // creates and adds to worklist any new states if needed
    def getState(m : Mode, noreach : Set[autState]) : tranState = {
      sMapRev.getOrElse((m, noreach), {
        val s = builder.getNewState
        mapState(s, (m, noreach))
        val goodNoreach = !noreach.exists(isAccept(_))
        builder.setAccept(s, m match {
          case NotMatching => goodNoreach
          case CopyLeft => goodNoreach
          case EndMatch(_) => goodNoreach
          case Matching(_) => false
        }, output)
      if (goodNoreach)
        worklist.push(s)
      s
      })
    }

    val tranInit = builder.initialState

    mapState(tranInit, (NotMatching, Set.empty[autState]))
    builder.setAccept(tranInit, true, output)
    worklist.push(tranInit)

    // the returned image is sorted by priority
    def getImage(s: autState, lbl : TLabel) : Seq[autState] = {
      (for (t <- aut.trans.get(s).iterator;
        (lbl2, s2) <- t;
        if LabelOps.labelsOverlap(lbl, lbl2)) 
          yield s2).toSeq
    }
    def getImageAll(states : Set[autState], lbl : TLabel) : Set[autState] = {
      for (s1 <- states;
           t <- aut.trans.get(s1).iterator;
           (lbl2, s2) <- t;
           if LabelOps.labelsOverlap(lbl, lbl2))
             yield s2
    }
    def getInitImage(lbl : TLabel) : Seq[autState] = {
      for ((lbl2, s) <- aut.initialTrans;
           if LabelOps.labelsOverlap(lbl, lbl2)) yield s
    }

    // dfs
    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = getInitImage(lbl)
            val noreachImg = getImageAll(noreach, lbl)

            // if we stay in 'left' mode, initImg should not be reached
            // and update the 'res' variable only.
            val dontMatch = getState(NotMatching, noreachImg ++ initImg.toSet)
            builder.addTransition(ts, lbl, only(numCap, append_after(numCap)), dontMatch)

            var priority = Int.MaxValue
            for (next <- initImg; if !(noreachImg contains next)) {
              val newMatch = getState(Matching(next), noreachImg)
              // update the correpsonding variables for 
              // capture groups that are relevant
              // (for now we don't need to care about stars)
              val caps = state2Caps.getOrElse(next, Set())
              var ops : Seq[Seq[UpdateOp]] = updateWithIndex {
                i => {
                  if (caps contains i) {
                    single
                  } else {
                    nochange(i)
                  }
                }
              }
              builder.addTransition(ts, lbl, ops, priority, newMatch)
              priority -= 1
            }

            // accept and go back to left mode directly
            for (next <- initImg; if isAccept (next)) {
              val oneCharMatch = getState(EndMatch(next), noreachImg)
              // since we have not went into long mode
              // all the variables are empty except 'res'
              // just keep their values and we only need to update 'res' here
              lazy val caps = state2Caps.getOrElse(next, Set())
              val op = RefVariable(numCap) +: rep.flatMap({ 
                  case RefVariable(n) => {
                    if (caps contains n) {
                      single
                    } else {
                      List()
                    }
                  }
                  case o => List(o)
              })
              builder.addTransition(ts, lbl, only(numCap, op), priority, oneCharMatch)
              priority -= 1
            }
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = getImage(frontier, lbl)
            val noreachImg = getImageAll(noreach, lbl)

            var priority = Int.MaxValue
            for (next <- frontImg; if !(noreachImg contains next)) {
              val contMatch = getState(Matching(next), noreachImg)
              // we have to consider which Klenne Stars are reset
              // and how variables are thus updated
              val caps_activated = state2Caps.getOrElse(next, Set())
              val stars_reset : Set[Int] = states2Stars.getOrElse((frontier, next), Set.empty[Int])
              val caps_in_stars : Set[Int] = 
                (for (star <- stars_reset; starcaps = (star2Caps.getOrElse(star, Set()));
                  cap <- starcaps) yield cap).toSet

              val ops : Seq[Seq[UpdateOp]] = updateWithIndex { 
                index => {
                  val is_activated = caps_activated contains index
                  val is_in_stars = caps_in_stars contains index
                  (is_activated, is_in_stars) match {
                    case (true, true) => single
                    case (true, false) => append_after(index)
                    case (false, true) => clear
                    case (false, false) => nochange(index)
                  }
                }
              }
              builder.addTransition(ts, lbl, ops, priority, contMatch)
              priority -= 1
            }

            for (next <- frontImg; if isAccept (next)) {
              val stopMatch = getState(EndMatch(next), noreachImg)
              lazy val caps_activated = state2Caps.getOrElse(next, Set())
              lazy val stars_reset : Set[Int] = states2Stars.getOrElse((frontier, next), Set.empty[Int])
              lazy val caps_in_stars : Set[Int] = 
                (for (star <- stars_reset; starcaps = (star2Caps.getOrElse(star, Set()));
                  cap <- starcaps) yield cap).toSet


              val op : Seq[UpdateOp] = RefVariable(numCap) +: rep.flatMap {
                case RefVariable(index) => {
                  val is_activated = caps_activated contains index
                  val is_in_stars = caps_in_stars contains index
                  (is_activated, is_in_stars) match {
                    case (true, true) => single
                    case (true, false) => append_after(index)
                    case (false, true) => clear
                    case (false, false) => nochange(index)
                  }
                }
                case o => List(o)
              }
              val ops = updateWithIndex {
                index => {
                  if (index == numCap) {
                    op
                  } else {
                    clear
                  }
                }
              }
              builder.addTransition(ts, lbl, ops, priority, stopMatch)
              priority -= 1
            }
          }
        }
        case EndMatch(frontier) => {
          for (lbl <- labels) {
            val frontImg = getImage(frontier, lbl).toSet
            val noreachImg = getImageAll(noreach, lbl) ++ frontImg

            val startcopy = getState(CopyLeft, noreachImg)
            builder.addTransition(ts, lbl, only(numCap, append_after(numCap)), startcopy)
          }
        }
        case CopyLeft => {
          for (lbl <- labels) {
            val noreachImg = getImageAll(noreach, lbl)

            val continuecopy = getState(CopyLeft, noreachImg)
            builder.addTransition(ts, lbl, only(numCap, append_after(numCap)), continuecopy)
          }
        }
      }
    }

    val tran = builder.getTransducer
    tran
  }
}
