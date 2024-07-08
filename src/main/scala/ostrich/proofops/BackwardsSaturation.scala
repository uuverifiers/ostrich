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
import ap.theories.SaturationProcedure
import ap.util.Combinatorics.cartesianProduct
import ostrich._
import ostrich.automata.{Automaton, BricsAutomaton, AtomicStateAutomaton}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.preop.{ConcatPreOp, PreOp}
import scala.util.Random

import scala.collection.breakOut
import scala.collection.mutable.{
  ArrayBuffer,
  BitSet => MBitSet,
  HashMap => MHashMap,
  MultiMap => MMultiMap,
  Set => MSet
}

object BackwardsSaturation {
  case class TermConstraint(t : Term, aut : Automaton)
  type ConflictSet = Seq[TermConstraint]
}

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
  theory : OstrichStringTheory
) extends SaturationProcedure("ForwardsPropagation") {
  import theory.{
    str_from_char, str_len, str_empty, str_cons, str_++, str_in_re,
    str_char_count, str_in_re_id, str_to_re, re_from_str,
    re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive,
    str_replace, str_replacere, str_replaceall, str_replaceallre,
    str_prefixof, re_none, re_all, re_allchar, re_charrange, re_++,
    re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt,
    re_opt_?, re_comp, re_loop, re_loop_?, re_eps, re_capture,
    re_reference, re_begin_anchor, re_end_anchor, FunPred, strDatabase
  }

  /**
   * (funApp, argConstraint)
   * funApp -- x = f(y1, ..., yn)
   * argConstraint -- str_in_re_id(x, autid) or None for Sigma*
   */
  type ApplicationPoint = (Atom, Option[Atom])

  val rexOps : Set[IFunction] = Set(
    re_none, re_all, re_allchar, re_charrange, re_++, re_union,
    re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?,
    re_comp, re_loop, re_loop_?, re_eps, str_to_re, re_from_str,
    re_capture, re_reference, re_begin_anchor, re_end_anchor,
    re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive
  )

  val autDatabase = theory.autDatabase

  override def extractApplicationPoints(
    goal : Goal
  ) : Iterator[ApplicationPoint] = {
    val funApps = getFunApps(goal)
    val termConstraintMap = getInitialConstraints(goal)
    val sortedFunApps = sortFunApps(funApps, termConstraintMap)

    val applicationPoints = for {
      (apps, res) <- sortedFunApps;
      (_, _, formula) <- apps;
      regex <- termConstraintMap.get(res)
        .map(_.map(Some(_)))
        .getOrElse(Seq(None))
    } yield (formula, regex)

    applicationPoints.toIterator
  }

  override def applicationPriority(goal : Goal, p : ApplicationPoint) : Int = {
    val regexExtractor = theory.RegexExtractor(goal)
    p._2 match {
      // None means arg in Sigma*
      case None => 1
      case Some(a) => {
        a.pred match {
          case `str_in_re_id` =>
            getAutomatonSize(decodeRegexId(a, false))
          // will be a str_len == 0 as we only return those
          case FunPred(`str_len`) => 1
          // will not happen
          case _ => 0
        }
      }
    }
  }

  override def handleApplicationPoint(
    goal : Goal, appPoint : ApplicationPoint
  ) : Seq[Plugin.Action] = {
    // return empty if appPoint no longer relevant
    if (!extractApplicationPoints(goal).contains(appPoint))
      return List()

    val stringFunctionTranslator =
        new OstrichStringFunctionTranslator(theory, goal.facts)
    val regexExtractor = theory.RegexExtractor(goal)
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

    // TODO: is it better to compute argument constraints anew based on
    // latest goal or reuse the one we build for finding application
    // points? At any rate, we already compute it when checking the goal
    // is still relevant, so refactor to avoid computing it twice.
    // In backwards propagation, the constraints on the arguments are
    // used to avoid constraints on yi being to general / too many
    // disjunctions
    val termConstraintMap = getInitialConstraints(goal)

    val argAuts = for (a <- args)
      yield termConstraintMap(a)
        .map(atom => applicationPointAtomToAut(a, Some(atom)))
        .toSeq
    val resAut = applicationPointAtomToAut(res, argCon)

    val (newConstraints, _) = op(argAuts, resAut)
    val argConstraints = for {
      argCS <- newConstraints;
      (a, aut) <- args zip argCS
      autId = autDatabase.automaton2Id(aut)
      argTerm = LinearCombination(a, goal.order)
      lautId = LinearCombination(IdealInt(autId))
    } yield str_in_re_id_app(Seq(argTerm, lautId))

    val argCases = argConstraints.map(
      r => (Conjunction.conj(r, goal.order), Seq())
    ).toSeq

    // TODO: is the assumption really just funApp -- don't we need the
    // constraints on the result and the ones on the argument we used
    // for optimisation?
    Seq(AxiomSplit(Seq(funApp), argCases, theory))
  }

  /**
   * Convert an atom in one of our application points to Automaton
   *
   * Throws exception if not of the expected format (i.e. the atom came
   * from somewhere other than an application point.
   *
   * @param term the term the constraint applies to
   * @constraint the constraint or None if there is no constraint (will
   * try to find a concrete def of term instead)
   */
  private def applicationPointAtomToAut(
    term : Term, constraint : Option[Atom]
  ) : Automaton = {
    constraint match {
      // None means arg in Sigma*...
      case None => {
        // but might have a concrete def
        strDatabase.term2List(term).map({ w =>
          val str : String = w.map(i => i.toChar)(breakOut)
          BricsAutomaton.fromString(str)
        }).getOrElse(BricsAutomaton.makeAnyString())
      }
      case Some(a) => {
        a.pred match {
          case `str_in_re_id` =>
            decodeRegexId(a, false)
          // will be a str_len == 0 as we only return those
          case FunPred(`str_len`) =>
            BricsAutomaton.fromString("")
          // will not happen
          case _ => {
            throw new Exception ("Cannot handle literal " + a)
          }
        }
      }
    }
  }

  private def getAutomatonSize(aut : Automaton) : Int = {
    aut match {
      case automaton: AtomicStateAutomaton => automaton.states.size
      case base: CostEnrichedAutomatonBase => base.states.size
      case _ => 0
    }
  }

  private def isNotNonZeroLenConstraint(a : Atom) : Boolean = {
    a.pred match {
      case FunPred(`str_len`) => a(1).isZero
      case _ => true
    }
  }

  private def getFunApps(
    goal : Goal
  ) : Seq[(PreOp, Seq[Term], Term, Atom)] = {
    val atoms = goal.facts.predConj
    val stringFunctionTranslator =
        new OstrichStringFunctionTranslator(theory, goal.facts)

    // Collect a bunch of data. Always keep original formula for axiom
    // construction when returning propagation results.
    //
    // funApps -- each function application:
    //  (operation, arguments, result term, original formula containing app)
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term, Atom)]

    for (a <- atoms.positiveLits)
      getFunApp(stringFunctionTranslator, a).foreach(funApps += _)

    funApps
  }

  /**
   * Split a fun app atom into (op, args, atom)
   *
   * Or None if not a fun app
   */
  private def getFunApp(
    stringFunctionTranslator : OstrichStringFunctionTranslator,
    a : Atom
  ) : Option[(PreOp, Seq[Term], Term, Atom)] = {
    a.pred match {
      case `str_prefixof` => {
        val rightVar = theory.StringSort.newConstant("rhs")
        Some((ConcatPreOp, List(a(0), rightVar), a(1), a))
      }
      case FunPred(f) if rexOps contains f =>
        None
      // next three cases prevent exception for supported string
      // functions that aren't apps
      case `str_in_re` =>
        None
      case `str_in_re_id` =>
        None
      case FunPred(`str_char_count`) =>
        None
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(a) match {
          case Some((op, args, res)) =>
            Some((op(), args, res, a))
          case _ =>
            throw new Exception ("Cannot get fun app from literal " + a)
        }
      case _ =>
        None
    }
  }

  private def sortFunApps(
    funApps : Seq[(PreOp, Seq[Term], Term, Atom)],
    termConstraints : MMultiMap[Term, Atom]
  ) : Seq[(Seq[(PreOp, Seq[Term], Atom)], Term)] = {
    val argTermNum = new MHashMap[Term, Int]
    for ((_, _, res, _) <- funApps)
      argTermNum.put(res, 0)
    for ((t, _) <- termConstraints)
      argTermNum.put(t, 0)
    for ((_, args, _, _) <- funApps; a <- args)
      argTermNum.put(a, argTermNum.getOrElse(a, 0) + 1)

    var ignoredApps = new ArrayBuffer[(PreOp, Seq[Term], Term, Atom)]
    var remFunApps  = funApps
    val sortedApps  = new ArrayBuffer[(Seq[(PreOp, Seq[Term], Atom)], Term)]

    while (!remFunApps.isEmpty) {
      val (selectedApps, otherApps) =
        remFunApps partition { case (_, _, res, _) =>
          argTermNum(res) == 0 ||
            strDatabase.isConcrete(res) }

      if (selectedApps.isEmpty) {
        if (ignoredApps.isEmpty)
          Console.err.println(
            "Warning: cyclic definitions found, ignoring some function " +
              "applications")
        ignoredApps += remFunApps.head
        remFunApps = remFunApps.tail
      } else {
        remFunApps = otherApps

        for ((_, args, _, _) <- selectedApps; a <- args)
          argTermNum.put(a, argTermNum.getOrElse(a, 0) - 1)

        val appsPerRes = selectedApps groupBy (_._3)
        val nonArgTerms = (selectedApps map (_._3)).distinct

        for (t <- nonArgTerms)
          sortedApps +=
            ((for ((op, args, _, f) <- appsPerRes(t)) yield (op, args, f), t))
      }
    }

    sortedApps.toSeq
  }

  /**
   * Get initial constraints on string vars
   *
   * The atom will be str_in_re_id, or a str_len constraint
   */
  private def getInitialConstraints(goal: Goal) : MMultiMap[Term, Atom] = {
    val atoms = goal.facts.predConj
    val stringFunctionTranslator =
        new OstrichStringFunctionTranslator(theory, goal.facts)

    val termConstraints = new MHashMap[Term, MSet[Atom]]
      with MMultiMap[Term, Atom]

    for (a <- atoms.positiveLits) a.pred match {
      case `str_in_re_id` => termConstraints.addBinding(a(0), a)
      case FunPred(`str_len`) => termConstraints.addBinding(a(0), a)
      case _ => // nothing
    }

    termConstraints
  }

  def decodeRegexId(a : Atom, complemented : Boolean) : Automaton = {
    a(1) match {
      case LinearCombination.Constant(id) => {
        val autOption
          = if (complemented)
            autDatabase.id2ComplementedAutomaton(id.intValueSafe)
          else
            autDatabase.id2Automaton(id.intValueSafe)

        autOption match {
          case Some(aut) => aut
          case None => throw new Exception ("Could not decode regex id " + a(1))
        }
      }
      case lc =>
        throw new Exception ("Could not decode regex id " + lc)
    }
  }
}
