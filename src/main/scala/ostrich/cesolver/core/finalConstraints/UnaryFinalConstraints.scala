package ostrich.cesolver.core.finalConstraints

import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.automata.CEBasicOperations
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.OFlags
import ap.parser.ITerm
import ap.parser.IFormula

class UnaryFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase],
    flags : OFlags
) extends BaselineFinalConstraints(strDataBaseId, auts) {

  private val productAut = auts.reduce(_ product _)

  private lazy val mostlySimplifiedAut = {
    val ceAut = CEBasicOperations.minimizeHopcroftByVec(
      CEBasicOperations.determinateByVec(
        CEBasicOperations.epsilonClosureByVec(
          productAut
        )
      )
    )
    ceAut.removeDuplicatedReg()
    ceAut
  }

  private lazy val simplifyButRemainLabelAut = {
    val ceAut = CEBasicOperations.removeDuplicatedTrans(
      CEBasicOperations.minimizeHopcroft(
        productAut
      )
    )
    ceAut.removeDuplicatedReg()
    ceAut
  }

  ParikhUtil.debugPrintln("ISSUE: the product automaton is too large to minimize, for some timeout instances of pyex suite")  

  private  val checkSatAut =
    if (flags.simplifyAut) mostlySimplifiedAut else productAut
  private  val findModelAut =
    if (flags.simplifyAut) simplifyButRemainLabelAut else productAut

  simplifyButRemainLabelAut.toDot(strDataBaseId.toString + "_simplifyButRemainLabelAut")
  mostlySimplifiedAut.toDot(strDataBaseId.toString + "_mostlySimplifiedAut")

  override lazy val getCompleteLIA: IFormula = {
    getCompleteLIA(checkSatAut)
  }

  override def getRegsRelation: IFormula = checkSatAut.regsRelation

  override def getModel: Option[Seq[Int]] = {
    ParikhUtil.findAcceptedWordByRegisters(
      Seq(findModelAut),
      regTermsModel
    )
  }
}
