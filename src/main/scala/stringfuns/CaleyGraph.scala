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

package stringfuns

import dk.brics.automaton.{Automaton, State}
import scala.collection.mutable.{HashMap, Set, MultiMap}

/**
* Box in a Caley graph [w] = { (q,q') | q -- w --> q' }
*/
class Box(val arrows : MultiMap[State, State]) {

    def ++(that: Box) : Box = {
        val newMap = new HashMap[State, Set[State]] with MultiMap[State, State] 
        
        for ((q1, qs) <- arrows; q2 <- qs )
            if (that.arrows.isDefinedAt(q2))
                for (q3 <- that.arrows(q2))
                    newMap.addBinding(q1, q3)

        return new Box(newMap)
    }

    def apply(q : State) : Set[State] = arrows(q)

    override def toString : String = arrows.toString
}

class CaleyGraph {
    def getOne() : Integer = 1
}
