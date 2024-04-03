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
import dk.brics.automaton.Transition
import scala.collection.JavaConverters._
import ap.parser.IFormula
import ap.parser.IExpression._
import ostrich.cesolver.util.TermGenerator
import ap.parser.Simplifier
import ostrich.cesolver.util.ParikhUtil
import ostrich.automata.BricsTLabelEnumerator
import ap.util.Timeout
import ostrich.cesolver.automata
import ap.parser.IBinJunctor

object CEBasicOperations {

  private val directlyUnwindUpper = 20
  private val termGen = TermGenerator()

  def toBricsAutomaton(aut: CostEnrichedAutomatonBase): BAutomaton = {
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

  def unionWithoutRegs(
      auts: Seq[CostEnrichedAutomatonBase]
  ): CostEnrichedAutomatonBase = {
    val bauts = auts.map(toBricsAutomaton)
    BricsAutomatonWrapper(BasicOperations.union(bauts.asJava))
  }

  def union(
      auts: Seq[CostEnrichedAutomatonBase],
      autsFormulaIsSame: Boolean = false
  ): CostEnrichedAutomatonBase = {
    ParikhUtil.log("CEBasicOperations.union: compute the union of automata")
    if (auts.isEmpty) return BricsAutomatonWrapper(BasicAutomata.makeEmpty)
    if (
      auts.forall(aut =>
        aut.registers.isEmpty &&
          (((new Simplifier)(aut.regsRelation)).isTrue || autsFormulaIsSame)
      )
    ) {
      val res = unionWithoutRegs(auts)
      res.regsRelation &= auts.head.regsRelation
      return res
    }
    val ceAut = new CostEnrichedAutomaton
    val termGen = TermGenerator()
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
      newRegisters += termGen.registerTerm
      val f = newRegisters.last >= 1
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
      finalDisjList += partitionFormula(aut) & aut.regsRelation
    }
    // all register equal to 0 and disj(epsilonSatisfied)
    finalDisjList += connectSimplify(
      ((oldRegsiters ++ newRegisters).map(_ === 0)) :+ or(epsilonSatisfied),
      IBinJunctor.And
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
    ParikhUtil.log(
      "CEBasicOperations.complement: compute the complement of automata"
    )
    ParikhUtil.todo("Complement CEFAs that contain registers", 1)
    registersMustBeEmpty(aut)
    complementWithoutRegs(aut)
  }

  def intersection[A <: CostEnrichedAutomatonBase](
      aut1: A,
      aut2: A
  ): CostEnrichedAutomatonBase = {
    ParikhUtil.log("CEBasicOperations.intersection: intersect automata")
    val ceAut = new CostEnrichedAutomaton
    val initialState1 = aut1.initialState
    val initialState2 = aut2.initialState
    val initialState = ceAut.initialState
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
                worklist.push((to1, to2))
                ceAut.newState()
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
    ceAut.regsRelation = connectSimplify(Seq(aut1.regsRelation, aut2.regsRelation), IBinJunctor.And)
    ceAut.registers = aut1.registers ++ aut2.registers
    removeDeadState(ceAut)
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
    ParikhUtil.log("CEBasicOperations.diff: compute the difference of automata")
    if (a1.registers.isEmpty && a2.registers.isEmpty)
      return diffWithoutRegs(a1, a2)
    intersection(a1, complement(a2))
  }

  def concatenate(
      auts: Seq[CostEnrichedAutomatonBase]
  ): CostEnrichedAutomatonBase = {
    ParikhUtil.log("CEBasicOperations.concatenate: concatenate automata")
    if (auts.isEmpty)
      return BricsAutomatonWrapper.makeEmpty()
    val ceAut = new CostEnrichedAutomaton
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

    for (aut <- auts; s <- aut.acceptingStates)
      ceAut.setAccept(old2new(s), false)
    for (s <- auts.last.acceptingStates)
      ceAut.setAccept(old2new(s), true)
    for (
      i <- (0 until auts.size - 1).reverse;
      lastAccept <- auts(i).acceptingStates
    )
      ceAut.addEpsilon(old2new(lastAccept), old2new(auts(i + 1).initialState))
    ceAut.registers = auts.flatMap(_.registers)
    ceAut.regsRelation = connectSimplify(auts.map(_.regsRelation), IBinJunctor.And)
    ceAut
  }

  private def registersMustBeEmpty(aut: CostEnrichedAutomatonBase): Unit = {
    if (aut.registers.nonEmpty) {
      aut.toDot("registersMustBeEmpty_assertion_failed")
      throw new Exception("Registers must be empty")
    }
  }

  def repeatUnwind(
      aut: CostEnrichedAutomatonBase,
      min: Int
  ): CostEnrichedAutomatonBase = {
    ParikhUtil.log(
      "CEBasicOperations.repeatUnwind: directly unwind repeat automata, min = " + min + ", max = " + "inf"
    )
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
    ParikhUtil.log(
      "CEBasicOperations.repeatUnwind: directly unwind automata, min = " + min + ", max = " + max
    )
    if (min > max) return BricsAutomatonWrapper.makeEmpty()
    if (max == 0) return BricsAutomatonWrapper.makeAnyString()
    val auts = Seq.fill(max)(aut.clone())
    val ceAut = new CostEnrichedAutomaton
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

    for (aut <- auts; s <- aut.acceptingStates)
      ceAut.setAccept(old2new(s), false)
    for ((aut, i) <- auts.zipWithIndex; if (i >= min-1); s <- aut.acceptingStates)
      ceAut.setAccept(old2new(s), true)
    for (
      i <- (0 until auts.size - 1).reverse;
      lastAccept <- auts(i).acceptingStates
    )
      ceAut.addEpsilon(old2new(lastAccept), old2new(auts(i + 1).initialState))
    ceAut.registers = auts.flatMap(_.registers)
    ceAut.regsRelation = connectSimplify(auts.map(_.regsRelation), IBinJunctor.And)
    ceAut
  }

  def repeat(
      aut: CostEnrichedAutomatonBase,
      min: Int,
      max: Int,
      unwind: Boolean
  ): CostEnrichedAutomatonBase = {
    if (unwind | max < directlyUnwindUpper / aut.states.size) {
      return repeatUnwind(aut, min, max)
    }

    ParikhUtil.log("CEBasicOperations.repeat: symbolicly repeat automata, min = " + min + ", max = " + max)

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
    ParikhUtil.log("CEBasicOperations.optional: optional automata")
    aut.setAccept(aut.initialState, true)
    aut.regsRelation = or(
      Seq(aut.regsRelation, and(aut.registers.map(_ === 0)))
    )
    aut
  }

  // NOTE: Following functions are only complete for emptiness check. These funcitons do not reserve the semantic of the automaton.
  // For example, the automaton generated by epsilonClosureByVec may reject some strings that are not rejected by the original automaton.
  // ---------------------------------------------------------------------------------------------------------------------
  private def epsilonClosureByVec(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    if (aut.registers.isEmpty) return aut
    ParikhUtil.log(
      "CEBasicOperations.epsilonClosureByVec: compute epsilon closure of automata by considering registers update (0,...,0) as epsilon"
    )
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

  private def determinateByVec(
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

  private def partitionStatesByVec(
      aut: CostEnrichedAutomatonBase
  ) = {
    if (aut.registers.isEmpty) aut
    val pairs = new MHashSet[Set[State]]()
    for (s <- aut.states; t <- aut.states; if s != t)
      pairs.add(Set(s, t))
    val pair2dependingList = new MHashMap[Set[State], ArrayBuffer[Set[State]]]()
    for (pair <- pairs) {
      val state1 = pair.head
      val state2 = pair.last
      for ((source1, l1, v1) <- aut.incomingTransitionsWithVec(state1)) {
        for (
          (source2, l2, v2) <- aut.incomingTransitionsWithVec(state2);
          if v1 == v2
        ) {
          ap.util.Timeout.check
          if (source1 != source2) {
            pair2dependingList.getOrElseUpdate(pair, ArrayBuffer()) += Set(
              source1,
              source2
            )
          }
        }
      }
    }
    val distinguishedPairs = new MHashSet[Set[State]]()
    val baseDistinguishedPairs = new MHashSet[Set[State]]()
    for (pair <- pairs) {
      if (aut.isAccept(pair.head) != aut.isAccept(pair.last)) {
        baseDistinguishedPairs.add(pair)
      } else {
        val outVecs1 = aut
          .outgoingTransitionsWithVec(pair.head)
          .map { case (_, _, v) => v }
          .toSet
        val outVecs2 = aut
          .outgoingTransitionsWithVec(pair.last)
          .map { case (_, _, v) => v }
          .toSet
        if (outVecs1 != outVecs2) {
          baseDistinguishedPairs.add(pair)
        }
      }
    }
    var lastDistinguishedPairs = baseDistinguishedPairs
    while (lastDistinguishedPairs.nonEmpty) {
      distinguishedPairs ++= lastDistinguishedPairs
      val newDistinguishedPairs = new MHashSet[Set[State]]()
      for (pair <- lastDistinguishedPairs; if pair2dependingList.contains(pair)) {
        for (dependingPair <- pair2dependingList(pair)) {
          if (!distinguishedPairs.contains(dependingPair)) {
            newDistinguishedPairs.add(dependingPair)
          }
        }
      }
      lastDistinguishedPairs = newDistinguishedPairs
    }
    val s2equivalentClass = new MHashMap[State, MHashSet[State]]
    for (s <- aut.states)
      s2equivalentClass += (s -> MHashSet(s))
    for (pair <- pairs) {
      if (!distinguishedPairs.contains(pair)) {
        val s1 = pair.head
        val s2 = pair.last
        s2equivalentClass(s1) ++= s2equivalentClass(s2)
        s2equivalentClass(s2) = s2equivalentClass(s1)
      }
    }
    val equalClass2rep = new MHashMap[Set[State], State]
    val s2reprensentive = new MHashMap[State, State]
    for (equalClass <- s2equivalentClass.values) {
      equalClass2rep.getOrElseUpdate(equalClass.toSet, aut.newState())
    }
    for ((s, set) <- s2equivalentClass) {
      s2reprensentive(s) = equalClass2rep(set.toSet)
    }
    s2reprensentive
  }

  def minimizeHopcroftByVec(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    if (aut.registers.isEmpty) return aut
    ParikhUtil.log(
      "CEBasicOperations.minimizeHopcroftByVec: minimize automata according to registers updates (do not minimize if the automata is much larger after determinization)"
    )
    val afterEpsilonClosure = epsilonClosureByVec(aut)
    val afterDetermine = determinateByVec(afterEpsilonClosure)
    if (afterDetermine.size / 5 > aut.size)
      return aut
    val s2representive = partitionStatesByVec(afterDetermine)
    val ceAut = new CostEnrichedAutomaton
    ceAut.initialState = s2representive(afterDetermine.initialState)
    for ((s, l, t, v) <- afterDetermine.transitionsWithVec)
      ceAut.addTransition(s2representive(s), l, s2representive(t), v)
    for (s <- afterDetermine.acceptingStates)
      ceAut.setAccept(s2representive(s), true)
    ceAut.regsRelation = afterDetermine.regsRelation
    ceAut.registers = afterDetermine.registers
    removeDuplicatedReg(ceAut)
  }
  // ---------------------------------------------------------------------------------------------------------------------

  private def determinate(aut: CostEnrichedAutomatonBase) = {
    val ceAut = new CostEnrichedAutomaton
    val powerset2new = new MHashMap[Set[State], State]
    val workstack = new MStack[Set[State]]

    val initialState = ceAut.initialState
    powerset2new += (Set(aut.initialState) -> initialState)
    workstack.push(Set(aut.initialState))

    while (workstack.nonEmpty) {
      ap.util.Timeout.check

      val curPowerSet = workstack.pop()
      val curState = powerset2new(curPowerSet)
      val curTrans = new MHashMap[((Char, Char), Seq[Int]), MHashSet[State]]
      val outLabels =
        for (
          s <- curPowerSet;
          (t, l, v) <- aut.outgoingTransitionsWithVec(
            s
          )
        ) yield l
      val outLabelsEnumerator = new BricsTLabelEnumerator(outLabels.iterator)
      for (
        s <- curPowerSet; (t, l, v) <- aut.outgoingTransitionsWithVec(s);
        splitlbl <- outLabelsEnumerator.enumLabelOverlap(l)
      ) {
        val newGoToStates = curTrans.getOrElse((splitlbl, v), MHashSet()).union(Set(t))
        curTrans += ((splitlbl, v) -> newGoToStates)
      }
      for (((splitlbl, v), set) <- curTrans) {
        val powerset = set.toSet
        if (!powerset2new.contains(powerset)) {
          powerset2new += (powerset -> ceAut.newState())
          workstack.push(powerset)
        }
        ceAut.addTransition(
          curState,
          splitlbl,
          powerset2new(powerset),
          v
        )
      }
    }
    for ((seq, s) <- powerset2new) {
      if (seq.exists(aut.isAccept))
        ceAut.setAccept(s, true)
    }
    ceAut.registers = aut.registers
    ceAut.regsRelation = aut.regsRelation
    ceAut
  }

  private def partitionStates(aut: CostEnrichedAutomatonBase) = {
    val pairs = new MHashSet[Set[State]]()
    for (s <- aut.states; t <- aut.states; if s != t)
      pairs.add(Set(s, t))
    val pair2dependingList = new MHashMap[Set[State], ArrayBuffer[Set[State]]]()
    for (pair <- pairs) {
      val state1 = pair.head
      val state2 = pair.last
      for ((source1, l1, v1) <- aut.incomingTransitionsWithVec(state1)) {
        for (
          (source2, l2, v2) <- aut.incomingTransitionsWithVec(state2);
          if (l1, v1).equals((l2, v2))
        ) {
          ap.util.Timeout.check
          if (source1 != source2) {
            pair2dependingList.getOrElseUpdate(pair, ArrayBuffer()) += Set(
              source1,
              source2
            )
          }
        }
      }
    }
    val distinguishedPairs = new MHashSet[Set[State]]()
    val baseDistinguishedPairs = new MHashSet[Set[State]]()
    for (pair <- pairs) {
      if (aut.isAccept(pair.head) != aut.isAccept(pair.last)) {
        baseDistinguishedPairs.add(pair)
      } else {
        val outVecs1 = aut
          .outgoingTransitionsWithVec(pair.head)
          .map { case (_, l, v) => (l, v) }
          .toSet
        val outVecs2 = aut
          .outgoingTransitionsWithVec(pair.last)
          .map { case (_, l, v) => (l, v) }
          .toSet
        if (outVecs1 != outVecs2) {
          baseDistinguishedPairs.add(pair)
        }
      }
    }
    val newDistinguishedPairs = baseDistinguishedPairs
    while (newDistinguishedPairs.nonEmpty) {
      distinguishedPairs ++= newDistinguishedPairs
      val tmpPairs = newDistinguishedPairs.clone()
      newDistinguishedPairs.clear()
      for (pair <- tmpPairs; if pair2dependingList.contains(pair)) {
        for (dependingPair <- pair2dependingList(pair)) {
          if (!distinguishedPairs.contains(dependingPair)) {
            newDistinguishedPairs.add(dependingPair)
          }
        }
      }
    }
    val s2equivalentClass = new MHashMap[State, MHashSet[State]]
    for (s <- aut.states)
      s2equivalentClass += (s -> MHashSet(s))
    for (pair <- pairs) {
      if (!distinguishedPairs.contains(pair)) {
        val s1 = pair.head
        val s2 = pair.last
        s2equivalentClass(s1) ++= s2equivalentClass(s2)
        s2equivalentClass(s2) = s2equivalentClass(s1)
      }
    }
    val equalClass2rep = new MHashMap[Set[State], State]
    val s2reprensentive = new MHashMap[State, State]
    for (equalClass <- s2equivalentClass.values) {
      equalClass2rep += (equalClass.toSet -> aut.newState())
    }
    for ((s, set) <- s2equivalentClass) {
      s2reprensentive += (s -> equalClass2rep(set.toSet))
    }
    s2reprensentive
  }

  def minimizeHopcroft(aut: CostEnrichedAutomatonBase) = {
    ParikhUtil.log(
      "CEBasicOperations.minimizeHopcroft: minimize automata"
    )
    val afterDetermine = determinate(aut)
    val s2representive = partitionStates(afterDetermine)
    val ceAut = new CostEnrichedAutomaton
    ceAut.initialState = s2representive(afterDetermine.initialState)
    for ((s, l, t, v) <- afterDetermine.transitionsWithVec)
      ceAut.addTransition(s2representive(s), l, s2representive(t), v)
    for (s <- afterDetermine.acceptingStates)
      ceAut.setAccept(s2representive(s), true)
    ceAut.regsRelation = afterDetermine.regsRelation
    ceAut.registers = afterDetermine.registers
    removeDuplicatedReg(ceAut)
  }

  def removeDuplicatedReg(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    if (aut.registers.isEmpty) return aut
    ParikhUtil.log(
      "CEBasicOperations.removeDuplicatedReg: remove duplicated registers"
    )
    def seqRemoveValuesAtIdxs[A](s: Seq[A], idxs: Set[Int]): Seq[A] = {
      val res = ArrayBuffer[A]()
      for (i <- 0 until s.size) {
        if (!idxs.contains(i)) {
          res += s(i)
        }
      }
      res.toSeq
    }
    // transpose the vectors, so that each vector is a column containing all updates of a register
    val vectorsT =
      aut.transitionsWithVec
        .map { case (_, _, _, v) => v }
        .toSeq
        .transpose
        .zipWithIndex
    val vectors2Idxs = new MHashMap[Seq[Int], Set[Int]]()
    // map the transposed vectors to their updated register
    for ((v, i) <- vectorsT) {
      if (!vectors2Idxs.contains(v)) {
        vectors2Idxs += (v -> Set[Int]())
      }
      vectors2Idxs(v) += i
    }
    // if a transposed vector map to more than one register, then these registers are duplicated
    val duplicatedRegs =
      vectors2Idxs.map { case (_, idxs) => idxs }.filter(_.size > 1)
    val ceAut = new CostEnrichedAutomaton
    var newRegsRelation = aut.regsRelation
    var newRegisters = aut.registers
    val old2new = aut.states.map(s => (s, ceAut.newState())).toMap
    if (duplicatedRegs.isEmpty) return aut

    // remove the duplicated registers and add lia constraints to remain the semantics
    val removeIdxs = new MHashSet[Int]()
    duplicatedRegs.foreach { regidxs =>
      regidxs.tail.foreach { idx =>
        newRegsRelation = connectSimplify(
          Seq(
            newRegsRelation,
            (newRegisters(regidxs.head) === newRegisters(idx))
          ),
          IBinJunctor.And
        )
      }
      removeIdxs ++= regidxs.tail
    }
    newRegisters = seqRemoveValuesAtIdxs(newRegisters, removeIdxs.toSet)
    for ((from, lbl, to, vec) <- aut.transitionsWithVec) {
      ceAut.addTransition(
        old2new(from),
        lbl,
        old2new(to),
        seqRemoveValuesAtIdxs(vec, removeIdxs.toSet)
      )
    }
    for (s <- aut.acceptingStates)
      ceAut.setAccept(old2new(s), true)
    ceAut.initialState = old2new(aut.initialState)
    ceAut.registers = newRegisters
    ceAut.regsRelation = newRegsRelation
    ceAut
  }

  def removeDeadState(
      aut: CostEnrichedAutomatonBase
  ): CostEnrichedAutomatonBase = {
    ParikhUtil.log(
      "CEBasicOperations.removeDeadState: remove states that can not reach the final state"
    )
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
