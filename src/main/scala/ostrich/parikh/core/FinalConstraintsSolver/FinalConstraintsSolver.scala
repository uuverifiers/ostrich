package ostrich.parikh.core

import ap.api.SimpleAPI.ProverStatus
import ap.terfor.Term
import ap.basetypes.IdealInt
import ostrich.parikh.ParikhUtil.measure
import ostrich.parikh.automata.CostEnrichedAutomatonTrait

class Result {
  protected var status = ProverStatus.Unknown

  private val model = new OstrichModel

  def isSat = status == ProverStatus.Sat

  def isUnsat = status == ProverStatus.Unsat

  def setStatus(s: ProverStatus.Value): Unit = status = s

  def getStatus = status

  def updateModel(t: Term, v: IdealInt): Unit = model.update(t, v)

  def updateModel(t: Term, v: Seq[Int]): Unit = model.update(t, v)

  def getModel = model.getModel
}


trait FinalConstraintsSolver[A <: FinalConstraints] {

  def solve: Result

  def measureTimeSolve: Result =
    measure(s"${this.getClass.getSimpleName}::solve") {
      solve
    }

  protected var constraints: Seq[A] = Seq()

  protected var integerTerms: Set[Term] = Set()

  def setIntegerTerm(terms: Set[Term]): Unit = integerTerms = terms

  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): Unit

  def addConstraint(c: A) = constraints = constraints :+ c

}
