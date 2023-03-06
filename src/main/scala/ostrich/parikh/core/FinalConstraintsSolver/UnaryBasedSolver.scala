package ostrich.parikh.core

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.terfor.TerForConvenience._
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import FinalConstraints._
import ap.terfor.Term
import ap.terfor.Formula
import ostrich.parikh.ParikhUtil.measure
import ostrich.parikh.util.UnknownException
import ostrich.parikh.automata.CostEnrichedAutomatonBase

class UnaryBasedSolver extends FinalConstraintsSolver[UnaryFinalConstraints] {
  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(unaryHeuristicACs(t, auts))
  }

  def solve: Result = {
    var res = solveUnderApprox
    if (!res.isSat){
      // try res = solveOverApprox 
      // catch {
      //   case e: UnknownException => res = solveCompleteLIA
      // }
      res = solveCompleteLIA
    }
    res
  }

  def solveUnderApprox: Result = {
    // add bound iterately
    val maxBound = 15
    val step = 5
    var nowBound = 5
    var result = new Result
    while (nowBound <= maxBound && !result.isSat) {
      result = solveFormula(
        conj(constraints.map(_.getUnderApprox(nowBound)))
      )
      nowBound += step
    }
    result
  }

  def solveOverApprox: Result = solveFormula(
    conj(constraints.map(_.getOverApprox))
  )

  def solveCompleteLIA: Result = solveFormula(
    conj(constraints.map(_.getCompleteLIA))
  )

  def solveFormula(f: Formula): Result = {
    import FinalConstraints.evalTerm
    val res = new Result
    SimpleAPI.withProver { p =>
      p setConstructProofs true
      val regsRelation = conj(constraints.map(_.getRegsRelation))
      val inputAndGenerated = FinalConstraints()
      val finalArith = conj(f, regsRelation, inputAndGenerated)

      SymbolCollector.constants(finalArith) ++ integerTerms

      p addConstants order.orderedConstants

      // We must treat TermGenerator.order carefully. 
      // Note that finalArith.order == TermGenerator.order 
      // The call addAssertion will fail some asserttion if the TermGenerator is extended with too many constants. 
      // (run ostrich with +assert option)
      println(finalArith)
      p !! finalArith
      val status = measure(
        s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
      ) {
        p.???
      }
      status match {
        case ProverStatus.Sat =>
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
            val value = evalTerm(term, partialModel)
            res.updateModel(term, value)
          }

          res.setStatus(ProverStatus.Sat)
        case _ => res.setStatus(_)
      }
    }
    res
  }

}