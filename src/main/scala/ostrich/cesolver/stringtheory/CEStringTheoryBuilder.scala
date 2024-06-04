/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2023 Denghang Hu, Philipp Ruemmer. All rights reserved.
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
import ap.theories.TheoryBuilder
import ostrich.cesolver.core.FinalConstraints
import ostrich.OFlags
import OFlags.CEABackend.{Unary, Baseline}
import ostrich.cesolver.util.ParikhUtil

/** The entry class of the Ostrich string solver.
  */
class CEStringTheoryBuilder extends OstrichStringTheoryBuilder {

  private var useCostEnriched, debug = false
  private var backend: OFlags.CEABackend.Value = Unary
  private var underApprox, simplifyAut = true
  private var underApproxBound = 15

  override def parseParameter(str: String): Unit = str match {
    case CmdlParser.Opt("simplify-aut", value) =>
      simplifyAut = value
    case CmdlParser.Opt("costenriched", value) =>
      useCostEnriched = value
    case CmdlParser.Opt("under-approx", value) =>
      underApprox = value
    case CmdlParser.Opt("debug", value) =>  {
      debug = value
      ParikhUtil.debug = value
    }
    case CmdlParser.ValueOpt("backend", "baseline") =>
      backend = Baseline
    case CmdlParser.ValueOpt("backend", "unary") =>
      backend = Unary
    case CmdlParser.ValueOpt("under-approx-bound", value) =>
      underApproxBound = value.toInt
    case str =>
      super.parseParameter(str)
  }

  import StringTheoryBuilder._
  import ap.parser._
  import IExpression._

  private var createdTheory = false

  override lazy val theory = {
    createdTheory = true

    new CEStringTheory(
      symTransducers.toSeq,
      OFlags(
        eagerAutomataOperations = eager,
        useLength               = useLen,
        useParikhConstraints    = useParikh,
        minimizeAutomata        = minimizeAuts,
        regexTranslator         = regexTrans,
        ceaBackend              = backend,
        useCostEnriched         = useCostEnriched,
        debug                   = debug,
        underApprox             = underApprox,
        underApproxBound        = underApproxBound,
        simplifyAut             = simplifyAut
      )
    )
  }

}
