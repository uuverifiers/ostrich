package ostrich.ceasolver.core

import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.parser.Internal2InputAbsy._
import ostrich.ceasolver.convenience.CostEnrichedConvenience._
import FinalConstraints._
import ostrich.ceasolver.util.ParikhUtil.measure
import ostrich.ceasolver.util.UnknownException
import ostrich.ceasolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IExpression._
import ostrich.ceasolver.util.ParikhUtil

class BaselineSolver(val lProver: SimpleAPI)
    extends FinalConstraintsSolver[BaselineFinalConstraints] {
  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(baselineACs(t, auts))
  }

  def solve: Result = {
    ParikhUtil.todo("include goal.facts.arithconj")
    val f = and(constraints.map(_.getCompleteLIA))
    import FinalConstraints.evalTerm
    val res = new Result
    val regsRelation = and(constraints.map(_.getRegsRelation))
    val finalArith = and(Seq(f, regsRelation))

    // p addConstantsRaw initialConstTerms
    lProver.push
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
    res
  }
}
