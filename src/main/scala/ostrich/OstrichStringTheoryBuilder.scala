/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ostrich.automata.TransducerTranslator

import ap.theories.strings.{StringTheory, StringTheoryBuilder, SeqStringTheory}
import ap.util.CmdlParser

import scala.collection.mutable.ArrayBuffer

/**
 * The entry class of the Ostrich string solver.
 */
class OstrichStringTheoryBuilder extends StringTheoryBuilder {

  val name = "OSTRICH"
  val version = "1.1"

  Console.withOut(Console.err) {
    println
    println("Loading " + name + " " + version +
              ", a solver for string constraints")
    println("(c) Matthew Hague, Philipp Rümmer, 2018-2021")
    println("With contributions by Riccardo De Masellis, Zhilei Han.")
    println("For more information, see https://github.com/uuverifiers/ostrich")
    println
  }

  def setAlphabetSize(w : Int) : Unit = ()

  private var eager, forward, minimizeAuts, useParikh = false
  private var useLen : OFlags.LengthOptions.Value = OFlags.LengthOptions.Auto

  override def parseParameter(str : String) : Unit = str match {
    case CmdlParser.Opt("eager", value) =>
      eager = value
    case CmdlParser.Opt("minimizeAutomata", value) =>
      minimizeAuts = value
    case CmdlParser.ValueOpt("length", "off") =>
      useLen = OFlags.LengthOptions.Off
    case CmdlParser.ValueOpt("length", "on") =>
      useLen = OFlags.LengthOptions.On
    case CmdlParser.ValueOpt("length", "auto") =>
      useLen = OFlags.LengthOptions.Auto
    case CmdlParser.Opt("forward", value) =>
      forward = value
    case CmdlParser.Opt("parikh", value) =>
      useParikh = value
    case str =>
      super.parseParameter(str)
  }

  import StringTheoryBuilder._
  import ap.parser._
  import IExpression._

  lazy val getTransducerTheory : Option[StringTheory] =
    Some(SeqStringTheory(OstrichStringTheory.alphabetSize))

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
        Console.err.println("Translating transducer " + name + " ...")
        val aut = TransducerTranslator.toBricsTransducer(
                    transducer, OstrichStringTheory.alphabetSize,
                    getTransducerTheory.get)
        (name, aut)
      }

    new OstrichStringTheory (symTransducers,
                             OFlags(eagerAutomataOperations = eager,
                                    useLength               = useLen,
                                    useParikhConstraints    = useParikh,
                                    forwardApprox           = forward,
                                    minimizeAutomata        = minimizeAuts))
  }

}
