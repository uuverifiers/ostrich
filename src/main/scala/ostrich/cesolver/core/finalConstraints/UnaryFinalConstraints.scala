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

  private lazy val findModelAut =
    if (flags.minimizeAutomata)
      CEBasicOperations.minimizeHopcroft(
        productAut
      )
    else productAut
    
  private lazy val checkSatAut = if (productAut.registers.isEmpty) {
    findModelAut
  } else {
    CEBasicOperations.minimizeHopcroftByVec(
      productAut
    )
  }

  ParikhUtil.log("The checkSatAut: " + checkSatAut)
  ParikhUtil.log("The findModelAut: " + findModelAut)

  override lazy val getCompleteLIA: IFormula = {
    getCompleteLIA(checkSatAut)
  }

  override def getRegsRelation: IFormula = checkSatAut.regsRelation

  override def getModel: Option[Seq[Int]] = {
    ParikhUtil.log("Get model of string term " + strDataBaseId)
    val res = ParikhUtil.findAcceptedWordByRegisters(
      Seq(findModelAut),
      regTermsModel
    )
    ParikhUtil.log(s"the model of ${strDataBaseId} is ${res}")
    res
  }
}
