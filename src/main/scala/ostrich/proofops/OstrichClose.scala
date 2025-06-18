/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Oliver Markgraf, Philipp Ruemmer. All rights reserved.
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

package ostrich.proofops

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.{Atom, PredConj}
import ap.terfor.{Term, TermOrder}
import ap.terfor.conjunctions.Conjunction

import ostrich._
import ostrich.automata.AutDatabase.NamedAutomaton

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.{HashMap => MHashMap}

class OstrichClose(theory : OstrichStringTheory)  {
  import theory.{str_in_re_id, autDatabase}
  import LinearCombination.Constant

  // Atoms with predicate str_in_re, and negated str_in_re_id predicates
  // are now handled in the proof rule OstrichStrInReConverter

  def handleGoal(goal : Goal) : Seq[Plugin.Action] = {
    val facts: Conjunction = goal.facts
    val predConj: PredConj = facts.predConj
    val order = goal.order

    val regexGroups = predConj.positiveLitsWithPred(str_in_re_id).groupBy(_(0))
    implicit val lcOrdering = order.lcOrdering

    for ((c, atoms) <- regexGroups.toSeq.sortBy(_._1);
         if atoms.size > 1;
         ids = for (Seq(_, Constant(IdealInt(id))) <- atoms) yield id;
         if autDatabase.emptyIntersection(ids.toSet))
    yield Plugin.CloseByAxiom(atoms, theory)
  }
}