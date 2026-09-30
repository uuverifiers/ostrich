/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2023 Philipp Ruemmer. All rights reserved.
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

package ostrich.automata.Henrik

import org.scalacheck.Properties
import ostrich.automata.afa2.concrete.{AFA2, AFA2StateDuplicator, AFA2StateExpander, AFA2TestHelper, NFATranslator, NFATranslatorParallel}
import ostrich.automata.afa2.{Right, StepTransition}

object AFA2OptimizationCorrectness extends Properties("AFA2") {

  property("optimize() preserves language") = {
    val aut = AFA2(
      initialStates = Seq(0),
      finalStates = Seq(9),
      transitions = Map(
        0 -> Seq(
          StepTransition('a'.toInt, Right, Seq(1)),
          StepTransition('b'.toInt, Right, Seq(2))
        ),

        // 1 and 3 are intentionally equivalent
        1 -> Seq(
          StepTransition('a'.toInt, Right, Seq(3)),
          StepTransition('b'.toInt, Right, Seq(4))
        ),
        3 -> Seq(
          StepTransition('a'.toInt, Right, Seq(3)),
          StepTransition('b'.toInt, Right, Seq(4))
        ),

        // 2 and 5 are intentionally equivalent
        2 -> Seq(
          StepTransition('a'.toInt, Right, Seq(5)),
          StepTransition('b'.toInt, Right, Seq(6))
        ),
        5 -> Seq(
          StepTransition('a'.toInt, Right, Seq(5)),
          StepTransition('b'.toInt, Right, Seq(6))
        ),

        // 4 and 7 are intentionally equivalent
        4 -> Seq(
          StepTransition('a'.toInt, Right, Seq(7)),
          StepTransition('b'.toInt, Right, Seq(9))
        ),
        7 -> Seq(
          StepTransition('a'.toInt, Right, Seq(7)),
          StepTransition('b'.toInt, Right, Seq(9))
        ),

        // 6 and 8 are intentionally equivalent
        6 -> Seq(
          StepTransition('a'.toInt, Right, Seq(8)),
          StepTransition('b'.toInt, Right, Seq(9))
        ),
        8 -> Seq(
          StepTransition('a'.toInt, Right, Seq(8)),
          StepTransition('b'.toInt, Right, Seq(9))
        )
      )
    )

    val reduced = aut.optimize()
    val beforeNFA = NFATranslator(AFA2StateExpander(aut), null)
    val afterNFA = NFATranslator(AFA2StateExpander(reduced), null)

    val beforeMinusAfter = beforeNFA & !afterNFA
    val afterMinusBefore = afterNFA & !beforeNFA

    reduced.states.size < aut.states.size &&
      beforeMinusAfter.isEmpty &&
      afterMinusBefore.isEmpty
  }
}