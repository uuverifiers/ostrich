/** This file is part of Ostrich, an SMT solver for strings. Copyright (c) 2023
  * Denghang Hu. All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  * * Redistributions of source code must retain the above copyright notice,
  * this list of conditions and the following disclaimer.
  *
  * * Redistributions in binary form must reproduce the above copyright notice,
  * this list of conditions and the following disclaimer in the documentation
  * and/or other materials provided with the distribution.
  *
  * * Neither the name of the authors nor the names of their contributors may be
  * used to endorse or promote products derived from this software without
  * specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGE.
  */

package ostrich.cesolver.preop

import scala.collection.mutable.{
  HashMap => MHashMap,
  Stack => MStack,
  HashSet => MHashSet
}

import ostrich.automata.Automaton
import ostrich.automata.Transducer
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import Transducer._
import ostrich.cesolver.automata.CETransducer
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.util.ParikhUtil.{partition, State, getImage}
import ostrich.cesolver.automata.CETLabelEnumerator

trait ReplaceCEPreOpBase {
  def apply(w : Seq[Char], rep: Seq[Char]) : CEPreOp = ReplaceCEPreOpWord(w, rep)
}

object ReplaceCEShortestPreOp extends ReplaceCEPreOpBase {
  def apply(aut: CostEnrichedAutomatonBase, rep: Seq[Char]) : CEPreOp = ReplaceCEPreOpShortestRegEx(aut, rep)
}

object ReplaceCELongestPreOp extends ReplaceCEPreOpBase {
  def apply(aut: CostEnrichedAutomatonBase, rep: Seq[Char]) : CEPreOp = ReplaceCEPreOpLongestRegEx(aut, rep)
}

object ReplaceCEPreOpWord {
  /** The representation of x = replace(y, pattern, replacement) where pattern
    * is a concrete string
    */
  def apply(pattern: Seq[Char], replacement: Seq[Char]) = {
    val wtran =
      if (pattern.isEmpty) buildEmptyWordTransducer()
      else buildNonEmptyWordTransducer(pattern)
    new ReplaceCEPreOp(wtran, replacement)
  }

  private def buildEmptyWordTransducer(): CETransducer = {
    val ceTran = new CETransducer
    val initState = ceTran.initialState
    val copyRest = ceTran.newState()
    val internal = OutputOp("", Internal, "")
    val copy = OutputOp("", Plus(0), "")
    ceTran.addETransition(initState, internal, copyRest)
    ceTran.addTransition(copyRest, ceTran.LabelOps.sigmaLabel, copy, copyRest)
    ceTran.setAccept(copyRest, true)
    ceTran
  }

  /** Build transducer that identifies first instance of w and replaces it with
    * internal char
    */
  private def buildNonEmptyWordTransducer(
      w: Seq[Char]
  ): CETransducer = {
    assert(w.nonEmpty)
    val ceTran = new CETransducer

    val initState = ceTran.initialState
    val states = initState :: (List.fill(w.size - 1)(ceTran.newState()))
    val finstates = List.fill(w.size)(ceTran.newState())
    val copyRest = ceTran.newState()
    val nop = OutputOp("", NOP, "")
    val internal = OutputOp("", Internal, "")
    val copy = OutputOp("", Plus(0), "")
    val end = w.size - 1

    ceTran.setAccept(initState, true)
    finstates.foreach(ceTran.setAccept(_, true))
    ceTran.setAccept(copyRest, true)

    // recognise word
    // deliberately miss last element
    for (i <- 0 until w.size - 1) {
      ceTran.addTransition(states(i), (w(i), w(i)), nop, states(i + 1))
    }
    ceTran.addTransition(states(end), (w(end), w(end)), internal, copyRest)

    // copy rest after first match
    ceTran.addTransition(copyRest, ceTran.LabelOps.sigmaLabel, copy, copyRest)

    // begin again if mismatch, the mismathced char is w(i)
    for (i <- 0 until w.size) {
      // the heads of mismatched string
      val mismatchHeads = w.slice(0, i)
      // char that are handled using KMP algorithm
      val KMPMatchedChars = new MHashSet[Char]
      KMPMatchedChars += w(i)

      // for each prefix - we go in reverse so we get the longest ones
      // first
      for (j <- i - 1 to 0 by -1) {
        val prefix = w.slice(0, j)
        val charNext = w(prefix.size)
        if (
          !KMPMatchedChars.contains(charNext) && mismatchHeads.endsWith(prefix)
        ) {
          val rejectedOldMatchSize = mismatchHeads.size - prefix.size
          val rejectedOldMatchPart =
            mismatchHeads.slice(0, rejectedOldMatchSize)
          // next char is either part of next match or the last char
          val rejectedOutput = OutputOp(rejectedOldMatchPart, NOP, "")
          val rejectedOutputFin = OutputOp(mismatchHeads, Plus(0), "")

          ceTran.addTransition(
            states(i),
            (charNext, charNext),
            rejectedOutput,
            states(prefix.size + 1)
          )
          // or word ends here...
          ceTran.addTransition(
            states(i),
            (charNext, charNext),
            rejectedOutputFin,
            finstates(i)
          )
        }
      }

      // letters that should return to start 
      val output = OutputOp(mismatchHeads, Plus(0), "")
      for (lbl <- ceTran.LabelOps.subtractLetters(KMPMatchedChars, ceTran.LabelOps.sigmaLabel))
        ceTran.addTransition(states(i), lbl, output, states(0))    
        
      // handle word ending in middle of match
      val outop = if (i == w.size - 1) internal else output
      ceTran.addTransition(states(i), (w(i), w(i)), outop, finstates(i))
    }

    ceTran

  }

}

