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

import java.lang.StringBuilder

case class PFA(val sTran: MMap[PFA.State, Seq[PFA.SigmaTransition]],
  val preTran: MMap[PFA.State, Seq[PFA.ETransition]],
  val postTran: MMap[PFA.State, Seq[PFA.ETransition]],
  val initial: PFA.State,
  val accepting: PFA.State)

object PFA {

  type State = BricsAutomaton#State
  type TLabel = BricsAutomaton#TLabel
  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps
  type SigmaTransition = (TLabel, State)
  type ETransition = State

  // the automaton,
  // number of capture groups,
  // number of stars,
  // map from state to the capture groups it's in,
  // map from state pair to stars which it resets
  // map from star to the capture groups within
  type completeInfo = (PFA, Int, Int, Map[State, Set[Int]], Map[(State, State), Set[Int]], Map[Int, Set[Int]])

  private class GState extends BState {
    override def toString = "qP" + hashCode
  }

  private def getNewState : State = new GState

  def none() : PFA = {
      val init = getNewState
      val end = getNewState
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      val pre = new MHashMap[State, Seq[ETransition]]
      val post = new MHashMap[State, Seq[ETransition]]
      PFA(trans, pre, post, init, end)
  }

  def epsilon() : PFA = {
      val init = getNewState
      val end = getNewState
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      val pre = new MHashMap[State, Seq[ETransition]]
      pre += ((init, Seq(end)))
      val post = new MHashMap[State, Seq[ETransition]]
      PFA(trans, pre, post, init, end)
  }

  def single(lbl : TLabel) : PFA = {
    if (LabelOps isNonEmptyLabel lbl) {
      val init = getNewState
      val end = getNewState
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      trans += ((init, Seq((lbl, end))))
      val pre = new MHashMap[State, Seq[ETransition]]
      val post = new MHashMap[State, Seq[ETransition]]
      PFA(trans, pre, post, init, end)
    } else {
      none
    }
  }

  def constant(str: Seq[Int]) : PFA = {
    if (str.isEmpty) {
      epsilon
    } else {
      val h = str.head
      val t = str.tail
      val haut = single(LabelOps.interval(h.toChar, h.toChar))
      concat(haut, constant(t))
    }
  }

  def alternate(aut1 : PFA, aut2 : PFA) : PFA = {
    (aut1, aut2) match {
      case (PFA(t1, pre1, post1, init1, end1), PFA(t2, pre2, post2, init2, end2)) => {
        val init = getNewState
        val end = getNewState
        val trans = t1 ++ t2
        val pre = pre1 ++ pre2
        pre += ((init, Seq(init1, init2)))
        pre += ((end1, Seq(end)))
        pre += ((end2, Seq(end)))
        val post = post1 ++ post2

        PFA(trans, pre, post, init, end)
      }
    }
  }

  def concat(aut1 : PFA, aut2 : PFA) : PFA = {
    (aut1, aut2) match {
      case (PFA(t1, pre1, post1, init1, end1), PFA(t2, pre2, post2, init2, end2)) => {
        val trans = t1 ++ t2
        val pre = pre1 ++ pre2
        pre += ((end1, Seq(init2)))
        val post = post1 ++ post2

        PFA(trans, pre, post, init1, end2)
      }
    }
  }

  def star(aut : PFA) : PFA = {
    aut match {
      case PFA(t1, pre1, post1, init1, end1) => {
        val end = getNewState
        pre1 += ((end1, Seq(init1)))

        (post1 get init1) match {
          case None => {
            post1 += (init1 -> Seq(end))
          }
          case Some(tgts) => {
            post1(init1) = tgts :+ (end)
          }
        }

        PFA(t1, pre1, post1, init1, end)
      }
    }
  }

  def lazystar(aut : PFA) : PFA = {
    aut match {
      case PFA(t1, pre1, post1, init1, end1) => {
        val end = getNewState
        pre1.+=((end1, Seq(init1)))

        (pre1 get init1) match {
          case None => {
            pre1 += (init1 -> Seq(end))
          }
          case Some(tgts) => {
            pre1(init1) = tgts.+:(end)
          }
        }

        PFA(t1, pre1, post1, init1, end)
      }
    }
  }

  def plus(aut : PFA) : PFA = {
    aut match {
      case PFA(t1, pre1, post1, init1, end1) => {
        val end = getNewState
        pre1.+=((end1, Seq(init1, end)))

        PFA(t1, pre1, post1, init1, end)
      }
    }
  }

