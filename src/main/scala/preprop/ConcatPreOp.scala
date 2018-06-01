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

import scala.collection.JavaConversions.{asScalaIterator,
                                         iterableAsScalaIterable}

/**
 * Pre-image computation for the concatenation operator.
 */
object ConcatPreOp extends PreOp {

  /**
   * At the moment this implementation is BricsAutomaton-specific; it is
   * not really clear how a generic Automaton interface enabling this
   * kind of computation should look like.
   */
  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : Iterator[Seq[Automaton]] = resultConstraint match {

    case resultConstraint : BricsAutomaton =>
      // TODO: probably this won't process the states in deterministic order
      for (s <- resultConstraint.underlying.getStates.iterator) yield {
        val (aAut, aMap) = resultConstraint.cloneWithStateMap
        val (bAut, bMap) = resultConstraint.cloneWithStateMap

        val aMappedS = aMap(s)

        for (t <- aAut.underlying.getStates)
          t.setAccept(t == aMappedS)

        aAut.underlying.restoreInvariant

        bAut.underlying setInitialState bMap(s)
        bAut.underlying.restoreInvariant

        List(aAut, bAut)
      }

    case _ =>
      throw new IllegalArgumentException
  }

  override def toString = "concat"

}
