package ostrich.parikh.automata

import ostrich.automata.AtomicStateAutomatonAdapter
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.{TransitionTerm, RegisterTerm}
import ostrich.automata.Automaton
import ap.terfor.Term
import scala.collection.mutable.{
  HashMap => MHashMap,
  ArrayStack,
  HashSet => MHashSet,
  MultiMap,
  LinkedHashSet => MLinkedHashSet,
  Set => MSet
}
import ostrich.parikh.OstrichConfig

// TODO: BUG occur because this class mixs underlying and internalise!!
// Rewrite this class to only extends CostEnrichedAutomatonTrait
// never use AtomicStateAutomatonAdapter
abstract class CostEnrichedAutomatonAdapter[A <: CostEnrichedAutomatonTrait](
    val underlying: A
) extends CostEnrichedAutomatonTrait {

  registers = Seq.fill(underlying.getRegisters.size)(RegisterTerm())

  etaMap = underlying.getEtaMap

  def computeReachableStates(
      initState: State,
      accStates: Set[State]
  ): Set[State] = {
    val fwdReachable, bwdReachable = new MLinkedHashSet[State]
    fwdReachable += initState

    val worklist = new ArrayStack[State]
    worklist push initState

    while (!worklist.isEmpty)
      for ((s, _) <- underlying.outgoingTransitions(worklist.pop))
        if (fwdReachable add s)
          worklist push s

    val backMapping = new MHashMap[State, MHashSet[State]]

    for (s <- fwdReachable)
      for ((t, _) <- underlying.outgoingTransitions(s))
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

    bwdReachable.toSet
  }

  lazy val internalise: CostEnrichedAutomaton = {
    val smap = new MHashMap[underlying.State, underlying.State]

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

    builder.addRegsRelation(this.regsRelation)
    builder.appendRegisters(this.registers)
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
    override val underlying: A,
    val _initialState: A#State,
    val _acceptingStates: Set[A#State]
) extends CostEnrichedAutomatonAdapter[A](underlying) {

  lazy val initialState = _initialState

  lazy val states =
    computeReachableStates(_initialState, _acceptingStates)

  lazy val acceptingStates: Set[State] =
    _acceptingStates & states

  def unary_! = {
    internalise.unary_!
  }

  def |(that: Automaton): Automaton = {
    internalise | that
  }

  def apply(word: Seq[Int]): Boolean = {
    var state = initialState
    var finalIdx = 0
    for (
      (c, idx) <- word.zipWithIndex;
      (to, lbl) <- outgoingTransitions(state)
      if LabelOps.labelContains(c.toChar, lbl)
    ) {
      state = to
      finalIdx = idx
    }
    isAccept(state) && finalIdx == word.size - 1
  }

  def isAccept(s: State): Boolean = acceptingStates.contains(s)

  def getAcceptedWord: Option[Seq[Int]] = {

    val s2word = new MHashMap[State, Seq[Int]]
    val worklist = new ArrayStack[State]
    worklist.push(initialState)
    s2word.put(initialState, Seq())

    if (isAccept(initialState))
      return Some(Seq())

    while (!worklist.isEmpty) {
      val s = worklist.pop
      val word = s2word(s)
      for ((to, label) <- outgoingTransitions(s)) {
        if (!s2word.contains(to)) {
          s2word.put(to, word :+ label._1.toInt)
          worklist.push(to)
        }
        if (isAccept(to)) return Some(s2word(to))
      }
    }
    None
  }

  def isEmpty: Boolean = {
    return !isAccept(initialState) && outgoingTransitions(initialState).isEmpty
  }

  override def outgoingTransitions(q: State): Iterator[(State, TLabel)] = {
    val _states = states
    for (
      p @ (s, _) <- underlying.outgoingTransitions(q);
      if _states contains s
    )
      yield p
  }

  override def incomingTransitions(
      t: State
  ): Iterator[(State, (Char, Char))] = {
    val _states = states
    for (
      p @ (s, _) <- underlying.incomingTransitions(t);
      if _states contains s
    )
      yield p
  }

  override def toString: String = {
    val state2Int = states.zipWithIndex.toMap
    def transition2Str(transition: (State, TLabel, State, Seq[Int])): String = {
      val (s, (left, right), t, vec) = transition
      val registerUpdate =
        s"{${vec.zipWithIndex
            .map { case (veci, i) => s"${registers(i)} += $veci" }
            .mkString(", ")}};"

      s"s${state2Int(s)} -> s${state2Int(t)} [${left.toInt}, ${right.toInt}] $registerUpdate"
    }

    s"""
    automaton a${states.size} {
      init s${state2Int(initialState)};
      ${transitionsWithVec.toSeq
        .sortBy(_._1)
        .map(transition2Str)
        .mkString("\n  ")}
      accepting ${acceptingStates.map(s => s"s${state2Int(s)}").mkString(", ")};
    };
    """
  }
}
