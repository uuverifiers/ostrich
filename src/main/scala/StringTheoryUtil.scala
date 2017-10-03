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

package strsolver

import ap.terfor.Term

object StringTheoryUtil {
  private var _numOfVariables: Int = -1;

  def setVariables(v: Int): Unit = _numOfVariables = v

  def getVariable: Int = {
    _numOfVariables += 1; _numOfVariables
  }

  private def createUnicodeChar(num: Int): String = {
    "\\" + new String(Character.toChars(num))
  }

  private def getString(str: String) =
    """\\\\\\\\\\x\\([0-9a-f])\\([0-9a-f])""".r.replaceAllIn(str, { m =>
      "\\" + Integer.parseInt(m.group(1) + m.group(2), 16).toChar
    })

  private def createString(list: List[Either[Int, Term]]): String = list match {
    case Nil => ""
    case x :: xs => (x match {
      case Left(c) if (c > 39 && c < 44) ||
                      (c > 90 && c < 95) ||
                      c == 45 ||
                      c == 46 ||
                      c == 63 ||
                      c == 124 => c.toChar
      case Left(c) => "\\" + c.toChar//createUnicodeChar(c)
      case Right(s) => throw new Exception("Don't know how to handle " + s + " in createString")
    }) + createString(xs)
  }

  def createString(it: Iterator[List[Either[Int, Term]]]): String = {
    if (it.hasNext) {
      val str = createString(it.next())

      """^\\/(?s)(.*)\\/$""".r.findFirstMatchIn(str) match {
        case None => 
          str

        case Some(s) => 
          s.group(1)
      }
    } else
      ""
  }
}