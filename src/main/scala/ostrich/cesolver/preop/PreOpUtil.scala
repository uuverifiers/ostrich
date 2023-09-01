package ostrich.cesolver.preop
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.BricsAutomatonWrapper.{
  makeEmpty,
  makeEmptyString
}

object PreOpUtil {
  def automatonWithLen(len: Int): CostEnrichedAutomatonBase = {
    if (len < 0) return makeEmpty()
    if (len == 0) return makeEmptyString()
    val ceAut = new CostEnrichedAutomatonBase
    val sigma = ceAut.LabelOps.sigmaLabel
    val states =
      ceAut.initialState +: (for (_ <- 0 to len) yield ceAut.newState())
    for (i <- 0 until len) {
      ceAut.addTransition(states(i), sigma, states(i + 1), Seq())
    }
    ceAut.setAccept(states(len), true)
    ceAut
  }

  def automatonWithLenLessThan(len: Int): CostEnrichedAutomatonBase = {
    if (len <= 0) return makeEmpty()
    val ceAut = new CostEnrichedAutomatonBase
    val sigma = ceAut.LabelOps.sigmaLabel
    val states =
      ceAut.initialState +: (for (_ <- 0 to len) yield ceAut.newState())
    for (i <- 0 until len - 1) {
      ceAut.setAccept(states(i), true)
      ceAut.addTransition(states(i), sigma, states(i + 1), Seq())
    }
    ceAut.setAccept(states(len - 1), true)
    ceAut
  }

}
