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

import strsolver.Flags

import ap.SimpleAPI
import SimpleAPI.ProverStatus
import ap.terfor.Term
import ap.terfor.substitutions.VariableSubst
import ap.util.Seqs

import scala.collection.mutable.{HashMap => MHashMap, ArrayBuffer, ArrayStack,
                                 HashSet => MHashSet, LinkedHashSet}

object Exploration {
  case class TermConstraint(t : Term, aut : Automaton)

  type ConflictSet = Seq[TermConstraint]

  abstract class ConstraintStore {
    def push : Unit

    def pop : Unit

    /**
     * Add new automata to the store, return a sequence of term constraints
     * in case the asserted constraints have become inconsistent
     */
    def assertConstraint(aut : Automaton) : Option[ConflictSet]

    /**
     * Return some representation of the asserted constraints
     */
    def getContents : List[Automaton]

    /**
     * Return all constraints that were asserted (without any modifications)
     */
    def getCompleteContents : List[Automaton]

    def getAcceptedWord : Seq[Int]
  }

  def eagerExp(funApps : Seq[(PreOp, Seq[Term], Term)],
               initialConstraints : Seq[(Term, Automaton)],
               lengthProver : Option[SimpleAPI],
               lengthVars : Map[Term, Term]) : Exploration =
    new EagerExploration(funApps, initialConstraints, lengthProver, lengthVars)

  def lazyExp(funApps : Seq[(PreOp, Seq[Term], Term)],
              initialConstraints : Seq[(Term, Automaton)],
              lengthProver : Option[SimpleAPI],
              lengthVars : Map[Term, Term]) : Exploration =
    new LazyExploration(funApps, initialConstraints, lengthProver, lengthVars)

  private case class FoundModel(model : Map[Term, Seq[Int]]) extends Exception

  def measure[A](op : String)(comp : => A) : A =
    if (Flags.measureTimes)
      ap.util.Timer.measure(op)(comp)
    else
      comp
}

/**
 * A naive recursive implementation of depth-first exploration of a conjunction
 * of function applications
 */
