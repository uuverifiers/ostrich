package ostrich.parikh.core

import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.automata.CostEnrichedAutomatonTrait.{
  getRegisters,
  getEtaMap,
  getTransTermMap
}
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ap.terfor.Formula
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet
}
import ap.terfor.Term
import ostrich.parikh.KTerm
import ap.terfor.conjunctions.Conjunction
import ostrich.parikh.ZTerm
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.CostEnrichedConvenience._

object AtomConstraint {
  def unaryHeuristicAC(aut: CostEnrichedAutomatonTrait) =
    new UnaryHeuristicAC(aut)
}

trait AtomConstraint {

  type State = CostEnrichedAutomatonTrait#State

  type TLabel = CostEnrichedAutomatonTrait#TLabel

  val aut: CostEnrichedAutomatonTrait

  val states = aut.states

  val registers: Seq[Term] = getRegisters(aut)

  val etaMap: Map[(State, TLabel, State),Seq[Int]] = getEtaMap(aut)

  val transTermMap: Map[(State, TLabel, State),Term] = getTransTermMap(aut)

  def product(that: AtomConstraint): AtomConstraint

  def getOverApprox: Formula

  def getLinearAbs: Formula

  def getRegsRelation: Formula

}

class UnaryHeuristicAC(val aut: CostEnrichedAutomatonTrait)
    extends AtomConstraint {

  def product(that: AtomConstraint): AtomConstraint = {
    new UnaryHeuristicAC(that.aut & aut)
  }

  def getOverApprox: Formula = {
    val n = aut.states.size
    val concreteLenBound = if (n > 10) 100 else n * n + 10;
    val s = computeS(concreteLenBound)
    val registers = getRegisters(aut)
    disjFor(
      for (
        j <- 0 until concreteLenBound;
        if !s(j).isEmpty;
        (s, regVal) <- s(j);
        if(aut.isAccept(s))
      ) yield {
        conj(for (i <- 0 until registers.size) yield registers(i) === regVal(i))
      }
    )
  }

  def getRegsRelation: Formula = aut.getRegsRelation
  def getLinearAbs: Formula = {
    println("unary ---------------------------------------------")
    val n = states.size
    val rLen = registers.size
    val concreteLen = 2 * n * n + n
    val kSet = new MHashSet[Term]

    val s = computeS(concreteLen)
    val t = computeT
    val r1Formula = disjFor(
      for (
        j <- 0 until concreteLen;
        if !s(j).isEmpty && !s(j).map(_._1).forall(!aut.isAccept(_));
        (_, regVal) <- s(j)
      ) yield {
        conj(for (i <- 0 until rLen) yield registers(i) === regVal(i))
      }
    )

    val r2Formula = disjFor(
      for (
        d <- 1 until n + 1;
        c <- 2 * n * n - d until 2 * n * n;
        (from, regVal) <- s(n);
        (period, loopVec) <- periods(from);
        (to, tailVec) <- t(c - n);
        if (period == d && from == to)
      ) yield {
        val k = KTerm()
        kSet += k
        conj(
          for (i <- 0 until rLen)
            yield registers(i) === regVal(i) + k * loopVec(i) + tailVec(i)
        )
      }
    )
    val kFormula = conj(
      for (k <- kSet) yield {
        k >= 1
      }
    )

    disj(r1Formula, conj(r2Formula, kFormula))

  }

  /** computing S_(2n^2+n-1), ..., S_0. Terminate if S_(2n^2+n-1) is computed or
    * succ(S_i) is empty
    * @return
    *   S
    */
  def computeS(
      sLen: Int
  ): ArrayBuffer[Set[(State, Seq[Int])]] = {
    val S = ArrayBuffer.fill(sLen)(Set[(State, Seq[Int])]())
    S(0) = Set((aut.initialState, Seq.fill(registers.size)(0)))
    var idx = 0
    while (idx < sLen - 1 && !S(idx).isEmpty) {
      idx += 1
      S(idx) =
        for (
          (s, regVal) <- S(idx - 1);
          (t, vec) <- succWithVec(s)
        ) yield {
          (t, addTwoSeq(regVal, vec))
        }
    }
    S
  }

  /** computing T_(2n^2-n-1), ..., T_0. Terminate if T_(2n^2-n-1) is computed or
    * pre(S_i) is empty
    */
  def computeT: ArrayBuffer[Set[(State, Seq[Int])]] = {
    val n = aut.states.size
    val acceptingStates = aut.acceptingStates
    val rLen = getRegisters(aut).size
    val Tlen = 2 * n * n - n
    val T = ArrayBuffer.fill(Tlen)(Set[(State, Seq[Int])]())
    T(0) = acceptingStates.map((_, Seq.fill(rLen)(0)))
    var idx = 0
    while (idx < Tlen - 1 && !T(idx).isEmpty) {
      idx += 1
      T(idx) =
        for (
          (t, regVal) <- T(idx - 1);
          (s, vec) <- preWithVec(t)
        ) yield {
          (s, addTwoSeq(regVal, vec))
        }
    }
    T
  }

  def periods(s: State): Set[(Int, Seq[Int])] = {
    val periods = new ArrayBuffer[(Int, Seq[Int])]
    var period = 0
    val n = aut.states.size
    val rLen = getRegisters(aut).size

    var periodVec = Seq.fill(rLen)(0)
    val nextStates2Vec = succWithVec(s).toMap
    val nextStates = nextStates2Vec.map(_._1).toSet
    while (period < n && !nextStates.isEmpty) {
      period += 1
      if (nextStates.contains(s)) {
        periodVec = addTwoSeq(periodVec, nextStates2Vec(s))
        periods.append((period, periodVec))
      }
    }
    periods.toSet
  }

  def succWithVec(
      s: State
  ): Iterator[(State, Seq[Int])] =
    for ((t, lbl, vec) <- aut.outgoingTransitionsWithVec(s)) yield (t, vec)

  def preWithVec(
      t: State
  ): Iterator[(State, Seq[Int])] =
    for ((s, lbl) <- aut.incomingTransitions(t).iterator)
      yield (s, etaMap((s, lbl, t)))

  // e.g (1,1) + (1,0) = (2,1)
  def addTwoSeq(seq1: Seq[Int], seq2: Seq[Int]): Seq[Int] = {
    seq1 zip seq2 map { case (a, b) => a + b }
  }

}