object ReplaceCEPreOpLongestRegEx {
  /**
    * The representation of x = replace(y, pattern, replacement) where pattern
    * is a regular expression and is matched longest
    */
  def apply(pattern: CostEnrichedAutomatonBase, replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern)
    new ReplaceCEPreOp(transducer, replacement)
  }


  /**
   * Builds transducer that identifies leftmost and longest match of
   * regex by rewriting matches to internalChar.
   *
   * TODO: currently does not handle empty matches
   */
  private def buildTransducer(
      aut: CostEnrichedAutomatonBase
  ): CETransducer = {
    ParikhUtil.todo("ReplaceCEPreOp: not handle empty match in pattern", 3)
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier: Set[State]) extends Mode
    // last transition finished a match and reached frontier
    case class EndMatch(val frontier: Set[State]) extends Mode
    // copy the rest of the word after first match
    case object CopyRest extends Mode

    val labelEnumerator = new CETLabelEnumerator(
      aut.transitionsWithVec.map(_._2)
    )
    val labels = labelEnumerator.enumDisjointLabelsComplete
    val ceTran = new CETransducer
    val nop = OutputOp("", NOP, "")
    val copy = OutputOp("", Plus(0), "")
    val internal = OutputOp("", Internal, "")

    // TODO: encapsulate this worklist automaton construction

    // states of transducer have current mode and a set of states that
    // should never reach a final state (if they do, a match has been
    // missed)
    val sMap = new MHashMap[State, (Mode, Set[State])]
    val sMapRev = new MHashMap[(Mode, Set[State]), State]

    // states of new transducer to be constructed
    val worklist = new MStack[State]

    def mapState(s: State, q: (Mode, Set[State])) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    // creates and adds to worklist any new states if needed
    def getState(m: Mode, noreach: Set[State]): State = {
      sMapRev.getOrElse(
        (m, noreach), {
          val s = ceTran.newState()
          mapState(s, (m, noreach))
          val goodNoreach = !noreach.exists(aut.isAccept(_))
          ceTran.setAccept(
            s,
            m match {
              case NotMatching => goodNoreach
              case EndMatch(_) => goodNoreach
              case Matching(_) => false
              case CopyRest    => goodNoreach
            }
          )
          if (goodNoreach)
            worklist.push(s)
          s
        }
      )
    }

    val autInit = aut.initialState
    val tranInit = ceTran.initialState

    mapState(tranInit, (NotMatching, Set.empty[State]))
    ceTran.setAccept(tranInit, true)
    worklist.push(tranInit)

    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = getImage(aut, Set(autInit), lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            val dontMatch = getState(NotMatching, noreachImg ++ initImg)
            ceTran.addTransition(ts, lbl, copy, dontMatch)

            if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), noreachImg)
              ceTran.addTransition(ts, lbl, nop, newMatch)
            }

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(EndMatch(initImg), noreachImg)
              ceTran.addTransition(ts, lbl, internal, oneCharMatch)
            }
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = getImage(aut, frontier, lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            if (!frontImg.isEmpty) {
              val contMatch = getState(Matching(frontImg), noreachImg)
              ceTran.addTransition(ts, lbl, nop, contMatch)
            }

            if (frontImg.exists(aut.isAccept(_))) {
              val stopMatch = getState(EndMatch(frontImg), noreachImg)
              ceTran.addTransition(ts, lbl, internal, stopMatch)
            }
          }
        }
        case EndMatch(frontier) => {
          for (lbl <- labels) {
            val frontImg = getImage(aut, frontier, lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            val noMatch = getState(CopyRest, frontImg ++ noreachImg)

            ceTran.addTransition(ts, lbl, copy, noMatch)
          }
        }
        case CopyRest => {
          for (lbl <- labels) {
            val noreachImg = getImage(aut, noreach, lbl)
            val copyRest = getState(CopyRest, noreachImg)
            ceTran.addTransition(ts, lbl, copy, copyRest)
          }
        }
      }
    }

    ceTran
  }

}

