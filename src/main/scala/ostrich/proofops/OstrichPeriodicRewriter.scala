/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf, Philipp Ruemmer. All rights reserved.
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

import ostrich._
import ostrich.automata.AutomataUtils

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.{Term, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap, HashSet => MHashSet}

class OstrichPeriodicRewriter(goal : Goal,
                              theory : OstrichStringTheory) {
  import theory.{_str_++, str_contains, str_in_re_id, str_prefixof,
                 str_suffixof, strDatabase, autDatabase}
  import TerForConvenience._

  implicit val order = goal.order

  private val facts      = goal.facts
  private val predConj   = facts.predConj
  private val concatLits = predConj.positiveLitsWithPred(_str_++)
  private val concatPerRes =
    concatLits groupBy (_(2))
  private val regexLitsPerTerm =
    predConj.positiveLitsWithPred(str_in_re_id) groupBy (_(0))

  private val rootCache      = new MHashMap[Term, Option[Seq[Int]]]
  private val rootInProgress = new MHashSet[Term]

  def handleGoal : Seq[Plugin.Action] =
    rewriteNegContains ++ rewriteNegPrefixes ++
      rewriteNegSuffixes ++ rewriteNegEquations

  private def rewriteNegContains : Seq[Plugin.Action] =
    for (lit <- predConj.negativeLitsWithPred(str_contains);
         if haveSamePeriodicRoot(lit(0), lit(1));
         act <- rewriteNegContains(lit))
    yield act

  private def rewriteNegContains(lit : Atom) : Seq[Plugin.Action] = {
    val builder = new FormulaBuilder(goal, theory)
    builder.addConjunct(builder.lengthOfTerm(lit(0)) < builder.lengthOfTerm(lit(1)))

    List(
      Plugin.RemoveFacts(!conj(lit)),
      Plugin.AddAxiom(Seq(!conj(lit)), builder.result, theory)
    )
  }

  private def rewriteNegPrefixes : Seq[Plugin.Action] =
    for (lit <- predConj.negativeLitsWithPred(str_prefixof);
         if haveSamePeriodicRoot(lit(0), lit(1));
         act <- rewriteNegPrefix(lit))
    yield act

  private def rewriteNegPrefix(lit : Atom) : Seq[Plugin.Action] = {
    val builder = new FormulaBuilder(goal, theory)
    builder.addConjunct(builder.lengthOfTerm(lit(0)) > builder.lengthOfTerm(lit(1)))

    List(
      Plugin.RemoveFacts(!conj(lit)),
      Plugin.AddAxiom(Seq(!conj(lit)), builder.result, theory)
    )
  }

  private def rewriteNegSuffixes : Seq[Plugin.Action] =
    for (lit <- predConj.negativeLitsWithPred(str_suffixof);
         if haveSamePeriodicRoot(lit(0), lit(1));
         act <- rewriteNegSuffix(lit))
    yield act

  private def rewriteNegSuffix(lit : Atom) : Seq[Plugin.Action] = {
    val builder = new FormulaBuilder(goal, theory)
    builder.addConjunct(builder.lengthOfTerm(lit(0)) > builder.lengthOfTerm(lit(1)))

    List(
      Plugin.RemoveFacts(!conj(lit)),
      Plugin.AddAxiom(Seq(!conj(lit)), builder.result, theory)
    )
  }

  private def rewriteNegEquations : Seq[Plugin.Action] =
    for (lc <- facts.arithConj.negativeEqs.toSeq;
         (left, right) <- disequalityTerms(lc).toSeq;
         if haveSamePeriodicRoot(left, right);
         act <- rewriteNegEquation(lc, left, right))
    yield act

  private def rewriteNegEquation(lc : LinearCombination,
                                 left : Term,
                                 right : Term) : Seq[Plugin.Action] = {
    val disequality = conj(lc =/= 0)
    val builder = new FormulaBuilder(goal, theory)
    builder.addConjunct(builder.lengthOfTerm(left) =/= builder.lengthOfTerm(right))

    List(
      Plugin.RemoveFacts(disequality),
      Plugin.AddAxiom(Seq(disequality), builder.result, theory)
    )
  }

  private def disequalityTerms(lc : LinearCombination) : Option[(Term, Term)] =
    lc match {
      case Seq((IdealInt.ONE, left), (IdealInt.MINUS_ONE, right)) =>
        Some((left, right))
      case Seq((IdealInt.MINUS_ONE, left), (IdealInt.ONE, right)) =>
        Some((left, right))
      case _ =>
        None
    }

  private def haveSamePeriodicRoot(left : Term, right : Term) : Boolean =
    (for (leftRoot <- termPeriodicRoot(left);
          rightRoot <- termPeriodicRoot(right))
     yield leftRoot == rightRoot).getOrElse(false)

  private def termPeriodicRoot(term : Term) : Option[Seq[Int]] =
    rootCache.get(term) match {
      case Some(root) =>
        root
      case None if rootInProgress(term) =>
        None
      case None =>
        rootInProgress += term
        val root =
          try {
            computeTermPeriodicRoot(term)
          } finally {
            rootInProgress -= term
          }
        rootCache.put(term, root)
        root
    }

  private def computeTermPeriodicRoot(term : Term) : Option[Seq[Int]] = {
    val roots = new ArrayBuffer[Seq[Int]]

    strDatabase.term2List(term) match {
      case Some(word) if word.nonEmpty =>
        roots += AutomataUtils.primitiveRoot(word)
      case _ =>
    }

    for (lit <- regexLitsPerTerm.getOrElse(term, Vector.empty);
         root <- autDatabase.periodicRoot(lit(1).constant.intValueSafe))
      roots += root

    for (lit <- concatPerRes.getOrElse(term, Vector.empty);
         leftRoot <- termPeriodicRoot(lit(0));
         rightRoot <- termPeriodicRoot(lit(1));
         if leftRoot == rightRoot)
      roots += leftRoot

    commonRoot(roots)
  }

  private def commonRoot(roots : Seq[Seq[Int]]) : Option[Seq[Int]] =
    roots.headOption.filter(root => roots.forall(_ == root))
}
