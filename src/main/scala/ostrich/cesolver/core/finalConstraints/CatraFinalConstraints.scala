package ostrich.cesolver.core.finalConstraints

import ap.terfor.Formula
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IExpression._
import ap.parser.IFormula
import ostrich.cesolver.util.ParikhUtil


class CatraFinalConstraints(
    override val strId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints {

  val interestTerms: Seq[ITerm] = auts.flatMap(_.registers)

  import ap.terfor.TerForConvenience._
  
  def getRegsRelation: IFormula = and(auts.map(_.regsRelation))

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(auts, registersModel)
  }
}