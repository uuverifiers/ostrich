/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2018-2020  Matthew Hague, Philipp Ruemmer
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

import scala.collection.breakOut

object StreamingTransducerPreOp {
  def apply(t : StreamingTransducer) = new StreamingTransducerPreOp(t)
}

/**
* Representation of x = T(y)
*/
class StreamingTransducerPreOp(t : StreamingTransducer) extends PreOp {

  override def toString = "transducer"

  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]] = {
    assert (arguments.size == 1)
    val arg = arguments(0).map(_.toChar).mkString
    for (s <- t(arg)) yield s.toSeq.map(_.toInt)
  }

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val rc : BricsAutomaton = resultConstraint match {
      case resCon : BricsAutomaton => resCon
      case _ => throw new IllegalArgumentException("TransducerPreOp needs an BricsAutomaton")
    }
    (Iterator(Seq(t.preImage(rc))), List())
  }

}
