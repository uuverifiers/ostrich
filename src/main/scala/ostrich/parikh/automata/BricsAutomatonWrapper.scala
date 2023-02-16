package ostrich.parikh.automata

import dk.brics.automaton.{
  BasicAutomata,
  RegExp,
  Automaton => BAutomaton
}
import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  LinkedHashSet => MLinkedHashSet,
  Stack => MStack
}

import scala.collection.mutable.ArrayBuffer
import ostrich.parikh._
import ap.terfor.TerForConvenience._
import TermGeneratorOrder.order
import scala.collection.JavaConverters.asScala

import ostrich.parikh.automata.CostEnrichedAutomatonBase
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

  /** Check whether we should avoid ever minimising the given automaton.
    */
  def neverMinimize(aut: BAutomaton): Boolean =
    aut.getSingleton != null || aut.getNumberOfStates > MINIMIZE_LIMIT

  private val MINIMIZE_LIMIT = 100000
}

/** Wrapper for the BRICS automaton class. It is the same as the BRICS automaton
  * class, except that it has registers and update for each transition.
  */
class BricsAutomatonWrapper(val underlying: BAutomaton)
    extends CostEnrichedAutomatonBase {
  // initialize
  val old2new = asScala(underlying.getStates()).map(s => (s, newState())).toMap
  for (s <- asScala(underlying.getStates())){
    setAccept(old2new(s), s.isAccept)
    for (t <- asScala(s.getTransitions()))
      addTransition(old2new(s), (t.getMin(), t.getMax()), old2new(t.getDest()), Seq())
  }
  initialState = old2new(underlying.getInitialState)
}
