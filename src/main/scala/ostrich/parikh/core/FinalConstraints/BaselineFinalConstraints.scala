package ostrich.parikh.core

import ap.terfor.Formula
import ap.terfor.Term
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.ParikhUtil
import ostrich.parikh.automata.CEBasicOperations

class BaselineFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  lazy val productAut = getAutomata.reduce(_ product _)
  

  def getCompleteLIA: Formula = 
    new BaselineAC(productAut).getCompleteLIA

  def getRegsRelation: Formula = 
    new BaselineAC(productAut).getRegsRelation

    val interestTerms: Seq[Term] = productAut.registers

  def getModel: Option[Seq[Int]] = {
    val transtionModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(
      Seq(productAut),
      transtionModel
    )
  }
}