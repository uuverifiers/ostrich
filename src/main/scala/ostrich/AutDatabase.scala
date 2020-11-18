/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020 Philipp Ruemmer. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
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
