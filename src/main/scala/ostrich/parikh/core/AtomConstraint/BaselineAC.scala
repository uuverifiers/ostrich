package ostrich.parikh.core

import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ap.terfor.Formula

class BaselineAC(val aut: CostEnrichedAutomatonTrait) extends AtomConstraint {
  def getRegsRelation: Formula = aut.getRegsRelation
}