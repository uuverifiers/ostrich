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
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IConstant
import ap.util.Timeout
import ap.parser.IBinJunctor

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
    connectSimplify(constraints.map(_.getCompleteLIA), IBinJunctor.And)
  )

  def solveFormula(f: IFormula, generateModel: Boolean = true): Result = {

    val res = new Result
    val finalArith = f & additionalLia

    lProver.push
    val integerInConstraints =
      (for (t <- integerTerms) yield SymbolCollector constants t).flatten
    val allConsts =
      (SymbolCollector.constants(
        finalArith
      ) ++ integerInConstraints)

    val newConsts = allConsts &~ lProver.order.orderedConstants

    lProver.addConstantsRaw(newConsts)
    lProver !! finalArith
    lProver.checkSat(false)
    val status = measure(
      s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
    ) {
      while (lProver.getStatus(100) == ProverStatus.Running) {
        Timeout.check
      }
      lProver.???
    }
    status match {
      case ProverStatus.Sat if generateModel =>
        // generate model
        val partialModel = lProver.partialModel
        // update string model
        for (singleString <- constraints) {
          val value = measure(
            s"${this.getClass.getSimpleName}::findStringModel"
          )(singleString.getModel(partialModel))
          value match {
            case Some(v) => res.updateModel(singleString.strDataBaseId, v)
            case None    => throw UnknownException("Cannot find string model")
          }

        }
        // update integer model
        for (term <- allConsts) {
          val value = FinalConstraints.evalTerm(IConstant(term), partialModel)
          res.updateModel(term, value)
        }
      case _ => //do nothing
    }
    res.setStatus(status)
    lProver.pop
    res
  }

}
