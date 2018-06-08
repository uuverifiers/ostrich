package strsolver.preprop

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._
import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object BricsTransducerSpecification
	extends Properties("BricsTransducer"){

  property("Simple Pre") = {
    // Transducer q0 -in: [a-c]-> q1 -out: [d-f]-> qf
    val q0 = new IDState(0)
    val q1 = new IDState(1)
    val qf = new IDState(2)
    qf.setAccept(true)
    q0.addTransition(new Transition('a', 'c', q1))
    q1.addTransition(new Transition('d', 'f', qf))
    val tran = new BAutomaton
    tran.setInitialState(q0)
    val btran = new BricsTransducer(tran, Set(q0))

    // Automaton q3 -[d]-> q4
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q4.setAccept(true)
    q3.addTransition(new Transition('d', 'd', q4))
    val aut = new BAutomaton
    aut.setInitialState(q3)
    val baut = new BricsAutomaton(aut)

    val pre = btran.preImage(baut)

    pre(List('a')) && pre(List('c')) && !pre(List('d'))
  }
}
