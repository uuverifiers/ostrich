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

object AtomConstraints {
  import AtomConstraint._
  def unaryHeuristicACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonTrait]
  ): UnaryHeuristicACs = {
    val atomConstraints = auts.map(unaryHeuristicAC(_))
    new UnaryHeuristicACs(t, atomConstraints)
  }

  def parikhACs(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): ParikhACs = {
    val atomConstraints = auts.map(parikhAC(_))
    new ParikhACs(t, atomConstraints)
  }

  def catraACs(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): CatraACs = {
    val atomConstraints = auts.map(catraAC(_))
    new CatraACs(t, atomConstraints)
  }

  def evalTerm(t: Term, model: PartialModel): IdealInt = {
    val value = evalTerm(t)(model)
    if (!value.isDefined)
      throw new Exception("Term " + t + " is not defined in the model")
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

import AtomConstraints._
trait AtomConstraints {

  val strId: Term

  val atoms: Seq[AtomConstraint]

  val interestTerms: Seq[Term]

  def getModel: Seq[Int]

  protected var interestTermsModel: Map[Term, IdealInt] = Map()

  lazy val productAtom: AtomConstraint = atoms.reduceLeft(_ product _)

  def getAutomata = atoms.map(_.aut)

  def getOverApprox: Formula = productAtom.getOverApprox

  def getLinearAbs: Formula = productAtom.getLinearAbs

  def getRegsRelation: Formula = conj(atoms.map(_.getRegsRelation))

  def setInterestTermModel(partialModel: PartialModel): Unit = 
    for (term <- interestTerms) 
      interestTermsModel += (term -> evalTerm(term, partialModel))
}

class UnaryHeuristicACs(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends AtomConstraints {

  val interestTerms: Seq[Term] = productAtom.registers

  def getModel: Seq[Int] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(Seq(productAtom.aut), registersModel).get
  }

}

class ParikhACs(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends AtomConstraints {

  val interestTerms: Seq[Term] = productAtom.transTermMap.map(_._2).toSeq

  def getModel: Seq[Int] = {
    val transtionModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByTranstions(Seq(productAtom.aut), transtionModel).get
  }
}

class CatraACs(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends AtomConstraints {

  val interestTerms: Seq[Term] = atoms.map(_.aut).flatMap(_.getRegisters)

  def getModel: Seq[Int] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(atoms.map(_.aut), registersModel).get
  }
}
