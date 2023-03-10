package ostrich.parikh

import ostrich.Exploration
import ap.terfor.Term
import ostrich.automata.Automaton
import scala.collection.mutable.{ArrayBuffer, ArrayStack, HashMap => MHashMap}
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import Exploration._
import ap.util.Seqs
import ostrich.parikh.automata.BricsAutomatonWrapper

object ParikhStore {
  sealed trait LIAStrategy // linear integer arithmetic generating strategy
  case class ArithAfterProduct() extends LIAStrategy
  case class ArithBeforeProduct(syncLen: Int) extends LIAStrategy
}

class ParikhStore(t: Term) extends ConstraintStore {


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
    Seqs.reduceToSize(constraints, oldSize)
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
        // println("Stored conflict applies!")
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
      auts: Seq[CostEnrichedAutomatonBase]
  ): Boolean = {
    var productAut : CostEnrichedAutomatonBase = BricsAutomatonWrapper.makeAnyString
    auts.sortBy(_.states.size).foreach { aut =>
      productAut = productAut & aut
      if(productAut.isEmpty) return false
    }
    true
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
      if (!isConsistency(consideredAuts.toSeq))
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
    } else Console.err.println("contain")
    None
  }

  def getContents: List[Automaton] = constraints.toList

  def getCompleteContents: List[Automaton] = constraints.toList

  def ensureCompleteLengthConstraints: Unit = None // no need

  def isAcceptedWord(w: Seq[Int]): Boolean = false // no need

  def getAcceptedWord: Seq[Int] = Seq() // no need
  def getAcceptedWordLen(len: Int): Seq[Int] = Seq() // no need

}
