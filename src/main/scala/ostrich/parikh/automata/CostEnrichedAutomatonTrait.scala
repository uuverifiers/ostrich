package ostrich.parikh.automata

import ostrich.automata._
import dk.brics.automaton.{State => BState, Automaton => BAutomaton}

import scala.collection.immutable.Map
import scala.collection.mutable.{
  HashMap => MHashMap,
  Stack => MStack,
  LinkedHashSet => MLinkedHashSet
}
import ap.terfor.Term
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import scala.collection.immutable.Map
import scala.collection.mutable.ArrayStack

trait CostEnrichedAutomatonTrait extends AtomicStateAutomaton {
  type State = BState

  type TLabel = (Char, Char)

  /** The relations of different registers
    */
  protected var regsRelation: Formula = Conjunction.TRUE

  /** Map from transition to its cost.
    */
  protected var etaMap: Map[(State, TLabel, State), Seq[Int]] = Map()

  /** Map from transition to its term.
    */
  protected var transTermMap: Map[(State, TLabel, State), Term] = Map()

  /** Registers storing count value for accepting state.
    */
  protected var registers: Seq[Term] = Seq()

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

  val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

  val labelEnumerator: TLabelEnumerator[TLabel] =
    new BricsTLabelEnumerator(for ((_, lbl, _) <- transitions) yield lbl)

  def &(that: Automaton): Automaton = this & that

  def &(aut2: CostEnrichedAutomatonTrait): CostEnrichedAutomaton = {
    val aut1 = this
    val autBuilder = new CostEnrichedAutomatonBuilder

    // begin intersection
    val initialState1 = aut1.initialState
    val initialState2 = aut2.initialState
    val initialState = autBuilder.getNewState
    autBuilder.setInitialState(initialState)
    autBuilder.setAccept(
      initialState,
      aut1.isAccept(initialState1) && aut2.isAccept(initialState2)
    )

    // from old states pair to new state
    val pair2state = new MHashMap[(State, State), State]
    val worklist = new ArrayStack[(State, State)]

    pair2state.put((initialState1, initialState2), initialState)
    worklist.push((initialState1, initialState2))

    while (!worklist.isEmpty) {
      val (from1, from2) = worklist.pop()
      val from = pair2state(from1, from2)
      for (
        (to1, label1, vec1, term1) <- aut1.outgoingTransitionsWithInfo(from1);
        (to2, label2, vec2, term2) <- aut2.outgoingTransitionsWithInfo(from2)
      ) {
        // intersect transition
        LabelOps.intersectLabels(label1, label2) match {
          case Some(label) => {
            val to = pair2state.getOrElseUpdate(
              (to1, to2), {
                val newState = autBuilder.getNewState
                worklist.push((to1, to2))
                newState
              }
            )
            val vector = vec1 ++ vec2
            autBuilder.addTransition(
              from,
              label,
              to,
              vector
            )
            autBuilder.setAccept(
              to,
              aut1.isAccept(to1) && aut2.isAccept(to2)
            )
          }
          case _ => // do nothing
        }
      }
    }
    autBuilder.addRegsRelation(aut1.regsRelation)
    autBuilder.addRegsRelation(aut2.regsRelation)
    autBuilder.prependRegisters(aut1.registers ++ aut2.registers)
    val res = autBuilder.getAutomaton
    res
  }

  def getBuilder: AtomicStateAutomatonBuilder[State, TLabel] = {
    new CostEnrichedAutomatonBuilder
  }


  /** Given a state, iterate over all outgoing transitons with vector
    */
  def outgoingTransitionsWithVec(
      s: State
  ): Iterator[(State, TLabel, Seq[Int])] = for (
    (t, lbl) <- outgoingTransitions(s)
  ) yield (t, lbl, etaMap((s, lbl, t)))

  /** Given a state, iterate over all outgoing transitons with their terms, try
    * to be deterministic
    */
  def outgoingTransitionsWithTerm(
      s: State
  ): Iterator[(State, TLabel, Term)] = for ((t, lbl) <- outgoingTransitions(s))
    yield (t, lbl, transTermMap((s, lbl, t)))

  /** Given a state, iterate over all outgoing transitons with vector and term
    */
  def outgoingTransitionsWithInfo(
      s: State
  ): Iterator[(State, TLabel, Seq[Int], Term)] = for (
    (t, lbl) <- outgoingTransitions(s)
  ) yield {
  (t, lbl, etaMap((s, lbl, t)), transTermMap((s, lbl, t)))
  }

  /** Unique lengths of accepted words
    */
  lazy val uniqueAcceptedWordLengths: Option[Seq[Int]] = {
    val lengths = for (s <- acceptingStates) yield (uniqueLengthStates get s)
    if (lengths.size > 0 && !(lengths contains None))
      Some(lengths.filter(_ != None).map(_.get).toSeq)
    else
      None
  }

  /** Transitions with their terms
    */
  def transitionsWithTerm: Iterator[(State, TLabel, State, Term)] =
    transitions.map { case (s, lbl, t) =>
      (s, lbl, t, transTermMap((s, lbl, t)))
    }

  /** Transitions with their costs
    */
  def transitionsWithVec: Iterator[(State, TLabel, State, Seq[Int])] =
    transitions.map { case (s, lbl, t) =>
      (s, lbl, t, etaMap((s, lbl, t)))
    }

  def getRegsRelation = regsRelation

  def getRegisters = registers

  def getEtaMap = etaMap

  def getTransTermMap = transTermMap

  def getTransitionsTerms = transTermMap.map(_._2).toSeq

  def setRegisters(_registers: Seq[Term]) = registers = _registers

  def setEtaMap(_etaMap: Map[(State, TLabel, State), Seq[Int]]) =
    etaMap = _etaMap

  def setTransTermMap(_transTermMap: Map[(State, TLabel, State), Term]) =
    transTermMap = _transTermMap

  def setRegsRelation(f: Formula) = regsRelation = f

  /** @deprecated
    *   not implemented
    */
  def |(that: Automaton): Automaton =
    new CostEnrichedAutomaton(new BAutomaton)
  def unary_! : Automaton =
    new CostEnrichedAutomaton(new BAutomaton)
  def getTransducerBuilder: TransducerBuilder[State, TLabel] =
    BricsTransducer.getBuilder

}
