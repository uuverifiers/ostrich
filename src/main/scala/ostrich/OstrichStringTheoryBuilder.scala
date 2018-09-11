/**
 * This file is part of Ostrich.
 *
 * Copyright (C) 2018 Philipp Ruemmer <ph_r@gmx.net>
 *
 * Ostrich is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * Ostrich is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Ostrich.  If not, see <http://www.gnu.org/licenses/>.
 */

package ostrich

import ap.theories.strings.{StringTheory, StringTheoryBuilder, SeqStringTheory}

import scala.collection.mutable.ArrayBuffer

/**
 * The entry class of the Ostrich string solver.
 */
class OstrichStringTheoryBuilder extends StringTheoryBuilder {

  val name = "OSTRICH"

  Console.withOut(Console.err) {
    println
    println("Loading " + name + ", a solver for string constraints")
    println("(c) Matthew Hague, Philipp Rümmer, 2018")
    println("For more information, see https://github.com/pruemmer/ostrich")
    println
  }

  def setBitWidth(w : Int) : Unit = ()

  import StringTheoryBuilder._
  import ap.parser._
  import IExpression._

  lazy val getTransducerTheory : Option[StringTheory] =
    Some(SeqStringTheory(OstrichStringTheory.bitWidth))

  private val transducers = new ArrayBuffer[(String, SymTransducer)]

  def addTransducer(name : String, transducer : SymTransducer) : Unit = {
    assert(!createdTheory)
    transducers += ((name, transducer))
  }

  private var createdTheory = false

  lazy val theory = {
    createdTheory = true

    val symTransducers =
      for ((name, transducer) <- transducers) yield {
        println("Translating transducer " + name + " ...")
        val aut = TransducerTranslator.toBricsTransducer(
                    transducer, OstrichStringTheory.bitWidth)
        (name, aut)
      }

    new OstrichStringTheory (symTransducers)
  }

}