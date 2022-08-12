package ostrich.parikh.automata

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
import scala.collection.mutable.ArrayStack
import ap.SimpleAPI
import ostrich.parikh._
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._

object CostEnrichedAutomaton {

  type State = CostEnrichedAutomaton#State
  type TLabel = CostEnrichedAutomaton#TLabel

  def apply(): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(new BAutomaton)

  /** Build CostEnriched automaton from a regular expression in brics format
    */
  def apply(pattern: String): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(new RegExp(pattern).toAutomaton(false))

  def fromString(str: String): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(BasicAutomata makeString str)

  def makeAnyString(): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(BAutomaton.makeAnyString)

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
  def getCEAutomaton(aut: Automaton): CostEnrichedAutomaton = aut match {
    case that: CostEnrichedAutomaton =>
      that
    case that: CostEnrichedAutomatonAdapter[_] =>
      getCEAutomaton(that.internalise)
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

import CostEnrichedAutomaton._

trait CostEnrichedAutomatonTrait extends AtomicStateAutomaton {

  type State = BState

  type TLabel = (Char, Char)

  val registers: Seq[Term]

  var intFormula: Formula = Conjunction.TRUE

  def addIntFormula(f: Formula) = {
    intFormula = conj(intFormula, f)
  }

  /** Given a state, iterate over all outgoing transitons with vector
    */
  def outgoingTransitionsWithVec(q: State): Iterator[(State, TLabel, Seq[Int])]

  /** Given a state, iterate over all outgoing transitons with their terms, try
    * to be deterministic
    */
  def outgoingTransitionsWithTerm(q: State): Iterator[(State, TLabel, Term)]

  /** Given a state, iterate over all outgoing transitons with vector and term
    */
  def outgoingTransitionsWithInfo(
      q: State
  ): Iterator[(State, TLabel, Seq[Int], Term)]

  lazy val uniqueAcceptedWordLengths: Option[Seq[Int]] = {
    val lengths = for (s <- acceptingStates) yield (uniqueLengthStates get s)
    if (lengths.size > 0 && !(lengths contains None))
      Some(lengths.filter(_ != None).map(_.get).toSeq)
    else
      None
  }

  val parikhTheory: Formula 

  def getTransitionsTerms: Seq[Term]
}

/** Wrapper for the BRICS automaton class. New features added:
  *   - registers: a sequence of registers that store integer values
  *   - etaMap: a map from transitions to update functions of registers
  */
class CostEnrichedAutomaton(
    val underlying: BAutomaton,
    val etaMap: MHashMap[(State, TLabel, State), Seq[Int]],
    val registers: Seq[Term],
    val transTermMap: MHashMap[(State, TLabel, State), Term]
) extends CostEnrichedAutomatonTrait {

  var minimised = false

  /** constructor */
  def this(underlying: BAutomaton) =
    this(underlying, new MHashMap, Seq(), new MHashMap)

  def this(
      underlying: BAutomaton,
      etaMap: MHashMap[(State, TLabel, State), Seq[Int]],
      registers: Seq[Term]
  ) =
    this(underlying, etaMap, registers, new MHashMap)

  // Traverse etaMap and transTermMap and init all undefined keys
  transitions.foreach { transition =>
    if (!etaMap.contains(transition)) {
      etaMap.put(transition, Seq.fill(registers.size)(0))
    } else {
      assert(etaMap(transition).size == registers.size)
    }
    if (!transTermMap.contains(transition)) {
      transTermMap.put(transition, TransitionTerm())
    }
  }

  /** @deprecated
    *   not implemented
    */
  def |(that: Automaton): Automaton =
    new CostEnrichedAutomaton(new BAutomaton)

  def &(that: Automaton): Automaton = {
    // TODO：intersection of automata

    val aut1 = this
    val aut2 = getCEAutomaton(that)
    val autBuilder = new CostEnrichedAutomatonBuilder

    val oldTerm2NewTerms = new MHashMap[Term, MHashSet[Term]]

    // begin intersection
    val initialState1 = aut1.initialState
    val initialState2 = aut2.initialState
    val initialState = autBuilder.getNewState
    autBuilder.setInitialState(initialState)
    autBuilder.setAccept(
      initialState,
      aut1.isAccept(initialState1) && aut2.isAccept(initialState2)
    )

    val newStateMap = new MHashMap[(State, State), State]
    var worklist = new ArrayStack[(State, State)]

    newStateMap.put((initialState1, initialState2), initialState)
    worklist.push((initialState1, initialState2))

    while (!worklist.isEmpty) {
      val (state1, state2) = worklist.pop()
      val state = newStateMap(state1, state2)
      for (
        (t1, label1, vec1, term1) <- aut1.outgoingTransitionsWithInfo(state1);
        (t2, label2, vec2, term2) <- aut2.outgoingTransitionsWithInfo(state2)
      ) {
        LabelOps.intersectLabels(label1, label2) match {
          case Some(label) => {
            if (newStateMap.contains((t1, t2))) {
              val newState = newStateMap((t1, t2))
              val newVector = vec1 ++ vec2
              val newTerm = TransitionTerm()
              autBuilder.addTransition(
                state,
                label,
                newState,
                newVector,
                newTerm
              )
              oldTerm2NewTerms.getOrElseUpdate(term1, MHashSet()) += newTerm
              oldTerm2NewTerms.getOrElseUpdate(term2, MHashSet()) += newTerm
              autBuilder.setAccept(
                newState,
                aut1.isAccept(t1) && aut2.isAccept(t2)
              )
            } else {
              val newState = autBuilder.getNewState
              newStateMap.put((t1, t2), newState)
              worklist.push((t1, t2))
              val newVector = vec1 ++ vec2
              val newTerm = TransitionTerm()
              autBuilder.addTransition(
                state,
                label,
                newState,
                newVector,
                newTerm
              )
              oldTerm2NewTerms.getOrElseUpdate(term1, MHashSet()) += newTerm
              oldTerm2NewTerms.getOrElseUpdate(term2, MHashSet()) += newTerm
              autBuilder.setAccept(
                newState,
                aut1.isAccept(t1) && aut2.isAccept(t2)
              )
            }
          }
          case _ => // do nothing
        }
      }
    }
    oldTerm2NewTerms.foreach { case (oldTerm, newTerms) =>
      autBuilder.addIntFormula(oldTerm === newTerms.reduce(_ + _))
    }
    autBuilder.addIntFormula(aut1.intFormula)
    autBuilder.addIntFormula(aut2.intFormula)
    autBuilder.addRegisters(aut1.registers ++ aut2.registers)
    autBuilder.getAutomaton
  }

  /** @deprecated
    *   not implemented
    */
  def unary_! : Automaton =
    new CostEnrichedAutomaton(new BAutomaton)

  def isEmpty: Boolean = underlying.isEmpty

  def apply(word: Seq[Int]): Boolean =
    BasicOperations.run(
      this.underlying,
      SeqCharSequence(for (c <- word.toIndexedSeq) yield c.toChar).toString
    )

  def getAcceptedWord: Option[Seq[Int]] =
    (this.underlying getShortestExample true) match {
      case null => None
      case str  => Some(for (c <- str) yield c.toInt)
    }

  override val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

  lazy val initialState: State = underlying.getInitialState

  val acceptingStates: Set[State] =
    (for (s <- states; if s.isAccept) yield s).toSet

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

  val labelEnumerator: TLabelEnumerator[TLabel] =
    new BricsTLabelEnumerator(for ((_, lbl, _) <- transitions) yield lbl)

  def outgoingTransitions(from: State): Iterator[(State, TLabel)] = {
    for (t <- from.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax)
      )
  }

  def outgoingTransitionsWithTerm(q: State): Iterator[(State, TLabel, Term)] = {
    for (t <- q.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax),
        transTermMap((q, (t.getMin, t.getMax), t.getDest))
      )
  }

