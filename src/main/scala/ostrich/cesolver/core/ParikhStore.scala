package ostrich.cesolver.core

import scala.collection.mutable.{ArrayBuffer, ArrayStack, HashMap => MHashMap}
import ostrich.cesolver.convenience.CostEnrichedConvenience._
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ParikhExploration._
import ostrich.Exploration.ConstraintStore
import ap.util.Seqs
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ap.parser.ITerm
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.automata.CostEnrichedAutomaton
import ostrich.OFlags

class ParikhStore(t: ITerm, flags: OFlags) {

  // constraints in this store
  private val constraints = new ArrayBuffer[CostEnrichedAutomatonBase]
  // the stack is used to push and pop constraints
  private val constraintStack = new ArrayStack[Int]
  private val productAutStack = new ArrayStack[CostEnrichedAutomatonBase]

  // the intermidiate product automaton
  private var productAut: CostEnrichedAutomatonBase =
    BricsAutomatonWrapper.makeAnyString

  // Combinations of automata that are known to have empty intersection
  private val inconsistentAutomata =
    new ArrayBuffer[Seq[CostEnrichedAutomatonBase]]
  // Map from watched automata to the indexes of
  // <code>inconsistentAutomata</code> that is watched
  private val watchedAutomata =
    new MHashMap[CostEnrichedAutomatonBase, List[Int]]

  def push: Unit = {
    productAutStack push productAut
    constraintStack push constraints.size
  }

  def pop: Unit = {
    productAut = productAutStack.pop
    val oldSize = constraintStack.pop
    Seqs.reduceToSize(constraints, oldSize)
  }

  /** Check if there is directly confilct
    * @param aut
    *   new added aut
    * @return
    *   None if constraints belong to one of **inconsistentAutomata**;
    *   ConflicSet otherwise.
    */
  private def directlyConflictSet(
      aut: CostEnrichedAutomatonBase
  ): Option[ConflictSet] = {
    var potentialConflictsIdxs = watchedAutomata.getOrElse(aut, List())
    while (!potentialConflictsIdxs.isEmpty) {
      val potentialConflictsIdx = potentialConflictsIdxs.head
      val potentialConflicts = inconsistentAutomata(potentialConflictsIdx)
      if (potentialConflicts.forall((constraints :+ aut).contains(_))) {
        // constraints have become inconsistent!
        ParikhUtil.debugPrintln("Stored conflict applies!")
        return Some(
          for (a <- potentialConflicts.toList)
            yield TermConstraint(t, a)
        )
      }
      potentialConflictsIdxs = potentialConflictsIdxs.tail
    }
    None
  }

  private def checkConsistency(
      aut: CostEnrichedAutomatonBase
  ): Option[Seq[CostEnrichedAutomatonBase]] = {
    if (flags.noAutomataProduct)  return None
    productAut = productAut product aut
    val consideredAuts = new ArrayBuffer[CostEnrichedAutomatonBase]
    if (productAut.isEmpty) {
      // inconsistent, generate the minimal conflicted set
      var tmpAut: CostEnrichedAutomatonBase =
        BricsAutomatonWrapper.makeAnyString
      for (aut2 <- aut +: constraints) {
        tmpAut = tmpAut product aut2
        consideredAuts += aut2
        if (tmpAut.isEmpty) {
          // found the minimal conflicted set
          return Some(consideredAuts.toSeq)
        }
      }
    }
    None
  }

  /** Add `aut` to the store if `aut` is consistent with the stored constraints
    * @param aut
    *   added aut
    * @return
    *   None if constraints are still consistent; Some(unsatCore) otherwise.
    */
  def assertConstraint(aut: CostEnrichedAutomatonBase): Option[ConflictSet] = {
    if (!constraints.contains(aut)) {
      // check if the stored automata is consistent after adding the aut
      // 1. check if the aut is already in inconsistent core:
      // We will maintain an ArrayBuffer **inconsistentAutomata** to store confilctSets.
      // We return the conflictSet directly if current constraints contain
      // one of confilctSets in **inconsistentAutomata**.
      directlyConflictSet(aut) match {
        case Some(confilctSet) =>
          return Some(confilctSet);
        case None => // do nothing
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
    }
    None
  }

  // used to get the product automaton or stored automata
  def getContents: List[CostEnrichedAutomatonBase] =
    if (flags.eagerAutomataOperations)
      List(productAut)
    else
      constraints.toList

  // used to cut off the searching tree
  def getCompleteContents: List[CostEnrichedAutomatonBase] = constraints.toList

  def ensureCompleteLengthConstraints: Unit = None // no need

  def isAcceptedWord(w: Seq[Int]): Boolean = false // no need

  def getAcceptedWord: Seq[Int] = Seq() // no need
  
  def getAcceptedWordLen(len: Int): Seq[Int] = Seq() // no need

}
