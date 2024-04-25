package ostrich.cesolver.core.finalConstraintsSolver

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.core.finalConstraints.{FinalConstraints, BaselineFinalConstraints}
import ap.parser.ITerm
import ap.parser.IExpression._
import ostrich.OFlags

class BaselineSolver(flags: OFlags, val lProver: SimpleAPI)
    extends FinalConstraintsSolver[BaselineFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.baselineACs(t, auts, flags))
  }

  def solve: Result = {
    val finalArith = and(constraints.map(_.getCompleteLIA))
    import FinalConstraints.evalTerm
    val res = new Result

    lProver.push
    val newConsts = SymbolCollector.constants(finalArith) &~ lProver.order.orderedConstants 
    lProver.addConstantsRaw(newConsts)
    lProver !! finalArith
    val status = measure(
      s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
    ) {
      lProver.???
    }
    lProver.pop
    status match {
      case ProverStatus.Sat =>
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
        for (term <- integerTerms) {
          val value = evalTerm(term, partialModel)
          res.updateModel(term, value)
        }

        res.setStatus(ProverStatus.Sat)
      case _ => res.setStatus(_)
    }
    res
  }
}
