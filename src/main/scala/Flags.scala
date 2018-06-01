/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
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

package strsolver

object Flags {

  // General options

  object Solver extends Enumeration {
    val afa_mc, preprop = Value
  }

  // order in which solvers should be tried
  val enabledSolvers : Seq[Solver.Value] = List(Solver.preprop)

  // AFA-Sloth specific options

  object ModelChecker extends Enumeration {
    val nuxmv, abc, simple = Value
  }

  var splitOptimization = false
  var minimalSuccessors = false
  var modelChecker= Set.empty[ModelChecker.Value]

  def isSplitOptimization: Boolean = splitOptimization
  def isMinimalSuccessors: Boolean = minimalSuccessors

  def isABC: Boolean =
    modelChecker(ModelChecker.abc)
  def isSimpleModelChecker: Boolean =
    modelChecker(ModelChecker.simple)
}
