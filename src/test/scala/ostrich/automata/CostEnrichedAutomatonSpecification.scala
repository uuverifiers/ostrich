package ostrich.automata

import org.scalacheck.Properties
import ostrich.automata.costenrich.CostEnrichedAutomatonBuilder
import ostrich.automata.costenrich.CostEnrichedAutomaton
import ostrich.preop.costenrich.LengthPreOp
import ap.terfor.OneTerm
import ap.terfor.Formula
import ap.parser.IFormula
import ap.SimpleAPI
import ap.parser.SymbolCollector
import ap.terfor.conjunctions.Conjunction
import ap.parser.IExpression
import ap.terfor.Term
import ap.parser.ITerm

object CostEnrichedAutomatonSpecification
    extends Properties("CostEnrichedAutomaton") {
  import ap.parser.Internal2InputAbsy
  
  implicit def Internal2Input(c: Conjunction) : IExpression = Internal2InputAbsy(c)
  implicit def Internal2Input(t: Iterable[Term]): Iterable[ITerm] = t.map(Internal2InputAbsy(_))

  def str2SeqInt(s: String): Seq[Int] = s.map(_.toInt)

  property("parikh image") = {
    val abcAut = CostEnrichedAutomaton("abc")
    val parikhImage = abcAut.parikhTheory
    SimpleAPI.withProver(enableAssert = true) { p =>
      import p._
      addAssertion(parikhImage)
      addConstants(SymbolCollector.constants(parikhImage).toIterable)
      ???
    }
    abcAut(str2SeqInt("abc"))
  }

  property("automaton product") = {
    true
  }

}
