/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2018-2020  Matthew Hague, Philipp Ruemmer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
package ostrich

import scala.collection.mutable.HashMap

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object PrioStreamingTransducerSpecification
	extends Properties("PrioStreamingTransducer"){

  def seq(s : String) = s.map(_.toInt)

  def toConstants(s : String) = s.map((c) => Constant(c))

  // a trivial PSST which simulate the normal prioritised transducer
  // q0 -- [a-c], ("zz", +0, "adb") --> qf
  val simplePrePostTran = {
    // have a single variable for 'result'
    val builder = PrioStreamingTransducer.getBuilder(1)
    val q0 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true, List(RefVariable(0)))

    builder.addTransition(q0, BricsTLabelOps.singleton('a'), List(toConstants("zzaadb")), qf)
    builder.addTransition(q0, BricsTLabelOps.singleton('b'), List(toConstants("zzbadb")), qf)
    builder.addTransition(q0, BricsTLabelOps.singleton('c'), List(toConstants("zzcadb")), qf)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  val copyPSST = {
    // PSST that replaces (b*)a(b*) with \2a\2, which cannot be modeled 
    // by one-way FT since the relation is not even regular.
    // The capturing group semantics a.k.a greedy matching are not shown here.

    // we only need one var for the second star
    val builder = PrioStreamingTransducer.getBuilder(1)
    val q0 = builder.getNewState
    val qf = builder.getNewState

    val nop = List(List(RefVariable(0)))
    val update = List(List(RefVariable(0), Constant('b')))
    builder.addTransition(q0, BricsTLabelOps.singleton('b'), nop, q0)
    builder.addTransition(q0, BricsTLabelOps.singleton('a'), nop, qf)
    builder.addTransition(qf, BricsTLabelOps.singleton('b'), update, qf)

    builder.setInitialState(q0)
    builder.setAccept(qf, true, List(RefVariable(0), Constant('a'), RefVariable(0)))

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

  property("replace (b*)a(b*) to \\2a\\2 result bab") = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q4.setAccept(true)
    q1.addTransition(new Transition('b', 'b', q2))
    q2.addTransition(new Transition('a', 'a', q3))
    q3.addTransition(new Transition('b', 'b', q4))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val pre = copyPSST.preImage(baut)

    !pre(List('b', 'a', 'b', 'b')) &&
    pre(List('b', 'a', 'b')) && !pre(List('a', 'b', 'b'))
  }
}
