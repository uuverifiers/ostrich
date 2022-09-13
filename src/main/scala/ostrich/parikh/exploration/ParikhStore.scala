package ostrich.parikh

import ostrich.Exploration
import ap.terfor.Term
import ostrich.automata.Automaton
import scala.collection.mutable.{
  ArrayBuffer,
  ArrayStack,
  HashMap => MHashMap
}
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.CostEnrichedConvenience._
import ap.terfor.TerForConvenience._
import TermGeneratorOrder._
import ParikhUtil._
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.Config.{strategy, SyncSubstr, BasicProduct}
import ap.terfor.Formula
import ostrich.automata.AtomicStateAutomatonAdapter
import Exploration._

object ParikhStore {
  sealed trait LIAStrategy // linear integer arithmetic(LIA) generate strategy
  case class ArithAfterProduct() extends LIAStrategy
  case class ArithBeforeProduct(syncLen: Int) extends LIAStrategy
}


class ParikhStore(t: Term) extends ConstraintStore {

  import ParikhStore._
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
        conj(currentProduct.intFormula, currentProduct.registersAbstraction)
      case ArithBeforeProduct(syncLen) =>
        val labels = split2MinLabels(constraints)
        val (syncLenAuts, states2Prefix) =
          getSyncLenAuts(constraints, labels, syncLen)
        val syncFormula = sync(syncLenAuts, states2Prefix, labels, syncLen)
        currentParikhAuts = syncLenAuts
        conj(
          syncLenAuts.map(_.registersAbstraction) ++: syncLenAuts.map(
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
    case SyncSubstr(_, _, _) =>
      currentParikhAuts
    case BasicProduct() =>
      Seq(currentProduct)
  }
}
