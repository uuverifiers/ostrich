/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ap.theories.Theory
import ap.terfor.{TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.substitutions.VariableShiftSubst

class OstrichInternalPreprocessor(theory : OstrichStringTheory,
                                  flags : OFlags) {
  import theory.{FunPred, str_len, _str_len, str_++}
  private val p = theory.functionPredicateMap

  def preprocess(f : Conjunction, order : TermOrder) : Conjunction = {
    implicit val _ = order
    import TerForConvenience._

    val useLength = flags.useLength match {
      case OFlags.LengthOptions.Off  => false
      case OFlags.LengthOptions.On   => true
      case OFlags.LengthOptions.Auto => f.predicates contains _str_len
    }

    if (!useLength)
      return f

    val funTranslator =
      new OstrichStringFunctionTranslator(theory, Conjunction.TRUE)

      Theory.rewritePreds(f, order) { (a, negated) =>
        if (negated) {
          funTranslator(a) match {
            case Some((preop, args, result)) => {
              val shifter =
                VariableShiftSubst(0, args.size + 1, order)
              val shiftedA =
                shifter(a)
              val lenAtoms =
                for ((t, n) <- (args ++ List(result)).zipWithIndex)
                yield _str_len(List(shifter(l(t)), l(v(n))))
              val relation =
                preop().lengthApproximation(for (n <- 0 until args.size)
                                              yield v(n),
                                            v(args.size),
                                            order)
              exists(args.size + 1, conj(List(shiftedA, relation) ++ lenAtoms))
            }
            case _ =>
              a
          }
        } else {
          a
        }
      }

  }
  

}
