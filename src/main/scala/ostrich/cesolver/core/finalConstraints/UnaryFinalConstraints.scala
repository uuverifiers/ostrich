package ostrich.cesolver.core.finalConstraints

import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.automata.CEBasicOperations
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.OFlags
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._
import ap.parser.IBinJunctor

class UnaryFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase],
    flags: OFlags
) extends BaselineFinalConstraints(strDataBaseId, auts) {

  private def removeDupTransitions(aut: CostEnrichedAutomatonBase) : CostEnrichedAutomatonBase = {
    val ceAut = new CostEnrichedAutomatonBase
    val old2new = aut.states.map(_ -> ceAut.newState()).toMap
    ceAut.initialState = old2new(aut.initialState)
    for (state <- aut.states) {
      if (aut.isAccept(state))
        ceAut.setAccept(old2new(state), true)
      val outTrans = aut.outgoingTransitionsWithVec(state)
      val afterRemoveDup = outTrans.groupBy{
        case (outState, _, vec) => (outState, vec)
      }.map{
        case (_, trans) => trans.head
      }
      for ((outState, label, vec) <- afterRemoveDup) {
        ceAut.addTransition(old2new(state), label, old2new(outState), vec)
      }
    }
    ceAut.registers = aut.registers
    ceAut.regsRelation = aut.regsRelation
    ceAut
  }

  private val productAut = auts.reduce(_ product _)

  private lazy val findModelAut = {
    val afterRemoveDup = removeDupTransitions(productAut)
    if (flags.minimizeAutomata)
      CEBasicOperations.minimizeHopcroft(
        afterRemoveDup
      )
    else afterRemoveDup
  }
    
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
    connectSimplify(
      Seq(ParikhUtil.parikhImage(checkSatAut), checkSatAut.regsRelation),
      IBinJunctor.And
    )
  }

  override def getRegsRelation: IFormula = checkSatAut.regsRelation

  override def getModel: Option[Seq[Int]] = {
    ParikhUtil.log("Get model of string term " + strDataBaseId)
    val res = ParikhUtil.findAcceptedWord(
      Seq(findModelAut),
      regTermsModel,
      flags.findModelBased
    )
    ParikhUtil.log(s"The model of ${strDataBaseId} is generated")
    res
  }
}
