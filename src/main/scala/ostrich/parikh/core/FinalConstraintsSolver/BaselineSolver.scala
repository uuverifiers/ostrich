package ostrich.parikh.core

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.terfor.TerForConvenience._
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import FinalConstraints._
import ap.terfor.Term
import ostrich.parikh.ParikhUtil.measure
import ostrich.parikh.util.UnknownException
import ostrich.parikh.automata.CostEnrichedAutomatonBase

class BaselineSolver extends FinalConstraintsSolver[BaselineFinalConstraints] {
  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(baselineACs(t, auts))
  }

  def solve: Result = {
    val f = conj(constraints.map(_.getCompleteLIA))
    import FinalConstraints.evalTerm
    val res = new Result
    SimpleAPI.withProver { p =>
      p setConstructProofs true
      val regsRelation = conj(constraints.map(_.getRegsRelation))
      val finalArith = conj(f, regsRelation, FinalConstraints())
      val constants =
        SymbolCollector.constants(finalArith) ++ integerTerms

      p addConstants constants

      // p addConstantsRaw initialConstTerms
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