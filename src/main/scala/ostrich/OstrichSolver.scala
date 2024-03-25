/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2024 Matthew Hague, Philipp Ruemmer, Oliver Markgraf. All rights reserved.
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

import ostrich.automata.{Automaton, BricsAutomaton}
import ostrich.preop.{ConcatPreOp, PreOp}

import ap.SimpleAPI
import ap.parser.IFunction
import ap.terfor.{ConstantTerm, Formula, OneTerm, TerForConvenience, Term}
import ap.terfor.preds.{Atom, PredConj}
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.conjunctions.Conjunction
import ap.types.Sort
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.basetypes.IdealInt
import ap.util.Seqs

import dk.brics.automaton.{RegExp, Automaton => BAutomaton}

import scala.collection.breakOut
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap,
                                 HashSet => MHashSet, LinkedHashMap}

object OstrichSolver {

  /**
   * Exception thrown by the backward propagation algorithm when it
   * encounters constraints that cannot be handled: e.g.,
   * non-tree-like or cyclic constraints.
   */
  protected[ostrich] class BackwardException
                     extends Exception("backward propagation failed")

  protected[ostrich] case object BackwardFailed
                     extends BackwardException

  protected[ostrich] case class BlockingActions(actions : Seq[Plugin.Action])
                     extends BackwardException

  /**
   * Up to which length are monadic length constraints turned into
   * finite-state automata.
   */
  private val lengthToRegexBound = 100000

}

