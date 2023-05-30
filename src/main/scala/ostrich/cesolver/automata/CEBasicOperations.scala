package ostrich.cesolver.automata

import dk.brics.automaton.{BasicOperations, State, Automaton => BAutomaton}
import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  Stack => MStack,
  ArrayBuffer,
  ArrayStack
}
import dk.brics.automaton.BasicAutomata
import ap.parser.ITerm
import ostrich.automata.BricsTLabelOps
import ostrich.cesolver.util.ParikhUtil
import dk.brics.automaton.Transition
import scala.collection.JavaConverters._
import ap.parser.IFormula
import ap.parser.IExpression._
import ap.parser.IExpression
import ostrich.cesolver.util.TermGenerator

object CEBasicOperations {

  private val termGen = TermGenerator(hashCode())

  def toBricsAutomaton(aut: CostEnrichedAutomatonBase): BAutomaton = aut match {
    case a: BricsAutomatonWrapper => a.underlying
    case _ => {
      val baut = new BAutomaton
      baut.setDeterministic(false)

      val old2new = aut.states.map(s => s -> new State()).toMap
      for ((s, l, t, v) <- aut.transitionsWithVec) {
        old2new(s).addTransition(new Transition(l._1, l._2, old2new(t)))
      }
      for (s <- aut.acceptingStates) {
        old2new(s).setAccept(true)
      }
      baut.setInitialState(old2new(aut.initialState))
      baut
    }
  }

  def unionWithoutRegs(
      auts: Seq[CostEnrichedAutomatonBase]
  ): CostEnrichedAutomatonBase = {
    val bauts = auts.map(toBricsAutomaton)
    val a = BricsAutomatonWrapper(BasicOperations.union(bauts.asJava))
    a
  }

  def union(
      auts: Seq[CostEnrichedAutomatonBase]
  ): CostEnrichedAutomatonBase = {
    if (auts.isEmpty) return BricsAutomatonWrapper(BasicAutomata.makeEmpty)
    if (auts.forall(_.registers.isEmpty))
      return unionWithoutRegs(auts)
    val ceAut = new CostEnrichedAutomaton
    val initialS = ceAut.initialState
    val newRegisters: ArrayBuffer[ITerm] = new ArrayBuffer
    val oldRegsiters = auts.flatMap(_.registers)
    val oldRegsLen = oldRegsiters.size
    var prefixlen = 0
    // the regs relation need to be satisfied for epsilon string
    val epsilonSatisfied =
      auts.filter(aut => aut.isAccept(aut.initialState)).map(_.regsRelation)
    // the list of disjunctive formula for the union of the automata
    val finalDisjList = ArrayBuffer[IFormula]()
    // map each automaton to the formula that is satisfied iff
    // the union of the automata chooses this automaton
    val partitionFormula = MHashMap[CostEnrichedAutomatonBase, IFormula]()
    val aut2newRegIdx = MHashMap[CostEnrichedAutomatonBase, Int]()

    for (aut <- auts) {
      var f = IExpression.Boolean2IFormula(false)
      val initialStateOut =
        aut.outgoingTransitionsWithVec(aut.initialState).map(_._3)
      if (initialStateOut.forall(_.exists(_ > 0))) {
        // all vectors of transitions from initialState have elements > 0
        for (vec <- initialStateOut) {
          val notZeroIdx = vec.indexWhere(_ > 0)
          f = or(Seq(f, aut.registers(notZeroIdx) >= 1))
        }
      }
      if (f == IExpression.Boolean2IFormula(false)) {
        // all value of initialOutVecs are 0
        newRegisters += termGen.registerTerm
        f = newRegisters.last >= 1
      }
      aut2newRegIdx += (aut -> (newRegisters.size - 1))
      partitionFormula += (aut -> f)
    }

    for (aut <- auts) {
      val old2new = aut.states.map(s => (s -> ceAut.newState())).toMap
      for ((s, l, t, v) <- aut.transitionsWithVec) {
        val preFill = Seq.fill(prefixlen)(0)
        val postFill = Seq.fill(oldRegsLen - prefixlen - v.size)(0)
        val newRegsUpdate = ArrayBuffer.fill(newRegisters.size)(0)
        if (aut2newRegIdx(aut) >= 0)
          newRegsUpdate(aut2newRegIdx(aut)) = 1
        val tailVec = newRegsUpdate.toSeq
        val newVec =
          preFill ++ v ++ postFill ++ tailVec
        ceAut.addTransition(
          old2new(s),
          l,
          old2new(t),
          newVec
        )
      }
      for (s <- aut.acceptingStates)
        ceAut.setAccept(old2new(s), true)

      prefixlen += aut.registers.size

      ceAut.addEpsilon(initialS, old2new(aut.initialState))
      finalDisjList += and(Seq(partitionFormula(aut), aut.regsRelation))
    }
    // forall i newRegisters(i) == 0 and disj(epsilonSatisfied)
    finalDisjList += and(
      (newRegisters.map(_ === 0)) :+ or(epsilonSatisfied)
    )

    ceAut.regsRelation = or(finalDisjList)
    ceAut.registers = oldRegsiters ++ newRegisters
    ceAut
  }

