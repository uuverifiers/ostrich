/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2021 Riccardo de Masellis, Philipp Ruemmer. All rights reserved.
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

import ap.parser.{IFunApp, IIntLit}
import ap.terfor.{TermOrder, TerForConvenience, ComputationLogger}
import ap.terfor.conjunctions.{Conjunction, Quantifier, ReduceWithConjunction,
                               ReducerPluginFactory, ReducerPlugin}
import ap.terfor.arithconj.ArithConj
import ap.terfor.preds.{Atom, Predicate, PredConj}

class OstrichReducerFactory protected[ostrich] (theory : OstrichStringTheory)
      extends ReducerPluginFactory {
  def apply(conj : Conjunction, order : TermOrder) =
    new OstrichReducer(theory, conj, this)
}

/**
 * Reducer for string constraints. This class is responsible for
 * simplifying string formulas during proof construction.
 */
class OstrichReducer protected[ostrich] (theory : OstrichStringTheory,
                                         facts : Conjunction,
                                         val factory : ReducerPluginFactory)
      extends ReducerPlugin {

  import theory.{_str_empty, _str_cons, _str_++,
                 str_empty, str_cons, str_in_re_id, strDatabase, autDatabase}

  private val funTranslator =
    new OstrichStringFunctionTranslator(theory, facts)

  def passQuantifiers(num : Int) = this

  def addAssumptions(arithConj : ArithConj,
                     mode : ReducerPlugin.ReductionMode.Value) = this

  def addAssumptions(predConj : PredConj,
                     mode : ReducerPlugin.ReductionMode.Value) = this
  
  def finalReduce(conj : Conjunction) = conj

    def reduce(predConj : PredConj,
               reducer : ReduceWithConjunction,
               logger : ComputationLogger,
               mode : ReducerPlugin.ReductionMode.Value)
             : ReducerPlugin.ReductionResult = {
      implicit val order = predConj.order
      import TerForConvenience._
      import strDatabase.isConcrete

      ReducerPlugin.rewritePreds(predConj,
                                 List(_str_empty, _str_cons,
                                      str_in_re_id) ++ // str_len
                                   funTranslator.translatablePredicates,
                                 order,
                                 logger) { a =>
        a.pred match {
          case `_str_empty` =>
            val n =
            a.last === strDatabase.str2Id(IFunApp(str_empty, List()))
              println("Rewriting " + a + " to " + n)
              n

          case `_str_cons` =>
            if (a(0).isConstant && isConcrete(a(1))) {
              a.last ===
                strDatabase.str2Id(IFunApp(str_cons,
                                           List(IIntLit(a(0).constant),
                                                IIntLit(a(1).constant))))
            } else {
              a
            }

          case `str_in_re_id` =>
            if (isConcrete(a(0))) {
              assert(a(1).isConstant)
              val Some(str) = strDatabase.term2Str(a(0))
              val Some(aut) = autDatabase.id2Automaton(a(1).constant.intValueSafe)
              if (aut(str)) Conjunction.TRUE else Conjunction.FALSE
            } else {
              a
            }

          case p => {
            assert(funTranslator.translatablePredicates contains p)
            funTranslator(a) match {
              case Some((op, args, res)) if (args forall isConcrete) => {
                val argStrs = args map strDatabase.term2StrGet
                op().eval(argStrs) match {
                  case Some(resStr) => {
                    val n = res === strDatabase.list2Id(resStr)
                    println("Rewriting " + a + " to " + n)
                    n
                  }
                  case None =>
                    a
                }
              }
              case _ =>
                a
            }
          }
        }
      }
    }

}
