package ostrich.parikh.core

import ap.terfor.Formula
import ap.terfor.Term
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.ParikhUtil
import ostrich.parikh.automata.CostEnrichedAutomatonBase

class CatraFinalConstraints(
    override val strId: Term,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints {

  val interestTerms: Seq[Term] = auts.flatMap(_.registers)

  import ap.terfor.TerForConvenience._
  import ostrich.parikh.TermGeneratorOrder.order
  
  def getRegsRelation: Formula = conj(auts.map(_.regsRelation))

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(auts, registersModel)
  }
}