  def complementWithoutRegs(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    val baut = toBricsAutomaton(aut)
    BricsAutomatonWrapper {
      BasicOperations.complement(baut)
    }
  }

  def complement(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    registersMustBeEmpty(aut)
    complementWithoutRegs(aut)
  }

  def intersection[A <: CostEnrichedAutomatonBase](
      aut1: A,
      aut2: A
  ): CostEnrichedAutomatonBase = {
    ap.util.Timeout.check
    val ceAut = new CostEnrichedAutomaton
    // begin intersection
    val initialState1 = aut1.initialState
    val initialState2 = aut2.initialState
    val initialState = ceAut.initialState
    // autBuilder.setInitialState(initialState)
    ceAut.setAccept(
      initialState,
      aut1.isAccept(initialState1) && aut2.isAccept(initialState2)
    )

    // from old states pair to new state
    val pair2state = new MHashMap[(State, State), State]
    val worklist = new ArrayStack[(State, State)]

    pair2state.put((initialState1, initialState2), initialState)
    worklist.push((initialState1, initialState2))

    while (!worklist.isEmpty) {
      ap.util.Timeout.check

      val (from1, from2) = worklist.pop()
      val from = pair2state(from1, from2)
      for (
        (to1, label1, vec1) <- aut1.outgoingTransitionsWithVec(from1);
        (to2, label2, vec2) <- aut2.outgoingTransitionsWithVec(from2)
      ) {
        // intersect transition
        aut1.LabelOps.intersectLabels(label1, label2) match {
          case Some(label) => {
            val to = pair2state.getOrElseUpdate(
              (to1, to2), {
                val newState = ceAut.newState()
                worklist.push((to1, to2))
                newState
              }
            )
            val vector = vec1 ++ vec2
            ceAut.addTransition(
              from,
              label,
              to,
              vector
            )
            ceAut.setAccept(
              to,
              aut1.isAccept(to1) && aut2.isAccept(to2)
            )
          }
          case _ => // do nothing
        }
      }
    }
    ceAut.regsRelation = and(Seq(aut1.regsRelation, aut2.regsRelation))
    ceAut.registers = aut1.registers ++ aut2.registers
    ceAut
  }

  def diffWithoutRegs(
      aut1: CostEnrichedAutomatonBase,
      aut2: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    val baut1 = toBricsAutomaton(aut1)
    val baut2 = toBricsAutomaton(aut2)
    BricsAutomatonWrapper {
      BasicOperations.minus(baut1, baut2)
    }
  }

  def diff(
      a1: CostEnrichedAutomatonBase,
      a2: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    if (a1.registers.isEmpty && a2.registers.isEmpty)
      return diffWithoutRegs(a1, a2)
    intersection(a1, complement(a2))
  }

