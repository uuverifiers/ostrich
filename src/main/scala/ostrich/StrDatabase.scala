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

  /**
   * Check whether the given term represents a concrete string.
   */
  def isConcrete(t : Term) : Boolean = t match {
    case LinearCombination.Constant(IdealInt(id)) => synchronized {
      id2StrMap contains id
    }
    case _ =>
      false
  }

  /**
   * Check whether the given term represents a concrete string.
   */
  def term2Str(t : Term) : Option[List[Int]] = t match {
    case LinearCombination.Constant(IdealInt(id)) => Some(id2Str(id))
    case _ => None
  }

  /**
   * Query the string for an id. If no string belongs to the id, an
   * exception is thrown.
   */
  def id2Str(id : Int) : List[Int] = StringTheory.term2List(id2StrTerm(id))

  /**
   * Query the string for an id. If no string belongs to the id, an
   * exception is thrown.
   */
  def id2StrTerm(id : Int) : ITerm = synchronized {
    id2StrMap.get(id) match {
      case Some(t@IFunApp(`str_empty`, _)) =>
        t
      case Some(IFunApp(`str_cons`,
                        Seq(head, IIntLit(IdealInt(tail))))) =>
        str_cons(head, id2StrTerm(tail))
      case _ =>
        throw new RuntimeException("Riccardo, this should not happen!")
    }
  }

  def listInt2String(list : List[Int]) : String =
    (for (c <- list) yield c.toChar).mkString

  /**
   * Query a string for an id (it adds str to database if not already present)
   */
  def str2Id(str : ITerm) : Int = str match {
    case IIntLit(IdealInt(id)) =>
      id
    case str@IFunApp(`str_empty`, _) =>
      atomic2Id(str)
    case IFunApp(`str_cons`, Seq(Regex2Aut.SmartConst(head), tail)) =>
      atomic2Id(str_cons(head, str2Id(tail)))
  }

  /**
   * Add a string to the database; this method only handles the case
   * of an empty string, or of a string that consists of a single
   * <code>str.cons</code>, and some id as tail.
   */
  private def atomic2Id(atomicStr : IFunApp) : Int = synchronized {
    str2IdMap.getOrElseUpdate(atomicStr,
                              {
                                val id = str2IdMap.size
                                id2StrMap.put(id, atomicStr)
                                id
                              })
  }
}
