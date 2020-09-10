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

import java.io.{ByteArrayOutputStream, PrintStream}
import pack.ocamljavaMain

object Reg2PTWrapper {

  def translateRegex(regex : String) : Unit = {
    val baos = new ByteArrayOutputStream
    val oldOut = System.out

    try {
      System.setOut(new PrintStream(baos))
      pack.ocamljavaMain.mainWithReturn(Array("-s", regex))
    } finally {
      System.setOut(oldOut)
    }

    println(baos)
  }

}
