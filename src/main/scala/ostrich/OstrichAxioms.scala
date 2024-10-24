/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ap.terfor.{TerForConvenience, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ap.parser._
import ap.theories.strings.StringTheory

/**
 * Axioms that will be instantiated using E-matching.
 */
class OstrichAxioms(theory : OstrichStringTheory) {

  import theory._
  import TerForConvenience._

  // Ideally, we just would use theory.order here, but that
  // does not seem to be set up correctly (we are too early?)
  implicit val order : TermOrder =
    TermOrder.EMPTY.extendPred(List(str_contains, _str_++))

  private val CSo = CharSort
  private val SSo = StringSort
  private val RSo = RegexSort

  /*
   * !str.contains(str.++(x1, x2), y) ->
   *    !str.contains(x1, y) & !str.contains(x2, y)
   */
  val not_contains_concat : Conjunction =
    forall(forall(forall(forall(
      (_str_++(List(l(v(0)), l(v(1)), l(v(2)))) &
        !conj(str_contains(List(l(v(2)), l(v(3))))))
      ==>
      (!conj(str_contains(List(l(v(0)), l(v(3))))) &
        !conj(str_contains(List(l(v(1)), l(v(3))))))))))

  val axioms : Conjunction = not_contains_concat

}
