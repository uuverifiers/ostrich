package ostrich.cesolver.core.finalConstraints

import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.automata.CEBasicOperations
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import scala.collection.mutable.ArrayBuffer
import ostrich.OFlags
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._

class UnaryFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase],
    flags : OFlags
) extends BaselineFinalConstraints(strDataBaseId, auts) {
  private val productAut = auts.reduce(_ product _)

  private val mostlySimplifiedAut = {
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

  private val simplifyButRemainLabelAut = {
    val ceAut = CEBasicOperations.removeDuplicatedTrans(
      CEBasicOperations.minimizeHopcroft(
        productAut
      )
    )
    ceAut.removeDuplicatedReg()
    ceAut
  }
    

  private  val checkSatAut =
    if (flags.simplifyAut) mostlySimplifiedAut else productAut
  private  val findModelAut =
    if (flags.simplifyAut) simplifyButRemainLabelAut else productAut

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
