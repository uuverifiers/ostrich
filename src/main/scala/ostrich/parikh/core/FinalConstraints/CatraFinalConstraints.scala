package ostrich.parikh.core

import ap.terfor.Formula
import ap.terfor.Term
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.ParikhUtil

class CatraFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  // eagerly product, which means compute lia after producting
  lazy val productAtom = new BaselineAC(getAutomata.reduceLeft(_ product _))

  def getRegsRelation: Formula = productAtom.getRegsRelation

  val interestTerms: Seq[Term] = atoms.map(_.aut).flatMap(_.getRegisters)

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(Seq(productAtom.aut), registersModel)
  }
}