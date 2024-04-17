package ostrich.cesolver.core.finalConstraints

import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression
import ap.parser.IExpression._
import scala.collection.mutable.ArrayBuffer
import ostrich.cesolver.util.TermGenerator
import scala.collection.mutable.{HashSet => MHashSet}
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IBinJunctor

class BaselineFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints {

  private val termGen = TermGenerator()

  lazy val getCompleteLIA: IFormula = {
    connectSimplify(
      ParikhUtil.parikhImage(auts.reduce(_ product _)) +: auts.map(_.regsRelation),
      IBinJunctor.And
    )
  }

  // def ParikhImage(
  //     aut: CostEnrichedAutomatonBase,
  //     explicitTrans2Term: Map[CostEnrichedAutomatonBase#Transition, ITerm] =
  //       Map()
  // ): IFormula = {
  //   ParikhUtil.log(
  //     s"Computing the parikh image of the automaton A${aut.hashCode()}..."
  //   )
  //   lazy val transtion2Term =
  //     if (explicitTrans2Term.nonEmpty) explicitTrans2Term
  //     else
  //       aut.transitionsWithVec.map(t => (t, termGen.transitionTerm)).toMap
  //   def outFlowTerms(from: State): Seq[ITerm] = {
  //     val outFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
  //     aut.outgoingTransitionsWithVec(from).foreach { case (to, lbl, vec) =>
  //       outFlowTerms += transtion2Term(from, lbl, to, vec)
  //     }
  //     outFlowTerms.toSeq
  //   }

  //   def inFlowTerms(to: State): Seq[ITerm] = {
  //     val inFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
  //     aut.incomingTransitionsWithVec(to).foreach { case (from, lbl, vec) =>
  //       inFlowTerms += transtion2Term(from, lbl, to, vec)
  //     }
  //     inFlowTerms.toSeq
  //   }

  //   val zTerm = aut.states.map((_, termGen.zTerm)).toMap

  //   val preStatesWithTTerm = new MHashMap[State, MHashSet[(State, ITerm)]]
  //   for ((from, lbl, to, vec) <- aut.transitionsWithVec) {
  //     val set = preStatesWithTTerm.getOrElseUpdate(to, new MHashSet)
  //     val tTerm = transtion2Term(from, lbl, to, vec)
  //     set += ((from, tTerm))
  //   }
  //   // consistent flow ///////////////////////////////////////////////////////////////
  //   var consistentFlowFormula = or(
  //     for (acceptState <- aut.acceptingStates)
  //       yield {
  //         val consistentFormulas =
  //           for (s <- aut.states)
  //             yield {
  //               val inFlow =
  //                 if (s == aut.initialState)
  //                   inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0)) + i(
  //                     1
  //                   )
  //                 else inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
  //               val outFlow =
  //                 if (s == acceptState)
  //                   outFlowTerms(s)
  //                     .reduceLeftOption(_ + _)
  //                     .getOrElse(i(0)) + i(1)
  //                 else outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
  //               inFlow === outFlow
  //             }
  //         connectSimplify(consistentFormulas, IBinJunctor.And)
  //       }
  //   )

  //   // every transtion term should greater than 0
  //   val transtionTerms = transtion2Term.map(_._2).toSeq
  //   transtionTerms.foreach { term =>
  //     consistentFlowFormula =
  //       connectSimplify(Seq(consistentFlowFormula, term >= 0), IBinJunctor.And)
  //   }
  //   /////////////////////////////////////////////////////////////////////////////////

  //   // connection //////////////////////////////////////////////////////////////////
  //   val zVarInitFormulas = aut.transitionsWithVec.map {
  //     case (from, lbl, to, vec) => {
  //       val tTerm = transtion2Term(from, lbl, to, vec)
  //       if (from == aut.initialState)
  //         (zTerm(from) === 0)
  //       else
  //         (tTerm === 0) | (zTerm(from) > 0)
  //     }
  //   }

  //   val connectFormulas = aut.states.map {
  //     case s if s != aut.initialState =>
  //       (zTerm(s) === 0) | or(
  //         preStatesWithTTerm(s).map { case (from, tTerm) =>
  //           if (from == aut.initialState)
  //             connectSimplify(Seq(tTerm > 0, zTerm(s) === 1), IBinJunctor.And)
  //           else
  //             connectSimplify(
  //               Seq(
  //                 zTerm(from) > 0,
  //                 tTerm > 0,
  //                 zTerm(s) === zTerm(from) + 1
  //               ),
  //               IBinJunctor.And
  //             )
  //         }
  //       )
  //     case _ => IExpression.Boolean2IFormula(true)
  //   }

  //   val connectionFormula =
  //     connectSimplify(zVarInitFormulas ++ connectFormulas, IBinJunctor.And)
  //   /////////////////////////////////////////////////////////////////////////////////

  //   // registers update formula ////////////////////////////////////////////////////
  //   // registers update map
  //   val registerUpdateMap: Map[ITerm, ArrayBuffer[ITerm]] = {
  //     val registerUpdateMap =
  //       new MHashMap[ITerm, ArrayBuffer[ITerm]]
  //     aut.transitionsWithVec.foreach { case (from, lbl, to, vec) =>
  //       val trasitionTerm = transtion2Term(from, lbl, to, vec)
  //       vec.zipWithIndex.foreach {
  //         case (veci, i) => {
  //           val update =
  //             registerUpdateMap.getOrElseUpdate(
  //               aut.registers(i),
  //               new ArrayBuffer[ITerm]
  //             )
  //           update.append(trasitionTerm * veci)
  //         }
  //       }
  //     }
  //     registerUpdateMap.toMap
  //   }

  //   val registerUpdateFormula =
  //     if (registerUpdateMap.size == 0) // empty automaton
  //       connectSimplify(for (r <- aut.registers) yield r === 0, IBinJunctor.And)
  //     else
  //       connectSimplify(
  //         for ((r, update) <- registerUpdateMap)
  //           yield {
  //             r === update.reduce { (t1, t2) => sum(Seq(t1, t2)) }
  //           },
  //         IBinJunctor.And
  //       )

  //   /////////////////////////////////////////////////////////////////////////////////
  //   val parikhImage = connectSimplify(
  //     Seq(
  //       registerUpdateFormula,
  //       consistentFlowFormula,
  //       connectionFormula
  //     ),
  //     IBinJunctor.And
  //   )
  //   ParikhUtil.log(
  //     s"Parikh image of the automaton A${aut.hashCode()} computed."
  //   )
  //   parikhImage
  // }
}
