/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu, Matthew Hague, Philipp Ruemmer. All rights reserved.
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
package ostrich.cesolver.stringtheory

import ostrich.automata.{Transducer}

import ap.Signature
import ap.basetypes.IdealInt
import ap.parser.{IFormula, IExpression}
import IExpression.Predicate
import ap.theories.Incompleteness
import ap.terfor.{Term, TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.util.Seqs

import ostrich.cesolver.preprocess.CEPreprocessor
import ostrich.{OFlags, OstrichSolver, OstrichStringTheory}
import ostrich.OstrichEqualityPropagator
import ostrich.cesolver.automata.CEAutDatabase
import ostrich.cesolver.preprocess.CEInternalPreprocessor
import ap.parser.IFunction
import ap.types.MonoSortedIFunction
import ap.types.Sort.Integer

////////////////////////////////////////////////////////////////////////////////

/** The entry class of the Ostrich string solver.
  */
class CEStringTheory(transducers: Seq[(String, Transducer)], flags: OFlags)
    extends OstrichStringTheory(transducers, flags) {

  private val ceSolver = new CESolver(this, flags)
  private val equalityPropagator = new OstrichEqualityPropagator(this)

  lazy val ceAutDatabase = new CEAutDatabase(this, flags)

   // substring special cases 
  lazy val str_substr_0_lenMinus1 = 
    new MonoSortedIFunction("str_substr_0_lenMinus1", List(StringSort), StringSort, true, false)
  lazy val str_substr_lenMinus1_1 = 
    new MonoSortedIFunction("str_substr_lenMinus1_1", List(StringSort), StringSort, true, false)
  lazy val str_substr_n_lenMinusM = 
    new MonoSortedIFunction("str_substr_n_lenMinusM", List(StringSort, Integer, Integer), StringSort, true, false)
  lazy val str_substr_0_indexofc0 = 
    new MonoSortedIFunction("str_substr_0_indexofc0", List(StringSort, StringSort), StringSort, true, false)
  lazy val str_substr_0_indexofc0Plus1 = 
    new MonoSortedIFunction("str_substr_0_indexofc0Plus1", List(StringSort, StringSort), StringSort, true, false)
  lazy val str_substr_indexofc0Plus1_tail = 
    new MonoSortedIFunction("str_substr_indexofc0Plus1_tail", List(StringSort, StringSort), StringSort, true, false)

  lazy val specialSubstrFucs = List(
    str_substr_0_lenMinus1, str_substr_n_lenMinusM, str_substr_lenMinus1_1, 
    str_substr_0_indexofc0, str_substr_0_indexofc0Plus1, str_substr_indexofc0Plus1_tail
  )

  override protected def  extraExtraFunctions: Seq[IFunction] = specialSubstrFucs

  // Set of the predicates that are fully supported at this point
  private val supportedPreds : Set[Predicate] =
    Set(str_in_re, str_in_re_id, str_prefixof, str_suffixof) ++
    (for (f <- Set(str_empty, str_cons, str_at,
                   str_++, str_replace, str_replaceall,
                   str_replacere, str_replaceallre, str_replaceallcg, 
                   str_replacecg, str_to_re,
                   str_extract,
                   str_to_int, int_to_str,
                   re_none, re_eps, re_all, re_allchar, re_charrange,
                   re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?,
                   re_opt, re_opt_?,
                   re_comp, re_loop, re_loop_?, re_from_str, re_capture, re_reference,
                   re_begin_anchor, re_end_anchor,
                   re_from_ecma2020, re_from_ecma2020_flags,
                   re_case_insensitive,
                   str_substr, str_indexof))
     yield functionPredicateMap(f)) ++
    (for (f <- List(str_len); if flags.useLength != OFlags.LengthOptions.Off)
     yield functionPredicateMap(f)) ++
    (for ((_, e) <- extraOps.iterator) yield e match {
       case Left(f) => functionPredicateMap(f)
       case Right(p) => p
     })

  private val unsupportedPreds = predicates.toSet -- supportedPreds


  override def plugin = Some(new Plugin {

    private val modelCache =
      new ap.util.LRUCache[Conjunction, Option[
        Map[Term, Either[IdealInt, Seq[Int]]]
      ]](3)

    override def handleGoal(goal: Goal): Seq[Plugin.Action] = {

      goalState(goal) match {

        case Plugin.GoalState.Eager =>
          Seq()

        case Plugin.GoalState.Intermediate =>
          Seq()

        case Plugin.GoalState.Final =>
          try { 
            callBackwardProp(goal)
          } catch {
            case t: ap.util.Timeout => throw t
            // case t: Throwable       => { t.printStackTrace; throw t }
          }

      }
    }

    private def callBackwardProp(goal: Goal): Seq[Plugin.Action] =
      try {
        modelCache(goal.facts) {
          ceSolver.findStringModel(goal)
        } match {
          case Some(m) =>
            equalityPropagator.handleSolution(goal, m)
          case None =>
            List(Plugin.AddFormula(Conjunction.TRUE))
        }
      } catch {
        case OstrichSolver.BlockingActions(actions) => actions
      }

    override def computeModel(goal: Goal): Seq[Plugin.Action] =
      if (Seqs.disjointSeq(goal.facts.predicates, predicates)) {
        List()
      } else {
        val model = (modelCache(goal.facts) {
          ceSolver.findStringModel(goal)
        }).get
        implicit val order = goal.order
        import TerForConvenience._

        val stringAssignments =
          conj(
            for ((x, Right(w)) <- model)
              yield (x === strDatabase.list2Id(w))
          )

        import TerForConvenience._
        val lenAssignments =
          eqZ(
            for (
              (x, Left(len)) <- model;
              if x.constants subsetOf order.orderedConstants
            )
              yield l(x - len)
          )

        val stringFormulas =
          conj(goal.facts.iterator filter { f =>
            !Seqs.disjointSeq(f.predicates, predicates)
          })

        List(
          Plugin.RemoveFacts(stringFormulas),
          Plugin.AddAxiom(
            List(stringFormulas),
            stringAssignments & lenAssignments,
            CEStringTheory.this
          )
        )
      }

  })

  override def iPreprocess(
      f: IFormula,
      signature: Signature
  ): (IFormula, Signature) = {
    val visitor1 = new CEPreprocessor(this)
    (visitor1(f), signature)
  }

  override def preprocess(f : Conjunction, order : TermOrder) : Conjunction = {
    if (!Seqs.disjoint(f.predicates, unsupportedPreds))
      Incompleteness.set

    val preprocessor = new CEInternalPreprocessor(this, flags)
    preprocessor.preprocess(f, order)
  }

  // TODO: ADD Reducer Plugin
  // override val reducerPlugin  = 
  //   new CEReducerFactory(this)
}
