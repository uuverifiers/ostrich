/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ostrich.automata.{AtomicStateAutomaton, Transducer, Automaton,
                         CaleyGraph, ReplaceCharAutomaton, InitFinalAutomaton,
                         ProductAutomaton, NestedAutomaton, BricsTransducer,
                         PreImageAutomaton, PostImageAutomaton}

import ap.terfor.{Term, Formula, TermOrder, TerForConvenience}
import ap.terfor.preds.PredConj

import dk.brics.automaton.RegExp

import scala.collection.mutable.{HashMap => MHashMap,
                                 Stack => MStack,
                                 HashSet => MHashSet}

abstract class ReplacePreOpBase {
  def apply(a : Char) : PreOp = ReplacePreOpWord(Seq(a))

  def apply(w : Seq[Char]) : PreOp = ReplacePreOpWord(w)

  def apply(s : String) : PreOp = ReplacePreOpWord(s.toSeq)
}

object ReplaceLongestPreOp extends ReplacePreOpBase {
  /**
   * PreOp for x = replace(y, e, z) for regex e
   */
//  def apply(c : Term, context : PredConj) : PreOp =
//    ReplacePreOpRegEx(c, context)

  /**
   * PreOp for x = replace(y, e, z) for regex e represented as
   * automaton aut
   */
  def apply(aut : AtomicStateAutomaton) : PreOp =
    ReplaceLongestPreOpRegEx(aut)
}

object ReplaceShortestPreOp extends ReplacePreOpBase {
  /**
   * PreOp for x = replace(y, e, z) for regex e represented as
   * automaton aut, where left-most non-empty shortest match is replaced
   */
  def apply(aut : AtomicStateAutomaton) : PreOp =
    ReplaceShortestPreOpRegEx(aut)
}

/**
 * Companion object for ReplacePreOpWord, does precomputation of
 * transducer representation of word
 */
object ReplacePreOpWord {
  import Transducer._

  def apply(w : Seq[Char]) = {
    val wtran = if (w.isEmpty) buildEmptyWordTransducer()
      else buildNonEmptyWordTransducer(w)
    new ReplacePreOpTran(wtran)
  }

  private def buildEmptyWordTransducer() : Transducer = {
    val builder = BricsTransducer.getBuilder
    val initState = builder.initialState
    val copyRest = builder.getNewState
    val internal = OutputOp("", Internal, "")
    val copy = OutputOp("", Plus(0), "")

    builder.addETransition(initState, internal, copyRest)
    builder.addTransition(copyRest, builder.LabelOps.sigmaLabel, copy, copyRest)
    builder.setAccept(copyRest, true)

    val res = builder.getTransducer
    return res
  }

  /**
   * Build transducer that identifies first instance of w and replaces it with
   * internal char
   */
  private def buildNonEmptyWordTransducer(w : Seq[Char]) : Transducer = {
    assert(!w.isEmpty)

    val builder = BricsTransducer.getBuilder

    val initState = builder.initialState
    val states = initState::(List.fill(w.size - 1)(builder.getNewState))
    val finstates = List.fill(w.size)(builder.getNewState)
    val copyRest = builder.getNewState
    val nop = OutputOp("", NOP, "")
    val internal = OutputOp("", Internal, "")
    val copy = OutputOp("", Plus(0), "")
    val end = w.size - 1

    builder.setAccept(initState, true)
    finstates.foreach(builder.setAccept(_, true))
    builder.setAccept(copyRest, true)

    // recognise word
    // deliberately miss last element
    for (i <- 0 until w.size - 1) {
      builder.addTransition(states(i), (w(i), w(i)), nop, states(i+1))
    }
    builder.addTransition(states(end), (w(end), w(end)), internal, copyRest)

    // copy rest after first match
    builder.addTransition(copyRest, builder.LabelOps.sigmaLabel, copy, copyRest)

    for (i <- 0 until w.size) {
      // the amount of w read up to state i
      val buffer = w.slice(0, i)
      // for when we need to output whole prefix read so far
      val output = OutputOp(buffer, Plus(0), "")

      // if mismatch, look for the largest suffix of the output buffer
      // that is a correct prefix of the word being searched for. Then
      // return to the state corresponding to that part of the word.

      val anyLbl = builder.LabelOps.sigmaLabel

      // chars that are handled specially (do not return to start)
      // e.g. the next letter in w
      val handledChars= new MHashSet[Char]
      handledChars.add(w(i))

      // for each prefix - we go in reverse so we get the longest ones
      // first
      for (j <- i - 1 to 0 by -1) {
        val prefix = w.slice(0, j)
        val charNext = w(prefix.size)

        if (!handledChars.contains(charNext) && buffer.endsWith(prefix)) {
          val rejectedOldMatchSize = buffer.size - prefix.size
          val rejectedOldMatchPart = buffer.slice(0, rejectedOldMatchSize)
          // next char either part of next match or last char and not
          // buffered
          val rejectedOutput = OutputOp(rejectedOldMatchPart, NOP, "")
          val rejectedOutputFin = OutputOp(buffer, Plus(0), "")

          builder.addTransition(states(i),
                                (charNext, charNext),
                                rejectedOutput,
                                states(prefix.size + 1))
          // or word ends here...
          builder.addTransition(states(i),
                                (charNext, charNext),
                                rejectedOutputFin,
                                finstates(i))

          handledChars.add(charNext)
        }
      }

      // letters that should return to start
      for (lbl <- builder.LabelOps.subtractLetters(handledChars, anyLbl)) {
        builder.addTransition(states(i), lbl, output, states(0))
      }

      // handle word ending in middle of match
      val outop = if (i == w.size - 1) internal else output
      builder.addTransition(states(i), (w(i), w(i)), outop, finstates(i))
    }

    val res = builder.getTransducer
    res
  }
}

