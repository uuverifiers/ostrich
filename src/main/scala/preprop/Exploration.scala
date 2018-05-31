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

import scala.collection.mutable.{HashMap => MHashMap, ArrayBuffer}

/**
 * A naive recursive implementation of depth-first exploration of a conjunction
 * of function applications
 */
class Exploration(val funApps : IndexedSeq[(PreOp, Seq[Term], Term)],
                  val initialConstraints : IndexedSeq[(Term, Automaton)]) {

  type TermConstraints = Seq[Automaton]

  // topological sorting of the function applications
  private val sortedFunApps : Seq[(Seq[(PreOp, Seq[Term])], Term)] = {
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

    sortedApps.toSeq
  }

  private def dfExplore(constraints : Map[Term, TermConstraints])
                      : Option[Map[Term, Seq[Int]]] = {
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

}