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
  lazy val productAtom: AtomConstraint = {
    val productAut = getAutomata.reduce(_ product _)
    new UnaryHeuristicAC(productAut)
  }

  lazy val mostlySimplifiedAut = {
    CEBasicOperations.minimizeHopcroftByVec(
      CEBasicOperations.determinateByVec(
        CEBasicOperations.epsilonClosureByVec(
          productAtom.aut
        )
      )
    )
  }

  lazy val simplifyButRemainLabelAut =
    CEBasicOperations.removeUselessTrans(
      CEBasicOperations.minimizeHopcroft(
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

  val interestTerms: Seq[Term] = productAtom.aut.registers

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(
      Seq(simplifyButRemainLabelAut),
      registersModel
    )
  }

  if (OstrichConfig.outputdot) {
    mostlySimplifiedAut.toDot("simplified_" + strId.toString)
    simplifyButRemainLabelAut.toDot("original_" + strId.toString)
  }

}
