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
import ostrich.parikh.OstrichConfig
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.automata.CEBasicOperations
import ostrich.parikh.automata.CostEnrichedAutomaton

trait AtomConstraint {

  type State = CostEnrichedAutomatonTrait#State

  type TLabel = CostEnrichedAutomatonTrait#TLabel

  val aut: CostEnrichedAutomatonTrait

  /** Parikh image of this automaton, using algorithm in Verma et al, CADE 2005.
    * Encode the formula of registers meanwhile.
    */
  def getCompleteLIA: Formula = {
    def outFlowTerms(from: State): Seq[Term] = {
      val outFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.outgoingTransitions(from).foreach { case (to, lbl) =>
        outFlowTerms += aut.getTransTermMap(from, lbl, to)
      }
      outFlowTerms.toSeq
    }

    def inFlowTerms(to: State): Seq[Term] = {
      val inFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      aut.incomingTransitions(to).foreach { case (from, lbl) =>
        inFlowTerms += aut.getTransTermMap(from, lbl, to)
      }
      inFlowTerms.toSeq
    }

    val zTerm = aut.states.map((_, ZTerm())).toMap

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
    val transtionTerms = aut.getTransTermMap.map(_._2).toSeq
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
      val transitionsWithVector: Iterator[(State, TLabel, State, Seq[Int])] =
        for (
          s <- aut.states.iterator;
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
        val trasitionTerm = aut.getTransTermMap(from, lbl, to)
        vec.zipWithIndex.foreach {
          case (veci, i) => {
            val registerTerm = aut.getRegisters(i)
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





