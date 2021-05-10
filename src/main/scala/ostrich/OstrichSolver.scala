/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2021 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ap.SimpleAPI
import ap.parser.IFunction
import ap.terfor.{Term, TerForConvenience, ConstantTerm, OneTerm}
import ap.terfor.preds.{PredConj, Atom}
import ap.terfor.linearcombination.LinearCombination
import ap.types.Sort
import ap.proof.goal.Goal
import ap.basetypes.IdealInt

import dk.brics.automaton.{RegExp, Automaton => BAutomaton}

import scala.collection.breakOut
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

class OstrichSolver(theory : OstrichStringTheory,
                    flags : OFlags) {

  import theory.{str_from_char, str_len, str_empty, str_cons, str_++,
                 str_in_re,
                 str_in_re_id, str_to_re, re_from_str, re_from_ecma2020,
                 re_case_insensitive,
                 str_replace, str_replacere, str_replaceall, str_replaceallre,
                 str_prefixof,
                 re_none, re_all, re_allchar, re_charrange,
                 re_++, re_union, re_inter, re_diff, re_*, re_+, re_opt,
                 re_comp, re_loop, re_eps, FunPred, strDatabase}

  val rexOps : Set[IFunction] =
    Set(re_none, re_all, re_allchar, re_charrange, re_++, re_union, re_inter,
        re_diff, re_*, re_+, re_opt, re_comp, re_loop, re_eps, str_to_re,
        re_from_str, re_from_ecma2020, re_case_insensitive)

  private val p = theory.functionPredicateMap

  private val autDatabase = theory.autDatabase

  def findStringModel(goal : Goal)
                    : Option[Map[Term, Either[IdealInt, Seq[Int]]]] = {
    val atoms = goal.facts.predConj
    val order = goal.order

    val containsLength = !(atoms positiveLitsWithPred p(str_len)).isEmpty
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

    val wordExtractor =
      theory.WordExtractor(goal)
    val regexExtractor =
      theory.RegexExtractor(goal)
    val stringFunctionTranslator =
      new OstrichStringFunctionTranslator(theory, goal.facts)

    // extract regex constraints and function applications from the
    // literals
    val funApps    = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes    = new ArrayBuffer[(Term, Automaton)]
    val lengthVars = new MHashMap[Term, Term]

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
               c <- t.constants.iterator) yield c)).toSet
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
        case lc if lc.constants exists stringConstants =>
          throw new Exception ("Cannot handle negative string equation " +
                                 (lc =/= 0))
        case _ =>
          // nothing
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

      exploration.findModel
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  /**
   * Translate term in a regex argument position into an automaton
   * returns a string if it detects only one word is accepted
   */
/*
  private def regexValue(regex : Term, regex2AFA : Regex2AFA)
      : Either[String,AtomicStateAutomaton] = {
    val b = (regex2AFA buildStrings regex).next
    if (!b.isEmpty && b(0).isLeft) {
      // In this case we've been given a string regex and expect it
      // to start and end with / /
      // if it just defines one string, treat it as a replaceall
      // else treat it as true replaceall-re
      val stringB : String = b.map(_.left.get.toChar)(collection.breakOut)
      if (stringB(0) != '/' || stringB.last != '/')
        throw new IllegalArgumentException("regex defined with a string argument expects the regular expression to start and end with /")
      val sregex = stringB.slice(1, stringB.size - 1)
      val baut = new RegExp(sregex, RegExp.NONE).toAutomaton(true)
      val w = baut.getSingleton
      if (w != null)
        return Left(w)
      else
        return Right(new BricsAutomaton(baut))
    } else {
      return Right(BricsAutomaton(regex2AFA buildRegex regex))
    }
  }
*/
}
