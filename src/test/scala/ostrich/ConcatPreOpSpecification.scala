package ostrich

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object ConcatPreOpSpecification
	extends Properties("ConcatPreOp"){

  def seq(s : String) = s.map(_.toInt)

  property("Simple Post") = {
    val baut1 = BricsAutomaton.fromString("d")
    val baut2 = BricsAutomaton.fromString("e")

    val concat = ConcatPreOp.forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                                               Seq(baut2.asInstanceOf[Automaton])))

    concat(seq("de")) && !concat(seq("d"))
  }
}
