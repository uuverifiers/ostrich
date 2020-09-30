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

import ap.basetypes.IdealInt
import ap.parser._
import ap.theories.strings.StringTheory

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}

import scala.collection.mutable.{HashMap => MHashMap,
                                 HashSet => MHashSet,
                                 LinkedHashSet => MLinkedHashSet,
                                 Stack => MStack,
                                 TreeSet => MTreeSet,
                                 MultiMap => MMultiMap,
                                 Set => MSet,
                                 Map => MMap}

case class GlushkovPFA (val initialTrans : Seq[GlushkovPFA.Transition], 
  val trans: MMap[GlushkovPFA.State, Seq[GlushkovPFA.Transition]], 
  val start: Set[GlushkovPFA.State], 
  val end: Set[GlushkovPFA.State], 
  val empty: Boolean) // if q0 is accepting, or if N accepts \epsilon

object GlushkovPFA {

  type State = BricsAutomaton#State
  type TLabel = BricsAutomaton#TLabel
  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps
  type Transition = (TLabel, State)

  // the automaton, 
  // number of capture groups, 
  // number of stars,
  // map from state to the capture groups it's in,
  // map from state pair to stars which it resets
  // map from star to the capture groups within
  type completeInfo = (GlushkovPFA, Int, Int, Map[State, Set[Int]], Map[(State, State), Set[Int]], Map[Int, Set[Int]])

  private class GState extends BState {
    override def toString = "q" + hashCode
  }

  private def getNewState : State = new GState

  def none() : GlushkovPFA = {
      val trans = new MHashMap[State, Seq[Transition]]
      GlushkovPFA(Seq(), trans, Set(), Set(), false) 
  }

  def epsilon() : GlushkovPFA = {
      val trans = new MHashMap[State, Seq[Transition]]
      GlushkovPFA(Seq(), trans, Set(), Set(), true)
  }

  def single(lbl : TLabel) : GlushkovPFA = {
    if (LabelOps isNonEmptyLabel lbl) {
      val s = getNewState
      val trans = new MHashMap[State, Seq[Transition]]
      GlushkovPFA(Seq((lbl, s)), trans, Set(s), Set(s), false)
    } else {
      none
    }
  }

  def alternate(aut1 : GlushkovPFA, aut2 : GlushkovPFA) : GlushkovPFA = {
    (aut1, aut2) match {
      case (GlushkovPFA(init1, t1, s1, e1, empty1), GlushkovPFA(init2, t2, s2, e2, empty2)) => {
        val empty = empty1 || empty2
        val start = s1 ++ s2
        val end = e1 ++ e2
        val init = init1 ++ init2 // aut1 is prioritised

        var trans = t1
        for (p <- t2) { // states of aut1 and 2 are different
          trans += p
        }

        GlushkovPFA(init, trans, start, end, empty)
      }
    }
  }

  def concat(aut1 : GlushkovPFA, aut2 : GlushkovPFA) : GlushkovPFA = {
    (aut1, aut2) match {
      case (GlushkovPFA(init1, t1, s1, e1, empty1), GlushkovPFA(init2, t2, s2, e2, empty2)) => {
        val empty = empty1 && empty2

        var start = s1
        if (empty1) {
          start ++= s2
        }

        var end = e2
        if (empty2) {
          end ++= e1
        }

        var init = init1
        if (empty1) {
          init ++= init2 // it is preferred to go aut1 first, if possible
        }

        var trans = t1
        for (es1 <- e1) { // bridge aut1 and aut2
          (trans get es1) match {
            case None => {
              trans += (es1 -> init2) 
            }
            case Some(tgts) => {
              trans(es1) = tgts ++ init2 // prefer to stay in aut1
            }
          }
        }
        for (p <- t2) { // states of aut1 and 2 are different
          trans += p
        }

        GlushkovPFA(init, trans, start, end, empty)
      }
    }
  }

