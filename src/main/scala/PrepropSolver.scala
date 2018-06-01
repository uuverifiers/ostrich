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
                          ConcatPreOp, ReplaceAllPreOp}

import ap.terfor.Term
import ap.proof.goal.Goal

import scala.collection.mutable.ArrayBuffer

class PrepropSolver {

  import StringTheory.{member, replaceall, replace,
                       wordEps, wordCat, wordChar, wordDiff,
                       rexEmpty, rexEps, rexSigma,
                       rexStar, rexUnion, rexChar, rexCat, rexNeg, rexRange,
                       FunPred}

  val rexOps = Set(rexEmpty, rexEps, rexSigma,
                   rexStar, rexUnion, rexChar, rexCat, rexNeg, rexRange)

  private val p = StringTheory.functionPredicateMap

  def findStringModel(goal : Goal) : Option[Map[Term, List[Int]]] = {
    val atoms = goal.facts.predConj
    val regex2AFA = new Regex2AFA(atoms)

    println(atoms)

    // extract regex constraints and function applications from the
    // literals
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes = new ArrayBuffer[(Term, Automaton)]

    for (a <- atoms.positiveLits) a.pred match {
      case `member` =>
        regexes += ((a.head, BricsAutomaton(a.last, atoms)))
      case FunPred(`wordCat`) =>
        funApps += ((ConcatPreOp, List(a(0), a(1)), a(2)))
      case FunPred(`replaceall`) =>
        println(a)
        println("replaced string: " + (regex2AFA buildStrings a(1)).next)
        funApps += ((ReplaceAllPreOp, List(a(0), a(1), a(2)), a(3)))
      case FunPred(f) if rexOps contains f =>
        // nothing
      case _ =>
        Console.err.println("Warning: ignoring " + a)
    }

    val exploration = new Exploration(funApps, regexes)

    exploration.findModel match {
      case Some(model) => Some(model mapValues (_.toList))
      case None        => None
    }
  }

}
