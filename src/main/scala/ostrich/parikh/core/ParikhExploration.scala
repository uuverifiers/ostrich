package ostrich.parikh

import ostrich.Exploration
import ostrich.preop.PreOp
import ap.terfor.Term
import ostrich.automata.Automaton
import ostrich.StrDatabase
import ap.SimpleAPI
import ostrich.OFlags
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet,
  BitSet => MBitSet
}
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.CostEnrichedConvenience._
import scala.collection.breakOut
import ostrich.parikh.preop.LengthCEPreOp
import ap.basetypes.IdealInt
import SimpleAPI.ProverStatus
import scala.collection.mutable.LinkedHashSet
import ap.util.Seqs
import ostrich.parikh.preop.SubStringCEPreOp
import ostrich.parikh.core.LinearAbstractionSolver
import ostrich.parikh.core.Model.{IntValue, StringValue}
import ostrich.parikh.preop.IndexOfCEPreOp

object ParikhExploration {
  def isStringResult(op: PreOp): Boolean = op match {
    case _: LengthCEPreOp  => false
    case _: IndexOfCEPreOp => false
    case _                 => true
  }

  def generateResultModel(
      apps: Iterator[(PreOp, Seq[Term], Term)],
      model: MHashMap[Term, Either[IdealInt, Seq[Int]]]
  ): MHashMap[Term,Either[IdealInt,Seq[Int]]] = {
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
            "Model extraction failed: " + _oldValue + " != " + resValue
          )
      }

      if (isStringResult(op))
        model += (res -> Right(resValue))
    }
    model
  }
}

class ParikhExploration(
    _funApps: Seq[(PreOp, Seq[Term], Term)],
    _initialConstraints: Seq[(Term, Automaton)],
    _strDatabase: StrDatabase,
    _lengthProver: Option[SimpleAPI],
    _lengthVars: Map[Term, Term],
    _strictLengths: Boolean,
    _flags: OFlags
) extends Exploration(
      _funApps,
      _initialConstraints,
      _strDatabase,
      _lengthProver,
      _lengthVars,
      _strictLengths,
      _flags
    ) {

  import Exploration._

  override val leafTerms: Set[Term] =
    allTerms filter { case t => !(resultTerms contains t) }

  lazy val trivalConflict: ConflictSet = {
    for (
      t <- leafTerms.toSeq;
      aut <- constraintStores(t).getContents
    ) yield TermConstraint(t, aut)
  }

  private val constraintStores = new MHashMap[Term, ParikhStore]

  // all integer terms and string terms
  val (integerTerm, strTerms) = {
    var _integerTerm = Set[Term]()
    var _strTerms = allTerms
    funApps.foreach {
      case (_: LengthCEPreOp, _, res) => // length op
        _strTerms -= res
        _integerTerm += res
      case (_: SubStringCEPreOp, Seq(_, beginIdx, length), _) =>
        _strTerms -= beginIdx
        _strTerms -= length
        _integerTerm += length
        _integerTerm += beginIdx
      case _ =>
    }
    (_integerTerm, _strTerms)
  }

  override def findModel: Option[Map[Term, Either[IdealInt, Seq[Int]]]] = {
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
    }
  }

  // override the model generation function
  override def dfExplore(apps: List[(PreOp, Seq[Term], Term)]): ConflictSet =
    apps match {

      case List() => {
        // TODO: use different strategies to find the model
        // when assertConstraints is called, only product and check emptyness

        // we are finished and just have to construct a model
        val model = new MHashMap[Term, Either[IdealInt, Seq[Int]]]

        // check linear arith consistency of final automata

        val solver = new LinearAbstractionSolver
        solver.setInterestTerm(integerTerm)
        for (t <- leafTerms) {
          solver.addConstraint(t, constraintStores(t).getContents)
        }

        val res = solver.solve

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
                ignoredApps.iterator // TODO: reverseIterator?
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

  override def dfExploreOp(
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
      while (measure("pre-op hasNext") { newConstraintsIt.hasNext }) {
        ap.util.Timeout.check

        val argCS = measure("pre-op next") { newConstraintsIt.next }

        // push
        for (a <- args)
          constraintStores(a).push
        pushLengthConstraints

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
          popLengthConstraints
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
  override val allInitialConstraints: Seq[(Term, Automaton)] = {
    // transform brics automata to cost-enriched automata
    val initialConstraints = _initialConstraints.map { case (t, aut) =>
      (t, brics2CostEnriched(aut))
    }
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
      for (w <- _strDatabase.term2List(t)) {
        val str: String = w.map(i => i.toChar)(breakOut)
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
            ((sortedFunApps(n)._2, CostEnrichedAutomaton makeAnyString))
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
