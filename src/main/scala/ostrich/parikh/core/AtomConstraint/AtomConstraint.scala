package ostrich.parikh.core

import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ap.terfor.Formula
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet
}
import ap.terfor.Term
import ap.terfor.conjunctions.Conjunction
import ostrich.parikh.ZTerm
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.TransitionTerm

trait AtomConstraint {

  type State = CostEnrichedAutomatonTrait#State

  type TLabel = CostEnrichedAutomatonTrait#TLabel

  val aut: CostEnrichedAutomatonTrait

  /** Parikh image of this automaton, using algorithm in Verma et al, CADE 2005.
    * Encode the formula of registers meanwhile.
    */
  lazy val getCompleteLIA: Formula = {
    lazy val transtion2Term = aut.transitionsWithVec.map(t => (t, TransitionTerm())).toMap
    def outFlowTerms(from: State): Seq[Term] = {
      val outFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.outgoingTransitionsWithVec(from).foreach { case (to, lbl, vec) =>
        outFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      outFlowTerms.toSeq
    }

    def inFlowTerms(to: State): Seq[Term] = {
      val inFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.incomingTransitionsWithVec(to).foreach { case (from, lbl, vec) =>
        inFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      inFlowTerms.toSeq
    }

    val zTerm = aut.states.map((_, ZTerm())).toMap

    val preStatesWithTTerm = new MHashMap[State, MHashSet[(State, Term)]]
    for ((from, lbl, to, vec) <- aut.transitionsWithVec) {
      val set = preStatesWithTTerm.getOrElseUpdate(to, new MHashSet)
      val tTerm = transtion2Term(from, lbl, to, vec)
      set += ((from, tTerm))
    }
    // consistent flow ///////////////////////////////////////////////////////////////
    var consistentFlowFormula = disj(
      for (acceptState <- aut.acceptingStates)
        yield {
          val consistentFormulas =
            for (s <- aut.states)
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
    val transtionTerms = transtion2Term.map(_._2).toSeq
    transtionTerms.foreach { term =>
      consistentFlowFormula = conj(consistentFlowFormula, term >= 0)
    }
    /////////////////////////////////////////////////////////////////////////////////

    // connection //////////////////////////////////////////////////////////////////
    val zVarInitFormulas = aut.transitionsWithVec.map {
      case (from, lbl, to, vec) => {
        val tTerm = transtion2Term(from, lbl, to, vec)
        if (from == aut.initialState)
          (zTerm(from) === 0)
        else
          (tTerm === 0) | (zTerm(from) > 0)
      }
    }

    val connectFormulas = aut.states.map {
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
      aut.transitionsWithVec.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transtion2Term(from, lbl, to, vec)
        vec.zipWithIndex.foreach {
          case (veci, i) => {
            val registeri = aut.getRegisters(i)
            val update =
              registerUpdateMap.getOrElseUpdate(
                registeri,
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
        conj(for (r <- aut.getRegisters) yield r === 0)
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

}





