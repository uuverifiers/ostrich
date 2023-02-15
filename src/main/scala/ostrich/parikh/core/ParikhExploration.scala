package ostrich.parikh

import ostrich.Exploration
import ostrich.preop.PreOp
import ap.terfor.Term
import ostrich.automata.Automaton
import ostrich.StrDatabase
import ap.SimpleAPI
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet,
  BitSet => MBitSet
}
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.preop.LengthCEPreOp
import ap.basetypes.IdealInt
import SimpleAPI.ProverStatus
import scala.collection.mutable.LinkedHashSet
import ap.util.Seqs
import ostrich.parikh.preop.SubStringCEPreOp
import ostrich.parikh.core.UnaryBasedSolver
import ostrich.parikh.core.Model.{IntValue, StringValue}
import ostrich.parikh.preop.IndexOfCEPreOp
import ostrich.parikh.core.CatraBasedSolver
import ostrich.parikh.core.BaselineSolver
import ostrich.parikh.OstrichConfig.Catra
import ostrich.parikh.OstrichConfig.Baseline
import ostrich.parikh.OstrichConfig.Unary
import ostrich.parikh.util.UnknownException
import ostrich.parikh.util.TimeoutException

object ParikhExploration {
  def isStringResult(op: PreOp): Boolean = op match {
    case _: LengthCEPreOp  => false
    case _: IndexOfCEPreOp => false
    case _                 => true
  }

  def generateResultModel(
      apps: Iterator[(PreOp, Seq[Term], Term)],
      model: MHashMap[Term, Either[IdealInt, Seq[Int]]]
  ): MHashMap[Term, Either[IdealInt, Seq[Int]]] = {
    for (
      (op, args, res) <- apps;
      argValues = args map model
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

      // check the consistence of old result values and computed result values
      for (oldValue <- model get res) {
        var _oldValue: Seq[Int] = Seq()
        oldValue match {
          case Left(value)  => _oldValue = Seq(value.intValueSafe)
          case Right(value) => _oldValue = value
        }
        if (_oldValue != resValue)
          throw new Exception(
            "Model extraction failed: old value::" + _oldValue + " != res value::" + resValue
          )
      }

      if (isStringResult(op))
        model += (res -> Right(resValue))
    }
    model
  }

  case class Approx(val approx: String) {
    override def toString = approx
    def isOverApprox = approx == "over"
    def isUnderApprox = approx == "under"
    def isNoApprox = approx == "no"
  }
}

