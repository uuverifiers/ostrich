package ostrich.automata.costenrich

import ap.terfor.Term
import ap.terfor.ConstantTerm
import ap.terfor.TermOrder

object TermGeneratorOrder{
  implicit var order = TermOrder.EMPTY
  def apply(): TermOrder = order
  def extend(t: ConstantTerm): Unit = {
    order = order.extend(t)
  }
  def extend(t: Seq[ConstantTerm]): Unit = {
    order = order.extend(t)
  }
}

object RegisterTerm {
  var count = 0
  def apply(): Term = {
    count += 1
    val regTerm = new ConstantTerm(s"R$count")
    TermGeneratorOrder.extend(regTerm)
    regTerm
  }
}

object TranstionTerm {
  var count = 0
  def apply(): Term = {
    count += 1
    val transTerm = new ConstantTerm(s"T$count")
    TermGeneratorOrder.extend(transTerm)
    transTerm
  }
}
