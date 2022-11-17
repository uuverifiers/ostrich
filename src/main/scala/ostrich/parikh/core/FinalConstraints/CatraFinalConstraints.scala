package ostrich.parikh.core

import ap.terfor.Formula
import ostrich.parikh.automata.CostEnrichedAutomaton
import ap.terfor.Term
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.terfor.ConstantTerm
import ap.terfor.OneTerm
import ap.terfor.linearcombination.LinearCombination
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.parikh.ParikhUtil
import ap.types.SortedConstantTerm
import ostrich.parikh.OstrichConfig
import ostrich.parikh.automata.CEBasicOperations
import ap.terfor.conjunctions.Conjunction
import shapeless.Fin
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import FinalConstraints._

class CatraFinalConstraints(
    override val strId: Term,
    override val atoms: Seq[AtomConstraint]
) extends FinalConstraints {

  // eagerly product, which means compute lia after producting
  lazy val productAtom = new ParikhAC(getAutomata.reduceLeft(_ product _))

  def getRegsRelation: Formula = productAtom.getRegsRelation

  val interestTerms: Seq[Term] = atoms.map(_.aut).flatMap(_.getRegisters)

  def getModel: Option[Seq[Int]] = {
    val registersModel = MHashMap() ++ interestTermsModel
    ParikhUtil.findAcceptedWordByRegisters(Seq(productAtom.aut), registersModel)
  }
}