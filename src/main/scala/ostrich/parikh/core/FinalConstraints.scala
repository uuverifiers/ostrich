package ostrich.parikh.core

import ap.terfor.Formula
import ostrich.parikh.automata.CostEnrichedAutomaton
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
import ostrich.parikh.automata.CEBasicOperations
import ap.terfor.conjunctions.Conjunction
import shapeless.Fin
import ostrich.parikh.automata.CostEnrichedAutomatonTrait

object FinalConstraints {

  private var finalLIA = Conjunction.TRUE

  def apply() = finalLIA

  def conjFormula(f: Formula) = finalLIA = conj(finalLIA, f)

  def unaryHeuristicACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonTrait]
  ): UnaryFinalConstraints = {
    val atomConstraints = auts.map(new UnaryHeuristicAC(_))
    new UnaryFinalConstraints(t, atomConstraints)
  }

  def baselineACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonTrait]
  ): BaselineFinalConstraints = {
    val atomConstraints = auts.map(new ParikhAC(_))
    new BaselineFinalConstraints(t, atomConstraints)
  }

  def catraACs(
      t: Term,
      auts: Seq[CostEnrichedAutomatonTrait]
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

class UnaryFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  // eagerly product, which means compute lia after producting
  lazy val productAtom: AtomConstraint = {
    val productAut = getAutomata.reduce(_ product _)
    val simplifyAut = CEBasicOperations.simplify(productAut)
    new UnaryHeuristicAC(simplifyAut)
  }

  lazy val mostlySimplifiedAut =
    CEBasicOperations.determinateByVec(
      CEBasicOperations.epsilonClosureByVec(
        productAtom.aut
      )
    )

  def getUnderApprox(bound: Int): Formula =
    new UnaryHeuristicAC(mostlySimplifiedAut).getUnderApprox(bound)

  def getOverApprox: Formula =
    new UnaryHeuristicAC(mostlySimplifiedAut).getOverApprox

  def getCompleteLIA: Formula =
    new UnaryHeuristicAC(mostlySimplifiedAut).getCompleteLIA

  def getRegsRelation: Formula =
    new UnaryHeuristicAC(mostlySimplifiedAut).getRegsRelation

  val interestTerms: Seq[Term] = productAtom.aut.getRegisters

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(Seq(productAtom.aut), registersModel)
  }

  if (Config.outputdot) mostlySimplifiedAut.toDot(strId.toString)

}

class BaselineFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  // eagerly product, which means compute lia after producting
  lazy val productAtom = new ParikhAC(getAutomata.reduceLeft(_ product _))

  def getCompleteLIA: Formula = productAtom.getCompleteLIA

  def getRegsRelation: Formula = productAtom.getRegsRelation

  val interestTerms: Seq[Term] = productAtom.aut.getTransTermMap.map(_._2).toSeq

  def getModel: Option[Seq[Int]] = {
    val transtionModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByTranstions(
      Seq(productAtom.aut),
      transtionModel
    )
  }
}

class CatraFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  // eagerly product, which means compute lia after producting
  lazy val productAtom = new ParikhAC(getAutomata.reduceLeft(_ product _))

  def getRegsRelation: Formula = productAtom.getRegsRelation

  val interestTerms: Seq[Term] = atoms.map(_.aut).flatMap(_.getRegisters)

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(Seq(productAtom.aut), registersModel)
  }
}
