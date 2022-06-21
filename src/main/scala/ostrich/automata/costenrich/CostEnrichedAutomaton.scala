package ostrich.automata.costenrich

import ostrich.automata._

import scala.collection.JavaConversions.{
  asScalaIterator,
  iterableAsScalaIterable
}

import dk.brics.automaton.{
  BasicAutomata,
  BasicOperations,
  RegExp,
  Transition,
  Automaton => BAutomaton,
  State => BState
}
import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  LinkedHashSet => MLinkedHashSet,
  Stack => MStack,
  TreeSet => MTreeSet,
  MultiMap => MMultiMap,
  Set => MSet
}

import ap.terfor.Term
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import scala.collection.immutable.{HashMap, Map}
import scala.collection.mutable.ArrayBuffer
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.TermOrder
import scala.annotation.implicitNotFound
import java.text.Normalizer.Form
import ap.terfor.ConstantTerm
import ap.terfor.OneTerm

object CostEnrichedAutomaton {

  type State = CostEnrichedAutomaton#State
  type TLabel = CostEnrichedAutomaton#TLabel

  def apply(): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(new BAutomaton, new MHashMap, Seq())

  /** Build CostEnriched automaton from a regular expression in brics format
    */
  def apply(pattern: String): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(
      new RegExp(pattern).toAutomaton(false),
      new MHashMap,
      Seq()
    )

  /** Derive parikh image of the automaton
    */
  def parikhTheory(aut: Automaton): Formula = aut match {
    case that: CostEnrichedAutomaton =>
      that.parikhTheory
    case that: AtomicStateAutomatonAdapter[_] =>
      parikhTheory(that.internalise)
  }

  /** Return the underlying brics automata of the given aut.
    */
  def getBAutomaton(aut: Automaton): BAutomaton = aut match {
    case that: CostEnrichedAutomaton =>
      that.underlying
    case that: AtomicStateAutomatonAdapter[_] =>
      getBAutomaton(that.internalise)
    case _ =>
      throw new IllegalArgumentException
  }

  /** Return the etaMap of the given aut. */
  def getMap(
      aut: Automaton
  ): MHashMap[(State, TLabel, State), Seq[Int]] = aut match {
    case that: CostEnrichedAutomaton =>
      that.etaMap
    case that: AtomicStateAutomatonAdapter[_] =>
      getMap(that.internalise)
    case _ =>
      throw new IllegalArgumentException
  }

  /** Return the registers of the given aut. */
  def getRegisters(aut: Automaton): Seq[Term] = aut match {
    case that: CostEnrichedAutomaton =>
      that.registers
    case that: AtomicStateAutomatonAdapter[_] =>
      getRegisters(that.internalise)
    case _ =>
      throw new IllegalArgumentException
  }

  /** Check whether we should avoid ever minimising the given automaton.
    */
  def neverMinimize(aut: BAutomaton): Boolean =
    aut.getSingleton != null || aut.getNumberOfStates > MINIMIZE_LIMIT

  /** Return new automaton builder of compatible type
    */
  def getBuilder: CostEnrichedAutomatonBuilder = {
    new CostEnrichedAutomatonBuilder
  }

  private val MINIMIZE_LIMIT = 100000
}

/** Wrapper for the BRICS automaton class. New features added:
  *   - registers: a sequence of registers that store integer values
  *   - etaMap: a map from transitions to update functions of registers
  */
