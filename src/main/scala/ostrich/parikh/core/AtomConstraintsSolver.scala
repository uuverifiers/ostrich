package ostrich.parikh.core

import ap.terfor.conjunctions.Conjunction
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.parser.Internal2InputAbsy
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import AtomConstraints.{unaryHeuristicACs}
import ap.terfor.Term
import ap.terfor.Formula

object AtomConstraintsSolver {
  var initialLIA: Formula = Conjunction.TRUE

}

class Result {
  protected var status = ProverStatus.Unknown

  private val model = new OstrichModel

  def setStatus(s: ProverStatus.Value): Unit = status = s

  def getStatus = status

  def updateModel(t: Term, v: Int): Unit = model.update(t, v)

  def updateModel(t: Term, v: Seq[Int]): Unit = model.update(t, v)
}

import AtomConstraintsSolver._

trait AtomConstraintsSolver {

  protected var constraints: Seq[AtomConstraints] = Seq()

  def addConstraint(constraint: AtomConstraints): Unit =
    constraints ++= Seq(constraint)

  def solve: Result

}

class LinearAbstractionSolver extends AtomConstraintsSolver {

  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): Unit = {
    val constraint = unaryHeuristicACs(t, auts)
    super.addConstraint(constraint)
  }

  def solve: Result = {
    // Sometimes computation of linear abstraction is very expensive
    // So we thy to find a model with less constraints(over-approximation) first
    // Improve me !! (maybe currently compute approximation and linear abstraction)
    val approxRes = solveOverApprox
    approxRes.getStatus match {
      case ProverStatus.Sat => approxRes
      case _ => solveLinearAbs
    }
  }

  def solveOverApprox: Result = solveFixedFormula(
    conj(constraints.map(_.getOverApprox))
  )

  def solveLinearAbs: Result = solveFixedFormula(
    conj(constraints.map(_.getLinearAbs))
  )

  def solveFixedFormula(f: Formula): Result = {
    val res = new Result
    SimpleAPI.withProver { p =>
      p setConstructProofs true
      val regsRelation = conj(constraints.map(_.getRegsRelation))
      val finalArith = conj(f, initialLIA, regsRelation)
      p addConstantsRaw SymbolCollector.constants(
        Internal2InputAbsy(finalArith)
      )
      p addAssertion finalArith
      p.??? match {
        case ProverStatus.Sat =>
          val partialModel = p.partialModel
          for (c <- constraints) {
            c.setTermModel(partialModel)
            val value = c.getModel
            res.updateModel(c.getTerm, value)
          }
          res.setStatus(ProverStatus.Sat)
        case _ => res.setStatus(_)
      }
    }
    res
  }

}
