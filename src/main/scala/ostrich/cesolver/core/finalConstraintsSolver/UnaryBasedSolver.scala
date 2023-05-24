package ostrich.cesolver.core

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ostrich.cesolver.convenience.CostEnrichedConvenience._
import FinalConstraints._
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.OFlags
import ostrich.cesolver.util.ParikhUtil
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._

class UnaryBasedSolver(
    flags: OFlags,
    freshIntTerm2orgin: Map[ITerm, ITerm],
    lProver: SimpleAPI
) extends FinalConstraintsSolver[UnaryFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(unaryHeuristicACs(t, auts, flags))
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
    val maxBound = flags.underApproxBound
    val step = 5
    var nowBound = 5
    var result = new Result
    while (nowBound <= maxBound && !result.isSat) {
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
    import FinalConstraints.evalTerm
    val res = new Result

    val finalArith = f

    lProver.push
    val newConsts = SymbolCollector.constants(finalArith) &~ lProver.order.orderedConstants  
    lProver.addConstantsRaw(newConsts)
    lProver.addConstants(integerTerms)
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
          val value = evalTerm(freshIntTerm2orgin(term), partialModel)
          res.updateModel(term, value)
        }

        res.setStatus(ProverStatus.Sat)
      case _ => res.setStatus(_)
    }
    lProver.pop
    res
  }

}
