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
  ArrayStack,
  HashMap => MHashMap,
  HashSet => MHashSet,
  BitSet => MBitSet
}
import ostrich.parikh.automata.CostEnrichedAutomaton
import ap.parser.SymbolCollector
import ostrich.parikh.CostEnrichedConvenience._
import scala.collection.breakOut
import ostrich.parikh.preop.LengthCEPreOp
import ap.basetypes.IdealInt
import ap.terfor.TerForConvenience._
import TermGeneratorOrder._
import ParikhUtil._
import SimpleAPI.ProverStatus
import scala.collection.mutable.LinkedHashSet
import ap.util.Seqs
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.Config.{strategy, IC3Based, ParikhBased, RegisterBased}
import ostrich.parikh.preop.SubStringCEPreOp
import ap.terfor.Formula
import ap.api.PartialModel
import ostrich.automata.AtomicStateAutomatonAdapter
object ParikhExploration {
  sealed trait LIAStrategy // linear integer arithmetic(LIA) generate strategy
  case class ArithAfterProduct() extends LIAStrategy
  case class ArithBeforeProduct(syncLen: Int) extends LIAStrategy
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
  import ParikhExploration._

  override val leafTerms =
    allTerms filter { case t => !(resultTerms contains t) }

  private var lengthModel: Option[PartialModel] = None

  private val constraintStores = new MHashMap[Term, ParikhStore]

  // lengthProver p is used to solve linear arithmatic constraints
  val p = _lengthProver.get

  // if unknown is true, the unsat result is unsound, return empty conflict set
  var unknown = false

  // all interger term
  val integerTerm = new ArrayBuffer[Term]
  // all string term
  var allStrTerms = allTerms

  funApps.foreach {
    case (_: LengthCEPreOp, _, res) => // length op
      allStrTerms -= res
      integerTerm += res
    case (_: SubStringCEPreOp, Seq(_, beginIdx, length), _) =>
      allStrTerms -= beginIdx
      allStrTerms -= length
      integerTerm += length
      integerTerm += beginIdx
    case _ =>
  }

  def updateLengthModel = {
    lengthModel = {
      Some(p.partialModel)
    }
  }

  /** Given a sequence of automata, update `termModel`.
    * @return
    *   After this method is called, `termModel` will contain the mapping
    *   from each transition term to its int value
    */
  def resetTermModel: Unit = {
    val lModel = lengthModel.get
    for (t <- leafTerms) {
      val store = constraintStores(t)
      store.termModel.clear()
      for (
        term <- getAllTransTerms(store.getCurrentAuts);
        if term.constants.size == 1;
        tVal <- evalTerm(term)(lModel)
      )
        store.termModel.put(term, tVal.intValue)
    }
  }

  def checkArithConstency(f: Formula): ProverStatus.Value = {
    pushLengthConstraints
    p.!!(f)
    p.addConstantsRaw(SymbolCollector constants f)
    val res = p.???
    updateLengthModel
    popLengthConstraints
    res
  }

  def findAcceptedWordForTerm(t: Term): Option[Seq[Int]] = {
    resetTermModel
    val store = constraintStores(t)
    val auts = store.getCurrentAuts
    val termModel = store.termModel
    findAcceptedWord(auts, termModel)
  }

