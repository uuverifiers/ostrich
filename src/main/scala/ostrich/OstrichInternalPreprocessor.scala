/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2024 Matthew Hague, Philipp Ruemmer. All rights reserved.
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
import ap.theories.Theory
import ap.terfor.{TermOrder, TerForConvenience}
import ap.terfor.conjunctions.{Conjunction, ReduceWithConjunction}
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.substitutions.VariableShiftSubst
import ap.types.SortedPredicate
import ap.parameters.{Param, ReducerSettings}

import ostrich.automata.{Automaton, AtomicStateAutomaton}

class OstrichInternalPreprocessor(theory : OstrichStringTheory,
                                  flags : OFlags) {
  import theory.{FunPred, StringSort, str_len, _str_len, _str_char_count,
                 str_++, _str_++, str_in_re_id, strDatabase, autDatabase}
  import LinearCombination.Constant

  private val p = theory.functionPredicateMap

  def preprocess(f : Conjunction, order : TermOrder) : Conjunction = {
    implicit val _ = order
    import TerForConvenience._

    // As a heuristic, we generate length predicate whenever the
    // problem already contained length constraints from the
    // beginning, or if the problem contains string concatenation
    val useLength =
      flags.useLength match {
        case OFlags.LengthOptions.Off  => false
        case OFlags.LengthOptions.On   => true
        case OFlags.LengthOptions.Auto =>
          theory.lengthNeeded(f) || (f.predicates contains _str_++)
      }

    if (!useLength)
      return f

    val characters =
      if (flags.useParikhConstraints)
        interestingCharacters(f).toSeq.sorted
      else
        List()

    val funTranslator =
      new OstrichStringFunctionTranslator(theory, Conjunction.TRUE)

    val res = 
    Theory.rewritePreds(f, order) { (a, negated) =>
      funTranslator(a) match {
        case Some((preop, args, result)) if negated => {
          val coeff =
            characters.size + 1
          def lenVar(argNum : Int) =
            l(v(argNum * coeff))
          def charCountVar(argNum : Int, char : Int) =
            l(v(argNum * coeff + char + 1))

          val shifter =
            VariableShiftSubst(0, (args.size + 1) * coeff, order)
          val shiftedA =
            shifter(a)
          val lenAtoms =
            for ((t, n) <- (args ++ List(result)).zipWithIndex)
            yield _str_len(List(shifter(l(t)), lenVar(n)))
          val charCountAtoms =
            for ((t, n) <- (args ++ List(result)).zipWithIndex;
                 (c, m) <- characters.zipWithIndex)
            yield _str_char_count(List(l(c), shifter(l(t)),
                                         charCountVar(n, m)))
          val charCountNonNeg =
            for (n <- 0 until (args.size + 1); m <- 0 until characters.size)
            yield (charCountVar(n, m) >= 0)
          val lenCountRelations =
            for (n <- 0 to args.size)
            yield (lenVar(n) >= sum(for (m <- 0 until characters.size)
                                    yield (IdealInt.ONE, charCountVar(n, m))))
          val lenRelation =
            preop().lengthApproximation(for (n <- 0 until args.size)
                                        yield lenVar(n),
                                        lenVar(args.size),
                                        order)
          val countRelations =
            for ((c, m) <- characters.zipWithIndex)
            yield preop().charCountApproximation(c,
                                                 for (n <- 0 until args.size)
                                                 yield charCountVar(n, m),
                                                 charCountVar(args.size, m),
                                                 order)
          exists((args.size + 1) * coeff,
                 conj(List(shiftedA, lenRelation) ++
                        lenAtoms ++ charCountAtoms ++ charCountNonNeg ++
                        lenCountRelations ++ countRelations))
        }

        case _ => a.pred match {

          case `str_in_re_id` if negated => {
            val aut = autDatabase.id2Automaton(a.last.constant.intValueSafe).get
            val charCountConstraints =
              for (c <- characters; if !automatonAcceptsChar(c, aut))
              yield _str_char_count(List(l(c), a(0), l(0)))
            if (charCountConstraints.isEmpty)
              a
            else
              conj(charCountConstraints ++ List(a))
          }

          case `str_in_re_id` if !negated => {
            val aut =
              autDatabase.id2ComplementedAutomaton(
                a.last.constant.intValueSafe).get
            val charCountConstraints =
              for (c <- characters; if !automatonAcceptsChar(c, aut))
              yield _str_char_count(List(l(c), a(0), l(0)))
            if (charCountConstraints.isEmpty)
              a
            else
              !conj(charCountConstraints) | a
          }

          case _ =>
            a
        }
      }
    }

    val reducerSettings =
      Param.FUNCTIONAL_PREDICATES.set(ReducerSettings.DEFAULT,
                                      theory.functionalPredicates)
    val res2 = ReduceWithConjunction(Conjunction.TRUE,
                                     order,
                                     reducerSettings)(res)

    res2

  }

  def automatonAcceptsChar(char : Int, aut : Automaton) : Boolean = {
    val asAut = aut.asInstanceOf[AtomicStateAutomaton]
    asAut.transitions exists {
      case (_, label, _) => asAut.LabelOps.labelContains(char.toChar, label)
    }
  }

  def interestingCharacters(f : Conjunction) : Set[Int] = {
    val predConj = f.predConj

    val local =
      (for (a <-
              predConj.positiveLits.iterator ++ predConj.negativeLits.iterator;
            sorts = SortedPredicate argumentSorts a;
            (Constant(IdealInt(id)), StringSort) <-
              a.iterator zip sorts.iterator;
            c <- strDatabase id2List id)
       yield c).toSet

    local ++
    (for (g <- f.negatedConjs.iterator;
          c <- interestingCharacters(g).iterator)
     yield c)
  }

}
