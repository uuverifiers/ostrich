package ostrich.ceasolver.core

import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.ceasolver.util.ParikhUtil
import ostrich.ceasolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._

class CatraFinalConstraints(
    override val strId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints {

  val interestTerms: Seq[ITerm] = auts.flatMap(_.registers)

  
  def getRegsRelation: IFormula = and(auts.map(_.regsRelation))

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(auts, registersModel)
  }
}