  def outgoingTransitionsWithVec(
      q: State
  ): Iterator[(State, TLabel, Seq[Int])] = {
    for (t <- q.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax),
        etaMap((q, (t.getMin, t.getMax), t.getDest))
      )
  }

  def outgoingTransitionsWithInfo(
      q: State
  ): Iterator[(State, (Char, Char), Seq[Int], Term)] = {
    for (t <- q.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax),
        etaMap((q, (t.getMin, t.getMax), t.getDest)),
        transTermMap((q, (t.getMin, t.getMax), t.getDest))
      )
  }

  lazy val transitionsWithVector: Iterator[(State, TLabel, State, Seq[Int])] =
    for (
      s <- states.iterator;
      (to, label, vec) <- outgoingTransitionsWithVec(s)
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

  def isAccept(s: State): Boolean = s.isAccept

  def getBuilder: AtomicStateAutomatonBuilder[State, TLabel] = {
    new CostEnrichedAutomatonBuilder
  }

  def getTransducerBuilder: TransducerBuilder[State, TLabel] =
    BricsTransducer.getBuilder

  def toDetailedString: String = underlying.toString()

  /** Get terms representing the transtions
    */
  def getTransitionsTerms: Seq[Term] = {
    val terms = new ArrayBuffer[Term]
    transTermMap.foreach({ case (transition, term) =>
      terms += term
    })
    terms
  }

  /** Parikh image of this automaton
    */
  lazy val parikhTheory: Formula = {

    // BUG: when accepting states are more than one, the formula is not correct
    import ap.terfor.TerForConvenience._
    import TermGeneratorOrder._
    import ostrich.parikh.CostEnrichedConvenience._

    def outFlowTerms(from: State): Seq[Term] = {
      val outFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      outgoingTransitions(from).foreach { case (to, lbl) =>
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

    // consistent flow ///////////////////////////////////////////////////////////////
    var consistentFlowFormula = Conjunction.TRUE

    states.foreach { s =>
      val outFlowTerms_ = outFlowTerms(s)
      val outFlow: LinearCombination =
        if (s.isAccept()) outFlowTerms_.reduceLeftOption(_ + _).getOrElse(l(0)) + 1
        else outFlowTerms_.reduceLeftOption(_ + _).getOrElse(l(0))
      val inFlowTerms_ = inFlowTerms(s)
      val inFlow: LinearCombination =
        if (s == initialState) inFlowTerms_.reduceLeftOption(_ + _).getOrElse(l(0)) + 1
        else inFlowTerms_.reduceLeftOption(_ + _).getOrElse(l(0))

      consistentFlowFormula = conj(consistentFlowFormula, outFlow === inFlow)
    }

    // every transtion term should greater than 0
    getTransitionsTerms.foreach { term =>
      consistentFlowFormula = conj(consistentFlowFormula, term >= 0)
    }

    /////////////////////////////////////////////////////////////////////////////////

    // registers update formula ////////////////////////////////////////////////////
    // registers update map
    val registerUpdateMap: Map[Term, ArrayBuffer[LinearCombination]] = {
      val registerUpdateMap = new MHashMap[Term, ArrayBuffer[LinearCombination]]
      transitionsWithVector.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transTermMap(from, lbl, to)
        vec.zipWithIndex.foreach {
          case (veci, i) => {
            val registerTerm = registers(i)
            val update =
              registerUpdateMap.getOrElseUpdate(
                registerTerm,
                new ArrayBuffer[LinearCombination]
              )
            update.append(trasitionTerm * veci)
          }
        }
      }
      registerUpdateMap.toMap
    }

    var registerUpdateFormula = Conjunction.TRUE
    registerUpdateMap.foreach { case (registerTerm, update) =>
      val updateSum = update.clone.reduceLeft(_ + _)
      registerUpdateFormula =
        conj(registerUpdateFormula, (registerTerm === updateSum))
    }
    /////////////////////////////////////////////////////////////////////////////////

    conj(registerUpdateFormula, consistentFlowFormula)
  }

  override lazy val getLengthAbstraction: Formula = Conjunction.TRUE

  override def toString : String = "CostEnrichedAutomaton@" + underlying.toString
  
}
