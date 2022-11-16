package ostrich.parikh.automata

import dk.brics.automaton.{BasicOperations, Automaton => BAutomaton, State}
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

object CEBasicOperations {
  // TODO: implement them

  private def negate(f: Formula) = {
    Conjunction.negate(f, order)
  }

  def union(auts: Seq[CostEnrichedAutomaton]): CostEnrichedAutomaton = {
    // TODO: bug exists. The union is not semantically correct
    if (auts.isEmpty) return new CostEnrichedAutomaton(BasicAutomata.makeEmpty)
    if (auts.forall(_.getRegisters.isEmpty))
      return new CostEnrichedAutomaton(
        BasicOperations.union(auts.map(_.underlying).asJava)
      )
    var regsRelation = Conjunction.TRUE
    val builder = CostEnrichedAutomaton.getBuilder
    val initialS = builder.getNewState
    builder.setInitialState(initialS)
    val newRegisters: ArrayBuffer[Term] = new ArrayBuffer
    val oldRegsiters = auts.flatMap(_.getRegisters)
    val oldRegsLen = auts.flatMap(_.getRegisters).size
    var prefixlen = 0
    val epsilonSatisfied =
      auts.filter(aut => aut.isAccept(aut.initialState)).map(_.getRegsRelation)
    val finalDisjList = ArrayBuffer[Formula]()
    val partitionFormula = MHashMap[CostEnrichedAutomaton, Formula]()

    for (aut <- auts) {
      var f = Conjunction.TRUE
      val initialOutVecs =
        aut.outgoingTransitionsWithVec(aut.initialState).map(_._3).toSet
      initialOutVecs.foreach(vec => {
        for (i <- 0 until vec.size) {
          if (vec(i) != 0) {
            f = disj(f, aut.getRegisters(i) >= 1)
          }
        }
      })
      if (f == Conjunction.TRUE) {
        // all value of initialOutVecs are 0
        newRegisters += RegisterTerm()
        f = newRegisters(0) >= 1
      }
      partitionFormula += (aut -> f)
    }

    for (aut <- auts) {
      val old2new = aut.states.map(s => (s -> builder.getNewState)).toMap
      for ((s, l, t, v) <- aut.transitionsWithVec) {
        val isInitialOut = if (s == aut.initialState) 1 else 0
        val preFill = Seq.fill(prefixlen)(0)
        val postFill = Seq.fill(oldRegsLen - prefixlen - v.size)(0)
        val partitionTailVec = if (s == aut.initialState && v.forall(_ == 0)) {
          Seq.fill(newRegisters.size)(1)
        } else Seq.fill(newRegisters.size)(0)
        val newVec =
          preFill ++ v ++ postFill ++ partitionTailVec
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
    val a = builder.getAutomaton
    a
  }

  def complement(aut: CostEnrichedAutomaton): CostEnrichedAutomaton = {
    val aut1 = new CostEnrichedAutomaton(
      BasicOperations.complement(aut.underlying)
    )
    if (aut.getRegisters.size == 0)
      return aut1
    val aut2 = {
      val builder = CostEnrichedAutomaton.getBuilder
      val old2new = aut.states.map(s => (s -> builder.getNewState)).toMap
      for ((s, l, t, v) <- aut.transitionsWithVec)
        builder.addTransition(old2new(s), l, old2new(t), v)
      for (s <- aut.acceptingStates)
        builder.setAccept(old2new(s), true)
      builder.setInitialState(old2new(aut.initialState))
      builder.prependRegisters(aut.getRegisters)
      builder.addRegsRelation(negate(aut.getRegsRelation))
      builder.getAutomaton
    }
    if (aut1.isEmpty) {
      return aut2
    }
    union(Seq(aut1, aut2))
  }

  def intersection(
      aut1: CostEnrichedAutomaton,
      aut2: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    val autBuilder = CostEnrichedAutomaton.getBuilder

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
    val res = autBuilder.getAutomaton
    CEBasicOperations.removeDeadState(res)
  }

  def diff(
      a1: CostEnrichedAutomaton,
      a2: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    if (a1.getRegisters.isEmpty && a2.getRegisters.isEmpty)
      return new CostEnrichedAutomaton(
        BasicOperations.minus(a1.underlying, a2.underlying)
      )
    intersection(a1, complement(a2))
  }

  def concatenate(auts: Seq[CostEnrichedAutomaton]): CostEnrichedAutomaton = {
    if (auts.isEmpty)
      return new CostEnrichedAutomaton(BasicAutomata.makeEmpty())
    if (auts.forall(_.getRegisters.isEmpty))
      return new CostEnrichedAutomaton(
        BasicOperations.concatenate(auts.map(_.underlying).asJava)
      )
    val builder = CostEnrichedAutomaton.getBuilder
    val old2new =
      auts.map(_.states).flatten.map(s => (s -> builder.getNewState)).toMap
    val finalVecLen = auts.map(_.getRegisters.size).sum

    builder.setInitialState(old2new(auts(0).initialState))
    for ((s, l, t, v) <- auts(0).transitionsWithVec)
      builder.addTransition(
        old2new(s),
        l,
        old2new(t),
        v ++ Seq.fill(finalVecLen - v.size)(0)
      )
    builder.appendRegisters(auts(0).getRegisters)
    builder.addRegsRelation(auts(0).getRegsRelation)

    var lastAccepts = auts.head.acceptingStates
    var prefixlen = auts.head.getRegisters.size

    for (s <- auts.last.acceptingStates)
      builder.setAccept(old2new(s), true)

    for (aut <- auts.tail) {
      for ((s, l, t, v) <- aut.transitionsWithVec)
        builder.addTransition(
          old2new(s),
          l,
          old2new(t),
          Seq.fill(prefixlen)(0) ++ v ++ Seq.fill(
            finalVecLen - prefixlen - v.size
          )(0)
        )
      for (s <- lastAccepts)
        builder.addEpsilon(old2new(s), old2new(aut.initialState))
      lastAccepts = aut.acceptingStates
      prefixlen += aut.getRegisters.size
      builder.appendRegisters(aut.getRegisters)
      builder.addRegsRelation(aut.getRegsRelation)
    }
    builder.getAutomaton
  }

  def repeat(aut: CostEnrichedAutomaton): CostEnrichedAutomaton = {
    new CostEnrichedAutomaton(BasicOperations.repeat(aut.underlying))
  }

  def repeat(aut: CostEnrichedAutomaton, min: Int): CostEnrichedAutomaton = {
    if (min <= 0) return repeat(aut)
    val builder = CostEnrichedAutomaton.getBuilder
    val newRegister = RegisterTerm()
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
    val builder = CostEnrichedAutomaton.getBuilder
    val newRegister = RegisterTerm()
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
    builder.getAutomaton
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
  def simplify(aut: CostEnrichedAutomaton): CostEnrichedAutomaton = {
    // determinateByVec(epsilonClosureByVec(
    removeUselessTrans(aut)
    // ))
  }

  def removeUselessTrans(
      aut: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
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

  def epsilonClosureByVec(
      aut: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    if (aut.getRegisters.isEmpty) return aut
    // TODO: Some bug exist, think about how to compute the epsilon closure
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

  // we want to determinze the final automaton before generating lia by vec
  // see (0,...,0) as epsilon
  def determinateByVec(
      aut: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    if (aut.getRegisters.isEmpty) return aut
    val builder = CostEnrichedAutomaton.getBuilder
    val seq2new = new MHashMap[Set[State], State]
    val workstack = new MStack[Set[State]]
    val s2i = aut.states.zipWithIndex.toMap

    seq2new += (Set(aut.initialState) -> builder.getNewState)
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
          // println(seq.map(s => s"s${s2i(s)}").mkString(","))
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
      if (seq.exists(_ == aut.initialState))
        builder.setInitialState(s)
    }

    builder.appendRegisters(aut.getRegisters)
    builder.addRegsRelation(aut.getRegsRelation)
    builder.getAutomaton
  }

  /** TODO: implement it Remove all state that can not reach the final state
    * @param aut
    * @return
    */
  def removeDeadState(
      aut: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
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
        if (!seen(s)) {
          workstack.push(s)
          seen.add(s)
          builder.addTransition(old2new(s), l, old2new(cur), v)
        }
      }
    }
    builder.setInitialState(old2new(aut.initialState))
    builder.appendRegisters(aut.getRegisters)
    builder.addRegsRelation(aut.getRegsRelation)
    builder.getAutomaton
  }
}
