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

import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.proof.theoryPlugins.Plugin.AxiomSplit
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.{Atom, Predicate}
import ap.terfor.{TerForConvenience, Term, TermOrder}
import ap.theories.{SaturationProcedure, Theory}
import ostrich.OstrichStringFunctionTranslator
import ostrich.OstrichStringTheory
import scala.collection.mutable.{HashMap => MHashMap}
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
) extends SaturationProcedure("BackwardsPropagation")
  with PropagationSaturationUtils {
  import theory.{ str_len, str_in_re_id, FunPred,strDatabase, str_++ }

  private val atomToFunApp = new MHashMap[Atom, FunAppTuple]()

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
  def computePenalty(predicate: Predicate): Int = predicate match {
    case FunPred(theory.str_++) => 100
    // Add more cases for other predicates and their respective penalties
    case _ => 0 // No penalty for other cases
  }

  def computeConstantBonus(p : ApplicationPoint) : Int = {
    var bonus = 0
    for (test <- p._1.elements){
      if (strDatabase.isConcrete(test)) {
        bonus = bonus -5
      }
    }
    bonus
  }

  override def applicationPriority(goal : Goal, p : ApplicationPoint) : Int = {
    p._2 match {
      // None means arg in Sigma* or constant string
      case None =>
        if (strDatabase.isConcrete(atomToFunApp(p._1)._3)){
          0
        }
        else{
          500
        }
      case Some(a) => {
        a.pred match {
          case `str_in_re_id` =>
            getAutomatonSize(decodeRegexId(a, false)) + computePenalty(p._1.pred) + computeConstantBonus(p)
          // will be a str_len == 0 as we only return those
          // PR: this case should never occur, the OstrichReducer will
          // replace any atom str_len(x) == 0 with x == ""!
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

    val (funApp, argCon) = appPoint
    val (op, args, res, formula)
      = getFunApp(stringFunctionTranslator, funApp) match {
          case Some(app) => app
          case None =>
            throw new Exception(
              "Expected a funApp in the ApplicationPoint " + appPoint
            )
        }

    val argAuts = for (aopt <- args)
      yield aopt match {
        case None => {
          Seq(autDatabase.anyStringAut)
        }
        case Some(a) => {
          termConstraintMap.get(a)
            .map(_.map(atom => atomConstraintToAut(a, Some(atom))).toSeq)
            .getOrElse(Seq(atomConstraintToAut(a, None)))
        }
      }
    import TerForConvenience._
    val resAut = atomConstraintToAut(res, argCon)
    val age = getAge(res, l(autDatabase.automaton2Id(resAut)), goal)
    val (newConstraints, _) = op(argAuts, resAut)
    implicit val o: TermOrder = goal.order
    // remove cases where one argument has no solutions
    val argCases = newConstraints.filter(_.forall(!_.isEmpty))
      .map(argCS => {
        (args zip argCS).collect({
          case (Some(a), aut) => {
            if (!a.isConstant) {
              // TODO REMOVE YOUnger AGEs
              conj(List(formulaTermInAut(a, aut, goal), buildAge(a,autDatabase.automaton2Id(aut), age+1, goal)))
            }
            else {
              formulaTermInAut(a, aut, goal)
            }
          }
        })
      }).map(cs => (Conjunction.conj(cs, goal.order), Seq()))
      .toSeq

    val assumptions = (
      Seq(funApp)
      ++ argCon.map(Seq(_)).getOrElse(Seq())
      ++ args.collect({
          case Some(a) =>
            termConstraintMap.get(a).getOrElse(Seq())
        }).toSeq.flatten
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
    goal : Goal, termConstraintMap : Map[Term, Seq[Atom]]
  ) : Iterator[ApplicationPoint] = {
    val funApps = getFunApps(goal)

    val applicationPoints = for {
      (op, args, res, formula) <- funApps
      regex <- termConstraintMap.get(res)
        .map(_.map(Some(_)))
        .getOrElse(Seq(None))
      if (formula.pred match {
      case FunPred(`str_++`) => {
        regex.isDefined | strDatabase.isConcrete(res)
      } // Skip if pred matches `str.++` and regex is None
      case _ => true // Include all other cases
    })
    } yield {
      atomToFunApp.put(formula, (op, args, res, formula))
      (formula, regex)
    }


    applicationPoints.toIterator
  }

  override def isSoundForSat(
    theories : Seq[Theory],
    config : Theory.SatSoundnessConfig.Value) : Boolean = true
}
