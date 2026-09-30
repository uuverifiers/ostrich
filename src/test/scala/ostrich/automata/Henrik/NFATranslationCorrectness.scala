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
import ostrich.automata.afa2.concrete.{AFA2StateDuplicator, AFA2TestHelper, NFATranslator, NFATranslatorParallel}

object NFATranslationCorrectness extends Properties("AFA2") {

  property("Parallel-NFATranslator tested against Lazy-NFATranslator (random automata)") = {
    val automataCount = 1000L
    var seed = 0L

    // Counterexample found! Seed: 38

    var counter = 0
    var parallelTime = 0L
    var lazyTime = 0L
    var allEquivalent = true

    while (counter < automataCount && allEquivalent) {
      val stateCount = 5
      val aut = AFA2TestHelper.superRandomAFA2(seed, stateCount)
      try {
        if(aut.states.size < 3) {
          seed = seed + 1L
        } else {
          println(aut.states.size + " states in 2AFA")
          println("Seed: " + seed)
          println("===============")
          println(aut.prettyPrint())
          println("===============")
          val safa = AFA2StateDuplicator(aut)
          println(safa.states.size + " states in S2AFA")

          val parallelStart = System.nanoTime()
          val parallel = NFATranslatorParallel(safa)
          parallelTime += System.nanoTime() - parallelStart

          val lazyStart = System.nanoTime()
          val lazyt = NFATranslator(safa, null)
          lazyTime += System.nanoTime() - lazyStart

          val parallelMinusLazyt = parallel & !lazyt
          val lazytMinusParallel = lazyt & !parallel

          val equivalent = parallelMinusLazyt.isEmpty && lazytMinusParallel.isEmpty

          counter += 1
          println((counter.toFloat / automataCount.toFloat) * 100 + "% done...")
          println()
          println("###################")
          println()

          if (!equivalent) {
            println("Counterexample seed: " + seed)
            println(aut.prettyPrint())
            println(parallel)
            println(lazyt)
            allEquivalent = false
          }

          seed = seed + 1L
        }
      } catch {
        case e: Throwable =>
          println("Exception at seed: " + seed)
          println(e.getMessage)
          println(aut.prettyPrint())
          allEquivalent = false
      }
    }

    val parallelSeconds = parallelTime / 1e9
    val lazySeconds = lazyTime / 1e9

    val speedup =
      lazyTime.toDouble / parallelTime.toDouble

    println()
    println(f"Tested Automata: $counter")
    println(f"Parallel: $parallelSeconds%.3f s")
    println(f"Lazy:     $lazySeconds%.3f s")
    println(f"Speedup:  ${speedup}%.2fx")

    allEquivalent
  }
}