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
    flags: OFlags
) extends BaselineFinalConstraints(strDataBaseId, auts) {

  private val productAut = auts.reduce(_ product _)

  private lazy val simplifiedByVec = {
    if (productAut.registers.isEmpty) simplified
    else {
      val ceAut = CEBasicOperations.minimizeHopcroftByVec(
        productAut
      )
      ceAut.removeDuplicatedReg()
      ceAut
    }
  }

  private lazy val simplified = {
    val ceAut = CEBasicOperations.removeDuplicatedTrans(
      CEBasicOperations.minimizeHopcroft(
        productAut
      )
    )
    ceAut.removeDuplicatedReg()
    ceAut
  }

  ParikhUtil.debugPrintln(
    "ISSUE: In some cases, the product of automata is too large to minimize"
  )

  private val checkSatAut =
    if (flags.simplifyAut) simplifiedByVec else productAut
  private val findModelAut =
    if (flags.simplifyAut) simplified else productAut

  simplified.toDot(strDataBaseId.toString + "_simplified")
  simplifiedByVec.toDot(strDataBaseId.toString + "_simplifiedByVec")

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