  def repeatCheckArithConsistency(
      f: Formula,
      repeatTime: Int
  ): ProverStatus.Value = {
    println("repeat check arith consistency")
    var currentF = f
    var currentTime = 0
    while (currentTime < repeatTime) {
      checkArithConstency(currentF) match {
        case ProverStatus.Sat =>
          val unsatCore = disjFor(
            for (t <- leafTerms; if findAcceptedWordForTerm(t) == None) yield {
              val termModel = constraintStores(t).termModel
              disjFor(termModel.map { case (t, value) => t =/= value })
            }
          )
          if (unsatCore.length == 0)  
            return ProverStatus.Sat
          currentF = conj(currentF, unsatCore)
          currentTime += 1
        case ProverStatus.Unsat => return ProverStatus.Unsat
        case _ =>
      }
    }
    ProverStatus.Unknown
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
      if (unknown) throw new Exception("unknown")
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
        def trivalConflict: ConflictSet = {
          for (
            t <- leafTerms.toSeq;
            aut <- constraintStores(t).getContents
          ) yield TermConstraint(t, aut)
        }

        def checkFinalArithConsistency: Option[ConflictSet] = {
          strategy match {
            case RegisterBased() =>
              println("find word-----------------------------------------")
              val finalArith = conj(for (t <- leafTerms) yield {
                constraintStores(t).getArithFormula(ArithAfterProduct())
              })
              checkArithConstency(finalArith) match {
                case ProverStatus.Sat => // nothing
                case _                => return Some(trivalConflict) // not sat
              }
            // TODO: Implement parikh based
            case ParikhBased(minSyncLen, maxSyncLen, repeatTimes) =>
              for (syncLen <- minSyncLen until maxSyncLen + 1) {
                val finalArith = conj(for (t <- leafTerms) yield {
                  constraintStores(t).getArithFormula(
                    ArithBeforeProduct(syncLen)
                  )
                })
                repeatCheckArithConsistency(finalArith, repeatTimes) match {
                  case ProverStatus.Sat => return None
                  case ProverStatus.Unsat => return Some(trivalConflict) // not sat
                  case ProverStatus.Unknown => 
                }
                // case IC3Based() => return Seq() // TODO
              }
              // neither sat not unsat, throw unkonwn
              throw new Exception("unknown")
          }
          None
        }
        checkFinalArithConsistency match {
          case None              => // nothing
          case Some(confilctSet) => return confilctSet
        }

        // values for leaf string variables
        resetTermModel
        for (t <- leafTerms) {
          val store = constraintStores(t)
          model.put(t, Right(store.getAcceptedWord))
        }

        // values for integer variables
        for (
          lModel <- lengthModel;
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
            // if (_oldValue != resValue)
            //   throw new Exception(
            //     "Model extraction failed: " + _oldValue + " != " + resValue
            //   )
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
              println("backjump " + (conflict map {
                case TermConstraint(t, aut) => (t, aut)
              }))
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
    for (t <- allStrTerms)
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
            ((sortedFunApps(n)._2, CostEnrichedAutomaton.makeAnyString()))
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
  protected def newStore(t: Term): ParikhStore = new ParikhStore(t)

  class ParikhStore(t: Term) extends ConstraintStore {

    val termModel = new MHashMap[Term, Int]
    // current product automaton
    private var currentProduct: CostEnrichedAutomatonTrait =
      CostEnrichedAutomaton.makeAnyString()
    private var currentParikhAuts: Seq[CostEnrichedAutomatonTrait] =
      Seq()

    // constraints in this store
    private val constraints = new ArrayBuffer[Automaton]
    // the stack is used to push and pop constraints
    private val constraintStack = new ArrayStack[Int]

    // Combinations of automata that are known to have empty intersection
    private val inconsistentAutomata = new ArrayBuffer[Seq[Automaton]]
    // Map from watched automata to the indexes of
    // <code>inconsistentAutomata</code> that is watched
    private val watchedAutomata = new MHashMap[Automaton, List[Int]]


    // calling for `p.???` will reset formula in p
    // Remember to use `pushLengthConstraints` and `popLengthConstraints`
    // to store formula !!
    /** push to store current linear arith formula before add new constraints
      */
    def pushLengthConstraints: Unit = {
      p.push
    }

    /** pop to restore the linear arith formula
      */
    def popLengthConstraints: Unit = {
      p.pop
    }

    def push: Unit = {
      constraintStack push constraints.size
    }

    def pop: Unit = {
      val oldSize = constraintStack.pop
      constraints reduceToSize oldSize
    }

    /** Check if there is directly confilct
      * @param aut
      *   new added aut
      * @return
      *   None if constraints belong to one of **inconsistentAutomata**;
      *   ConflicSet otherwise.
      */
    private def directlyConflictSet(aut: Automaton): Option[ConflictSet] = {
      var potentialConflictsIdxs = watchedAutomata.getOrElse(aut, List())
      while (!potentialConflictsIdxs.isEmpty) {
        val potentialConflictsIdx = potentialConflictsIdxs.head
        val potentialConflicts = inconsistentAutomata(potentialConflictsIdx)
        if (potentialConflicts.forall((constraints :+ aut).contains(_))) {
          // constraints have become inconsistent!
          println("Stored conflict applies!")
          return Some(
            for (a <- potentialConflicts.toList)
              yield TermConstraint(t, a)
          )
        }
        potentialConflictsIdxs = potentialConflictsIdxs.tail
      }
      None
    }

    /** Check if there is conflict among auts
      * @param auts
      *   the automata to check
      * @return
      *   ture if not conflict; false otherwise
      */
    private def isConsistency(
        auts: Seq[CostEnrichedAutomatonTrait]
    ): Boolean = {
      if (auts.size == 1) {
        currentProduct = AtomicStateAutomatonAdapter.intern(auts(0))
        true
      } else {
        currentProduct = auts.reduceLeft(_ & _)
        !currentProduct.isEmpty
      }
    }

    /** Check if constraints are still consistent after adding `aut`
      * @param aut
      *   new added aut
      * @return
      *   None if constraints are still consistent; Some(unsatCore) otherwise.
      */
    private def checkConsistency(aut: Automaton): Option[Seq[Automaton]] = {
      val consideredAuts = new ArrayBuffer[Automaton]
      for (aut2 <- constraints :+ aut) {
        consideredAuts += aut2
        if (!isConsistency(consideredAuts))
          return Some(consideredAuts.toSeq)
      }
      None
    }
    def assertConstraint(aut: Automaton): Option[ConflictSet] = {

      if (!constraints.contains(aut)) {
        // check if the stored automata is consistent after adding the aut
        // 1. check if the aut is already in inconsistent core:
        // We will maintain an ArrayBuffer **inconsistentAutomata** to store confilctSets.
        // We return the conflictSet directly if current constraints with aut belongs to
        // one confilctSet in **inconsistentAutomata**.
        println("check")
        directlyConflictSet(aut) match {
          case Some(confilctSet) => return Some(confilctSet);
          case None              => // do nothing
        }

        // 2. check if the stored automata are consistent after adding the aut:
        checkConsistency(aut) match {
          case Some(inconsistentAuts) => {
            // add the inconsistent automata to the list of inconsistent automata
            inconsistentAutomata += inconsistentAuts
            // add the index of the inconsistent automata to the watched automata
            for (inconsistentAut <- inconsistentAuts) {
              watchedAutomata.put(
                inconsistentAut,
                watchedAutomata.getOrElse(
                  inconsistentAut,
                  List()
                ) :+ inconsistentAutomata.size - 1
              )
            }
            // return the conflictSet
            return Some(
              for (a <- inconsistentAuts.toList)
                yield TermConstraint(t, a)
            )
          }
          case None => {
            constraints += aut
            None
          }
        }
      } else println("contain")
      None
    }

    def getArithFormula(strategy: LIAStrategy): Formula = {
      strategy match {
        case ArithAfterProduct() =>
          conj(currentProduct.intFormula, currentProduct.parikhImage)
        case ArithBeforeProduct(syncLen) =>
          val labels = split2MinLabels(constraints)
          val (syncLenAuts, states2Prefix) =
            getSyncLenAuts(constraints, labels, syncLen)
          val syncFormula = sync(syncLenAuts, states2Prefix, labels, syncLen)
          currentParikhAuts = syncLenAuts
          conj(
            syncLenAuts.map(_.parikhImage) ++: syncLenAuts.map(
              _.intFormula
            ) :+ syncFormula
          )
      }
    }

    def getContents: List[Automaton] = constraints.toList

    def getCompleteContents: List[Automaton] = constraints.toList

    def ensureCompleteLengthConstraints: Unit = None // do nothing

    def isAcceptedWord(w: Seq[Int]): Boolean = {
      val constraintSet = constraints.toSet
      for (aut <- constraintSet) {
        if (!aut(w)) {
          return false
        }
      }
      return true
    }

    def getAcceptedWord: Seq[Int] = {
      val finalCostraints = getCurrentAuts
      findAcceptedWord(finalCostraints, termModel) match {
        case Some(w) => return w
        case None    => throw new Exception("not find word") // do nothing
      }
    }
    def getAcceptedWordLen(len: Int): Seq[Int] = Seq() // no need

    def getCurrentAuts: Seq[Automaton] = strategy match {
      case ParikhBased(_, _, _) =>
        currentParikhAuts
      case RegisterBased() =>
        Seq(currentProduct)
      case IC3Based() =>
        Seq(currentProduct)
    }
  }
}
