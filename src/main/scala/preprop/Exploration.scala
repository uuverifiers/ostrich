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

package strsolver.preprop

import ap.terfor.Term
import ap.util.Seqs

import scala.collection.mutable.{HashMap => MHashMap, ArrayBuffer}

/**
 * A naive recursive implementation of depth-first exploration of a conjunction
 * of function applications
 */
class Exploration(val funApps : Seq[(PreOp, Seq[Term], Term)],
                  val initialConstraints : Seq[(Term, Automaton)]) {

  println
  println("Running preprop solver")

  // topological sorting of the function applications
  private val (allTerms, sortedFunApps)
              : (Set[Term], Seq[(Seq[(PreOp, Seq[Term])], Term)]) = {
    val argTermNum = new MHashMap[Term, Int]
    for ((_, _, res) <- funApps)
      argTermNum.put(res, 0)
    for ((_, args, _) <- funApps; a <- args)
      argTermNum.put(a, argTermNum.getOrElse(a, 0) + 1)

    var remFunApps = funApps
    val sortedApps = new ArrayBuffer[(Seq[(PreOp, Seq[Term])], Term)]

    while (!remFunApps.isEmpty) {
      val (selectedApps, otherApps) =
        remFunApps partition { case (_, _, res) => argTermNum(res) == 0 }
      remFunApps = otherApps

      for ((_, args, _) <- selectedApps; a <- args)
        argTermNum.put(a, argTermNum.getOrElse(a, 0) - 1)

      assert(!selectedApps.isEmpty)

      val appsPerRes = selectedApps groupBy (_._3)
      val nonArgTerms = (selectedApps map (_._3)).distinct

      for (t <- nonArgTerms)
        sortedApps +=
          ((for ((op, args, _) <- appsPerRes(t)) yield (op, args), t))
    }

    (argTermNum.keySet.toSet, sortedApps.toSeq)
  }

  println("   Considered function applications:")
  for ((apps, res) <- sortedFunApps) {
    println("   " + res + " =")
    for ((op, args) <- apps)
      println("     " + op + "(" + (args mkString ", ") + ")")
  }

  //////////////////////////////////////////////////////////////////////////////

  def findModel : Option[Map[Term, Seq[Int]]] = {
    val constraints =
      (for (t <- allTerms.iterator) yield (t, List())).toMap ++
      (initialConstraints groupBy (_._1) mapValues {
        case auts => canonise(auts map (_._2))
       })

    val funAppList =
      (for ((apps, res) <- sortedFunApps;
            (op, args) <- apps)
       yield (op, args, res)).toList

    if (constraints.values exists (!isConsistent(_)))
      None
    else
      dfExplore(funAppList, constraints)
  }

  private def dfExplore(apps : List[(PreOp, Seq[Term], Term)],
                        constraints : ConstraintMap)
                      : Option[Map[Term, Seq[Int]]] = apps match {

    case List() =>
      // we are finished and just have to construct a model
      Some(Map()) // ...
    case (op, args, res) :: otherApps =>
      dfExploreOp(op, args, constraints(res).toList,
                  otherApps, constraints)
  }

  private def dfExploreOp(op : PreOp,
                          args : Seq[Term],
                          resConstraints : List[Automaton],
                          nextApps : List[(PreOp, Seq[Term], Term)],
                          constraints : ConstraintMap)
                        : Option[Map[Term, Seq[Int]]] = resConstraints match {
    case List() =>
      dfExplore(nextApps, constraints)
    case resAut :: otherAuts =>
      Seqs.some(for (argCS <- op(args map constraints, resAut)) yield {
        for (newConstraints <- extend(constraints, args zip argCS);
             res <- dfExploreOp(op, args, otherAuts, nextApps, newConstraints))
        yield res
      })
  }

  //////////////////////////////////////////////////////////////////////////////

  type TermConstraints = Seq[Automaton]
  type ConstraintMap = Map[Term, TermConstraints]

  private def extend(constraints : ConstraintMap,
                     newC : Seq[(Term, Automaton)]) : Option[ConstraintMap] = {
    var res : Option[ConstraintMap] = Some(constraints)
    val newCIt = newC.iterator
    while (res.isDefined && newCIt.hasNext) {
      val (t, aut) = newCIt.next
      res = extend(res.get, t, aut)
    }
    res
  }

  private def extend(constraints : ConstraintMap,
                     t : Term, aut : Automaton) : Option[ConstraintMap] = {
    val oldC = constraints(t)
    val newC = canonise(oldC ++ List(aut))
    if (isConsistent(newC))
      Some(constraints + (t -> newC))
    else
      None
  }

  private def canonise(cs : TermConstraints) : TermConstraints = cs match {
    case Seq() | Seq(_) => cs
    case cs             => List(cs reduceLeft (_ & _))
  }

  private def isConsistent(cs : TermConstraints) : Boolean = cs match {
    case Seq()    => true
    case Seq(aut) => !aut.isEmpty
    case cs       => isConsistent(canonise(cs))
  }

  private def findElement(cs : TermConstraints) : Seq[Int] = cs match {
    case Seq()    => List()
    case Seq(aut) => aut.getAcceptedWord.get
    case cs       => findElement(canonise(cs))
  }

}