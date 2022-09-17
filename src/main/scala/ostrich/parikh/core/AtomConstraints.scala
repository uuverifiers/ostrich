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
import shapeless.ops.product

object AtomConstraints {
  import AtomConstraint._
  def unaryHeuristicACs(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): UnaryHeuristicACs = {
    val atomConstraints = auts.map(unaryHeuristicAC(_))
    new UnaryHeuristicACs(t, atomConstraints)
  }

  def evalTerm(t : Term)(model : PartialModel)
                      : Option[IdealInt] = t match {
    case c : ConstantTerm =>
      model eval c
    case OneTerm =>
      Some(IdealInt.ONE)
    case lc : LinearCombination => {
      val terms = for ((coeff, t) <- lc) yield (coeff, evalTerm(t)(model))
      if (terms forall { case (_, None) => false
                         case _ => true })
        Some((for ((coeff, Some(v)) <- terms) yield (coeff * v)).sum)
      else
        None
    }
  }
}

import AtomConstraints._
trait AtomConstraints {

  protected val t: Term

  protected var interestTermsModel: Map[Term, Int] = Map()

  protected val atoms: Seq[AtomConstraint]

  protected val interestTerms: Seq[Term]

  def getOverApprox: Formula

  def getLinearAbs: Formula

  def getRegsRelation: Formula

  def getModel: Seq[Int]

  def getTerm: Term = t

  def setTermModel(partialModel: PartialModel): Unit = {
    for (term <- interestTerms) {
      val value = evalTerm(term)(partialModel)
      if(!value.isDefined) throw new Exception("Term " + term + " is not defined in the model")
      interestTermsModel += (term -> value.get.intValue)
    }
  }
}

class UnaryHeuristicACs(
    override protected val t: Term,
    override protected val atoms: Seq[AtomConstraint]
) extends AtomConstraints {

  protected val interestTerms: Seq[Term] = atoms.map(_.registers).flatten

  def getOverApprox: Formula = atoms.reduceLeft(_ product _).getOverApprox

  def getLinearAbs: Formula = atoms.reduceLeft(_ product _).getLinearAbs

  def getRegsRelation: Formula = conj(atoms.map(_.getRegsRelation))
  def getModel: Seq[Int] = {
    Seq(1)
  }

}

// class TransTermModeledSC(automata: Seq[CostEnrichedAutomatonTrait])
//     extends StringConstraints {

//   def getInterestingTerms: Set[Term] =
//     automata.flatMap(getTransitionsTerms(_)).toSet

// }
