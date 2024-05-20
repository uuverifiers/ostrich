package ostrich.preop

import ostrich.automata.{BricsAutomaton, Automaton, IDState}

import org.scalacheck.Properties
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object NOPPreOpSpecification
  extends Properties("NOPPreOp"){

  val abcdAut = BricsAutomaton.fromString("abcd")

  def seq(s : String) = s.map(_.toInt)

  property("Simple word nop") = {
    // abcd = nop(x)
    NOPPreOp(Seq(Seq()), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple word nop unchanged") = {
    // abcd = nop(x)
    !NOPPreOp(Seq(Seq()), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcde"))
    })
  }

  property("Simple post nop") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val post = NOPPreOp.forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton])))
    post(seq("hello")) && !post(seq("hello1"))
  }
}