class ParikhAC(val aut: CostEnrichedAutomatonTrait) extends AtomConstraint {

  def product(that: AtomConstraint): AtomConstraint = {
    new ParikhAC(aut & that.aut)
  }
  def getOverApprox: Formula = Conjunction.FALSE

  def getRegsRelation: Formula = aut.getRegsRelation

  def getLinearAbs: Formula = {
    println("parikh ---------------------------------")
    def outFlowTerms(from: State): Seq[Term] = {
      val outFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.outgoingTransitions(from).foreach { case (to, lbl) =>
        outFlowTerms += transTermMap(from, lbl, to)
      }
      outFlowTerms
    }

    def inFlowTerms(to: State): Seq[Term] = {
      val inFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.incomingTransitions(to).foreach { case (from, lbl) =>
        inFlowTerms += transTermMap(from, lbl, to)
      }
      inFlowTerms
    }

    val zTerm = states.map((_, ZTerm())).toMap

    val preStatesWithTTerm = new MHashMap[State, MHashSet[(State, Term)]]
    for ((s, _, t, tTerm) <- aut.transitionsWithTerm) {
      val set = preStatesWithTTerm.getOrElseUpdate(t, new MHashSet)
      set += ((s, tTerm))
    }
    // consistent flow ///////////////////////////////////////////////////////////////
    var consistentFlowFormula = disj(
      for (acceptState <- aut.acceptingStates)
        yield {
          val consistentFormulas =
            for (s <- states)
              yield {
                val inFlow =
                  if (s == aut.initialState)
                    inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0)) + 1
                  else inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0))
                val outFlow =
                  if (s == acceptState)
                    outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0)) + 1
                  else outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0))
                inFlow === outFlow
              }
          conj(consistentFormulas)
        }
    )

    // every transtion term should greater than 0
    val transtionTerms = transTermMap.map(_._2).toSeq
    transtionTerms.foreach { term =>
      consistentFlowFormula = conj(consistentFlowFormula, term >= 0)
    }
    /////////////////////////////////////////////////////////////////////////////////

    // connection //////////////////////////////////////////////////////////////////
    val zVarInitFormulas = aut.transitionsWithTerm.map {
      case (from, _, _, tTerm) =>
        if (from == aut.initialState)
          (zTerm(from) === 0)
        else
          (tTerm === 0) | (zTerm(from) > 0)
    }

    val connectFormulas = states.map {
      case s if s != aut.initialState =>
        (zTerm(s) === 0) | disj(
          preStatesWithTTerm(s).map { case (from, tTerm) =>
            if (from == aut.initialState)
              conj(tTerm > 0, zTerm(s) === 1)
            else
              conj(
                zTerm(from) > 0,
                tTerm > 0,
                zTerm(s) === zTerm(from) + 1
              )
          }
        )
      case _ => Conjunction.TRUE
    }

    val connectionFormula = conj(zVarInitFormulas ++ connectFormulas)
    /////////////////////////////////////////////////////////////////////////////////

    // registers update formula ////////////////////////////////////////////////////
    // registers update map
    val registerUpdateMap: Map[Term, ArrayBuffer[LinearCombination]] = {
      val registerUpdateMap = new MHashMap[Term, ArrayBuffer[LinearCombination]]
      val transitionsWithVector: Iterator[(State, TLabel, State, Seq[Int])] =
        for (
          s <- states.iterator;
          (to, label, vec) <- aut.outgoingTransitionsWithVec(s)
        )
          yield (
            (
              s,
              label,
              to,
              vec
            )
          )
      transitionsWithVector.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transTermMap(from, lbl, to)
        vec.zipWithIndex.foreach {
          case (veci, i) => {
            val registerTerm = registers(i)
            val update =
              registerUpdateMap.getOrElseUpdate(
                registerTerm,
                new ArrayBuffer[LinearCombination]
              )
            update.append(trasitionTerm * veci)
          }
        }
      }
      registerUpdateMap.toMap
    }

    val registerUpdateFormula = conj(
      for ((registerTerm, update) <- registerUpdateMap)
        yield {
          registerTerm === update.reduce(_ + _)
        }
    )

    /////////////////////////////////////////////////////////////////////////////////

    conj(registerUpdateFormula, consistentFlowFormula, connectionFormula)
  }

}
