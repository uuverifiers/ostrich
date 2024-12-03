/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Oliver Markgraf. All rights reserved.
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
import ap.proof.theoryPlugins.Plugin
import ap.proof.theoryPlugins.Plugin.AxiomSplit
import ap.terfor.{TerForConvenience,  TermOrder}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.Atom
import ap.theories.{SaturationProcedure, Theory}
import ostrich.OstrichStringTheory

/**
 * A SaturationProcedure for Cut propagation.
 */
class CutSaturation(
  val theory : OstrichStringTheory
) extends SaturationProcedure("CutSaturation")
  with PropagationSaturationUtils {
  import theory.{FunPred, str_contains, str_in_re_id,  str_replace, str_replaceall, str_replacere, str_replaceallre}

  /**
   * (funApp)
   * funApp -- replace(x,y,z) = res | replace_all(x,y,z) = res | replace_re(x, regex,z) = res | replace_all_re(x, regex,z) = res
   * Add axiom for str.replace split str.contains(x,y) | !str.contains(x,y)
   * Add axiom for str.replace_re split str.in_re(x,regex) | !str.in_re(x, regex)
   */
  type ApplicationPoint = (Atom)

  override def extractApplicationPoints(goal: Goal): Iterator[ApplicationPoint] = {
    val predicates = Seq(str_replace, str_replaceall, str_replacere, str_replaceallre)

    predicates.iterator.flatMap { pred =>
      goal.facts.predConj.positiveLitsWithPred(FunPred(pred)).filter { appPoint =>
        appPoint.pred match {
          case FunPred(`str_replace`) | FunPred(`str_replaceall`) =>
            !(appPoint(0).isConstant || appPoint(1).isConstant) // Exclude if either is a constant
          case _ => true // Include all other cases
        }
      }
    }
  }



  override def applicationPriority(goal : Goal, p : ApplicationPoint) : Int = {
    1
  }

  override def handleApplicationPoint(
    goal : Goal, appPoint : ApplicationPoint
  ) : Seq[Plugin.Action] = {
    implicit val o: TermOrder = goal.order
    import TerForConvenience._
    val action = appPoint.pred match {
      case FunPred(`str_replace`) | FunPred(`str_replaceall`) => {
        val contains : (Conjunction, Seq[Nothing]) = (str_contains(List(l(appPoint(0)), l(appPoint(1)))), Seq())
        val negContains : (Conjunction, Seq[Nothing]) = (!conj(str_contains(List(l(appPoint(0)), l(appPoint(1))))), Seq())
        Seq(AxiomSplit(Seq(conj(appPoint)),Seq(contains, negContains), theory))
      }

      case FunPred(`str_replacere`) | FunPred(`str_replaceallre`) =>
        // TODO: Check if this is useful or just slows down
        val extract = theory.RegexExtractor(goal.facts.predConj)
        val autId = autDatabase.regex2Id(extract.regexAsTerm(appPoint(1)))

        autDatabase.id2ComplementedId(autId) match {
          case Some(autId2) =>
            val cut1: (Conjunction, Seq[Nothing]) = (str_in_re_id(List(l(appPoint(0)), l(autId))), Seq())
            val cut2: (Conjunction, Seq[Nothing]) = (str_in_re_id(List(l(appPoint(0)), l(autId2))), Seq())
            Seq(AxiomSplit(Seq(conj(appPoint)), Seq(cut1, cut2), theory))
          case None =>
            Seq() // If no complemented ID is found, return an empty sequence TODO: Can this ever happen?
        }

      case _ => List()
    }

    logSaturation("cut contains") {
      action
    }
  }


  override def isSoundForSat(
    theories : Seq[Theory],
    config : Theory.SatSoundnessConfig.Value) : Boolean = true
}