  def lazyplus(aut : PFA) : PFA = {
    aut match {
      case PFA(t1, pre1, post1, init1, end1) => {
        val end = getNewState
        pre1.+=((end1, Seq(end, init1)))

        PFA(t1, pre1, post1, init1, end)
      }
    }
  }

  def optional(aut : PFA) : PFA = {
    aut match {
      case PFA(t1, pre1, post1, init1, end1) => {
        (post1 get init1) match {
          case None => {
            post1 += (init1 -> Seq(end1))
          }
          case Some(tgts) => {
            post1(init1) = tgts.+:(end1)
          }
        }
        PFA(t1, pre1, post1, init1, end1)
      }
    }
  }

  def toDot(aut: PFA) : String = {
    val sb = new StringBuilder()
    sb.append("digraph PFA {\n")

    sb.append(aut.initial + "[shape=square];\n")
    sb.append(aut.accepting + "[peripheries=2];\n")

    var priority = Int.MaxValue
    for (tran <- aut.sTran) {
      val (state, arrows) = tran
      for (arrow <- arrows) {
        val (lbl, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"" + lbl + "/" + priority + "\"];\n")
        priority -= 1
      }
    }

    priority = Int.MaxValue
    for ((s, arrow) <- aut.preTran; dest <- arrow) {
      sb.append(s + " -> " + dest);
      sb.append("[label=\"preeps" + "/" + priority + "\"];\n")
      priority -= 1
    }

    priority = Int.MaxValue
    for ((s, arrow) <- aut.postTran; dest <- arrow) {
      sb.append(s + " -> " + dest);
      sb.append("[label=\"posteps" + "/" + priority + "\"];\n")
      priority -= 1
    }

    sb.append("}\n")

    return sb.toString()
  }

  def printInfo(info : completeInfo) = {
    val (aut, numCap, numStar, state2Caps, states2Stars, star2Caps) = info
    Console.withOut(Console.err) {
      println("   Generated  PNFA with " + numCap + " capture groups and " + numStar + " Klenne stars:")
      println(PFA.toDot(aut))
      println("   State to Capture Groups:")
      for ((s, caps) <- state2Caps) {
        println(s + " -> { " + caps + " }")
      }
      println("   States to Kleene Stars:")
      for ((s, stars) <- states2Stars) {
        println(s + " -> { " + stars + " }")
      }
      println("   Star to Capture Groups:")
      for ((star, caps) <- star2Caps) {
        println(star + " -> { " + caps + " }")
      }
    }
  }
}

class Regex2PFA(theory : OstrichStringTheory) {

  import PFA.completeInfo

  type State = PFA.State
  type TLabel = PFA.TLabel
  val LabelOps : TLabelOps[TLabel] = BricsTLabelOps

  import theory.{re_none, re_all, re_eps, re_allchar, re_charrange,
    re_++, re_union, re_inter, re_*, re_*?, re_+, re_+?, re_opt, re_comp,
    re_loop, str_to_re, re_from_str,
    re_capture, re_reference, re_from_ecma2020}

  // this is the map from literal numbering to internal numbering of
  // capture groups. It is for translating the replacement string.
  private val capNumTransform =
    new MHashMap[Int, Int]

