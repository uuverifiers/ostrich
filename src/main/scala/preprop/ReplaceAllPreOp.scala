/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2018  Matthew Hague, Philipp Ruemmer
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

package strsolver.preprop

import ap.terfor.Term
import ap.terfor.preds.PredConj

import scala.collection.mutable.{HashMap => MHashMap, Stack => MStack}

object ReplaceAllPreOp {
  def apply(a : Char) : PreOp = new ReplaceAllPreOpChar(a)

  /**
   * preop for a replaceall(_, w, _) for whatever we get out of
   * PrepropSolver.
   */
  def apply(w : List[Either[Int,Term]]) : PreOp = {
    val charw = w.map(_ match {
      case Left(c) => c.toChar
      case _ =>
        throw new IllegalArgumentException("ReplaceAllPreOp only supports single character replacement.")
    })
    ReplaceAllPreOp(charw)
  }

  def apply(w : Seq[Char]) : PreOp = {
    if (w.size == 1) {
      new ReplaceAllPreOpChar(w(0))
    } else {
      ReplaceAllPreOpWord(w)
    }
  }

  def apply(s : String) : PreOp = ReplaceAllPreOp(s.toSeq)


  /**
   * PreOp for x = replaceall(y, e, z) for regex e
   */
  def apply(c : Term, context : PredConj) : PreOp =
    ReplaceAllPreOpRegEx(c, context)
}

/**
* Representation of x = replaceall(y, a, z) where a is a single
* character.
*/
class ReplaceAllPreOpChar(a : Char) extends PreOp {

  override def toString = "replaceall"

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton) : Iterator[Seq[Automaton]] = {
    val rc : AtomicStateAutomaton = resultConstraint match {
      case resCon : AtomicStateAutomaton => resCon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp needs an AtomicStateAutomaton")
    }
    val zcons = argumentConstraints(1).map(_ match {
      case zcon : AtomicStateAutomaton => zcon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp can only use AtomicStateAutomaton constraints.")
    })
    val cg = CaleyGraph[rc.type](rc)

    for (box <- cg.getAcceptNodes(zcons).iterator) yield {
      val newYCon = rc.replaceTransitions(a, box.getEdges)
      val newZCons =
        box.getEdges.map({ case (q1, q2) => rc.setInitAccept(q1, q2) }).toSeq
      val newZCon = AutomataUtils.product(newZCons)
      Seq(newYCon, newZCon)
    }
  }
}


/**
 * Companion object for ReplaceAllPreOpWord, does precomputation of
 * transducer representation of word
 */
object ReplaceAllPreOpWord {
  def apply(w : Seq[Char]) = {
    val wtran = buildWordTransducer(w)
    new ReplaceAllPreOpTran(wtran)
  }

  private def buildWordTransducer(w : Seq[Char]) : AtomicStateTransducer = {
    val builder = BricsTransducer.getBuilder

    val initState = builder.initialState
    val states = initState::(List.fill(w.size - 1)(builder.getNewState))
    val finstates = List.fill(w.size)(builder.getNewState)
    val delete = BricsOutputOp("", Delete, "")
    val internal = BricsOutputOp(Seq(builder.internalChar.toChar), Delete, "")
    val end = w.size - 1

    builder.setAccept(initState, true)
    finstates.foreach(builder.setAccept(_, true))

    // recognise word
    // deliberately miss last element
    for (i <- 0 until w.size - 1) {
      builder.addTransition(states(i), w(i), w(i), delete, states(i+1))
    }
    builder.addTransition(states(end), w(end), w(end), internal, states(0))

    for (i <- 0 until w.size) {
      val output = BricsOutputOp(w.slice(0, i), Plus(0), "")

      // begin again if mismatch
      if (w(i) > builder.minChar) {
        val below = (w(i) - 1).toChar
        builder.addTransition(states(i),
                              builder.minChar.toChar, below,
                              output,
                              states(0))
      }
      if (w(i) < builder.maxChar) {
        val above = (w(i) + 1).toChar
        builder.addTransition(states(i),
                              above, builder.maxChar.toChar,
                              output,
                              states(0))
      }

      // handle word ending in middle of match
      builder.addTransition(states(i), w(i), w(i), output, finstates(i))
    }

    builder.getTransducer
  }
}

