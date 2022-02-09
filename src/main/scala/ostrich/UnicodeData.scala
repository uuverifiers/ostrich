/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2021-2022 Philipp Ruemmer. All rights reserved.
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
import scala.collection.mutable.{HashMap => MHashMap, ArrayBuffer}

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

  /**
   * Unicode properties of the general category. For each general
   * category property value, the map specifies the intervals of
   * characters belonging to the category.
   */
  lazy val generalProperties : Map[String, Seq[Interval]] = {
    var lastCat      = ""
    var lastCatStart = -1
    val categories   = new MHashMap[String, ArrayBuffer[Interval]]

    for (str <- characterLines) {
      val fields = str split ";"
      val code   = Integer.parseInt(fields(0), 16)
      val cat    = fields(2)

      if (cat != lastCat) {
        if (lastCatStart >= 0) {
          val intervals = categories.getOrElseUpdate(lastCat, new ArrayBuffer)
          intervals += ((lastCatStart, code - 1))
        }
        lastCat      = cat
        lastCatStart = code
      }
    }

    if (lastCatStart >= 0) {
      val intervals = categories.getOrElseUpdate(lastCat, new ArrayBuffer)
      intervals += ((lastCatStart, 0x10FFFF))
    }

    val categoriesSeq = categories.toVector.sortBy(_._1)

    // Add the single-letter categories by joining the categories from
    // the database
    for ((cat, seq) <- categoriesSeq) {
      assert(cat.size == 2)
      val prefix = cat.substring(0, 1)
      val intervals = categories.getOrElseUpdate(prefix, new ArrayBuffer)
      intervals ++= seq
    }

    // Special case: LC is the union of Lu, Ll, Lt
    {
      val intervals = categories.getOrElseUpdate("LC", new ArrayBuffer)
      intervals ++= categories("Lu")
      intervals ++= categories("Ll")
      intervals ++= categories("Lt")
    }

    (for ((cat, s) <- categories.iterator)
     yield (cat.toLowerCase, s.toSeq)).toMap
  }

  /**
   * Map a property of the general category to the standard name.
   */
  def normalizeGeneralProperty(name : String) : String =
    if (name.size <= 2) {
      name.toLowerCase
    } else {
      val norm = normalize(name)
      longCategoryNames.getOrElse(norm, norm)
    }

  private val longCategoryNamesRaw = Map(
    "Letter" -> "L",
    "Lowercase_Letter" -> "Ll",
    "Uppercase_Letter" -> "Lu",
    "Titlecase_Letter" -> "Lt",
    "Cased_Letter" -> "LC",
    "Modifier_Letter" -> "Lm",
    "Other_Letter" -> "Lo",
    "Mark" -> "M",
    "Non_Spacing_Mark" -> "Mn",
    "Spacing_Combining_Mark" -> "Mc",
    "Enclosing_Mark" -> "Me",
    "Separator" -> "Z",
    "Space_Separator" -> "Zs",
    "Line_Separator" -> "Zl",
    "Paragraph_Separator" -> "Zp",
    "Symbol" -> "S",
    "Math_Symbol" -> "Sm",
    "Currency_Symbol" -> "Sc",
    "Modifier_Symbol" -> "Sk",
    "Other_Symbol" -> "So",
    "Number" -> "N",
    "Decimal_Digit_Number" -> "Nd",
    "Letter_Number" -> "Nl",
    "Other_Number" -> "No",
    "Punctuation" -> "P",
    "Dash_Punctuation" -> "Pd",
    "Open_Punctuation" -> "Ps",
    "Close_Punctuation" -> "Pe",
    "Initial_Punctuation" -> "Pi",
    "Final_Punctuation" -> "Pf",
    "Connector_Punctuation" -> "Pc",
    "Other_Punctuation" -> "Po",
    "Other" -> "C",
    "Control" -> "Cc",
    "Format" -> "Cf",
    "Private_Use" -> "Co",
    "Surrogate" -> "Cs",
    "Unassigned" -> "Cn"
  )

  private val longCategoryNames =
    for ((a, b) <- longCategoryNamesRaw)
    yield (normalize(a), b.toLowerCase)

  private def normalize(str : String) : String =
    str.toLowerCase.replaceAll("[^a-z]", "")

}
