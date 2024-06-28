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

import ap.terfor.TerForConvenience
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.{Atom, PredConj}
import ap.terfor.{Term, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ostrich._

/**
 * Class to replace left-over <code>str.in_re</code> atoms with
 * <code>str_in_re_id</code> atoms.
 */
class OstrichStrInReTranslator(theory : OstrichStringTheory) {
  import theory._

  def handleGoal(goal : Goal) : Seq[Plugin.Action] = {
    val predConj = goal.facts.predConj

    if (predConj.predicates contains str_in_re) {
      val posLits = predConj.positiveLitsWithPred(str_in_re)
      val negLits = predConj.negativeLitsWithPred(str_in_re)

      val regexExtractor = theory.RegexExtractor(goal)
      implicit val to = goal.order
      import TerForConvenience._
      import Plugin.{AddAxiom, RemoveFacts}
      import Conjunction.negate

      def autIdFor(t : Term) : Option[Int] = 
        try {
          val regex = regexExtractor regexAsTerm t
          val aut   = autDatabase.regex2Automaton(regex)
          Some(autDatabase.automaton2Id(aut))
        } catch {
          case _ : IllegalRegexException => None
        }
      
      (for (a   <- posLits;
            id  <- autIdFor(a(1)).toSeq;
            act <- List(AddAxiom(List(a),
                                 str_in_re_id(List(a(0), l(id))),
                                 theory),
                        RemoveFacts(a)))
       yield act) ++
      (for (a   <- negLits;
            id  <- autIdFor(a(1)).toSeq;
            act <- List(AddAxiom(List(negate(a, to)),
                                 negate(str_in_re_id(List(a(0), l(id))), to),
                                 theory),
                        RemoveFacts(negate(a, to))))
       yield act)
    } else {
      List()
    }
  }

}