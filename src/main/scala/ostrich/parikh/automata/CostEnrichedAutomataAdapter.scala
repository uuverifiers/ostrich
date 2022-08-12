package ostrich.parikh.automata

import ostrich.automata.AtomicStateAutomaton
import ostrich.automata.AtomicStateAutomatonAdapter
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.{TransitionTerm, RegisterTerm}
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._
import ap.terfor.Term
import dk.brics.automaton.{State => BState}

abstract class CostEnrichedAutomatonAdapter[A <: CostEnrichedAutomatonTrait](
    val _underlying: A
) extends AtomicStateAutomatonAdapter[A](_underlying)
    with CostEnrichedAutomatonTrait {

  override type State = _underlying.State

  override type TLabel = _underlying.TLabel

  override lazy val internalise: CostEnrichedAutomaton = {
    val builder = underlying.getBuilder
    val smap = new MHashMap[underlying.State, underlying.State]

    for (s <- states)
      smap.put(s, builder.getNewState)

    for (s <- states) {
      val t = smap(s)
      for ((to, label, update) <- outgoingTransitionsWithVec(s))
        builder.addTransition(t, label, smap(to), update, TransitionTerm())
      builder.setAccept(t, isAccept(s))
    }

    builder.asInstanceOf[CostEnrichedAutomatonBuilder].addRegisters(registers)
    builder.asInstanceOf[CostEnrichedAutomatonBuilder].addIntFormula(intFormula)
    builder.setInitialState(smap(initialState))
    builder.asInstanceOf[CostEnrichedAutomatonBuilder].getAutomaton
  }
}

object CostEnrichedInitFinalAutomaton {
  def apply[A <: CostEnrichedAutomatonTrait](
      aut: A,
      initialState: A#State,
      acceptingStates: Set[A#State]
  ): CostEnrichedAutomatonTrait =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, _, _) =>
        _CostEnrichedInitFinalAutomaton(a, initialState, acceptingStates)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, initialState, acceptingStates)
    }

  def setInitial[A <: CostEnrichedAutomatonTrait](
      aut: A,
      initialState: A#State
  ) =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, oldInit, oldFinal) =>
        _CostEnrichedInitFinalAutomaton(a, initialState, oldFinal).internalise
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, initialState, aut.acceptingStates).internalise
    }

  def setFinal[A <: CostEnrichedAutomatonTrait](
      aut: A,
      acceptingStates: Set[CostEnrichedAutomatonTrait#State]
  ) =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, oldInit, oldFinal) =>
        _CostEnrichedInitFinalAutomaton(a, oldInit, acceptingStates).internalise
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, aut.initialState, acceptingStates).internalise
    }
}

case class _CostEnrichedInitFinalAutomaton[A <: CostEnrichedAutomatonTrait](
    override val _underlying: A,
    val _initialState: A#State,
    val _acceptingStates: Set[A#State]
) extends CostEnrichedAutomatonAdapter[A](_underlying) {

  lazy val parikhTheory = internalise.parikhTheory

  def getTransitionsTerms = internalise.getTransitionsTerms

  val registers = Seq.fill(underlying.registers.size)(RegisterTerm())

  override lazy val initialState = _initialState

  override lazy val states =
    computeReachableStates(_initialState, _acceptingStates)

  override lazy val acceptingStates =
    _acceptingStates & states

  override def outgoingTransitions(q: State): Iterator[(State, TLabel)] = {
    val _states = states
    for (
      p @ (s, _) <- underlying.outgoingTransitions(q);
      if _states contains s
    )
      yield p
  }

  def outgoingTransitionsWithInfo(
      q: State
  ): Iterator[(State, TLabel, Seq[Int], Term)] = {
    val _states = states
    for (
      p @ (s, _, _, _) <- underlying.outgoingTransitionsWithInfo(q);
      if _states contains s
    )
      yield p
  }

  def outgoingTransitionsWithVec(
      q: State
  ): Iterator[(State, TLabel, Seq[Int])] = {
    val _states = states
    for (
      p @ (s, _, _) <- underlying.outgoingTransitionsWithVec(q);
      if _states contains s
    )
      yield p
  }

  def outgoingTransitionsWithTerm(
      q: State
  ): Iterator[(State, TLabel, Term)] = {
    val _states = states
    for (
      p @ (s, _, _) <- underlying.outgoingTransitionsWithTerm(q);
      if _states contains s
    )
      yield p
  }

}
