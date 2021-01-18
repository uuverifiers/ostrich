/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2021 Riccardo de Masellis. All rights reserved.
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
import ap.parser.{IFunApp, IIntLit}

import scala.collection.mutable.{HashMap => MHashMap}

class StrDatabase(theory : OstrichStringTheory) {

  private val id2StrMap = new MHashMap[Int, (IFunApp, Option[Int])]
  private val str2IdMap = new MHashMap[IFunApp, Int]


  /** Query the id for a concrete string */
  def id2Str(id : Int) : List[Int] = {
    id2StrMap.get(id) match {
      case Some((IFunApp(this.theory.str_empty, _), None)) => Nil

      //OLD, but working
      case Some((funApp, Some(nextId))) => funApp(2).asInstanceOf[IIntLit].value.intValueSafe :: id2Str(nextId)
      //NEW with improved pattern matching:
      //case Some((IFunApp(this.theory.str_cons, Seq(_, _, IIntLit(IdealInt(i)))), Some(nextId))) => i.intValue() :: id2Str(nextId)
      case _ => throw new RuntimeException("Riccardo, this should not happen!")
    }
  }

  def listInt2String(list : List[Int]) : String =
    (for (c <- list) yield c.toChar).mkString

  /** Query a string for an id (it adds str to database if not already present) */
  def str2Id(str : IFunApp) : Int = synchronized {
    str2IdMap getOrElseUpdate(str, {
      val id = str2IdMap.size
      str2IdMap.put(str, id)

      str match {
        case IFunApp(this.theory.str_empty, _) => {
          id2StrMap put(id, (str, None))
          return id
        }

        case IFunApp(this.theory.str_cons, _) => {
          val strHead = str.args(0).asInstanceOf[IFunApp]
          val strTail = str.args(1).asInstanceOf[IFunApp]
          str2IdMap get strTail match {
            case None => throw new RuntimeException("Riccardo, this should not happen!")
            case Some(s) => id2StrMap put (id, (strHead, Some(s)))
          }
          return id
        }
      }
    })
  }

}
