package ostrich.preop.cepreop

import ap.terfor.OneTerm
import org.scalacheck.Properties
import ostrich.automata.costenrich.CostEnrichedAutomaton
import ostrich.preop.costenrich.LengthPreOp

object LengthPreOpSpecification
  extends Properties("LengthPreOp") {
    val aAut1 = CostEnrichedAutomaton("a");
    property("Single length") = {
      val preOpRes = LengthPreOp(OneTerm)(Seq(), aAut1)
      val preAut = preOpRes._1.next()(0)
      val preAutRegisterLength = preAut.asInstanceOf[CostEnrichedAutomaton].registers.size
      (preAutRegisterLength == 1)
    }
}
