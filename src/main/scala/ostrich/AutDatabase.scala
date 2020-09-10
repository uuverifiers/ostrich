/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2020  Philipp Ruemmer
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

import ap.parser._

import scala.collection.mutable.{HashMap => MHashMap}

/**
 * A database to store the automata or transducers obtained from
 * regular expressions. The database will assign a unique id to regular
 * expressions, and will compute the resulting automaton on demand.
 */
class AutDatabase(theory : OstrichStringTheory) {

  private val regex2Aut  = new Regex2Aut(theory)

  private val regexes    = new MHashMap[ITerm, Int]
  private val id2Regex   = new MHashMap[Int, ITerm]
  private val id2Aut     = new MHashMap[Int, Automaton]
  private val id2CompAut = new MHashMap[Int, Automaton]

  /**
   * Query the id of a regular expression.
   */
  def regex2Id(regexTerm : ITerm) : Int =
    synchronized {
      regexes.getOrElseUpdate(regexTerm, {
                                val id = regexes.size
                                id2Regex.put(id, regexTerm)
                                id })
    }

  /**
   * Query the id of a regular expression.
   */
  def id2Regex(id : Int) : Option[ITerm] =
    synchronized {
      id2Regex get id
    }

  /**
   * Query the automaton that belongs to the regular expression with given id.
   */
  def id2Automaton(id : Int) : Option[Automaton] =
    synchronized {
      (id2Aut get id) match {
        case r@Some(_) => r
        case None =>
          (id2Regex get id) match {
            case Some(regex) => {
              val aut = regex2Aut buildAut regex
              id2Aut.put(id, aut)
              Some(aut)
            }
            case None =>
              None
          }
      }
    }

  /**
   * Query the complemented automaton that belongs to the regular
   * expression with given id.
   */
  def id2ComplementedAutomaton(id : Int) : Option[Automaton] =
    synchronized {
      (id2CompAut get id) match {
        case r@Some(_) => r
        case None =>
          id2Automaton(id) match {
            case Some(aut) => {
              val compAut = !aut
              id2CompAut.put(id, compAut)
              Some(compAut)
            }
            case None =>
              None
          }
      }
    }

  /**
   * Query the automaton that belongs to a regular expression.
   */
  def regex2Automaton(regexTerm : ITerm) : Automaton =
    id2Automaton(regex2Id(regexTerm)).get

  /**
   * Query the complemented automaton that belongs to a regular expression.
   */
  def regex2ComplementedAutomaton(regexTerm : ITerm) : Automaton =
    id2ComplementedAutomaton(regex2Id(regexTerm)).get

}