  def star(aut : GlushkovPFA) : GlushkovPFA = {
    aut match {
      case GlushkovPFA(init1, t1, s1, e1, empty1) => {

        var trans = t1
        for (es <- e1) {
          (trans get es) match {
            case None => {
              trans += (es -> init1)
            }
            case Some(tgts) => {
              trans(es) = tgts ++ init1 // prefer to match longer substring in an iteration
            }
          }
        }

        GlushkovPFA(init1, trans, s1, e1, true)
      }
    }
  }

  def plus(aut : GlushkovPFA) : GlushkovPFA = {
    aut match {
      case GlushkovPFA(init1, t1, s1, e1, empty1) => {

        var trans = t1
        for (es <- e1) {
          (trans get es) match {
            case None => {
              trans += (es -> init1)
            }
            case Some(tgts) => {
              trans(es) = tgts ++ init1 // prefer to match longer substring in an iteration
            }
          }
        }

        GlushkovPFA(init1, trans, s1, e1, empty1)
      }
    }
  }

  def optional(aut : GlushkovPFA) : GlushkovPFA = {
    aut match {
      case GlushkovPFA(init1, t1, s1, e1, empty1) => {
        GlushkovPFA(init1, t1, s1, e1, true)
      }
    }
  }
}

class Regex2PFA(theory : OstrichStringTheory) {

  import GlushkovPFA.completeInfo

  type State = GlushkovPFA.State
  type TLabel = GlushkovPFA.TLabel
  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  import theory.{re_none, re_all, re_eps, re_allchar, re_charrange,
    re_++, re_union, re_inter, re_*, re_+, re_opt, re_comp,
    re_loop, str_to_re, re_from_str, 
    re_capture, re_reference}

  def buildAll(pat : ITerm, rep: ITerm) : (completeInfo, Seq[UpdateOp]) = {
    var numCapture : Int = 0
    var numStar : Int = 0

    val capState =
      new MHashMap[Int, MSet[State]]
      with MMultiMap[Int, State]

    // the set of Start, End, and capture groups within
    val starInfo =
      new MHashMap[Int, (Set[State], Set[State], Set[Int])]

    // this is the map from literal numbering to internal numbering of 
    // capture groups. It is for translating the replacement string.
    val capNumTransform = 
      new MHashMap[Int, Int]

    def buildPatternImpl(t : ITerm) : (GlushkovPFA, Set[Int]) = {
      t match {
        case IFunApp(`re_none`, _) =>
          (GlushkovPFA.none, Set())
        case IFunApp(`re_eps`, _) =>
          (GlushkovPFA.epsilon, Set())
        case IFunApp(`re_allchar`, _) =>
          (GlushkovPFA.single(LabelOps.sigmaLabel), Set())
        case IFunApp(`re_all`, _) => {
          val aut_allchar = GlushkovPFA.single(LabelOps.sigmaLabel)
          val aut_all = GlushkovPFA.star(aut_allchar)
          (aut_all, Set())
        }
        case IFunApp(`re_charrange`,
          Seq(IIntLit(IdealInt(a)), IIntLit(IdealInt(b)))) => {
            val lbl = LabelOps.interval(a.toChar, b.toChar) // XXX:Int to Char?
            (GlushkovPFA.single(lbl), Set())
        }
        case IFunApp(`re_++`, Seq(a, b)) => {
          val (autA, capA) = buildPatternImpl(a)
          val (autB, capB) = buildPatternImpl(b)
          (GlushkovPFA.concat(autA, autB), capA ++ capB)
        }
        case IFunApp(`re_union`, Seq(a, b)) => {
          val (autA, capA) = buildPatternImpl(a)
          val (autB, capB) = buildPatternImpl(b)
          (GlushkovPFA.alternate(autA, autB), capA ++ capB)
        }
        case IFunApp(`re_inter`, Seq(a, b)) => {
          throw new IllegalArgumentException(
            "regex with capture groups does not support intersection " + t)
        }
        case IFunApp(`re_comp`, Seq(a)) => {
          throw new IllegalArgumentException(
            "regex with capture groups does not support complement " + t)
        }
        case IFunApp(`re_*`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          val localStarNum = numStar
          numStar += 1
          starInfo(localStarNum) = (autA.start, autA.end, capA)

          (GlushkovPFA.star(autA), capA)
        }
        case IFunApp(`re_+`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          val localStarNum = numStar
          numStar += 1 // plus is regarded as a star
          starInfo(localStarNum) = (autA.start, autA.end, capA)

          (GlushkovPFA.star(autA), capA)
        }
        case IFunApp(`re_opt`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)
          (GlushkovPFA.optional(autA), capA)
        }
        case IFunApp(`re_loop`, Seq(IIntLit(n1), IIntLit(n2), a)) => {
          // NOTE
          // It is possible to support this
          // the crux is to find a way to construct the Glushkov NFA
          // which allows bounded match of a
          throw new IllegalArgumentException(
            "regex with capture groups does not support loop (yet!) " + t)
        }
        case IFunApp(`re_capture`, Seq(IIntLit(IdealInt(litCaptureNum)), a)) => {
          val localCaptureNum = numCapture
          numCapture += 1 // capture group is numbered from 0 to numCapture - 1

          (capNumTransform get litCaptureNum) match {
            case None => { capNumTransform += (litCaptureNum -> localCaptureNum)}
            case Some(_) => {
              throw new IllegalArgumentException(
                "Duplicate capture group index " + litCaptureNum)
            }
          }

          val (autA, capA) = buildPatternImpl(a)

          for ((s, trans) <- autA.trans; (lbl, tgt) <- trans) {
            capState.addBinding(localCaptureNum, tgt)
          }
          for (s <- autA.start) {
            capState.addBinding(localCaptureNum, s)
          }

          (GlushkovPFA.star(autA), capA + localCaptureNum)
        }
        case _ =>
          throw new IllegalArgumentException(
            "could not translate " + t + " to an automaton")
        // TODO: str_to_re & re_from_str ??
      }
    }

