package ostrich

import scala.collection.mutable.HashMap

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object BricsPrioTransducerSpecification
	extends Properties("BricsPrioTransducer"){

  def seq(s : String) = s.map(_.toInt)

  val simplePrePostTran = {
    // Transducer q0 -- [a-c], ("zz", +0, "adb") --> qf
    val builder = BricsPrioTransducer.getBuilder
    val q0 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true)

    val op = OutputOp("zz", Plus(0), "adb")
    builder.addTransition(q0, ('a', 'c'), op, qf)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  val aStarPrioTran = {
    // Transducer encoding the capture group (a*)a*
    val builder = BricsPrioTransducer.getBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true)

    val op = OutputOp("", Plus(0), "")
    val nop = OutputOp("", NOP, "")
    builder.addTransition(q0, ('a', 'a'), op, q1)
    builder.addTransition(qf, ('a', 'a'), nop, qf)
    builder.addETransition(q1, nop, 0, qf)
    builder.addETransition(q1, nop, 1, q0) // this is the prioritised transition

    builder.setInitialState(q0)

    builder.getTransducer
  }

  property("Simple Pre With Pre and Post") = {
    // Automaton q1 -[z]-> q2 -[a-z]-> q3 -[b]-> q4 -- [a] --> q2
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q4.setAccept(true)
    q1.addTransition(new Transition('z', 'z', q2))
    q2.addTransition(new Transition('a', 'z', q3))
    q3.addTransition(new Transition('b', 'b', q4))
    q4.addTransition(new Transition('a', 'a', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val pre = simplePrePostTran.preImage(baut)

    pre(List('b')) && !pre(List('a')) && !pre(List('d'))
  }

  property("Capture group (a*)a* result aaaa") = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    val q5 = new IDState(5)
    q5.setAccept(true)
    q1.addTransition(new Transition('a', 'a', q2))
    q2.addTransition(new Transition('a', 'a', q3))
    q3.addTransition(new Transition('a', 'a', q4))
    q4.addTransition(new Transition('a', 'a', q5))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val pre = aStarPrioTran.preImage(baut)

    pre(List('a', 'a', 'a', 'a')) &&
    !pre(List('a', 'a', 'a')) && !pre(List('a', 'a', 'a', 'a', 'a'))
  }
}
