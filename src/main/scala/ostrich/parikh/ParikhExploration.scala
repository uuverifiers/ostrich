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
import ap.terfor.SortedWithOrder
import ostrich.OstrichSolver
import ap.proof.theoryPlugins.Plugin
import ap.terfor.TerForConvenience._
import TermGeneratorOrder._
import ap.terfor.Formula
import ParikhUtil._
import SimpleAPI.ProverStatus
import ap.terfor.conjunctions.Conjunction
import scala.collection.mutable.LinkedHashSet
import ap.util.Seqs

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
  import OFlags.debug

  // all interger term
  val integerTerm = new ArrayBuffer[Term]
  // all string term
  var allStrTerms = allTerms

  funApps.foreach {
    case (preOp: LengthCEPreOp, args, res) =>
      allStrTerms = allStrTerms - res
      integerTerm += res
    case (preOp, args, res) =>
  }

  // override the model generation function
  override def dfExplore(apps: List[(PreOp, Seq[Term], Term)]): ConflictSet =
    apps match {

      case List() => {
        if (debug)
          Console.err.println("Trying to contruct model")

        // TODO: Parikh solver will introduce integer, we should consider
        // them when generate model.

        // we are finished and just have to construct a model
        val model = new MHashMap[Term, Either[IdealInt, Seq[Int]]]

        val lengthModel = {
          for (t <- allTerms)
            constraintStores(t).ensureCompleteLengthConstraints
          for (core <- checkLengthConsistency)
            // we failed and need to try other pre-image
            return core
          Some(_lengthProver.get.partialModel)
        }

        // values for string variables
        val leafTerms =
          allTerms filter { case t => !(resultTerms contains t) }
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

          if (debug)
            Console.err.println(
              "Derived model value: " + res + " <- " + args
            )

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
        if (debug)
          Console.err.println("dfExplore, depth " + apps.size)
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
      if (debug)
        Console.err.println("dfExploreOp, #constraints " + resConstraints.size)

      ap.util.Timeout.check

      val argConstraints =
        for (a <- args) yield constraintStores(a).getCompleteContents

      val collectedConflicts = new LinkedHashSet[TermConstraint]

      val (newConstraintsIt, argDependencies) =
        measure("pre-op") { op(argConstraints, resAut) }
      while (measure("pre-op hasNext") { newConstraintsIt.hasNext }) {
        ap.util.Timeout.check

        val argCS = measure("pre-op next") { newConstraintsIt.next }

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

          if (consistent) {
            val conflict = dfExploreOp(op, args, res, otherAuts, nextApps)
            if (!conflict.isEmpty && Seqs.disjointSeq(newConstraints, conflict)) {
              // we can jump back, because the found conflict does not depend
              // on the considered function application
println("backjump " + (conflict map { case TermConstraint(t, aut) => (t, aut) }))
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
        (for (
          (t, auts) <- args.iterator zip argDependencies.iterator;
          aut <- auts.iterator
        )
          yield TermConstraint(t, aut))

      collectedConflicts.toSeq
    }
  }

  // need to be cost-enriched constraints
  override val allInitialConstraints = {
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
  protected def newStore(t: Term): ConstraintStore = new ParikhStore(t)

  private class ParikhStore(t: Term) extends ConstraintStore {
    // the string accepted by this constraint store
    private var acceptedString: Option[String] = None
    // the length model used to generate accepted string
    private val lengthModel = new MHashMap[Term, Int]
    // current product automaton
    private var currentFormula = Conjunction.TRUE

    // constraints in this store
    private val constraints = new ArrayBuffer[Automaton]
    // the stack is used to push and pop constraints
    private val constraintStack = new ArrayStack[Int]
    // formulas computed from constraints
    // private val formulas = new ArrayBuffer[Formula]
    // // the stack is used to push and pop formulas
    // private val formulaStack = new ArrayStack[Int]

    // Combinations of automata that are known to have empty intersection
    private val inconsistentAutomata = new ArrayBuffer[Seq[Automaton]]
    // Map from watched automata to the indexes of
    // <code>inconsistentAutomata</code> that is watched
    private val watchedAutomata = new MHashMap[Automaton, List[Int]]

    /** Given a sequence of automata, product them
      * @return
      *   true if auts are consistent. The side effect is to update
      *   `currentFormula`
      */
    def checkConsistenceByProduct(
        auts: Seq[CostEnrichedAutomaton],
        lengthProver: Option[SimpleAPI]
    ): Boolean = {
      val p = lengthProver.getOrElse(
        SimpleAPI()
      )
      val productAut = auts.reduceLeft(_ & _)
      val linearArith = conj(productAut.intFormula, productAut.parikhTheory)
      p.!!(linearArith)
      p.addConstantsRaw(SymbolCollector.constants(linearArith))
      if (p.??? == ProverStatus.Sat) {
        currentFormula = linearArith
        true
      } else
        false
    }

    def updateLengthModel(auts: Seq[CostEnrichedAutomaton]): Unit = {
      val lModel = _lengthProver.get.partialModel
      for (
        term <- getAllConstantTerms(auts);
        if term.constants.size == 1;
        tVal <- evalTerm(term)(lModel)
      )
        lengthModel.put(term, tVal.intValue)
    }

    def pushLengthConstraints: Unit = {
      for (p <- _lengthProver) p.push
    }

    def popLengthConstraints: Unit = {
      for (p <- _lengthProver) p.pop
    }

    def push: Unit = {
      constraintStack push constraints.size
      // for (p <- _lengthProver) p.push
      // formulaStack push formulas.size
    }

    def pop: Unit = {
      val oldSize = constraintStack.pop
      constraints reduceToSize oldSize
      // for (p <- _lengthProver) p.pop
      // val oldSize2 = formulaStack.pop
      // formulas reduceToSize oldSize2
    }

    def assertConstraint(aut: Automaton): Option[ConflictSet] = {
      val constraintSet = constraints.toSet

      /** Check if there is directly confilct
        * @param aut
        *   new added aut
        * @return
        *   None if constraints belong to one of **inconsistentAutomata**;
        *   ConflicSet otherwise.
        */
      def directlyConflictSet(aut: Automaton): Option[ConflictSet] = {
        var potentialConflictsIdxs = watchedAutomata.getOrElse(aut, List())
        while (!potentialConflictsIdxs.isEmpty) {
          val potentialConflictsIdx = potentialConflictsIdxs.head
          val potentialConflicts = inconsistentAutomata(potentialConflictsIdx)
          if (constraintSet.forall(potentialConflicts.contains(_))) {
            // constraints have become inconsistent!
            println("Stored conflict applies!")
            return Some(
              for (a <- potentialConflicts.toList)
                yield TermConstraint(t, a)
            )
          }
          potentialConflictsIdxs = potentialConflictsIdxs.tail
        }
        return None
      }

      /** Check if there is conflict among auts
        * @param auts
        *   the automata to check
        * @return
        *   ture if not conflict; false otherwise
        */
      def isConsistency(auts: Seq[CostEnrichedAutomaton]): Boolean = {
        // TODO: two strategy to check consistency
        class ProductStrategy
        case object RegisterBased extends ProductStrategy
        case object IC3Based extends ProductStrategy
        case object ParikhBased extends ProductStrategy

        val strategy: ProductStrategy = RegisterBased
        var res = false
        pushLengthConstraints
        strategy match {
          case RegisterBased =>
            res = checkConsistenceByProduct(auts, _lengthProver)
          case ParikhBased =>
            res = checkConsistenceByParikh(auts, _lengthProver)
          case IC3Based =>
            res = checkConsistenceByIC3(auts, _lengthProver)
        }
        popLengthConstraints
        res
      }

      /** Check if constraints are still consistent after adding `aut`
        * @param aut
        *   new added aut
        * @return
        *   None if constraints are still consistent; Some(unsatCore) otherwise.
        */
      def checkConsistency(aut: Automaton): Option[Seq[Automaton]] = {
        val consideredAuts = new ArrayBuffer[Automaton]
        // Bug: Each constraintStore should have an unique lengthProver.
        // We should clean all formula before running function `isConsistency`.
        // TODO: fix this bug.
        for (aut2 <- constraints :+ aut) {
          consideredAuts += aut2
          if (!isConsistency(consideredAuts)) {
            return Some(consideredAuts.toSeq)
          }
        }
        return None
      }
      if (!constraintSet.contains(aut)) {
        // check if the stored automata is consistent after adding the aut
        // 1. check if the aut is already in inconsistent core:
        // We will maintain an ArrayBuffer **inconsistentAutomata** to store confilctSets.
        // We return the conflictSet directly if current constraints with aut belongs to
        // one confilctSet in **inconsistentAutomata**.
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
            return None
          }
        }
      }
      return None
    }

    def getContents: List[Automaton] = constraints.toList

    def getCompleteContents: List[Automaton] = constraints.toList

    def ensureCompleteLengthConstraints: Unit = {
      for (p <- _lengthProver) {
        p.!!(currentFormula)
        p.addConstantsRaw(SymbolCollector.constants(currentFormula))
      }
    }

    def isAcceptedWord(w: Seq[Int]): Boolean = {
      val constraintSet = constraints.toSet
      for (aut <- constraintSet) {
        if (!aut(w)) {
          return false
        }
      }
      return true
    }

    /** Note that this function must be called after function
      * `ensureCompleteLengthConstraints` initing the .
      * @return
      *   the accepted word
      */
    def getAcceptedWord: Seq[Int] = {
      updateLengthModel(constraints)
      findAcceptedWord(constraints, lengthModel) match {
        case None    => throw new Exception("No accepted word found")
        case Some(w) => return w
      }
    }

    def getAcceptedWordLen(len: Int): Seq[Int] = getAcceptedWord // no need
  }
}
