/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu, Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.cesolver.stringtheory

import ostrich._
import ostrich.automata.TransducerTranslator

import ap.theories.strings.{StringTheory, StringTheoryBuilder, SeqStringTheory}
import ap.util.CmdlParser

import scala.collection.mutable.ArrayBuffer
import ostrich.OFlags
import OFlags.CEABackend.{Unary, Baseline, Catra, Nuxmv}
import ostrich.cesolver.util.ParikhUtil
import ap.CmdlMain

/** The entry class of the Ostrich string solver.
  */
class CEStringTheoryBuilder extends OstrichStringTheoryBuilder {

  override val name = "OSTRICH"
  val version = "1.2.1"

  Console.withOut(Console.err) {
    println
    println(
      "Loading " + name + " " + version +
        ", a solver for string constraints"
    )
    println("(c) Denghang Hu, Matthew Hague, Philipp Rümmer, 2018-2023")
    println(
      "With contributions by Riccardo De Masellis, Zhilei Han, Oliver Markgraf."
    )
    println("For more information, see https://github.com/uuverifiers/ostrich")
    println
  }

  protected var debug = false
  protected var compApprox, simplyAutByVec = true
  protected var backend: OFlags.CEABackend.Value = Unary
  protected var nuxmvBackend: OFlags.NuxmvBackend.Value = OFlags.NuxmvBackend.Ic3
  protected var findModelStrategy: OFlags.FindModelBy.Value =
    OFlags.FindModelBy.Mixed
  protected var countUnwindStrategy: OFlags.NestedCountUnwindBy.Value =
    OFlags.NestedCountUnwindBy.MinFisrt
  protected var searchStringBy: OFlags.SearchStringBy.Value =
    OFlags.SearchStringBy.MoreUpdatesFirst

  override def parseParameter(str: String): Unit = str match {
    case CmdlParser.Opt("eager", value) =>
      eager = value
    case CmdlParser.Opt("minimizeAutomata", value) =>
      minimizeAuts = value

    // Options for cost-enriched-automata based solver
    case CmdlParser.Opt("debug", value) =>
      debug = value
      ParikhUtil.debugOpt = value
      CmdlMain.stackTraces = value
    case CmdlParser.Opt("log", value) =>
      ParikhUtil.logOpt = value
    case CmdlParser.Opt("compApprox", value) =>
      compApprox = value
    case CmdlParser.Opt("simplyAutByVec", value) =>
      simplyAutByVec = value

    case CmdlParser.ValueOpt("ceaBackend", "baseline") =>
      backend = Baseline
    case CmdlParser.ValueOpt("ceaBackend", "unary") =>
      backend = Unary
    case CmdlParser.ValueOpt("ceaBackend", "catra") =>
      backend = Catra
    case CmdlParser.ValueOpt("ceaBackend", "nuxmv") =>
      backend = Nuxmv

    case CmdlParser.ValueOpt("nuxmvBackend", "bmc") =>
      nuxmvBackend = OFlags.NuxmvBackend.Bmc
    case CmdlParser.ValueOpt("nuxmvBackend", "ic3") =>
      nuxmvBackend = OFlags.NuxmvBackend.Ic3

    case CmdlParser.ValueOpt("findModelBy", "registers") =>
      findModelStrategy = OFlags.FindModelBy.Registers
    case CmdlParser.ValueOpt("findModelBy", "transitions") =>
      findModelStrategy = OFlags.FindModelBy.Transtions
    case CmdlParser.ValueOpt("findModelBy", "mixed") =>
      findModelStrategy = OFlags.FindModelBy.Mixed

    case CmdlParser.ValueOpt("searchStringBy", "moreUpdatesFirst") =>
      searchStringBy = OFlags.SearchStringBy.MoreUpdatesFirst
    case CmdlParser.ValueOpt("searchStringBy", "random") =>
      searchStringBy = OFlags.SearchStringBy.Random

    case CmdlParser.ValueOpt("countUnwindBy", "minFirst") =>
      countUnwindStrategy = OFlags.NestedCountUnwindBy.MinFisrt
    case CmdlParser.ValueOpt("countUnwindBy", "meetFirst") =>
      countUnwindStrategy = OFlags.NestedCountUnwindBy.MeetFirst

    case str =>
      super.parseParameter(str)
  }

  import StringTheoryBuilder._

  private var createdTheory = false

  override lazy val theory = {
    createdTheory = true

    new CEStringTheory(
      symTransducers.toSeq,
      OFlags(
        eagerAutomataOperations = eager,
        useLength = OFlags.LengthOptions.On,
        minimizeAutomata = minimizeAuts,
        backend = backend,
        debug = debug,
        NuxmvBackend = nuxmvBackend,
        findModelStrategy = findModelStrategy,
        countUnwindStrategy = countUnwindStrategy,
        searchStringStrategy = searchStringBy,
        compApprox = compApprox,
        simplyAutByVec = simplyAutByVec
      )
    )
  }

}
