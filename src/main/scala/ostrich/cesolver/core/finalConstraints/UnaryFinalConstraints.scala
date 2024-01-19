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
    if (productAut.registers.isEmpty) {
      simplified
    } else {
      CEBasicOperations.minimizeHopcroftByVec(
        productAut
      )
    }
  }

  private lazy val simplified = {
    CEBasicOperations.minimizeHopcroft(
      productAut
    )
  }

  ParikhUtil.debugPrintln("The productAut: " + productAut)

  private lazy val checkSatAut = simplifiedByVec
  private lazy val findModelAut =
    if (flags.minimizeAutomata) simplified else productAut

  simplified.toDot(strDataBaseId.toString + "_unary_simplified")
  simplifiedByVec.toDot(strDataBaseId.toString + "_unary_simplifiedByVec")
  ParikhUtil.log("The checkSatAut: " + checkSatAut)
  ParikhUtil.log("The findModelAut: " + findModelAut)

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
