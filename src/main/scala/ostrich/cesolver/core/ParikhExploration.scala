/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2023 Denghang Hu, Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.cesolver.core

import ostrich.preop.PreOp
import ostrich.automata.Automaton
import ostrich.StrDatabase
import ap.SimpleAPI
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet,
  BitSet => MBitSet
}
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.cesolver.convenience.CostEnrichedConvenience._
import ostrich.cesolver.preop.LengthCEPreOp
import ap.basetypes.IdealInt
import SimpleAPI.ProverStatus
import scala.collection.mutable.LinkedHashSet
import ap.util.Seqs
import ostrich.cesolver.preop.SubStringCEPreOp
import ostrich.cesolver.core.Model.{IntValue, StringValue}
import ostrich.cesolver.preop.IndexOfCEPreOp
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.util.TimeoutException
import ostrich.OFlags
import OFlags.CEABackend.{Baseline, Unary, Catra}
import ap.terfor.linearcombination.LinearCombination
import ap.parser.{ITerm, IFormula}
import ap.parser.InputAbsy2Internal
import ap.terfor.Term
import ap.terfor.TermOrder
import ostrich.cesolver.util.{TermGenerator, ParikhUtil}
import ap.parser.IIntLit
import ap.terfor.SortedWithOrder
import ostrich.OstrichSolver
import ap.proof.theoryPlugins.Plugin
import ap.parser.Internal2InputAbsy

object ParikhExploration {

  case class TermConstraint(t: ITerm, aut: Automaton)

  type ConflictSet = Seq[TermConstraint]

  case class FoundModel(model: Map[Term, Either[IdealInt, Seq[Int]]])
      extends Exception

  private def isStringResult(op: PreOp): Boolean = op match {
    case _: LengthCEPreOp  => false
    case _: IndexOfCEPreOp => false
    case _                 => true
  }
}

