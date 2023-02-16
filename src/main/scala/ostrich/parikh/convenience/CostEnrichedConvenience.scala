package ostrich.parikh

import ostrich.parikh.automata.BricsAutomatonWrapper
import ostrich.automata.Automaton
import ap.parser.Internal2InputAbsy
import ap.terfor.Term
import ap.parser.ITerm
import ap.terfor.ConstantTerm
import ap.terfor.Formula
import ap.parser.IFormula
import ostrich.automata.BricsAutomaton
import ostrich.parikh.automata.CostEnrichedAutomatonBase
object CostEnrichedConvenience {

  def brics2CostEnriched(aut: Automaton): Automaton = {
    if (aut.isInstanceOf[BricsAutomaton])
      BricsAutomatonWrapper(aut.asInstanceOf[BricsAutomaton].underlying)
    else {
      val e = new Exception(
        s"Automaton $aut is not a bricsAutomaton or a costEnrichedAutomaton"
      )
      e.printStackTrace()
      throw e
    }
  }

  implicit def Internal2Input(f: Formula): IFormula =
    Internal2InputAbsy(f)

  implicit def Internal2Input(t: Iterable[Term]): Iterable[ITerm] =
    t.map(Internal2InputAbsy(_))

  implicit def term2ConstTerm(t: Seq[Term]): Seq[ConstantTerm] = {
    t.map(t => term2ConstTerm(t))
  }

  implicit def term2ConstTerm(t: Term): ConstantTerm = {
    if (t.isInstanceOf[ConstantTerm]) {
      t.asInstanceOf[ConstantTerm]
    } else {
      val e = new Exception(s"Term $t is not a constant term")
      e.printStackTrace()
      throw e
    }
  }

  implicit def automaton2CostEnriched(
      auts: Seq[Automaton]
  ): Seq[CostEnrichedAutomatonBase] =
    auts.map(automaton2CostEnriched(_))

  implicit def automaton2CostEnriched(aut: Automaton): CostEnrichedAutomatonBase = {
    if (
      aut.isInstanceOf[CostEnrichedAutomatonBase]
    ) {
      aut.asInstanceOf[CostEnrichedAutomatonBase]
    } else {
      val e = new Exception(s"Automaton $aut is not a cost-enriched automaton")
      e.printStackTrace()
      throw e
    }
  }

}
