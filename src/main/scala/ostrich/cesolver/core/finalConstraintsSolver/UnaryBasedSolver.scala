package ostrich.cesolver.core.finalConstraintsSolver

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ostrich.cesolver.convenience.CostEnrichedConvenience._
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.core.finalConstraints.{
  FinalConstraints,
  UnaryFinalConstraints
}
import ostrich.OFlags
import ostrich.cesolver.util.ParikhUtil
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._

class UnaryBasedSolver(
    flags: OFlags,
    lProver: SimpleAPI
) extends FinalConstraintsSolver[UnaryFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    ParikhUtil.debugPrintln("add atom constraints begin")
    addConstraint(FinalConstraints.unaryHeuristicACs(t, auts, flags))
  }

  def solve: Result = {
    if (flags.underApprox) {
      val res = solveUnderApprox
      if (res.isSat) return res
    }
    solveCompleteLIA
  }

  def solveUnderApprox: Result = {
    // add bound iterately
    ParikhUtil.debugPrintln("under begin")
    val maxBound = flags.underApproxBound
    val step = 5
    var nowBound = 5
    var result = new Result
    while (nowBound <= maxBound && !result.isSat) {
      ap.util.Timeout.check
      result = solveFormula(
        and(constraints.map(_.getUnderApprox(nowBound)))
      )
      nowBound += step
    }
    result
  }

  def solveCompleteLIA: Result = solveFormula(
    and(constraints.map(_.getCompleteLIA))
  )

  def solveFormula(f: IFormula, generateModel: Boolean = true): Result = {
    ParikhUtil.debugPrintln("begin solveFormula")
    val res = new Result

    val finalArith = f

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
        val partialModel = lProver.partialModel
        // update string model
        for (singleString <- constraints) {
          singleString.setInterestTermModel(partialModel)
          val value = measure(
            s"${this.getClass.getSimpleName}::findStringModel"
          )(singleString.getModel)
          value match {
            case Some(v) => res.updateModel(singleString.strId, v)
            case None    => throw UnknownException("Cannot find string model")
          }

        }
        // update integer model
        for (term <- integerTerms) {
          val value = FinalConstraints.evalTerm(term, partialModel)
          res.updateModel(term, value)
        }

        res.setStatus(ProverStatus.Sat)
      case _ => res.setStatus(_)
    }

    lProver.pop
    ParikhUtil.debugPrintln("end solveFormula")
    res
  }

}