class ParikhExploration(
    funApps: Seq[(PreOp, Seq[ITerm], ITerm)],
    initialConstraints: Seq[(ITerm, Automaton)],
    initialLengthConstraints : IFormula,
    strDatabase: StrDatabase,
    flags: OFlags,
    lProver: SimpleAPI
) {

  import ParikhExploration._

  private val termGen = TermGenerator()

  def measure[A](op: String)(comp: => A): A =
    ParikhUtil.measure(op)(comp)(flags.debug)

  // topological sorting of the function applications
  // divide integer term and string term
  private val freshIntTerm2orgin = new MHashMap[ITerm, ITerm]
  private val (integerTerms, strTerms, sortedFunApps, ignoredApps) = {
    val strTerms = MHashSet[ITerm]()
    for ((t, _) <- initialConstraints)
      strTerms += t
    val newFunApps = funApps.map {
      case (op: LengthCEPreOp, Seq(str), length) => {
        val frashInt = termGen.intTerm
        freshIntTerm2orgin += (frashInt -> length)
        strTerms += str
        (op, Seq(str), frashInt)
      }
      case (op: SubStringCEPreOp, Seq(str, start, length), subStr) => {
        val frashInt1 = termGen.intTerm
        val frashInt2 = termGen.intTerm
        freshIntTerm2orgin += (frashInt1 -> start)
        freshIntTerm2orgin += (frashInt2 -> length)
        strTerms += str
        strTerms += subStr
        (op, Seq(str, frashInt1, frashInt2), subStr)
      }
      case (op: IndexOfCEPreOp, Seq(str, subStr, start), index) => {
        val frashInt1 = termGen.intTerm
        val frashInt2 = termGen.intTerm
        freshIntTerm2orgin += (frashInt1 -> start)
        freshIntTerm2orgin += (frashInt2 -> index)
        strTerms += str
        strTerms += subStr
        (op, Seq(str, subStr, frashInt1), frashInt2)
      }
      case (op, strs, resstr) => {
        strTerms ++= strs
        strTerms += resstr
        (op, strs, resstr)
      }
    }
    val integerTerms = freshIntTerm2orgin.keySet

    val sortedApps = new ArrayBuffer[(Seq[(PreOp, Seq[ITerm])], ITerm)]
    var ignoredApps = new ArrayBuffer[(PreOp, Seq[ITerm], ITerm)]
    var remFunApps = newFunApps
    var topSortedFunApps = newFunApps

    val termCout = new MHashMap[ITerm, Int]
    for ((op, args, res) <- newFunApps) {
      termCout(res) = termCout.getOrElse(res, 0)
      for (arg <- args) termCout(arg) = termCout.getOrElse(arg, 0) + 1
    }
    // all integer Terms are topologically sorted to the head
    for (t <- integerTerms)
      termCout(t) = 0

    while (topSortedFunApps.nonEmpty) {
      val (_topSortedFunApps, _remFunApps) = remFunApps partition {
        case (_, _, res) => termCout(res) == 0
      }
      sortedApps ++= {
        val grouped = _topSortedFunApps groupBy (_._3)
        grouped map { case (res, apps) =>
          (apps map (app => (app._1, app._2)), res)
        }
      }
      for ((op, args, res) <- _topSortedFunApps) {
        for (arg <- args) termCout(arg) = termCout(arg) - 1
      }
      topSortedFunApps = _topSortedFunApps
      remFunApps = _remFunApps
    }

    if (remFunApps.nonEmpty) {
      ignoredApps ++= remFunApps
      println("WARNING: cyclic definitions found, ignoring them")
    }

    (integerTerms, strTerms, sortedApps, ignoredApps)
  }

  for ((apps, res) <- sortedFunApps) {
    Console.withOut(Console.err) {

      def term2String(t: ITerm) =
        if (strTerms contains t) {
          val str = strDatabase term2Str InputAbsy2Internal(t, TermOrder.EMPTY)
          str match {
            case Some(str) => "\"" + str + "\""
            case None      => t.toString()
          }
        } else {
          freshIntTerm2orgin(t).toString()
        }

      println("   " + term2String(res) + " =")
      for ((op, args) <- apps)
        println(
          "     " + op +
            "(" + (args map (term2String _) mkString ", ") + ")"
        )
    }
  }

  val nonTreeLikeApps =
    sortedFunApps exists { case (ops, t) =>
      ops.size > 1 && !(strDatabase isConcrete InputAbsy2Internal(
        t,
        TermOrder.EMPTY
      ))
    }

  if (nonTreeLikeApps)
    Console.err.println(
      "Warning: input is not straightline, some variables have multiple " +
        "definitions"
    )

  private val allTerms = integerTerms ++ strTerms

  private val resultTerms =
    (for ((_, t) <- sortedFunApps.iterator) yield t).toSet

  val leafTerms =
    allTerms filter { case t => !(resultTerms contains t) }

  private def trivalConflict: ConflictSet = {
    for (
      t <- leafTerms.toSeq;
      aut <- constraintStores(t).getCompleteContents
    ) yield TermConstraint(t, aut)
  }

  private val constraintStores = new MHashMap[ITerm, ParikhStore]

  def findModel: Option[Map[Term, Either[IdealInt, Seq[Int]]]] = {
    for (t <- allTerms)
      constraintStores.put(t, newStore(t))

    for ((t, aut) <- allInitialConstraints) {
      constraintStores(t).assertConstraint(aut) match {
        case Some(confilctSet) =>
          // println(confilctSet)
          return None
        case None => // nothing
      }
    }

    val funAppList =
      (for (
        (apps, res) <- sortedFunApps;
        (op, args) <- apps
      )
        yield (op, args, res)).toList

    try {
      dfExplore(funAppList)
      None
    } catch {
      case FoundModel(model) => Some(model)
      case UnknownException(info) =>
        throw new Exception("--Unknown: " + info)
        None
      case TimeoutException(time) =>
        throw new Exception(s"--Timeout: $time s")
        None
    }
  }

  private def generateResultModel(
      apps: Iterator[(PreOp, Seq[ITerm], ITerm)],
      model: MHashMap[ITerm, Either[IdealInt, Seq[Int]]]
  ): MHashMap[ITerm, Either[IdealInt, Seq[Int]]] = {
    for (
      (op, formalArgs, res) <- apps;
      argValues = formalArgs map model
    ) {

      val args: Seq[Seq[Int]] = argValues map {
        case Left(value)   => Seq(value.intValueSafe)
        case Right(values) => values
      }

      val resValue =
        op.eval(args) match {
          case Some(v) => v
          case None =>
            throw new Exception(
              "Model extraction failed: " + op + " is not defined for " +
                args.mkString(", ")
            )
        }
      def throwResultCutException: Unit = {
        import ap.terfor.TerForConvenience._
        implicit val o = lProver.order
        ap.util.Timeout.check
        val resEq =
          res === strDatabase.list2Id(resValue)

        Console.err.println("   ... adding cut over result for " + res)

        throw new OstrichSolver.BlockingActions(
          List(
            Plugin.CutSplit(conj(InputAbsy2Internal(resEq, o)), List(), List())
          )
        )
      }
      // check the consistence of old result values and computed result values
      for (oldValue <- model get res) {
        var _oldValue: Seq[Int] = Seq()
        oldValue match {
          case Left(value)  => _oldValue = Seq(value.intValueSafe)
          case Right(value) => _oldValue = value
        }
        if (_oldValue != resValue)
          if (nonTreeLikeApps)
            throwResultCutException
          else
            throw new Exception(
              "Model extraction failed: " + res + " old value::" + _oldValue + " != res value::" + resValue
            )
      }

      if (isStringResult(op))
        model += (res -> Right(resValue))
    }
    model
  }

  def dfExplore(apps: List[(PreOp, Seq[ITerm], ITerm)]): ConflictSet =
    apps match {

      case List() => {

        // we are finished and just have to construct a model
        val model = new MHashMap[ITerm, Either[IdealInt, Seq[Int]]]

        // check linear arith consistency of final automata

        val backendSolver =
          flags.ceaBackend match {
            case Catra    => new CatraBasedSolver(initialLengthConstraints,
                                                  freshIntTerm2orgin.toMap)
            case Baseline => new BaselineSolver(lProver)
            case Unary =>
              new UnaryBasedSolver(flags, freshIntTerm2orgin.toMap, lProver)
          }

        backendSolver.setIntegerTerm(integerTerms.toSet)
        for (t <- leafTerms; if (strTerms contains t)) {
          backendSolver.addConstraint(t, constraintStores(t).getCompleteContents)
        }

        val res = backendSolver.measureTimeSolve

        ParikhUtil.debugPrintln("Result from CEA backend: " + res)

        res.getStatus match {
          case ProverStatus.Sat => {
            // model of leaf term
            for ((t, v) <- res.getModel) {
              v match {
                case IntValue(i)    => model.put(t, Left(i))
                case StringValue(s) => model.put(t, Right(s))
              }
            }
            for ((fresh, orign) <- freshIntTerm2orgin) {
              orign match {
                case IIntLit(_) => // do nothing
                case _ =>
                  model.put(orign, model(fresh))
              }
            }

            // model of result term
            val allFunApps: Iterator[(PreOp, Seq[ITerm], ITerm)] =
              (for (
                (ops, res) <- sortedFunApps.reverseIterator;
                (op, args) <- ops.iterator
              )
                yield (op, args, res)) ++
                ignoredApps.iterator
            model ++= generateResultModel(allFunApps, model)
            throw FoundModel(
              model.map { case (term, value) =>
                InputAbsy2Internal(term, lProver.order) -> value
              }.toMap
            )
          }
          case _ => return trivalConflict
        }

      }
      case (op, args, res) :: otherApps => {
        dfExploreOp(op, args, res, constraintStores(res).getContents, otherApps)
      }
    }

  def dfExploreOp(
      op: PreOp,
      args: Seq[ITerm],
      res: ITerm,
      resConstraints: List[Automaton],
      nextApps: List[(PreOp, Seq[ITerm], ITerm)]
  ): ConflictSet = resConstraints match {
    case List() =>
      dfExplore(nextApps)

    case resAut :: otherAuts => {
      ap.util.Timeout.check

      val argConstraints =
        for (a <- args) yield constraintStores(a).getCompleteContents

      val collectedConflicts = new LinkedHashSet[TermConstraint]

      // compute pre image for op
      val (newConstraintsIt, argDependencies) =
        measure("pre-op") { op(argConstraints, resAut) }

      // iterate over pre image
      while (newConstraintsIt.hasNext) {
        ap.util.Timeout.check

        val argCS = newConstraintsIt.next

        // push
        for (a <- args)
          constraintStores(a).push

        try {
          val newConstraints = new MHashSet[TermConstraint]

          var consistent = true
          for ((a, aut) <- args zip argCS)
            if (consistent) {
              newConstraints += TermConstraint(a, aut)
              // add pre image aut to its constraint store, check consistency
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

          if (consistent) {
            val conflict = dfExploreOp(op, args, res, otherAuts, nextApps)
            if (
              !conflict.isEmpty && Seqs.disjointSeq(newConstraints, conflict)
            ) {
              // we can jump back, because the found conflict does not depend
              // on the considered function application
              // println("backjump " + conflict)
              return conflict
            }
            collectedConflicts ++= (conflict.iterator filterNot newConstraints)
          }
        } finally {
          // pop
          for (a <- args)
            constraintStores(a).pop
        }
      }

      // generate conflict set
      if (needCompleteContentsForConflicts)
        collectedConflicts ++=
          (for (aut <- constraintStores(res).getCompleteContents)
            yield TermConstraint(res, aut))
      else
      collectedConflicts += TermConstraint(res, resAut)

      collectedConflicts ++=
        (for (
          (t, auts) <- args.iterator zip argDependencies.iterator;
          aut <- auts.iterator
        )
          yield TermConstraint(t, aut))
      collectedConflicts.toSeq
    }
  }

  // need to be cost-enriched constraints
  val allInitialConstraints: Seq[(ITerm, Automaton)] = {
    val coveredTerms = new MHashSet[ITerm]
    for ((t, _) <- initialConstraints)
      coveredTerms += t

    val additionalConstraints = new ArrayBuffer[(ITerm, Automaton)]

    // check whether any of the terms have concrete definitions
    for (t <- strTerms)
      for (w <- strDatabase.term2List(InputAbsy2Internal(t, TermOrder.EMPTY))) {
        val str: String = w.view.map(i => i.toChar).mkString("")
        additionalConstraints += ((t, BricsAutomatonWrapper fromString str))
        coveredTerms += t
      }

    for (
      (argsSeq, t) <- sortedFunApps;
      if {
        if (!(coveredTerms contains t)) {
          coveredTerms += t
          additionalConstraints +=
            ((t, BricsAutomatonWrapper.makeAnyString))
        }
        true
      };
      (_, args) <- argsSeq;
      arg <- args
    )
      coveredTerms += arg

    initialConstraints ++ additionalConstraints
  }

  // set to true if we product eagerly
  protected val needCompleteContentsForConflicts: Boolean = true
  protected def newStore(t: ITerm): ParikhStore =
    new ParikhStore(t)
}
