package ostrich.cesolver.core.finalConstraints

import scala.collection.mutable.{HashMap => MHashMap}

import ap.parser.{ITerm, IFormula}
import ap.parser.IExpression._

import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.util.ParikhUtil

class NuxmvFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints {

  val regsTerms: Seq[ITerm] = auts.flatMap(_.registers)

  import ap.terfor.TerForConvenience._
  
  def getRegsRelation: IFormula = and(auts.map(_.regsRelation))

  def getModel: Option[Seq[Int]] = {
    ParikhUtil.findAcceptedWordByRegisters(auts, regTermsModel)
  }
}