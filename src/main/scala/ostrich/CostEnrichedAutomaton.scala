/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2021 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ap.terfor.Formula

/**
 * Trait for automata with atomic/nominal states; i.e., states
 * don't have any structure and are not composite, there is a unique
 * initial state, and a set of accepting states.
 */
trait CostEnrichedAutomaton extends AtomicStateAutomaton {

  /**
   * Union. This method assumed that <code>this</code> and <code>that</code>
   * have the same number of cost counters.
   */
  def |(that : CostEnrichedAutomaton) : CostEnrichedAutomaton

  /**
   * Intersection. The resulting automata will have
   * <code>this.counterNum + that.counterNum</code> counters.
   */
  def &(that : CostEnrichedAutomaton) : CostEnrichedAutomaton

  /**
   * The number of counters available for costs.
   */
  val counterNum : Int

  /**
   * Given a state, iterate over all outgoing transitions, including
   * their label and the costs.
   */
  def outgoingTransitionsWithCost(from : State)
                                : Iterator[(State, TLabel, Seq[Int])]
  
  def outgoingTransitions(from : State) : Iterator[(State, TLabel)] =
    for ((s, l, _) <- outgoingTransitionsWithCost(from)) yield (s, l)

  /**
   * Return new automaton builder of compatible type
   */
  def getBuilder : CostEnrichedAutomatonBuilder[State, TLabel]

  /**
   * Compute the set of possible cost vectors as a Presburger formula.
   * The costs are represented by the variables <code>_0, _1, ...</code>.
   */
  def getCostImage : Formula

  //////////////////////////////////////////////////////////////////////////
  // Derived methods

  /**
   * Iterate over all transitions with costs
   */
  def transitionsWithCost : Iterator[(State, TLabel, Seq[Int], State)] =
    for (s1 <- states.iterator; (s2, lbl, c) <- outgoingTransitionsWithCost(s1))
      yield (s1, lbl, c, s2)

}

trait CostEnrichedAutomatonBuilder[State, TLabel]
      extends AtomicStateAutomatonBuilder[State, TLabel] {

  /**
   * Set the number of cost counters used in the automaton. This
   * method can only be used prior to adding states or transitions.
   */
  def setCounterNum(num : Int) : Unit

  /**
   * Add a new transition q1 --label--> q2 with given cost
   */
  def addTransitionWithCost(s1 : State,
                            label : TLabel, costs : Seq[Int],
                            s2 : State) : Unit

  /**
   * Iterate over outgoing transitions from state, with their costs
   */
  def outgoingTransitionsWithCost(q : State) : Iterator[(State, TLabel, Seq[Int])]

  /**
   * Returns built automaton.  Can only be used once after which the
   * automaton cannot change
   */
  def getAutomaton : CostEnrichedAutomaton

}
