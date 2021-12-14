/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2021 Riccardo de Masellis, Philipp Ruemmer. All rights reserved.
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

import ostrich.automata.Regex2Aut

import ap.basetypes.IdealInt
import ap.parser.{IFunApp, IIntLit, ITerm, IExpression}
import ap.theories.strings.StringTheory
import ap.terfor.Term
import ap.terfor.linearcombination.LinearCombination

import scala.collection.mutable.{HashMap => MHashMap}

class StrDatabase(theory : OstrichStringTheory) {

  import theory.{str_empty, str_cons}
  import IExpression._

  private val id2StrMap = new MHashMap[Int, IFunApp]
  private val str2IdMap = new MHashMap[IFunApp, Int]
  private var idCnt     = 0

  /**
   * Check whether the given id belongs to a string.
   */
  def containsId(id : Int) : Boolean = synchronized {
    id2StrMap contains id
  }

  /**
   * Check whether the given term represents a concrete string.
   */
  def isConcrete(t : Term) : Boolean = t match {
    case LinearCombination.Constant(IdealInt(id)) =>
      containsId(id)
    case _ =>
      false
  }

  /**
   * Check whether the given term represents a concrete string, and return
   * the string.
   */
  def term2List(t : Term) : Option[List[Int]] = t match {
    case LinearCombination.Constant(IdealInt(id)) => Some(id2List(id))
    case _ => None
  }

  /**
   * Return the concrete string represented by the given term, throw
   * an exception if the term does not represent a concrete string.
   */
  def term2ListGet(t : Term) : List[Int] = term2List(t).get

  /**
   * Check whether the given term represents a concrete string, and return
   * the string.
   */
  def term2Str(t : Term) : Option[String] = t match {
    case LinearCombination.Constant(IdealInt(id)) => Some(id2Str(id))
    case _ => None
  }

  /**
   * Query the string for an id. If no string belongs to the id, an
   * exception is thrown.
   */
  def id2List(id : Int) : List[Int] = StringTheory.term2List(id2ITerm(id))

  /**
   * Query the string for an id. If no string belongs to the id, an
   * exception is thrown.
   */
  def id2Str(id : Int) : String =
    StringTheory term2String id2ITerm(id)

  /**
   * Query the string for an id. If no string belongs to the id, an
   * exception is thrown.
   */
  def id2ITerm(id : Int) : ITerm = synchronized {
    id2StrMap.get(id) match {
      case Some(t@IFunApp(`str_empty`, _)) =>
        t
      case Some(IFunApp(`str_cons`,
                        Seq(head, IIntLit(IdealInt(tail))))) =>
        str_cons(head, id2ITerm(tail))
      case None =>
        id2FreshITerm(id)
      case _ =>
        throw new RuntimeException("Riccardo, this should not happen!")
    }
  }

  /**
   * Retrieve the id of a string; add the string to the database if it
   * does not exist yet.
   */
  def iTerm2Id(str : ITerm) : Int = str match {
    case IIntLit(IdealInt(id)) =>
      id
    case str@IFunApp(`str_empty`, _) =>
      atomic2Id(str)
    case IFunApp(`str_cons`, Seq(Regex2Aut.SmartConst(head), tail)) =>
      atomic2Id(str_cons(head, iTerm2Id(tail)))
  }

  /**
   * Retrieve the id of a string in list representation; add the string to
   * the database if it does not exist yet.
   */
  def list2Id(str : Seq[Int]) : Int =
    str.foldRight(atomic2Id(str_empty())) {
      case (c, id) => atomic2Id(str_cons(c, id))
    }

  /**
   * Retrieve the id of a string in list representation; add the string to
   * the database if it does not exist yet.
   */
  def str2Id(str : String) : Int =
    str.foldRight(atomic2Id(str_empty())) {
      case (c, id) => atomic2Id(str_cons(c, id))
    }

  /**
   * Add a string to the database; this method only handles the case
   * of an empty string, or of a string that consists of a single
   * <code>str.cons</code>, and some id as tail.
   */
  private def atomic2Id(atomicStr : IFunApp) : Int = synchronized {
    str2IdMap.getOrElseUpdate(atomicStr,
                              {
                                val id = nextFreeId
                                id2StrMap.put(id, atomicStr)
                                id
                              })
  }

  /**
   * Determine the next free id for storing a string.
   */
  private def nextFreeId : Int = synchronized {
    val res = idCnt
    idCnt = idCnt + 1
    if (id2StrMap contains res)
      nextFreeId
    else
      res
  }

  /**
   * If the given id is not mapped to a string yet, find a fresh
   * string and add it to the database.
   */
  private def id2FreshITerm(id : Int) : ITerm = synchronized {
    val emptyStrId = atomic2Id(str_empty())

    if (id2StrMap contains id) {
      id2ITerm(id)
    } else {
      var c = 0

      while (str2IdMap contains str_cons(c, emptyStrId))
        c = c + 1

      str2IdMap.put(str_cons(c, emptyStrId), id)
      id2StrMap.put(id, str_cons(c, emptyStrId))

      str_cons(c, str_empty())
    }
  }

  /**
   * Extractor to recognise strings in different representations.
   */
  object EncodedString {
    def unapply(t : ITerm) : Option[String] =
      t match {
        case IIntLit(IdealInt(value)) =>
          Some(id2Str(value))
        case StringTheory.ConcreteString(str) =>
          Some(str)
        case _ =>
          None
      }
  }

}