  def concatenate(
      auts: Seq[CostEnrichedAutomatonBase]
  ): CostEnrichedAutomatonBase = {
    if (auts.isEmpty)
      return BricsAutomatonWrapper(BasicAutomata.makeEmpty())
    val ceAut = new CostEnrichedAutomaton
    // val builder = CostEnrichedAutomatonTrait.getBuilder
    val old2new =
      auts.map(_.states).flatten.map(s => (s -> ceAut.newState())).toMap
    val finalVecLen = auts.map(_.registers.size).sum

    ceAut.initialState = old2new(auts(0).initialState)

    var prefixlen = 0
    for (aut <- auts) {
      for ((s, l, t, v) <- aut.transitionsWithVec)
        ceAut.addTransition(
          old2new(s),
          l,
          old2new(t),
          Seq.fill(prefixlen)(0) ++ v ++ Seq.fill(
            finalVecLen - prefixlen - v.size
          )(0)
        )
      prefixlen += aut.registers.size
    }

    for (s <- auts.last.acceptingStates)
      ceAut.setAccept(old2new(s), true)
    for (
      i <- (0 until auts.size - 1).reverse;
      lastAccept <- auts(i).acceptingStates
    ) // Bug: should set accept first, add epsilon later
      ceAut.addEpsilon(old2new(lastAccept), old2new(auts(i + 1).initialState))
    ceAut.registers = auts.flatMap(_.registers)
    ceAut.regsRelation = and(auts.map(_.regsRelation))
    // val a = builder.getAutomaton
    ceAut
  }

  private def registersMustBeEmpty(aut: CostEnrichedAutomatonBase): Unit = {
    if (aut.registers.nonEmpty)
      throw new Exception("Registers must be empty")
  }

  def repeatUnwind(
      aut: CostEnrichedAutomatonBase,
      min: Int
  ): CostEnrichedAutomatonBase = {
    registersMustBeEmpty(aut)
    BricsAutomatonWrapper(
      BasicOperations.repeat(
        toBricsAutomaton(aut),
        min
      )
    )
  }

  def repeatUnwind(
      aut: CostEnrichedAutomatonBase,
      min: Int,
      max: Int
  ): CostEnrichedAutomatonBase = {
    registersMustBeEmpty(aut)
    BricsAutomatonWrapper(
      BasicOperations.repeat(
        toBricsAutomaton(aut),
        min,
        max
      )
    )
  }

  def repeat(
      aut: CostEnrichedAutomatonBase,
      min: Int,
      max: Int
  ): CostEnrichedAutomatonBase = {
    if (aut.registers.nonEmpty) {
      return repeatUnwind(aut, min, max)
    }
    if (max < min || min < 0 || aut.isEmpty)
      return new BricsAutomatonWrapper(BasicAutomata.makeEmpty())
    if (max == 0)
      return new BricsAutomatonWrapper(BasicAutomata.makeEmptyString())
    val ceAut = new CostEnrichedAutomaton
    val newRegister = termGen.registerTerm
    val old2new = aut.states.map(s => (s, ceAut.newState())).toMap
    ceAut.initialState = old2new(aut.initialState)
    if (min == 0)
      ceAut.setAccept(old2new(aut.initialState), true)
    // construct update of the new register
    for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
      ceAut.addTransition(
        old2new(aut.initialState),
        l,
        old2new(t),
        v ++ Seq(1)
      )
    // construct other updates
    for ((s, l, t, v) <- aut.transitionsWithVec; if s != aut.initialState)
      ceAut.addTransition(old2new(s), l, old2new(t), v ++ Seq(0))
    for (s <- aut.acceptingStates) {
      for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
        ceAut.addTransition(old2new(s), l, old2new(t), v ++ Seq(1))
      ceAut.setAccept(old2new(s), true)
    }
    val newRegisters = aut.registers ++ Seq(newRegister)
    // if empty string is accepted by the aut, then the repeat of the aut should also
    // accept empty string
    val newRegsRelation =
      if (aut.isAccept(aut.initialState))
        newRegister <= max
      else
        and(Seq(newRegister >= min, newRegister <= max))
    ceAut.registers = newRegisters
    ceAut.regsRelation = newRegsRelation
    ceAut
  }

