package strsolver.preprop

import org.scalacheck.Properties
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object ReplaceAllPreOpSpecification
	extends Properties("ReplaceAllPreOp"){

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

  // Automaton q1 -[b]-> q2 -[c]-> q3
  val bcAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    q3.setAccept(true)
    q1.addTransition(new Transition('b', 'b', q2))
    q2.addTransition(new Transition('c', 'c', q3))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }

  // Automaton q1 -[a]-> q2 -[a]-> q3
  val aaAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    q3.setAccept(true)
    q1.addTransition(new Transition('a', 'a', q2))
    q2.addTransition(new Transition('a', 'a', q3))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }

  // Automaton q1 -[a,b]-> q2
  val aorbAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('a', 'b', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }

  // Automaton q1 -[a]-> q2 -[a]-> q3
  //              -[b]-> q4 -[b]->
  val aaorbbAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q3.setAccept(true)
    q1.addTransition(new Transition('a', 'a', q2))
    q2.addTransition(new Transition('a', 'a', q3))
    q1.addTransition(new Transition('b', 'b', q2))
    q4.addTransition(new Transition('b', 'b', q3))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }

  // Automaton q1 -[a]-> q2 -[b]-> q3 -[d]-> q4
  val abdAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q4.setAccept(true)
    q1.addTransition(new Transition('a', 'a', q2))
    q2.addTransition(new Transition('b', 'b', q3))
    q3.addTransition(new Transition('d', 'd', q4))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }

  // Automaton q1 -[d]-> q2 -[b]-> q3 -[a]-> q4
  val dbaAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q4.setAccept(true)
    q1.addTransition(new Transition('d', 'd', q2))
    q2.addTransition(new Transition('b', 'b', q3))
    q3.addTransition(new Transition('a', 'a', q4))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }

  // Automaton q1 -[d]-> q
  val dAut = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q2.setAccept(true)
    q1.addTransition(new Transition('d', 'd', q2))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    new BricsAutomaton(aut)
  }


  def seq(s : String) = s.map(_.toInt)

  property("Simple single char test 1") = {
    // abcd = replaceall(x, e, bc)
    ReplaceAllPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut).exists(cons => {
      cons(0)(seq("aed"))
    })
  }

  property("Simple single char test 2") = {
    // abcd = replaceall(x, e, bc)
    ReplaceAllPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut).exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple single char test 3") = {
    // abcd = replaceall(x, e, bc)
    !ReplaceAllPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut).exists(cons => {
      cons(0)(seq("abd"))
    })
  }

  property("Simple word test 1") = {
    // abcd = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut).exists(cons => {
      cons(0)(seq("awordd"))
    })
  }

  property("Simple word test 2") = {
    // abcd = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut).exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple word test 3") = {
    // abcd = replaceall(x, word, bc)
    !ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut).exists(cons => {
      cons(0)(seq("xbcx"))
    })
  }

  property("Simple word test 4") = {
    // abcd = replaceall(x, word, bc)
    !ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut).exists(cons => {
      cons(0)(seq("word"))
    })
  }

  property("Double word test 1") = {
    // aa = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaAut).exists(cons => {
      cons(0)(seq("wordword"))
    })
  }

  property("Double word test 3") = {
    // aa = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut).exists(cons => {
      cons(0)(seq("wordword"))
    })
  }

  property("Double word test 4") = {
    // aa = replaceall(x, word, bc)
    !ReplaceAllPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut).exists(cons => {
      cons(0)(seq("ab"))
    })
  }

  property("Regex simple test 1") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut).exists(cons => {
      cons(0)(seq("aaaa"))
    })
  }

  property("Regex simple test 2") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut).exists(cons => {
      cons(0)(seq("bc"))
    })
  }

  property("Regex simple test 3") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    !ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut).exists(cons => {
      cons(0)(seq("abc"))
    })
  }

  property("Regex leftmost test 1") = {
    // dba = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(dAut)), dbaAut).exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Regex leftmost test 2") = {
    // abd = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    !ReplaceAllPreOp(aut)(Seq(Seq(), Seq(dAut)), abdAut).exists(cons => {
      cons(0)(seq("ababa"))
    })
  }
}

