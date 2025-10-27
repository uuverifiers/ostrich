/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2025 Matthew Hague, Philipp Ruemmer. All rights reserved.
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
import ap.parser._
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.TerForConvenience
import ap.terfor.preds.Atom
import ap.terfor.conjunctions.Conjunction

import ostrich._
import ostrich.preprocessor.Backreferences

import scala.collection.mutable.ArrayBuffer

/**
 * Class to evaluate occurrences of the <code>str_in_re_delayed</code>
 * predicate.
 */
class OstrichRegexMatcher(theory : OstrichStringTheory) {

  import theory._

  private val backreferences = new Backreferences(theory)

  def evalAtom(a : Atom)
              (implicit extractor : RegexExtractor) : Option[Boolean] = {
    assert(a(0).isConstant)
    val str = theory.strDatabase.id2List(a(0).constant.intValueSafe)
    val regex = extractor.regexAsTerm(a(1))
    backreferences.matchRegex(str, regex) match {
      case Some(_) => Some(true)
      case None    => Some(false)
    }
  }

  def handleGoal(goal : Goal) : Seq[Plugin.Action] = {
    val facts = goal.facts
    val predConj = facts.predConj

    val posLits =
      predConj.positiveLitsWithPred(str_in_re_delayed).filter(_(0).isConstant)
    val negLits =
      predConj.negativeLitsWithPred(str_in_re_delayed).filter(_(0).isConstant)

    if (posLits.isEmpty && negLits.isEmpty) {
      List()
    } else {
      implicit val extractor = theory.RegexExtractor(goal)
      implicit val order = goal.order
      import TerForConvenience._

      val actions = new ArrayBuffer[Plugin.Action]

      for (a <- posLits)
        evalAtom(a) match {
          case Some(true) =>
            actions += Plugin.RemoveFacts(a)
          case Some(false) =>
            // TODO: also need atoms defining the regex!
            return List(Plugin.AddAxiom(List(a), Conjunction.FALSE, theory))
          case None =>
            // nothing
        }

      for (a <- negLits)
        evalAtom(a) match {
          case Some(false) =>
            actions += Plugin.RemoveFacts(a)
          case Some(true) =>
            // TODO: also need atoms defining the regex!
            return List(Plugin.AddAxiom(List(!conj(a)), Conjunction.FALSE, theory))
          case None =>
            // nothing
        }

      actions.toSeq
    }
  }

}