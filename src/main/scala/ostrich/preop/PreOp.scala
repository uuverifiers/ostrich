/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.preop

import ostrich.automata.{Automaton, BricsAutomaton}

import ap.terfor.{Term, Formula, TermOrder}
import ap.terfor.conjunctions.Conjunction

/**
 * Interface for back-propagating regex constraints over n-ary functions f.
 */
trait PreOp {

  /**
   * Given known regex constraints for function arguments and function result,
   * derive a sequence of regex constraints for the arguments such that
   * <ul>
   * <li>returned constraints are contained in the pre-image:
   *     any word tuple accepted by any of the returned automata tuples
   *     is mapped by the function to a word accepted by the
   *     result constraint</li>
   * <li>returned constraints subsume the pre-image intersected with the
   *     existing argument constraints: whenever a word tuple is accepted
   *     by the given argument constraints, and is mapped by the function
   *     to a word accepted by the result constraint, then the word tuple
   *     is also accepted by one of the returned constraints</li>
   * </ul>
   *
   * If the result depends on the given <code>argumentConstraints</code>,
   * then the used constraints also have to be returned as second result
   * component.
   */
  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]])

  /**
   * Evaluate the described function; return <code>None</code> if the
   * function is not defined for the given arguments.
   */
  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]]

  /**
   * Generate a formula that approximates the length relationship
   * between arguments and result. It is sound to just return
   * <code>true</code>. The parameters <code>arguments</code> and
   * <code>result</code> are terms representing the length of the
   * string arguments.
   */
  def lengthApproximation(arguments : Seq[Term], result : Term,
                          order : TermOrder) : Formula =
    Conjunction.TRUE

  /**
   * Generate a formula that approximates the character count (=
   * Parikh) relationship between arguments and result, for one
   * particular letter <code>char</code>. It is sound to just return
   * <code>true</code>. The parameters <code>arguments</code> and
   * <code>result</code> are terms representing the length of the
   * string arguments.
   */
  def charCountApproximation(char : Int,
                             arguments : Seq[Term], result : Term,
                             order : TermOrder) : Formula =
    Conjunction.TRUE

  /**
   * Given constraints on the input variables, produce an over-approximation
   * constraint on the output.
   */
  def forwardApprox(argumentConstraints : Seq[Seq[Automaton]]) : Automaton =
    BricsAutomaton.makeAnyString
}
