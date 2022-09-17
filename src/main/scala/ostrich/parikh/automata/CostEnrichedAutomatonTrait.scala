package ostrich.parikh.automata

import ostrich.automata._
import dk.brics.automaton.{
  State => BState
}

import scala.collection.immutable.Map
import scala.collection.mutable.{HashMap => MHashMap, Stack => MStack, LinkedHashSet => MLinkedHashSet}
import ap.terfor.Term
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import scala.collection.immutable.Map
import CostEnrichedAutomaton._

object CostEnrichedAutomatonTrait {
  // getter
  def getRegisters(aut: CostEnrichedAutomatonTrait): Seq[Term] = aut.registers

  def getEtaMap(
      aut: CostEnrichedAutomatonTrait
  ): Map[(State, TLabel, State), Seq[Int]] =
    aut.etaMap

  def getTransTermMap(
      aut: CostEnrichedAutomatonTrait
  ): Map[(State, TLabel, State), Term] =
    aut.transTermMap

  def getIntFormula(aut: CostEnrichedAutomatonTrait): Formula = aut.regsRelation

  def getTransitionsTerms(aut: CostEnrichedAutomatonTrait): Seq[Term] = 
    aut.transTermMap.map(_._2).toSeq

  // setter
  def setRegisters(
      aut: CostEnrichedAutomatonTrait,
      registers: Seq[Term]
  ): Unit =
    aut.registers = registers

  def setEtaMap(
      aut: CostEnrichedAutomatonTrait,
      etaMaps: Map[
        (State, TLabel, State),
        Seq[Int]
      ]
  ): Unit =
    aut.etaMap = etaMaps

  def setTransTermMap(
      aut: CostEnrichedAutomatonTrait,
      transTermMaps: Map[
        (State, TLabel, State),
        Term
      ]
  ): Unit =
    aut.transTermMap = transTermMaps
    
  def setRegsRelation(aut: CostEnrichedAutomatonTrait, f: Formula): Unit =
    aut.regsRelation = f
}

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
  ) yield (t, lbl, etaMap((s, lbl, t)), transTermMap((s, lbl, t)))

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

}
