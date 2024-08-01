/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2024 Philipp Ruemmer. All rights reserved.
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

import ostrich.{OstrichStringTheory, OFlags}
import ap.parser._

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap, HashSet => MHashSet}

class SuffixTrieNode {
  var children: Map[Int, SuffixTrieNode] = Map()
  var isEndOfSet: Boolean = false

  def insert(set: Seq[Int]): Unit = {
    var currentNode = this
    for (elem <- set) {
      if (!currentNode.children.contains(elem)) {
        currentNode.children += (elem -> new SuffixTrieNode)
      }
      currentNode = currentNode.children(elem)
    }
    currentNode.isEndOfSet = true
  }


  def contains(set: Seq[Int]): Boolean = {
    var currentNode = this
    for (elem <- set) {
      if (currentNode.isEndOfSet) {
        return true
      }
      if (!currentNode.children.contains(elem)) {
        return false
      }
      currentNode = currentNode.children(elem)
    }
    currentNode.isEndOfSet
  }

}

class SuffixTrie {
  private val root = new SuffixTrieNode

  def insert(set: Seq[Int]): Unit = {
    root.insert(set)
  }

  def contains(set: Seq[Int]): Boolean = {
    root.contains(set)
  }

}

class TrieNode {
  var children: Map[Int, TrieNode] = Map()

  def insert(set: Seq[Int]): Unit = {
    var currentNode = this
    for (elem <- set) {
      if (!currentNode.children.contains(elem)) {
        currentNode.children += (elem -> new TrieNode)
      }
      currentNode = currentNode.children(elem)
    }
  }


  def contains(set: Seq[Int]): Boolean = {
    var currentNode = this
    for (elem <- set) {
      if (!currentNode.children.contains(elem)) {
        return false
      }
      currentNode = currentNode.children(elem)
    }
    true
  }

}

class SetTrie {
  private val root = new TrieNode

  def insert(set: Seq[Int]): Unit = {
    root.insert(set)
  }

  def contains(set: Seq[Int]): Boolean = {
    root.contains(set)
  }

}

object AutDatabase {

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

  private val subsetRel  =
    new MHashMap[(NamedAutomaton, NamedAutomaton), Boolean]

  private val prefixSortedIntersectionTree = new SetTrie
  private val knownConflicts = new SuffixTrie

  val emptyLangAut : Automaton = BricsAutomaton.makeEmptyLang()
  val emptyLangId : Int        = automaton2Id(emptyLangAut)

  val anyStringAut : Automaton = BricsAutomaton.makeAnyString()
  val anyStringId : Int        = automaton2Id(anyStringAut)

