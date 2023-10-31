package ostrich.cesolver.convenience

import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.automata.Automaton
import ostrich.automata.BricsAutomaton
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
object CostEnrichedConvenience {
  def automaton2CostEnriched(
      auts: Seq[Automaton]
  ): Seq[CostEnrichedAutomatonBase] =
    auts.map(automaton2CostEnriched(_))

  def automaton2CostEnriched(aut: Automaton): CostEnrichedAutomatonBase = {
    if (
      aut.isInstanceOf[CostEnrichedAutomatonBase]
    ) {
      aut.asInstanceOf[CostEnrichedAutomatonBase]
    } else if (aut.isInstanceOf[BricsAutomaton]) {
      BricsAutomatonWrapper(aut.asInstanceOf[BricsAutomaton].underlying)
    } else {
      val e = new Exception(s"Automaton $aut is not a cost-enriched automaton")
      e.printStackTrace()
      throw e
    }
  }

}
