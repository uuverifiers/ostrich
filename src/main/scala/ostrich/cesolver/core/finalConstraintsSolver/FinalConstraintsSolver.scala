package ostrich.cesolver.core

import ap.api.SimpleAPI.ProverStatus
import ap.basetypes.IdealInt
import ostrich.cesolver.util.ParikhUtil.measure
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm

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

  def solve: Result

  def measureTimeSolve: Result =
    measure(s"${this.getClass.getSimpleName}::solve") {
      solve
    }

  protected var constraints: Seq[A] = Seq()

  protected var integerTerms: Set[ITerm] = Set()

  def setIntegerTerm(terms: Set[ITerm]): Unit = integerTerms = terms

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit

  def addConstraint(c: A) = constraints = constraints :+ c

}
