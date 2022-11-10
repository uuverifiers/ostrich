package ostrich.parikh.automata

import dk.brics.automaton.{BasicOperations, Automaton => BAutomaton, State}
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.RegisterTerm
import ostrich.parikh.TermGeneratorOrder.order
import ap.terfor.TerForConvenience._
import ap.terfor.conjunctions.Conjunction
import dk.brics.automaton.BasicAutomata
import scala.jdk.CollectionConverters._
import ap.terfor.Term

object CEBasicOperations {
  // TODO: implement them

  def union(auts: Seq[CostEnrichedAutomaton]): CostEnrichedAutomaton = {
    if (auts.isEmpty) return new CostEnrichedAutomaton(BasicAutomata.makeEmpty)
    if (auts.forall(_.getRegisters.isEmpty))
      return new CostEnrichedAutomaton(
        BasicOperations.union(auts.map(_.underlying).asJava)
      )
    var regsRelation = Conjunction.TRUE
    var needNewReg = false
    if (auts.exists(_.getRegisters.isEmpty))
      needNewReg = true
    val builder = CostEnrichedAutomaton.getBuilder
    val initialS = builder.getNewState
    builder.setInitialState(initialS)
    val newRegisters: Seq[Term] = if (needNewReg) Seq(RegisterTerm()) else Seq()
    val allRegisters = auts.flatMap(_.getRegisters) ++ newRegisters
    val finalVecLen = allRegisters.size
    var prefixlen = 0
    for (aut <- auts) {
      val old2new = aut.states.map(s => (s -> builder.getNewState)).toMap
      for ((s, l, t, v) <- aut.transitionsWithVec) {
        val newVec =
          if (v.isEmpty) Seq.fill(finalVecLen - 1)(0) ++ Seq(1)
          else
            Seq.fill(prefixlen)(0) ++ v ++ Seq.fill(
              finalVecLen - prefixlen - v.size
            )(0)
        builder.addTransition(
          old2new(s),
          l,
          old2new(t),
          newVec
        )
      }
      prefixlen += aut.getRegisters.size
      val registers =
        if (aut.getRegisters.isEmpty) newRegisters else aut.getRegisters
      builder.addEpsilon(initialS, old2new(aut.initialState))
      for (s <- aut.acceptingStates)
        builder.setAccept(old2new(s), true)
      // builder.addRegsRelation(aut.getRegsRelation)
      val otherRegsBeZero = conj(
        for (r <- allRegisters.filterNot(registers.contains)) 
          yield r === 0
      )
      regsRelation = disj(regsRelation, conj(aut.getRegsRelation, otherRegsBeZero))
    }
    builder.appendRegisters(allRegisters)
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
      builder.addRegsRelation(Conjunction.negate(aut.getRegsRelation, order))
      builder.getAutomaton
    }
    union(Seq(aut1, aut2))
  }

  def intersection(
      a1: CostEnrichedAutomaton,
      a2: CostEnrichedAutomaton
  ): CostEnrichedAutomaton = {
    (a1 & a2).asInstanceOf[CostEnrichedAutomaton]
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
    for (s <- lastAccepts)
      builder.setAccept(old2new(s), true)
    builder.getAutomaton
  }

  def repeat(aut: CostEnrichedAutomaton): CostEnrichedAutomaton = {
    new CostEnrichedAutomaton(BasicOperations.repeat(aut.underlying))
  }

  def repeat(aut: CostEnrichedAutomaton, min: Int): CostEnrichedAutomaton = {
    val builder = CostEnrichedAutomaton.getBuilder
    val newRegister = RegisterTerm()
    val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
    builder.setInitialState(old2new(aut.initialState))
    if (min <= 0)
      builder.setAccept(old2new(aut.initialState), true)
    for ((s, l, t, v) <- aut.transitionsWithVec)
      builder.addTransition(old2new(s), l, old2new(t), v ++ Seq(0))
    for (s <- aut.acceptingStates) {
      for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
        builder.addTransition(old2new(s), l, old2new(t), v ++ Seq(1))
      builder.setAccept(old2new(s), true)
    }
    builder.setInitialState(old2new(aut.initialState))
    builder.prependRegisters(aut.getRegisters ++ Seq(newRegister))
    builder.addRegsRelation(newRegister >= min-1)
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
    for (s <- aut.acceptingStates) {
      for ((t, l, v) <- aut.outgoingTransitionsWithVec(aut.initialState))
        builder.addTransition(old2new(s), l, old2new(t), v ++ Seq(1))
      builder.setAccept(old2new(s), true)
    }
    builder.prependRegisters(aut.getRegisters ++ Seq(newRegister))
    builder.addRegsRelation(conj(newRegister >= min-1, newRegister <= max-1))
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

}
