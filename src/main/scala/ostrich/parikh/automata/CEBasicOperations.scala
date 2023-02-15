package ostrich.parikh.automata

import dk.brics.automaton.{BasicOperations, State}
import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  Stack => MStack,
  ArrayBuffer,
  ArrayStack
}
import ostrich.parikh.RegisterTerm
import ostrich.parikh.TermGeneratorOrder.order
import ap.terfor.TerForConvenience._
import ap.terfor.conjunctions.Conjunction
import dk.brics.automaton.BasicAutomata
import scala.jdk.CollectionConverters._
import ap.terfor.Term
import ap.terfor.Formula
import ostrich.automata.BricsTLabelOps
import ostrich.automata.Automaton
import ostrich.parikh.ParikhUtil
import ap.terfor.substitutions.ConstantSubst
import ostrich.parikh.TermGeneratorOrder
import ap.terfor.ConstantTerm

object CEBasicOperations {
  // For each automaton, we add a register to stand for using the automaton
  // TODO: Bug exists.
  def union(auts: Seq[CostEnrichedAutomaton]): CostEnrichedAutomaton = {
    if (auts.isEmpty) return CostEnrichedAutomaton(BasicAutomata.makeEmpty)
    if (auts.forall(_.getRegisters.isEmpty))
      return CostEnrichedAutomaton(
        BasicOperations.union(auts.map(_.underlying).asJava)
      )
    val builder = CostEnrichedAutomaton.getBuilder
    val initialS = builder.getNewState
    builder.setInitialState(initialS)
    val newRegisters: ArrayBuffer[Term] = new ArrayBuffer
    val oldRegsiters = auts.flatMap(_.getRegisters)
    val oldRegsLen = auts.flatMap(_.getRegisters).size
    var prefixlen = 0
    // the regs relation need to be satisfied for epsilon string 
    val epsilonSatisfied =
      auts.filter(aut => aut.isAccept(aut.initialState)).map(_.getRegsRelation)
    // the list of disjunctive formula for the union of the automata
    val finalDisjList = ArrayBuffer[Formula]()
    // map each automaton to the formula that is satisfied iff 
    // the union of the automata chooses this automaton
    val partitionFormula = MHashMap[CostEnrichedAutomaton, Formula]()
    val aut2newRegIdx = MHashMap[CostEnrichedAutomaton, Int]()

    for (aut <- auts) {
      var f = Conjunction.FALSE
      val initialStateOut = aut.outgoingTransitionsWithVec(aut.initialState).map(_._3)
      if(initialStateOut.forall(_.exists(_ > 0))){
        // all vectors of transitions from initialState have elements > 0
        for (vec <- initialStateOut){
          val notZeroIdx = vec.indexWhere(_ > 0)
          f = disj(f, aut.getRegisters(notZeroIdx) >= 1)
        }
      }
      if (f == Conjunction.FALSE) {
        // all value of initialOutVecs are 0
        newRegisters += RegisterTerm()
        f = newRegisters.last >= 1
      }
      aut2newRegIdx += (aut -> (newRegisters.size - 1))
      partitionFormula += (aut -> f)
    }

    for (aut <- auts) {
      val old2new = aut.states.map(s => (s -> builder.getNewState)).toMap
      for ((s, l, t, v) <- aut.transitionsWithVec) {
        val preFill = Seq.fill(prefixlen)(0)
        val postFill = Seq.fill(oldRegsLen - prefixlen - v.size)(0)
        val newRegsUpdate = ArrayBuffer.fill(newRegisters.size)(0)
        newRegsUpdate(aut2newRegIdx(aut)) = 1
        val tailVec = newRegsUpdate.toSeq
        val newVec =
          preFill ++ v ++ postFill ++ tailVec
        builder.addTransition(
          old2new(s),
          l,
          old2new(t),
          newVec
        )
      }
      for (s <- aut.acceptingStates)
        builder.setAccept(old2new(s), true)

      prefixlen += aut.getRegisters.size

      builder.addEpsilon(initialS, old2new(aut.initialState))
      // partitionFormula and aut.getRegsRelation
      finalDisjList += conj(partitionFormula(aut), aut.getRegsRelation)
    }
    // forall i newRegisters(i) == 0 and disj(epsilonSatisfied)
    finalDisjList += conj(
      (newRegisters.map(_ === 0)) :+ disjFor(epsilonSatisfied)
    )

    builder.addRegsRelation(disjFor(finalDisjList))
    builder.appendRegisters(oldRegsiters ++ newRegisters)
    builder.getAutomaton
  }

