/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2018  Matthew Hague, Philipp Ruemmer
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

package strsolver

import strsolver.preprop.{PreOp, Exploration, Automaton, BricsAutomaton,
                          ConcatPreOp, ReplaceAllPreOp, ReversePreOp}

import ap.SimpleAPI
import ap.terfor.Term
import ap.terfor.preds.PredConj
import ap.types.Sort
import ap.proof.goal.Goal

import scala.collection.breakOut
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

class PrepropSolver {

  import StringTheory.{member, replaceall, replaceallre, replace, reverse,
                       wordEps, wordCat, wordChar, wordDiff, wordLen,
                       rexEmpty, rexEps, rexSigma,
                       rexStar, rexUnion, rexChar, rexCat, rexNeg, rexRange,
                       FunPred}

  val rexOps = Set(rexEmpty, rexEps, rexSigma,
                   rexStar, rexUnion, rexChar, rexCat, rexNeg, rexRange)

  private val p = StringTheory.functionPredicateMap

  def findStringModel(goal : Goal) : Option[Map[Term, List[Int]]] = {
    val atoms = goal.facts.predConj
    val order = goal.order
    val regex2AFA = new Regex2AFA(atoms)

//    println(atoms)

    val concreteWords = findConcreteWords(atoms) match {
      case Some(w) => w
      case None => return None
    }

    // extract regex constraints and function applications from the
    // literals
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes = new ArrayBuffer[(Term, Automaton)]
    val lengthVars = new MHashMap[Term, Term]

    for (a <- atoms.positiveLits) a.pred match {
      case FunPred(`wordChar` | `wordEps`)
        if concreteWords contains a.last =>
        // nothing, can be ignored
      case FunPred(`wordCat`)
        if a forall { t => concreteWords contains t } =>
        // nothing, can be ignored
      case `member` =>
        regexes += ((a.head, BricsAutomaton(a.last, atoms)))
      case FunPred(`wordCat`) =>
        funApps += ((ConcatPreOp, List(a(0), a(1)), a(2)))
      case FunPred(`replaceall`) => {
        val b = (regex2AFA buildStrings a(1)).next
        funApps += ((ReplaceAllPreOp(b), List(a(0), a(2)), a(3)))
      }
      case FunPred(`replaceallre`) => {
        val b = (regex2AFA buildStrings a(1)).next
        val regex = (regex2AFA buildRegex a(1))
        funApps += ((ReplaceAllPreOp(BricsAutomaton(regex)), List(a(0), a(2)), a(3)))
      }
      case FunPred(`wordLen`) =>
        lengthVars.put(a(0), a(1))
      case FunPred(`reverse`) =>
        funApps += ((ReversePreOp, List(a(0)), a(1)))
      case FunPred(f) if rexOps contains f =>
        // nothing
      case p if (StringTheory.predicates contains p) =>
        Console.err.println("Warning: ignoring " + a)
      case _ =>
        // nothing
    }

    for (a <- atoms.negativeLits) a.pred match {
      case p if (StringTheory.predicates contains p) =>
        Console.err.println("Warning: ignoring !" + a)
      case _ =>
        // nothing
    }

    val interestingTerms =
      ((for ((t, _) <- regexes.iterator) yield t) ++
       (for ((_, args, res) <- funApps.iterator;
             t <- args.iterator ++ Iterator(res)) yield t)).toSet

    for (t <- interestingTerms)
      (concreteWords get t) match {
        case Some(w) => {
          val str : String = w.map(i => i.toChar)(breakOut)
          regexes += ((t, BricsAutomaton fromString str))
        }
        case None =>
          // nothing
      }

    SimpleAPI.withProver { lengthProver =>
      val lProver =
        if (Flags.useLength) {
          lengthProver setConstructProofs true
          lengthProver.addConstantsRaw(order sort order.orderedConstants)

/*
          val lengthConsts = (for (t <- lengthVars.values.iterator;
                                   c <- t.constants.iterator)
                              yield c).toSet
          for (f <- goal.facts.arithConj.iterator)
            if (f.constants subsetOf lengthConsts)
              lengthProver addAssertion f
 */

          for (t <- interestingTerms)
            lengthVars.getOrElseUpdate(
              t, lengthProver.createConstantRaw("" + t + "_len", Sort.Nat))
              
          Some(lengthProver)
        } else {
          None
        }

      val exploration =
        if (Flags.eagerAutomataOperations)
          Exploration.eagerExp(funApps, regexes,
                               lProver, lengthVars.toMap)
        else
          Exploration.lazyExp(funApps, regexes,
                              lProver, lengthVars.toMap)

      exploration.findModel match {
        case Some(model) => Some((model mapValues (_.toList)) ++
                                 (concreteWords mapValues (_.toList)))
        case None        => None
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

    for (a <- atoms positiveLitsWithPred p(wordEps))
      assign(a.last, List())
    for (a <- atoms positiveLitsWithPred p(wordChar)) {
      if (!a.head.isConstant)
        throw new Exception("Cannot handle " + a)
      assign(a.last, List(a.head.constant.intValueSafe))
    }

    var oldSize = 0
    while (res.size > oldSize) {
      oldSize = res.size

      for (a <- atoms positiveLitsWithPred p(wordCat))
        if ((res contains a(0)) && (res contains a(1)))
          assign(a(2), res(a(0)) ++ res(a(1)))
    }

    Some(res.toMap)
  } catch {
    case Inconsistent => None
  }

}
