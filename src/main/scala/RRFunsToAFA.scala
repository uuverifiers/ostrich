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

import ap.parser.IFunction
import ap.parser.IExpression.Predicate

import scala.collection.mutable


object RRFunsToAFA {
  def addFun2AFA(fun : IFunction, afa : AFA) : Unit =
    fun2AFA.put(fun, afa)

  def addRel2Fun(p : Predicate, fun : IFunction) : Unit =
    rel2Fun.put(p, fun)

  def get(r : Predicate) : Option[AFA] =
    for (f <- rel2Fun get r; afa <- fun2AFA get f) yield afa

  private val fun2AFA = new mutable.HashMap[IFunction, AFA]
  private val rel2Fun = new mutable.HashMap[Predicate, IFunction]
}