  def optional(aut: CostEnrichedAutomatonBase): CostEnrichedAutomatonBase = {
    aut.setAccept(aut.initialState, true)
    aut.regsRelation = or(
      Seq(aut.regsRelation, and(aut.registers.map(_ === 0)))
    )
    aut
  }

  // We want to simplify the final automaton before generating lia by three steps:
  // remove all transitions with same state and update function
  def simplify(aut: CostEnrichedAutomatonBase): CostEnrichedAutomatonBase = {
    aut.removeDuplicatedReg()
    removeUselessTrans(aut)
  }

  // When two transition contains same (s, t, v), we can remove one of them
  def removeUselessTrans(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    if (aut.registers.isEmpty) return aut
    val ceAut = new CostEnrichedAutomaton
    val old2new = aut.states.map(s => (s, ceAut.newState())).toMap
    ceAut.initialState = old2new(aut.initialState)
    val seenList = new MHashSet[(State, State, Seq[Int])]
    for ((s, l, t, v) <- aut.transitionsWithVec) {
      if (!seenList.contains((old2new(s), old2new(t), v))) {
        ceAut.addTransition(old2new(s), l, old2new(t), v)
        seenList.add((old2new(s), old2new(t), v))
      }
    }
    for (s <- aut.acceptingStates)
      ceAut.setAccept(old2new(s), true)
    ceAut.registers = aut.registers
    ceAut.regsRelation = aut.regsRelation
    ceAut
  }

  // see (0,...,0) as epsilon
  def epsilonClosureByVec(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    if (aut.registers.isEmpty) return aut
    val ceAut = new CostEnrichedAutomaton
    val old2new = aut.states.map(s => (s, ceAut.newState())).toMap
    for (s <- aut.states) {
      if (aut.isAccept(s))
        ceAut.setAccept(old2new(s), true)
      // get the epsilon closure
      val epsClosureSet = MHashSet[State](s)
      val workstack = MStack[State](s)
      val seen = MHashSet[State](s)
      while (workstack.nonEmpty) {
        val cur = workstack.pop()
        for ((t, _, v) <- aut.outgoingTransitionsWithVec(cur)) {
          if (v.forall(_ == 0) && !seen(t)) {
            workstack.push(t)
            epsClosureSet.add(t)
            if (aut.isAccept(t))
              ceAut.setAccept(old2new(s), true)
            seen.add(t)
          }
        }
      }
      // generate new transitions
      for (
        se <- epsClosureSet; (t, l, v) <- aut.outgoingTransitionsWithVec(se);
        if v.exists(_ != 0)
      )
        ceAut.addTransition(old2new(s), l, old2new(t), v)
    }
    ceAut.initialState = old2new(aut.initialState)

    ceAut.registers = aut.registers
    ceAut.regsRelation = aut.regsRelation
    ceAut
  }

  // We want to determinze the final automaton before generating lia by vec
  def determinateByVec(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    if (aut.registers.isEmpty) return aut
    val ceAut = new CostEnrichedAutomaton
    val seq2new = new MHashMap[Set[State], State]
    val workstack = new MStack[Set[State]]

    val initialState = ceAut.initialState
    seq2new += (Set(aut.initialState) -> initialState)
    workstack.push(Set(aut.initialState))

    while (workstack.nonEmpty) {
      ap.util.Timeout.check

      val curSeq = workstack.pop()
      val curState = seq2new(curSeq)
      val curTrans = new MHashMap[Seq[Int], Set[State]]
      for (s <- curSeq) {
        for ((t, l, v) <- aut.outgoingTransitionsWithVec(s)) {
          if (curTrans.contains(v))
            curTrans(v) = curTrans(v) ++ Set(t)
          else
            curTrans += (v -> Set(t))
        }
      }
      for ((v, seq) <- curTrans) {
        if (!seq2new.contains(seq)) {
          seq2new += (seq -> ceAut.newState())
          workstack.push(seq)
        }
        ceAut.addTransition(
          curState,
          BricsTLabelOps.sigmaLabel,
          seq2new(seq),
          v
        )
      }
    }

    for ((seq, s) <- seq2new) {
      if (seq.exists(aut.isAccept))
        ceAut.setAccept(s, true)
    }

    ceAut.registers = aut.registers
    ceAut.regsRelation = aut.regsRelation
    ceAut
  }

