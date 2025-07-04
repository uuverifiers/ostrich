/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2025 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ap.ParallelFileProver
import ap.parameters.Param

/**
 * Wrapper around <code>ap.CmdlMain</code>, adding the option
 * <code>-stringSolver=ostrich.OstrichStringTheory</code>.
 */
object OstrichMain {

  val version =
    OstrichStringTheoryBuilder.version +
    " (Princess: " + ap.CmdlMain.version + ")"

  private val ostrichStringTheory =
    "ostrich.OstrichStringTheory"

  /**
   * The options forwarded to Princess. They will be overwritten by options
   * specified on the command line, so it is possible to provide more specific
   * string solver options on the command line.
   */
  val options = List("-stringSolver=" + ostrichStringTheory, "-logo")

  PortfolioSetup

  def main(args: Array[String]) : Unit =
    ap.CmdlMain.main((options ++ args).toArray)

}

object PortfolioSetup {

  private val ostrichStringTheory =
    "ostrich.OstrichStringTheory"
  private val ceaStringTheory =
    "ostrich.cesolver.stringtheory.CEStringTheory"

  // Run the RCP, ADT, CEA solvers
  ParallelFileProver.addPortfolio(
    "strings", arguments => {
      import arguments._
      val strategies =
        List(
          // Configuration 0: RCP: BWD + Nielsen
          ParallelFileProver.Configuration(
            Param.STRING_THEORY_DESC.set(baseSettings,
              ostrichStringTheory + ":-eager,-forwardPropagation,+backwardPropagation,+nielsenSplitter"),
            f"-stringSolver=${ostrichStringTheory}:-eager,-forwardPropagation,+backwardPropagation,+nielsenSplitter",
            1000000000,
            1500),
          // Configuration 1: CEA
          ParallelFileProver.Configuration(
            Param.STRING_THEORY_DESC.set(
              baseSettings,
              ceaStringTheory),
            "+cea",
            1000000000,
            1000),
          // Configuration 2: ADT
          ParallelFileProver.Configuration(
            Param.STRING_THEORY_DESC.set(
              baseSettings,
              Param.STRING_THEORY_DESC.defau),
            "-stringSolver=" +
              Param.STRING_THEORY_DESC.defau,
            1000000000,
            1000),
          // Configuration 3: RCP: BWD + FWD + Nielsen
          ParallelFileProver.Configuration(
            Param.STRING_THEORY_DESC.set(baseSettings,
              ostrichStringTheory + ":+forwardPropagation,+backwardPropagation,+nielsenSplitter"),
            f"-stringSolver=${ostrichStringTheory}:+forwardPropagation,+backwardPropagation,+nielsenSplitter",
            6000, // kill after 6s
            500),
          // Configuration 4: RCP: BWD + FWD + EAGER + Parikh
          ParallelFileProver.Configuration(
            Param.STRING_THEORY_DESC.set(baseSettings,
              ostrichStringTheory + ":+eager,+forwardPropagation,+backwardPropagation,-nielsenSplitter,+parikh"),
            f"-stringSolver=${ostrichStringTheory}:+eager,+forwardPropagation,+backwardPropagation,-nielsenSplitter,+parikh",
            1000000000,
            500)
        )
      ParallelFileProver(createReader,
        timeout,
        true,
        userDefStoppingCond(),
        strategies,
        1,
        5,
        runUntilProof,
        prelResultPrinter,
        threadNum)
    })

}
