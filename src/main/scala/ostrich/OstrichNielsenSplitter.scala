/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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
import ap.proof.ModelSearchProver
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.terfor.{ConstantTerm, VariableTerm, Formula, Term, TerForConvenience}
import ap.terfor.conjunctions.{Conjunction, ReduceWithConjunction}
import ap.terfor.preds.Atom
import ap.terfor.linearcombination.LinearCombination
import ap.types.Sort

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

class OstrichNielsenSplitter(goal : Goal,
                             theory : OstrichStringTheory,
                             flags : OFlags) {
  import theory.{_str_++, _str_len, strDatabase, StringSort}
  import OFlags.debug

  val order        = goal.order
  val X            = new ConstantTerm("X")
  val extOrder     = order extend X

  val facts        = goal.facts
  val predConj     = facts.predConj
  val concatLits   = predConj.positiveLitsWithPred(_str_++)
  val concatPerRes = concatLits groupBy (_(2))
  val lengthLits   = predConj.positiveLitsWithPred(_str_len)
  val lengthMap    = (for (a <- lengthLits.iterator) yield (a(0), a(1))).toMap

  def resolveConcat(t : LinearCombination)
                  : Option[(LinearCombination, LinearCombination)] =
    for (lits <- concatPerRes get t) yield (lits.head(0), lits.head(1))

  def lengthFor(t : LinearCombination) : LinearCombination =
    if (strDatabase isConcrete t)
      LinearCombination((strDatabase term2ListGet t).size)
    else
      lengthMap(t)

  def eval(t           : LinearCombination,
           lengthModel : ReduceWithConjunction) : Int = {
    import TerForConvenience._
    implicit val o = extOrder

    val f = lengthModel(t === X)
    assert(f.size == 1 && f.constants == Set(X))
    (-f.head.constant).intValueSafe
  }

  def evalLengthFor(t : LinearCombination,
                    lengthModel : ReduceWithConjunction) : Int =
    eval(lengthFor(t), lengthModel)

  type ChooseSplitResult =
    (Seq[LinearCombination], // left terms
     LinearCombination,      // length of concat of left terms
     LinearCombination,      // term to split
     Seq[LinearCombination]) // right terms

  def chooseSplit(splitLit1    : Atom,
                  splitLit2    : Atom,
                  lengthModel  : ReduceWithConjunction)
                               : ChooseSplitResult = {
    val splitLenConc = evalLengthFor(splitLit2(0), lengthModel)
    chooseSplit(splitLit1, splitLenConc, lengthModel,
                List(), List(), List())
  }

  def chooseSplit(t            : LinearCombination,
                  splitLen     : Int,
                  lengthModel  : ReduceWithConjunction,
                  leftTerms    : List[LinearCombination],
                  leftLenTerms : List[LinearCombination],
                  rightTerms   : List[LinearCombination])
                               : ChooseSplitResult =
    (concatPerRes get t) match {
      case Some(lits) =>
        chooseSplit(lits.head, splitLen, lengthModel,
                    leftTerms, leftLenTerms, rightTerms)
      case None =>
        ((leftTerms.reverse,
          LinearCombination.sum(
            for (t <- leftLenTerms) yield (IdealInt.ONE, t), order),
          t, rightTerms))
    }

  def chooseSplit(lit          : Atom,
                  splitLen     : Int,
                  lengthModel  : ReduceWithConjunction,
                  leftTerms    : List[LinearCombination],
                  leftLenTerms : List[LinearCombination],
                  rightTerms   : List[LinearCombination])
                               : ChooseSplitResult = {
    val left        = lit(0)
    val right       = lit(1)
    val leftLen     = lengthFor(left)
    val leftLenConc = eval(leftLen, lengthModel)

    if (splitLen <= leftLenConc)
      chooseSplit(left, splitLen, lengthModel,
                  leftTerms, leftLenTerms, right :: rightTerms)
    else
      chooseSplit(right, splitLen - leftLenConc, lengthModel,
                  left :: leftTerms, leftLen :: leftLenTerms, rightTerms)
  }

  def splittingFormula(split     : ChooseSplitResult,
                       splitLit2 : Atom)
                                 : Conjunction = {
    import TerForConvenience._
    implicit val o = order

    val (leftTerms, _, symToSplit, rightTerms) = split

    val varSorts   = new ArrayBuffer[Sort]
    val matrixFors = new ArrayBuffer[Formula]
    val varLengths = new MHashMap[VariableTerm, Term]

    def newVar(s : Sort) : VariableTerm = {
      val res = VariableTerm(varSorts.size)
      varSorts += s
      res
    }

    def lengthFor2(t : Term) : Term =
      t match {
        case t : VariableTerm =>
          varLengths.getOrElseUpdate(t, {
            val len = newVar(Sort.Integer)
            matrixFors += _str_len(List(l(t), l(len)))
            len
          })
        case _ =>
          lengthFor(t)
      }

    def addConcat(left : Term, right : Term, res : Term) : Unit = {
      matrixFors += _str_++ (List(l(left), l(right), l(res)))
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
          terms reduceLeft[Term] {
            case (t1, t2) => {
              val s = prefixes.next
              addConcat(t1, t2, s)
              s
            }
          }
        }
      }

    val leftSplitSym, rightSplitSym = newVar(StringSort)

    addConcat(leftSplitSym, rightSplitSym, symToSplit)

    addConcatN(leftTerms ++ List(leftSplitSym),   splitLit2(0))
    addConcatN(List(rightSplitSym) ++ rightTerms, splitLit2(1))

    existsSorted(varSorts.toSeq, conj(matrixFors))
  }

  def diffLengthFormula(split : ChooseSplitResult,
                        splitLit2 : Atom) : Conjunction = {
    import TerForConvenience._
    implicit val o = order

    val (_, leftTermsLen, symToSplit, _) = split
    val splitLen = lengthFor(splitLit2(0))

    (splitLen < leftTermsLen) |
    (splitLen > leftTermsLen + lengthFor(symToSplit))
  }

  def splitEquation : Seq[Plugin.Action] = {
    val multiGroups =
      concatPerRes filter {
        case (res, lits) => lits.size >= 2 && !(strDatabase isConcrete res)
      }

    val splittableTerms =
      concatLits.iterator.map(_(2)).filter(multiGroups.keySet).toList

    if (splittableTerms.isEmpty)
      return List()

    val termToSplit = splittableTerms.head
    val literals    = multiGroups(termToSplit).take(2)

    val splitLit1   = literals(0)
    val splitLit2   = literals(1)

//    if (debug)
      Console.err.println(
        "Applying Nielsen transformation: " + splitLit1 + ", " + splitLit2)

    val lengthModel =
      ModelSearchProver(Conjunction.negate(facts.arithConj, order), order)

    val split = chooseSplit(splitLit1, splitLit2,
                            ReduceWithConjunction(lengthModel, extOrder))

    if (debug)
      Console.err.println(
        "Splitting symbol " + split._3)

    val f1 = splittingFormula(split, splitLit2)
    val f2 = diffLengthFormula(split, splitLit2)

    List(
      Plugin.RemoveFacts(Conjunction.conj(splitLit1, order)),
      Plugin.AxiomSplit(concatLits ++ lengthLits, // TODO: make specific
                        List((f1, List()), (f2, List())),
                        theory)
    )

  }

}
