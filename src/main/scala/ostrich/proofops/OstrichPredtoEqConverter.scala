/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022 Oliver Markgraf, Philipp Ruemmer. All rights reserved.
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

import ap.basetypes.IdealInt
import ap.parameters.Param
import ap.proof.ModelSearchProver
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.terfor.TerForConvenience.l
import ap.terfor.{ConstantTerm, Formula, TerForConvenience, Term, VariableTerm}
import ap.terfor.conjunctions.{Conjunction, NegatedConjunctions, ReduceWithConjunction}
import ap.terfor.preds.Atom
import ap.terfor.linearcombination.LinearCombination
import ap.types.Sort
import TerForConvenience._
import ap.basetypes.IdealInt.ZERO

import scala.::
import scala.collection.mutable
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

class OstrichPredtoEqConverter(goal : Goal,
                               theory : OstrichStringTheory,
                               flags : OFlags)  {
  import theory.{str_prefixof, str_suffixof, _str_++, _str_len, str_replace,
                 strDatabase, str_to_int, int_to_str, StringSort, FunPred}
  import OFlags.debug
  import TerForConvenience._

  implicit val order = goal.order

  val facts        = goal.facts
  val predConj     = facts.predConj
  val concatLits   = predConj.positiveLitsWithPred(_str_++)
  val concatPerRes = concatLits groupBy (_(2))
  val lengthLits   = predConj.positiveLitsWithPred(_str_len)
  val lengthMap    = (for (a <- lengthLits.iterator) yield (a(0), a(1))).toMap

  def resolveConcat(t : LinearCombination)
  : Option[(LinearCombination, LinearCombination)] =
    for (lits <- concatPerRes get t) yield (lits.head(0), lits.head(1))

  def reduceNegPrefixToEquation(t : Atom) : Seq[Plugin.Action] = {
    /**
     * Extract the left variable x and the right variable y
     * Create 5 new vars, a,b,b',c,c'
     * add the concatenations to the form:
     *  x = abc
     *  y = ab'c'
     * add new inequality form:
     *  b != b'
     * add new length constraint:
     *  len(b) = 1
     *  len(b') = 1
     *  return as actions:
     *  remove negated t
     *  add new axioms from the matrix
     */

    import TerForConvenience._

    val builder = new FormulaBuilder(goal, theory)
    val x = t(0)
    val y = t(1)
    val newVars = for (_ <- 0 to 4) yield builder.newVar(StringSort)
    builder.addConcatN(Seq(newVars(0),newVars(1),newVars(2)), x)
    builder.addConcatN(Seq(newVars(0),newVars(3),newVars(4)), y)
    builder.addConjunct(newVars(1) =/= newVars(3))
    builder.setLength(newVars(1), LinearCombination.ONE)
    builder.setLength(newVars(3), LinearCombination.ONE)

    val lengthBuilder = new FormulaBuilder(goal, theory)
    lengthBuilder.addConjunct(lengthBuilder.lengthOfTerm(x) >
                                lengthBuilder.lengthOfTerm(y))

    List(Plugin.RemoveFacts(!conj(t)),
         Plugin.AddAxiom(Seq(!conj(t)),
                         builder.result | lengthBuilder.result, theory))
  }


  def reduceNegSuffixToEquation(t : Atom) : Seq[Plugin.Action] = {
    /**
     * Extract the left variable x and the right variable y
     * Create 5 new vars, a,b,b',c,c'
     * add the concatenations to the form:
     *  x = abc
     *  y = a'b'c
     * add new inequality form:
     *  b != b'
     * add new length constraint:
     *  len(b) = 1
     *  len(b') = 1
     *  return as actions:
     *  remove negated t
     *  add new axioms from the matrix
     */

    import TerForConvenience._

    val builder = new FormulaBuilder(goal, theory)
    val vars = t.constants.toSeq
    // find correct variable with the constant term?

    val x = t(0)
    val y = t(1)
    val newVars = for (_ <- 0 to 4) yield builder.newVar(StringSort)
    builder.addConcatN(Seq(newVars(0),newVars(1),newVars(2)), x)
    builder.addConcatN(Seq(newVars(3),newVars(4),newVars(2)), y)
    builder.addConjunct(newVars(1) =/= newVars(4))
    builder.setLength(newVars(1), LinearCombination.ONE)
    builder.setLength(newVars(4), LinearCombination.ONE)

    val lengthBuilder = new FormulaBuilder(goal, theory)
    lengthBuilder.addConjunct(lengthBuilder.lengthOfTerm(x) >
                                lengthBuilder.lengthOfTerm(y))

    List(Plugin.RemoveFacts(!conj(t)),
         Plugin.AddAxiom(Seq(!conj(t)),
                         builder.result | lengthBuilder.result,
                         theory))
  }

  def rewriteStrReplace(a : Atom) : Seq[Plugin.Action] =
    if (strDatabase.hasValue(a(0), List())) {
      import TerForConvenience._
      List(
        Plugin.RemoveFacts(conj(a)),
        Plugin.AddAxiom(Seq(conj(a)),
                        ((a(0) === a(1)) & (a(2) === a(3))) |
                          ((a(0) =/= a(1)) & (a(0) === a(3))),
                        theory)
      )
    } else {
      List()
    }

  def enumStrToIntValues(a : Atom) : Seq[Plugin.Action] = {
    for (lit <- List(a);
         if !a.last.isConstant;
         enumAtom = conj(theory.IntEnumerator.enumIntValuesOf(a.last, order));
         if !goal.reduceWithFacts(enumAtom).isTrue)
    yield Plugin.AddAxiom(List(), enumAtom, theory)
  }

  def enumIntToStrValues(a : Atom) : Seq[Plugin.Action] = {
    for (lit <- List(a);
         if !a.head.isConstant;
         enumAtom = conj(theory.IntEnumerator.enumIntValuesOf(a.head, order));
         if !goal.reduceWithFacts(enumAtom).isTrue)
    yield Plugin.AddAxiom(List(), enumAtom, theory)
  }

  def propStrToIntLength(a : Atom, len : Term) : Seq[Plugin.Action] = {
    (for (IdealInt(bound) <- goal.reduceWithFacts.upperBound(len);
          constraint = (a(1) >= -1) & a(1) <= ((IdealInt(10) pow bound) - 1);
          if !goal.reduceWithFacts(constraint).isTrue) yield {
       Plugin.AddAxiom(List(), // TODO
                       constraint,
                       theory)
     }).toSeq
  }

  /**
   *  Convert predicates to equations. Supported predicates at the moment
   *  are negative literals of str_prefix
   *
   * @return Sequences of Actions to be executed
   */
  def reducePredicatesToEquations : Seq[Plugin. Action] = {
    //TODO rewrite positive prefix, suffix, contains

    val a = (for (lit <- predConj.negativeLitsWithPred(str_prefixof);
                  act <- reduceNegPrefixToEquation(lit)) yield act)

    val b = (for (lit <- predConj.negativeLitsWithPred(str_suffixof);
                  act <- reduceNegPrefixToEquation(lit)) yield act)

    val c = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_replace));
                  act <- rewriteStrReplace(lit)) yield act)

    val d = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_to_int));
                  len <- (lengthMap get lit(0)).toSeq;
                  act <- propStrToIntLength(lit, len)) yield act)

    a ++ b ++ c ++ d
  }

  def lazyEnumeration : Seq[Plugin.Action] = {
    val a = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_to_int));
                  act <- enumStrToIntValues(lit)) yield act)

    val b = (for (lit <- predConj.positiveLitsWithPred(FunPred(int_to_str));
                  act <- enumIntToStrValues(lit)) yield act)

    a ++ b
  }

}
