package ostrich.parikh.core

import ap.terfor.Formula
import ap.terfor.Term
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.terfor.ConstantTerm
import ap.terfor.OneTerm
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.conjunctions.Conjunction
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ap.parser.IExpression
import ostrich.parikh.TransitionTerm
import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap, HashSet => MHashSet}
import ostrich.parikh.ZTerm
import ostrich.OFlags

object FinalConstraints {

  private var finalLIA = Conjunction.TRUE

  private var str2IntList = Seq[(IExpression, IExpression, Int)]()

  def apply() = finalLIA

  def reset() = {
    finalLIA = Conjunction.TRUE
    str2IntList = Seq[(IExpression, IExpression, Int)]()
  }

  def conjFormula(f: Formula) = finalLIA = conj(finalLIA, f)

  def addStr2IntPred(str: IExpression, int: IExpression, strlen: Int) =
    str2IntList = str2IntList :+ (str, int, strlen)

  def unaryHeuristicACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): UnaryFinalConstraints = {
    new UnaryFinalConstraints(t, auts, flags)
  }

  def baselineACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonBase]
  ): BaselineFinalConstraints = {
    new BaselineFinalConstraints(t, auts)
  }

  def catraACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonBase]
  ): CatraFinalConstraints = {
    new CatraFinalConstraints(t, auts)
  }

  def evalTerm(t: Term, model: PartialModel): IdealInt = {
    var value = evalTerm(t)(model)
    if (!value.isDefined) {
      // TODO: NEED NEW FEATURE!
      // Do not generate model of variables without constraints now
      throw new Exception("Term " + t + " is not defined in the model")
    }
    value.get
  }

  def evalTerm(t: Term)(model: PartialModel): Option[IdealInt] = t match {
    case c: ConstantTerm =>
      model eval c
    case OneTerm =>
      Some(IdealInt.ONE)
    case lc: LinearCombination => {
      val terms = for ((coeff, t) <- lc) yield (coeff, evalTerm(t)(model))
      if (
        terms forall {
          case (_, None) => false
          case _         => true
        }
      )
        Some((for ((coeff, Some(v)) <- terms) yield (coeff * v)).sum)
      else
        None
    }
  }
}

import FinalConstraints._
trait FinalConstraints {
  type State = CostEnrichedAutomatonBase#State

  val strId: Term

  val auts: Seq[CostEnrichedAutomatonBase]

  val interestTerms: Seq[Term]

  def getModel: Option[Seq[Int]]

  protected var interestTermsModel: Map[Term, IdealInt] = Map()
  // accessors and mutators
  def getRegsRelation: Formula

  def setInterestTermModel(partialModel: PartialModel): Unit =
    for (term <- interestTerms)
      interestTermsModel += (term -> evalTerm(term, partialModel))

  def setInterestTermModel(termModel: Map[Term, IdealInt]): Unit =
    for (term <- interestTerms)
      interestTermsModel = interestTermsModel + (term -> termModel(term))

  lazy val getCompleteLIA: Formula = getCompleteLIA(auts.reduce(_ product _))

  def getCompleteLIA(aut: CostEnrichedAutomatonBase): Formula = {
    lazy val transtion2Term =
      aut.transitionsWithVec.map(t => (t, TransitionTerm())).toMap
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
            val registeri = aut.registers(i)
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
        conj(for (r <- aut.registers) yield r === 0)
      else
        conj(
          for ((r, update) <- registerUpdateMap)
            yield {
              r === update.reduce(_ + _)
            }
        )

    /////////////////////////////////////////////////////////////////////////////////
    conj(registerUpdateFormula, consistentFlowFormula, connectionFormula, getRegsRelation)
  }
}
