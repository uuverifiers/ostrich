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
  def apply(a : Char) = new ReplaceAllPreOp(a)

  /**
   * preop for a replaceall(_, w, _) for whatever we get out of
   * PrepropSolver.
   */
  def apply(w : List[Either[Int,Term]]) =
    if (w.length == 1) {
      w(0) match {
        case Left(c) => {
          new ReplaceAllPreOp(c.toChar)
        }
        case _ =>
          throw new IllegalArgumentException("ReplaceAllPreOp only supports single character replacement.")
      }
    } else {
      throw new IllegalArgumentException("ReplaceAllPreOp only supports single character replacement")
    }
}

/**
* Representation of x = replaceall(y, a, z) where a is a single
* character.
*/
class ReplaceAllPreOp(a : Char) extends PreOp {

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
