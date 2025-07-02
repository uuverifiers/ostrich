/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2025 Philipp Ruemmer. All rights reserved.
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

package ostrich.automata

import ap.basetypes.SetTrie
import ap.parser._

import ostrich.{OstrichStringTheory, OFlags}

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap, HashSet => MHashSet}

object AutDatabase {

  object NamedAutomaton {
    def apply(id : Int, complemented : Boolean) =
      if (complemented) ComplementedAut(id) else PositiveAut(id)
  }

  abstract sealed class NamedAutomaton (val id : Int) {
    def complement : NamedAutomaton
  }

  case class PositiveAut    (_id : Int) extends NamedAutomaton (_id) {
    def complement = ComplementedAut(id)
  }

  case class ComplementedAut(_id : Int) extends NamedAutomaton (_id) {
    def complement = PositiveAut(id)
  }

}

/**
 * A database to store the automata or transducers obtained from
 * regular expressions. The database will assign a unique id to regular
 * expressions, and will compute the resulting automaton on demand.
 */
class AutDatabase(theory : OstrichStringTheory,
                  minimizeAutomata : Boolean) {

  import AutDatabase._
  import IExpression.toFunApplier // for e.g. re_* to become applicable
  import theory.{re_*, re_allchar}

  protected val regex2Aut  = new Regex2Aut(theory)

  private var nextId       = 0

  /**
   * Map from regular expressions to ids. Ids are assigned based on the
   * languages, two distinct regular expressions describing the same
   * language will be assigned the same id.
   */
  private val regexes      = new MHashMap[ITerm, Int]

  /**
   * Map from ids to the corresponding regular expression. Not every id
   * present in the database has to correspond to a regular expression,
   * since we internally create new automata without ever going through
   * regular expressions.
   */
  private val id2Regex     = new MHashMap[Int, ITerm]

  /**
   * Map from ids to the corresponding automaton. The key set of this map
   * is guaranteed to be a superset of the key set of the
   * <code>regexes</code> map. Distinct ids are guaranteed to be mapped to
   * automata describing distinct languages. 
   */
  private val id2Aut       = new MHashMap[Int, Automaton]

  /**
   * Map from ids to the ids of the complement automata. This map is populated
   * lazily and will typically only cover a subset of the ids present in the
   * <code>id2Aut</code> map.
   */
  private val id2CompAut   = new MHashMap[Int, Int]

  /**
   * Tree data-structure to map automata to IDs.
   */
  private val autTree      = new AutomatonTree

  /**
   * Combinations of automata with non-empty intersection.
   */
  private val nonEmptyIntersections = new SetTrie[Int]

  /**
   * Combinations of automata with empty intersection.
   */
  private val emptyIntersections    = new SetTrie[Int]

  lazy val emptyLangAut : Automaton = BricsAutomaton.makeEmptyLang()
  lazy val emptyLangId : Int        = automaton2Id(emptyLangAut)

  lazy val anyStringAut : Automaton = BricsAutomaton.makeAnyString()
  lazy val anyStringId : Int        = automaton2Id(anyStringAut)

  synchronized {
    id2CompAut.put(anyStringId, emptyLangId)
    id2CompAut.put(emptyLangId, anyStringId)
    nonEmptyIntersections += Set(anyStringId)
    emptyIntersections    += Set(emptyLangId)
  }

  /**
   * Query the id of a regular expression.
   */
  def regex2Id(regexTerm : ITerm) : Int =
    synchronized {
      regexes.get(regexTerm) match {
        case None     => addRegex(regexTerm)
        case Some(id) => id
      }
    }

  /**
   * Add a regex that is not yet in the <code>regex2Id</code> map.
   * This will check whether we already know the language represented by
   * the regex, and in this case assign the same id.
   */
  private def addRegex(regexTerm : ITerm) : Int =
    synchronized {
      require(!regexes.contains(regexTerm))
      val aut = regex2Aut.buildAut(regexTerm, minimizeAutomata)
      val id = automaton2Id(aut)
      regexes.put(regexTerm, id)
      id2Regex.getOrElseUpdate(id, regexTerm)
      id
    }

  /**
   * Add an automaton to the database. If the database already contains
   * an equivalent automaton, the old id will be returned, ensuring
   * that distinct ids always map to automata representing distinct languages.
   */
  def automaton2Id(aut : Automaton) : Int =
    synchronized {
      val id = autTree.insert(aut, nextId)
      if (id == nextId) {
        if (OFlags.debug)
          Console.err.println(f"Adding new automaton with id $id to database")
        nextId = nextId + 1
        id2Aut.put(id, aut)
      }
      id
    }

  /**
   * Convert a regular expression to an automaton, adding both
   * the expression and the automaton to the database as a side effect.
   */
  def regex2Automaton(regexTerm : ITerm) : Automaton =
    id2Automaton(regex2Id(regexTerm)).get

  /**
   * Convert the complement of a regular expression to an automaton, adding
   * the (non-complemented) expression, the automaton, and the complemented
   * automaton to the database as a side effect.
   */
  def regex2ComplementedAutomaton(regexTerm : ITerm) : Automaton =
    id2ComplementedAutomaton(regex2Id(regexTerm)).get

  /**
   * Retrieve the regular expression for a given id.
   * If no regular expression is stored for the given id,
   * <code>None</code> is returned.
   */
  def id2Regex(id : Int) : Option[ITerm] =
    synchronized { id2Regex get id }

  /**
   * Retrieve the automaton for a given id. If no automaton is stored for the
   * given id, <code>None</code> is returned.
   */
  def id2Automaton(id : Int) : Option[Automaton] =
    synchronized { id2Aut get id }

  /**
   * Retrieve the complemented automaton that belongs to the automaton
   * with the given id. If the database does not contain any automaton with
   * this id, <code>None</code> is returned. As a side effect, this method
   * might compute the complement of the automaton with the given id.
   */
  def id2ComplementedAutomaton(id : Int) : Option[Automaton] =
    synchronized {
      id2ComplementedId(id).flatMap(id2Automaton)
    }

  /**
   * Query the id of the complemented automaton for the automaton with given
   * id. If the database does not contain any automaton with this id,
   * <code>None</code> is returned. As a side effect, this method might compute
   * the complement of the automaton with the given id.
   */
  def id2ComplementedId(id : Int) : Option[Int] =
    synchronized {
      (id2CompAut get id) match {
        case r@Some(_) => r
        case None =>
          id2Automaton(id) match {
            case Some(aut) => {
              val compId = automaton2Id(!aut)
              id2CompAut.put(id, compId)
              id2CompAut.put(compId, id)
              Some(compId)
            }
            case None =>
              None
          }
      }
    }

  /**
   * Query the complemented automaton that belongs to the automaton with given
   * id; return the automaton only if it is already available in the database.
   */
  def id2ComplementedAutomatonBE(id : Int) : Option[Automaton] =
    synchronized {
      for (compId <- id2CompAut get id; aut <- id2Automaton(compId)) yield aut
    }

  /**
   * Convert a named automaton to an id. If necessary, this will
   * add the complemented automaton to the database. The method will fail
   * with an exception if the name of an automaton is given that does not
   * exist.
   */
  def namedAutToId(n : NamedAutomaton) : Int =
    n match {
      case PositiveAut(id)     => id
      case ComplementedAut(id) => id2ComplementedId(id).get
    }

  /**
   * Convert a named automaton to an id. If complementation is required,
   * and the resulting automata have not been computed yet, or if 
   * the specified automaton does not exist, the method will return
   * <code>None</code>.
   */
  def namedAutToIdBE(n : NamedAutomaton) : Option[Int] =
    n match {
      case PositiveAut(id)     => Some(id)
      case ComplementedAut(id) => synchronized { id2CompAut get id }
    }

  /**
   * Query the automaton that belongs to the regular expression with
   * given id. If the database does not contain any automaton with this id,
   * <code>None</code> is returned.
   */
  def id2Automaton(id : NamedAutomaton) : Option[Automaton] = id match {
    case PositiveAut(id)     => id2Automaton(id)
    case ComplementedAut(id) => id2ComplementedAutomaton(id)
  }

  /**
   * Query the automaton that belongs to the given id;
   * return a complemented automaton only if it is already in the database.
   * If the database does not contain any automaton with this id,
   * <code>None</code> is returned as well.
   */
  def id2AutomatonBE(id : NamedAutomaton) : Option[Automaton] = id match {
    case PositiveAut(id)     => id2Automaton(id)
    case ComplementedAut(id) => id2ComplementedAutomatonBE(id)
  }

  /**
   * Check whether <code>aut1</code> specifies a subset of <code>aut2</code>.
   * If no automata with the given names exist in the database, the method
   * will fail with an exception.
   */
  def isSubsetOf(aut1 : NamedAutomaton, aut2 : NamedAutomaton) : Boolean =
    // aut1 <= aut2
    //  <==>
    // (aut1 & aut2.complement) = empty
    emptyIntersection(aut1, aut2.complement)

  /**
   * Check whether <code>aut1</code> specifies a subset of <code>aut2</code>;
   * the check is only carried out when all required automata are already in
   * the database and no additional complementation steps are necessary.
   */
  def isSubsetOfBE(aut1 : NamedAutomaton,
                   aut2 : NamedAutomaton) : Option[Boolean] =
    for (id1 <- namedAutToIdBE(aut1);
         id2 <- namedAutToIdBE(aut2.complement))
    yield emptyIntersection(Set(id1, id2))

  /**
   * Check whether <code>aut1</code> and <code>aut2</code> have empty
   * intersection.
   * If no automata with the given names exist in the database, the method
   * will fail with an exception.
   */
  def emptyIntersection(aut1 : NamedAutomaton,
                        aut2 : NamedAutomaton) : Boolean =
    emptyIntersection(Set(namedAutToId(aut1), namedAutToId(aut2)))

  /**
   * Check whether the automata with the given ids have empty intersection.
   * If no automata with the given ids exist in the database, the method
   * will fail with an exception.
   * 
   * TODO: move the expensive step out of the synchronized block?
   */
  def emptyIntersection(ids : Set[Int]) : Boolean =
    synchronized {
      if (nonEmptyIntersections.containsSuperset(ids)) {
        false
      } else if (emptyIntersections.containsSubset(ids)) {
        true
      } else {
        val auts = ids.toSeq.sorted.map(id => id2Automaton(id).get)
        if (AutomataUtils.areConsistentAutomata(auts)) {
          nonEmptyIntersections += ids
//          printSMTLIB(ids, true)
          false
        } else {
          emptyIntersections += ids
//          printSMTLIB(ids, false)
          true
        }
      }
    }

/*
  private var fileCnt : Int = 0

  private def printSMTLIB(ids : Set[Int], expectedSat : Boolean) : Unit = {
    val smtlibFile =
      new java.io.FileOutputStream(f"automaton-intersection-${fileCnt}.smt2")
    fileCnt = fileCnt + 1
    Console.withOut(smtlibFile) {
      println("(set-logic QF_S)")
      println(s"(set-info :status ${if (expectedSat) "sat" else "unsat"})")
      println("(declare-const w String)")
      for (id <- ids.toList.sorted)
        println("(assert (str.in_re w (re.from_automaton \"" +
                  ostrich.AutomatonParser.toString(
                    id2Automaton(id).get.asInstanceOf[AtomicStateAutomaton]) +
                  "\")))")
      println("(check-sat)")
    }
    smtlibFile.close
  }
*/

}
