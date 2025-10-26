/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2025 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.preprocessor

import ap.basetypes.IdealInt
import ap.parser._
import ap.theories.strings.StringTheory

import ostrich._
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashHap}

class Backreferences(theory : OstrichStringTheory) {

  import theory._
  import IExpression._

  object CollectGroups extends CollectingVisitor[Unit, Set[IdealInt]] {
    def apply(t : IExpression) = this.visit(t, ())
    def postVisit(t : IExpression, arg : Unit,
                  subres : Seq[Set[IdealInt]]) : Set[IdealInt] = {
      val subs = subres.foldLeft[Set[IdealInt]](Set())(_ ++ _)
      t match {
        case IFunApp(`re_capture`, Seq(Const(n), _)) => subs + n
        case _ => subs
      }
    }
  }

  def containsReference(t : ITerm) : Boolean =
    ContainsSymbol(t, expr => expr match {
      case IFunApp(`re_reference`, _) => true
      case _ => false
    })

  /**
   * Replace uniquely defined back-references with the regex of the
   * corresponding capture group.
   */
  def stubBackRefs(re     : ITerm,
                   groups : Map[IdealInt, ITerm])
                          : (ITerm, Map[IdealInt, ITerm]) =
    re match {
      case IFunApp(`re_capture`, Seq(Const(n), re1)) => {
        val (re1n, groups1) = stubBackRefs(re1, groups)
        (re_capture(n, re1n), groups1 + (n -> re1n))
      }
      case IFunApp(`re_reference`, Seq(Const(n))) => {
        groups.get(n) match {
          case Some(re1) => (re1, groups)
          case None      => (re_all(), groups)
        }
      }
      case IFunApp(`re_++`, Seq(re1, re2)) => {
        val (re1n, groups1) = stubBackRefs(re1, groups)
        val (re2n, groups2) = stubBackRefs(re2, groups1)
        (re_++(re1n, re2n), groups2)
      }
      case IFunApp(f@(`re_union` | `re_inter`), Seq(re1, re2)) => {
        val (re1n, groups1) = stubBackRefs(re1, groups)
        val groups1b = groups1 -- CollectGroups(re1)
        val (re2n, groups2) = stubBackRefs(re2, groups1b)
        val groups2b = groups2 -- CollectGroups(re2)
        (f(re1n, re2n), groups2b)
      }
      case IFunApp(`str_to_re` | `re_none` | `re_eps` |
                   `re_all` | `re_allchar` | `re_charrange` |
                   `re_range`, _) => {
        (re, groups)
      }
    }

}