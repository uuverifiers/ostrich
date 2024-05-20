package ostrich.automata

import dk.brics.automaton.{Transition, Automaton => BAutomaton}
import org.scalacheck.Prop._
import org.scalacheck.Properties
import ostrich.AutomatonParser

object AutomatonParserTest
	extends Properties("AutomatonParser"){

  val anyStringAut = BricsAutomaton.makeAnyString()

  val aPlusbPlusAut = {
    // Transducer encoding the capture group (a*)a*
    val builder = new BricsAutomatonBuilder()
    val init = builder.getNewState
    val aplus = builder.getNewState
    val bplus = builder.getNewState
    builder.setInitialState(init)

    builder.addTransition(init,builder.LabelOps singleton 'a', aplus)
    builder.addTransition(aplus,builder.LabelOps singleton 'a', aplus)

    builder.addTransition(aplus,builder.LabelOps singleton 'b', bplus)
    builder.addTransition(bplus,builder.LabelOps singleton 'b', bplus)
    builder.setAccept(bplus, isAccepting = true)
    builder.getAutomaton
  }

  property("parse success") = {

        val exampleInput = "automaton value_0 {init s0; s0 -> s0 [0, 31]; s0 -> s1 [32, 32]; s0 -> s0 [33, 65535]; s1 -> s1 [0, 65535]; accepting s0,s1;};"
    val result = new AutomatonParser().parseAutomaton(exampleInput)
    println(result)
    result.isRight
  }
  property("parse two initial states") = {
    // exactly one initial state
    val exampleInput = "automaton value_0 {init s0,s1; s0 -> s0 [0, 31]; s0 -> s1 [32, 32]; s0 -> s0 [33, 65535]; s1 -> s1 [0, 65535]; accepting s0,s1;};"
    val result = new AutomatonParser().parseAutomaton(exampleInput)
    result.isLeft
  }

  property("parse no initial state") = {
    // exactly one initial state
    val exampleInput = "automaton value_0 {init; s0 -> s0 [0, 31]; s0 -> s1 [32, 32]; s0 -> s0 [33, 65535]; s1 -> s1 [0, 65535]; accepting s0,s1;};"
    val result = new AutomatonParser().parseAutomaton(exampleInput)
    result.isLeft
  }

  property("parse equiv check") = {
    val exampleInput = "automaton value_0 {init s0; s0 -> s0 [0, 65535]; accepting s0;};"
    val result = new AutomatonParser().parseAutomaton(exampleInput)
    val res1 = result.isRight
    val aut = result.right.get
    val aut2 = !aut & anyStringAut
    val res2 = aut2.isEmpty
    val aut3 = aut & !anyStringAut
    val res3 = aut3.isEmpty
    res1 & res2 & res3
  }

  property("parse equiv check 2") = {
    val exampleInput = "automaton value_0 {init s0; s0 -> s1 [97, 97]; s1 -> s1 [97, 97]; s1 -> s2 [98, 98]; s2 -> s2 [98, 98];accepting s2;};"
    val result = new AutomatonParser().parseAutomaton(exampleInput)
    val res1 = result.isRight
    val aut = result.right.get

    val aut2 = !aut & aPlusbPlusAut
    val res2 = aut2.isEmpty

    val aut3 = aut & !aPlusbPlusAut
    val res3 = aut3.isEmpty

    res1 & res2 & res3
  }
}
