package ostrich.automata.costenrich

import ap.terfor.Term
import ap.terfor.ConstantTerm

object RegisterTerm{
  var count = 0
  def apply(): Term = new ConstantTerm(s"R$count")
}

object TranstionTerm{
  var count = 0
  def apply(): Term = new ConstantTerm(s"T$count")
}