  private def buildPatternRegex(pat : ITerm) : completeInfo = {

    var numCapture : Int = 0
    var numStar : Int = 0

    val capState =
      new MHashMap[Int, MSet[State]]
      with MMultiMap[Int, State]

    // record the start and end state of subexpr, and capture groups within a star
    val starInfo =
      new MHashMap[Int, (State, State, Set[Int])]

    def buildPatternImpl(t : ITerm) : (PFA, Set[Int]) = { // returns PFA and capture groups within
      t match {
        case IFunApp(`re_none`, _) =>
          (PFA.none, Set())
        case IFunApp(`re_eps`, _) =>
          (PFA.epsilon, Set())
        case IFunApp(`re_allchar`, _) =>
          (PFA.single(LabelOps.sigmaLabel), Set())
        case IFunApp(`re_all`, _) => {
          val aut_allchar = PFA.single(LabelOps.sigmaLabel)
          val aut_all = PFA.star(aut_allchar)
          val localStarNum = numStar // considered as Kleene star Sigma*
          numStar += 1

          starInfo(localStarNum) = (aut_allchar.initial, aut_allchar.accepting, Set.empty[Int])
          (aut_all, Set())
        }
        case IFunApp(`re_charrange`,
          Seq(IIntLit(IdealInt(a)), IIntLit(IdealInt(b)))) => {
            val lbl = LabelOps.interval(a.toChar, b.toChar) // XXX:Int to Char?
            (PFA.single(lbl), Set())
        }
        case IFunApp(`re_++`, Seq(a, b)) => {
          val (autA, capA) = buildPatternImpl(a)
          val (autB, capB) = buildPatternImpl(b)
          (PFA.concat(autA, autB), capA ++ capB)
        }
        case IFunApp(`re_union`, Seq(a, b)) => {
          val (autA, capA) = buildPatternImpl(a)
          val (autB, capB) = buildPatternImpl(b)
          (PFA.alternate(autA, autB), capA ++ capB)
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
          starInfo(localStarNum) = (autA.initial, autA.accepting, capA)

          (PFA.star(autA), capA)
        }
        case IFunApp(`re_*?`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          val localStarNum = numStar
          numStar += 1
          starInfo(localStarNum) = (autA.initial, autA.accepting, capA)

          (PFA.lazystar(autA), capA)
        }
        case IFunApp(`re_+`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          val localStarNum = numStar
          numStar += 1 // plus is regarded as a star
          starInfo(localStarNum) = (autA.initial, autA.accepting, capA)

          (PFA.plus(autA), capA)
        }
        case IFunApp(`re_+?`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          val localStarNum = numStar
          numStar += 1 // plus is regarded as a star
          starInfo(localStarNum) = (autA.initial, autA.accepting, capA)

          (PFA.lazyplus(autA), capA)
        }
        case IFunApp(`re_opt`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)
          (PFA.optional(autA), capA)
        }
        case IFunApp(`re_loop`, Seq(IIntLit(n1), IIntLit(n2), a)) => {
          // NOTE
          // It is possible to support this
          // the crux is to find a way to construct a PFA
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
                "Duplicate capture group : " + litCaptureNum)
            }
          }

          val (autA, capA) = buildPatternImpl(a)

          for ((s, trans) <- autA.sTran; (lbl, tgt) <- trans) {
            capState.addBinding(localCaptureNum, tgt)
            capState.addBinding(localCaptureNum, s)
          }
          for ((s, trans) <- autA.preTran; tgt <- trans) {
            capState.addBinding(localCaptureNum, s)
            capState.addBinding(localCaptureNum, tgt)
          }
          for ((s, trans) <- autA.postTran; tgt <- trans) {
            capState.addBinding(localCaptureNum, s)
            capState.addBinding(localCaptureNum, tgt)
          }

          (autA, capA + localCaptureNum)
        }
        case IFunApp(`str_to_re`, Seq(a)) => {
          (PFA.constant(StringTheory.term2List(a)), Set())
        }
        case IFunApp(`re_from_ecma2020`, Seq(a)) => {
          val parser = new ECMARegexParser(theory)
          val t = parser.string2Term(StringTheory.term2String(a))
          buildPatternImpl(t)
        }
        case _ =>
          throw new IllegalArgumentException(
            "could not translate " + t + " to an automaton")
        // TODO: re_from_str ??
      }
    }

    val (aut, _) = buildPatternImpl(pat)
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

    for ((starnum, (start, end, _)) <- starInfo) {
      states2Star_mut.addBinding((end, start), starnum)
    }

    val states2Star = (for ((s, star) <- states2Star_mut)
      yield (s, star.toSet)).toMap

    (aut, numCapture, numStar, state2Capture, states2Star, star2Capture)
  }

  private def buildReplacementRegex(t : ITerm) : Seq[UpdateOp] = {
    t match {
      case IFunApp(`re_eps`, _) => Seq.empty[UpdateOp]
      case IFunApp(`re_++`, Seq(a, b)) => {
        val opsa = buildReplacementRegex(a)
        val opsb = buildReplacementRegex(b)
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

  def buildReplaceInfo(pat : ITerm, rep: ITerm) : (completeInfo, Seq[UpdateOp]) = {
    capNumTransform.clear
    val info = buildPatternRegex(pat)
    val ops = buildReplacementRegex(rep)

    (info, ops)
  }

  def buildExtractInfo(index: Int, pat: ITerm) : (Int, completeInfo) = {
    capNumTransform.clear

    val info = buildPatternRegex(pat)
    val localindex =
      (capNumTransform get index) match {
        case None =>
          throw new IllegalArgumentException("Undefined capture group referenced: " + index)
        case Some(l) => l
      }

    (localindex, info)
  }

}
