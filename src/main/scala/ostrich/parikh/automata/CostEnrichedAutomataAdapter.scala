package ostrich.parikh.automata

import ostrich.automata.AtomicStateAutomatonAdapter
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.{TransitionTerm, RegisterTerm}
import ostrich.automata.Automaton
import ap.terfor.Term

object CostEnrichedAutomatonAdapter {
  def intern(a: Automaton): CostEnrichedAutomaton = a match {
    case a: CostEnrichedAutomatonAdapter[_] => a.internalise
    case a: CostEnrichedAutomaton           => a
    case _ => throw new IllegalArgumentException
  }

  def underlying(a: Automaton): CostEnrichedAutomatonTrait = a match {
    case a: CostEnrichedAutomatonAdapter[_] => a.underlying
    case a: CostEnrichedAutomaton           => a
    case _ => throw new IllegalArgumentException
  }

  def init(a: CostEnrichedAutomatonAdapter[_]): Unit = {
    val underlyingRegs = underlying(a).getRegisters
    val internaliseRegs = Seq.fill(underlyingRegs.size)(RegisterTerm())
    a.setRegisters(internaliseRegs)
    a.setEtaMap(underlying(a).getEtaMap)
    a.setTransTermMap(intern(a).getTransTermMap)
  }

}

// TODO: BUG occur because this class mixs underlying and internalise!!  
// Rewrite this class to only extends CostEnrichedAutomatonTrait
// never use AtomicStateAutomatonAdapter
abstract class CostEnrichedAutomatonAdapter[A <: CostEnrichedAutomatonTrait](
    val _underlying: A
) extends AtomicStateAutomatonAdapter[A](_underlying)
    with CostEnrichedAutomatonTrait {

  import CostEnrichedAutomatonAdapter.{init}

  init(this)

  override type State = _underlying.State

  override type TLabel = _underlying.TLabel

  override lazy val internalise: CostEnrichedAutomaton = {
    val smap = new MHashMap[_underlying.State, _underlying.State]

    val builder =
      underlying.getBuilder.asInstanceOf[CostEnrichedAutomatonBuilder]

    for (s <- states)
      smap.put(s, builder.getNewState)

    for (s <- states) {
      val t = smap(s)
      for ((to, label, update) <- outgoingTransitionsWithVec(s))
        builder.addTransition(t, label, smap(to), update)
      builder.setAccept(t, isAccept(s))
    }

    builder.addNewIntFormula(this.regsRelation)
    builder.prependRegisters(this.registers)
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

  override def toString: String =
    "_CostEnrichedInitFinalAutomaton \n" + internalise.toString()

  override lazy val initialState = _initialState

  override lazy val states =
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

  override def outgoingTransitionsWithInfo(
      s: State
  ): Iterator[(State, (Char, Char), Seq[Int], Term)] =
    internalise.outgoingTransitionsWithInfo(s)

  override def outgoingTransitionsWithTerm(
      s: State
  ): Iterator[(State, (Char, Char), Term)] =
    internalise.outgoingTransitionsWithTerm(s)

}