/**
 * Companion class for building representation of x = replace(y, e,
 * z) for a regular expression e.
 */
object ReplaceLongestPreOpRegEx {
  import Transducer._

  /**
   * Build preop from c and context giving regex to be replaced
   */
//  def apply(c : Term, context : PredConj) : PreOp = {
//    val tran = buildTransducer(c, context)
//    new ReplacePreOpTran(tran)
//  }

  /**
   * Build preop from aut giving regex to be replaced
   */
  def apply(aut : AtomicStateAutomaton) : PreOp = {
    val tran = buildTransducer(aut)
    new ReplacePreOpTran(tran)
  }

  /**
   * Builds transducer that identifies leftmost and longest match of
   * regex by rewriting matches to internalChar
   */
//  private def buildTransducer(aut : AtomicStateAutomaton) : Transducer =
//    buildTransducer(aut)

  /**
   * Builds transducer that identifies leftmost and longest match of
   * regex by rewriting matches to internalChar.
   *
   * TODO: currently does not handle empty matches
   */
  private def buildTransducer(aut : AtomicStateAutomaton) : Transducer = {
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier : Set[aut.State]) extends Mode
    // last transition finished a match and reached frontier
    case class EndMatch(val frontier : Set[aut.State]) extends Mode
    // copy the rest of the word after first match
    case object CopyRest extends Mode

    val labels = aut.labelEnumerator.enumDisjointLabelsComplete
    val builder = aut.getTransducerBuilder
    val nop = OutputOp("", NOP, "")
    val copy = OutputOp("", Plus(0), "")
    val internal = OutputOp("", Internal, "")

    // TODO: encapsulate this worklist automaton construction

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
        val s = builder.getNewState
        mapState(s, (m, noreach))
        val goodNoreach = !noreach.exists(aut.isAccept(_))
        builder.setAccept(s, m match {
          case NotMatching => goodNoreach
          case EndMatch(_) => goodNoreach
          case Matching(_) => false
          case CopyRest => goodNoreach
        })
        if (goodNoreach)
          worklist.push(s)
        s
      })
    }

    val autInit = aut.initialState
    val tranInit = builder.initialState

    mapState(tranInit, (NotMatching, Set.empty[aut.State]))
    builder.setAccept(tranInit, true)
    worklist.push(tranInit)

    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = aut.getImage(autInit, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            val dontMatch = getState(NotMatching, noreachImg ++ initImg)
            builder.addTransition(ts, lbl, copy, dontMatch)

            if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), noreachImg)
              builder.addTransition(ts, lbl, nop, newMatch)
            }

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(EndMatch(initImg), noreachImg)
              builder.addTransition(ts, lbl, internal, oneCharMatch)
            }
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = aut.getImage(frontier, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            if (!frontImg.isEmpty) {
              val contMatch = getState(Matching(frontImg), noreachImg)
              builder.addTransition(ts, lbl, nop, contMatch)
            }

            if (frontImg.exists(aut.isAccept(_))) {
                val stopMatch = getState(EndMatch(frontImg), noreachImg)
                builder.addTransition(ts, lbl, internal, stopMatch)
            }
          }
        }
        case EndMatch(frontier) => {
          for (lbl <- labels) {
            val frontImg = aut.getImage(frontier, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            val noMatch = getState(CopyRest, frontImg ++ noreachImg)

            builder.addTransition(ts, lbl, copy, noMatch)
          }
        }
        case CopyRest => {
          for (lbl <- labels) {
            val noreachImg = aut.getImage(noreach, lbl)
            val copyRest = getState(CopyRest, noreachImg)
            builder.addTransition(ts, lbl, copy, copyRest)
          }
        }
      }
    }

    val tran = builder.getTransducer
    tran
  }
}

/**
 * Companion class for building representation of x = replace(y, e,
 * z) for a regular expression e with SMT-LIB leftmost shortest
 * semantics. Also, in line with SMT-LIB, prepend the word if e accepts
 * the empty language.
 */
