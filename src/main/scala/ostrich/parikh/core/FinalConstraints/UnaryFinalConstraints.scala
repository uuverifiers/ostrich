package ostrich.parikh.core

import ap.terfor.Formula
import ap.terfor.Term
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.ParikhUtil
import ostrich.parikh.OstrichConfig
import ostrich.parikh.automata.CEBasicOperations

class UnaryFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  // eagerly product
  lazy val productAut = getAutomata.reduce(_ product _)

  lazy val mostlySimplifiedAut = {
    CEBasicOperations.minimizeHopcroftByVec(
      CEBasicOperations.determinateByVec(
        CEBasicOperations.epsilonClosureByVec(
          productAut
        )
      )
    )
  }

  lazy val simplifyButRemainLabelAut =
    CEBasicOperations.removeUselessTrans(
      CEBasicOperations.minimizeHopcroft(
        productAut 
      )
    )

  lazy val checkSatAut = if(OstrichConfig.simplifyAut) mostlySimplifiedAut else productAut
  lazy val findModelAut = if(OstrichConfig.simplifyAut) simplifyButRemainLabelAut else productAut 
  
  def getUnderApprox(bound: Int): Formula =
    new UnaryHeuristicAC(checkSatAut).getUnderApprox(bound)

  def getOverApprox: Formula =
    new UnaryHeuristicAC(checkSatAut).getOverApprox

  def getCompleteLIA: Formula =
    new UnaryHeuristicAC(checkSatAut).getCompleteLIA

  def getRegsRelation: Formula =
    new UnaryHeuristicAC(checkSatAut).getRegsRelation

  val interestTerms: Seq[Term] = productAut.registers

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(
      Seq(findModelAut),
      registersModel
    )
  }

  if (OstrichConfig.debug) {
    productAut.toDot("product_" + strId.toString)
    mostlySimplifiedAut.toDot("simplified_" + strId.toString)
    simplifyButRemainLabelAut.toDot("original_" + strId.toString)
  }

}
