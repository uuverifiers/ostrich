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

object FinalConstraints {

  private var finalLIA = Conjunction.TRUE

  private var str2IntList = Seq[(IExpression, IExpression, Int)]()

  def apply() = finalLIA

  def conjFormula(f: Formula) = finalLIA = conj(finalLIA, f)

  def addStr2IntPred(str: IExpression, int: IExpression, strlen: Int) =
    str2IntList = str2IntList :+ (str, int, strlen)

  def unaryHeuristicACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonBase]
  ): UnaryFinalConstraints = {
    val atomConstraints = auts.map(new UnaryHeuristicAC(_))
    new UnaryFinalConstraints(t, atomConstraints)
  }

  def baselineACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonBase]
  ): BaselineFinalConstraints = {
    val atomConstraints = auts.map(new BaselineAC(_))
    new BaselineFinalConstraints(t, atomConstraints)
  }

  def catraACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonBase]
  ): CatraFinalConstraints = {
    val atomConstraints = auts.map(new CatraAC(_))
    new CatraFinalConstraints(t, atomConstraints)
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

  val strId: Term

  val atoms: Seq[AtomConstraint]

  val interestTerms: Seq[Term]

  def getModel: Option[Seq[Int]]

  protected var interestTermsModel: Map[Term, IdealInt] = Map()

  def getRegsRelation: Formula

  def getAutomata = atoms.map(_.aut)

  def setInterestTermModel(partialModel: PartialModel): Unit =
    for (term <- interestTerms)
      interestTermsModel += (term -> evalTerm(term, partialModel))

  def setInterestTermModel(termModel: Map[ConstantTerm, IdealInt]): Unit =
    for (term <- interestTerms)
      interestTermsModel = interestTermsModel + (term -> termModel(
        term.asInstanceOf[ConstantTerm]
      ))
}
