
package ostrich

import org.scalacheck.Properties
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object ReversePreOpSpecification
	extends Properties("ReversePreOp"){

  // Automaton q1 -[a]-> q2 -[b]-> q3 -[c]-> q4 -[d]-> q5
  val abcdAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    val q5 = new IDState(5)
    q5.setAccept(true)
    q1.addTransition(new Transition('a', 'a', q2))
    q2.addTransition(new Transition('b', 'b', q3))
    q3.addTransition(new Transition('c', 'c', q4))
    q4.addTransition(new Transition('d', 'd', q5))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }

  // Automaton q1 -[a]-> q2 -[b]-> q3
  //              -[c]-> q4
  val aborcAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q3.setAccept(true)
    q4.setAccept(true)
    q1.addTransition(new Transition('a', 'a', q2))
    q2.addTransition(new Transition('b', 'b', q3))
    q1.addTransition(new Transition('c', 'c', q4))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }


  def seq(s : String) = s.map(_.toInt)

  property("Simple reverse abcd") = {
    // dcba = reverse(abcd)
    ReversePreOp(Seq(), abcdAut)._1.exists(cons => {
      cons(0)(seq("dcba"))
    })
  }

  property("Simple reverse abcd not accept") = {
    // abcd != reverse(abcd)
    !ReversePreOp(Seq(), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple reverse with multiple final 1") = {
    // ba = reverse(abOrc)
    ReversePreOp(Seq(), aborcAut)._1.exists(cons => {
      cons(0)(seq("ba"))
    })
  }

  property("Simple reverse with multiple final 2") = {
    // ba = reverse(abOrc)
    ReversePreOp(Seq(), aborcAut)._1.exists(cons => {
      cons(0)(seq("c"))
    })
  }

  property("Simple reverse with multiple final not accept") = {
    // ba = reverse(abOrc)
    !ReversePreOp(Seq(), aborcAut)._1.exists(cons => {
      cons(0)(seq("ab"))
    })
  }
}

