package ostrich.preop.costenrich

import ostrich.preop.PreOp
import ostrich.automata.Automaton
import ap.terfor.{Formula, Term, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ostrich.automata.costenrich.CostEnrichedAutomaton

trait CostEnrichedPreOp extends PreOp {

  /** Given an iterator of pre-image constraints clusters and a result
    * constraint, derive a sequence of formulas. Each formula responds to a
    * pre-image constraints cluster It is sound to just return `true`
    */
  def lengthConstraints(
      preImageConstraints: Seq[CostEnrichedAutomaton],
      resultConstraint: CostEnrichedAutomaton
  )(implicit order: TermOrder): Formula =
    Conjunction.TRUE

  /** If this op return integer result
   */  
  def isIntRes: Boolean = false
  
}