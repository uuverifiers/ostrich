package ostrich.parikh.core

import ap.terfor.Formula
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ap.terfor.Term
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.terfor.ConstantTerm
import ap.terfor.OneTerm
import ap.terfor.linearcombination.LinearCombination
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.ParikhUtil
import ap.types.SortedConstantTerm
import ostrich.parikh.Config

object FinalConstraints {
  import AtomConstraint._
  def unaryHeuristicACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonTrait]
  ): UnaryFinalConstraints = {
    val atomConstraints = auts.map(unaryHeuristicAC(_))
    new UnaryFinalConstraints(t, atomConstraints)
  }

  def baselineACs(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): BaselineFinalConstraints = {
    val atomConstraints = auts.map(parikhAC(_))
    new BaselineFinalConstraints(t, atomConstraints)
  }

  def catraACs(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): CatraFinalConstraints = {
    val atomConstraints = auts.map(catraAC(_))
    new CatraFinalConstraints(t, atomConstraints)
  }

  def evalTerm(t: Term, model: PartialModel): IdealInt = {
    var value = evalTerm(t)(model)
    if (!value.isDefined){
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

  lazy val productAtom: AtomConstraint = atoms.reduceLeft(_ product _)

  def getAutomata = atoms.map(_.aut)

  def getUnderApprox: Formula = productAtom.getUnderApprox

  def getOverApprox: Formula = productAtom.getOverApprox

  def getCompleteLIA: Formula = productAtom.getCompleteLIA

  def getRegsRelation: Formula = productAtom.getRegsRelation

  def setInterestTermModel(partialModel: PartialModel): Unit = 
    for (term <- interestTerms) 
      interestTermsModel += (term -> evalTerm(term, partialModel))
  
  def setInterestTermModel(termModel: Map[ConstantTerm, IdealInt]): Unit = 
    for (term <- interestTerms) 
      interestTermsModel = interestTermsModel + (term -> termModel(term.asInstanceOf[ConstantTerm]))
}

class UnaryFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  val interestTerms: Seq[Term] = productAtom.registers

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(Seq(productAtom.aut), registersModel)
  }

  if(Config.outputdot)  productAtom.aut.toDot(strId.toString)

}

class BaselineFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  val interestTerms: Seq[Term] = productAtom.transTermMap.map(_._2).toSeq

  def getModel: Option[Seq[Int]] = {
    val transtionModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByTranstions(Seq(productAtom.aut), transtionModel)
  }
}

class CatraFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  val interestTerms: Seq[Term] = atoms.map(_.aut).flatMap(_.getRegisters)

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(Seq(productAtom.aut), registersModel)
  }
}
