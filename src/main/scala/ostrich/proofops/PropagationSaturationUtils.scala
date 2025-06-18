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
import ap.terfor.TerForConvenience.{l, term2RichLC}
import ap.terfor.{Formula, RichPredicate, TerForConvenience, Term}
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
import ostrich._
import ostrich.automata.{AtomicStateAutomaton, AutomataUtils, Automaton, BricsAutomaton}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.preop.{ConcatPreOp, PreOp}

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap, MultiMap => MMultiMap, Set => MSet}
import ap.basetypes.IdealInt

/**
 * Utility methods for propagator saturation
 */
trait PropagationSaturationUtils {
  val theory : OstrichStringTheory

  import theory.{
    str_len, str_in_re, str_char_count, str_in_re_id, str_to_re, str_contains, agePred,
    re_from_str, re_from_ecma2020, re_from_ecma2020_flags,
    re_case_insensitive, str_prefixof, str_suffixof, re_none, re_all, re_allchar,
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

  def getAge(variable : Term, regex : Term, goal : Goal) : Int = {
    for (a <- goal.facts.predConj.positiveLitsWithPred(agePred)){
      if (variable == a(0) && regex == a(1)){
        //return innerhalb von for ist langsam
        return a(2).head._1.intValueSafe
      }
    }
    0
  }

  def buildAge(variable : Term, autId : Int, age : Int, goal : Goal) : Atom = {
    import TerForConvenience._
    implicit val o = goal.order
    agePred(List(l(variable),l(autId), l(age)))
  }



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
          val str : String = w.map(i => i.toChar).mkString
          BricsAutomaton.fromString(str)
        }).getOrElse(autDatabase.anyStringAut)
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

  type FunAppTuple = (PreOp, Seq[Option[Term]], Term, Atom)

  /**
   * The function applications that appear in the goal
   *
   * @return sequence of tuples (op, argTerms, resultTerm, formula)
   * where op is the PreOp for the operation (e.g. ReplaceAllPreOp),
   * argTerms is the sequence of terms that are the arguments to the
   * application. resultTerm is the term to compare with the result of
   * the application. formula is the full atom (e.g. x = replaceall(y,
   * s, z)).
   *
   * argTerms may be None which stands for "an unconstrained fresh
   * value"
   */
  def getFunApps(
    goal : Goal
  ) : Seq[FunAppTuple] = {
    val atoms = goal.facts.predConj
    val stringFunctionTranslator =
        new OstrichStringFunctionTranslator(theory, goal.facts)

    // Collect a bunch of data. Always keep original formula for axiom
    // construction when returning propagation results.
    //
    // funApps -- each function application:
    //  (operation, arguments, result term, original formula containing app)
    val funApps = new ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)]

    for (a <- atoms.positiveLits)
      getFunApp(stringFunctionTranslator, a).foreach(funApps += _)

    funApps.toSeq
  }

  /**
   * Split a fun app atom into (op, args, atom) (see getFunApps)
   *
   * Or None if not a fun app. An arg of None means that the argument is
   * an unconstrained string
   */
  def getFunApp(
    stringFunctionTranslator : OstrichStringFunctionTranslator,
    a : Atom
  ) : Option[FunAppTuple] = {
    a.pred match {
      case `str_prefixof` => {
        Some((ConcatPreOp, List(Some(a(0)), None), a(1), a))
      }
      case `str_suffixof` => {
        Some((ConcatPreOp, List(None, Some(a(0))), a(1), a))
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
            Some((
              op(),
              args.map(a => Some(a)).toSeq,
              res,
              a
            ))
          case _ =>
            // ignore unknown string functions
            None
        }
      case _ =>
        None
    }
  }

  /**
   * Get initial constraints on string vars
   *
   * The atom will be str_in_re_id, or a str_len constraint if enforces
   * 0 len. Atoms will be sorted by goal order.
   */
  def getInitialConstraints(goal: Goal) : Map[Term, Seq[Atom]] = {
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

    termConstraints.map({ case (t, as) =>
      (t, as.toSeq.sorted(goal.order.atomOrdering))
    }).toMap
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

  def formulaTermInAut(t : Term, aut : Automaton, goal : Goal) : Formula = {
    val word = AutomataUtils.isSingletonIfAtomic(aut)
    val lt = LinearCombination(t, goal.order);
    if (word.isDefined) {
      val w = word.head
      val wordId = strDatabase.list2Id(w)
      term2RichLC(t)(goal.order) === LinearCombination(IdealInt(wordId))
    } else {
      val str_in_re_id_app = new RichPredicate(str_in_re_id, goal.order)
      val autId = autDatabase.automaton2Id(aut);
      val lautId = LinearCombination(IdealInt(autId));
      str_in_re_id_app(Seq(lt, lautId))
    }
  }

  private def resultTermAppearsElsewhere(term: Term, funApps: ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)], originalElem: (PreOp, Seq[Option[Term]], Term, Atom)): Boolean = {
    funApps.exists { case (op, args, resTerm, atom) =>
      // Check if the term appears in the arguments or as the result term,
      // excluding its original position
      if (originalElem == (op, args, resTerm, atom)) {
        false
      } else {
        args.flatten.contains(term) || resTerm == term
      }
    }
  }

  // Helper function to check if any terms in the sequence of options appear elsewhere
  private def argsAppearElsewhere(args: Seq[Option[Term]], funApps: ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)], currentElem: (PreOp, Seq[Option[Term]], Term, Atom)): Boolean = {
    args.flatten.exists(term => resultTermAppearsElsewhere(term, funApps, currentElem)) || currentElem._4.pred == FunPred(theory.str_replaceallre) || currentElem._4.pred == FunPred(theory.str_replaceall)
  }

  def getCutOrder(goal: Goal): Seq[(PreOp, Seq[Option[Term]], Term, Atom)] = {
    val orderOfRemoval = ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)]()
    // Get initial function applications
    val initialFunApps = getFunApps(goal)
    val funApps = ArrayBuffer(initialFunApps: _*) // Make a mutable copy
    var changed = true

    while (changed && funApps.nonEmpty) {
      changed = false
      val toRemove = ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)]()

      // Check each element and mark for removal if it satisfies the condition
      for (elem <- funApps) {
        val (_, args, resultTerm, _) = elem
        if (!resultTermAppearsElsewhere(resultTerm, funApps, elem)){
          orderOfRemoval += elem
          toRemove += elem
        }
        if (!argsAppearElsewhere(args, funApps, elem)){

          orderOfRemoval += elem
          toRemove += elem
        }

      }

      // Remove the marked elements
      if (toRemove.nonEmpty) {
        changed = true
        funApps --= toRemove
      }
    }
    orderOfRemoval.toSeq
  }

  def chainFree(goal: Goal): Boolean = {
    val orderOfRemoval = ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)]()
    // Get initial function applications
    val initialFunApps = getFunApps(goal)
    val funApps = ArrayBuffer(initialFunApps: _*) // Make a mutable copy
    var changed = true

    while (changed && funApps.nonEmpty) {
      changed = false
      val toRemove = ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)]()

      // Check each element and mark for removal if it satisfies the condition
      for (elem <- funApps) {
        val (_, args, resultTerm, _) = elem
        if (!resultTermAppearsElsewhere(resultTerm, funApps, elem)){
          orderOfRemoval += elem
          toRemove += elem
        }
        if (!argsAppearElsewhere(args, funApps, elem)){
          orderOfRemoval += elem
          toRemove += elem
        }

      }

      // Remove the marked elements
      if (toRemove.nonEmpty) {
        changed = true
        funApps --= toRemove
      }
    }
     funApps.isEmpty
  }

  def straightLine(goal: Goal): Boolean = {
    val orderOfRemoval = ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)]()
    // Get initial function applications
    val initialFunApps = getFunApps(goal)
    val funApps = ArrayBuffer(initialFunApps: _*) // Make a mutable copy
    var changed = true

    while (changed && funApps.nonEmpty) {
      changed = false
      val toRemove = ArrayBuffer[(PreOp, Seq[Option[Term]], Term, Atom)]()

      // Check each element and mark for removal if it satisfies the condition
      for (elem <- funApps) {
        val (_, args, resultTerm, _) = elem
        if (!resultTermAppearsElsewhere(resultTerm, funApps, elem)){
          orderOfRemoval += elem
          toRemove += elem
        }

      }

      // Remove the marked elements
      if (toRemove.nonEmpty) {
        changed = true
        funApps --= toRemove
      }
    }
    funApps.isEmpty
  }


  def logSaturation[A](category : String)(action : A) : A = {
    if (OFlags.debug)
      Console.err.println(f"Performing $category: $action")
    action
  }
}