object ReplaceCEPreOpShortestRegEx {
  /**
    * The representation of x = replace(y, pattern, replacement) where pattern
    * is a regular expression and is matched shortest
    */
  def apply(pattern: CostEnrichedAutomatonBase, replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern)
    new ReplaceCEPreOp(transducer, replacement)
  }

  /**
   * Builds transducer that identifies leftmost and shortest non-empty
   * match of regex by rewriting matches to internalChar.
   *
   * If aut contains the empty word, the internalChar will be prepended
   */
  private def buildTransducer(
      aut: CostEnrichedAutomatonBase
  ): CETransducer = {
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier : Set[aut.State]) extends Mode
    // copy the rest of the word after first match
    case object CopyRest extends Mode

    val labelEnumerator = new CETLabelEnumerator(
      aut.transitionsWithVec.map(_._2)
    )
    val labels = labelEnumerator.enumDisjointLabelsComplete

    val ceTran = new CETransducer
    val nop = OutputOp("", NOP, "")
    val copy = OutputOp("", Plus(0), "")
    val internal = OutputOp("", Internal, "")

    // states of transducer have current mode and a set of states that
    // should never reach a final state (if they do, a match has been
    // missed)
    val sMap = new MHashMap[aut.State, (Mode, Set[aut.State])]
    val sMapRev = new MHashMap[(Mode, Set[aut.State]), aut.State]

    // states of new transducer to be constructed
    val worklist = new MStack[aut.State]

    def mapState(s : aut.State, q : (Mode, Set[aut.State])) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    // creates and adds to worklist any new states if needed
    def getState(m : Mode, noreach : Set[aut.State]) : aut.State = {
      sMapRev.getOrElse((m, noreach), {
        val s = ceTran.newState()
        mapState(s, (m, noreach))
        val goodNoreach = !noreach.exists(aut.isAccept(_))
        ceTran.setAccept(s, m match {
          case NotMatching => goodNoreach
          case Matching(_) => false
          case CopyRest => goodNoreach
        })
        if (goodNoreach)
          worklist.push(s)
        s
      })
    }

    val autInit = aut.initialState
    val tranInit = ceTran.initialState

    // if accepts empty word, prepend internalChar and copy
    if (aut.isAccept(autInit)) {
      val copyRest = getState(CopyRest, Set.empty[aut.State])
      ceTran.addETransition(tranInit, internal, copyRest)
    } else {
      mapState(tranInit, (NotMatching, Set.empty[aut.State]))
      ceTran.setAccept(tranInit, true)
      worklist.push(tranInit)
    }

    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = getImage(aut, Set(autInit), lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            val dontMatch = getState(NotMatching, noreachImg ++ initImg)
            ceTran.addTransition(ts, lbl, copy, dontMatch)

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(CopyRest, noreachImg)
              ceTran.addTransition(ts, lbl, internal, oneCharMatch)
            } else if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), noreachImg)
              ceTran.addTransition(ts, lbl, nop, newMatch)
            }
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = getImage(aut, frontier, lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            if (frontImg.exists(aut.isAccept(_))) {
                val stopMatch = getState(CopyRest, noreachImg)
                ceTran.addTransition(ts, lbl, internal, stopMatch)
            } else if (!frontImg.isEmpty) {
              val contMatch = getState(Matching(frontImg), noreachImg)
              ceTran.addTransition(ts, lbl, nop, contMatch)
            }
          }
        }
        case CopyRest => {
          for (lbl <- labels) {
            val noreachImg = getImage(aut, noreach, lbl)
            val copyRest = getState(CopyRest, noreachImg)
            ceTran.addTransition(ts, lbl, copy, copyRest)
          }
        }
      }
    }

    ceTran
  }
}

/** Representation of x = replace(y, tran, replacement) where tran is a
  * transducer that replaces part of the word to be replaced with internal
  * symbols. Note that replacement can only be a concrete string
  */
class ReplaceCEPreOp(tran: CETransducer, replacement: Seq[Char])
    extends CEPreOp {
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    // x = replace(y, pattern, replacement)
    val rc = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val internals = partition(rc, replacement)
    val newYCon = tran.preImage(rc, internals)
    (Iterator(Seq(newYCon)), argumentConstraints)
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    for (s <- tran(arguments(0).map(_.toChar).mkString, replacement.mkString))
      yield s.toSeq.map(_.toInt)
  }

  override def toString(): String = "ReplaceCEPreOp"

}
