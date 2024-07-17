/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Matthew Hague, Philipp Ruemmer. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from this software without specific prior written permission.
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

import ap.parser.IFunction
import ap.proof.goal.Goal
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
import ap.terfor.Term
import ostrich._
import ostrich.automata.{Automaton, BricsAutomaton, AtomicStateAutomaton}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.preop.{ConcatPreOp, PreOp}

import scala.collection.breakOut
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  MultiMap => MMultiMap,
  Set => MSet
}

/**
 * Utility methods for propagator saturation
 */
trait PropagationSaturationUtils {
  val theory : OstrichStringTheory

  import theory.{
    str_len, str_in_re, str_char_count, str_in_re_id, str_to_re,
    re_from_str, re_from_ecma2020, re_from_ecma2020_flags,
    re_case_insensitive, str_prefixof, re_none, re_all, re_allchar,
    re_charrange, re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+,
    re_+?, re_opt, re_opt_?, re_comp, re_loop, re_loop_?, re_eps,
    re_capture, re_reference, re_begin_anchor, re_end_anchor, FunPred,
    strDatabase
  }

  val rexOps : Set[IFunction] = Set(
    re_none, re_all, re_allchar, re_charrange, re_++, re_union,
    re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?,
    re_comp, re_loop, re_loop_?, re_eps, str_to_re, re_from_str,
    re_capture, re_reference, re_begin_anchor, re_end_anchor,
    re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive
  )

  val autDatabase = theory.autDatabase

  /**
   * Convert an atom to Automaton
   *
   * Throws exception if not of the expected format (i.e. the atom came
   * from somewhere other than an application point.
   *
   * @param term the term the constraint applies to
   * @constraint the constraint or None if there is no constraint (will
   * try to find a concrete def of term instead)
   */
  def atomConstraintToAut(
    term : Term, constraint : Option[Atom]
  ) : Automaton = {
    constraint match {
      // None means arg in Sigma*...
      case None => {
        // but might have a concrete def
        strDatabase.term2List(term).map({ w =>
          val str : String = w.map(i => i.toChar)(breakOut)
          BricsAutomaton.fromString(str)
        }).getOrElse(BricsAutomaton.makeAnyString())
      }
      case Some(a) => {
        a.pred match {
          case `str_in_re_id` =>
            decodeRegexId(a, false)
          // will be a str_len == 0 as we only return those
          case FunPred(`str_len`) if a(1).isZero =>
            BricsAutomaton.fromString("")
          // will not happen
          case _ => {
            throw new Exception ("Cannot handle literal " + a)
          }
        }
      }
    }
  }

  def getAutomatonSize(aut : Automaton) : Int = {
    aut match {
      case automaton: AtomicStateAutomaton => automaton.states.size
      case base: CostEnrichedAutomatonBase => base.states.size
      case _ => 0
    }
  }

  def isNotNonZeroLenConstraint(a : Atom) : Boolean = {
    a.pred match {
      case FunPred(`str_len`) => a(1).isZero
      case _ => true
    }
  }

  /**
   * The function applications that appear in the goal
   *
   * @return sequence of tuples (op, argTerms, resultTerm, formula)
   * where op is the PreOp for the operation (e.g. ReplaceAllPreOp),
   * argTerms is the sequence of terms that are the arguments to the
   * application. resultTerm is the term to compare with the result of
   * the application. formula is the full atom (e.g. x = replaceall(y,
   * s, z)).
   */
  def getFunApps(
    goal : Goal
  ) : Seq[(PreOp, Seq[Term], Term, Atom)] = {
    val atoms = goal.facts.predConj
    val stringFunctionTranslator =
        new OstrichStringFunctionTranslator(theory, goal.facts)

    // Collect a bunch of data. Always keep original formula for axiom
    // construction when returning propagation results.
    //
    // funApps -- each function application:
    //  (operation, arguments, result term, original formula containing app)
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term, Atom)]

    for (a <- atoms.positiveLits)
      getFunApp(stringFunctionTranslator, a).foreach(funApps += _)

    funApps
  }

  /**
   * Split a fun app atom into (op, args, atom) (see getFunApps)
   *
   * Or None if not a fun app
   */
  def getFunApp(
    stringFunctionTranslator : OstrichStringFunctionTranslator,
    a : Atom
  ) : Option[(PreOp, Seq[Term], Term, Atom)] = {
    a.pred match {
      case `str_prefixof` => {
        val rightVar = theory.StringSort.newConstant("rhs")
        Some((ConcatPreOp, List(a(0), rightVar), a(1), a))
      }
      case FunPred(f) if (rexOps contains f) || (f == `str_len`) =>
        None
      // next three cases prevent exception for supported string
      // functions that aren't apps
      case `str_in_re` =>
        None
      case `str_in_re_id` =>
        None
      case FunPred(`str_char_count`) =>
        None
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(a) match {
          case Some((op, args, res)) =>
            Some((op(), args, res, a))
          case _ =>
            throw new Exception ("Cannot get fun app from literal " + a)
        }
      case _ =>
        None
    }
  }

  /**
   * Get initial constraints on string vars
   *
   * The atom will be str_in_re_id, or a str_len constraint if enforces
   * 0 len
   */
  def getInitialConstraints(goal: Goal) : MMultiMap[Term, Atom] = {
    val atoms = goal.facts.predConj
    val stringFunctionTranslator =
        new OstrichStringFunctionTranslator(theory, goal.facts)

    val termConstraints = new MHashMap[Term, MSet[Atom]]
      with MMultiMap[Term, Atom]

    for (a <- atoms.positiveLits) a.pred match {
      case `str_in_re_id` => termConstraints.addBinding(a(0), a)
      case FunPred(`str_len`) if a(1).isZero
        => termConstraints.addBinding(a(0), a)
      case _ => // nothing
    }

    termConstraints
  }

  /**
   * Resolve an atom that is the id num of an automaton to the automaton
   */
  def decodeRegexId(a : Atom, complemented : Boolean) : Automaton = {
    a(1) match {
      case LinearCombination.Constant(id) => {
        val autOption
          = if (complemented)
            autDatabase.id2ComplementedAutomaton(id.intValueSafe)
          else
            autDatabase.id2Automaton(id.intValueSafe)

        autOption match {
          case Some(aut) => aut
          case None => throw new Exception ("Could not decode regex id " + a(1))
        }
      }
      case lc =>
        throw new Exception ("Could not decode regex id " + lc)
    }
  }

  def logSaturation[A](category : String)(action : A) : A = {
    if (OFlags.debug)
      Console.err.println(f"Performing $category: $action")
    action
  }
}
