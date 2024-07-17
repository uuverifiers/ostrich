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
import ap.parser.IFunction
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.proof.theoryPlugins.Plugin.AxiomSplit
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
import ap.terfor.{RichPredicate, Term}
import ap.theories.{SaturationProcedure, Theory}
import ostrich.OstrichStringFunctionTranslator
import ostrich.OstrichStringTheory
import ostrich.automata.Automaton

import scala.collection.mutable.{MultiMap => MMultiMap}

/**
 * A SaturationProcedure for backwards propagation.
 *
 * For each x = f(y1,...,yn) collect constraints on x, propagate
 * them backwards through f, and create a new AxiomSplit:
 *
 *  assume: <x constraint> & x = f(y1,...,yn)
 *  derive: Disj of <yi constraints> in Pre(f, <x constraint>)
 *
 * For the saturation, the ApplicationPoint is (appTerm,
 * argConstraint) where appTerm is a function application as above
 * and the argConstraint is a str_in_re_id constraint on x.
 *
 * Expects str_in_re not to occur, only str_in_re_id.
 */
class BackwardsSaturation(
  val theory : OstrichStringTheory
) extends SaturationProcedure("ForwardsPropagation")
  with PropagationSaturationUtils {
  import theory.{ str_len, str_in_re_id, FunPred }

  /**
   * (funApp, argConstraint)
   * funApp -- x = f(y1, ..., yn)
   * argConstraint -- str_in_re_id(x, autid) or None for Sigma*
   */
  type ApplicationPoint = (Atom, Option[Atom])

  override def extractApplicationPoints(
    goal : Goal
  ) : Iterator[ApplicationPoint] = extractApplicationPoints(
    goal, getInitialConstraints(goal)
  )

  override def applicationPriority(goal : Goal, p : ApplicationPoint) : Int = {
    p._2 match {
      // None means arg in Sigma*
      case None => 1
      case Some(a) => {
        a.pred match {
          case `str_in_re_id` =>
            getAutomatonSize(decodeRegexId(a, false))
          // will be a str_len == 0 as we only return those
          case FunPred(`str_len`) if a(1).isZero => 1
          // will not happen
          case _ => 0
        }
      }
    }
  }

  override def handleApplicationPoint(
    goal : Goal, appPoint : ApplicationPoint
  ) : Seq[Plugin.Action] = {
    val termConstraintMap = getInitialConstraints(goal)
    // return empty if appPoint no longer relevant
    if (!extractApplicationPoints(goal, termConstraintMap).contains(appPoint))
      return List()

    val stringFunctionTranslator =
        new OstrichStringFunctionTranslator(theory, goal.facts)
    val str_in_re_id_app = new RichPredicate(str_in_re_id, goal.order)

    val (funApp, argCon) = appPoint
    val (op, args, res, formula)
      = getFunApp(stringFunctionTranslator, funApp) match {
          case Some(app) => app
          case None =>
            throw new Exception(
              "Expected a funApp in the ApplicationPoint " + appPoint
            )
        }

    val argAuts = for (a <- args)
      yield termConstraintMap.get(a)
        .map(_.map(atom => atomConstraintToAut(a, Some(atom))).toSeq)
        .getOrElse(Seq(atomConstraintToAut(a, None)))
    val resAut = atomConstraintToAut(res, argCon)

    val (newConstraints, _) = op(argAuts, resAut)
    val argCases = newConstraints.map(argCS => {
      (args zip argCS).map({ case (a, aut) =>
        val autId = autDatabase.automaton2Id(aut)
        val argTerm = LinearCombination(a, goal.order)
        val lautId = LinearCombination(IdealInt(autId))
        str_in_re_id_app(Seq(argTerm, lautId))
      })
    }).map(cs => (Conjunction.conj(cs, goal.order), Seq()))
    .toSeq

    val assumptions = (
      Seq(funApp)
      ++ argCon.map(Seq(_)).getOrElse(Seq())
      ++ args.map(termConstraintMap.get(_).getOrElse(Seq())).toSeq.flatten
    )

    logSaturation("backward propagation") {
      Seq(AxiomSplit(assumptions, argCases, theory))
    }
  }

  /**
   * Extract application points without computing term constraints
   *
   * Useful when the constraints are already known, e.g. in
   * handleApplicationPoint
   */
  private def extractApplicationPoints(
    goal : Goal, termConstraintMap : MMultiMap[Term, Atom]
  ) : Iterator[ApplicationPoint] = {
    val funApps = getFunApps(goal)

    val applicationPoints = for {
      (_, _, res, formula) <- funApps;
      regex <- termConstraintMap.get(res)
        .map(_.map(Some(_)))
        .getOrElse(Seq(None))
    } yield (formula, regex)

    applicationPoints.toIterator
  }

  override def isSoundForSat(
    theories : Seq[Theory],
    config : Theory.SatSoundnessConfig.Value) : Boolean = true
}
