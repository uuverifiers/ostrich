package ostrich

import fastparse.Parsed
import ostrich.automata.{AtomicStateAutomaton, AtomicStateAutomatonAdapter, Automaton, BricsAutomaton, BricsAutomatonBuilder}

import scala.collection.mutable
import fastparse._
import MultiLineWhitespace._

case class Transition(from: String, to: String, range: (Int, Int))
case class AutomatonFragment(name: String, initStates: String, transitions: Seq[Transition], acceptingStates: Seq[String])


class AutomatonParser {
  def identifier[_: P]: P[String] = P(CharsWhileIn("a-zA-Z_0-9").!)

  def number[_: P]: P[Int] = P(CharsWhileIn("0-9").!).map(_.toInt)

  def range[_: P]: P[(Int, Int)] = P("[" ~/ number ~ "," ~ number ~ "]").map { case (start, end) => (start, end) }

  def transition[_: P]: P[Transition] = P(identifier ~ "->" ~ identifier ~ range ~ ";").map {
    case (from, to, range) => Transition(from, to, range)
  }
  def init[_: P]: P[String] = P("init" ~/ identifier ~ ";")
  def accepting[_: P]: P[Seq[String]] = P("accepting" ~/ identifier.rep(1, sep = ",") ~ ";").map(_.toSeq)

  def automaton[_: P]: P[AutomatonFragment] = P("automaton" ~/ identifier ~ "{" ~ init ~ transition.rep ~ accepting ~ "}").map {
    case (name, initStates, transitions, acceptingStates) => AutomatonFragment(name, initStates, transitions, acceptingStates)
  }

  def parseAutomaton(input: String): Either[String, Automaton] = parse(input, automaton(_)) match {
    case Parsed.Success(value, _) => Right(automatonFromFragment(value))
    case f: Parsed.Failure => Left(f.msg)
  }

  def automatonFromFragment(fragment: AutomatonFragment) : Automaton = {
    val builder = new BricsAutomatonBuilder()
    val nameToState = new mutable.HashMap[String,  BricsAutomaton#State]()
    val init = builder.getNewState
    nameToState.put(fragment.initStates, init)
    builder.setInitialState(init)

    for (transition <- fragment.transitions) {
      val source_state  = nameToState.getOrElseUpdate(transition.from, builder.getNewState)
      val destination_state = nameToState.getOrElseUpdate(transition.to, builder.getNewState)
      builder.addTransition(source_state, builder.LabelOps.interval(transition.range._1.toChar,transition.range._2.toChar), destination_state)
    }

    for (accepting <- fragment.acceptingStates) {
      val accepting_state = nameToState.getOrElseUpdate(accepting, builder.getNewState)
      builder.setAccept(accepting_state, isAccepting = true)
    }


    val result = builder.getAutomaton
    Console.err.println("resulta at \n ", result)
    return result
  }
}


/*
// Example usage
val exampleInput = """automaton value_0 {
  init s0,s1;
  s0 -> s0 [0, 31];
  s0 -> s1 [32, 32];
  s0 -> s0 [33, 65535];
  s1 -> s1 [0, 65535];
  accepting s0,s1;
};"""

val result = AutomatonParser.parseAutomaton(exampleInput)
println(result)*/
