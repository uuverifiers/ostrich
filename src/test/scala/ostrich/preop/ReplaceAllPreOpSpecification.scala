package ostrich.preop

import ostrich.automata.{BricsAutomaton, Automaton, IDState}

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
  val ddAut = BricsAutomaton.fromString("dd")
  val eAut = BricsAutomaton.fromString("")

  def seq(s : String) = s.map(_.toInt)

  property("Simple single char test 1") = {
    // abcd = replaceall(x, e, bc)
    ReplaceAllLongestPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("aed"))
    })
  }

  property("Simple single char test 2") = {
    // abcd = replaceall(x, e, bc)
    ReplaceAllLongestPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple single char test 3") = {
    // abcd = replaceall(x, e, bc)
    !ReplaceAllLongestPreOp('e')(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abd"))
    })
  }

  property("Simple word test 1") = {
    // abcd = replaceall(x, word, bc)
    ReplaceAllLongestPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("awordd"))
    })
  }

  property("Simple word test 2") = {
    // abcd = replaceall(x, word, bc)
    ReplaceAllLongestPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("abcd"))
    })
  }

  property("Simple word test 3") = {
    // abcd = replaceall(x, word, bc)
    !ReplaceAllLongestPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("xbcx"))
    })
  }

  property("Simple word test 4") = {
    // abcd = replaceall(x, word, bc)
    !ReplaceAllLongestPreOp("word")(Seq(Seq(), Seq(bcAut)), abcdAut)._1.exists(cons => {
      cons(0)(seq("word"))
    })
  }

  property("Double word test 1") = {
    // aa = replaceall(x, word, a|b)
    ReplaceAllLongestPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaAut)._1.exists(cons => {
      cons(0)(seq("wordword"))
    })
  }

  property("Double word test 3") = {
    // aa = replaceall(x, word, a|b)
    ReplaceAllLongestPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut)._1.exists(cons => {
      cons(0)(seq("wordword"))
    })
  }

  property("Double word test 4") = {
    // aa = replaceall(x, word, a|b)
    !ReplaceAllLongestPreOp("word")(Seq(Seq(), Seq(aorbAut)), aaorbbAut)._1.exists(cons => {
      cons(0)(seq("ab"))
    })
  }

  property("Regex simple test 1") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllLongestPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("aaaa"))
    })
  }

  property("Regex simple test 2") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    ReplaceAllLongestPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("bc"))
    })
  }

  property("Regex simple test 3") = {
    // bc = replaceall(x, a*, bc)
    val aut = BricsAutomaton("a*")
    !ReplaceAllLongestPreOp(aut)(Seq(Seq(), Seq(bcAut)), bcAut)._1.exists(cons => {
      cons(0)(seq("abc"))
    })
  }

  property("Regex leftmost test 1") = {
    // dba = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    ReplaceAllLongestPreOp(aut)(Seq(Seq(), Seq(dAut)), dbaAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Regex leftmost test 2") = {
    // abd = replaceall(x, aba, d)
    val aut = BricsAutomaton("aba")
    !ReplaceAllLongestPreOp(aut)(Seq(Seq(), Seq(dAut)), abdAut)._1.exists(cons => {
      cons(0)(seq("ababa"))
    })
  }

  property("Simple Post Char") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val post = ReplaceAllLongestPreOp('l').
      forwardApprox(Seq(Seq(baut1.asInstanceOf[Automaton]),
                        Seq(baut2.asInstanceOf[Automaton])))

    // negative ones are subjective i suppose due to over-approx
    post(seq("heworldworldo")) &&
      !post(seq("hello")) &&
      !post(seq("hworldo")) &&
      !post(seq("hworldllo"))
  }

  property("Simple Post Word") = {
    val baut1 = BricsAutomaton.fromString("hello")
    val baut2 = BricsAutomaton.fromString("world")

    val post = ReplaceAllLongestPreOp("el").
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

    val post = ReplaceAllLongestPreOp(regex).
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

    val post = ReplaceAllLongestPreOp(regex).
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

    !ReplaceAllLongestPreOp("scr")(Seq(Seq(), Seq(eAut)),
                           scscriptriptAut)._1.exists(cons => {
      cons(0)(seq("scscriptript"))
    })
  }

  property("Transducer over cycling word") = {
    val aabaabAut = BricsAutomaton.fromString("aabaab")
    val tAut = BricsAutomaton.fromString("")

    !ReplaceAllLongestPreOp("aabaab")(Seq(Seq(), Seq(eAut)),
                               aabaabAut)._1.exists(cons => {
      cons(0)(seq("aabaab"))
    })
  }

  property("Pre-image over a non replaced word contains original word") = {
    val aabaabAut = BricsAutomaton.fromString("ccc")
    val tAut = BricsAutomaton.fromString("")

    ReplaceAllLongestPreOp("aabaab")(Seq(Seq(), Seq(eAut)),
                               aabaabAut)._1.exists(cons => {
      cons(0)(seq("ccc"))
    })
  }

  property("Regex longest catches all") = {
    // dd = replaceAll(x, a*, d) cannot contain aa
    val aut = BricsAutomaton("a*")
    !ReplaceAllLongestPreOp(aut)(Seq(Seq(), Seq(dAut)), ddAut)._1.exists(cons => {
      cons(0)(seq("aa"))
    })
  }

  property("Regex shortest matches single") = {
    // dd = replaceAllShortest(x, a*, d) can contain aa
    val aut = BricsAutomaton("a*")
    ReplaceAllShortestPreOp(aut)(
      Seq(Seq(), Seq(dAut)), ddAut
    )._1.exists(cons => { cons(0)(seq("aa")) })
  }

  property("Regex shortest doesn't match double") = {
    // d = replaceAllShortest(x, a*, d) can't have x = aa
    val aut = BricsAutomaton("a*")
    !ReplaceAllShortestPreOp(aut)(
      Seq(Seq(), Seq(dAut)), dAut
    )._1.exists(cons => { cons(0)(seq("aa")) })
  }

  property("Regex shortest empty does nothing") = {
    // dd = replaceAllShortest(x, "", d) allows x = dd
    val aut = BricsAutomaton("")
    ReplaceAllShortestPreOp(aut)(
      Seq(Seq(), Seq(dAut)), ddAut
    )._1.exists(cons => { cons(0)(seq("dd")) })
  }

  property("Regex shortest empty post-image empty pre") = {
    // "" = replaceAllShortest(x, a*, d) has x = ""
    val aut = BricsAutomaton("a*")
    ReplaceAllShortestPreOp(aut)(
      Seq(Seq(), Seq(dAut)), eAut
    )._1.exists(cons => { cons(0)(seq("")) })
  }

  property("Regex shortest repeated word match") = {
    // "dd" = replaceAllShortest(x, (abc)+, d) has x = abcabc
    val aut = BricsAutomaton("(abc)*")
    ReplaceAllShortestPreOp(aut)(
      Seq(Seq(), Seq(dAut)), ddAut
    )._1.exists(cons => { cons(0)(seq("abcabc")) })
  }

  property("Regex shortest repeated word match neg") = {
    // "d" = replaceShortest(x, (abc)+, d) has not x = abcabc
    val aut = BricsAutomaton("(abc)*")
    !ReplaceAllShortestPreOp(aut)(
      Seq(Seq(), Seq(dAut)), dAut
    )._1.exists(cons => { cons(0)(seq("abcabc")) })
  }

  property("Regex middle repeated word match") = {
    // "dddd" = replaceShortest(x, (abc)+, d) has x = dabcabcd
    val ddddAut = BricsAutomaton.fromString("dddd")
    val aut = BricsAutomaton("(abc)*")
    ReplaceAllShortestPreOp(aut)(
      Seq(Seq(), Seq(dAut)), ddddAut
    )._1.exists(cons => { cons(0)(seq("dabcabcd")) })
  }

  property("Bug 56 style error") = {
    // "aa" = replaceAll(x, ab, c) has x = aa
    val cAut = BricsAutomaton.fromString("c")
    ReplaceAllShortestPreOp("ab")(
      Seq(Seq(), Seq(cAut)), aaAut
    )._1.exists(cons => { cons(0)(seq("aa")) })
  }

  property("Unchanged shortest empty") = {
    // "aa" = replaceAll(x, "", c) has x = aa
    val cAut = BricsAutomaton.fromString("c")
    ReplaceAllShortestPreOp("")(
      Seq(Seq(), Seq(cAut)), aaAut
    )._1.exists(cons => { cons(0)(seq("aa")) })
  }

  property("Unchanged shortest empty neg") = {
    // "c" = replaceAll(x, "", c) has not x = aa
    val cAut = BricsAutomaton.fromString("c")
    !ReplaceAllShortestPreOp("")(
      Seq(Seq(), Seq(cAut)), cAut
    )._1.exists(cons => { cons(0)(seq("aa")) })
  }
}

