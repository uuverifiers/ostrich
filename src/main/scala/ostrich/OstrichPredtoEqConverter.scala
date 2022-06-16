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

package ostrich

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
                 strDatabase, StringSort, FunPred}
  import OFlags.debug
  import TerForConvenience._

  implicit val order = goal.order

  val facts        = goal.facts
  val predConj     = facts.predConj
  val concatLits   = predConj.positiveLitsWithPred(_str_++)
  val concatPerRes = concatLits groupBy (_(2))
  val lengthLits   = predConj.positiveLitsWithPred(_str_len)
  val lengthMap = collection.mutable.Map((for (a <- lengthLits.iterator) yield (a(0), a(1))).toMap.toSeq: _*)

  val prefixNegLits = predConj.negativeLitsWithPred(str_prefixof)
  val suffixNegLits = predConj.negativeLitsWithPred(str_suffixof)

  val replaceLits = predConj.positiveLitsWithPred(FunPred(str_replace))

  class FormulaBuilder {
    // TODO: Class got restructured?
    import TerForConvenience._

    val varSorts   = new ArrayBuffer[Sort]
    // Array of sorts, a sort has a theory and can evaluate terms see OstrichStringSort, Integer, Fun, Constant, Var
    val matrixFors = new ArrayBuffer[Formula]
    val varLengths = new MHashMap[VariableTerm, Term]
    // map that remembers which variable has the same length as which term?

    def newVar(s : Sort) : VariableTerm = {
      val res = VariableTerm(varSorts.size)
      // VarTerm takes integer as input
      varSorts += s
      res
    }

    def lengthFor2(t : Term) : Term =
      t match {
        case t : VariableTerm =>
          varLengths.getOrElseUpdate(t, {
            val len = newVar(Sort.Integer)
            matrixFors += _str_len(List(l(t), l(len)))
            matrixFors += l(len) >= 0
            len
          })
        case _ =>
          lengthFor(t)
      }

    def addConcat(left : Term, right : Term, res : Term) : Unit = {
      matrixFors += _str_++(List(l(left),l(right),l(res)))
      matrixFors += lengthFor2(left) + lengthFor2(right) === lengthFor2(res)
    }

    def addConcatN(terms : Seq[Term], res : Term) : Unit =
      terms match {
        case Seq(t) =>
          matrixFors += t === res
        case terms => {
          assert(terms.size > 1)
          val prefixes =
            (for (_ <- (2 until terms.size).iterator)
              yield newVar(StringSort)) ++ Iterator(res)
              // for all terms create a new string variable and end up with an iterator over all of them and the result
          // Frage: Warum kein neue Var für res? Warum überaupt neue Var, können die Terms nicht schon neue Vars sein?
          // weil wir n neue concat erstellen, deswegen auch der Name
          terms reduceLeft[Term] {
            case(t1,t2) => {
              val s = prefixes.next
              addConcat(t1,t2,s)
              s
            }
          }
        }
      }

    def addLength(term1 : Term, term2 : Term) : Unit = {
      matrixFors += _str_len(List(l(term1),l(term2)))
    }

    def addInequality(term1 : Term, term2 : Term) : Unit = {
      matrixFors += l(term1) =/= l(term2)
    }

    def generateGreaterThanLengthConstraint(term1 : Term, term2 : Term) : Formula = {
      (lengthFor2(term1)) > lengthFor2(term2) &
        _str_len(List(l(term1),l(lengthFor2(term1)))) &
        _str_len(List(l(term2),l(lengthFor2(term2))))
    }

    def addGreaterThanLengthConstraint(term1 : Term, term2 : Term) : Unit = {
      matrixFors += (lengthFor2(term1)) > lengthFor2(term2)
    }

    def addNewLengthVar(term : Term) : Unit = {
      val len = newVar(Sort.Integer)
      lengthMap += (l(term) -> l(len))
    }

    def result =
      existsSorted(varSorts.toSeq, conj(matrixFors))

    def resultDisj(term1 : Term, term2 : Term) =
      existsSorted(varSorts.toSeq, conj(matrixFors) | (conj(generateGreaterThanLengthConstraint(term1, term2)) ))
  }

  def resolveConcat(t : LinearCombination)
  : Option[(LinearCombination, LinearCombination)] =
    for (lits <- concatPerRes get t) yield (lits.head(0), lits.head(1))

  def lengthFor(t : LinearCombination) : LinearCombination =
    if (strDatabase isConcrete t)
      LinearCombination((strDatabase term2ListGet t).size)
    else
      lengthMap(t)

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

    val builder = new FormulaBuilder
    val x = t(0)
    builder.addNewLengthVar(x)
    val y = t(1)
    builder.addNewLengthVar(y)
    val newVars = for (_ <- 0 to 4) yield builder.newVar(StringSort)
    builder.addConcatN(Seq(newVars(0),newVars(1),newVars(2)), x)
    builder.addConcatN(Seq(newVars(0),newVars(3),newVars(4)), y)
    builder.addInequality(newVars(1),newVars(3))
    builder.addLength(newVars(1), LinearCombination.ONE)
    builder.addLength(newVars(3), LinearCombination.ONE)

    val lengthBuilder = new FormulaBuilder
    lengthBuilder.addGreaterThanLengthConstraint(x,y)
    lengthBuilder.addLength(x, lengthMap(x))
    lengthBuilder.addLength(y, lengthMap(y))
    List(Plugin.RemoveFacts(!conj(t)), Plugin.AddAxiom(Seq(!conj(t)), builder.result | lengthBuilder.result, theory))
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

    val builder = new FormulaBuilder
    val vars = t.constants.toSeq
    // find correct variable with the constant term?

    val x = t(0)
    builder.addNewLengthVar(x)
    val y = t(1)
    builder.addNewLengthVar(y)
    val newVars = for (_ <- 0 to 4) yield builder.newVar(StringSort)
    builder.addConcatN(Seq(newVars(0),newVars(1),newVars(2)), x)
    builder.addConcatN(Seq(newVars(3),newVars(4),newVars(2)), y)
    builder.addInequality(newVars(1),newVars(4))
    builder.addLength(newVars(1), LinearCombination.ONE)
    builder.addLength(newVars(4), LinearCombination.ONE)

    val lengthBuilder = new FormulaBuilder
    lengthBuilder.addGreaterThanLengthConstraint(x,y)
    lengthBuilder.addLength(x, lengthMap(x))
    lengthBuilder.addLength(y, lengthMap(y))

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

  /**
   *  Convert predicates to equations. Supported predicates at the moment
   *  are negative literals of str_prefix
   *
   * @return Sequences of Actions to be executed
   */
  def reducePredicatesToEquations : Seq[Plugin. Action] = {
    //TODO rewrite positive prefix, suffix, contains

    val a = (for (lit <- prefixNegLits;
                  act <- reduceNegPrefixToEquation(lit)) yield act)

    val b = (for (lit <- suffixNegLits;
                  act <- reduceNegPrefixToEquation(lit)) yield act)

    val c = (for (lit <- replaceLits;
                  act <- rewriteStrReplace(lit)) yield act)

    a ++ b ++ c
  }

}