class CostEnrichedAutomaton(
    val underlying: BAutomaton,
    val etaMap: MHashMap[
      (
          CostEnrichedAutomaton#State,
          CostEnrichedAutomaton#TLabel,
          CostEnrichedAutomaton#State
      ),
      Seq[Int]
    ],
    val registers: Seq[Term]
) extends AtomicStateAutomaton {

  import CostEnrichedAutomaton._

  type State = BState

  type TLabel = (Char, Char)

  var minimised = false

  // init and check etaMap
  transitions.foreach { transition =>
    if (!etaMap.contains(transition)) {
      etaMap.put(transition, Seq.fill(registers.size)(0))
    } else {
      assert(etaMap(transition).size == registers.size)
    }
  }

  /** Transtion -> ap.terfor.Term, used by parikhTheory generator
    */
  val transTermMap: Map[(State, TLabel, State), Term] =
    transitions.map(t => (t, TranstionTerm())).toMap

  /** Union. @deprecated not implemented
    */
  def |(that: Automaton): Automaton =
    new CostEnrichedAutomaton(new BAutomaton, new MHashMap, Seq())

  /** Intersection
    */
  def &(that: Automaton): Automaton = {
    val thatAut = getBAutomaton(that);
    val thatEtaMap = getMap(that);
    val thatRegisters = getRegisters(that);
    val interAut = BasicOperations.intersection(underlying, thatAut);
    val transitions: Iterable[(State, TLabel, State)] =
      interAut
        .getStates
        .map(s =>
          s.getTransitions
            .map(t => (s, (t.getMin, t.getMax), t.getDest))
        )
        .flatten

    // interEtaMap = (t => this.etaMap(t) ++ that.etaMap(t))
    val interEtaMap: MHashMap[(State, TLabel, State), Seq[Int]] = new MHashMap
    transitions.foreach{ t =>
      val thisVec = etaMap(t)
      val thatVec = thatEtaMap(t)
      interEtaMap.put(t, thisVec ++ thatVec)
    }

    val interRegisters = registers ++ thatRegisters
    new CostEnrichedAutomaton(
      BasicOperations.intersection(underlying, thatAut),
      interEtaMap,
      interRegisters
    );
  }

  /** Complementation. @deprecated not implemented
    */
  def unary_! : Automaton =
    new CostEnrichedAutomaton(new BAutomaton, new MHashMap, Seq())

  /** Check whether this automaton accepts any word.
    */
  def isEmpty: Boolean = underlying.isEmpty

  /** Check whether the automaton accepts a given word.
    */
  def apply(word: Seq[Int]): Boolean =
    BasicOperations.run(
      this.underlying,
      SeqCharSequence(for (c <- word.toIndexedSeq) yield c.toChar).toString
    )

  /** Get any word accepted by this automaton, or <code>None</code> if the
    * language is empty
    */
  def getAcceptedWord: Option[Seq[Int]] =
    (this.underlying getShortestExample true) match {
      case null => None
      case str  => Some(for (c <- str) yield c.toInt)
    }

  /** Operations on labels
    */
  override val LabelOps: TLabelOps[TLabel] = BricsTLabelOps
  /** The unique initial state
   */
  lazy val initialState: State = underlying.getInitialState

  /** The set of accepting states
   */
  val acceptingStates: Set[State] =
    (for (s <- states; if s.isAccept) yield s).toSet
  /** Iterate over automaton states
    */
  def states: Iterable[State] = {
    // do this the hard way to give a deterministic ordering
    val worklist = new MStack[State]
    val seenstates = new MLinkedHashSet[State]

    worklist.push(initialState)
    seenstates.add(initialState)

    while (!worklist.isEmpty) {
      val s = worklist.pop

      for ((to, _) <- outgoingTransitions(s)) {
        if (!seenstates.contains(to)) {
          worklist.push(to)
          seenstates += to
        }
      }
    }

    seenstates
  }

  /** To enumerate the labels used
    */
  val labelEnumerator: TLabelEnumerator[TLabel] =
    new BricsTLabelEnumerator(for ((_, lbl, _) <- transitions) yield lbl)

  /** Given a state, iterate over all outgoing transitions, try to be
    * deterministic
    */
  def outgoingTransitions(from: State): Iterator[(State, TLabel)] = {
    for (t <- from.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax)
      )
  }

  /** Given a state, iterate over all outgoing transitons and their update
    * functions, try to be deterministic
    */
  def outgoingTransitionsWithVector(
      q: State
  ): Iterator[(State, TLabel, Seq[Int])] =
    for (t <- q.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax),
        etaMap((q, (t.getMin, t.getMax), t.getDest))
      )

  lazy val transitionsWithVector: Iterator[(State, TLabel, State, Seq[Int])] =
    for (
      s <- states.iterator;
      (to, label, vec) <- outgoingTransitionsWithVector(s)
    )
      yield (
        (
          s,
          label,
          to,
          vec
        )
      )

  /** Map state to its incoming transitions
    */
  lazy val incomingTransitions: Map[State, Set[(State, TLabel)]] = {
    val map = new MHashMap[State, Set[(State, TLabel)]]
    val worklist = new MStack[State]
    val seenstates = new MLinkedHashSet[State]

    map.put(initialState, Set.empty)

    worklist.push(initialState)
    seenstates.add(initialState)

    while (!worklist.isEmpty) {
      val s = worklist.pop
      outgoingTransitions(s).foreach { case (to, lbl) =>
        val set = map.getOrElseUpdate(to, Set.empty)
        map.put(to, set + ((s, lbl)))
        if (!seenstates.contains(to)) {
          worklist.push(to)
          seenstates.add(to)
        }
      }
    }
    map.toMap
  }

  /** Test if state is accepting
    */
  def isAccept(s: State): Boolean = s.isAccept

  /** Return new automaton builder of compatible type
    */
  def getBuilder: AtomicStateAutomatonBuilder[State, TLabel] = {
    new CostEnrichedAutomatonBuilder
  }

  /** Return new automaton builder of compatible type. TODO: change to
    * CostEnrichedTransducer
    */
  def getTransducerBuilder: TransducerBuilder[State, TLabel] =
    BricsTransducer.getBuilder

  /** String representation of automaton in full gory detail
    */
  def toDetailedString: String = underlying.toString()

  /** Parikh image of this automaton
    */
  lazy val parikhTheory = {

    import ap.terfor.TerForConvenience._
    implicit def termSeq2ConstantTermSeq(t: Seq[Term]): Seq[ConstantTerm] =
      t.map(_.asInstanceOf[ConstantTerm])

    implicit var order = TermOrder.EMPTY

    def outFlowTerms(from: State): Seq[Term] = {
      val outFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      outgoingTransitionsWithVector(from).foreach { case (to, lbl, vec) =>
        outFlowTerms += transTermMap(from, lbl, to)
      }
      outFlowTerms
    }

    def inFlowTerms(to: State): Seq[Term] = {
      val inFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      incomingTransitions(to).foreach { case (from, lbl) =>
        inFlowTerms += transTermMap(from, lbl, to)
      }
      inFlowTerms
    }

    // consistent flow
    var consistentFlowFormula = Conjunction.TRUE

    states.foreach { s =>
      val outFlowTerms_ = outFlowTerms(s)
      // outFlow(finalState) = 1
      val outFlow: LinearCombination =
        if (s.isAccept()) 1 else outFlowTerms_.reduceLeft(_ + _)
      val inFlowTerms_ = inFlowTerms(s)
      // inFlow(initialState) = 1
      val inFlow: LinearCombination =
        if (s == initialState) 1 else inFlowTerms_.reduceLeft(_ + _)
      order = order.extend(outFlowTerms_ ++ inFlowTerms_)

      consistentFlowFormula = conj(Seq(consistentFlowFormula, outFlow === inFlow))(order)
    }

    // update for registers
    val registerUpdateMap: Map[Term, ArrayBuffer[LinearCombination]] = {
      val registerUpdateMap = new MHashMap[Term, ArrayBuffer[LinearCombination]]
      transitionsWithVector.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transTermMap(from, lbl, to)
        vec.foreach(i => {
          val registerTerm = registers(i)
          val update =
            registerUpdateMap.getOrElseUpdate(registerTerm, new ArrayBuffer)
          update.append(trasitionTerm * i)
        })
      }
      registerUpdateMap.toMap
    }

    // formula for registers update
    var registerUpdateFormula = Conjunction.TRUE
    registerUpdateMap.foreach { case (registerTerm, update) =>
      val updateSum = update.reduceLeft(_ + _)
      registerUpdateFormula =
        registerUpdateFormula & (registerTerm === updateSum)
    }

    consistentFlowFormula & registerUpdateFormula
  }
}
