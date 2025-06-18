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

package ostrich.cesolver.convenience

import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.automata.Automaton
import ostrich.automata.BricsAutomaton
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.util.ParikhUtil
object CostEnrichedConvenience {
  def automaton2CostEnriched(
      auts: Seq[Automaton]
  ): Seq[CostEnrichedAutomatonBase] = {
    ParikhUtil.log("CostEnrichedConvenience.automaton2CostEnriched: convert automata to cost-enriched automata")
    auts.map(automaton2CostEnriched(_))
  }

  def automaton2CostEnriched(aut: Automaton): CostEnrichedAutomatonBase = {
    ParikhUtil.log("CostEnrichedConvenience.automaton2CostEnriched: convert automaton to cost-enriched automaton")
    if (
      aut.isInstanceOf[CostEnrichedAutomatonBase]
    ) {
      aut.asInstanceOf[CostEnrichedAutomatonBase]
    } else if (aut.isInstanceOf[BricsAutomaton]) {
      BricsAutomatonWrapper(aut.asInstanceOf[BricsAutomaton].underlying)
    } else {
      val e = new Exception(s"Automaton $aut is not a cost-enriched automaton")
      // e.printStackTrace()
      throw e
    }
  }

}
