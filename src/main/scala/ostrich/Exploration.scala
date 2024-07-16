/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2023 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ostrich.automata.{Automaton, BricsAutomaton, AutomataUtils}
import ostrich.preop.PreOp

import ap.SimpleAPI
import SimpleAPI.ProverStatus
import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.parser.SMTLineariser
import ap.proof.theoryPlugins.Plugin
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.substitutions.VariableSubst
import ap.terfor._
import ap.util.{Seqs, Timeout}

import scala.collection.breakOut
import scala.collection.mutable.{ArrayBuffer, ArrayStack, LinkedHashSet, BitSet => MBitSet, HashMap => MHashMap, HashSet => MHashSet}

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
     * Check whether input automaton is superset of current constraints
     * Not implemented for eager
     * @param aut
     * @return true if constraints.getComplete \subseteq aut
     */
    def isSuperSet(aut : Automaton) : Boolean

    /**
     * Return some representation of the asserted constraints
     */
    def getContents : List[Automaton]

    /**
     * Return all constraints that were asserted (without any modifications)
     */
    def getCompleteContents : List[Automaton]

    /**
     * Make sure that the exact length abstraction for the intersection of the
     * stored automata has been pushed to the length prover
     */
    def ensureCompleteLengthConstraints : Unit

    /**
     * Check whether some word is accepted by all the stored constraints
     */
    def isAcceptedWord(w : Seq[Int]) : Boolean

    /**
     * Produce an arbitrary word accepted by all the stored constraints
     */
    def getAcceptedWord : Seq[Int]

    /**
     * Produce a word of length <code>len</code> accepted by all the stored
     * constraints
     */
    def getAcceptedWordLen(len : Int) : Seq[Int]
  }

  def eagerExp(funApps : Seq[(PreOp, Seq[Term], Term)],
               initialConstraints : Seq[(Term, Automaton)],
               strDatabase : StrDatabase,
               lengthProver : Option[SimpleAPI],
               lengthVars : Map[Term, Term],
               strictLengths : Boolean,
               flags : OFlags) : Exploration =
    new EagerExploration(funApps, initialConstraints, strDatabase,
      lengthProver, lengthVars, strictLengths, flags)

  def lazyExp(funApps : Seq[(PreOp, Seq[Term], Term)],
              initialConstraints : Seq[(Term, Automaton)],
              strDatabase : StrDatabase,
              lengthProver : Option[SimpleAPI],
              lengthVars : Map[Term, Term],
              strictLengths : Boolean,
              flags : OFlags) : Exploration =
    new LazyExploration(funApps, initialConstraints, strDatabase,
      lengthProver, lengthVars, strictLengths, flags)

  private case class FoundModel(model : Map[Term, Either[IdealInt, Seq[Int]]])
    extends Exception

}

////////////////////////////////////////////////////////////////////////////////

/**
 * Depth-first exploration of a conjunction of function applications
 */
