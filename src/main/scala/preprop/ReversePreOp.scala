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

/**
 * Pre-image computation for the reverse operator.
 */
object ReversePreOp extends PreOp {

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) =
    resultConstraint match {
      case resultConstraint : AtomicStateAutomaton =>
        // TODO: what should the second element be?
        (Iterator(Seq(ReverseAutomaton(resultConstraint))), List())

      case _ =>
        throw new IllegalArgumentException
    }

  // TODO: is this implemented correctly?
  def eval(arguments : Seq[Seq[Int]]) : Seq[Int] =
    arguments(0)

  override def toString = "reverse"

}
