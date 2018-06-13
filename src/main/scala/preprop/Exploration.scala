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

import scala.collection.mutable.{HashMap => MHashMap, ArrayBuffer, ArrayStack,
                                 HashSet => MHashSet}

object Exploration {
  case class TermConstraint(t : Term, aut : Automaton)

  abstract class ConstraintStore {
    def push : Unit
    
    def pop : Unit

    /**
     * Add new automata to the store, return a sequence of term constraints
     * in case the asserted constraints have become inconsistent
     */
    def assertConstraint(aut : Automaton) : Option[Seq[TermConstraint]]

    def getContents : List[Automaton]
  }

  def eagerExp(funApps : Seq[(PreOp, Seq[Term], Term)],
               initialConstraints : Seq[(Term, Automaton)]) : Exploration =
    new EagerExploration(funApps, initialConstraints)

  def lazyExp(funApps : Seq[(PreOp, Seq[Term], Term)],
              initialConstraints : Seq[(Term, Automaton)]) : Exploration =
    new LazyExploration(funApps, initialConstraints)
}

/**
 * A naive recursive implementation of depth-first exploration of a conjunction
 * of function applications
 */
abstract class Exploration(val funApps : Seq[(PreOp, Seq[Term], Term)],
                           val initialConstraints : Seq[(Term, Automaton)]) {

  import Exploration._

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

  private val constraintStores = new MHashMap[Term, ConstraintStore]

  def findModel : Option[Map[Term, Seq[Int]]] = {
    for (t <- allTerms)
      constraintStores.put(t, newStore(t))

    for ((t, aut) <- initialConstraints)
      constraintStores(t).assertConstraint(aut) match {
        case Some(_) => return None
        case None    => // nothing
      }

    val funAppList =
      (for ((apps, res) <- sortedFunApps;
            (op, args) <- apps)
       yield (op, args, res)).toList

    val res = dfExplore(funAppList)

    println("nr of pre-op applications: " + preopCnt)

    res
  }

  private var preopCnt = 0

  private def dfExplore(apps : List[(PreOp, Seq[Term], Term)])
                      : Option[Map[Term, Seq[Int]]] = apps match {

    case List() =>
      // we are finished and just have to construct a model
      Some(Map()) // ...
    case (op, args, res) :: otherApps =>
      dfExploreOp(op, args, constraintStores(res).getContents,
                  otherApps)
  }

  private def dfExploreOp(op : PreOp,
                          args : Seq[Term],
                          resConstraints : List[Automaton],
                          nextApps : List[(PreOp, Seq[Term], Term)])
                        : Option[Map[Term, Seq[Int]]] = resConstraints match {
    case List() =>
      dfExplore(nextApps)
      
    case resAut :: otherAuts => {
      preopCnt = preopCnt + 1
      ap.util.Timeout.check

      val argConstraints = for (a <- args) yield constraintStores(a).getContents
      
      Seqs.some(for (argCS <- op(argConstraints, resAut)) yield {
        for (a <- args)
          constraintStores(a).push

        var consistent = true
        for ((a, aut) <- args zip argCS)
          if (consistent)
            constraintStores(a).assertConstraint(aut) match {
              case Some(_) => consistent = false
              case None    => // nothing
            }

        val res =
          if (consistent)
            dfExploreOp(op, args, otherAuts, nextApps)
          else
            None

        for (a <- args)
          constraintStores(a).pop

        res
      })
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  protected def newStore(t : Term) : ConstraintStore

}

////////////////////////////////////////////////////////////////////////////////

/**
 * Version of exploration that eagerly computes products of regex constraints.
 */
class EagerExploration(_funApps : Seq[(PreOp, Seq[Term], Term)],
                       _initialConstraints : Seq[(Term, Automaton)])
      extends Exploration(_funApps, _initialConstraints) {

  import Exploration._

  protected def newStore(t : Term) : ConstraintStore = new ConstraintStore {
    private var currentConstraint : Option[Automaton] = None
    private val constraintStack = new ArrayStack[Option[Automaton]]

    def push : Unit = constraintStack push currentConstraint
    
    def pop : Unit = currentConstraint = constraintStack.pop

    def assertConstraint(aut : Automaton) : Option[Seq[TermConstraint]] =
      if (aut.isEmpty) {
        Some(List(TermConstraint(t, aut)))
      } else {
        currentConstraint match {
          case Some(oldAut) => {
            val newAut = oldAut & aut
            if (newAut.isEmpty) {
              Some(List(TermConstraint(t, oldAut), TermConstraint(t, aut)))
            } else {
              currentConstraint = Some(newAut)
              None
            }
          }
          case None => {
            currentConstraint = Some(aut)
            None
          }
        }
      }

    def getContents : List[Automaton] =
      currentConstraint.toList
  }

}

////////////////////////////////////////////////////////////////////////////////

/**
 * Version of exploration that keeps automata separate and avoids computation
 * of products. No caching yet
 */
class LazyExploration(_funApps : Seq[(PreOp, Seq[Term], Term)],
                      _initialConstraints : Seq[(Term, Automaton)])
      extends Exploration(_funApps, _initialConstraints) {

  import Exploration._

  private val stores = new ArrayBuffer[Store]

  // Combinations of automata that are known to have empty intersection
  private val inconsistentAutomata = new ArrayBuffer[Seq[Automaton]]

  private def addIncAutomata(auts : Seq[Automaton]) : Unit = {
    inconsistentAutomata += auts
//    println("Watching " + inconsistentAutomata.size + " sets of inconsistent automata")
    val ind = inconsistentAutomata.size - 1
    for (s <- stores) {
      val r = s.watchAutomata(auts, ind)
      assert(r)
    }
  }

  protected def newStore(t : Term) : ConstraintStore = new Store(t)

  private class Store(t : Term) extends ConstraintStore {
    private val constraints = new ArrayBuffer[Automaton]
    private val constraintSet = new MHashSet[Automaton]
    private val constraintStack = new ArrayStack[Int]

    // Map from watched automata to the indexes of
    // <code>inconsistentAutomata</code> that is watched
    private val watchedAutomata = new MHashMap[Automaton, List[Int]]

    // Add a new entry to <code>watchedAutomata</code>; return
    // <code>false</code> in case the set of new automata is a subset of the
    // asserted constraints
    def watchAutomata(auts : Seq[Automaton], ind : Int) : Boolean =
      // TODO: we should randomise at this point!
      (auts find { a => !(constraintSet contains a) }) match {
        case Some(aut) => {
          watchedAutomata.put(aut,
                              ind :: watchedAutomata.getOrElse(aut, List()))
          true
        }
        case None =>
          false
      }

    def push : Unit = constraintStack push constraints.size
    
    def pop : Unit = {
      val oldSize = constraintStack.pop
      while (constraints.size > oldSize) {
        constraintSet -= constraints.last
        constraints reduceToSize (constraints.size - 1)
      }
    }

    def assertConstraint(aut : Automaton) : Option[Seq[TermConstraint]] =
      if (constraintSet contains aut) {
        None
      } else {
        var potentialConflicts =
          (watchedAutomata get aut) match {
            case Some(incAuts) => {
              // need to find new watched automata for the found conflicts
              watchedAutomata -= aut
              incAuts
            }
            case None =>
              List()
          }

        while (!potentialConflicts.isEmpty) {
          val autInd = potentialConflicts.head

          if (!watchAutomata(inconsistentAutomata(autInd), autInd)) {
            // constraints have become inconsistent!
            watchedAutomata.put(aut, potentialConflicts)
            println("Stored conflict applies!")
            return Some(for (a <- inconsistentAutomata(autInd).toList)
                        yield TermConstraint(t, a))
          }
            
          potentialConflicts = potentialConflicts.tail
        }

        if (aut.isEmpty) {
          addIncAutomata(List(aut))
          Some(List(TermConstraint(t, aut)))
        } else {
          AutomataUtils.findUnsatCore(constraints, aut) match {
            case Some(core) => {
              addIncAutomata(core)
              Some(for (a <- core.toList) yield TermConstraint(t, a))
            }
            case None => {
              constraints += aut
              constraintSet += aut
              None
            }
          }
        }
      }

    def getContents : List[Automaton] =
      constraints.toList
  }

}
