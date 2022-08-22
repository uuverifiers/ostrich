package ostrich.parikh.automata

import ostrich.automata._

import dk.brics.automaton.{
  Transition,
  Automaton => BAutomaton,
  State => BState
}
import scala.collection.mutable.{HashMap => MHashMap}
import scala.collection.JavaConverters.asScalaIterator
import ap.terfor.Term
import scala.collection.mutable.ArrayBuffer
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._

class CostEnrichedAutomatonBuilder
    extends AtomicStateAutomatonBuilder[
      CostEnrichedAutomaton#State,
      CostEnrichedAutomaton#TLabel
    ] {
  type State = CostEnrichedAutomaton#State
  type TLabel = CostEnrichedAutomaton#TLabel

  var minimize = false

  val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

  val baut: BAutomaton = {
    val baut = new BAutomaton
    baut.setDeterministic(false)
    baut
  }

  private val etaMap: MHashMap[(State, TLabel, State), Seq[Int]] = new MHashMap
  private val registers: ArrayBuffer[Term] = new ArrayBuffer()
  private val transTermMap: MHashMap[(State, TLabel, State), Term] = new MHashMap
  private var intFormula: Formula = Conjunction.TRUE
  
  // add interger arithmatic to this aut
  def addIntFormula(f: Formula): Unit = {
    intFormula = conj(intFormula, f)
  }

  // prepends a regsiter
  def addRegister(register: Term): ArrayBuffer[Term] = {
    register +=: registers
  }

  // prepends regsters
  def addRegisters(_registers: Seq[Term]): ArrayBuffer[Term] = {
    _registers ++=: registers
  }

  // add a (transition -> vector) map to etaMap
  def addEtaMap(map: MHashMap[(State, TLabel, State), Seq[Int]]): MHashMap[(State, TLabel, State),Seq[Int]] = {
    this.etaMap ++= map
  }

  // add a (transition -> term) map to transTermMap
  def addTransTermMap(map: MHashMap[(State,TLabel,State), Term]): MHashMap[(State, TLabel, State),Term] = {
    this.transTermMap ++= map
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

  /** Add a new transition q1 --label,vector--> q2, set its term to t
    */
  override def addTransition(
      q1: State,
      label: TLabel,
      q2: State,
      vector: Seq[Int],
      t: Term
  ): Unit = {
    if (LabelOps.isNonEmptyLabel(label)) {
      val (min, max) = label
      q1.addTransition(new Transition(min, max, q2))
      etaMap += ((q1, (min, max), q2) -> vector)
      transTermMap += ((q1, (min, max), q2) -> t)
    }
  }

  def outgoingTransitions(
      q: State
  ): Iterator[(State, TLabel)] =
    for (t <- asScalaIterator(q.getTransitions.iterator))
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
    val res = new CostEnrichedAutomaton(baut, etaMap, registers, transTermMap)
    res.addIntFormula(intFormula)
    res
  }
}
