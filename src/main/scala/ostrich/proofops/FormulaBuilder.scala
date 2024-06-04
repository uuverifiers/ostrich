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

package ostrich.proofops

import ostrich._

import ap.basetypes.IdealInt
import ap.terfor.{VariableTerm, Formula, Term, TerForConvenience}
import ap.types.Sort

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

import ap.proof.goal.Goal

/**
 * Class to simplify the construction of word equations.
 */
class FormulaBuilder(goal   : Goal,
                     theory : OstrichStringTheory) {
  import theory.{_str_++, _str_len, _str_char_count, strDatabase, StringSort}

  implicit val o = goal.order
  import TerForConvenience._

  val predConj   = goal.facts.predConj
  val useLength  = theory.lengthNeeded(goal.facts)
  val varSorts   = new ArrayBuffer[Sort]
  val matrixFors = new ArrayBuffer[Formula]
  val varLengths = new MHashMap[Term, Term]
  val charCounts = new MHashMap[(Int, Term), Term]

  val characters =
    (for (a <- predConj.positiveLitsWithPred(_str_char_count).iterator)
     yield a(0).constant.intValueSafe).toSet

  def newVar(s : Sort) : VariableTerm = {
    val res = VariableTerm(varSorts.size)
    varSorts += s
    res
  }

  def lengthOfTerm(t : Term) : Term =
    varLengths.getOrElseUpdate(t, {
      val len = newVar(Sort.Integer)
      matrixFors += _str_len(List(l(t), l(len)))
      matrixFors += l(len) >= sum(for (c <- characters.iterator)
                                  yield (IdealInt.ONE, l(ccOfTerm(c, t))))
      len
    })

  def setLength(term1 : Term, term2 : Term) : Unit =
    addConjunct(_str_len(List(l(term1),l(term2))))

  def ccOfTerm(c : Int, t : Term) : Term =
    charCounts.getOrElseUpdate((c, t), {
      val cc = newVar(Sort.Integer)
      matrixFors += _str_char_count(List(l(c), l(t), l(cc)))
      matrixFors += l(cc) >= 0
      cc
    })

  def addConcat(left : Term, right : Term, res : Term) : Unit = {
    matrixFors += _str_++ (List(l(left), l(right), l(res)))
    if (useLength) {
      matrixFors +=
        lengthOfTerm(left) + lengthOfTerm(right) === lengthOfTerm(res)

      for (c <- characters)
        matrixFors +=
          ccOfTerm(c, left) + ccOfTerm(c, right) === ccOfTerm(c, res)
    }
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

  def concat(terms : Seq[Term]) : Term = terms match {
    case Seq()  =>
      strDatabase.list2Id(List())
    case Seq(t) =>
      t
    case terms  => {
      val res = newVar(StringSort)
      addConcatN(terms, res)
      res
    }
  }

  def addConjunct(f : Formula) : Unit =
    matrixFors += f

  def result =
    existsSorted(varSorts.toSeq, conj(matrixFors))
}

