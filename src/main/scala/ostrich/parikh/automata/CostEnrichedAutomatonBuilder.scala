package ostrich.parikh.automata

import ostrich.automata._

import dk.brics.automaton.{Transition, Automaton => BAutomaton, State => BState}
import scala.collection.mutable.{HashMap => MHashMap}
import scala.collection.JavaConverters.asScalaIterator
import ap.terfor.Term
import scala.collection.mutable.ArrayBuffer
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._
import ostrich.parikh.TransitionTerm

class CostEnrichedAutomatonBuilder{
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
  // private val transTermMap: MHashMap[(State, TLabel, State), Term] =
  //   new MHashMap
  private var regsRelation: Formula = Conjunction.TRUE

  // add interger arithmatic to this aut
  def addRegsRelation(f: Formula): Unit = {
    regsRelation = conj(regsRelation, f)
  }

  // prepends a regsiter
  def prependRegister(_register: Term): ArrayBuffer[Term] =
    prependRegisters(Seq(_register))

  // prepends regsters
  def prependRegisters(_registers: Seq[Term]): ArrayBuffer[Term] =
    _registers ++=: registers
  
  def appendRegisters(_registers: Seq[Term]): ArrayBuffer[Term] =
    registers ++= _registers

  // add (transition -> vector) map to etaMap
  def addEtaMap(
      map: MHashMap[(State, TLabel, State), Seq[Int]]
  ): MHashMap[(State, TLabel, State), Seq[Int]] = {
    this.etaMap ++= map
  }

  // add (transition -> term) map to transTermMap
  // def addTermMap(
  //     map: MHashMap[(State, TLabel, State), Term]
  // ): MHashMap[(State, TLabel, State), Term] = {
  //   this.transTermMap ++= map
  // }

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
    for (t <- asScalaIterator(q.getTransitions.iterator))
      yield (t.getDest, (t.getMin, t.getMax))

  def outgoingTransitionsWithVec(
    q: State
  ): Iterator[(State, TLabel, Seq[Int])] = 
    for ((t, l) <- outgoingTransitions(q))
      yield (t, l, etaMap((q, l, t)))

  def setAccept(q: State, isAccepting: Boolean): Unit =
    q.setAccept(isAccepting)

  def isAccept(q: State): Boolean = q.isAccept

  def addEpsilon(q: State, q2: State): Unit = {
    if (isAccept(q2)) setAccept(q, true)
    for ((t, l, v) <- outgoingTransitionsWithVec(q2)){
      addTransition(q, l, t, v)
    }
  }

  /** Returns built automaton.
    */
  def getAutomaton: CostEnrichedAutomaton = {
    val res = new CostEnrichedAutomaton(baut)
    res.setRegisters(registers.toSeq)
    res.addEtaMap(etaMap.toMap)
    // res.addTransTermMap(transTermMap.toMap)
    res.setRegsRelation(regsRelation)
    res.removeDuplicatedReg()
    res
  }
}
