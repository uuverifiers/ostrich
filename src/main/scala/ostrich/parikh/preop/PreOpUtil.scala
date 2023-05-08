package ostrich.parikh.preop
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ostrich.parikh.automata.BricsAutomatonWrapper.{makeEmpty, makeEmptyString}

object PreOpUtil {
    def automatonWithLen(len: Int): CostEnrichedAutomatonBase = {
    if (len < 0) return makeEmpty()
    if (len == 0) return makeEmptyString()
    val automaton = new CostEnrichedAutomatonBase
    val sigma = automaton.LabelOps.sigmaLabel
    val states =
      automaton.initialState +: (for (_ <- 0 to len) yield automaton.newState())
    for (i <- 0 until len) {
      automaton.addTransition(states(i), sigma, states(i + 1), Seq())
    }
    automaton.setAccept(states(len), true)
    automaton
  }

  def automatonWithLenLessThan(len: Int): CostEnrichedAutomatonBase = {
    if (len <= 0) return makeEmpty()
    val automaton = new CostEnrichedAutomatonBase
    val sigma = automaton.LabelOps.sigmaLabel
    val states =
      automaton.initialState +: (for (_ <- 0 to len) yield automaton.newState())
    for (i <- 0 until len - 1) {
      automaton.setAccept(states(i), true)
      automaton.addTransition(states(i), sigma, states(i + 1), Seq())
    }
    automaton.setAccept(states(len - 1), true)
    automaton
  }
}