/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Oliver Markgraf. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich

import fastparse.Parsed
import ostrich.automata.{AtomicStateAutomaton, AtomicStateAutomatonAdapter, Automaton, BricsAutomaton, BricsAutomatonBuilder}

import scala.collection.mutable
import fastparse._
import MultiLineWhitespace._

case class Transition(from: String, to: String, range: (Int, Int))
case class AutomatonFragment(name: String, initStates: String, transitions: Seq[Transition], acceptingStates: Seq[String])


class AutomatonParser {
  def identifier[$: P]: P[String] = P(CharsWhileIn("a-zA-Z_0-9").!)

  def number[$: P]: P[Int] = P(CharsWhileIn("0-9").!).map(_.toInt)

  def range[$: P]: P[(Int, Int)] = P("[" ~/ number ~ "," ~ number ~ "]").map { case (start, end) => (start, end) }

  def transition[$: P]: P[Transition] = P(identifier ~ "->" ~ identifier ~ range ~ ";").map {
    case (from, to, range) => Transition(from, to, range)
  }
  def init[$: P]: P[String] = P("init" ~/ identifier ~ ";")
  def accepting[$: P]: P[Seq[String]] = P("accepting" ~/ identifier.rep(1, sep = ",") ~ ";").map(_.toSeq)

  def automaton[$: P]: P[AutomatonFragment] = P("automaton" ~/ identifier ~ "{" ~ init ~ transition.rep ~ accepting ~ "}").map {
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
//    Console.err.println("Result at \n ", result)
    result
  }
}


/*
// Example usage
val exampleInput = """automaton value_0 {
  init s0;
  s0 -> s0 [0, 31];
  s0 -> s1 [32, 32];
  s0 -> s0 [33, 65535];
  s1 -> s1 [0, 65535];
  accepting s0,s1;
};"""

val result = AutomatonParser.parseAutomaton(exampleInput)
println(result)*/
