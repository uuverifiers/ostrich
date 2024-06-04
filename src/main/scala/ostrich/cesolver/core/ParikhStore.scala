/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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

import ostrich.automata.Automaton
import scala.collection.mutable.{ArrayBuffer, ArrayStack, HashMap => MHashMap}
import ostrich.cesolver.convenience.CostEnrichedConvenience._
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ParikhExploration._
import ostrich.Exploration.ConstraintStore
import ap.util.Seqs
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ap.parser.ITerm

object ParikhStore {
  sealed trait LIAStrategy // linear integer arithmetic generating strategy
  case class ArithAfterProduct() extends LIAStrategy
  case class ArithBeforeProduct(syncLen: Int) extends LIAStrategy
}

class ParikhStore(t: ITerm) {

  // constraints in this store
  private val constraints = new ArrayBuffer[Automaton]
  // the stack is used to push and pop constraints
  private val constraintStack = new ArrayStack[Int]
  private val productAutStack = new ArrayStack[Automaton]

  // the intermidiate product automaton
  private var productAut: Automaton = BricsAutomatonWrapper.makeAnyString

  // Combinations of automata that are known to have empty intersection
  private val inconsistentAutomata = new ArrayBuffer[Seq[Automaton]]
  // Map from watched automata to the indexes of
  // <code>inconsistentAutomata</code> that is watched
  private val watchedAutomata = new MHashMap[Automaton, List[Int]]

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

  /** Check if constraints are still consistent after adding `aut`
    * @param aut
    *   new added aut
    * @return
    *   None if constraints are still consistent; Some(unsatCore) otherwise.
    */
  private def checkConsistency(aut: Automaton): Option[Seq[Automaton]] = {
    productAut = productAut & automaton2CostEnriched(aut)
    if (productAut.isEmpty) {
      val consideredAuts = ArrayBuffer(aut)
      var tmpAut = aut
      for (aut2 <- constraints) {
        if (tmpAut.isEmpty) return Some(consideredAuts.toSeq)
        tmpAut = tmpAut & automaton2CostEnriched(aut2)
        consideredAuts += aut2
      }
    }
    None
  }
  def assertConstraint(aut: Automaton): Option[ConflictSet] = {
    // Console.err.println("assert")

    if (!constraints.contains(aut)) {
      // check if the stored automata is consistent after adding the aut
      // 1. check if the aut is already in inconsistent core:
      // We will maintain an ArrayBuffer **inconsistentAutomata** to store confilctSets.
      // We return the conflictSet directly if current constraints with aut belongs to
      // one confilctSet in **inconsistentAutomata**.
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

  // used to get the product automaton
  def getContents: List[Automaton] = Seq(productAut).toList

  // used to cut off the searching tree
  def getCompleteContents: List[Automaton] = constraints.toList

  def ensureCompleteLengthConstraints: Unit = None // no need

  def isAcceptedWord(w: Seq[Int]): Boolean = false // no need

  def getAcceptedWord: Seq[Int] = Seq() // no need
  def getAcceptedWordLen(len: Int): Seq[Int] = Seq() // no need

}
