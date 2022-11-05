package ostrich.parikh.core

import ostrich.parikh.automata.CostEnrichedAutomatonTrait
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
import ap.terfor.preds.Atom
import ostrich.parikh.util.UnknownException

object AtomConstraint {
  def unaryHeuristicAC(aut: CostEnrichedAutomatonTrait) =
    new UnaryHeuristicAC(aut)

  def parikhAC(aut: CostEnrichedAutomatonTrait) =
    new ParikhAC(aut)

  def catraAC(aut: CostEnrichedAutomatonTrait) =
    new CatraAC(aut)
}

trait AtomConstraint {

  type State = CostEnrichedAutomatonTrait#State

  type TLabel = CostEnrichedAutomatonTrait#TLabel

  val aut: CostEnrichedAutomatonTrait

  val states = aut.states

  val registers: Seq[Term] = aut.getRegisters

  val etaMap: Map[(State, TLabel, State), Seq[Int]] = aut.getEtaMap

  val transTermMap: Map[(State, TLabel, State), Term] = aut.getTransTermMap

  def product(that: AtomConstraint): AtomConstraint

  def getUnderApprox: Formula

  def getOverApprox: Formula

  /** Parikh image of this automaton, using algorithm in Verma et al, CADE 2005.
    * Encode the formula of registers meanwhile.
    */
  def getCompleteLIA: Formula = {
    def outFlowTerms(from: State): Seq[Term] = {
      val outFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.outgoingTransitions(from).foreach { case (to, lbl) =>
        outFlowTerms += transTermMap(from, lbl, to)
      }
      outFlowTerms.toSeq
    }

    def inFlowTerms(to: State): Seq[Term] = {
      val inFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.incomingTransitions(to).foreach { case (from, lbl) =>
        inFlowTerms += transTermMap(from, lbl, to)
      }
      inFlowTerms.toSeq
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

    val registerUpdateFormula =
      if (registerUpdateMap.size == 0)
        conj(for (r <- registers) yield r === 0)
      else
        conj(
          for ((r, update) <- registerUpdateMap)
            yield {
              r === update.reduce(_ + _)
            }
        )

    /////////////////////////////////////////////////////////////////////////////////

    conj(registerUpdateFormula, consistentFlowFormula, connectionFormula)
  }

  def getRegsRelation: Formula

}

class UnaryHeuristicAC(val aut: CostEnrichedAutomatonTrait)
    extends AtomConstraint {

  def product(that: AtomConstraint): AtomConstraint = {
    new UnaryHeuristicAC(that.aut & aut)
  }

  def getUnderApprox: Formula = {
    // We return True when this automaton do not have registers
    // (which means there is only regex membership)
    if (aut.getRegisters.isEmpty)
      return Conjunction.TRUE
    val n = aut.states.size
    val rLen = aut.getRegisters.size
    val kSet = new MHashSet[Term]
    val concreteLenBound = if (n < 10) 10 * n else 100;
    val s = computeS(concreteLenBound)
    val t = computeT(n)
    val registers = aut.getRegisters

    // val r2Formula = disjFor(
    //   for (
    //     d <- 1 until n + 1;
    //     i <- d until n + 1;
    //     (from, regVal) <- s(i);
    //     (period, loopVec) <- periods(from);
    //     (to, tailVec) <- t(n - i);
    //     if (period == d && from == to)
    //   ) yield {
    //     val k = KTerm()
    //     kSet += k
    //     conj(
    //       for (i <- 0 until rLen)
    //         yield registers(i) === regVal(i) + k * loopVec(i) + tailVec(i)
    //     )
    //   }
    // )
    val r1Formula = disjFor(
      for (
        j <- 0 until concreteLenBound;
        if !s(j).isEmpty;
        (s, regVal) <- s(j);
        if (aut.isAccept(s))
      ) yield {
        conj(for (i <- 0 until registers.size) yield registers(i) === regVal(i))
      }
    )
    r1Formula
  }

  def getOverApprox: Formula = {
    // MORE TEST: maybe bug
    val n = states.size
    val rLen = registers.size
    val concreteLen = 2 * n * n + n
    val kSet = new MHashSet[Term]

    val s = computeS(concreteLen)
    val t = computeT(2 * n * n - n)

    val overapprox = conj(
      for (i <- 0 until rLen) yield {
        disj {
          val r1Formula = disjFor(
            for (
              j <- 0 until concreteLen;
              if !s(j).isEmpty;
              (s, regVal) <- s(j);
              if (aut.isAccept(s))
            ) yield {
              registers(i) === regVal(i)
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
              registers(i) === regVal(i) + k * loopVec(i) + tailVec(i)
            }
          )
          Seq(r1Formula, r2Formula)
        }
      }
    )

    val kFormula = conj(
      for (k <- kSet) yield {
        k >= 1
      }
    )
    conj(overapprox, kFormula)
    // val r1Formula = disjFor(
    //   for (
    //     j <- 0 until concreteLen;
    //     if !s(j).isEmpty;
    //     (s, regVal) <- s(j);
    //     if (aut.isAccept(s))
    //   ) yield {
    //     conj(for (i <- 0 until rLen) yield registers(i) === regVal(i))
    //   }
    // )

    // val r2Formula = disjFor(
    //   for (
    //     d <- 1 until n + 1;
    //     c <- 2 * n * n - d until 2 * n * n;
    //     (from, regVal) <- s(n);
    //     (period, loopVec) <- periods(from);
    //     (to, tailVec) <- t(c - n);
    //     if (period == d && from == to)
    //   ) yield {
    //     val k = KTerm()
    //     kSet += k
    //     conj(
    //       for (i <- 0 until rLen)
    //         yield registers(i) === regVal(i) + k * loopVec(i) + tailVec(i)
    //     )
    //   }
    // )

    // val kFormula = conj(
    //   for (k <- kSet) yield {
    //     k >= 1
    //   }
    // )

    // disj(r1Formula, conj(r2Formula, kFormula))

  }

  override def getCompleteLIA: Formula = {
    // Throw unkonwn exception to see how many instance can not be checked by approximation
    throw UnknownException(
      "UnaryHeuristicAC.getCompleteLIA: over- and under-approximation fail"
    )
  }

  def getRegsRelation: Formula = aut.getRegsRelation

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

  /** computing T_len, T_{len-1}, ..., T_0. Terminate if T_(2n^2-n-1) is
    * computed or pre(S_i) is empty
    */
  def computeT(len: Int): ArrayBuffer[Set[(State, Seq[Int])]] = {
    val n = aut.states.size
    val acceptingStates = aut.acceptingStates
    val rLen = aut.getRegisters.size
    val T = ArrayBuffer.fill(len)(Set[(State, Seq[Int])]())
    T(0) = acceptingStates.map((_, Seq.fill(rLen)(0)))
    var idx = 0
    while (idx < len - 1 && !T(idx).isEmpty) {
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
    val rLen = aut.getRegisters.size

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

// TODO: BUG!! Bug occurs when running benchmark `bigSubStrIdx.smt2`

class ParikhAC(val aut: CostEnrichedAutomatonTrait) extends AtomConstraint {

  def product(that: AtomConstraint): AtomConstraint = {
    new ParikhAC(aut & that.aut)
  }
  def getUnderApprox: Formula = Conjunction.FALSE

  def getOverApprox: Formula = Conjunction.TRUE

  def getRegsRelation: Formula = aut.getRegsRelation

}

class CatraAC(override val aut: CostEnrichedAutomatonTrait)
    extends ParikhAC(aut)
