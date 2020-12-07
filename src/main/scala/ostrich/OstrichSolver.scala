/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2020 Matthew Hague, Philipp Ruemmer. All rights reserved.
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
import ap.terfor.{Term, TerForConvenience}
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

  import theory.{str_from_char, str_len, str_empty, str_cons, str_at, str_++,
                 str_in_re,
                 str_in_re_id, str_to_re, re_from_str,
                 str_replace, str_replacere, str_replaceall, str_replaceallre,
                 str_replacecg, str_replaceallcg, str_extract,
                 re_none, re_all, re_allchar, re_charrange,
                 re_++, re_union, re_inter, re_*, re_*?, re_+, re_+?, re_opt,
                 re_comp, re_loop, re_eps, re_capture, re_reference, FunPred}

  val rexOps : Set[IFunction] =
    Set(re_none, re_all, re_allchar, re_charrange, re_++, re_union, re_inter,
        re_*, re_*?, re_+, re_+?, re_opt, re_comp, re_loop, re_eps, str_to_re,
        re_from_str, re_capture, re_reference)

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

    val wordExtractor = theory.WordExtractor(goal)
    val regexExtractor = theory.RegexExtractor(goal)
    val cgTranslator = new Regex2PFA(theory)

//    Console.err.println(atoms)

    val concreteWords = new MHashMap[Term, Seq[Int]]
    findConcreteWords(atoms) match {
      case Some(w) => concreteWords ++= w
      case None => return None
    }

    // extract regex constraints and function applications from the
    // literals
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes = new ArrayBuffer[(Term, Automaton)]
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
            Console.err.println("Warning: could not decode regex id " + a(1))
        }
      }
      case lc =>
        Console.err.println("Warning: could not decode regex id " + lc)
    }

    ////////////////////////////////////////////////////////////////////////////

    for (a <- atoms.positiveLits) a.pred match {
      case FunPred(`str_from_char` | `str_cons` | `str_empty`)
        if concreteWords contains a.last =>
        // nothing, can be ignored
      case FunPred(`str_++`)
        if a forall { t => concreteWords contains t } =>
        // nothing, can be ignored
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, false)
      case FunPred(`str_++`) =>
        funApps += ((ConcatPreOp, List(a(0), a(1)), a(2)))
      case FunPred(`str_replaceall`) => {
        val b = (wordExtractor extractWord a(1)).asConcreteWord
        funApps += ((ReplaceAllPreOp(b map (_.toChar)), List(a(0), a(2)), a(3)))
      }
      case FunPred(`str_replace`) => {
        val b = (wordExtractor extractWord a(1)).asConcreteWord
        funApps += ((ReplacePreOp(b map (_.toChar)), List(a(0), a(2)), a(3)))
      }
      case FunPred(`str_replaceallre`) => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex).asInstanceOf[AtomicStateAutomaton]
        funApps += ((ReplaceAllPreOp(aut), List(a(0), a(2)), a(3)))
      }
      case FunPred(`str_replaceallcg`) => {
        val pat = regexExtractor regexAsTerm a(1)
        val rep = regexExtractor regexAsTerm a(2)
        val (info, repStr) = cgTranslator.buildReplaceInfo(pat, rep)
        funApps += ((ReplaceAllCGPreOp(info, repStr), List(a(0)), a(3)))
      }
      case FunPred(`str_replacecg`) => {
        val pat = regexExtractor regexAsTerm a(1)
        val rep = regexExtractor regexAsTerm a(2)
        val (info, repStr) = cgTranslator.buildReplaceInfo(pat, rep)
        funApps += ((ReplaceCGPreOp(info, repStr), List(a(0)), a(3)))
      }
      case FunPred(`str_replacere`) => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex).asInstanceOf[AtomicStateAutomaton]
        funApps += ((ReplacePreOp(aut), List(a(0), a(2)), a(3)))
      }
      case FunPred(`str_extract`) => {
        val index = a(0) match {
          case LinearCombination.Constant(IdealInt(v)) => v
          case _ => throw new IllegalArgumentException("Not an integer")
        }
        val regex = regexExtractor regexAsTerm a(2)
        val (newindex, info) = cgTranslator.buildExtractInfo(index, regex)
        funApps += ((ExtractPreOp(newindex, info), List(a(1)), a(3)))
      }
      case FunPred(`str_len`) => {
        lengthVars.put(a(0), a(1))
        if (a(1).isZero)
          regexes += ((a(0), BricsAutomaton fromString ""))
      }
      case FunPred(`str_at`) => {
        val LinearCombination.Constant(IdealInt(ind)) = a(1)
        funApps +=
          ((TransducerPreOp(BricsTransducer.getStrAtTransducer(ind)),
            List(a(0)), a(2)))
      }
      case FunPred(f) if rexOps contains f =>
        // nothing
      case FunPred(f) if theory.extraFunctionPreOps contains f => {
        val (op, argSelector, resSelector) = theory.extraFunctionPreOps(f)
        funApps += ((op, argSelector(a), resSelector(a)))
      }
      case pred if theory.transducerPreOps contains pred =>
        funApps += ((theory.transducerPreOps(pred), List(a(0)), a(1)))
      case p if (theory.predicates contains p) =>
        Console.err.println("Warning: ignoring " + a)
      case _ =>
        // nothing
    }

    ////////////////////////////////////////////////////////////////////////////

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
        Console.err.println("Warning: ignoring !" + a)
      case _ =>
        // nothing
    }

    ////////////////////////////////////////////////////////////////////////////

    {
      import TerForConvenience._
      implicit val o = order

      val lengthConstants =
        (for (t <- lengthVars.values.iterator;
              c <- t.constants.iterator) yield c).toSet

      for (lc <- goal.facts.arithConj.negativeEqs) lc match {
        case Seq((IdealInt.ONE, c), (IdealInt.MINUS_ONE, d))
          if concreteWords contains l(c) => {
            val str : String = concreteWords(l(c)).map(i => i.toChar)(breakOut)
            regexes += ((l(d), !(BricsAutomaton fromString str)))
        }
        case Seq((IdealInt.ONE, d), (IdealInt.MINUS_ONE, c))
          if concreteWords contains l(c) => {
            val str : String = concreteWords(l(c)).map(i => i.toChar)(breakOut)
            regexes += ((l(d), !(BricsAutomaton fromString str)))
        }
        case lc
          if useLength && (lc.constants forall lengthConstants) =>
          // nothing
        case _ =>
          Console.err.println("Warning: ignoring " + (lc =/= 0))
      }
    }

    ////////////////////////////////////////////////////////////////////////////

    // check whether any of the function applications can be evaluated
    {
      var changed = true
      while (changed) {
        changed = false

        for (n <- (funApps.size - 1) to 0 by -1) {
          val (op, args, res) = funApps(n)
          if (args forall (concreteWords contains _)) {
            op.eval(args map concreteWords) match {
              case Some(newRes) =>
                (concreteWords get res) match {
                  case Some(oldRes) =>
                    if (newRes != oldRes)
                      return None
                  case None =>
                    concreteWords.put(res, newRes)
                }
              case None =>
                return None
            }
            funApps remove n
            changed = true
          }
        }
      }
    }

    val interestingTerms =
      ((for ((t, _) <- regexes.iterator) yield t) ++
       (for ((_, args, res) <- funApps.iterator;
             t <- args.iterator ++ Iterator(res)) yield t)).toSet

    ////////////////////////////////////////////////////////////////////////////

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

          for ((strVar, lenTerm) <- lengthVars; str <- concreteWords get strVar)
            lengthProver addAssertion (lenTerm === str.size)

          Some(lengthProver)
        } else {
          None
        }

      val exploration =
        if (eagerMode)
          Exploration.eagerExp(funApps, regexes, concreteWords.toMap,
                               lProver, lengthVars.toMap, useLength, flags)
        else
          Exploration.lazyExp(funApps, regexes, concreteWords.toMap,
                              lProver, lengthVars.toMap, useLength, flags)

      exploration.findModel match {
        case Some(model) =>
          Some(model ++ (for ((v, w) <- concreteWords) yield (v, Right(w))))
        case None =>
          None
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  private object Inconsistent extends Exception

  private def findConcreteWords(atoms : PredConj)
                              : Option[Map[Term, Seq[Int]]] = try {
    val res = new MHashMap[Term, Seq[Int]]

    def assign(t : Term, w : Seq[Int]) : Unit =
      (res get t) match {
        case Some(u) =>
          if (u != w)
            // inconsistent words
            throw Inconsistent
        case None =>
          res.put(t, w)
      }

    for (a <- atoms positiveLitsWithPred p(str_empty))
      assign(a.last, List())
    for (a <- atoms positiveLitsWithPred p(str_from_char)) {
      if (!a.head.isConstant)
        throw new Exception("Cannot handle " + a)
      assign(a.last, List(a.head.constant.intValueSafe))
    }

    var oldSize = 0
    while (res.size > oldSize) {
      oldSize = res.size

      for (a <- atoms positiveLitsWithPred p(str_++))
        if ((res contains a(0)) && (res contains a(1)))
          assign(a(2), res(a(0)) ++ res(a(1)))

      for (a <- atoms positiveLitsWithPred p(str_cons)) {
        if (!a.head.isConstant)
          throw new Exception("Cannot handle " + a)
        if (res contains a(1))
          assign(a(2), List(a(0).constant.intValueSafe) ++ res(a(1)))
      }
    }

    Some(res.toMap)
  } catch {
    case Inconsistent => None
  }

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
