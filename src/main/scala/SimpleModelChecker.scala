/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
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

import org.sat4j.minisat.SolverFactory
import org.sat4j.core.{Vec, VecInt}
import org.sat4j.specs.{IVecInt}
import org.sat4j.tools.{ModelIterator}

import scala.collection.mutable


object SimpleModelChecker {
  type Clauses = mutable.LinkedHashSet[IVecInt]

  val solver = SolverFactory.newDefault()
  val finalCond = SolverFactory.newDefault()
  var formula2lit = Map.empty[AFormula, (Int, Clauses)]
  var lit2state = Map.empty[Int, Int]

  private def update(af: AFormula, clauses: Clauses = mutable.LinkedHashSet.empty[IVecInt]) = {
    val res = formula2lit.size + 1

    formula2lit += af -> (res, clauses)

    res
  }

  private def decodeRange(af: AFormula, vars: IndexedSeq[AFormula]): AFormula = af match {
    case AFLet(definition, in) =>
      decodeRange(in, decodeRange(definition, vars) +: vars)

    case AFAnd(sub1, sub2) => decodeRange(sub1, vars) & decodeRange(sub2, vars)
    case AFOr(sub1, sub2) => decodeRange(sub1, vars) | decodeRange(sub2, vars)
    case AFNot(sub) => ~decodeRange(sub, vars)
    case AFDeBrujinVar(ind) => vars(ind)
    case s => s
  }

  private def buildClauses(af: AFormula): (Int, Clauses) = af match {
    case and@AFAnd(sub1, sub2) =>
      val (lit1, cl1) = formula2lit getOrElse(sub1, buildClauses(sub1))
      val (lit2, cl2) = formula2lit getOrElse(sub2, buildClauses(sub2))
      val clauses = cl1 ++ cl2
      val lit = update(and, clauses)

      clauses += new VecInt(Array(-lit, lit1))
      clauses += new VecInt(Array(-lit, lit2))
      clauses += new VecInt(Array(lit, -lit1, -lit2))

      (lit, clauses)

    case or@AFOr(sub1, sub2) =>
      val (lit1, cl1) = formula2lit getOrElse(sub1, buildClauses(sub1))
      val (lit2, cl2) = formula2lit getOrElse(sub2, buildClauses(sub2))
      val clauses = cl1 ++ cl2
      val lit = update(or, clauses)

      clauses += new VecInt(Array(lit, -lit1))
      clauses += new VecInt(Array(lit, -lit2))
      clauses += new VecInt(Array(-lit, lit1, lit2))

      (lit, clauses)

    case l:AFLet =>
      val formula = decodeRange(l, IndexedSeq.empty)

      formula2lit getOrElse(formula, buildClauses(formula))

    case AFNot(sub) =>
      val (lit, cl) = formula2lit getOrElse(sub, buildClauses(sub))

      (-lit, cl)

    case s@AFStateVar(v) =>
      val clauses = mutable.LinkedHashSet.empty[IVecInt]
      val lit = update(s, clauses)

      lit2state += lit -> v

      (lit, clauses)

    case v =>
      val clauses = mutable.LinkedHashSet.empty[IVecInt]

      (update(v, clauses), clauses)
  }

  private def xor(vars: Set[Int], clauses: Clauses) = if(vars.size > 1) {
    var tail = vars
    var res: Clauses = mutable.LinkedHashSet.empty

    res += new VecInt(vars.toArray)

    for (x <- vars.init) {
      tail = tail.tail
      for (y <- tail) {
        res += new VecInt(Array(-x, -y))
      }
    }

    clauses ++= res
  }

  private def buildClausesFromFormula(f: AFormula) = {
    (formula2lit getOrElse(f, {
      val (lit, cl) = buildClauses(f)
      val clauses = cl + new VecInt(Array(lit))

      (lit, clauses)
    }))._2
  }

  private def nextStates(lits: Array[Int]) = {
    var res = Set.empty[Int]

    for (lit <- lits) lit2state get lit match {
      case None =>
      case Some(s) => res += s
    }

    res
  }

  def apply(afa: AFA): Boolean = {
    solver.reset
    solver.newVar(100000)
    finalCond.reset
    finalCond.newVar(100000)
    formula2lit = Map.empty[AFormula, (Int, Clauses)]
    lit2state = Map.empty[Int, Int]

    val transitions = afa.states map {s =>
      val clauses = buildClausesFromFormula(s)

      xor(s.getStates.map(s => formula2lit(AFStateVar(s))._1), clauses)
      new Vec[IVecInt](clauses.toArray)
    }


    var workList = mutable.LinkedHashSet[Set[Int]]()
    val initSolver = SolverFactory.newDefault()
    val initConstr = new VecInt()

    initSolver.reset
    initSolver.newVar(100000)
    initSolver.addAllClauses(new Vec[IVecInt](buildClausesFromFormula(afa.initialStates).toArray))

    val initIt = new ModelIterator(initSolver)
    while (initIt.isSatisfiable(initConstr)) {
      val model = initIt.model
      val states = nextStates(model)

      workList += states
    }

    val it = new ModelIterator(solver)
    val size = workList.head.size
    val visited =  mutable.LinkedHashSet.empty[Set[Int]]

    finalCond.addAllClauses(new Vec[IVecInt](buildClausesFromFormula(afa.finalStates).toArray))
    while(workList.nonEmpty) {
      val states = workList.last
      var constr = new VecInt()
      val finalAssumps = new VecInt((states map { s => formula2lit(AFStateVar(s))._1 }).toArray)

      visited += states
      workList = workList.init
      if (states.size == size && finalCond.isSatisfiable(finalAssumps)) {
        return true
      }


      solver.reset
      states foreach(s => solver.addAllClauses(transitions(s)))
      while (it.isSatisfiable) {
        val model = it.model
        val next = nextStates(model)

        constr = new VecInt((next map { s => -formula2lit(AFStateVar(s))._1 }).toArray)
        solver.addClause(constr)
        if (next.size == size && !workList(next) && !visited(next)) {
          workList += next
        }
      }
    }

    false
  }
}
