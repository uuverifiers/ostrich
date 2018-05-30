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
 * Interface for back-propagating regex constraints over n-ary functions f.
 */
trait PreOp {

  /**
   * Given known regex constraints for function arguments and function result,
   * derive a sequence of regex constraints for the arguments such that
   * <ul>
   * <li>returned constraints are contained in the pre-image:
   *     any word tuple accepted by any of the returned automata tuples
   *     is mapped by the function to a word accepted by the
   *     result constraint</li>
   * <li>returned constraints subsume the pre-image intersected with the
   *     existing argument constraints: whenever a word tuple is accepted
   *     by the given argument constraints, and is mapped by the function
   *     to a word accepted by the result constraint, then the word tuple
   *     is also accepted by one of the returned constraints</li>
   * </ul>
   */
  def apply(argumentConstraints : Seq[Automaton],
            resultConstraint : Automaton)
          : Iterator[Seq[Automaton]]

}