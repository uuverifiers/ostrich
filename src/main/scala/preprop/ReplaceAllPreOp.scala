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

object ReplaceAllPreOp {
  def apply(a : Char) = new ReplaceAllPreOpChar(a)

  /**
   * preop for a replaceall(_, w, _) for whatever we get out of
   * PrepropSolver.
   */
  def apply(w : List[Either[Int,Term]]) = {
    val charw = w.map(_ match {
      case Left(c) => c.toChar
      case _ =>
        throw new IllegalArgumentException("ReplaceAllPreOp only supports single character replacement.")
    })

    if (charw.length == 1) {
      new ReplaceAllPreOpChar(charw(0))
    } else {
      ReplaceAllPreOpWord(charw)
    }
  }
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
      val newYCons = Seq(rc.replaceTransitions(a, box.getEdges))
      val newZCons =
        box.getEdges.map({ case (q1, q2) => rc.setInitAccept(q1, q2) }).toSeq
      newYCons ++ newZCons
    }
  }
}


/**
 * Companion object for ReplaceAllPreOpWord, does precomputation of
 * transducer representation of word
 */
object ReplaceAllPreOpWord {
  def apply(w : List[Char]) = {
    val wtran = buildWordTransducer(w)
    new ReplaceAllPreOpWord(wtran)
  }

  def buildWordTransducer(w : List[Char]) : Transducer = {
    val builder = BricsTransducer.getBuilder

    val initState = builder.initialState
    val states = initState::(List.fill(w.size - 1)(builder.getNewState))
    val delete = BricsOutputOp("", Delete, "")
    val internal = BricsOutputOp(Seq(builder.internalChar.toChar), Delete, "")
    val end = w.size - 1

    states.foreach(builder.setAccept(_, true))

    // recognise word
    // deliberately miss last element
    for (i <- 0 until w.size - 1) {
      builder.addTransition(states(i), w(i), w(i), delete, states(i+1))
    }
    builder.addTransition(states(end), w(end), w(end), internal, states(0))

    // begin again if mismatch
    for (i <- 0 until w.size) {
      val output = BricsOutputOp(w.slice(0, i), Plus(0), "")
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
    }

    builder.getTransducer
  }
}

/**
 * Representation of x = replaceall(y, w, z) where w is a fixed word.
 * wtran is the transducer that identifies w and replaces it with
 * internalChar.  Build with companion object that takes a plain word
 */
class ReplaceAllPreOpWord(wtran : Transducer) extends PreOp {

  override def toString = "replaceall"

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton) : Iterator[Seq[Automaton]] = {
//    val rc : AtomicStateAutomaton = resultConstraint match {
//      case resCon : AtomicStateAutomaton => resCon
//      case _ => throw new IllegalArgumentException("ReplaceAllPreOp needs an AtomicStateAutomaton")
//    }
//    val zcons = argumentConstraints(1).map(_ match {
//      case zcon : AtomicStateAutomaton => zcon
//      case _ => throw new IllegalArgumentException("ReplaceAllPreOp can only use AtomicStateAutomaton constraints.")
//    })
//    val cg = CaleyGraph[rc.type](rc)
//
//    for (box <- cg.getAcceptNodes(zcons).iterator) yield {
//      val newYCons = Seq(rc.replaceTransitions(a, box.getEdges))
//      val newZCons =
//        box.getEdges.map({ case (q1, q2) => rc.setInitAccept(q1, q2) }).toSeq
//      newYCons ++ newZCons
//    }
    List().iterator
  }
}
