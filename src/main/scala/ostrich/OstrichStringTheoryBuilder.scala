/** This file is part of Ostrich, an SMT solver for strings. Copyright (c)
  * 2019-2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  * * Redistributions of source code must retain the above copyright notice,
  * this list of conditions and the following disclaimer.
  *
  * * Redistributions in binary form must reproduce the above copyright notice,
  * this list of conditions and the following disclaimer in the documentation
  * and/or other materials provided with the distribution.
  *
  * * Neither the name of the authors nor the names of their contributors may be
  * used to endorse or promote products derived from this software without
  * specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGE.
  */

package ostrich

import ostrich.automata.TransducerTranslator

import ap.theories.strings.{StringTheory, StringTheoryBuilder, SeqStringTheory}
import ap.util.CmdlParser

import scala.collection.mutable.ArrayBuffer
import ap.theories.TheoryBuilder
import ostrich.parikh.OstrichConfig

/** The entry class of the Ostrich string solver.
  */
class OstrichStringTheoryBuilder extends StringTheoryBuilder {

  val name = "OSTRICH"
  val version = "1.2.1"

  Console.withOut(Console.err) {
    println
    println(
      "Loading " + name + " " + version +
        ", a solver for string constraints"
    )
    println("(c)Denghang Hu, Matthew Hague, Philipp Rümmer, 2018-2023")
    println(
      "With contributions by Riccardo De Masellis, Zhilei Han, Oliver Markgraf."
    )
    println("For more information, see https://github.com/uuverifiers/ostrich")
    println
  }

  def setAlphabetSize(w: Int): Unit = ()

  private var eager, forward, minimizeAuts, useParikh = false
  private var useLen: OFlags.LengthOptions.Value = OFlags.LengthOptions.Auto

  // TODO: add more command line arguments
  override def parseParameter(str: String): Unit = str match {
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

    // Options for cost-enriched-automata based solver
    case CmdlParser.Opt("simplify-aut", value) =>
      OstrichConfig.simplifyAut = value
    case CmdlParser.Opt("measuretime", value) =>
      OstrichConfig.measureTime = value
    case CmdlParser.Opt("costenriched", value) =>
      OstrichConfig.useCostEnriched = value
    case CmdlParser.Opt("under-approx", value) =>
      OstrichConfig.underApprox = value
    case CmdlParser.Opt("over-approx", value) =>
      OstrichConfig.overApprox = value
    case CmdlParser.Opt("debug", value) => 
      OstrichConfig.debug = value
    case CmdlParser.Opt("find-model-heuristic", value) =>
      OstrichConfig.findStringHeu = value
    case CmdlParser.ValueOpt("backend", "baseline") =>
      OstrichConfig.backend = OstrichConfig.Baseline()
    case CmdlParser.ValueOpt("backend", "unary") =>
      OstrichConfig.backend = OstrichConfig.Unary()
    case CmdlParser.ValueOpt("backend", "catra") =>
      OstrichConfig.backend = OstrichConfig.Catra()
    case CmdlParser.ValueOpt("under-approx-bound", value) =>
      OstrichConfig.underApproxBound = value.toInt
    // ignore")
    case str =>
      println("Parameter " + str + " is not supported by theory " + name + "\n")
      System.exit(1)
  }

  import StringTheoryBuilder._
  import ap.parser._
  import IExpression._

  lazy val getTransducerTheory: Option[StringTheory] =
    Some(SeqStringTheory(OstrichStringTheory.alphabetSize))

  private val transducers = new ArrayBuffer[(String, SymTransducer)]

  def addTransducer(name: String, transducer: SymTransducer): Unit = {
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
          transducer,
          OstrichStringTheory.alphabetSize,
          getTransducerTheory.get
        )
        (name, aut)
      }

    new OstrichStringTheory(
      symTransducers.toSeq,
      OFlags(
        eagerAutomataOperations = eager,
        useLength = useLen,
        useParikhConstraints = useParikh,
        forwardApprox = forward,
        minimizeAutomata = minimizeAuts
      )
    )
  }

}