class ParikhExploration(
    funApps: Seq[(PreOp, Seq[Term], Term)],
    initialConstraints: Seq[(Term, Automaton)],
    strDatabase: StrDatabase
) {
  import Exploration._

  def measure[A](op: String)(comp: => A): A =
    if (OstrichConfig.measureTime)
      ap.util.Timer.measure(op)(comp)
    else
      comp

  // topological sorting of the function applications
  // divide integer term and string term
  private val (integerTerms, strTerms, sortedFunApps, ignoredApps) = {
    // TODO: implement it
    val integerTerms = MHashSet[Term]()
    val strTerms = MHashSet[Term]()
    for ((t, _) <- initialConstraints)
      strTerms += t
    funApps.foreach {
      case (_: LengthCEPreOp, Seq(str), length) =>
        integerTerms += length; strTerms += str
      case (_: SubStringCEPreOp, Seq(str, start, length), subStr) =>
        integerTerms += start; integerTerms += length; strTerms += str;
        strTerms += subStr
      case (_, strs, resstr) => strTerms ++= strs; strTerms += resstr
    }

    val sortedApps = new ArrayBuffer[(Seq[(PreOp, Seq[Term])], Term)]
    var ignoredApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    var remFunApps = funApps
    var topSortedFunApps = funApps

    val termCout = new MHashMap[Term, Int]
    for ((op, args, res) <- funApps) {
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

      def term2String(t: Term) =
        if (strTerms contains t) {
          val str = strDatabase term2Str t
          str match {
            case Some(str) => "\"" + str + "\""
            case None      => t.toString()
          }
        } else t.toString()

      println("   " + term2String(res) + " =")
      for ((op, args) <- apps)
        println(
          "     " + op +
            "(" + (args map (term2String _) mkString ", ") + ")"
        )
    }
  }

  private val allTerms = integerTerms ++ strTerms

  private val resultTerms =
    (for ((_, t) <- sortedFunApps.iterator) yield t).toSet

  val leafTerms =
    allTerms filter { case t => !(resultTerms contains t) }

  lazy val trivalConflict: ConflictSet = {
    for (
      t <- leafTerms.toSeq;
      aut <- constraintStores(t).getContents
    ) yield TermConstraint(t, aut)
  }

  private val constraintStores = new MHashMap[Term, ParikhStore]

  def findModel: Option[Map[Term, Either[IdealInt, Seq[Int]]]] = {
    for (t <- allTerms)
      constraintStores.put(t, newStore(t))

    for ((t, aut) <- allInitialConstraints) {
      constraintStores(t).assertConstraint(aut) match {
        case Some(_) => return None
        case None    => // nothing
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
        println("--Unknown: " + info)
        System.exit(0)
        None
      case TimeoutException(time) =>
        println(s"--Timeout: $time s")
        System.exit(0)
        None
      case e: Exception =>
        println("--Exception: " + e)
        e.printStackTrace()
        System.exit(0)
        None
    }
  }

  // override the model generation function
  def dfExplore(apps: List[(PreOp, Seq[Term], Term)]): ConflictSet =
    apps match {

      case List() => {
        // TODO: use different strategies to find the model
        // when assertConstraints is called, only product and check emptyness

        // we are finished and just have to construct a model
        val model = new MHashMap[Term, Either[IdealInt, Seq[Int]]]

        // check linear arith consistency of final automata

        // val solver = new CatraBasedSolver
        val backendSolver =
          OstrichConfig.backend match {
            case Catra()    => new CatraBasedSolver
            case Baseline() => new BaselineSolver
            case Unary()    => new UnaryBasedSolver
          }

        backendSolver.setIntegerTerm(integerTerms.toSet)
        for (t <- leafTerms) {
          backendSolver.addConstraint(t, constraintStores(t).getContents)
        }

        val res = backendSolver.measureTimeSolve

        res.getStatus match {
          case ProverStatus.Sat => {
            import ParikhExploration.generateResultModel
            // model of leaf term
            for ((t, v) <- res.getModel) {
              v match {
                case IntValue(i)    => model.put(t, Left(i))
                case StringValue(s) => model.put(t, Right(s))
              }
            }

            // model of result term
            val allFunApps: Iterator[(PreOp, Seq[Term], Term)] =
              (for (
                (ops, res) <- sortedFunApps.reverseIterator;
                (op, args) <- ops.iterator
              )
                yield (op, args, res)) ++
                ignoredApps.iterator
            model ++= generateResultModel(allFunApps, model)

            throw FoundModel(model.toMap)
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
      args: Seq[Term],
      res: Term,
      resConstraints: List[Automaton],
      nextApps: List[(PreOp, Seq[Term], Term)]
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
              // println("backjump " + (conflict map {
              //   case TermConstraint(t, aut) => (t, aut)
              // }))
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
  val allInitialConstraints: Seq[(Term, Automaton)] = {
    val term2Index =
      (for (((_, t), n) <- sortedFunApps.iterator.zipWithIndex)
        yield (t -> n)).toMap

    val coveredTerms = new MBitSet
    for ((t, _) <- initialConstraints)
      for (ind <- term2Index get t)
        coveredTerms += ind

    val additionalConstraints = new ArrayBuffer[(Term, Automaton)]

    // check whether any of the terms have concrete definitions
    for (t <- strTerms)
      for (w <- strDatabase.term2List(t)) {
        val str: String = w.view.map(i => i.toChar).mkString("")
        additionalConstraints += ((t, CostEnrichedAutomaton fromString str))
        for (ind <- term2Index get t)
          coveredTerms += ind
      }

    for (
      n <- 0 until sortedFunApps.size;
      if {
        if (!(coveredTerms contains n)) {
          coveredTerms += n
          additionalConstraints +=
            ((sortedFunApps(n)._2, CostEnrichedAutomaton.makeAnyString))
        }
        true
      };
      (_, args) <- sortedFunApps(n)._1;
      arg <- args
    )
      for (ind <- term2Index get arg)
        coveredTerms += ind

    initialConstraints ++ additionalConstraints
  }

  protected val needCompleteContentsForConflicts: Boolean = false
  protected def newStore(t: Term): ParikhStore =
    new ParikhStore(t)
}