  def partitionStatesByVec(
      aut: CostEnrichedAutomatonBase
  ) = {
    val pairs = new MHashSet[(State, State)]()
    for (s <- aut.states; t <- aut.states; if s != t)
      pairs.add((s, t))
    var pairsIsEqual = pairs.map(p => (p, true)).toMap
    val pairs2depends = pairs.map(p => (p, new MHashSet[(State, State)])).toMap
    for ((s1, s2) <- pairs) {
      var isEqual = true
      for ((t1, l1, v1) <- aut.outgoingTransitionsWithVec(s1)) {
        for (
          (t2, l2, v2) <- aut.outgoingTransitionsWithVec(s2);
          if v1 == v2
        ) {
          if (t1 != t2)
            pairs2depends((t1, t2)).add((s1, s2))
        }
      }
      if (aut.isAccept(s1) != aut.isAccept(s2)) isEqual = false
      if (
        aut.outgoingTransitionsWithVec(s1).map(_._3).toSet !=
          aut.outgoingTransitionsWithVec(s2).map(_._3).toSet
      )
        isEqual = false
      if (!isEqual) {
        pairsIsEqual += ((s1, s2) -> isEqual)
      }
    }
    val seenPairs = new MHashSet[(State, State)]
    val worklist = new MStack[(State, State)]
    for ((s1, s2) <- pairs) {
      if (!pairsIsEqual((s1, s2))) {
        worklist.push((s1, s2))
      }
    }
    // partition the depend pairs
    while (worklist.nonEmpty) {
      ap.util.Timeout.check

      val (s1, s2) = worklist.pop()
      if (!seenPairs((s1, s2))) {
        seenPairs.add((s1, s2))
        pairsIsEqual += ((s1, s2) -> false)
        for ((t1, t2) <- pairs2depends((s1, s2))) {
          worklist.push((t1, t2))
        }
      }
    }
    val ceAut = new CostEnrichedAutomaton
    val s2new = new MHashMap[State, State]
    for ((s1, s2) <- pairs) {
      if (pairsIsEqual((s1, s2))) {
        val equalS = s2new.get(s1) match {
          case None        => s2new.getOrElse(s2, ceAut.newState())
          case Some(state) => state
        }
        s2new += (s1 -> equalS)
        s2new += (s2 -> equalS)
      } else {
        s2new += (s1 -> s2new.getOrElse(s1, ceAut.newState()))
        s2new += (s2 -> s2new.getOrElse(s2, ceAut.newState()))
      }
    }
    if (pairs.isEmpty) s2new += (aut.initialState -> ceAut.newState())
    s2new.toMap
  }

  def minimizeHopcroftByVec(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    val simplified1 = removeDeadState(aut)
    val s2equal = partitionStatesByVec(simplified1)
    val ceAut = new CostEnrichedAutomaton
    ceAut.initialState = s2equal(simplified1.initialState)
    for ((s, l, t, v) <- simplified1.transitionsWithVec)
      ceAut.addTransition(s2equal(s), l, s2equal(t), v)
    for (s <- simplified1.acceptingStates)
      ceAut.setAccept(s2equal(s), true)
    ceAut.regsRelation = simplified1.regsRelation
    ceAut.registers = simplified1.registers
    ceAut
  }

