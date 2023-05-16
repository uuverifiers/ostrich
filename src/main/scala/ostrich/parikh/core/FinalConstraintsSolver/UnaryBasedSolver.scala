package ostrich.parikh.core

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import FinalConstraints._
import ostrich.parikh.ParikhUtil.measure
import ostrich.parikh.util.UnknownException
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ostrich.OFlags
import ostrich.parikh.ParikhUtil
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._

class UnaryBasedSolver(flags: OFlags, freshIntTerm2orgin: Map[ITerm, ITerm])
    extends FinalConstraintsSolver[UnaryFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(unaryHeuristicACs(t, auts, flags))
  }

  def solve: Result = {
    if (flags.underApprox) {
      val res = solveUnderApprox
      if (res.isSat) return res
    }
    // if(OstrichConfig.overApprox){
    //   val res = solveOverApprox
    //   if(res.isUnsat) return res
    // }
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

  // def solveOverApprox: Result = solveFormula(
  //   and(constraints.map(_.getOverApprox)), false
  // )

  def solveCompleteLIA: Result = solveFormula(
    and(constraints.map(_.getCompleteLIA))
  )

  def solveFormula(f: IFormula, generateModel: Boolean = true): Result = {
    import FinalConstraints.evalTerm
    val res = new Result
    SimpleAPI.withProver { p =>
      p setConstructProofs true
      val inputAndGenerated = FinalConstraints()
      val finalArith = and(Seq(f, inputAndGenerated))

      // We must treat TermGenerator.order carefully.
      // finalArith.order should equal to TermGenerator.order
      p.addConstantsRaw(SymbolCollector.constants(finalArith))
      p.addConstants(integerTerms)
      p !! finalArith
      val status = measure(
        s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
      ) {
        p.???
      }
      status match {
        case ProverStatus.Sat if generateModel =>
          val partialModel = p.partialModel
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
    }
    res
  }

}