object ReplaceShortestPreOpRegEx {
  import Transducer._

  /**
   * Build preop from aut giving regex to be replaced
   */
  def apply(aut : AtomicStateAutomaton) : PreOp = {
    val tran = buildTransducer(aut)
    new ReplacePreOpTran(tran)
  }

  /**
   * Builds transducer that identifies leftmost and shortest non-empty
   * match of regex by rewriting matches to internalChar.
   *
   * If aut contains the empty word, the internalChar will be prepended
   */
  private def buildTransducer(aut : AtomicStateAutomaton) : Transducer = {
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier : Set[aut.State]) extends Mode
    // copy the rest of the word after first match
    case object CopyRest extends Mode

    val labels = aut.labelEnumerator.enumDisjointLabelsComplete
    val builder = aut.getTransducerBuilder
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
        val s = builder.getNewState
        mapState(s, (m, noreach))
        val goodNoreach = !noreach.exists(aut.isAccept(_))
        builder.setAccept(s, m match {
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
    val tranInit = builder.initialState

    // if accepts empty word, prepend internalChar and copy
    if (aut(Seq.empty)) {
      val copyRest = getState(CopyRest, Set.empty[aut.State])
      builder.addETransition(tranInit, internal, copyRest)
    } else {
      mapState(tranInit, (NotMatching, Set.empty[aut.State]))
      builder.setAccept(tranInit, true)
      worklist.push(tranInit)
    }

    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = aut.getImage(autInit, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            val dontMatch = getState(NotMatching, noreachImg ++ initImg)
            builder.addTransition(ts, lbl, copy, dontMatch)

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(CopyRest, noreachImg)
              builder.addTransition(ts, lbl, internal, oneCharMatch)
            } else if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), noreachImg)
              builder.addTransition(ts, lbl, nop, newMatch)
            }
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = aut.getImage(frontier, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            if (frontImg.exists(aut.isAccept(_))) {
                val stopMatch = getState(CopyRest, noreachImg)
                builder.addTransition(ts, lbl, internal, stopMatch)
            } else if (!frontImg.isEmpty) {
              val contMatch = getState(Matching(frontImg), noreachImg)
              builder.addTransition(ts, lbl, nop, contMatch)
            }
          }
        }
        case CopyRest => {
          for (lbl <- labels) {
            val noreachImg = aut.getImage(noreach, lbl)
            val copyRest = getState(CopyRest, noreachImg)
            builder.addTransition(ts, lbl, copy, copyRest)
          }
        }
      }
    }

    val tran = builder.getTransducer
    tran
  }
}

/**
 * Representation of x = replace(y, tran, z) where tran is a
 * transducer that replaces part of the word to be replaced with
 * internalChar.  Build with companion object ReplacePreOpWord or
 * ReplacePreOpTran
 */
class ReplacePreOpTran(tran : Transducer) extends PreOp {

  override def toString = "replace-tran"

  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]] =
    for (s <- tran(arguments(0).map(_.toChar).mkString,
                   arguments(1).map(_.toChar).mkString))
    yield s.toSeq.map(_.toInt)

  override def lengthApproximation(arguments : Seq[Term], result : Term,
                                   order : TermOrder) : Formula =
    tran.lengthApproximation(arguments(0), arguments(1), result, order)

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val rc : AtomicStateAutomaton = resultConstraint match {
      case resCon : AtomicStateAutomaton => resCon
      case _ => throw new IllegalArgumentException("ReplacePreOp needs an AtomicStateAutomaton")
    }
    val zcons = argumentConstraints(1).map(_ match {
      case zcon : AtomicStateAutomaton => zcon
      case _ => throw new IllegalArgumentException("ReplacePreOp can only use AtomicStateAutomaton constraints.")
    })

    // x = replace(y, w, z) internally translated to
    // y' = tran(y); x = replace(y', w, z)
    //
    val cg = CaleyGraph[rc.type](rc, zcons)
    val res =
    for (box <- cg.getAcceptNodes.iterator;
         newYCon = PreImageAutomaton(tran, rc, box.getEdges)) yield {
      val newZCons = box.getEdges.map({ case (q1, q2) =>
        val fin = Set(q2).asInstanceOf[Set[AtomicStateAutomaton#State]]
        InitFinalAutomaton(rc, q1, fin)
      }).toSeq
      val newZCon = ProductAutomaton(newZCons)
      Seq(newYCon, newZCon)
    }

    (res, argumentConstraints)
  }

  override def forwardApprox(argumentConstraints : Seq[Seq[Automaton]]) : Automaton = {
    val yCons = argumentConstraints(0).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ReplacePreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val zCons = argumentConstraints(1).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ReplacePreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val yProd = ProductAutomaton(yCons)
    val zProd = ProductAutomaton(zCons)

    PostImageAutomaton(yProd, tran, Some(zProd))
  }
}