  private def partitionStates(aut: CostEnrichedAutomatonBase) = {
    val pairs = new MHashSet[(State, State)]()
    for (s <- aut.states; t <- aut.states; if s != t)
      pairs.add((s, t))
    var pairsIsEqual = pairs.map(p => (p, true)).toMap
    val pairs2depends = pairs.map(p => (p, new MHashSet[(State, State)])).toMap
    for ((s1, s2) <- pairs) {
      var isEqual = true
      for ((t1, l1, v1) <- aut.outgoingTransitionsWithVec(s1)) {
        for (
          (t2, l2, v2) <- aut.outgoingTransitionsWithVec(s2);
          if l1 == l2 && v1 == v2
        ) {
          if (t1 != t2)
            pairs2depends((t1, t2)).add((s1, s2))
        }
      }
      if (aut.isAccept(s1) != aut.isAccept(s2)) isEqual = false
      if (
        aut
          .outgoingTransitionsWithVec(s1)
          .map { case (_, l, v) => (l, v) }
          .toSet !=
          aut
            .outgoingTransitionsWithVec(s2)
            .map { case (_, l, v) => (l, v) }
            .toSet
      )
        isEqual = false
      if (!isEqual) {
        pairsIsEqual += ((s1, s2) -> isEqual)
      }
    }
    val seenPairs = new MHashSet[(State, State)]
    val worklist = new MStack[(State, State)]
    for ((s1, s2) <- pairs) {
      if (!pairsIsEqual((s1, s2))) {
        worklist.push((s1, s2))
      }
    }
    // partition the depend pairs
    while (worklist.nonEmpty) {
      ap.util.Timeout.check

      val (s1, s2) = worklist.pop()
      if (!seenPairs((s1, s2))) {
        seenPairs.add((s1, s2))
        pairsIsEqual += ((s1, s2) -> false)
        for ((t1, t2) <- pairs2depends((s1, s2))) {
          worklist.push((t1, t2))
        }
      }
    }
    val ceAut = new CostEnrichedAutomaton
    val s2new = new MHashMap[State, State]
    for ((s1, s2) <- pairs) {
      if (pairsIsEqual((s1, s2))) {
        val equalS = s2new.get(s1) match {
          case None        => s2new.getOrElse(s2, ceAut.newState())
          case Some(state) => state
        }
        s2new += (s1 -> equalS)
        s2new += (s2 -> equalS)
      } else {
        s2new += (s1 -> s2new.getOrElse(s1, ceAut.newState()))
        s2new += (s2 -> s2new.getOrElse(s2, ceAut.newState()))
      }
    }
    if (pairs.isEmpty) s2new += (aut.initialState -> ceAut.newState())
    s2new.toMap
  }

  def minimizeHopcroft(aut: CostEnrichedAutomatonBase) = {
    val simplified1 = removeDeadState(aut)
    val s2equal = partitionStates(simplified1)
    val ceAut = new CostEnrichedAutomaton
    for ((s, l, t, v) <- simplified1.transitionsWithVec)
      ceAut.addTransition(s2equal(s), l, s2equal(t), v)
    ceAut.initialState = s2equal(simplified1.initialState)
    for (s <- simplified1.acceptingStates)
      ceAut.setAccept(s2equal(s), true)
    ceAut.regsRelation = simplified1.regsRelation
    ceAut.registers = simplified1.registers
    ceAut
  }

  // Remove the state can not reach the final state
  def removeDeadState(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    val ceAut = new CostEnrichedAutomaton
    val old2new = aut.states.map(s => (s, ceAut.newState())).toMap
    val workstack = MStack[State]()
    val seen = MHashSet[State]()
    for (s <- aut.acceptingStates) {
      workstack.push(s); seen.add(s); ceAut.setAccept(old2new(s), true)
    }
    while (workstack.nonEmpty) {
      val cur = workstack.pop()
      for ((s, l, v) <- aut.incomingTransitionsWithVec(cur)) {
        ceAut.addTransition(old2new(s), l, old2new(cur), v)
        if (!seen(s)) {
          workstack.push(s)
          seen.add(s)
        }
      }
    }
    ceAut.initialState = old2new(aut.initialState)
    ceAut.registers = aut.registers
    ceAut.regsRelation = aut.regsRelation
    ceAut
  }
}
