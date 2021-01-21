/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2021 Philipp Ruemmer. All rights reserved.
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

import ap.util.Seqs

import scala.io.Source
import scala.collection.immutable.VectorBuilder

object UnicodeData {

  val filename = "ostrich/UnicodeData.txt"

  /**
   * Inclusive intervals
   */
  type Interval = (Int, Int)

  lazy val characterLines : IndexedSeq[String] = {
    val source =
      Source.fromInputStream(
        getClass.getClassLoader.getResourceAsStream(filename))
    val res = source.getLines.toVector
    source.close
    res
  }

  /**
   * The mapping between lower-case and upper-case characters. Each of the
   * entries specifies a block of characters, and the shift to reach the
   * corresponding upper-/lower-case characters. Blocks are non-overlapping
   * and listed in ascending order.
   */
  lazy val upperLowerCaseShifts : IndexedSeq[(Interval, Int)] = {
    val result = new VectorBuilder[(Interval, Int)]

    var curBegin = -1
    var curEnd   = -1
    var curShift : Option[Int] = None

    for (str <- characterLines) {
      val fields = str split ";"

      val code = Integer.parseInt(fields(0), 16)
      val newShift =
        if (fields.size > 13 && fields(13) != "")
          Some(Integer.parseInt(fields(13), 16) - code)
        else if (fields.size > 14 && fields(14) != "")
          Some(Integer.parseInt(fields(14), 16) - code)
        else
          None

      if (newShift != curShift) {
        for (shift <- curShift)
          result += (((curBegin, curEnd), shift))

        curBegin = code
        curShift = newShift
      }

      curEnd = code
    }

    for (shift <- curShift)
      result += (((curBegin, curEnd), shift))

    result.result
  }

  /**
   * Add to a block of characters all the corresponding upper-/lower-case
   * characters.
   */
  def upperLowerCaseClosure(interval : Interval) : Seq[Interval] = {
    val shifts = upperLowerCaseShifts

    val (beg, end) = interval
    val result = new VectorBuilder[Interval]
    result += interval

    val startInd =
      Seqs.risingEdge[(Interval, Int)](shifts, {
                                         case ((_, u), _) => u >= beg
                                       })

    var ind = startInd
    while (shifts(ind)._1._1 <= end) {
      val ((l, u), shift) = shifts(ind)
      val (sl, su) = ((l max beg) + shift, (u min end) + shift)
      if (sl < beg || su > end)
        result += ((sl, su))
      ind = ind + 1
    }

    result.result
  }

}
