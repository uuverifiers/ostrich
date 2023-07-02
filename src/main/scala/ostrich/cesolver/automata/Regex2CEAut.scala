/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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

package ostrich.cesolver.automata

import ostrich.automata.Regex2Aut
import ap.parser._
import dk.brics.automaton.BasicAutomata
import ap.basetypes.IdealInt
import CEBasicOperations._
import scala.collection.mutable.ArrayStack
import scala.collection.immutable.VectorBuilder
import ostrich.automata.Automaton
import ostrich.OstrichStringTheory

class Regex2CEAut(theory: OstrichStringTheory) extends Regex2Aut(theory) {
  import theory.{
    re_inter,
    re_union,
    re_diff,
    re_*,
    re_*?,
    re_+,
    re_+?,
    re_opt,
    re_opt_?,
    re_loop,
    re_loop_?,
    re_++,
    re_comp,
    str_to_re
  }
  import theory.strDatabase.EncodedString

  private def translateLeaves(
      t: ITerm,
      unwind: Boolean
  ): Seq[CostEnrichedAutomatonBase] = {
    val leaves = collectLeaves(t, re_++)
    val leaveAuts = for (s <- leaves) yield toCEAutomaton(s, unwind)
    leaveAuts
  }

  private def collectLeaves(t: ITerm, op: IFunction): Seq[ITerm] = {
    val todo = new ArrayStack[ITerm]
    todo push t

    val res = new VectorBuilder[ITerm]

    while (!todo.isEmpty)
      todo.pop match {
        case IFunApp(`op`, args) =>
          for (s <- args.reverseIterator)
            todo push s
        case s =>
          res += s
      }

    res.result
  }

  def toCEAutomaton(t: ITerm, unwind: Boolean): CostEnrichedAutomatonBase =
    t match {
      case IFunApp(`re_++`, _) =>
        concatenate(translateLeaves(t, unwind))

      case IFunApp(`re_union`, _) => {
        val leaves = collectLeaves(t, re_union)
        val (singletons, nonSingletons) = leaves partition {
          case IFunApp(`str_to_re`, _) => true
          case _                       => false
        }

        val singletonAuts =
          if (singletons.isEmpty) {
            List()
          } else {
            val strings =
              (for (IFunApp(_, Seq(EncodedString(str))) <- singletons)
                yield str).toArray
            List(
              BricsAutomatonWrapper(
                BasicAutomata.makeStringUnion(strings: _*)
              )
            )
          }

        val nonSingletonAuts =
          for (s <- nonSingletons) yield toCEAutomaton(s, unwind)

        (singletonAuts, nonSingletonAuts) match {
          case (Seq(aut), Seq()) => aut
          case (Seq(), Seq(aut)) => aut
          case (auts1, auts2) =>
            union(auts1 ++ auts2)
        }
      }

      case IFunApp(`re_inter`, _) => {
        val leaves = collectLeaves(t, re_inter)
        val leaveAuts = for (s <- leaves) yield toCEAutomaton(s, unwind)
        leaveAuts reduceLeft { (aut1, aut2) =>
          intersection(aut1, aut2)
        }
      }

      case IFunApp(`re_diff`, Seq(t1, t2)) =>
        diff(toCEAutomaton(t1, false), toCEAutomaton(t2, true))

      case IFunApp(`re_opt` | `re_opt_?`, Seq(t)) =>
        optional(toCEAutomaton(t, unwind))

      case IFunApp(`re_comp`, Seq(t)) =>
        complement(toCEAutomaton(t, true))

      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(IIntLit(IdealInt(n1)), IIntLit(IdealInt(n2)), t)
          ) =>
        if (unwind) {
          repeatUnwind(toCEAutomaton(t, true), n1, n2)
        } else repeat(toCEAutomaton(t, true), n1, n2)
      case IFunApp(`re_*` | `re_*?`, Seq(t)) =>
        repeatUnwind(toCEAutomaton(t, true), 0)

      case IFunApp(`re_+` | `re_+?`, Seq(t)) =>
        repeatUnwind(toCEAutomaton(t, true), 1)

      case _ => BricsAutomatonWrapper(toBAutomaton(t, true))
    }

  override def buildAut(t: ITerm, minimize: Boolean): Automaton = {
    // minimize always, not use the parameter `minimize`
    toCEAutomaton(t, false)

  }

  def buildComplementAut(t: ITerm): Automaton = {
    // minimize always, not use the parameter `minimize`
    complement(toCEAutomaton(t, true))
  }

}
