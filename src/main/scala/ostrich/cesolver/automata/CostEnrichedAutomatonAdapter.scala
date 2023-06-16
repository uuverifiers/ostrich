package ostrich.cesolver.automata

import scala.collection.mutable.{
  HashMap => MHashMap,
  ArrayStack,
  HashSet => MHashSet,
  LinkedHashSet => MLinkedHashSet
}

import ostrich.cesolver.util.TermGenerator

abstract class CostEnrichedAutomatonAdapter[A <: CostEnrichedAutomatonBase](
    val underlying: A
) extends CostEnrichedAutomatonBase {

  val termGen = TermGenerator()

  // initialize registers
  this.registers = Seq.fill(underlying.registers.size)(termGen.registerTerm)

  def computeReachableStates(
      initState: State,
      accStates: Set[State]
  ): Iterable[State] = {
    val fwdReachable, bwdReachable = new MLinkedHashSet[State]
    fwdReachable += initState

    val worklist = new ArrayStack[State]
    worklist push initState

    while (!worklist.isEmpty)
      for ((s, _, _) <- underlying.outgoingTransitionsWithVec(worklist.pop))
        if (fwdReachable add s)
          worklist push s

    val backMapping = new MHashMap[State, MHashSet[State]]

    for (s <- fwdReachable)
      for ((t, _, _) <- underlying.outgoingTransitionsWithVec(s))
        backMapping.getOrElseUpdate(t, new MHashSet) += s

    for (_s <- accStates; s = _s.asInstanceOf[State])
      if (fwdReachable contains s) {
        bwdReachable += s
        worklist push s
      }

    while (!worklist.isEmpty)
      for (list <- backMapping get worklist.pop; s <- list)
        if (bwdReachable add s)
          worklist push s

    if (bwdReachable.isEmpty)
      bwdReachable add initState

    bwdReachable
  }

  lazy val internalise: CostEnrichedAutomaton = {
    val smap = new MHashMap[underlying.State, underlying.State]
    val ceAut = new CostEnrichedAutomaton

    for (s <- states)
      smap.put(s, ceAut.newState())

    for (from <- states) {
      for ((to, label, update) <- outgoingTransitionsWithVec(from))
        ceAut.addTransition(smap(from), label, smap(to), update)
      ceAut.setAccept(smap(from), isAccept(from))
    }

    ceAut.registers = _registers
    ceAut.regsRelation = _regsRelation
    ceAut.initialState = smap(initialState)
    ceAut
  }

}

object CostEnrichedInitFinalAutomaton {
  def apply[A <: CostEnrichedAutomatonBase](
      aut: A,
      initialState: A#State,
      acceptingStates: Set[A#State]
  ): CostEnrichedAutomatonBase =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, _, _) =>
        _CostEnrichedInitFinalAutomaton(a, initialState, acceptingStates)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, initialState, acceptingStates)
    }

  def setInitial[A <: CostEnrichedAutomatonBase](
      aut: A,
      initialState: A#State
  ): _CostEnrichedInitFinalAutomaton[_ >: A <: CostEnrichedAutomatonBase] =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, _, oldFinal) =>
        _CostEnrichedInitFinalAutomaton(a, initialState, oldFinal)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, initialState, aut.acceptingStates)
    }

  def setFinal[A <: CostEnrichedAutomatonBase](
      aut: A,
      acceptingStates: Set[CostEnrichedAutomatonBase#State]
  ): _CostEnrichedInitFinalAutomaton[_ >: A <: CostEnrichedAutomatonBase] =
    aut match {
      case _CostEnrichedInitFinalAutomaton(a, oldInit, _) =>
        _CostEnrichedInitFinalAutomaton(a, oldInit, acceptingStates)
      case _ =>
        _CostEnrichedInitFinalAutomaton(aut, aut.initialState, acceptingStates)
    }
}

case class _CostEnrichedInitFinalAutomaton[A <: CostEnrichedAutomatonBase](
    override val underlying: A,
    val startState: A#State,
    val _acceptingStates: Set[A#State]
) extends CostEnrichedAutomatonAdapter[A](underlying) {

  initialState = startState

  override lazy val states =
    computeReachableStates(_initialState, _acceptingStates)


  override lazy val acceptingStates: Set[State] =
    _acceptingStates & states.toSet

  override def isAccept(s: State): Boolean = acceptingStates.contains(s)

  override def outgoingTransitionsWithVec(q: State) = {
    for (
      p @ (s, _, _) <- underlying.outgoingTransitionsWithVec(q);
      if states.toSet.contains(s)
    )
      yield p
  }

  override def incomingTransitionsWithVec(
      t: State
  ) = {
    for (
      p @ (s, _, _) <- underlying.incomingTransitionsWithVec(t);
      if states.toSet.contains(s)
    )
      yield p
  }
}
