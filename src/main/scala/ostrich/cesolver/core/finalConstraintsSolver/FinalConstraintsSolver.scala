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
}


trait FinalConstraintsSolver[A <: FinalConstraints] {

  ParikhUtil.todo("remove unused integerTerms")

  def solve: Result

  def measureTimeSolve: Result =
    measure(s"${this.getClass.getSimpleName}::solve") {
      ParikhUtil.debugPrintln("begin solve")
      val res = solve
      ParikhUtil.debugPrintln("end solve")
      res
    }

  protected var constraints: Seq[A] = Seq()

  protected var integerTerms: Set[ITerm] = Set()

  def setIntegerTerm(terms: Set[ITerm]): Unit = integerTerms = terms

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit

  def addConstraint(c: A) = constraints = constraints :+ c

}
