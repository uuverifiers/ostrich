/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2024 Oliver Markgraf, Philipp Ruemmer. All rights reserved.
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
import scala.runtime.Nothing$

class OstrichPredtoEqConverter(goal : Goal,
                               theory : OstrichStringTheory,
                               flags : OFlags)  {
  import theory.{str_prefixof, str_suffixof, _str_++, _str_len, str_replace, str_contains,
                 strDatabase, str_to_int, int_to_str, str_indexof, str_at,str_empty,
                 StringSort, FunPred}
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

  def reducePosStrAt(t : Atom) : Seq[Plugin.Action] = {
    // TODO
    return List()
  }


  def reducePosPrefixToEquation(t : Atom) : Seq[Plugin.Action] = {
    /**
     * Input : prefix_of(x,y) is true iff x is prefix of y
     * y = xz
     *
     */
    import TerForConvenience._

    val builder = new FormulaBuilder(goal,theory)
    val x = t(0)
    val y = t(1)
    val z = builder.newVar(StringSort)
    builder.addConcatN(Seq(x,z),y)

    List(Plugin.RemoveFacts(conj(t)),
      Plugin.AddAxiom(Seq(conj(t)),
        builder.result, theory))
  }

  def reducePosSuffixToEquation(t : Atom) : Seq[Plugin.Action] = {
    /**
     * Input : suffix_of(x,y) is true iff x is suffix of y
     * y = zx
     *
     */
    import TerForConvenience._

    val builder = new FormulaBuilder(goal,theory)
    val x = t(0)
    val y = t(1)
    val z = builder.newVar(StringSort)
    builder.addConcatN(Seq(z,x),y)

    List(Plugin.RemoveFacts(conj(t)),
      Plugin.AddAxiom(Seq(conj(t)),
        builder.result, theory))
  }

  def reducePosContainsToEquation(t : Atom) : Seq[Plugin.Action] = {
    /**
     * Input : contains(x,y) is true iff x contains y
     * x = z1yz2
     *
     */
    import TerForConvenience._

    val builder = new FormulaBuilder(goal,theory)
    val x = t(0)
    val y = t(1)
    val z1 = builder.newVar(StringSort)
    val z2 = builder.newVar(StringSort)

    builder.addConcatN(Seq(z1,y, z2),x)

    List(Plugin.RemoveFacts(conj(t)),
      Plugin.AddAxiom(Seq(conj(t)),
        builder.result, theory))
  }


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

  def rewriteStrReplace(a : Atom) : Seq[Plugin.Action] = {
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
  }

  def rewriteStrReplaceToEquation(a : Atom) : Seq[Plugin.Action] = {
    //println(s"enter rewrite with ${a}")
    import TerForConvenience._
    val x = a(0)
    val y = a(1)
    val replace = a(2)
    val result = a(3)
    val builder = new FormulaBuilder(goal, theory)
    val newVars = for (_ <- 0 to 1) yield builder.newVar(StringSort)

    builder.addConcatN(Seq(newVars(0),replace,newVars(1)), result)
    builder.addConcatN(Seq(newVars(0),y,newVars(1)), x)
    builder.addNegContains(newVars(0), y)
    val ax1 = builder.buildContains(x,y)

    val builder1 = new FormulaBuilder(goal, theory)
    builder1.addConcatN(Seq(x), result)

    val builder2 = new FormulaBuilder(goal, theory)
    builder2.addConcatN(Seq(replace, x), result)
    val formula = conj(Seq(y) === 0)
    //println(s"froula $formula")

    val case1 = (conj(ax1, builder.result), Seq())
    //val case1 = (conj(a),List())

    val case2 = (conj(!conj(ax1), builder1.result),Seq(Plugin.RemoveFacts(conj(a))))
    //println(s"case1: $case1")
    val case3 = (conj(formula, builder2.result), Seq(Plugin.RemoveFacts(conj(a))))
    //println(s"case2: $case2")

    val action = Plugin.AxiomSplit(Seq(a), Seq(case1,case2, case3),theory)
    //val action1 = Plugin.RemoveFacts(conj(a))
    //val action2 = Plugin.AddAxiom(Seq(conj(a)), (conj(ax1, builder.result, !conj(negContains1)) | conj(!conj(ax1), builder1.result)), theory)
    //println(s"x $x y $y replace $replace result $result")
    //Seq(action1,action2)
    //println(s"return the action $action")
    Seq(action)


  }

  def removeEquationInStrReplace(a : Atom) : Seq[Plugin.Action] = {
    //println(s"enter rewrite with ${a}")
    import TerForConvenience._
    val x = a(0)
    val y = a(1)
    val replace = a(2)
    val result = a(3)
    val builder = new FormulaBuilder(goal, theory)

    Seq()


  }

  private def enumIntValues(lc : LinearCombination) : Option[Plugin.Action] =
    for (t <- Some(lc);
         if !t.isConstant;
         enumAtom = conj(theory.IntEnumerator.enumIntValuesOf(t, order));
         if !goal.reduceWithFacts(enumAtom).isTrue)
    yield Plugin.AddAxiom(List(), enumAtom, theory)

  def enumIndexofStartIndex(a : Atom) : Seq[Plugin.Action] =
    if (a(0).isConstant && a(1).isConstant) {
      enumIntValues(a(2)) match {
        case Some(act) => {
          val bigStr = strDatabase.term2ListGet(a(0))
          List(Plugin.CutSplit((a(2) >= 0) & (a(2) <= bigStr.size),
                               List(act), List()))
        }
        case None =>
          List()
      }
    } else {
      List()
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
   *  are literals of str_prefix, str_suffix and positive literals of
   *  str_replace, str_to_int, str_contains
   *
   * @return Sequences of Actions to be executed
   */
  def reducePredicatesToEquations : Seq[Plugin. Action] = {

    //println(s"facts: $facts")
    val a = (for (lit <- predConj.negativeLitsWithPred(str_prefixof);
                  act <- reduceNegPrefixToEquation(lit)) yield act)

    val b = (for (lit <- predConj.negativeLitsWithPred(str_suffixof);
                  act <- reduceNegSuffixToEquation(lit)) yield act)
    val c = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_replace));
                  act <- rewriteStrReplace(lit)) yield act)
    val c1 = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_replace));
                  act <- removeEquationInStrReplace(lit)) yield act)

    val d = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_to_int));
                  len <- (lengthMap get lit(0)).toSeq;
                  act <- propStrToIntLength(lit, len)) yield act)

    val e = (for (lit <- predConj.positiveLitsWithPred(str_prefixof);
                  act <- reducePosPrefixToEquation(lit)) yield act)

    val f = (for (lit <- predConj.positiveLitsWithPred(str_suffixof);
                  act <- reducePosSuffixToEquation(lit)) yield act)

    val g = (for (lit <- predConj.positiveLitsWithPred(str_contains);
                  act <- reducePosContainsToEquation(lit)) yield act)


    a ++ b ++ c ++ d ++ e ++ f ++ g
  }

  def lazyEnumeration : Seq[Plugin.Action] = {
    val a = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_to_int));
                  act <- enumIntValues(lit.last).toSeq) yield act)

    val b = (for (lit <- predConj.positiveLitsWithPred(FunPred(int_to_str));
                  act <- enumIntValues(lit.head).toSeq) yield act)

    val c = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_indexof));
                  act <- enumIndexofStartIndex(lit)) yield act)
    val d = (for (lit <- predConj.positiveLitsWithPred(FunPred(str_replace));
              act <- rewriteStrReplaceToEquation(lit)) yield act)

    a ++ b ++ c ++ d
  }

}
