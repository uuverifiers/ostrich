package ostrich.parikh.core

import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ap.terfor.Formula

class BaselineAC(val aut: CostEnrichedAutomatonBase) extends AtomConstraint {
  def getRegsRelation: Formula = aut.regsRelation
}