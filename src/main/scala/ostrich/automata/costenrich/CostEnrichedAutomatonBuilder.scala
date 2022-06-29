package ostrich.automata.costenrich

import ostrich.automata._

import dk.brics.automaton.{
  BasicAutomata,
  BasicOperations,
  RegExp,
  Transition,
  Automaton => BAutomaton,
  State => BState
}
import scala.collection.mutable.{HashMap => MHashMap}
import scala.collection.JavaConversions.{
  asScalaIterator,
  iterableAsScalaIterable
}
import ap.terfor.Term
import scala.collection.mutable.ArrayBuffer

class CostEnrichedAutomatonBuilder
    extends AtomicStateAutomatonBuilder[
      CostEnrichedAutomaton#State,
      CostEnrichedAutomaton#TLabel
    ] {
  type State = CostEnrichedAutomaton#State
  type TLabel = CostEnrichedAutomaton#TLabel

  val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

  private var minimize = false

  val baut: BAutomaton = {
    val baut = new BAutomaton
    baut.setDeterministic(false)
    baut
  }

  private var etaMap: MHashMap[(State, TLabel, State), Seq[Int]] = new MHashMap

  private var registers: ArrayBuffer[Term] = new ArrayBuffer()

  def addRegister(register: Term) = {
    registers += register
  }

  def addRegisters(registers: Seq[Term]) = {
    this.registers ++= registers
  }

  def addEtaMap(map: MHashMap[(State, TLabel, State), Seq[Int]]) = {
    this.etaMap ++= map
  }

  /** The initial state of the automaton being built
    */
  def initialState: State = baut.getInitialState

  /** By default one can assume built automata are minimised before the are
    * returned. Use this to enable or disable it
    */
  def setMinimize(minimize: Boolean): Unit = { this.minimize = minimize }

  /** Create a fresh state that can be used in the automaton
    */
  def getNewState: State = new BState()

  /** Set the initial state
    */
  def setInitialState(q: State): Unit =
    baut.setInitialState(q)

  /** Add a new transition q1 --label,()--> q2
    */
  def addTransition(
      q1: State,
      label: TLabel,
      q2: State
  ): Unit = {
    if (LabelOps.isNonEmptyLabel(label)) {
      val (min, max) = label
      q1.addTransition(new Transition(min, max, q2))
    }
  }

  /** Add a new transition q1 --label,vector--> q2
    */
  def addTransition(
      q1: State,
      label: TLabel,
      q2: State,
      vector: Seq[Int]
  ): Unit = {
    if (LabelOps.isNonEmptyLabel(label)) {
      val (min, max) = label
      q1.addTransition(new Transition(min, max, q2))
      etaMap += ((q1, (min, max), q2) -> vector)
    }
  }

  def outgoingTransitions(
      q: State
  ): Iterator[(State, TLabel)] =
    for (t <- q.getTransitions.iterator)
      yield (t.getDest, (t.getMin, t.getMax))
      
  def setAccept(q: State, isAccepting: Boolean): Unit =
    q.setAccept(isAccepting)

  def isAccept(q: State): Boolean = q.isAccept

  /** Returns built automaton. Can only be used once after which the automaton
    * cannot change
    */
  def getAutomaton: CostEnrichedAutomaton = {

    // baut.restoreInvariant
    // if (minimize && !CostEnrichedAutomaton.neverMinimize(baut))
    //   baut.minimize
    
    new CostEnrichedAutomaton(baut, etaMap, registers)
  }
}