  def complement(aut: CostEnrichedAutomaton): CostEnrichedAutomaton = {
    val aut1 = CostEnrichedAutomaton{
      BasicOperations.complement(aut.underlying)
    }

    // if (aut.getRegisters.size == 0)
    //   return aut1
    // val aut2 = {
    //   val builder = CostEnrichedAutomaton.getBuilder
    //   val old2new = aut.states.map(s => (s -> builder.getNewState)).toMap
    //   for ((s, l, t, v) <- aut.transitionsWithVec)
    //     builder.addTransition(old2new(s), l, old2new(t), v)
    //   for (s <- aut.acceptingStates)
    //     builder.setAccept(old2new(s), true)
    //   builder.setInitialState(old2new(aut.initialState))
    //   builder.prependRegisters(aut.getRegisters)
    //   builder.addRegsRelation(negate(aut.getRegsRelation))
    //   builder.getAutomaton
    // }
    // if (aut1.isEmpty) {
    //   return aut2
    // }
    // union(Seq(aut1, aut2))
     aut1
  }

  def intersection[A <: CostEnrichedAutomatonTrait](
      aut1: A,
      aut2: A
  ): CostEnrichedAutomaton = {
    val autBuilder = aut1.getBuilder
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
        (to1, label1, vec1) <- aut1.outgoingTransitionsWithVec(from1);
        (to2, label2, vec2) <- aut2.outgoingTransitionsWithVec(from2)
      ) {
        // intersect transition
        aut1.LabelOps.intersectLabels(label1, label2) match {
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
    autBuilder.addRegsRelation(aut1.getRegsRelation)
    autBuilder.addRegsRelation(aut2.getRegsRelation)
    autBuilder.prependRegisters(aut1.getRegisters ++ aut2.getRegisters)
    autBuilder.getAutomaton
  }

  def diff(
      a1: CostEnrichedAutomaton,
      a2: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    if (a1.getRegisters.isEmpty && a2.getRegisters.isEmpty)
      return CostEnrichedAutomaton(
        BasicOperations.minus(a1.underlying, a2.underlying)
      )
    intersection(a1, complement(a2))
  }

  def concatenate(
      auts: Seq[CostEnrichedAutomaton]
  ): CostEnrichedAutomaton = {
    if (auts.isEmpty)
      return CostEnrichedAutomaton(BasicAutomata.makeEmpty())
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new =
      auts.map(_.states).flatten.map(s => (s -> builder.getNewState)).toMap
    val finalVecLen = auts.map(_.getRegisters.size).sum

    builder.setInitialState(old2new(auts(0).initialState))

    var prefixlen = 0
    for (aut <- auts) {
      for ((s, l, t, v) <- aut.transitionsWithVec)
        builder.addTransition(
          old2new(s),
          l,
          old2new(t),
          Seq.fill(prefixlen)(0) ++ v ++ Seq.fill(
            finalVecLen - prefixlen - v.size
          )(0)
        )
      prefixlen += aut.getRegisters.size
      builder.appendRegisters(aut.getRegisters)
      builder.addRegsRelation(aut.getRegsRelation)
    }

    for (s <- auts.last.acceptingStates)
      builder.setAccept(old2new(s), true)
    for (i <- (0 until auts.size - 1).reverse; lastAccept <- auts(i).acceptingStates)
      builder.addEpsilon(old2new(lastAccept), old2new(auts(i + 1).initialState))

    val a = builder.getAutomaton
    a
  }

  private def registersMustBeEmpty(aut: CostEnrichedAutomaton): Unit = {
    if (aut.getRegisters.nonEmpty)
      throw new Exception("Registers must be empty")
  }

  private def clone(
      aut: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new = aut.states.map(s => (s -> builder.getNewState)).toMap
    for ((s, l, t, v) <- aut.transitionsWithVec)
      builder.addTransition(old2new(s), l, old2new(t), v)
    for (s <- aut.acceptingStates)
      builder.setAccept(old2new(s), true)
    builder.setInitialState(old2new(aut.initialState))
    val newRegisters = Seq.fill(aut.getRegisters.size)(RegisterTerm())
    val replacement = new MHashMap[ConstantTerm, Term]
    for ((oldr, newr) <- aut.getRegisters.zip(newRegisters))
      replacement.put(oldr.asInstanceOf[ConstantTerm], newr)
    val order = TermGeneratorOrder.order
    val newRegsRelation =
      ConstantSubst(replacement.toMap, order)(aut.getRegsRelation)
    builder.appendRegisters(newRegisters)
    builder.addRegsRelation(newRegsRelation)
    builder.getAutomaton
  }

  def repeatUnwind(
      aut: CostEnrichedAutomaton,
      min: Int
  ): CostEnrichedAutomaton = {
    registersMustBeEmpty(aut)
    CostEnrichedAutomaton(BasicOperations.repeat(aut.underlying, min))
  }

  def repeatUnwind(
      aut: CostEnrichedAutomaton,
      min: Int,
      max: Int
  ): CostEnrichedAutomaton = {
    // if(aut.getRegisters.isEmpty)
    //   return new CostEnrichedAutomaton(BasicOperations.repeat(aut.underlying, min, max))
    Console.err.println("unwind repeat")
    val unwindAuts = new ArrayBuffer[CostEnrichedAutomaton]
    if (max < min) return new CostEnrichedAutomaton(BasicAutomata.makeEmpty())
    if (max == 0) return new CostEnrichedAutomaton(BasicAutomata.makeEmptyString())
    for (_ <- 0 until max)
      unwindAuts += clone(aut)
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new =
      unwindAuts.map(_.states).flatten.map(s => (s -> builder.getNewState)).toMap
    val finalVecLen = unwindAuts.map(_.getRegisters.size).sum

    builder.setInitialState(old2new(unwindAuts(0).initialState))
    if(min == 0)  builder.setAccept(old2new(unwindAuts(0).initialState), true)

    var prefixlen = 0
    for ((aut, i) <- unwindAuts.zipWithIndex) {
      for ((s, l, t, v) <- aut.transitionsWithVec)
        builder.addTransition(
          old2new(s),
          l,
          old2new(t),
          Seq.fill(prefixlen)(0) ++ v ++ Seq.fill(
            finalVecLen - prefixlen - v.size
          )(0)
        )
      prefixlen += aut.getRegisters.size
      if (i+1 >= min){
        for (s <- aut.acceptingStates)
          builder.setAccept(old2new(s), true)
      }
      builder.appendRegisters(aut.getRegisters)
      builder.addRegsRelation(aut.getRegsRelation)
    }

    for (i <- 0 until unwindAuts.size - 1; lastAccept <- unwindAuts(i).acceptingStates)
      builder.addEpsilon(old2new(lastAccept), old2new(unwindAuts(i + 1).initialState))
    builder.getAutomaton
  }

  // We can not nestly repeat automata with registers
  // Naive implementation is to unfold the nestly repeat automata
  def repeat(
      aut: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    repeat(aut, 0)
  }

  def repeat(
      aut: CostEnrichedAutomaton,
      min: Int
  ): CostEnrichedAutomaton = {
    // we unfold the aut to avoid too many registers when the number of unfold states is less then `unfoldMaxState`
    // if (aut.states.size * medAutomaton(
    //     BasicOperations.repin <= unfoldMaxState)
    //   return new CostEnricheat(aut.underlying, min)
    //   )
    // registersMustBeEmpty(aut)
    val builder = CostEnrichedAutomaton.getBuilder
    val newRegister = RegisterTerm()
    ParikhUtil.addCountingRegister(newRegister)
    val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
    builder.setInitialState(old2new(aut.initialState))
    for ((s, l, t, v) <- aut.transitionsWithVec)
      builder.addTransition(old2new(s), l, old2new(t), v ++ Seq(0))
    for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
      builder.addTransition(
        old2new(aut.initialState),
        l,
        old2new(t),
        v ++ Seq(1)
      )
    for (s <- aut.acceptingStates) {
      for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
        builder.addTransition(old2new(s), l, old2new(t), v ++ Seq(1))
      builder.setAccept(old2new(s), true)
    }
    val newRegisters = aut.getRegisters ++ Seq(newRegister)
    builder.prependRegisters(newRegisters)
    val newRegsRelation =
      if (aut.isAccept(aut.initialState))
        disjFor(
          conj(newRegister >= min),
          conj(newRegisters.map(_ === 0) :+ aut.getRegsRelation)
        )
      else
        conj(newRegister >= min)

    builder.addRegsRelation(newRegsRelation)
    builder.getAutomaton
  }

  def repeat(
      aut: CostEnrichedAutomaton,
      min: Int,
      max: Int
  ): CostEnrichedAutomaton = {
    if (aut.getRegisters.nonEmpty) {
      return repeatUnwind(aut, min, max)
    }
    if (max < min) return new CostEnrichedAutomaton(BasicAutomata.makeEmpty())
    if (max == 0) return new CostEnrichedAutomaton(BasicAutomata.makeEmptyString())
    aut.toDot("before_repeat")
    val builder = CostEnrichedAutomaton.getBuilder
    val newRegister = RegisterTerm()
    ParikhUtil.addCountingRegister(newRegister)
    val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
    builder.setInitialState(old2new(aut.initialState))
    if (min <= 0)
      builder.setAccept(old2new(aut.initialState), true)
    for ((s, l, t, v) <- aut.transitionsWithVec)
      builder.addTransition(old2new(s), l, old2new(t), v ++ Seq(0))
    for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
      builder.addTransition(
        old2new(aut.initialState),
        l,
        old2new(t),
        v ++ Seq(1)
      )
    for (s <- aut.acceptingStates) {
      for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
        builder.addTransition(old2new(s), l, old2new(t), v ++ Seq(1))
      builder.setAccept(old2new(s), true)
    }
    val newRegisters = aut.getRegisters ++ Seq(newRegister)
    builder.prependRegisters(newRegisters)
    // if epsilon is accepted by the aut, then the repeat of the aut should also
    // accept epsilon
    val newRegsRelation =
      if (aut.isAccept(aut.initialState))
        disjFor(
          conj(newRegister >= min, newRegister <= max),
          conj(newRegisters.map(_ === 0) :+ aut.getRegsRelation)
        )
      else
        conj(newRegister >= min, newRegister <= max)
    builder.addRegsRelation(newRegsRelation)
    val a = builder.getAutomaton
    a
  }

  def optional(aut: CostEnrichedAutomaton): CostEnrichedAutomaton = {
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
    builder.setInitialState(old2new(aut.initialState))
    for ((s, l, t, v) <- aut.transitionsWithVec)
      builder.addTransition(old2new(s), l, old2new(t), v)
    for (s <- aut.acceptingStates)
      builder.setAccept(old2new(s), true)
    builder.setAccept(old2new(aut.initialState), true)
    builder.prependRegisters(aut.getRegisters)
    builder.addRegsRelation(aut.getRegsRelation)
    builder.getAutomaton
  }

  // We want to simplify the final automaton before generating lia by three steps:
  // remove all transitions with same state and update function
  def simplify(aut: CostEnrichedAutomatonTrait): CostEnrichedAutomatonTrait = {
    aut.asInstanceOf[CostEnrichedAutomaton].removeDuplicatedReg()
    removeUselessTrans(aut)
  }

  // When two transition contains same (s, t, v), we can remove one of them
  def removeUselessTrans(
      aut: CostEnrichedAutomatonTrait
  ): CostEnrichedAutomatonTrait = {
    if (aut.getRegisters.isEmpty) return aut
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
    builder.setInitialState(old2new(aut.initialState))
    val seenList = new MHashSet[(State, State, Seq[Int])]
    for ((s, l, t, v) <- aut.transitionsWithVec) {
      if (!seenList.contains((old2new(s), old2new(t), v))) {
        builder.addTransition(old2new(s), l, old2new(t), v)
        seenList.add((old2new(s), old2new(t), v))
      }
    }
    for (s <- aut.acceptingStates)
      builder.setAccept(old2new(s), true)
    builder.appendRegisters(aut.getRegisters)
    builder.addRegsRelation(aut.getRegsRelation)
    builder.getAutomaton
  }

  // see (0,...,0) as epsilon
  def epsilonClosureByVec(
      aut: CostEnrichedAutomatonTrait
  ): CostEnrichedAutomatonTrait = {
    if (aut.getRegisters.isEmpty) return aut
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
    for (s <- aut.states) {
      if (aut.isAccept(s))
        builder.setAccept(old2new(s), true)
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
              builder.setAccept(old2new(s), true)
            seen.add(t)
          }
        }
      }
      // generate new transitions
      for (
        se <- epsClosureSet; (t, l, v) <- aut.outgoingTransitionsWithVec(se);
        if v.exists(_ != 0)
      )
        builder.addTransition(old2new(s), l, old2new(t), v)
    }
    builder.setInitialState(old2new(aut.initialState))

    builder.appendRegisters(aut.getRegisters)
    builder.addRegsRelation(aut.getRegsRelation)
    builder.getAutomaton
  }

  // We want to determinze the final automaton before generating lia by vec
  def determinateByVec(
      aut: CostEnrichedAutomatonTrait
  ): CostEnrichedAutomatonTrait = {
    if (aut.getRegisters.isEmpty) return aut
    val builder = CostEnrichedAutomaton.getBuilder
    val seq2new = new MHashMap[Set[State], State]
    val workstack = new MStack[Set[State]]

    val initialState = builder.getNewState
    builder.setInitialState(initialState)
    seq2new += (Set(aut.initialState) -> initialState)
    workstack.push(Set(aut.initialState))

    while (workstack.nonEmpty) {
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
          seq2new += (seq -> builder.getNewState)
          workstack.push(seq)
        }
        builder.addTransition(
          curState,
          BricsTLabelOps.sigmaLabel,
          seq2new(seq),
          v
        )
      }
    }

    for ((seq, s) <- seq2new) {
      if (seq.exists(aut.isAccept))
        builder.setAccept(s, true)
    }

    builder.appendRegisters(aut.getRegisters)
    builder.addRegsRelation(aut.getRegsRelation)
    builder.getAutomaton
  }

  def partitionStatesByVec(
      aut: CostEnrichedAutomatonTrait
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
      val (s1, s2) = worklist.pop()
      if (!seenPairs((s1, s2))) {
        seenPairs.add((s1, s2))
        pairsIsEqual += ((s1, s2) -> false)
        for ((t1, t2) <- pairs2depends((s1, s2))) {
          worklist.push((t1, t2))
        }
      }
    }
    val builder = aut.getBuilder
    val s2new = new MHashMap[State, State]
    for ((s1, s2) <- pairs) {
      if (pairsIsEqual((s1, s2))) {
        val equalS = s2new.get(s1) match {
          case None        => s2new.getOrElse(s2, builder.getNewState)
          case Some(state) => state
        }
        s2new += (s1 -> equalS)
        s2new += (s2 -> equalS)
      } else {
        s2new += (s1 -> s2new.getOrElse(s1, builder.getNewState))
        s2new += (s2 -> s2new.getOrElse(s2, builder.getNewState))
      }
    }
    if (pairs.isEmpty) s2new += (aut.initialState -> builder.getNewState)
    s2new.toMap
  }

  // def minimizeHopcroftByVec(
  //     aut: CostEnrichedAutomatonTrait
  // ): CostEnrichedAutomatonTrait = {
  //   val simplified1 = removeDeadState(aut)
  //   val s2equal = partitionStatesByVec(simplified1)
  //   val builder = aut.getBuilder
  //   for ((s, l, t, v) <- simplified1.transitionsWithVec)
  //     builder.addTransition(s2equal(s), l, s2equal(t), v)
  //   builder.setInitialState(s2equal(simplified1.initialState))
  //   for (s <- simplified1.acceptingStates)
  //     builder.setAccept(s2equal(s), true)
  //   builder.addRegsRelation(simplified1.getRegsRelation)
  //   builder.appendRegisters(simplified1.getRegisters)
  //   builder.getAutomaton
  // }
  def minimizeHopcroftByVec(
        aut: CostEnrichedAutomatonTrait
    ): CostEnrichedAutomatonTrait = {
      val simplified1 = removeDeadState(aut)
      val s2equal = partitionStatesByVec(simplified1)
      val vecAut = new VectorAutomaton(s2equal(simplified1.initialState))
      for ((s, l, t, v) <- simplified1.transitionsWithVec)
        vecAut.addTransition(s2equal(s), s2equal(t), v)
      for (s <- simplified1.acceptingStates)
        vecAut.setAccept(s2equal(s), true)
      vecAut.setRegsRelation(simplified1.getRegsRelation)
      vecAut.setRegisters(simplified1.getRegisters)
      vecAut
    }


  private def partitionStates(aut: CostEnrichedAutomatonTrait) = {
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
      val (s1, s2) = worklist.pop()
      if (!seenPairs((s1, s2))) {
        seenPairs.add((s1, s2))
        pairsIsEqual += ((s1, s2) -> false)
        for ((t1, t2) <- pairs2depends((s1, s2))) {
          worklist.push((t1, t2))
        }
      }
    }
    val builder = aut.getBuilder
    val s2new = new MHashMap[State, State]
    for ((s1, s2) <- pairs) {
      if (pairsIsEqual((s1, s2))) {
        val equalS = s2new.get(s1) match {
          case None        => s2new.getOrElse(s2, builder.getNewState)
          case Some(state) => state
        }
        s2new += (s1 -> equalS)
        s2new += (s2 -> equalS)
      } else {
        s2new += (s1 -> s2new.getOrElse(s1, builder.getNewState))
        s2new += (s2 -> s2new.getOrElse(s2, builder.getNewState))
      }
    }
    if (pairs.isEmpty) s2new += (aut.initialState -> builder.getNewState)
    s2new.toMap
  }

  def minimizeHopcroft(aut: CostEnrichedAutomatonTrait) = {
    val simplified1 = removeDeadState(aut)
    val s2equal = partitionStates(simplified1)
    val builder = aut.getBuilder
    for ((s, l, t, v) <- simplified1.transitionsWithVec)
      builder.addTransition(s2equal(s), l, s2equal(t), v)
    builder.setInitialState(s2equal(simplified1.initialState))
    for (s <- simplified1.acceptingStates)
      builder.setAccept(s2equal(s), true)
    builder.addRegsRelation(simplified1.getRegsRelation)
    builder.appendRegisters(simplified1.getRegisters)
    builder.getAutomaton
  }

  // Remove the state can not reach the final state
  def removeDeadState(
      aut: CostEnrichedAutomatonTrait
  ): CostEnrichedAutomatonTrait = {
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
    val workstack = MStack[State]()
    val seen = MHashSet[State]()
    for (s <- aut.acceptingStates) {
      workstack.push(s); seen.add(s); builder.setAccept(old2new(s), true)
    }
    while (workstack.nonEmpty) {
      val cur = workstack.pop()
      for ((s, l, v) <- aut.incomingTransitionsWithVec(cur)) {
        builder.addTransition(old2new(s), l, old2new(cur), v)
        if (!seen(s)) {
          workstack.push(s)
          seen.add(s)
        }
      }
    }
    builder.setInitialState(old2new(aut.initialState))
    builder.appendRegisters(aut.getRegisters)
    builder.addRegsRelation(aut.getRegsRelation)
    builder.getAutomaton
  }

  // add counter to log the value of int get from the accepting string from the automaton
  // The size of the states of the result aut: O(10^len)
  def str2intCounterAut(len: Int, intRes: Term): Automaton = {
    val builder = CostEnrichedAutomaton.getBuilder
    val newReg = RegisterTerm()
    val initialState = builder.getNewState
    builder.setInitialState(initialState)
    val worklist = MStack[State](initialState)
    var digitIdx = len - 1
    while (digitIdx >= 0) {
      val curState = worklist.pop()
      for (i <- 0 to 9) {
        val newState = builder.getNewState
        builder.addTransition(
          curState,
          BricsTLabelOps.singleton((i + 48).toChar),
          newState,
          Seq(i * Math.pow(10, digitIdx).toInt)
        )
        if (digitIdx == 0) builder.setAccept(newState, true)
        else worklist.push(newState)
      }
      digitIdx -= 1
    }
    builder.addRegsRelation(newReg === intRes)
    builder.appendRegisters(Seq(newReg))
    builder.getAutomaton
  }
}