class OstrichSolver(theory : OstrichStringTheory,
                    flags : OFlags) {

  import OstrichSolver._
  import theory.{str_from_char, str_len, str_empty, str_cons, str_++,
                 str_in_re, str_char_count,
                 str_in_re_id, str_to_re, re_from_str,
                 re_from_ecma2020, re_from_ecma2020_flags,
                 re_case_insensitive,
                 str_replace, str_replacere, str_replaceall, str_replaceallre,
                 str_prefixof,
                 re_none, re_all, re_allchar, re_charrange,
                 re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?,
                 re_comp, re_loop, re_loop_?, re_eps, re_capture, re_reference,
                 re_begin_anchor, re_end_anchor, FunPred, strDatabase}

  val rexOps : Set[IFunction] =
    Set(re_none, re_all, re_allchar, re_charrange, re_++, re_union, re_inter,
        re_diff, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?, re_comp, re_loop, re_loop_?, re_eps, str_to_re,
        re_from_str, re_capture, re_reference, re_begin_anchor, re_end_anchor,
        re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive)

  private val p = theory.functionPredicateMap

  private val autDatabase = theory.autDatabase

  def findStringModel(goal : Goal)
                    : Option[Map[Term, Either[IdealInt, Seq[Int]]]] = {
    val atoms = goal.facts.predConj
    val order = goal.order

    // extract regex constraints and function applications from the
    // literals
    val funApps    = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes    = new ArrayBuffer[(Term, Automaton)]
    val negEqs     = new ArrayBuffer[(Term, Term)]
    val lengthVars = new MHashMap[Term, Term]

    val is_monadic = lengthToRegexConverter(goal.facts) match {
      case Some(rex) => {
        regexes ++= rex
        true
      }
      case None =>
        false
    }

    val containsLength =
      (atoms positiveLitsWithPred p(str_len)).nonEmpty && !is_monadic
    val eagerMode = flags.eagerAutomataOperations

    val useLength = flags.useLength match {

      case OFlags.LengthOptions.Off  => {
        if (containsLength)
          Console.err.println(
            "Warning: problem uses the string length operator, but -length=off")
        false
      }

      case OFlags.LengthOptions.On   =>
        true

      case OFlags.LengthOptions.Auto => {
        if (containsLength)
          Console.err.println(
            "Warning: assuming -length=on to handle length constraints")
        containsLength
      }

    }
    val regexExtractor =
      theory.RegexExtractor(goal)
    val stringFunctionTranslator =
      new OstrichStringFunctionTranslator(theory, goal.facts)

    ////////////////////////////////////////////////////////////////////////////

    def decodeRegexId(a : Atom, complemented : Boolean) : Unit = a(1) match {
      case LinearCombination.Constant(id) => {
        val autOption =
          if (complemented)
            autDatabase.id2ComplementedAutomaton(id.intValueSafe)
          else
            autDatabase.id2Automaton(id.intValueSafe)

        autOption match {
          case Some(aut) =>
            regexes += ((a.head, aut))
          case None =>
            throw new Exception ("Could not decode regex id " + a(1))
        }
      }
      case lc =>
        throw new Exception ("Could not decode regex id " + lc)
    }

    ////////////////////////////////////////////////////////////////////////////
    // Collect positive literals

    for (a <- atoms.positiveLits) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, false)
      case FunPred(`str_len`) => {
        lengthVars.put(a(0), a(1))
        if (a(1).isZero)
          regexes += ((a(0), BricsAutomaton fromString ""))
      }
      case FunPred(`str_char_count`) => {
        // ignore
      }
      case `str_prefixof` => {
        val rightVar = theory.StringSort.newConstant("rhs")
        funApps += ((ConcatPreOp, List(a(0), rightVar), a(1)))
      }
      case FunPred(f) if rexOps contains f =>
        // nothing
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(a) match {
          case Some((op, args, res)) =>
            funApps += ((op(), args, res))
          case _ =>
            throw new Exception ("Cannot handle literal " + a)
        }
      case _ =>
        // nothing
    }

    ////////////////////////////////////////////////////////////////////////////
    // Collect negative literals

    for (a <- atoms.negativeLits) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2ComplementedAutomaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, true)
      case pred if theory.transducerPreOps contains pred =>
        throw new Exception ("Cannot handle negated transducer constraint " + a)
      case p if (theory.predicates contains p) =>
        // Console.err.println("Warning: ignoring !" + a)
        throw new Exception ("Cannot handle negative literal " + a)
      case _ =>
        // nothing
    }

    ////////////////////////////////////////////////////////////////////////////
    // Check whether any of the negated equations talk about strings

    if (!goal.facts.arithConj.negativeEqs.isEmpty) {
      import TerForConvenience._
      implicit val o = order

      val stringConstants =
        ((for ((t, _) <- regexes.iterator;
               c <- t.constants.iterator) yield c) ++
         (for ((_, args, res) <- funApps.iterator;
               t <- args.iterator ++ Iterator(res);
               c <- t.constants.iterator) yield c) ++
         (for (a <- (atoms positiveLitsWithPred p(str_len)).iterator;
               c <- a(0).constants.iterator) yield c)).toSet
      val lengthConstants =
        (for (t <- lengthVars.values.iterator;
              c <- t.constants.iterator) yield c).toSet

      for (lc <- goal.facts.arithConj.negativeEqs) lc match {
        case Seq((IdealInt.ONE, c : ConstantTerm))
            if (stringConstants contains c) && (strDatabase containsId 0) => {
          val str = strDatabase id2Str 0
          regexes += ((l(c), !(BricsAutomaton fromString str)))
        }
        case Seq((IdealInt.ONE, c : ConstantTerm), (IdealInt(coeff), OneTerm))
            if (stringConstants contains c) &&
               (strDatabase containsId -coeff) => {
          val str = strDatabase id2Str -coeff
          regexes += ((l(c), !(BricsAutomaton fromString str)))
        }
        case lc if useLength && (lc.constants forall lengthConstants) =>
          // nothing
        case Seq((IdealInt.ONE, c : ConstantTerm),
                 (IdealInt.MINUS_ONE, d : ConstantTerm))
            if stringConstants(c) && stringConstants(d) =>
          negEqs += ((c, d))
        case lc if lc.constants exists stringConstants =>
          throw new Exception ("Cannot handle negative string equation " +
                                 (lc =/= 0))
        case _ =>
          // nothing
      }

      if (!negEqs.isEmpty) {
        // make sure that symbols mentioned in negated equations have some
        // regex constraint, and thus will be included in the solution
        val regexCoveredTerms = new MHashSet[Term]
        for ((t, _) <- regexes)
          regexCoveredTerms += t

        for ((c, d) <- negEqs) {
          if (regexCoveredTerms add c)
            regexes += ((l(c), BricsAutomaton.makeAnyString()))
          if (regexCoveredTerms add d)
            regexes += ((l(d), BricsAutomaton.makeAnyString()))
        }
      }
    }

    val interestingTerms =
      ((for ((t, _) <- regexes.iterator) yield t) ++
       (for ((_, args, res) <- funApps.iterator;
             t <- args.iterator ++ Iterator(res)) yield t)).toSet

    ////////////////////////////////////////////////////////////////////////////
    // Start the actual OSTRICH solver

    SimpleAPI.withProver { lengthProver =>
      val lProver =
        if (useLength) {
          lengthProver setConstructProofs true
          lengthProver.addConstantsRaw(order sort order.orderedConstants)

          lengthProver addAssertion goal.facts.arithConj

          for (t <- interestingTerms)
            lengthVars.getOrElseUpdate(
              t, lengthProver.createConstantRaw("" + t + "_len", Sort.Nat))

          import TerForConvenience._
          implicit val o = lengthProver.order

          Some(lengthProver)
        } else {
          None
        }

      val exploration =
        if (eagerMode)
          Exploration.eagerExp(funApps, regexes, strDatabase,
                               lProver, lengthVars.toMap, useLength, flags)
        else
          Exploration.lazyExp(funApps, regexes, strDatabase,
                              lProver, lengthVars.toMap, useLength, flags)

      val result = exploration.findModel

      ////////////////////////////////////////////////////////////////////////////
      // Verify that the result satisfies all constraints that could
      // not be included initially

      for (model <- result) {
        import TerForConvenience._
        implicit val o = order

        for ((c, d) <- negEqs) {
          val Right(cVal) = model(l(c))
          val Right(dVal) = model(l(d))

          if (cVal == dVal) {
            Console.err.println("   ... disequality is not satisfied: " +
                                  c + " != " + d)
            val strId = strDatabase.list2Id(cVal)
            throw new BlockingActions(List(
              Plugin.AxiomSplit(List(c =/= d),
                                List((c =/= strId, List()),
                                     (c === strId & d =/= strId, List())),
                                theory)))
          }
        }
      }

      if (result.isDefined)
        Console.err.println("   ... sat")
      else
        Console.err.println("   ... unsat")

      result
    }
  }

  private def lengthToRegexConverter(facts : Conjunction)
                                   : Option[Seq[(Term, Automaton)]] = {
    val atoms         = facts.predConj

    val pos_length    = atoms.positiveLitsWithPred(p(str_len))
    val regexes       = new ArrayBuffer[(Term,Automaton)]

    // We can only have monadic length constraints if length variables
    // are related to unique string variables
    val lenVar2strVar = new LinkedHashMap[ConstantTerm, Term]

    object SmallInt {
      def unapply(v : IdealInt) : Option[Int] =
        if (v.abs <= lengthToRegexBound)
          Some(v.intValueSafe)
        else
          None
    }

    for (atom <- pos_length) (atom(0), atom(1)) match {
      case (LinearCombination.Constant(_), _) => {
        // Constant string, can be ignored, it will be handled by the
        // reducer
      }

      case (strVar@LinearCombination.SingleTerm(_),
            LinearCombination.Constant(SmallInt(len))) => {
        // Constraint is equality int = |str|
        regexes += ((strVar, BricsAutomaton.eqLengthAutomata(len)))
      }

      case (strVar@LinearCombination.SingleTerm(_),
            LinearCombination.SingleTerm(lenVar : ConstantTerm))
        if !(lenVar2strVar contains lenVar) => {
        // more complicated length constraint, but might still be monadic
        lenVar2strVar.put(lenVar, strVar)
      }

      case _ =>
        return None
    }

    if (lenVar2strVar.isEmpty)
      return Some(regexes.toSeq)

    // Now we have to check that constraints about the length
    // variables are monadic

    for (f <- facts.arithConj.iterator)
      if (!Seqs.disjoint(f.constants, lenVar2strVar.keySet)) {
        if (f.constants.size != 1)
          return None

        val strVar = lenVar2strVar(f.constants.iterator.next)

        def addRegex(const : IdealInt,
                     aut : Int => Automaton) : Boolean = const match {
          case SmallInt(smallConst) => {
            regexes += ((strVar, aut(-smallConst)))
            true
          }
          case _ => {
            // then the constraint is not considered monadic
            false
          }
        }

        if (!f.positiveEqs.isTrue) {
          // Constraint is equality int = |str|
          if (!addRegex(f.positiveEqs.head.constant,
                        BricsAutomaton.eqLengthAutomata(_)))
            return None
        }
        if (!f.negativeEqs.isTrue) {
          // Constraint is disequality int != |str|
          if (!addRegex(f.negativeEqs.head.constant,
                        !BricsAutomaton.eqLengthAutomata(_)))
            return None
        }
        if (!f.inEqs.isTrue) {
          val lc = f.inEqs.head
          val success = lc.leadingCoeff.signum match {
            case 1 =>
              // Constraint is inequality int <= |str| ...
              addRegex(lc.constant,
                       len => BricsAutomaton.boundedLengthAutomata(len, None))
            case -1 =>
              // ... or int >= |str|
              addRegex(-lc.constant,
                       len => BricsAutomaton.boundedLengthAutomata(0,Some(len)))
          }
          if (!success)
            return None
        }
      }

    Some(regexes.toSeq)
  }
}
