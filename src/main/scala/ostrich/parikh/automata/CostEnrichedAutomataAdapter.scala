package ostrich.parikh.automata

import ostrich.automata.AtomicStateAutomatonAdapter
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.{TransitionTerm, RegisterTerm}
import ap.terfor.Term
import ostrich.automata.Automaton

object CostEnrichedAutomatonAdapter {
  def intern(a: Automaton): CostEnrichedAutomaton = a match {
    case a: CostEnrichedAutomatonAdapter[_] => a.internalise
    case a: CostEnrichedAutomaton           => a
    case _ => throw new IllegalArgumentException
  }
}

abstract class CostEnrichedAutomatonAdapter[A <: CostEnrichedAutomatonTrait](
    val _underlying: A
) extends AtomicStateAutomatonAdapter[A](_underlying)
    with CostEnrichedAutomatonTrait {

  val registers: Seq[Term] = Seq.fill(underlying.registers.size)(RegisterTerm())

  val smap = new MHashMap[underlying.State, underlying.State]

  override type State = _underlying.State

  override type TLabel = _underlying.TLabel

  override lazy val internalise: CostEnrichedAutomaton = {
    val builder =
      underlying.getBuilder.asInstanceOf[CostEnrichedAutomatonBuilder]

    for (s <- states)
      smap.put(s, builder.getNewState)

    for (s <- states) {
      val t = smap(s)
      for ((to, label, update) <- outgoingTransitionsWithVec(s))
        builder.addTransition(t, label, smap(to), update, TransitionTerm())
      builder.setAccept(t, isAccept(s))
    }

    builder.addIntFormula(this.intFormula)
    builder.addRegisters(this.registers)
    builder.setInitialState(smap(initialState))
    builder.getAutomaton
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
  ): _CostEnrichedInitFinalAutomaton[_ >: A <: CostEnrichedAutomatonTrait] =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, _, oldFinal) =>
        _CostEnrichedInitFinalAutomaton(a, initialState, oldFinal)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, initialState, aut.acceptingStates)
    }

  def setFinal[A <: CostEnrichedAutomatonTrait](
      aut: A,
      acceptingStates: Set[CostEnrichedAutomatonTrait#State]
  ): _CostEnrichedInitFinalAutomaton[_ >: A <: CostEnrichedAutomatonTrait] =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, oldInit, _) =>
        _CostEnrichedInitFinalAutomaton(a, oldInit, acceptingStates)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, aut.initialState, acceptingStates)
    }
}

case class _CostEnrichedInitFinalAutomaton[A <: CostEnrichedAutomatonTrait](
    override val _underlying: A,
    val _initialState: A#State,
    val _acceptingStates: Set[A#State]
) extends CostEnrichedAutomatonAdapter[A](_underlying) {

  override def toString: String = internalise.toString()

  def transitionsWithTerm = internalise.transitionsWithTerm
  def transitionsWithVec = internalise.transitionsWithVec
  lazy val registersAbstraction = internalise.registersAbstraction

  def getTransitionsTerms = internalise.getTransitionsTerms

  override lazy val initialState = _initialState

  override lazy val states: scala.collection.Set[underlying.State] =
    computeReachableStates(_initialState, _acceptingStates)

  override lazy val acceptingStates: Set[State] =
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
  ): Iterator[(State, TLabel, Term)] =
    // The transtion terms are unique for each CostEnrichedAutomatonAdapter
    // We can not use `underlying.outgoingTransitionsWithTerm(q)` directly
    internalise.outgoingTransitionsWithTerm(smap.getOrElse(q, q))

}
