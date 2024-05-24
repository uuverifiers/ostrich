package ostrich.cesolver.core.finalConstraintsSolver

import ap.api.SimpleAPI.ProverStatus
import ap.basetypes.IdealInt
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.core.OstrichModel
import ostrich.cesolver.core.finalConstraints.FinalConstraints

object Result {
  def ceaSatResult = {
    val res = new Result
    res.setStatus(ProverStatus.Sat)
    res
  }

  def ceaUnsatResult = {
    val res = new Result
    res.setStatus(ProverStatus.Unsat)
    res
  }

  def ceaUnknownResult = {
    val res = new Result
    res.setStatus(ProverStatus.Unknown)
    res
  }
}

class Result {
  protected var status = ProverStatus.Unknown

  private val model = new OstrichModel

  def isSat = status == ProverStatus.Sat

  def isUnsat = status == ProverStatus.Unsat

  def setStatus(s: ProverStatus.Value): Unit = status = s

  def getStatus = status

  def updateModel(t: ITerm, v: IdealInt): Unit = model.update(t, v)

  def updateModel(t: ITerm, v: Seq[Int]): Unit = model.update(t, v)

  def getModel = model.getModel

  override def toString : String =
    "" + status + ", " + model

}


trait FinalConstraintsSolver[A <: FinalConstraints] {

  def solve: Result

  def measureTimeSolve: Result =
    measure(s"${this.getClass.getSimpleName}::solve") {
      ParikhUtil.log("Begin to solve the final constraints")
      val res = solve
      ParikhUtil.log("End to solve the final constraints")
      res
    }

  protected var constraints: Seq[A] = Seq()

  protected var integerTerms: Set[ITerm] = Set()

  def setIntegerTerm(terms: Set[ITerm]): Unit = integerTerms = terms

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit

  def addConstraint(c: A) = constraints = constraints :+ c

  def cleanConstaints: Unit = constraints = Seq()

}
