package ostrich.cesolver.automata

import dk.brics.automaton.{
  BasicAutomata,
  RegExp,
  Automaton => BAutomaton
}

import scala.collection.JavaConverters.asScala

object BricsAutomatonWrapper {

  type State = BricsAutomatonWrapper#State
  type TLabel = BricsAutomatonWrapper#TLabel

  def apply(): BricsAutomatonWrapper =
    BricsAutomatonWrapper(new BAutomaton)

  def apply(underlying: BAutomaton): BricsAutomatonWrapper = 
    new BricsAutomatonWrapper(underlying)

  /** Build CostEnriched automaton from a regular expression in brics format
    */
  def apply(pattern: String): BricsAutomatonWrapper =
    BricsAutomatonWrapper(new RegExp(pattern).toAutomaton(false))

  def fromString(str: String): BricsAutomatonWrapper =
    BricsAutomatonWrapper(BasicAutomata makeString str)

  def makeAnyString(): BricsAutomatonWrapper =
    BricsAutomatonWrapper(BAutomaton.makeAnyString)
  
  def makeEmpty(): BricsAutomatonWrapper =
    BricsAutomatonWrapper(BAutomaton.makeEmpty)

  def makeEmptyString(): BricsAutomatonWrapper = 
    BricsAutomatonWrapper(BAutomaton.makeEmptyString())

  /** Check whether we should avoid ever minimising the given automaton.
    */
  def neverMinimize(aut: BAutomaton): Boolean =
    aut.getSingleton != null || aut.getNumberOfStates > MINIMIZE_LIMIT

  private val MINIMIZE_LIMIT = 100000
}

/** Wrapper for the dk.brics.automaton. Extend dk.brics.automaton with
  * registers and update for each transition.
  */
class BricsAutomatonWrapper(val underlying: BAutomaton)
    extends CostEnrichedAutomatonBase {

  private val old2new = asScala(underlying.getStates()).map(s => (s, newState())).toMap
  
  // initialize
  initialState = old2new(underlying.getInitialState())
  for (s <- asScala(underlying.getStates())){
    for (t <- asScala(s.getTransitions()))
      addTransition(old2new(s), (t.getMin(), t.getMax()), old2new(t.getDest()), Seq())
  }
  for (s <- asScala(underlying.getAcceptStates()))
    setAccept(old2new(s),true)
}
