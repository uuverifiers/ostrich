package strsolver.preprop

import scala.collection.mutable.HashMap

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object BricsTransducerSpecification
	extends Properties("BricsTransducer"){

  def seq(s : String) = s.map(_.toInt)

  val simplePrePostTran = {
    // Transducer q0 -- [a-c], ("zz", +0, "adb") --> qf
    val builder = BricsTransducer.getBuilder
    val q0 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true)

    val op = OutputOp("zz", Plus(0), "adb")
    builder.addTransition(q0, ('a', 'c'), op, qf)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  val simplePrePostDel = {
    // Transducer q0 -- [a-c], ("zz", delete, "adb") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("zz", NOP, "adb")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)

    builder.getTransducer
  }

  val simplePrePostInternal = {
    // Transducer q0 -- [a-c], ("zz", internal, "adb") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("zz", Internal, "adb")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)

    builder.getTransducer
  }

  val epsilonTrans = {
    // Transducer q0 -- epsilon, ("zz", delete, "adb") --> q1
    //            q1 -- a, ("", copy, "") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val qf = builder.getNewState

    val op1 = OutputOp("zz", NOP, "adb")
    val op2 = OutputOp("", Plus(0), "")

    builder.setAccept(qf, true)
    builder.addETransition(q0, op1, q1)
    builder.addTransition(q1, ('a', 'a'), op2, qf)
    builder.setInitialState(q0)

    builder.getTransducer
  }

  val onlyEpsilonTrans = {
    // Transducer q0 -- epsilon, ("zz", delete, "adb") --> q1
    //            q1 -- epsilon, ("", delete, "") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val qf = builder.getNewState

    val op1 = OutputOp("zz", NOP, "adb")
    val op2 = OutputOp("", NOP, "")

    builder.setAccept(qf, true)
    builder.addETransition(q0, op1, q1)
    builder.addETransition(q1, op2, qf)
    builder.setInitialState(q0)

    builder.getTransducer
  }

  val nonDeterministicTran = {
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val q2 = builder.getNewState
    val q3 = builder.getNewState
    val q4 = builder.getNewState

    builder.setAccept(q2, true)
    builder.setAccept(q4, true)

    val op1 = OutputOp("x", NOP, "y")
    val op2 = OutputOp("", Plus(1), "")
    val op3 = OutputOp("", Internal, "y")
    val op4 = OutputOp("", Plus(0), "z")

    builder.addTransition(q0, ('a', 'a'), op1, q1)
    builder.addTransition(q1, ('b', 'b'), op2, q2)
    builder.addTransition(q0, ('a', 'a'), op3, q3)
    builder.addTransition(q3, ('c', 'c'), op4, q4)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  property("Simple Pre +3") = {
    // Transducer q0 -- [a-c], +3 --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("", Plus(3), "")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)
    val btran = builder.getTransducer

    // Automaton q1 -[d]-> q2
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('d', 'd', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val pre = btran.preImage(baut)

    pre(List('a')) && !pre(List('c')) && !pre(List('d'))
  }

  property("Simple Pre With Pre") = {
    // Transducer q0 -- [a-c], ("zz", +0, "") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("zz", Plus(0), "")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)
    val btran = builder.getTransducer

    // Automaton q1 -[z]-> q2 -[a-z]-> q3 -[b]-> q4
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q4.setAccept(true)
    q1.addTransition(new Transition('z', 'z', q2))
    q2.addTransition(new Transition('a', 'z', q3))
    q3.addTransition(new Transition('b', 'b', q4))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val pre = btran.preImage(baut)

    pre(List('b')) && !pre(List('a')) && !pre(List('d'))
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

  property("Simple Pre With Pre and Post Should fail") = {
    // Transducer q0 -- [a-c], ("zz", +0, "adb") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("zz", Plus(0), "ad")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)
    val btran = builder.getTransducer

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

    val pre = btran.preImage(baut)

    !pre(List('b')) && !pre(List('a')) && !pre(List('d'))
  }

  property("Simple Pre With Pre and Post and NOP") = {
    // Transducer q0 -- [a-c], ("zz", delete, "adb") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = new OutputOp("zz", NOP, "badb")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)

    val btran = builder.getTransducer

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

    val pre = btran.preImage(baut)

    pre(List('b')) && pre(List('a')) && !pre(List('d', 'e'))
  }

  property("Simple Pre With Epsilon") = {
    val baut = BricsAutomaton.fromString("zzadba")
    val pre = epsilonTrans.preImage(baut)

    pre(List('a')) && !pre(List('b'))
  }

property("Simple Pre With Only Epsilon") = {
  val baut = BricsAutomaton.fromString("zzadb")
  val pre = onlyEpsilonTrans.preImage(baut)

  pre(List()) && !pre(List('b'))
}

  property("Simple Post +3") = {
    // Transducer q0 -- [a-c], +3 --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("", Plus(3), "")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)

    val btran = builder.getTransducer

    // Automaton q1 -[c]-> q2
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('c', 'c', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val post = btran.postImage(baut)

    post(List('f')) && !post(List('c')) && !post(List('z'))
  }

  property("Simple Post With Pre") = {
    // Transducer q0 -- [a-c], ("zz", +0, "") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("zz", Plus(0), "")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)
    val btran = builder.getTransducer

    // Automaton q1 -[c]-> q2
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('c', 'c', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val post = btran.postImage(baut)

    !post(seq("zza")) && post(seq("zzc")) && !post(List('a'))
  }

  property("Simple Post With Pre and Post") = {
    // Transducer q0 -- [a-c], ("zz", +0, "adb") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("zz", Plus(0), "adb")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)

    val btran = builder.getTransducer

    // Automaton q1 -[c]-> q2
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('c', 'c', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val post = btran.postImage(baut)

    post(seq("zzcadb")) && !post(seq("aadb")) && !post(seq("zzaadb"))
  }

  property("Simple Post With Pre and Post Should fail") = {
    // Transducer q0 -- [a-c], ("zz", +0, "adb") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("zz", Plus(0), "ad")
    builder.addTransition(q0, ('a', 'c'), op, qf)
    builder.setInitialState(q0)

    val btran = builder.getTransducer

    // Automaton q1 -[d]-> q2
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('d', 'd', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val post = btran.postImage(baut)

    !post(List('b')) && !post(List('a')) && !post(List('d'))
  }

  property("Simple Post With Pre and Post and NOP") = {
    // Automaton q1 -[c]-> q2
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('c', 'c', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val post = simplePrePostDel.postImage(baut)

    post(seq("zzadb")) && !post(seq("aadb")) && !post(seq("d"))
  }

  property("Simple Post With Epsilon") = {
    val baut = BricsAutomaton.fromString("a")
    val post = epsilonTrans.postImage(baut)

    post(seq("zzadba")) && !post(seq("a"))
  }

  property("Simple Post With Only Epsilon") = {
    val baut = BricsAutomaton.fromString("")
    val post = onlyEpsilonTrans.postImage(baut)

    post(seq("zzadb")) && !post(seq("a"))
  }

  property("Apply simple pre and post to input word") = {
    simplePrePostTran("b") == Some("zzbadb")
  }

  property("Apply simple pre and post with delete to input word") = {
    simplePrePostDel("b") == Some("zzadb")
  }

  property("Apply simple pre and post with internal to input word") = {
    simplePrePostInternal("b", "INT") == Some("zzINTadb")
  }

  property("Non deterministic accepted 1") = {
    nonDeterministicTran("ab", "INT") == Some("xyc")
  }

  property("Non deterministic accepted 2") = {
    nonDeterministicTran("ac", "INT") == Some("INTycz")
  }

  property("Non deterministic not accepted") = {
    nonDeterministicTran("ad") == None
  }

  property("Empty input") = {
    nonDeterministicTran("") == None
  }

  property("Empty input accept") = {
    val builder = BricsTransducer.getBuilder
    builder.setAccept(builder.initialState, true)
    val tran = builder.getTransducer

    tran("") == Some("")
  }

  property("Epsilon Apply") = {
    epsilonTrans("a") == Some("zzadba")
  }

  property("Only Epsilon Apply") = {
    onlyEpsilonTrans("") == Some("zzadb")
  }
}
