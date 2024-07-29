/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Philipp Ruemmer. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from this software without specific prior written permission.
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

package ostrich.proofops

import ap.proof.goal.Goal
import ap.theories.{SaturationProcedure, Theory}
import ap.proof.theoryPlugins.Plugin
import ap.terfor.TerForConvenience
import ap.terfor.preds.Atom
import ap.terfor.substitutions.VariableSubst
import ap.terfor.conjunctions.Conjunction

import ostrich.{OstrichStringTheory, OFlags}
import ostrich.automata.AtomicStateAutomaton

/**
 * Saturation procedure to add the length abstraction of regular
 * languages to a proof goal.
 */
class LengthAbstraction (
  val theory : OstrichStringTheory
) extends SaturationProcedure("ForwardsPropagation") {
  import theory.{_str_len, str_in_re_id, autDatabase}
  import autDatabase.id2Automaton

  /**
   * str_in_re_id atoms.
   */
  type ApplicationPoint = Atom

  override def extractApplicationPoints(goal : Goal)
                                      : Iterator[ApplicationPoint] =
    if (theory.lengthNeeded(goal.facts))
      goal.facts.predConj.positiveLitsWithPred(str_in_re_id).iterator
    else
      Iterator.empty

  override def applicationPriority(goal : Goal, a : Atom) : Int = {
    val aut = id2Automaton(a.last.constant.intValueSafe).get
    val size = aut match {
      case aut : AtomicStateAutomaton => aut.states.size
      case _                          => 100
    }
    100 + size
  }

  override def handleApplicationPoint(goal : Goal,
                                      a : Atom) : Seq[Plugin.Action] = {
    if (goal.facts.predConj.positiveLitsAsSet contains a) {
      implicit val order = goal.order
      import TerForConvenience._

      if (OFlags.debug)
        Console.err.println("Computing length abstraction for " + a)

      val aut            = id2Automaton(a.last.constant.intValueSafe).get
      val autAbstraction = aut.getLengthAbstraction
      val lenFor         = exists(conj(_str_len(List(a(0), l(v(0)))),
                                       autAbstraction))

      List(Plugin.AddAxiom(List(a), lenFor, theory))
    } else {
      List()
    }
  }
}

