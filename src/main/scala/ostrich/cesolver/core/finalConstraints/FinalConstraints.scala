package ostrich.cesolver.core.finalConstraints


import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.parser.IConstant
import ap.parser.IExpression
import ap.parser.IExpression._
import ap.parser.IFormula
import ap.parser.ITerm
import ap.terfor.ConstantTerm
import ap.terfor.OneTerm
import ostrich.OFlags
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.util.TermGenerator

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.{HashMap => MHashMap}
import scala.collection.mutable.{HashSet => MHashSet}

object FinalConstraints {

  private val termGen = TermGenerator()

  def unaryHeuristicACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): UnaryFinalConstraints = {
    new UnaryFinalConstraints(t, auts, flags)
  }

  def baselineACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase]
  ): BaselineFinalConstraints = {
    new BaselineFinalConstraints(t, auts)
  }

  def catraACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase]
  ): CatraFinalConstraints = {
    new CatraFinalConstraints(t, auts)
  }

  def nuxmvACs(
    t: ITerm,
    auts: Seq[CostEnrichedAutomatonBase]
  ): NuxmvFinalConstraints = {
    new NuxmvFinalConstraints(t, auts)
  }

  def evalTerm(t: ITerm, model: PartialModel): IdealInt = {
    var value = evalTerm(t)(model)
    if (!value.isDefined) {
      // TODO: NEED NEW FEATURE!
      // Do not generate model of variables without constraints now
      throw new Exception("ITerm " + t + " is not defined in the model")
    }
    value.get
  }

  def evalTerm(t: ITerm)(model: PartialModel): Option[IdealInt] = t match {
    case _: ITerm =>
      model eval t
  }
}

import FinalConstraints._
trait FinalConstraints {
  type State = CostEnrichedAutomatonBase#State

  val strDataBaseId: ITerm

  val auts: Seq[CostEnrichedAutomatonBase]

  val regsTerms: Seq[ITerm]

  def getModel: Option[Seq[Int]]

  protected var regTermsModel: Map[ITerm, IdealInt] = Map()
  // accessors and mutators
  def getRegsRelation: IFormula

  def getRegisters = auts.flatMap(_.registers)

  def setRegTermsModel(partialModel: PartialModel): Unit = {
    regTermsModel = Map()
    for (term <- getRegisters)
      regTermsModel += (term -> evalTerm(term, partialModel))
  }

  def setRegTermsModel(termModel: Map[ITerm, IdealInt]): Unit = {
    regTermsModel = Map()
    for (term <- getRegisters)
      regTermsModel += (term -> termModel(term))
  }

  lazy val getCompleteLIA: IFormula = getCompleteLIA(auts.reduce(_ product _))

  def getCompleteLIA(aut: CostEnrichedAutomatonBase): IFormula = {
    ParikhUtil.debugPrintln("getCompleteLIA")
    lazy val transtion2Term =
      aut.transitionsWithVec.map(t => (t, termGen.transitionTerm)).toMap
    def outFlowTerms(from: State): Seq[ITerm] = {
      val outFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
      aut.outgoingTransitionsWithVec(from).foreach { case (to, lbl, vec) =>
        outFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      outFlowTerms.toSeq
    }

    def inFlowTerms(to: State): Seq[ITerm] = {
      val inFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
      aut.incomingTransitionsWithVec(to).foreach { case (from, lbl, vec) =>
        inFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      inFlowTerms.toSeq
    }

    val zTerm = aut.states.map((_, termGen.zTerm)).toMap

    val preStatesWithTTerm = new MHashMap[State, MHashSet[(State, ITerm)]]
    for ((from, lbl, to, vec) <- aut.transitionsWithVec) {
      val set = preStatesWithTTerm.getOrElseUpdate(to, new MHashSet)
      val tTerm = transtion2Term(from, lbl, to, vec)
      set += ((from, tTerm))
    }
    // consistent flow ///////////////////////////////////////////////////////////////
    var consistentFlowFormula = or(
      for (acceptState <- aut.acceptingStates)
        yield {
          val consistentFormulas =
            for (s <- aut.states)
              yield {
                val inFlow =
                  if (s == aut.initialState)
                    inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0)) + i(
                      1
                    )
                  else inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
                val outFlow =
                  if (s == acceptState)
                    outFlowTerms(s)
                      .reduceLeftOption(_ + _)
                      .getOrElse(i(0)) + i(1)
                  else outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
                inFlow === outFlow
              }
          and(consistentFormulas)
        }
    )

    // every transtion term should greater than 0
    val transtionTerms = transtion2Term.map(_._2).toSeq
    transtionTerms.foreach { term =>
      consistentFlowFormula = and(Seq(consistentFlowFormula, term >= 0))
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
        (zTerm(s) === 0) | or(
          preStatesWithTTerm(s).map { case (from, tTerm) =>
            if (from == aut.initialState)
              and(Seq(tTerm > 0, zTerm(s) === 1))
            else
              and(
                Seq(
                  zTerm(from) > 0,
                  tTerm > 0,
                  zTerm(s) === zTerm(from) + 1
                )
              )
          }
        )
      case _ => IExpression.Boolean2IFormula(true)
    }

    val connectionFormula = and(zVarInitFormulas ++ connectFormulas)
    /////////////////////////////////////////////////////////////////////////////////

    // registers update formula ////////////////////////////////////////////////////
    // registers update map
    val registerUpdateMap: Map[ITerm, ArrayBuffer[ITerm]] = {
      val registerUpdateMap =
        new MHashMap[ITerm, ArrayBuffer[ITerm]]
      aut.transitionsWithVec.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transtion2Term(from, lbl, to, vec)
        vec.zipWithIndex.foreach {
          case (veci, i) => {
            val update =
              registerUpdateMap.getOrElseUpdate(
                aut.registers(i),
                new ArrayBuffer[ITerm]
              )
            update.append(trasitionTerm * veci)
          }
        }
      }
      registerUpdateMap.toMap
    }

    val registerUpdateFormula =
      if (registerUpdateMap.size == 0)
        and(for (r <- aut.registers) yield r === 0)
      else
        and(
          for ((r, update) <- registerUpdateMap)
            yield {
              r === update.reduce { (t1, t2) => sum(Seq(t1, t2)) }
            }
        )

    /////////////////////////////////////////////////////////////////////////////////
    and(
      Seq(
        registerUpdateFormula,
        consistentFlowFormula,
        connectionFormula,
        getRegsRelation
      )
    )
  }
}