    def buildReplacementImpl(t : ITerm) : Seq[UpdateOp] = {
      t match {
        case IFunApp(`re_eps`, _) => Seq.empty[UpdateOp]
        case IFunApp(`re_++`, Seq(a, b)) => {
          val opsa = buildReplacementImpl(a)
          val opsb = buildReplacementImpl(b)
          opsa ++ opsb
        }
        case IFunApp(`re_reference`, Seq(IIntLit(IdealInt(litCaptureNum)))) => {
          (capNumTransform get litCaptureNum) match {
            case None =>
              throw new IllegalArgumentException("Undefined capture group referenced: " + litCaptureNum)
            case Some(localCaptureNum) => List(RefVariable(localCaptureNum))
          }
        }
        case IFunApp(`str_to_re`, Seq(a)) => {
          val str = StringTheory.term2List(a)
          (for (v <- str)
            yield Constant(v.toChar)).toSeq
        }
        case _ =>
          throw new IllegalArgumentException(
            "could not use " + t + " in the replacement string")
      }
    }

    val (aut, _) = buildPatternImpl(pat)
    val ops = buildReplacementImpl(rep)
    val state2Capture_mut = new MHashMap[State, MSet[Int]] with MMultiMap[State, Int]

    for ((cap, states) <- capState;
         s <- states) {
        state2Capture_mut.addBinding(s, cap)
    }

    val state2Capture = (for ((s, caps) <- state2Capture_mut) 
      yield (s, caps.toSet)).toMap

    val states2Star_mut = new MHashMap[(State, State), MSet[Int]] with MMultiMap[(State, State), Int]
    val star2Capture = starInfo.map({
      case (starnum, (_, _, caps)) => (starnum, caps)
    }).toMap

    for ((starnum, (start, end, _)) <- starInfo; s <- start; e <- end) {
      states2Star_mut.addBinding((s, e), starnum)
    }

    val states2Star = (for ((s, star) <- states2Star_mut) 
      yield (s, star.toSet)).toMap

    ((aut, numCapture, numStar, state2Capture, states2Star, star2Capture), ops)
  }

}
