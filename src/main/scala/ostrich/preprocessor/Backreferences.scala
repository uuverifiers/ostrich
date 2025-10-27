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
import ostrich.automata.Regex2Aut.SmartConst
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashHap}

class Backreferences(theory : OstrichStringTheory) {

  import theory._
  import StringTheory._
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
      case IFunApp(`re_*`, Seq(re1)) => {
        val containedGroups = CollectGroups(re1)
        val groups1 = groups -- containedGroups
        val (re1n, groups1n) = stubBackRefs(re1, groups1)
        (re_*(re1n), groups1)
      }
      case IFunApp(`str_to_re` | `re_none` | `re_eps` |
                   `re_all` | `re_allchar` | `re_charrange` |
                   `re_range`, _) => {
        (re, groups)
      }
    }

  def matchRegex(str : Seq[Int], re : ITerm)
               : Option[Map[IdealInt, Seq[Int]]] = {
//                println("matching: " + str)
//                println(re)
    (for (state <- matchRegexRec(str.toIndexedSeq, MatchState(0, Map()), re);
          if state.pos == str.size)
     yield {
       state.groups.transform { case (n, (b, e)) => str.slice(b, e) }
     }).headOption
  }

  private case class MatchState(pos    : Int,
                                groups : Map[IdealInt, (Int, Int)]) {
    def +(n : Int) =
      MatchState(pos + n, groups)
    def setPos(n : Int) =
      MatchState(n, groups)
    def captureGroup(n : IdealInt, b : Int, e : Int) =
      MatchState(pos, groups + (n -> (b, e)))
  }

  private def matchRegexRec(str   : IndexedSeq[Int],
                            state : MatchState,
                            re    : ITerm) : Stream[MatchState] = {
    import state.pos
//    println(state)
    re match {
      case IFunApp(`re_none`, _) =>
        Stream.empty
      case IFunApp(`re_eps`, _) =>
        Stream(state)
      case IFunApp(`re_charrange`, Seq(SmartConst(l), SmartConst(u))) =>
        if (pos < str.size && l <= str(pos) && u >= str(pos))
          Stream(state + 1)
        else
          Stream.empty
      case IFunApp(`str_to_re`, Seq(_s)) =>
        val s = term2List(_s)
        if (pos + s.size <= str.size && str.slice(pos, pos + s.size) == s)
          Stream(state + s.size)
        else
          Stream.empty

      case IFunApp(`re_++`, Seq(re1, re2)) =>
        for (state1 <- matchRegexRec(str, state, re1);
             state2 <- matchRegexRec(str, state1, re2))
        yield state2
      case IFunApp(`re_union`, Seq(re1, re2)) =>
        matchRegexRec(str, state, re1) ++ matchRegexRec(str, state, re2)
      case IFunApp(`re_inter`, Seq(re1, re2)) =>
        for (state1 <- matchRegexRec(str, state, re1);
             state2 <- matchRegexRec(str, state1.setPos(pos), re2);
             if state1.pos == state2.pos)
        yield state2
      
      // re_diff
      // re_comp

      case IFunApp(`re_all`, _) =>
        matchRegexRec(str, state, re_*(re_allchar()))
      case IFunApp(`re_*`, Seq(re1)) =>
        (for (state1 <- matchRegexRec(str, state, re1);
              state2 <- matchRegexRec(str, state1, re))
         yield state2) :+ state
      case IFunApp(`re_+`, Seq(re1)) =>
        for (state1 <- matchRegexRec(str, state, re1);
             state2 <- matchRegexRec(str, state1, re_*(re1)))
        yield state2
      case IFunApp(`re_opt`, Seq(re1)) =>
        matchRegexRec(str, state, re1) :+ state
      case IFunApp(`re_loop`, Seq(Const(n1), Const(n2), re1)) => {
        assert(n1.signum >= 0, "re.loop cannot be used with negative indexes")
        if (n1 > n2)
          Stream.empty
        else if (n1.signum > 0)
          matchRegexRec(str, state,
                        re_++(re1, re_loop(n1 - 1, n2 - 1, re1)))
        else
          matchRegexRec(str, state,
                        re_++(re1, re_loop(IdealInt.ZERO,
                                           n2 - 1, re1))) :+ state
      }
      
      case IFunApp(`re_begin_anchor`, _) =>
        if (pos == 0) Stream(state) else Stream.empty
      case IFunApp(`re_end_anchor`, _) =>
        if (pos == str.size) Stream(state) else Stream.empty

      case IFunApp(`re_capture`, Seq(Const(n), re1)) =>
        for (state1 <- matchRegexRec(str, state, re1))
        yield state1.captureGroup(n, state.pos, state1.pos)
      case IFunApp(`re_reference`, Seq(Const(n))) =>
        state.groups.get(n) match {
          case Some((b, e))
              if pos + e - b <= str.size &&
                 ((b until e).forall {
                   ind => str(pos + ind - b) == str(ind) }) =>
            Stream(state + (e - b))
          case _ =>
            Stream.empty
        }

    }
  }

}