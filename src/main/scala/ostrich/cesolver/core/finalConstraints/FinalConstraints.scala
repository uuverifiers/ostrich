package ostrich.cesolver.core.finalConstraints


import ap.api.PartialModel
import ap.basetypes.IdealInt
import ap.parser.IExpression._
import ap.parser.IFormula
import ap.parser.ITerm
import ostrich.OFlags
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IBinJunctor


object FinalConstraints {
  def unaryHeuristicACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): UnaryFinalConstraints = {
    new UnaryFinalConstraints(t, auts, flags)
  }

  def baselineACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): BaselineFinalConstraints = {
    new BaselineFinalConstraints(t, auts, flags)
  }

  def catraACs(
      t: ITerm,
      auts: Seq[CostEnrichedAutomatonBase],
      flags: OFlags
  ): CatraFinalConstraints = {
    new CatraFinalConstraints(t, auts, flags)
  }

  def nuxmvACs(
    t: ITerm,
    auts: Seq[CostEnrichedAutomatonBase],
    flags: OFlags
  ): NuxmvFinalConstraints = {
    new NuxmvFinalConstraints(t, auts, flags)
  }

/*
  def nuxmvACs(
    t: ITerm,
    auts: Seq[CostEnrichedAutomatonBase]
  ): NuxmvFinalConstraints = {
    new NuxmvFinalConstraints(t, auts)
  }
*/

  def evalTerm(t: ITerm, model: PartialModel): IdealInt = {
    val value = evalTerm(t)(model)
    if (!value.isDefined) {
      // TODO: NEED NEW FEATURE!
      // Do not generate model of variables without constraints now
      throw new Exception("ITerm " + t + " is not defined in the model")
    }
    value.get
  }

  def evalTerm(t: ITerm)(model: PartialModel): Option[IdealInt] = t match {
    case _: ITerm =>
      model eval t
  }
}

trait FinalConstraints {
  type State = CostEnrichedAutomatonBase#State

  val strDataBaseId: ITerm

  val auts: Seq[CostEnrichedAutomatonBase]

  val regsTerms: Seq[ITerm]

  // protected var regTermsModel: Map[ITerm, IdealInt]

  // accessors and mutators-------------------------------------------
  def getModel(partialModel: PartialModel): Option[Seq[Int]]

  def getRegsRelation: IFormula 

  // def setRegTermsModel(partialModel: PartialModel): Unit = {
  //   regTermsModel = Map()
  //   for (term <- getRegisters)
  //     regTermsModel += (term -> evalTerm(term, partialModel))
  // }

  // def setRegTermsModel(termModel: Map[ITerm, IdealInt]): Unit = {
  //   regTermsModel = Map()
  //   for (term <- getRegisters)
  //     regTermsModel += (term -> termModel(term))
  // }
  // accessors and mutators-------------------------------------------
}
