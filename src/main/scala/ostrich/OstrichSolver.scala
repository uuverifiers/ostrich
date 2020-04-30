/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2018-2020  Matthew Hague, Philipp Ruemmer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package ostrich

import ap.SimpleAPI
import ap.parser.IFunction
import ap.terfor.{Term, TerForConvenience}
import ap.terfor.preds.PredConj
import ap.types.Sort
import ap.proof.goal.Goal
import ap.basetypes.IdealInt

import dk.brics.automaton.{RegExp, Automaton => BAutomaton}

import scala.collection.breakOut
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

class OstrichSolver(theory : OstrichStringTheory,
                    flags : OFlags) {

  import theory.{str, str_len, str_empty, str_cons, str_++, str_in_re,
                 str_to_re,
                 str_replace, str_replacere, str_replaceall, str_replaceallre,
                 re_none, re_all, re_allchar, re_charrange,
                 re_++, re_union, re_inter, re_*, re_+, re_opt,
                 FunPred}

  val rexOps : Set[IFunction] =
    Set(re_none, re_all, re_allchar, re_charrange, re_++, re_union, re_inter,
        re_*, re_+, re_opt, str_to_re)

  private val p = theory.functionPredicateMap

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
    val regex2Aut = new Regex2Aut(theory)

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

    for (a <- atoms.positiveLits) a.pred match {
      case FunPred(`str` | `str_cons` | `str_empty`)
        if concreteWords contains a.last =>
        // nothing, can be ignored
      case FunPred(`str_++`)
        if a forall { t => concreteWords contains t } =>
        // nothing, can be ignored
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = regex2Aut buildAut regex
        regexes += ((a.head, aut))
      }
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
        val aut = regex2Aut buildAut regex
        funApps += ((ReplaceAllPreOp(aut), List(a(0), a(2)), a(3)))
      }
      case FunPred(`str_replacere`) => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = regex2Aut buildAut regex
        funApps += ((ReplacePreOp(aut), List(a(0), a(2)), a(3)))
      }
      case FunPred(`str_len`) => {
        lengthVars.put(a(0), a(1))
        if (a(1).isZero)
          regexes += ((a(0), BricsAutomaton fromString ""))
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

    for (a <- atoms.negativeLits) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = regex2Aut buildAut regex
        regexes += ((a.head, !aut))
      }
      case pred if theory.transducerPreOps contains pred =>
        throw new Exception ("Cannot handle negated transducer constraint " + a)
      case p if (theory.predicates contains p) =>
        Console.err.println("Warning: ignoring !" + a)
      case _ =>
        // nothing
    }

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
    for (a <- atoms positiveLitsWithPred p(str)) {
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