  synchronized {
    id2CompAut.put(anyStringId, emptyLangId)
    id2CompAut.put(emptyLangId, anyStringId)
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
   * Add a new automaton to the database.
   */
  def automaton2Id(aut : Automaton) : Int =
    synchronized {
      println("checking ...")
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
   * Query the id of a regular expression.
   */
  def id2Regex(id : Int) : Option[ITerm] =
    synchronized { id2Regex get id }

  /**
   * Query the automaton that belongs to the regular expression with given id.
   */
  def id2Automaton(id : Int) : Option[Automaton] =
    synchronized { id2Aut get id }

  /**
   * Query the complemented automaton that belongs to the regular
   * expression with given id.
   */
  def id2ComplementedAutomaton(id : Int) : Option[Automaton] =
    synchronized {
      id2ComplementedId(id).flatMap(id2Automaton)
    }

  /**
   * Query the id of the complemented automaton for the automaton with given
   * id.
   */
  def id2ComplementedId(id : Int) : Option[Int] =
    synchronized {
      (id2CompAut get id) match {
        case r@Some(_) => r
        case None =>
          id2Automaton(id) match {
            case Some(aut) => {
              val compAut = automaton2Id(!aut)
              id2CompAut.put(id, compAut)
              Some(compAut)
            }
            case None =>
              None
          }
      }
    }

  /**
   * Query the complemented automaton that belongs to the regular
   * expression with given id;
   * return the automaton only if it is already in the database.
   */
  def id2ComplementedAutomatonBE(id : Int) : Option[Automaton] =
    synchronized {
      for (compId <- id2CompAut get id;
           aut <- id2Automaton(compId))
      yield aut
    }

  /**
   * Query the automaton that belongs to the regular expression with
   * given id.
   */
  def id2Automaton(id : NamedAutomaton) : Option[Automaton] = id match {
    case PositiveAut(id)     => id2Automaton(id)
    case ComplementedAut(id) => id2ComplementedAutomaton(id)
  }

  /**
   * Query the automaton that belongs to the given id;
   * return a complemented automaton only if it is already in the database.
   */
  def id2AutomatonBE(id : NamedAutomaton) : Option[Automaton] = id match {
    case PositiveAut(id)     => id2Automaton(id)
    case ComplementedAut(id) => id2ComplementedAutomatonBE(id)
  }

  /**
   * Check whether <code>aut1</code> specifies a subset of <code>aut2</code>.
   */
  def isSubsetOf(aut1 : NamedAutomaton, aut2 : NamedAutomaton) : Boolean =
    if (aut1.id < aut2.id) {
      synchronized {
        // aut1 <= aut2
        //  <==>
        // (aut1 & aut2.complement) = empty
        subsetRel.getOrElseUpdate((aut1, aut2),
                                  !AutomataUtils.areConsistentAutomata(
                                    List(id2Automaton(aut1).get,
                                         id2Automaton(aut2.complement).get)))
      }
    } else if (aut1.id > aut2.id) {
      isSubsetOf(aut2.complement, aut1.complement)
    } else {
      true
    }

  /**
   * Check whether <code>aut1</code> specifies a subset of <code>aut2</code>;
   * the check is only carried out when all required automata are already in
   * the database.
   */
  def isSubsetOfBE(aut1 : NamedAutomaton,
                   aut2 : NamedAutomaton) : Option[Boolean] =
    if (aut1.id < aut2.id) {
      synchronized {
        // aut1 <= aut2
        //  <==>
        // (aut1 & aut2.complement) = empty
        for (a1 <- id2AutomatonBE(aut1);
             a2 <- id2AutomatonBE(aut2.complement)) yield
          subsetRel.getOrElseUpdate((aut1, aut2),
                                    !AutomataUtils.areConsistentAutomata(
                                      List(a1, a2)))
      }
    } else if (aut1.id > aut2.id) {
      isSubsetOfBE(aut2.complement, aut1.complement)
    } else {
      Some(true)
    }

  /**
   * Check whether <code>aut1</code> and <code>aut2</code> have empty
   * intersection.
   */
  def emptyIntersection(aut1 : NamedAutomaton,
                        aut2 : NamedAutomaton) : Boolean =
  {
    val tmp = isSubsetOf(aut1, aut2.complement)
    synchronized {
      if (tmp) {
        knownConflicts.insert(Seq(aut1.id, aut2.id).sorted)
      }
      tmp
    }
  }

  def emptyIntersection(auts : ArrayBuffer[NamedAutomaton]) : Boolean =
  {
    synchronized {
      val autIds = new ArrayBuffer[Int]
      val autValues = new ArrayBuffer[Automaton]
      for (aut <- auts){
        autIds += aut.id
        autValues += id2Automaton(aut).get
      }
      autIds.sorted
      if (knownConflicts.contains(autIds)){
        return true
      }
      if (prefixSortedIntersectionTree.contains(autIds)){
        return false
      }

      if (AutomataUtils.areConsistentAutomata(autValues)){
        prefixSortedIntersectionTree.insert(autIds)
        false
      }
      else {
        knownConflicts.insert(autIds)
        true
      }
    }
  }

}
