/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2023 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

object OFlags {

  object LengthOptions extends Enumeration {
    val Off, On, Auto = Value
  }

  object RegexTranslator extends Enumeration {
    val Approx, Complete, Hybrid = Value
  }

  object CEABackend extends Enumeration {
    val Baseline, Unary = Value
  }

  /** Compile-time flag that can be used to switch on debugging output
    * throughout the theory.
    */
  protected[ostrich] val debug = false

  val timeout = 60000
}

case class OFlags(
  // Pre-image specific options
  eagerAutomataOperations : Boolean = false,
  measureTimes            : Boolean = false,
  useLength               : OFlags.LengthOptions.Value =
                              OFlags.LengthOptions.Auto,
  useParikhConstraints    : Boolean = true,
  minimizeAutomata        : Boolean = false,
  forwardPropagation      : Boolean = false,
  backwardPropagation     : Boolean = true,
  nielsenSplitter         : Boolean = true,
  regexTranslator         : OFlags.RegexTranslator.Value =
                              OFlags.RegexTranslator.Hybrid,

  // Options for the cost-enriched-automata solver
  ceaBackend              : OFlags.CEABackend.Value = OFlags.CEABackend.Unary,
  useCostEnriched         : Boolean = false,
  debug                   : Boolean = false,
  underApprox             : Boolean = true,
  underApproxBound        : Int = 15,
  simplifyAut             : Boolean = true
)
