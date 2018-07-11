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

package strsolver

/**
 * Convenience object to store user functions -- these are loaded by
 * UserFunctionRegistry
 */
object UserFunctions {
  /**
   * List of functions in the format
   *
   *   (<name> , <arity>, <PreOp object>)
   */
  val functions = List(
    ("user_reverse", 1, strsolver.preprop.ReversePreOp)
  )
}
