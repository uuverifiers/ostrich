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
) extends FinalConstraints {
  val productAut = auts.reduce(_ product _)

  val mostlySimplifiedAut = {
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

  val simplifyButRemainLabelAut = {
    val ceAut = CEBasicOperations.removeDuplicatedTrans(
      CEBasicOperations.minimizeHopcroft(
        productAut
      )
    )
    ceAut.removeDuplicatedReg()
    ceAut
  }
    

  lazy val checkSatAut =
    if (flags.simplifyAut) mostlySimplifiedAut else productAut
  lazy val findModelAut =
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

  if (flags.debug) {
    productAut.toDot("product_" + strDataBaseId.toString)
    mostlySimplifiedAut.toDot("simplified_" + strDataBaseId.toString)
    simplifyButRemainLabelAut.toDot("simplified_remainlabel_" + strDataBaseId.toString)
  }
}
