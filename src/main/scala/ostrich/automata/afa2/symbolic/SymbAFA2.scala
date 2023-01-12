/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2023 Riccado De Masellis. All rights reserved.
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

package ostrich.automata.afa2.symbolic

import ostrich.automata.afa2._
import scala.collection.mutable



/*
Symbolic Alternating 2 way automata:
 - WITHOUT epsilon transition;
  - accepting always at the (right) end of a string;
  - it reads word markers (begin and end of string).
 */
case class SymbAFA2(initialStates : Seq[Int],
                    finalStates   : Seq[Int],
                    transitions   : Map[Int, Seq[SymbTransition]]) {

  assert(!initialStates.isEmpty)

  lazy val states: Set[Int] = {
    val states = new mutable.HashSet[Int]

    states ++= initialStates
    states ++= finalStates

    for ((source, trans) <- transitions;
         t <- trans;
         target <- t.targets) {
      states += source
      states += target
    }

    states.toSet
  }

}

/*
Class EpsAFA2 is a 2AFA with:
- epsilon transition;
- accepting only at the right end of a string;
- can be concrete or symbolic, in general.
 */
case class EpsAFA2(initialState: Int,
                   finalStates: Seq[Int],
                   transitions: Map[Int, Seq[Transition]]) {

  lazy val states = {
    val states = mutable.Set[Int](initialState)
    states ++= finalStates
    for ((s, ts) <- transitions;
         t <- ts) {
      states += s
      states ++= t.targets
    }
    states.toIndexedSeq.sorted
    states
  }
}


/*
Symbolic Alternating 2 way automata:
 - WITH epsilon transitions;
 - accepting both at the beginning and end of the word;
 - it does not read word markings, but it has two kind of final states.
 */
case class SymbExtAFA2(initialStates : Seq[Int],
                       finalLeftStates: Seq[Int],
                       finalRightStates: Seq[Int],
                       transitions   : Map[Int, Seq[Transition]]) {

  assert(!initialStates.isEmpty)

  val states : Set[Int] = {
    val states = new mutable.HashSet[Int]

    states ++= initialStates
    states ++= finalLeftStates
    states ++= finalRightStates

    for ( (source, trans) <- transitions;
          t <- trans;
          target <- t.targets) {
      states += source
      states += target
    }

    states.toSet
  }

  lazy val letters =
    (for ((source, ts) <- transitions.iterator;
          SymbTransition(l, _, _) <- ts.iterator)
    yield l).flatten.toSet.toIndexedSeq.sorted


  override def toString: String = {
    val res = new mutable.StringBuilder()
    res.append("Initial states: " + initialStates + "\n")
    res.append("Final begin states: " + finalLeftStates + "\n")
    res.append("Final end states: " + finalRightStates + "\n")
    for (tr <- transitions) {
      res.append(tr._1 + " goes to: \n")
      for (t <- tr._2) res.append("\t" + t + "\n")
      res.append("\n")
    }
    res.toString()
  }

}
