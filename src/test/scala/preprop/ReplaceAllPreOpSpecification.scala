package strsolver.preprop

import org.scalacheck.Properties
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object ReplaceAllPreOpSpecification
	extends Properties("ReplaceAllPreOp"){

  val abcdAut = BricsAutomaton.fromString("abcd")
  val bcAut = BricsAutomaton.fromString("bc")
  val aaAut = BricsAutomaton.fromString("aa")
  val aorbAut = BricsAutomaton.fromString("a") | BricsAutomaton.fromString("b")
  val aaorbbAut = BricsAutomaton.fromString("aa") | BricsAutomaton.fromString("bb")
  val abdAut = BricsAutomaton.fromString("abd")
  val dbaAut = BricsAutomaton.fromString("dba")
  val dAut = BricsAutomaton.fromString("d")

  def seq(s : String) = s.map(_.toInt)

  property("Simple single char test 1") = {
    // abcd = replaceall(x, e, bc)
    ReplaceAllPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("aed"))
    })
  }

  property("Simple single char test 2") = {
    // abcd = replaceall(x, e, bc)
    ReplaceAllPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple single char test 3") = {
    // abcd = replaceall(x, e, bc)
    !ReplaceAllPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abd"))
    })
  }

  property("Simple word test 1") = {
    // abcd = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("awordd"))
    })
  }

  property("Simple word test 2") = {
    // abcd = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple word test 3") = {
    // abcd = replaceall(x, word, bc)
    !ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("xbcx"))
    })
  }

  property("Simple word test 4") = {
    // abcd = replaceall(x, word, bc)
    !ReplaceAllPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("word"))
    })
  }

  property("Double word test 1") = {
    // aa = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaAut)._1.exists(cons => {
      cons(0)(seq("wordword"))
    })
  }

  property("Double word test 3") = {
    // aa = replaceall(x, word, bc)
    ReplaceAllPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut)._1.exists(cons => {
      cons(0)(seq("wordword"))
    })
  }

  property("Double word test 4") = {
    // aa = replaceall(x, word, bc)
    !ReplaceAllPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut)._1.exists(cons => {
      cons(0)(seq("ab"))
    })
  }

  property("Regex simple test 1") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("aaaa"))
    })
  }

  property("Regex simple test 2") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("bc"))
    })
  }

  property("Regex simple test 3") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    !ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("abc"))
    })
  }

  property("Regex leftmost test 1") = {
    // dba = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(dAut)), dbaAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Regex leftmost test 2") = {
    // abd = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    !ReplaceAllPreOp(aut)(Seq(Seq(), Seq(dAut)), abdAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Simple Post Char") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val concat = ReplaceAllPreOp('l').
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    concat(seq("heworldworldo")) &&
      !concat(seq("hello")) &&
      !concat(seq("hworldo")) &&
      !concat(seq("hworldllo"))
  }

  property("Simple Post Word") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val concat = ReplaceAllPreOp("el").
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    concat(seq("hworldlo"))// &&
      //!concat(seq("hello")) &&
      //!concat(seq("hworldo")) &&
      //!concat(seq("hworldllo"))
  }

  property("Double word test 4") = {
    // aa = replaceall(x, word, bc)
    !ReplaceAllPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut)._1.exists(cons => {
      cons(0)(seq("ab"))
    })
  }

  property("Regex simple test 1") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("aaaa"))
    })
  }

  property("Regex simple test 2") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("bc"))
    })
  }

  property("Regex simple test 3") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    !ReplaceAllPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("abc"))
    })
  }

  property("Regex leftmost test 1") = {
    // dba = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    ReplaceAllPreOp(aut)(Seq(Seq(), Seq(dAut)), dbaAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Regex leftmost test 2") = {
    // abd = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    !ReplaceAllPreOp(aut)(Seq(Seq(), Seq(dAut)), abdAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Simple Post Char") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val concat = ReplaceAllPreOp('l').
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    concat(seq("heworldworldo")) &&
      !concat(seq("hello")) &&
      !concat(seq("hworldo")) &&
      !concat(seq("hworldllo"))
  }

  property("Simple Post Word") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val concat = ReplaceAllPreOp("el").
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    concat(seq("hworldlo")) &&
      !concat(seq("hello")) &&
      !concat(seq("hworldo")) &&
      !concat(seq("hworldllo"))
  }

  property("Simple Post Regex") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")
    val regex = BricsAutomaton.fromString("el")

    val concat = ReplaceAllPreOp(regex).
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    concat(seq("hworldlo")) &&
      !concat(seq("hello")) &&
      !concat(seq("hworldo")) &&
      !concat(seq("hworldllo"))
  }

  property("Simple Post Regex Loop") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val q0 = new IDState(0)
    q0.addTransition(new Transition('l', q0))
    q0.setAccept(true)
    val aut = new BAutomaton
    aut.setInitialState(q0)
    val regex = new BricsAutomaton(aut)

    val concat = ReplaceAllPreOp(regex).
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    concat(seq("heworldo")) &&
      !concat(seq("heworldlo")) &&
      !concat(seq("hworldo")) &&
      !concat(seq("hworldllo"))
  }
}

