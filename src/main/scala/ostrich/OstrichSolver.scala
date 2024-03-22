/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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
import dk.brics.automaton.{RegExp, Automaton => BAutomaton}

import scala.collection.breakOut
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap, HashSet => MHashSet}
import scala.util.control.Breaks.{break, breakable}

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

    val pos_length = atoms.positiveLitsWithPred(p(str_len))
    val length_vars = new MHashSet[Atom]()
    val regex_length_vars = new MHashSet[Atom]()

    val regex_ineq_vars = new MHashSet[Term]()
    val lower_bounds = new MHashMap[Term, Int]()
    val upper_bounds = new MHashMap[Term, Int]()
    var is_monadic = true
    breakable {
      for (atom <- pos_length) {
        if (!atom(1).isConstant) {
          if (atom(1).head._1.intValueSafe != 1){
            // TODO handle case if the variable inside str_len is not 1
            is_monadic = false
            break
          }
          length_vars.add(atom)
          if (atom(1).length > 1){
            is_monadic = false
            break
          }
          // Constraint is monadic and of the form int <= |str| <= int
          // (Z, var) and (Y, var) appear -> Z and Y not monadic
          if (!pos_length.exists(atom1 => atom1(1) == atom(1) && atom1(0) != atom(0))) {
            val ineqs = goal.facts.arithConj.inEqs
              .filter(ineq => ineq.head._2 == atom(1).head._2)


            for (ineq <- ineqs) {
              if (ineq.length > 2) {
                is_monadic = false
                break
              }
              // More than one variable appears in the ineq
              if (!(ineq.head._2.constants.isEmpty || ineq.last._2.constants.isEmpty)){
                is_monadic = false
                break
              }
              if (ineq.head._1.intValueSafe < 0) {
                if (ineq.length == 2) {
                  upper_bounds.put(atom(0), ineq.last._1.intValueSafe)
                  regex_ineq_vars.add(atom(0))
                }
                // if ineq length == 1, then unsat -- this should have been detected by preprocess
              }
              else {

                // if ineq length == 1, then default lower bound = 0
                if (ineq.length == 2) {
                  regex_ineq_vars.add(atom(0))
                  lower_bounds.put(atom(0), ineq.last._1.intValueSafe * -1)
                }
                if (ineq.length == 1){
                  lower_bounds.put(atom(0), 0)
                }
              }

            }

          }
          else {
            is_monadic = false
            break
          }
        }
        else {
          // Constraint is equality int = |str|
          regex_length_vars.add(atom)
        }
      }
    }

    val containsLength = (atoms positiveLitsWithPred p(str_len)).nonEmpty && !is_monadic
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

    // extract regex constraints and function applications from the
    // literals
    val funApps    = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes    = new ArrayBuffer[(Term, Automaton)]
    val negEqs     = new ArrayBuffer[(Term, Term)]
    val lengthVars = new MHashMap[Term, Term]

    ////////////////////////////////////////////////////////////////////////////

    // If no len constraints needed, add the computed length regexes and add them
    if (is_monadic){
      regexes ++= createBoundedLengthRegex(regex_ineq_vars, lower_bounds,upper_bounds)
      regexes ++= createEqRegex(regex_length_vars)
    }

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

  def createEqRegex(atoms: MHashSet[Atom]): ArrayBuffer[(Term, Automaton)] = {
    val regexes = new ArrayBuffer[(Term,Automaton)]
    for (atom <- atoms){
      assert(atom(1).isConstant)
      regexes += ((atom(0),BricsAutomaton.eqLengthAutomata(atom(1).head._1.intValueSafe)))
    }
    regexes
  }

  def createBoundedLengthRegex(terms: MHashSet[Term], lowerBounds :MHashMap[Term, Int], upperBounds: MHashMap[Term, Int]): ArrayBuffer[(Term, Automaton)] = {
    val regexes = new ArrayBuffer[(Term,Automaton)]
    for (variable <- terms){
      regexes += ((variable, BricsAutomaton.boundedLengthAutomata(lowerBounds.getOrElse(variable, 0),upperBounds.get(variable))))
    }
    regexes
  }
}
