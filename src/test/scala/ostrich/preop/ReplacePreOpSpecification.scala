package ostrich.preop

import ostrich.automata.{BricsAutomaton, Automaton, IDState}

import org.scalacheck.Properties
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object ReplacePreOpSpecification
    extends Properties("ReplacePreOp"){

  val abcdAut = BricsAutomaton.fromString("abcd")
  val bcAut = BricsAutomaton.fromString("bc")
  val aaAut = BricsAutomaton.fromString("aa")
  val aorbAut = BricsAutomaton.fromString("a") | BricsAutomaton.fromString("b")
  val aaorbbAut = BricsAutomaton.fromString("aa") | BricsAutomaton.fromString("bb")
  val abdAut = BricsAutomaton.fromString("abd")
  val dbaAut = BricsAutomaton.fromString("dba")
  val dAut = BricsAutomaton.fromString("d")
  val eAut = BricsAutomaton.fromString("")

  def seq(s : String) = s.map(_.toInt)

  property("Simple single char test 1") = {
    // abcd = replace(x, e, bc)
    ReplacePreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("aed"))
    })
  }

  property("Simple single char test 2") = {
    // abcd = replace(x, e, bc)
    ReplacePreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple single char test 3") = {
    // abcd = replace(x, e, bc)
    !ReplacePreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abd"))
    })
  }

  property("Simple word test 1") = {
    // abcd = replace(x, word, bc)
    ReplacePreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("awordd"))
    })
  }

  property("Simple word test 2") = {
    // abcd = replace(x, word, bc)
    ReplacePreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple word test 3") = {
    // abcd = replace(x, word, bc)
    !ReplacePreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("xbcx"))
    })
  }

  property("Simple word test 4") = {
    // abcd = replace(x, word, bc)
    !ReplacePreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("word"))
    })
  }

  property("Double word test 1") = {
    // aa = replace(x, word, a|b)
    ReplacePreOp("word")(Seq(Seq(), Seq(aorbAut)), aaAut)._1.exists(cons => {
      cons(0)(seq("worda"))
    })
  }

  property("Double word test 2") = {
    // aa = replace(x, word, a|b)
    !ReplacePreOp("word")(Seq(Seq(), Seq(aorbAut)), aaAut)._1.exists(cons => {
      cons(0)(seq("wordword"))
    })
  }

  property("Double word test 3") = {
    // (aa|bb) = replace(x, word, a|b)
    !ReplacePreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut)._1.exists(cons => {
      cons(0)(seq("ab"))
    })
  }

  property("Regex simple test 1") = {
    // bc = replace(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplacePreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("aaaa"))
    })
  }

  property("Regex simple test 2") = {
    // bc = replace(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplacePreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("bc"))
    })
  }

  property("Regex simple test 3") = {
    // bc = replace(x, a*, bc)
    val aut = BricsAutomaton("a*")
    !ReplacePreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("abc"))
    })
  }

  property("Regex leftmost test 1") = {
    // dba = replace(x, aba, d)
    val aut = BricsAutomaton("aba")
    ReplacePreOp(aut)(Seq(Seq(), Seq(dAut)), dbaAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Regex leftmost test 2") = {
    // abd = replace(x, aba, d)
    val aut = BricsAutomaton("aba")
    !ReplacePreOp(aut)(Seq(Seq(), Seq(dAut)), abdAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Simple Post Char") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val post = ReplacePreOp('l').
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    post(seq("heworldlo")) &&
      !post(seq("hello")) &&
      !post(seq("hworldwordo")) &&
      !post(seq("hworldllo"))
  }

  property("Simple Post Word") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val post = ReplacePreOp("el").
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    post(seq("hworldlo")) &&
      !post(seq("hello")) &&
      !post(seq("hworldo")) &&
      !post(seq("hworldllo"))
  }

  property("Simple Post Regex") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")
    val regex = BricsAutomaton.fromString("el")

    val post = ReplacePreOp(regex).
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    post(seq("hworldlo")) &&
      !post(seq("hello")) &&
      !post(seq("hworldo")) &&
      !post(seq("hworldllo"))
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

    val post = ReplacePreOp(regex).
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    post(seq("heworldo")) &&
      !post(seq("heworldlo")) &&
      !post(seq("hworldo")) &&
      !post(seq("hworldllo"))
  }

  property("Bug from Philipp 20 May 2020") = {
    val scscriptriptAut = BricsAutomaton.fromString("scscriptript")
    val tAut = BricsAutomaton.fromString("")

    !ReplacePreOp("scr")(Seq(Seq(), Seq(eAut)),
                           scscriptriptAut)._1.exists(cons => {
      cons(0)(seq("scscriptript"))
    })
  }

  property("Transducer over cycling word") = {
    val aabaabAut = BricsAutomaton.fromString("aabaab")
    val tAut = BricsAutomaton.fromString("")

    !ReplacePreOp("aabaab")(Seq(Seq(), Seq(eAut)),
                               aabaabAut)._1.exists(cons => {
      cons(0)(seq("aabaab"))
    })
  }

  property("Pre-image over a non replaced word contains original word") = {
    val aabaabAut = BricsAutomaton.fromString("ccc")
    val tAut = BricsAutomaton.fromString("")

    ReplacePreOp("aabaab")(Seq(Seq(), Seq(eAut)),
                               aabaabAut)._1.exists(cons => {
      cons(0)(seq("ccc"))
    })
  }

  property("Regex longest catches all") = {
    // dd = replace(x, a*, d) cannot contain aa
    val ddAut = BricsAutomaton.fromString("dd")
    val aut = BricsAutomaton("a*")
    !ReplacePreOp(aut)(Seq(Seq(), Seq(dAut)), ddAut)._1.exists(cons => {
      cons(0)(seq("aa"))
    })
  }
}

