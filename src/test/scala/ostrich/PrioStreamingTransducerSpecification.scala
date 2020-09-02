/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2020  Zhilei Han
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

  def toConstants(s : String) : Seq[UpdateOp] = s.map((c) => Constant(c))

  // a trivial PSST which simulate the normal prioritised transducer
  // q0 -- [a-c], ("zz", +0, "adb") --> qf
  val simplePrePostTran = {
    // have a single variable for 'result'
    val builder = PrioStreamingTransducer.getBuilder(1)
    val q0 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true, List(RefVariable(0)))

    builder.addTransition(q0, ('a', 'c'), List(toConstants("zz") ++ List(Offset(0)) ++ toConstants("adb")), qf)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  property("Simple Pre With Pre and Post PreImage") = {
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

  property("replace (b*)a(b*) to \\2a\\2 PreImage") = {
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
    pre(List('b', 'a', 'b')) && !pre(List('a', 'b', 'b')) && 
    pre(List('a', 'b'))
  }

  val abcStar = {
    // PSST that replaces (b + a)*(c + a)* with \2\1 

    val builder = PrioStreamingTransducer.getBuilder(2)
    val q0 = builder.getNewState
    val q1 = builder.getNewState

    val updatex = List(List(RefVariable(0), Offset(0)), List(RefVariable(1)))
    val updatey = List(List(RefVariable(0)), List(RefVariable(1), Offset(0)))

    builder.addTransition(q0, ('a', 'b'), updatex, 1, q0)

    builder.addTransition(q0, BricsTLabelOps.singleton('a'), updatey, 0, q1)
    builder.addTransition(q0, BricsTLabelOps.singleton('c'), updatey, 0, q1)

    builder.addTransition(q1, BricsTLabelOps.singleton('a'), updatey, 1, q1)
    builder.addTransition(q1, BricsTLabelOps.singleton('c'), updatey, 1, q1)

    builder.setInitialState(q0)
    builder.setAccept(q0, true, List(RefVariable(1), RefVariable(0)))
    builder.setAccept(q1, true, List(RefVariable(1), RefVariable(0)))

    builder.getTransducer
  }

  property("replace (b + a)*(c + a)* to \\2a\\2 PreImage") = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    q4.setAccept(true)
    q1.addTransition(new Transition('c', 'c', q2))
    q2.addTransition(new Transition('a', 'a', q3))
    q3.addTransition(new Transition('a', 'a', q4))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val pre = abcStar.preImage(baut)

    pre(List('a', 'a', 'c')) &&
    pre(List('a', 'c', 'a')) && pre(List('c', 'a', 'a')) && !pre(List('a', 'a', 'a'))
  }

  val aStarPSST = {
    // PSST that replaces (a*)a* with \1 

    val builder = PrioStreamingTransducer.getBuilder(1)
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val qf = builder.getNewState

    val nop = List(List(RefVariable(0)))
    val update = List(List(RefVariable(0), Constant('a')))

    builder.addTransition(q0, ('a', 'a'), update, q1)
    builder.addTransition(qf, ('a', 'a'), nop, qf)
    builder.addETransition(q1, nop, 0, qf)
    builder.addETransition(q1, nop, 1, q0) // this is the prioritised transition

    builder.setInitialState(q0)
    builder.setAccept(qf, true, List(RefVariable(0)))

    builder.getTransducer
  }

  property("PSST with epsilon PreImage") = {
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    val q3 = new IDState(3)
    val q4 = new IDState(4)
    val q5 = new IDState(5)
    q5.setAccept(true)
    q1.addTransition(new Transition('a', 'a', q2))
    q2.addTransition(new Transition('a', 'a', q3))
    q3.addTransition(new Transition('a', 'a', q4))
    q4.addTransition(new Transition('a', 'a', q5))
    val aut = new BAutomaton
    aut.setInitialState(q1)
    val baut = new BricsAutomaton(aut)

    val pre = aStarPSST.preImage(baut)

    pre(List('a', 'a', 'a', 'a')) &&
    !pre(List('a', 'a', 'a')) && !pre(List('a', 'a', 'a', 'a', 'a'))
  }

  property("PSST concrete evaluation correct") = {
    (copyPSST("bbbbbabb").get == "bbabb") &&
    (abcStar("bababbbaaaaca").get == "cabababbbaaaa") &&
    (aStarPSST("aaaaa").get == "aaaaa")
  }

}
