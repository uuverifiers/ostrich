package ostrich.parikh.core

import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ap.terfor.Formula
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet,
  Stack => MStack
}
import ap.terfor.Term
import ostrich.parikh.KTerm
import ap.terfor.conjunctions.Conjunction
import ostrich.parikh.ZTerm
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.CostEnrichedConvenience._
import ap.terfor.preds.Atom
import ostrich.parikh.util.UnknownException
import ostrich.parikh.writer.TempWriter
import ostrich.parikh.writer.Logger
import ostrich.parikh.Config
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.automata.CEBasicOperations
import ostrich.parikh.automata.CostEnrichedAutomaton

class UnaryHeuristicAC(val aut: CostEnrichedAutomatonTrait)
    extends AtomConstraint {

  private val upperBoundMax = 100

  private val globalS = ArrayBuffer[Set[(State, Seq[Int])]]()

  def getUnderApprox(ubound: Int): Formula = {
    // We return True when this automaton do not have registers
    // (which means there is only regex membership)
    if (aut.getRegisters.isEmpty)
      return Conjunction.TRUE
    val n = aut.states.size
    val rLen = aut.getRegisters.size
    val lowerBound = globalS.size
    val upperBound = if (ubound < upperBoundMax) ubound else upperBoundMax
    computeGlobalSWithRegsValue(upperBound)
    if(lowerBound == globalS.size){
      // the globalS does not change
      return Conjunction.FALSE
    }
    val registers = aut.getRegisters

    val r1Formula = disjFor(
      for (
        j <- lowerBound until globalS.size;
        if !globalS(j).isEmpty;
        (s, regVal) <- globalS(j);
        if (aut.isAccept(s))
      ) yield {
        conj(for (i <- 0 until registers.size) yield registers(i) === regVal(i))
      }
    )
    r1Formula
  }

  private def getLIAFromOneRegAut(aut: CostEnrichedAutomatonTrait): Formula = {
    assert(aut.getRegisters.size == 1)

    val n = aut.states.size
    val kSet = new MHashSet[Term]
    val reg = aut.getRegisters(0)
    val S = computeS(aut, 2 * n * n + n)
    val t = computeT(aut, 2 * n * n - n)

    val regsValuesLIA = disj {
      val r1Formula = disjFor(
        for (
          j <- 0 until S.size;
          s <- S(j);
          if (aut.isAccept(s))
        ) yield {
          aut.getRegisters(0) === j
        }
      )
      val r2Formula = disjFor(
        if (n < S.size) {
          for (
            from <- S(n);
            period <- periods(aut, from);
            c <- 2 * n * n - period until 2 * n * n;
            if (c - n) < t.size;
            to <- t(c - n);
            if (from == to)
          ) yield {
            val k = KTerm()
            kSet += k
            aut.getRegisters(0) === c + k * period
          }
        } else Seq()
      )
      Seq(r1Formula, r2Formula)
    }

    val kFormula = conj(
      for (k <- kSet) yield {
        k >= 1
      }
    )

    conj(regsValuesLIA, kFormula)

  }

  def getOverApprox: Formula = {
    val reg2Aut = for (i <- 0 until aut.getRegisters.size) yield {
      val reg = aut.getRegisters(i)
      val builder = CostEnrichedAutomaton.getBuilder
      val old2new = aut.states.map(s => (s, builder.getNewState)).toMap
      builder.setInitialState(old2new(aut.initialState))
      for ((s, l, t, v) <- aut.transitionsWithVec) {
        builder.addTransition(old2new(s), l, old2new(t), Seq(v(i)))
      }
      for (s <- aut.acceptingStates) {
        builder.setAccept(old2new(s), true)
      }
      builder.appendRegisters(Seq(reg))
      builder.getAutomaton
    }
    val regsFormula = conj(
      for (aut <- reg2Aut)
        yield getLIAFromOneRegAut(
          CEBasicOperations.determinateByVec(
            CEBasicOperations.epsilonClosureByVec(
              CEBasicOperations.simplify(aut)
            )
          )
        )
    )
    regsFormula
  }

  override def getCompleteLIA: Formula = {
    // Throw unkonwn exception to see how many instance can not be checked by approximation
    throw UnknownException(
      "UnaryHeuristicAC.getCompleteLIA: over- and under-approximation fail"
    )
  }

  def getRegsRelation: Formula = aut.getRegsRelation

  def computeGlobalSWithRegsValue(
      sLen: Int
  ): Unit = {
    var idx = globalS.size
    val s2i = aut.states.zipWithIndex.toMap
    if (idx == 0) {
      globalS += Set((aut.initialState, Seq.fill(aut.getRegisters.size)(0)))
      idx += 1
    }
    while (idx < sLen && !globalS(idx - 1).isEmpty) {
      globalS += (for (
        (s, regVal) <- globalS(idx - 1);
        (t, vec) <- succWithVec(aut, s)
      ) yield {
        (t, addTwoSeq(regVal, vec))
      })
      idx += 1
    }
  }

  def computeS(
      aut: CostEnrichedAutomatonTrait,
      sLen: Int
  ): ArrayBuffer[Set[State]] = {
    var idx = 1
    val s2i = aut.states.zipWithIndex.toMap

    val tmpS = ArrayBuffer(
      Set(aut.initialState)
    )

    while (idx < sLen && !tmpS(idx - 1).isEmpty) {
      tmpS += (for (
        s <- tmpS(idx - 1);
        (t, vec) <- succWithVec(aut, s)
      ) yield t)
      idx += 1
    }
    tmpS
  }

  /** computing T_len, T_{len-1}, ..., T_0. Terminate if T_(2n^2-n-1) is
    * computed or pre(S_i) is empty
    */
  def computeT(
      aut: CostEnrichedAutomatonTrait,
      len: Int
  ): ArrayBuffer[Set[State]] = {
    val n = aut.states.size
    val acceptingStates = aut.acceptingStates
    val T = ArrayBuffer[Set[State]]()
    T += acceptingStates
    var idx = 1
    while (idx < len && !T(idx - 1).isEmpty) {
      T +=
        (for (
          t <- T(idx - 1);
          (s, vec) <- preWithVec(aut, t)
        ) yield s)
      idx += 1
    }
    T
  }

  def periods(
      aut: CostEnrichedAutomatonTrait,
      s: State
  ): Set[Int] = {
    var period = 0
    val n = aut.states.size
    val rLen = aut.getRegisters.size
    val periods = new MHashSet[Int]
    val workstack = MStack(Seq(s))
    while (period < n && workstack.nonEmpty) {
      val seqstates = workstack.pop()
      val nextStates =
        for (
          s <- seqstates;
          (t, l) <- aut.outgoingTransitions(s)
        ) yield t
      workstack.push(nextStates)
      period += 1
      if (nextStates.contains(s)) {
        periods += period
      }
    }
    periods.toSet
  }

  def succWithVec(
      aut: CostEnrichedAutomatonTrait,
      s: State
  ): Iterator[(State, Seq[Int])] =
    for ((t, lbl, vec) <- aut.outgoingTransitionsWithVec(s)) yield (t, vec)

  def preWithVec(
      aut: CostEnrichedAutomatonTrait,
      t: State
  ): Iterator[(State, Seq[Int])] =
    for ((s, lbl) <- aut.incomingTransitions(t).iterator)
      yield (s, aut.getEtaMap((s, lbl, t)))

  // e.g (1,1) + (1,0) = (2,1)
  def addTwoSeq(seq1: Seq[Int], seq2: Seq[Int]): Seq[Int] = {
    seq1 zip seq2 map { case (a, b) => a + b }
  }

}