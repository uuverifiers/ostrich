/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2024 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

object OstrichStringTheoryBuilder {

  val version = "1.3.5"

  PortfolioSetup

}

/**
 * The entry class of the Ostrich string solver.
 */
class OstrichStringTheoryBuilder extends StringTheoryBuilder {

  import OstrichStringTheoryBuilder._

  val name = "OSTRICH"

  Console.withOut(Console.err) {
    println
    println("Loading " + name + " " + version +
              ", a solver for string constraints")
    println("(c) Matthew Hague, Denghang Hu, Philipp Rümmer, 2018-2024")
    println("With contributions by Riccardo De Masellis, Zhilei Han, Oliver Markgraf.")
    println("For more information, see https://github.com/uuverifiers/ostrich")
    println
  }

  def setAlphabetSize(w : Int) : Unit = ()

  protected var eager, forwardPropagation, minimizeAuts, useParikh = false
  protected var backwardPropagation, nielsenSplitter = true

  protected var useLen : OFlags.LengthOptions.Value = OFlags.LengthOptions.Auto
  protected var regexTrans : OFlags.RegexTranslator.Value = OFlags.RegexTranslator.Hybrid

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
    case CmdlParser.Opt("forwardPropagation", value) =>
      forwardPropagation = value
    case CmdlParser.Opt("backwardPropagation", value) =>
      backwardPropagation = value
    case CmdlParser.Opt("nielsenSplitter", value) =>
      nielsenSplitter = value
    case CmdlParser.Opt("parikh", value) =>
      useParikh = value
    case CmdlParser.ValueOpt("regexTranslator", "approx") =>
      regexTrans = OFlags.RegexTranslator.Approx
    case CmdlParser.ValueOpt("regexTranslator", "complete") =>
      regexTrans = OFlags.RegexTranslator.Complete
    case CmdlParser.ValueOpt("regexTranslator", "hybrid") =>
      regexTrans = OFlags.RegexTranslator.Hybrid
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

  lazy val symTransducers =
    for ((name, transducer) <- transducers) yield {
      Console.err.println("Translating transducer " + name + " ...")
      val aut = TransducerTranslator.toBricsTransducer(
                  transducer, OstrichStringTheory.alphabetSize,
                  getTransducerTheory.get)
      (name, aut)
    }

  lazy val theory = {
    createdTheory = true

    new OstrichStringTheory (symTransducers,
                             OFlags(eagerAutomataOperations = eager,
                                    useLength               = useLen,
                                    useParikhConstraints    = useParikh,
                                    forwardPropagation      = forwardPropagation,
                                    backwardPropagation     = backwardPropagation,
                                    nielsenSplitter         = nielsenSplitter,
                                    minimizeAutomata        = minimizeAuts,
                                    regexTranslator         = regexTrans))
  }

}
