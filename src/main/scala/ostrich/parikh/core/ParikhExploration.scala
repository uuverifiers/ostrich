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
import ap.api.PartialModel
import ostrich.parikh.core.LinearAbstractionSolver
object ParikhExploration {}

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

  private var integerModel: Option[PartialModel] = None

  private val constraintStores = new MHashMap[Term, ParikhStore]

  // lengthProver p is used to solve linear arithmatic constraints
  val p = _lengthProver.get

  // if unknown is true, the unsat result is unsound, return empty conflict set
  var unknown = false

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

  /** update model of integers
    */
  // def updateIntegerModel: Unit = {
  //   integerModel = {
  //     Some(p.partialModel)
  //   }
  // }

  /** Given a sequence of automata, update their `termModel`.
    */
  // def resetTermModel: Unit = {
  //   val lModel = integerModel.get
  //   for (t <- leafTerms) {
  //     val store = constraintStores(t)
  //     store.termModel.clear()
  //     for (
  //       term <- getAllTransTerms(store.getCurrentAuts);
  //       if term.constants.size == 1;
  //       tVal <- evalTerm(term)(lModel)
  //     )
  //       store.termModel.put(term, tVal.intValue)
  //   }
  // }

  // def checkArithConsistency(f: Formula): ProverStatus.Value = {
  //   pushLengthConstraints
  //   p.!!(f)
  //   p.addConstantsRaw(SymbolCollector constants f)
  //   val res = p.???
  //   updateIntegerModel
  //   popLengthConstraints
  //   res
  // }

  // def repeatCheckArithConsistency(
  //     f: Formula,
  //     repeatTime: Int
  // ): ProverStatus.Value = {
  //   var currentF = f
  //   var currentTime = 0
  //   while (currentTime < repeatTime) {
  //     checkArithConsistency(currentF) match {
  //       case ProverStatus.Sat =>
  //         val unsatCore = disjFor(
  //           for (t <- leafTerms; if findAcceptedWordSpecificTerm(t) == None)
  //             yield {
  //               val termModel = constraintStores(t).termModel
  //               disjFor(termModel.map { case (t, value) => t =/= value })
  //             }
  //         )
  //         if (unsatCore.length == 0)
  //           return ProverStatus.Sat
  //         currentF = conj(currentF, unsatCore)
  //         currentTime += 1
  //       case ProverStatus.Unsat => return ProverStatus.Unsat
  //       case _                  =>
  //     }
  //   }
  //   ProverStatus.Unknown
  // }

  // def findAcceptedWordSpecificTerm(t: Term): Option[Seq[Int]] = {
  //   resetTermModel
  //   val store = constraintStores(t)
  //   findAcceptedWord(store.getCurrentAuts, store.termModel)
  // }

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
        for (t <- leafTerms) {
          solver.addConstraint(t, constraintStores(t).getContents)
        }

        val res = solver.solve
        
        res.getStatus match {
          case ProverStatus.Sat => {
            throw FoundModel(model.toMap)
          }
          case _ => return trivalConflict
        }

        // def checkFinalArithConsistency: Option[ConflictSet] = {
        //   strategy match {
        //     case BasicProduct() =>
        //       val finalArith = conj(for (t <- leafTerms) yield {
        //         constraintStores(t).getArithFormula(ArithAfterProduct())
        //       })
        //       checkArithConsistency(finalArith) match {
        //         case ProverStatus.Sat => // nothing
        //         case _                => return Some(trivalConflict) // not sat
        //       }

        //     case SyncSubstr(minSyncLen, maxSyncLen, repeatTimes) =>
        //       for (syncLen <- minSyncLen until maxSyncLen + 1) {
        //         val finalArith = conj(for (t <- leafTerms) yield {
        //           constraintStores(t).getArithFormula(
        //             ArithBeforeProduct(syncLen)
        //           )
        //         })
        //         repeatCheckArithConsistency(finalArith, repeatTimes) match {
        //           case ProverStatus.Sat => return None
        //           case ProverStatus.Unsat =>
        //             return Some(trivalConflict) // not sat
        //           case ProverStatus.Unknown =>
        //         }
        //         // case IC3Based() => return Seq() // TODO
        //       }
        //       // neither sat not unsat, throw unkonwn
        //       throw new Exception("unknown")
        //   }
        //   None
        // }
        // checkFinalArithConsistency match {
        //   case None              => // nothing
        //   case Some(confilctSet) => return confilctSet
        // }

        // values for leaf string variables
        // resetTermModel
        for (t <- leafTerms) {
          val store = constraintStores(t)
          model.put(t, Right(store.getAcceptedWord))
        }

        // values for integer variables
        for (
          lModel <- integerModel;
          c <- integerTerm;
          cVal <- evalTerm(c)(lModel)
        )
          model.put(c, Left(cVal))

        // values for result variables
        val allFunApps: Iterator[(PreOp, Seq[Term], Term)] =
          (for (
            (ops, res) <- sortedFunApps.reverseIterator;
            (op, args) <- ops.iterator
          )
            yield (op, args, res)) ++
            ignoredApps.iterator // TODO: reverseIterator?

        for (
          (op, args, res) <- allFunApps;
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

          // check the result string value is accepted by its automaton
          if (!integerTerm.contains(res)) {
            if (!(constraintStores(res) isAcceptedWord resValue))
              throw new Exception(
                "Could not satisfy regex constraints for " + res +
                  ", maybe the problems involves non-functional transducers?"
              )
            model.put(res, Right(resValue))
          }
        }
        throw FoundModel(model.toMap)
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

                  if (conflict.size == 0)
                    unknown = true
                  else
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
            ((sortedFunApps(n)._2, CostEnrichedAutomaton makeAnyString ))
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
