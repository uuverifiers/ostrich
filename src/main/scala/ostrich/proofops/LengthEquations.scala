/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Philipp Ruemmer. All rights reserved.
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

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.theories.{SaturationProcedure, Theory}
import ap.proof.theoryPlugins.Plugin
import ap.terfor.TerForConvenience
import ap.terfor.preds.Atom
import ap.terfor.substitutions.VariableSubst
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination

import ostrich.{OstrichStringTheory, OFlags, OstrichStringFunctionTranslator}

/**
 * Proof rule to add length equations for string equations with concatenation.
 */
class LengthEquations (
  val theory : OstrichStringTheory
) extends SaturationProcedure("LengthEquations")
     with PropagationSaturationUtils {
  import theory.{_str_len, _str_++}

  val funTranslator =
    new OstrichStringFunctionTranslator(theory, Conjunction.TRUE)

  type ApplicationPoint = Atom

  override def extractApplicationPoints(goal : Goal)
                                             : Iterator[ApplicationPoint] =
    goal.facts.predConj.positiveLitsWithPred(_str_++).iterator

  override def applicationPriority(goal : Goal, p : ApplicationPoint) : Int =
    -500

  override def handleApplicationPoint(goal : Goal,
                                      a    : ApplicationPoint)
                                           : Seq[Plugin.Action] = {
    implicit val order = goal.order
    import TerForConvenience._

    if (goal.facts.predConj.positiveLitsAsSet.contains(a)) {
      funTranslator(a) match {
        case Some((preop, args, result)) => {
          def lenVar(argNum: Int) =
            l(v(argNum))
          val lenAtoms =
            for ((t, n) <- (args ++ List(result)).zipWithIndex)
            yield (_str_len(List(l(t), lenVar(n))) & (lenVar(n) >= 0))
          val lenRelation =
            preop().lengthApproximation((0 until args.size).map(lenVar(_)),
                                        lenVar(args.size),
                                        order)
          val f = exists(args.size + 1, conj(List(lenRelation) ++ lenAtoms))
          List(Plugin.AddAxiom(List(a), f, theory))
        }
        case _ =>
          List()
      }      
    } else {
      List()
    }
  }
}