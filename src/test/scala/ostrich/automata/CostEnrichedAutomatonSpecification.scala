package ostrich.automata

import org.scalacheck.Properties
import ostrich.automata.costenrich.CostEnrichedAutomatonBuilder
import ostrich.automata.costenrich.CostEnrichedAutomaton
import ostrich.preop.costenrich.LengthPreOp
import ap.terfor.OneTerm


object CostEnrichedAutomatonSpecification
    extends Properties("CostEnrichedAutomaton") {

  def str2SeqInt(s: String): Seq[Int] = s.map(_.toInt)

  property("parikh image") = {
    val abcAut = CostEnrichedAutomaton("abc")
    val lengthPreOfAbc = LengthPreOp(OneTerm)(Seq(), abcAut)
    abcAut(str2SeqInt("abc"))
  }

  property("automaton product") = {
    true
  }

}
