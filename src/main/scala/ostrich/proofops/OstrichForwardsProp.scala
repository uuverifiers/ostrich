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

import ostrich._
import ostrich.automata.{Automaton, BricsAutomaton}
import ostrich.preop.{ConcatPreOp, PreOp}

import ap.basetypes.IdealInt
import ap.parser.IFunction
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.proof.theoryPlugins.Plugin.AddAxiom
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
import ap.terfor.{RichPredicate, Term}

import scala.collection.breakOut
import scala.collection.mutable.{
  ArrayBuffer,
  BitSet => MBitSet,
  HashMap => MHashMap,
  MultiMap => MMultiMap,
  Set => MSet
}

object OstrichForwardsProp {
  case class TermConstraint(t : Term, aut : Automaton)
  type ConflictSet = Seq[TermConstraint]
}

/**
 * Forwards propagate constraints and return axioms
 *
 * For each x = f(y1,...,yn) collect constraints on y1,...,yn, propagate
 * them forwards through f, and create a new axiom:
 *
 *  assume: <yi constraints> & x = f(y1,...,yn)
 *  derive: x in Pre(f, <yi constraints>)
 */
class OstrichForwardsProp(goal : Goal,
                          theory : OstrichStringTheory,
                          flags : OFlags) {
  import OstrichForwardsProp._
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

  private val atoms = goal.facts.predConj
  private val regexExtractor = theory.RegexExtractor(goal)
  private val autDatabase = theory.autDatabase
  private val stringFunctionTranslator =
      new OstrichStringFunctionTranslator(theory, goal.facts)

  val rexOps : Set[IFunction] = Set(
    re_none, re_all, re_allchar, re_charrange, re_++, re_union,
    re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?,
    re_comp, re_loop, re_loop_?, re_eps, str_to_re, re_from_str,
    re_capture, re_reference, re_begin_anchor, re_end_anchor,
    re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive
  )

  // Collect a bunch of data. Always keep original formula for axiom
  // construction when returning propagation results.
  //
  // funApps -- each function application:
  //  (operation, arguments, result term, original formula containing app)
  // regexes -- each x in L constraint
  //  (x term, aut it's contained in, original formula that makes assertion)
  // lengthVars -- x = len(y) assertions
  //  (x, y)
  private val (funApps, initialConstraints, lengthVars) = {
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term, Formula)]
    val regexes = new ArrayBuffer[(Term, Automaton, Formula)]
    val lengthVars = new MHashMap[Term, Term]

    def decodeRegexId(a : Atom, complemented : Boolean) : Unit
      = a(1) match {
        case LinearCombination.Constant(id) => {
          val autOption =
            if (complemented)
              autDatabase.id2ComplementedAutomaton(id.intValueSafe)
            else
              autDatabase.id2Automaton(id.intValueSafe)

          autOption match {
            case Some(aut) =>
              regexes += ((a.head, aut, a))
            case None =>
              throw new Exception ("Could not decode regex id " + a(1))
          }
        }
        case lc =>
          throw new Exception ("Could not decode regex id " + lc)
      }

    for (a <- atoms.positiveLits) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex)
        regexes += ((a.head, aut, a))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, false)
      case FunPred(`str_len`) => {
        lengthVars.put(a(0), a(1))
        if (a(1).isZero)
          regexes += ((a(0), BricsAutomaton fromString "", a))
      }
      case FunPred(`str_char_count`) => {
        // ignore
      }
      case `str_prefixof` => {
        val rightVar = theory.StringSort.newConstant("rhs")
        funApps += ((ConcatPreOp, List(a(0), rightVar), a(1), a))
      }
      case FunPred(f) if rexOps contains f =>
        // nothing
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(a) match {
          case Some((op, args, res)) =>
            funApps += ((op(), args, res, a))
          case _ =>
            throw new Exception ("Cannot handle literal " + a)
        }
      case _ =>
        // nothing
    }
    (funApps, regexes, lengthVars)
  }

  // TODO: these will likely need calculating externally and sharing
  // between backwards and forwards
  // allTerms -- all of the terms in the formula
  // sortedFunApps -- the funApps above but grouped by result. I.e. (op,
  // args, result, formula) becomes ([(op, args, formula)], result). The
  // sorted.
  // ignoredApps -- what was missed.
  private val (allTerms, sortedFunApps, ignoredApps)
  : (Set[Term],
    Seq[(Seq[(PreOp, Seq[Term], Formula)], Term)],
    Seq[(PreOp, Seq[Term], Term, Formula)]) = {
    val argTermNum = new MHashMap[Term, Int]
    for ((_, _, res, _) <- funApps)
      argTermNum.put(res, 0)
    for ((t, _, _) <- initialConstraints)
      argTermNum.put(t, 0)
    for ((t, _) <- lengthVars)
      argTermNum.put(t, 0)
    for ((_, args, _, _) <- funApps; a <- args)
      argTermNum.put(a, argTermNum.getOrElse(a, 0) + 1)

    var ignoredApps = new ArrayBuffer[(PreOp, Seq[Term], Term, Formula)]
    var remFunApps  = funApps
    val sortedApps  = new ArrayBuffer[(Seq[(PreOp, Seq[Term], Formula)], Term)]

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

    (argTermNum.keySet.toSet, sortedApps.toSeq, ignoredApps.toSeq)
  }

  /**
   * Propagate input constraints to outputs
   *
   * Returns AddAxioms of input constraints plus funApp implying a new
   * constraint on the output variable.
   */
  def apply : Seq[Plugin.Action] = {
    // get input constraints
    val termConstraints = getTermConstraints

    val str_in_re_id_app = new RichPredicate(str_in_re_id, goal.order)

    val actions = for {
      (apps, res) <- sortedFunApps.reverseIterator;
      (op, args, formula) <- apps;
      argAuts = for (a <- args) yield termConstraints(a).map(_._1).toSeq;
      argAtoms = for (a <- args) yield termConstraints(a).map(_._2).toSeq;
      resultConstraint = op.forwardApprox(argAuts);
      autId = autDatabase.automaton2Id(resultConstraint);
      lres = LinearCombination(res, goal.order);
      lautId = LinearCombination(IdealInt(autId));
      assumptions = argAtoms.flatten ++ List(formula)
    } yield AddAxiom(
        assumptions,
        Conjunction.conj(str_in_re_id_app(Seq(lres, lautId)), goal.order),
        theory
    )

    actions.toSeq
  }

  /**
   * Map all regular constraints on variables
   *
   * Maps to the automaton the term should belong to, and the formula that
   * makes the assertion that the term is in the automaton.
   */
  private def getTermConstraints : MMultiMap[Term, (Automaton, Formula)] = {
    val termConstraints = new MHashMap[Term, MSet[(Automaton, Formula)]]
      with MMultiMap[Term, (Automaton, Formula)]

    for ((t, aut, atom) <- initialConstraints) {
      termConstraints.addBinding(t, (aut, atom))
    }

    // Make sure "implicit" constraints are taken care of also (e.g. x
    // in Sigma*)
    val term2Index =
      (for (((_, t), n) <- sortedFunApps.iterator.zipWithIndex)
        yield (t -> n)).toMap

    val coveredTerms = new MBitSet
    for ((t, _, _) <- initialConstraints)
      for (ind <- term2Index get t)
        coveredTerms += ind

    // check whether any of the terms have concrete definitions
    for (t <- allTerms)
      for (w <- strDatabase.term2List(t)) {
        val str : String = w.map(i => i.toChar)(breakOut)
        termConstraints.addBinding(
          t, (BricsAutomaton fromString str, Conjunction.TRUE)
        )
        for (ind <- term2Index get t)
          coveredTerms += ind
      }

    // add in Sigma* for all other input terms
    for (
      n <- 0 until sortedFunApps.size;
      (_, args, _) <- sortedFunApps(n)._1;
      arg <- args;
      ind <- term2Index get arg
    ) {
      if (!(coveredTerms contains ind)) {
        termConstraints.addBinding(
          arg, (BricsAutomaton.makeAnyString(), Conjunction.TRUE)
        )
        coveredTerms += ind
      }
    }

    termConstraints
  }
}
