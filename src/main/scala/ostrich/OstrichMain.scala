/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2020  Matthew Hague, Philipp Ruemmer
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

/**
 * Wrapper around <code>ap.CmdlMain</code>, adding the option
 * <code>-stringSolver=ostrich.OstrichStringTheory</code>.
 */
object OstrichMain {

  val version = "unstable build (Princess: " + ap.CmdlMain.version + ")"

  /**
   * The options forwarded to Princess. They will be overwritten by options
   * specified on the command line, so it is possible to provide more specific
   * string solver options on the command line.
   */
  val options = List("-stringSolver=ostrich.OstrichStringTheory", "-logo")

  def main(args: Array[String]) : Unit =
    ap.CmdlMain.main((options ++ args).toArray)

}
