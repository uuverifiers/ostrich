
package ostrich.automata

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object AutomatonTreeSpecification
  extends Properties("AutomatonTreeSpecification") {

  val autAOrB = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val qa = builder.getNewState
    val qb = builder.getNewState
    builder.setAccept(qa, true)
    builder.setAccept(qb, true)
    builder.addTransition(q0, ('a', 'a'),  qa)
    builder.addTransition(q0, ('b', 'b'),  qb)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  val autAOrBAlt = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true)
    builder.addTransition(q0, ('a', 'b'),  qf)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  val autABC = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true)
    builder.addTransition(q0, ('a', 'c'),  qf)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  val autAStar = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    builder.setAccept(q0, true)
    builder.addTransition(q0, ('a', 'a'),  q0)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  val autBStar = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    builder.setAccept(q0, true)
    builder.addTransition(q0, ('b', 'b'),  q0)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  val autCStar = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    builder.setAccept(q0, true)
    builder.addTransition(q0, ('c', 'c'),  q0)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  property("Add one") = {
    val t = new AutomatonTree
    t.insert(autAOrB, 1) == t.insert(autAOrB, 2)
  }

  property("Add two") = {
    val t = new AutomatonTree
    t.insert(autAOrB, 1) != t.insert(autABC, 2)
  }

  property("Add one alternative defs") = {
    val t = new AutomatonTree
    t.insert(autAOrB, 1) == t.insert(autAOrBAlt, 2)
  }

  property("Add three") = {
    val t = new AutomatonTree
    val idAOrB = t.insert(autAOrB, 1)
    val idABC = t.insert(autABC, 2)
    val idAStar = t.insert(autAStar, 3)

    Set(idAOrB, idABC, idAStar).size == 3
  }

  property("Add three with alt") = {
    val t = new AutomatonTree
    val idAOrB = t.insert(autAOrB, 1)
    val idABC = t.insert(autABC, 2)
    val idAStar = t.insert(autAStar, 3)
    val idAOrBAlt = t.insert(autAOrBAlt, 4)

    Set(idAOrB, idABC, idAStar, idAOrBAlt).size == 3
  }

  property("Add six") = {
    val t = new AutomatonTree
    val ids = Seq(autAOrB, autABC, autAStar, autAOrBAlt, autBStar, autCStar)
      .zipWithIndex
      .map({ case (a, i) => t.insert(a, i) })
      .toSet
    ids.size == 5
  }
}
