package ostrich.parikh

import ap.terfor.Term
import ap.terfor.ConstantTerm
import ap.terfor.TermOrder

object TermGeneratorOrder {
  def reset() = {
    order = TermOrder.EMPTY
  }
  implicit var order: TermOrder = TermOrder.EMPTY
  def apply(): TermOrder = order
  def extend(t: ConstantTerm): Unit = {
    if(!order.orderedConstants.contains(t))
      order = order.extend(t)
  }
  def extend(t: Seq[ConstantTerm]): Unit = {
    val newConsts = t.toSet &~ order.orderedConstants  
    order = order.extend(newConsts.toSeq)
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

object TransitionTerm {
  var count = 0
  def apply(): Term = {
    count += 1
    val transTerm = new ConstantTerm(s"T$count")
    TermGeneratorOrder.extend(transTerm)
    transTerm
  }
}

object ZTerm {
  var count = 0
  def apply(): Term = {
    count += 1
    val zTerm = new ConstantTerm(s"Z$count")
    TermGeneratorOrder.extend(zTerm)
    zTerm
  }
}

object LenTerm {
  var count = 0
  def apply(): Term = {
    count += 1
    val lenTerm = new ConstantTerm(s"Len$count")
    TermGeneratorOrder.extend(lenTerm)
    lenTerm
  }
}