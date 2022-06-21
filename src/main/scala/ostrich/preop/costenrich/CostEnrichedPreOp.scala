package ostrich.preop.costenrich

import ostrich.preop.PreOp
import ostrich.automata.Automaton
import ap.terfor.{Formula, Term, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ostrich.automata.costenrich.CostEnrichedAutomaton

trait CostEnrichedPreOp extends PreOp {

  /** Given a sequence of registers for the arguments and
   * registers for the result, derive a sequence of formula.
   * It is sound to just return `true`
   */
  def lengthConstraints(
                         argumentsRegisters: Iterator[Seq[Seq[Term]]],
                         resultRegisters: Seq[Term],
                         order: TermOrder
                       ): Iterator[Formula] =
    Iterator(Conjunction.TRUE)
}