/**
 * Companion class for building representation of x = replaceall(y, e,
 * z) for a regular expression e.
 */
object ReplaceAllPreOpRegEx {
  def apply(c : Term, context : PredConj) : PreOp = {
    val tran = buildTransducer(c, context)
    new ReplaceAllPreOpTran(tran)
  }

  /**
   * Builds transducer that identifies leftmost and longest match of
   * regex by rewriting matches to internalChar
   */
  private def buildTransducer(c : Term, context : PredConj) : AtomicStateTransducer = {
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier : Set[BricsTransducer#State]) extends Mode

    val aut = BricsAutomaton(c, context)
    val labels = aut.enumDisjointLabels
    val builder = BricsTransducer.getBuilder
    val delete = BricsOutputOp("", Delete, "")
    val copy = BricsOutputOp("", Plus(0), "")
    val internal = BricsOutputOp(Seq(builder.internalChar.toChar), Delete, "")

    // TODO: encapsulate this worklist automaton construction

    // states of transducer have current mode and a set of states that
    // should never reach a final state (if they do, a match has been
    // missed)
    val sMap = new MHashMap[BricsTransducer#State, (Mode, Set[aut.State])]
    val sMapRev = new MHashMap[(Mode, Set[aut.State]), BricsTransducer#State]

    val worklist = new MStack[BricsTransducer#State]

    def mapState(s : BricsTransducer#State, q : (Mode, Set[aut.State])) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    // creates and adds to worklist any new states if needed
    def getState(m : Mode, noreach : Set[aut.State]) : BricsTransducer#State = {
      sMapRev.getOrElse((m, noreach), {
        val s = builder.getNewState
        mapState(s, (m, noreach))
        val goodNoreach = !noreach.exists(aut.isAccept(_))
        s.setAccept(m match {
          case NotMatching => goodNoreach
          case Matching(_) => false
        })
        if (goodNoreach)
          worklist.push(s)
        s
      })
    }

    val autInit = aut.initialState
    val tranInit = builder.initialState

    mapState(tranInit, (NotMatching, Set.empty[aut.State]))
    worklist.push(tranInit)

    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      // TODO: take care of final states
      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = aut.getImage(autInit, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            val newMatch = getState(Matching(initImg), noreachImg)
            val dontMatch = getState(NotMatching, noreachImg ++ initImg)

            builder.addTransition(ts, lbl._1, lbl._2, delete, newMatch)
            builder.addTransition(ts, lbl._1, lbl._2, copy, dontMatch)
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = aut.getImage(frontier, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            val contMatch = getState(Matching(frontImg), noreachImg)
            val stopMatch = getState(NotMatching, noreachImg ++ frontImg)

            builder.addTransition(ts, lbl._1, lbl._2, delete, contMatch)
            builder.addTransition(ts, lbl._1, lbl._2, internal, stopMatch)
          }
        }
      }
    }

    builder.getTransducer
  }
}

/**
 * Representation of x = replaceall(y, tran, z) where tran is a
 * transducer that replaces parts of the word to be replaced with
 * internalChar.  Build with companion object ReplaceAllPreOpWord or
 * ReplaceAllPreOpTran
 */
class ReplaceAllPreOpTran(tran : AtomicStateTransducer) extends PreOp {

  override def toString = "replaceall"

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton) : Iterator[Seq[Automaton]] = {
    val rc : AtomicStateAutomaton = resultConstraint match {
      case resCon : AtomicStateAutomaton => resCon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp needs an AtomicStateAutomaton")
    }
    val zcons = argumentConstraints(1).map(_ match {
      case zcon : AtomicStateAutomaton => zcon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp can only use AtomicStateAutomaton constraints.")
    })

    // x = replaceall(y, w, z) internally translated to
    // y' = tran(y); x = replaceall(y', w, z)
    //
    val cg = CaleyGraph[rc.type](rc)
    for (box <- cg.getAcceptNodes(zcons).iterator) yield {
      val yprimeCons = rc.replaceTransitions(rc.internalChar.toChar, box.getEdges)
      val newYCon = tran.preImage(yprimeCons)
      val newZCons =
        box.getEdges.map({ case (q1, q2) => rc.setInitAccept(q1, q2) }).toSeq
      val newZCon = AutomataUtils.product(newZCons)
      Seq(newYCon, newZCon)
    }
  }
}