abstract class Exploration(val funApps : Seq[(PreOp, Seq[Term], Term)],
                           val initialConstraints : Seq[(Term, Automaton)],
                           lengthProver : Option[SimpleAPI],
                           lengthVars : Map[Term, Term]) {

  import Exploration._

  println
  println("Running preprop solver")

  // topological sorting of the function applications
  private val (allTerms, sortedFunApps)
              : (Set[Term], Seq[(Seq[(PreOp, Seq[Term])], Term)]) = {
    val argTermNum = new MHashMap[Term, Int]
    for ((_, _, res) <- funApps)
      argTermNum.put(res, 0)
    for ((t, _) <- initialConstraints)
      argTermNum.put(t, 0)
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

  for ((ops, t) <- sortedFunApps)
    if (ops.size > 1)
      throw new Exception("Multiple definitions found for " + t)

  val leafTerms = allTerms -- (for ((_, t) <- sortedFunApps) yield t)

  println("   Considered function applications:")
  for ((apps, res) <- sortedFunApps) {
    println("   " + res + " =")
    for ((op, args) <- apps)
      println("     " + op + "(" + (args mkString ", ") + ")")
  }

  for (p <- lengthProver)
    for ((apps, res) <- sortedFunApps; (op, args) <- apps)
      p addAssertion op.lengthApproximation(args map lengthVars,
                                            lengthVars(res), p.order)

  //////////////////////////////////////////////////////////////////////////////

  private val constraintStores = new MHashMap[Term, ConstraintStore]

  def findModel : Option[Map[Term, Seq[Int]]] = {
    for (t <- allTerms)
      constraintStores.put(t, newStore(t))

    for ((t, aut) <- initialConstraints) {
      println("Asserting constraint on " + t)
      println(aut)
      constraintStores(t).assertConstraint(aut) match {
        case Some(_) => return None
        case None    => // nothing
      }
    }

    for (p <- lengthProver) {
      for ((t, aut) <- initialConstraints)
        p addAssertion VariableSubst(0, List(lengthVars(t)), p.order)(
                                               aut.getLengthAbstraction)

      if (measure("check length consistency") { p.??? } == ProverStatus.Unsat)
        return None
    }

    addForwardConstraints

    val funAppList =
      (for ((apps, res) <- sortedFunApps;
            (op, args) <- apps)
       yield (op, args, res)).toList

    try {
      dfExplore(funAppList)
      None
    } catch {
      case FoundModel(model) => Some(model)
    }
  }

  /**
   * Propagates approximate constraints forwards from the root, adds new
   * constraints to constraintStores
   */
  private def addForwardConstraints : Unit = {
    println("Adding forwards")
    for ((apps, res) <- sortedFunApps.reverseIterator;
         (op, args) <- apps) {
      val arguments = for (a <- args) yield constraintStores(a).getCompleteContents
      val resultConstraint = op.forwardApprox(arguments)
      constraintStores(res).assertConstraint(resultConstraint)
    }
    println("Done")
  }

  private def dfExplore(apps : List[(PreOp, Seq[Term], Term)])
                      : ConflictSet = apps match {

    case List() => {
      // we are finished and just have to construct a model
      val model = new MHashMap[Term, Seq[Int]]
      for (t <- leafTerms)
        model.put(t, constraintStores(t).getAcceptedWord)
      for ((ops, res) <- sortedFunApps.reverseIterator;
           (op, args) <- ops.iterator) {
        val resValue = op.eval(args map model)
        for (oldValue <- model get res)
          if (resValue != oldValue)
            throw new Exception("Model extraction failed: " +
                                (oldValue mkString ", ") + " != " +
                                (resValue mkString ", "))
        model.put(res, resValue)
      }
      throw FoundModel(model.toMap)
    }
    case (op, args, res) :: otherApps =>
      dfExploreOp(op, args, res, constraintStores(res).getContents,
                  otherApps)
  }

  private def dfExploreOp(op : PreOp,
                          args : Seq[Term],
                          res : Term,
                          resConstraints : List[Automaton],
                          nextApps : List[(PreOp, Seq[Term], Term)])
                        : ConflictSet = resConstraints match {
    case List() =>
      dfExplore(nextApps)

    case resAut :: otherAuts => {
      ap.util.Timeout.check

      val argConstraints =
        for (a <- args) yield constraintStores(a).getCompleteContents

      val collectedConflicts = new LinkedHashSet[TermConstraint]

      val (newConstraintsIt, argDependencies) =
        measure("pre-op") { op(argConstraints, resAut) }
      while (measure("pre-op hasNext") {newConstraintsIt.hasNext}) {
        val argCS = measure("pre-op next") {newConstraintsIt.next}

        for (a <- args)
          constraintStores(a).push

        pushLengthConstraints

        try {
          val newConstraints = new MHashSet[TermConstraint]

          var consistent = true
          for ((a, aut) <- args zip argCS)
            if (consistent) {
              newConstraints += TermConstraint(a, aut)

              constraintStores(a).assertConstraint(aut) match {
                case Some(conflict) => {
                  consistent = false

                  assert(!Seqs.disjointSeq(newConstraints, conflict))
                  collectedConflicts ++=
                    (conflict.iterator filterNot newConstraints)
                }
                case None => // nothing
              }
            }

          if (consistent)
            for (core <- addLengthConstraints(newConstraints.toSeq)) {
//println("length conflict: " + core.size)
              collectedConflicts ++= (core.iterator filterNot newConstraints)
              consistent = false
            }

          if (consistent) {
            val conflict = dfExploreOp(op, args, res, otherAuts, nextApps)
            if (Seqs.disjointSeq(newConstraints, conflict)) {
              // we can jump back, because the found conflict does not depend
              // on the considered function application
//println("backjump " + (conflict map { case TermConstraint(t, aut) => (t, aut.hashCode) }))
              return conflict
            }
            collectedConflicts ++= (conflict.iterator filterNot newConstraints)
          }
        } finally {
          for (a <- args)
            constraintStores(a).pop
          popLengthConstraints
        }
      }

      if (needCompleteContentsForConflicts)
        collectedConflicts ++=
          (for (aut <- constraintStores(res).getCompleteContents)
           yield TermConstraint(res, aut))
      else
        collectedConflicts += TermConstraint(res, resAut)

      collectedConflicts ++=
        (for ((t, auts) <- args.iterator zip argDependencies.iterator;
              aut <- auts.iterator)
         yield TermConstraint(t, aut))

      collectedConflicts.toSeq
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  private val lengthPartitionStack = new ArrayStack[Int]
  private val lengthPartitions = new ArrayBuffer[TermConstraint]

  private def addLengthConstraints(constraints : Seq[TermConstraint])
                                 : Option[Seq[TermConstraint]] =
    for (p <- lengthProver;
         if {
           for (c@TermConstraint(t, aut) <- constraints) {
             lengthPartitions += c
             p setPartitionNumber lengthPartitions.size
             p addAssertion VariableSubst(0, List(lengthVars(t)), p.order)(
                                                    aut.getLengthAbstraction)
           }

           measure("check length consistency") {p.???} == ProverStatus.Unsat
         }) yield {
      for (n <- p.getUnsatCore.toList.sorted; if n > 0)
      yield lengthPartitions(n - 1)
    }

  private def pushLengthConstraints : Unit =
    for (p <- lengthProver) {
      p.push
      lengthPartitionStack push lengthPartitions.size
    }

  private def popLengthConstraints : Unit =
    for (p <- lengthProver) {
      p.pop
      lengthPartitions reduceToSize lengthPartitionStack.pop
    }

  //////////////////////////////////////////////////////////////////////////////

  protected def newStore(t : Term) : ConstraintStore

  protected val needCompleteContentsForConflicts : Boolean

}

////////////////////////////////////////////////////////////////////////////////

/**
 * Version of exploration that eagerly computes products of regex constraints.
 */
class EagerExploration(_funApps : Seq[(PreOp, Seq[Term], Term)],
                       _initialConstraints : Seq[(Term, Automaton)],
                       _lengthProver : Option[SimpleAPI],
                       _lengthVars : Map[Term, Term])
      extends Exploration(_funApps, _initialConstraints,
                          _lengthProver, _lengthVars) {

  import Exploration._

  protected val needCompleteContentsForConflicts : Boolean = true

  protected def newStore(t : Term) : ConstraintStore = new ConstraintStore {
    private val constraints = new ArrayBuffer[Automaton]
    private var currentConstraint : Option[Automaton] = None
    private val constraintStack = new ArrayStack[(Int, Option[Automaton])]

    def push : Unit =
      constraintStack push (constraints.size, currentConstraint)

    def pop : Unit = {
      val (oldSize, lastCC) = constraintStack.pop
      constraints reduceToSize oldSize
      currentConstraint = lastCC
    }

    def assertConstraint(aut : Automaton) : Option[ConflictSet] =
      if (aut.isEmpty) {
        Some(List(TermConstraint(t, aut)))
      } else {
        currentConstraint match {
          case Some(oldAut) => {
            val newAut = oldAut & aut
            if (newAut.isEmpty) {
              Some(for (a <- aut :: constraints.toList)
                   yield TermConstraint(t, a))
            } else {
              constraints += aut
              currentConstraint = Some(newAut)
              None
            }
          }
          case None => {
            constraints += aut
            currentConstraint = Some(aut)
            None
          }
        }
      }

    def getContents : List[Automaton] =
      currentConstraint.toList
    def getCompleteContents : List[Automaton] =
      constraints.toList

    def getAcceptedWord : Seq[Int] =
      currentConstraint match {
        case Some(aut) => aut.getAcceptedWord.get
        case None      => List()
      }
  }

}

////////////////////////////////////////////////////////////////////////////////

/**
 * Version of exploration that keeps automata separate and avoids computation
 * of products. No caching yet
 */
class LazyExploration(_funApps : Seq[(PreOp, Seq[Term], Term)],
                      _initialConstraints : Seq[(Term, Automaton)],
                      _lengthProver : Option[SimpleAPI],
                      _lengthVars : Map[Term, Term])
      extends Exploration(_funApps, _initialConstraints,
                          _lengthProver, _lengthVars) {

  import Exploration._

  protected val needCompleteContentsForConflicts : Boolean = false

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

    def assertConstraint(aut : Automaton) : Option[ConflictSet] =
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

        measure("AutomataUtils.findUnsatCore") { AutomataUtils.findUnsatCore(constraints, aut) } match {
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

    def getContents : List[Automaton] =
      constraints.toList
    def getCompleteContents : List[Automaton] =
      constraints.toList

    def getAcceptedWord : Seq[Int] =
      constraints match {
        case Seq() => List()
        case auts  => (auts reduceLeft (_ & _)).getAcceptedWord.get
      }
  }

}
