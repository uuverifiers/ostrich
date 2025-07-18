/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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

package ostrich.cesolver

import ap.ParallelFileProver
import ap.parameters.Param
import ostrich.OstrichMain
import ostrich.cesolver.util.ParikhUtil

/**
 * Wrapper around <code>ap.CmdlMain</code>, adding the option
 * <code>-stringSolver=ostrich.OstrichStringTheory</code>.
 */
object CEMain {

  val version = OstrichMain.version

  /**
   * The options forwarded to Princess. They will be overwritten by options
   * specified on the command line, so it is possible to provide more specific
   * string solver options on the command line.
   */
  val options = List("-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory", "-logo")

/*
  ParallelFileProver.addPortfolio(
    "strings", arguments => {
                 import arguments._
                 val strategies =
                   List(ParallelFileProver.Configuration(
                          baseSettings,
                          "-stringSolver=" +
                            Param.STRING_THEORY_DESC(baseSettings),
                          1000000000,
                          2000),
                        ParallelFileProver.Configuration(
                          Param.STRING_THEORY_DESC.set(
                                  baseSettings,
                                  Param.STRING_THEORY_DESC.defau),
                          "-stringSolver=" +
                            Param.STRING_THEORY_DESC.defau,
                          1000000000,
                          2000))
                 ParallelFileProver(createReader,
                                    timeout,
                                    true,
                                    userDefStoppingCond(),
                                    strategies,
                                    1,
                                    2,
                                    runUntilProof,
                                    prelResultPrinter,
                                    threadNum)
               })
 */

  def main(args: Array[String]) : Unit = try {
    ap.CmdlMain.stackTraces = ParikhUtil.debugOpt
    ap.CmdlMain.main((options ++ args).toArray)
  } catch {
    case e: Throwable =>
      ParikhUtil.throwWithStackTrace(e)
  }

}