abstract class Exploration(val funApps : Seq[(PreOp, Seq[Term], Term)],
                           val initialConstraints : Seq[(Term, Automaton)],
                           strDatabase : StrDatabase,
                           lengthProver : Option[SimpleAPI],
                           lengthVars : Map[Term, Term],
                           strictLengths : Boolean,
                           flags : OFlags) {

  import Exploration._
  import OFlags.debug

  def measure[A](op : String)(comp : => A) : A =
    if (flags.measureTimes)
      ap.util.Timer.measure(op)(comp)
    else
      comp

  Console.err.println
  Console.err.println("Running backward propagation")

  private var straightLine = true
  // topological sorting of the function applications
  private val (allTerms, sortedFunApps, ignoredApps)
  : (Set[Term],
    Seq[(Seq[(PreOp, Seq[Term])], Term)],
    Seq[(PreOp, Seq[Term], Term)]) = {
    val argTermNum = new MHashMap[Term, Int]
    for ((_, _, res) <- funApps)
      argTermNum.put(res, 0)
    for ((t, _) <- initialConstraints)
      argTermNum.put(t, 0)
    for ((t, _) <- lengthVars)
      argTermNum.put(t, 0)
    for ((_, args, _) <- funApps; a <- args)
      argTermNum.put(a, argTermNum.getOrElse(a, 0) + 1)

    var ignoredApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    var remFunApps  = funApps
    val sortedApps  = new ArrayBuffer[(Seq[(PreOp, Seq[Term])], Term)]

    while (!remFunApps.isEmpty) {
      val (selectedApps, otherApps) =
        remFunApps partition { case (_, _, res) =>
          argTermNum(res) == 0 ||
            strDatabase.isConcrete(res) }

      if (selectedApps.isEmpty) {

        if (ignoredApps.isEmpty)
          Console.err.println(
            "Warning: cyclic definitions found, ignoring some function " +
              "applications")
        ignoredApps += remFunApps.head
        remFunApps = remFunApps.tail

      } else {

        remFunApps = otherApps

        for ((_, args, _) <- selectedApps; a <- args)
          argTermNum.put(a, argTermNum.getOrElse(a, 0) - 1)

        val appsPerRes = selectedApps groupBy (_._3)
        val nonArgTerms = (selectedApps map (_._3)).distinct

        for (t <- nonArgTerms)
          sortedApps +=
            ((for ((op, args, _) <- appsPerRes(t)) yield (op, args), t))

      }
    }

    (argTermNum.keySet.toSet, sortedApps.toSeq, ignoredApps.toSeq)
  }

  if (!sortedFunApps.isEmpty)
    Console.withOut(Console.err) {
      println("   Considered function applications:")

      def term2String(t : Term) =
        (strDatabase term2Str t) match {
          case Some(str) => "\"" + (SMTLineariser escapeString str) + "\""
          case None => t.toString
        }

      for ((apps, res) <- sortedFunApps) {
        println("   " + term2String(res) + " =")
        for ((op, args) <- apps)
          println("     " + op +
            "(" + (args map (term2String _) mkString ", ") + ")")
      }

      /*
            println
            println("Regular expression constraints:")
            for ((t, aut) <- initialConstraints) {
              println("===== " + term2String(t) + " in:")
              println("     " + aut)
            }
      */
    }

  val nonTreeLikeApps =
    sortedFunApps exists {
      case (ops, t) => ops.size > 1 && !(strDatabase isConcrete t)
    }

  if (nonTreeLikeApps) {
    straightLine = false
    Console.err.println(
      "Warning: input is not straightline, some variables have multiple " +
        "definitions")
  }

  val resultTerms =
    (for ((_, t) <- sortedFunApps.iterator) yield t).toSet
  val leafTerms =
    allTerms filter {
      case t => (strDatabase isConcrete t) || !(resultTerms contains t)
    }

  //////////////////////////////////////////////////////////////////////////////

  // check whether we have to add further regex constraints to ensure
  // completeness; otherwise not all pre-images of function applications might
  // be considered

  val allInitialConstraints = {
    val term2Index =
      (for (((_, t), n) <- sortedFunApps.iterator.zipWithIndex)
        yield (t -> n)).toMap

    val coveredTerms = new MBitSet
    for ((t, _) <- initialConstraints)
      for (ind <- term2Index get t)
        coveredTerms += ind

    val additionalConstraints = new ArrayBuffer[(Term, Automaton)]

    // check whether any of the terms have concrete definitions
    for (t <- allTerms)
      for (w <- strDatabase.term2List(t)) {
        val str : String = w.map(i => i.toChar)(breakOut)
        additionalConstraints += ((t, BricsAutomaton fromString str))
        for (ind <- term2Index get t)
          coveredTerms += ind
      }

    for (n <- 0 until sortedFunApps.size;
         if {
           if (!(coveredTerms contains n)) {
             coveredTerms += n
             additionalConstraints +=
               ((sortedFunApps(n)._2, BricsAutomaton.makeAnyString()))
           }
           true
         };
         (_, args) <- sortedFunApps(n)._1;
         arg <- args)
      for (ind <- term2Index get arg)
        coveredTerms += ind

    initialConstraints ++ additionalConstraints
  }

  //////////////////////////////////////////////////////////////////////////////

  // set up the length prover with available information about the function
  // applications

  for (p <- lengthProver)
    for ((apps, res) <- sortedFunApps; (op, args) <- apps)
      p addAssertion op.lengthApproximation(args map lengthVars,
        lengthVars(res), p.order)

  //////////////////////////////////////////////////////////////////////////////

  private val constraintStores = new MHashMap[Term, ConstraintStore]

  /**
   * Check for existence of a model. A model maps each integer variable
   * to an integer, and each string variable to a list of characters.
   */
  def findModel : Option[Map[Term, Either[IdealInt, Seq[Int]]]] = {
    for (t <- allTerms)
      constraintStores.put(t, newStore(t))

    for ((t, aut) <- allInitialConstraints) {
      constraintStores(t).assertConstraint(aut) match {
        case Some(_) => return None
        case None    => // nothing
      }
    }

    for (p <- lengthProver) {
      for ((t, aut) <- allInitialConstraints)
        p addAssertion VariableSubst(0, List(lengthVars(t)), p.order)(
          aut.getLengthAbstraction)

      if (measure("check length consistency") { p.??? } == ProverStatus.Unsat)
        return None
    }
    if (flags.forwardPropagation){
      val result = addForwardConstraints
      if (result.isDefined){
        return None
      }
    }
    if (!flags.backwardPropagation){
      dfExplore(List(), List())
    }



    val funAppList =
      (for ((apps, res) <- sortedFunApps;
            (op, args) <- apps)
      yield (op, args, res)).toList

    try {
      dfExplore(funAppList, List())
      None
    } catch {
      case FoundModel(model) => Some(model)
    }
  }

  /**
   * Propagates approximate constraints forwards from the root, adds new
   * constraints to constraintStores
   */
  private def addForwardConstraints : Option[ConflictSet] = {
    for ((apps, res) <- sortedFunApps.reverseIterator;
         (op, args) <- apps) {
      val arguments = for (a <- args) yield constraintStores(a).getCompleteContents
      val resultConstraint = op.forwardApprox(arguments)
      if (constraintStores(res).isSuperSet(resultConstraint)){
        //println("Forward is saturated") TODO do something with that info?
      }
      else {
        val r = constraintStores(res).assertConstraint(resultConstraint)
        // Forward has found conlict
        if (r.isDefined) return r
      }
    }
    None
  }

  private def evalTerm(t : Term)(model : PartialModel)
  : Option[IdealInt] = t match {
    case c : ConstantTerm =>
      model eval c
    case OneTerm =>
      Some(IdealInt.ONE)
    case lc : LinearCombination => {
      val terms = for ((coeff, t) <- lc) yield (coeff, evalTerm(t)(model))
      if (terms forall { case (_, None) => false
      case _ => true })
        Some((for ((coeff, Some(v)) <- terms) yield (coeff * v)).sum)
      else
        None
    }
  }


  private def dfExplore(apps : List[(PreOp, Seq[Term], Term)], fwdApps : List[(PreOp, Seq[Term], Term)])
  : ConflictSet = apps match {

    case List() => {
      if (debug)
        Console.err.println("Trying to contruct model")

      // we are finished and just have to construct a model
      val model = new MHashMap[Term, Either[IdealInt, Seq[Int]]]

      val lengthModel =
        if (strictLengths) {
          for (t <- allTerms)
            constraintStores(t).ensureCompleteLengthConstraints
          for (core <- checkLengthConsistency)
            return core
          Some(lengthProver.get.partialModel)
        } else {
          None
        }

      def getVarLength(t : Term) : Option[IdealInt] =
        for (lModel <- lengthModel;
             lengthVar <- lengthVars get t;
             tlen <- evalTerm(lengthVar)(lModel))
        yield tlen

      // values for string variables
      for (t <- leafTerms) {
        val store = constraintStores(t)
        model.put(t,
          Right((for (tlen <- getVarLength(t))
            yield store.getAcceptedWordLen(tlen.intValueSafe))
            .getOrElse(store.getAcceptedWord)))
      }

      // values for integer variables
      for (lModel <- lengthModel;
           (_, c) <- lengthVars;
           if c.constants.size == 1;
           cVal <- evalTerm(c)(lModel))
        model.put(c, Left(cVal))

      val allFunApps : Iterator[(PreOp, Seq[Term], Term)] =
        (for ((ops, res) <- sortedFunApps.reverseIterator;
              (op, args) <- ops.iterator)
        yield (op, args, res)) ++
          ignoredApps.iterator  // TODO: reverseIterator?

      for ((op, args, res) <- allFunApps;
           argValues = args map model) {
        if (argValues exists (_.isLeft))
          throw new Exception(
            "Model extraction failed: " + op +
              " is only defined for string arguments")

        val argStrings : Seq[Seq[Int]] = argValues map (_.right.get)

        val resString =
          op.eval(argStrings) match {
            case Some(v) => v
            case None =>
              throw new Exception(
                "Model extraction failed: " + op + " is not defined for " +
                  argStrings.mkString(", "))
          }

        if (debug)
          Console.err.println("Derived model value: " + res + " <- " + resString)

        val resValue : Either[IdealInt, Seq[Int]] = Right(resString)

        def throwResultCutException : Unit = {
          import TerForConvenience._
          implicit val o = res.asInstanceOf[SortedWithOrder[Term]].order

          val resEq =
            res === strDatabase.list2Id(resString)

          Console.err.println("   ... adding cut over result for " + res)

          throw new OstrichSolver.BlockingActions(List(
            Plugin.CutSplit(resEq, List(), List())))
        }

        for (oldValue <- model get res)
          if (resValue != oldValue) {
            if (!nonTreeLikeApps)
              throw new Exception("Model extraction failed: " +
                oldValue + " != " + resValue)
            throwResultCutException
          }

        if (!(constraintStores(res) isAcceptedWord resString)) {
          throw new Exception(
            "Could not satisfy regex constraints for " + res +
              ", maybe the problems involves non-functional transducers?")
        }

        for (resLen <- getVarLength(res))
          if (resValue.right.get.size != resLen.intValueSafe) {
            /*
                       throw new Exception(
                         "Could not satisfy length constraints for " + res +
                           " with solution " +
                           resValue.right.get.map(i => i.toChar)(breakOut) +
                           "; length is " + resValue.right.get.size +
                           " but should be " + resLen)
             */
            throwResultCutException
          }

        model.put(res, resValue)
      }
      throw FoundModel(model.toMap)
    }
    case (op, args, res) :: otherApps => {
      if (debug)
        Console.err.println("dfExplore, depth " + apps.size)
      dfExploreOp(op, args, res, constraintStores(res).getContents,
        otherApps, fwdApps)
    }
  }
  private def addForwardConstraints(nextApps : List[(PreOp, Seq[Term], Term)], argInput : Seq[Term]) : Option[ConflictSet] = {
    for ((apps, res) <- sortedFunApps.reverseIterator;
         (op, args) <- apps) if (argInput.intersect(args).isEmpty)
    {
      val arguments = for (a <- args) yield constraintStores(a).getCompleteContents
      val resultConstraint = op.forwardApprox(arguments)
      if (constraintStores(res).isSuperSet(resultConstraint)){
      }
      else {
        val r = constraintStores(res).assertConstraint(resultConstraint)
        if (r.isDefined) return r
      }
    }
    None
  }

  private def dfExploreOp(op : PreOp,
                          args : Seq[Term],
                          res : Term,
                          resConstraints : List[Automaton],
                          nextApps : List[(PreOp, Seq[Term], Term)],
                          fwdApps : List[(PreOp, Seq[Term], Term)])
  : ConflictSet = resConstraints match {
    case List() => {
      dfExplore(nextApps, fwdApps)
    }

    case resAut :: otherAuts => {
      if (debug)
        Console.err.println("dfExploreOp, #constraints " + resConstraints.size)

      ap.util.Timeout.check

      val argConstraints =
        for (a <- args) yield constraintStores(a).getCompleteContents

      val collectedConflicts = new LinkedHashSet[TermConstraint]
      if (flags.forwardPropagation){
        addForwardConstraints(nextApps, args)
      }
      val (newConstraintsIt, argDependencies) =
        measure("pre-op") { op(argConstraints, resAut) }
      while (measure("pre-op hasNext") {newConstraintsIt.hasNext}) {
        ap.util.Timeout.check

        val argCS = measure("pre-op next") {newConstraintsIt.next}
        if (flags.forwardPropagation){
          for (a <- allTerms)
            constraintStores(a).push
        }
        else {
          for (a <- args)
            constraintStores(a).push
        }

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
            for (core <- checkLengthConsistency) {
              collectedConflicts ++= (core.iterator filterNot newConstraints)
              consistent = false
            }

          if (consistent) {
            val conflict = dfExploreOp(op, args, res, otherAuts, nextApps, fwdApps)
            if (Seqs.disjointSeq(newConstraints, conflict)) {
              // we can jump back, because the found conflict does not depend
              // on the considered function application
              //println("backjump " + (conflict map { case TermConstraint(t, aut) => (t, aut.hashCode) }))
              return conflict
            }
            collectedConflicts ++= (conflict.iterator filterNot newConstraints)
          }
        } finally {
          if (flags.forwardPropagation){
            for (a <- allTerms)
              constraintStores(a).pop
          }
          else {
            for (a <- args)
              constraintStores(a).pop
          }
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
  private val lengthPartitions = new ArrayBuffer[Seq[TermConstraint]]

  protected def addLengthConstraint(constraint : TermConstraint,
                                    sources : Seq[TermConstraint]) : Unit =
    for (p <- lengthProver) {
      lengthPartitions += sources
      p setPartitionNumber lengthPartitions.size
      val TermConstraint(t, aut) = constraint
      p addAssertion VariableSubst(0, List(lengthVars(t)), p.order)(
        aut.getLengthAbstraction)
    }

  private def checkLengthConsistency : Option[Seq[TermConstraint]] =
    for (p <- lengthProver;
         if {
           if (debug)
             Console.err.println("checking length consistency")
           Timeout.unfinished {
             p.checkSat(false)
             measure("check length consistency") {
               while (p.getStatus(100) == ProverStatus.Running)
                 Timeout.check
               p.??? == ProverStatus.Unsat
             }
           } {
             case x : Any => {
               p.stop
               x
             }
           }
         }) yield {
      for (n <- p.getUnsatCore.toList.sorted;
           if n > 0;
           c <- lengthPartitions(n - 1))
      yield c
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
                       _strDatabase : StrDatabase,
                       _lengthProver : Option[SimpleAPI],
                       _lengthVars : Map[Term, Term],
                       _strictLengths : Boolean,
                       _flags : OFlags)
  extends Exploration(_funApps, _initialConstraints, _strDatabase,
    _lengthProver, _lengthVars, _strictLengths, _flags) {

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

    override def isSuperSet(aut: Automaton): Boolean = {
      false
    }

    def assertConstraint(aut : Automaton) : Option[ConflictSet] =
      if (aut.isEmpty) {
        Some(List(TermConstraint(t, aut)))
      } else {
        currentConstraint match {
          case Some(oldAut) => {
            val newAut = measure("intersection") { oldAut & aut }
            if (newAut.isEmpty) {
              Some(for (a <- aut :: constraints.toList)
                yield TermConstraint(t, a))
            } else {
              constraints += aut
              currentConstraint = Some(newAut)
              addLengthConstraint(TermConstraint(t, newAut),
                for (a <- constraints)
                  yield TermConstraint(t, a))
              None
            }
          }
          case None => {
            constraints += aut
            currentConstraint = Some(aut)
            val c = TermConstraint(t, aut)
            addLengthConstraint(c, List(c))
            None
          }
        }
      }

    def getContents : List[Automaton] =
      currentConstraint.toList
    def getCompleteContents : List[Automaton] =
      constraints.toList

    def ensureCompleteLengthConstraints : Unit = ()

    def isAcceptedWord(w : Seq[Int]) : Boolean =
      currentConstraint match {
        case Some(aut) => aut(w)
        case None      => true
      }

    def getAcceptedWord : Seq[Int] =
      currentConstraint match {
        case Some(aut) => aut.getAcceptedWord.get
        case None      => List()
      }

    def getAcceptedWordLen(len : Int) : Seq[Int] =
      currentConstraint match {
        case Some(aut) => AutomataUtils.findAcceptedWord(List(aut), len).get
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
                      _strDatabase : StrDatabase,
                      _lengthProver : Option[SimpleAPI],
                      _lengthVars : Map[Term, Term],
                      _strictLengths : Boolean,
                      _flags : OFlags)
  extends Exploration(_funApps, _initialConstraints, _strDatabase,
    _lengthProver, _lengthVars, _strictLengths, _flags) {

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


    def isSuperSet(aut: Automaton) : Boolean = {
      if (constraintSet contains aut) {
        true
      }
      else{
        val product = AutomataUtils.product(constraintSet.toSeq)
        val superSetAut = !aut & product
        val res = superSetAut.isEmpty
        res
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
            val c = TermConstraint(t, aut)
            addLengthConstraint(c, List(c))
            None
          }
        }
      }

    def getContents : List[Automaton] =
      constraints.toList
    def getCompleteContents : List[Automaton] =
      constraints.toList

    private def intersection : Automaton =
      AutomataUtils.product(constraints, _flags.minimizeAutomata)

    def ensureCompleteLengthConstraints : Unit =
      constraints match {
        case Seq() | Seq(_) =>
        // nothing, all length constraints already pushed
        case auts =>
          addLengthConstraint(TermConstraint(t, intersection),
            for (a <- constraints)
              yield TermConstraint(t, a))
      }

    def isAcceptedWord(w : Seq[Int]) : Boolean =
      constraints forall (_(w))

    def getAcceptedWord : Seq[Int] =
      constraints match {
        case Seq() => List()
        case auts  => intersection.getAcceptedWord.get
      }

    def getAcceptedWordLen(len : Int) : Seq[Int] =
      constraints match {
        case Seq() => for (_ <- 0 until len) yield 0
        case auts  => AutomataUtils.findAcceptedWord(auts, len).get
      }
  }

}
