package ostrich.ceasolver.automata

class CostEnrichedAutomaton extends CostEnrichedAutomatonBase{

  def addEpsilon(s: State, t: State): Unit = {
    if(isAccept(t)) setAccept(s, true)
    for ((to, lbl, vec) <- outgoingTransitionsWithVec(t)) {
      addTransition(s, lbl, to, vec)
    }
  }
}