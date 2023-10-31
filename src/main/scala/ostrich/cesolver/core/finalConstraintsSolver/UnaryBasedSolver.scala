package ostrich.cesolver.core.finalConstraintsSolver

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.core.finalConstraints.{
  FinalConstraints,
  UnaryFinalConstraints
}
import ostrich.OFlags
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._

class UnaryBasedSolver(
    flags: OFlags,
    lProver: SimpleAPI,
    additionalLia: IFormula
) extends FinalConstraintsSolver[UnaryFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.unaryHeuristicACs(t, auts, flags))
  }

  def solve: Result = solveCompleteLIA

  def solveCompleteLIA: Result = solveFormula(
    and(constraints.map(_.getCompleteLIA))
  )

  def solveFormula(f: IFormula, generateModel: Boolean = true): Result = {
    val res = new Result

    val finalArith = f & additionalLia

    lProver.push
    val internalInt =
      (for (t <- integerTerms) yield SymbolCollector constants t).flatten
    val newConsts =
      (SymbolCollector.constants(
        finalArith
      ) ++ internalInt) &~ lProver.order.orderedConstants
    lProver.addConstantsRaw(newConsts)
    lProver !! finalArith
    val status = measure(
      s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
    ) {
      lProver.???
    }
    status match {
      case ProverStatus.Sat if generateModel =>
        // generate model
        val partialModel = lProver.partialModel
        // update string model
        for (singleString <- constraints) {
          singleString.setRegTermsModel(partialModel)
          val value = measure(
            s"${this.getClass.getSimpleName}::findStringModel"
          )(singleString.getModel)
          value match {
            case Some(v) => res.updateModel(singleString.strDataBaseId, v)
            case None    => throw UnknownException("Cannot find string model")
          }

        }
        // update integer model
        for (term <- integerTerms) {
          val value = FinalConstraints.evalTerm(term, partialModel)
          res.updateModel(term, value)
        }
      case _ => //do nothing
    }
    res.setStatus(status)
    lProver.pop
    res
  }

}
