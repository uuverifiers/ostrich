package ostrich.parikh.core

import ap.terfor.Formula
import ap.terfor.Term
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.ParikhUtil
import ostrich.parikh.automata.CEBasicOperations

class BaselineFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  lazy val productAtom: AtomConstraint = {
    val productAut = getAutomata.reduce(_ product _)
    val simplifyAut = CEBasicOperations.simplify(productAut)
    new UnaryHeuristicAC(simplifyAut)
  }

  lazy val mostlySimplifiedAut = {
    val res =
      CEBasicOperations.minimizeHopcroftByVec(
        CEBasicOperations.determinateByVec(
          CEBasicOperations.epsilonClosureByVec(
            productAtom.aut
          )
        )
      )
    res
  }

  lazy val simplifyButRemainLabelAut =
    CEBasicOperations.removeUselessTrans(
      CEBasicOperations.minimizeHopcroft(
        productAtom.aut
      )
    )

  def getCompleteLIA: Formula = 
    new BaselineAC(mostlySimplifiedAut).getCompleteLIA

  def getRegsRelation: Formula = 
    new BaselineAC(mostlySimplifiedAut).getRegsRelation

    val interestTerms: Seq[Term] = productAtom.aut.registers

  def getModel: Option[Seq[Int]] = {
    val transtionModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(
      Seq(simplifyButRemainLabelAut),
      transtionModel
    )
  }
}