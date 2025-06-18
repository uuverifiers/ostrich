
package ostrich.automata

import scala.collection.mutable.HashMap

import org.scalacheck.Properties
import org.scalacheck.Prop._

object AutomataUtilsSpecification
    extends Properties("AutomataUtils"){

  val autA = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val qa = builder.getNewState
    builder.setAccept(qa, true)
    builder.addTransition(q0, ('a', 'a'),  qa)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

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

  val autAStar = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    builder.setAccept(q0, true)
    builder.addTransition(q0, ('a', 'a'),  q0)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  val autAB = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val q2 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'a'),  q1)
    builder.addTransition(q1, ('b', 'b'),  q2)
    builder.setAccept(q2, true)
    builder.getAutomaton
  }

  val autABStar = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'a'),  q1)
    builder.addTransition(q1, ('b', 'b'),  q1)
    builder.setAccept(q1, true)
    builder.getAutomaton
  }

  val autAOrBThenC = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val q2 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'a'),  q1)
    builder.addTransition(q0, ('b', 'b'),  q1)
    builder.addTransition(q1, ('c', 'c'),  q2)
    builder.setAccept(q2, true)
    builder.getAutomaton
  }

  val autAOrBThenCAlt = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val q2 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'b'),  q1)
    builder.addTransition(q1, ('c', 'c'),  q2)
    builder.setAccept(q2, true)
    builder.getAutomaton
  }

  val autAStarB = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'a'),  q0)
    builder.addTransition(q0, ('b', 'b'),  q1)
    builder.setAccept(q1, true)
    builder.getAutomaton
  }

  val autAThenBStar = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'a'),  q1)
    builder.addTransition(q1, ('b', 'b'),  q0)
    builder.setAccept(q1, true)
    builder.getAutomaton
  }

  val autABMaybe = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val q2 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'a'),  q1)
    builder.addTransition(q1, ('b', 'b'),  q2)
    builder.setAccept(q1, true)
    builder.setAccept(q2, true)
    builder.getAutomaton
  }


  def seq(s : String) = s.map(_.toInt)

  property("isSingleton(a)") = {
    AutomataUtils.isSingleton(autA) == Some(seq("a"))
  }

  property("isSingleton(a|b)") = {
    AutomataUtils.isSingleton(autAOrB).isEmpty
  }

  property("isSingleton(a*)") = {
    AutomataUtils.isSingleton(autAStar).isEmpty
  }

  property("isSingleton(a* & (a|b))") = {
    AutomataUtils.isSingleton(List(autAStar, autAOrB)) == Some(seq("a"))
  }

  property("isSingleton(ab)") = {
    AutomataUtils.isSingleton(autAB) == Some(seq("ab"))
  }

  property("isSingleton(ab* & ab)") = {
    AutomataUtils.isSingleton(List(autABStar, autAB)) == Some(seq("ab"))
  }

  property("isSingleton((a|b)c)") = {
    AutomataUtils.isSingleton(autAOrBThenC).isEmpty
  }

  property("isSingleton((a|b)c) alt") = {
    AutomataUtils.isSingleton(autAOrBThenCAlt).isEmpty
  }

  property("isSingleton(a*b)") = {
    AutomataUtils.isSingleton(autAStarB).isEmpty
  }

  property("isSingleton((ab)*)") = {
    AutomataUtils.isSingleton(autAThenBStar).isEmpty
  }

  property("isSingleton((ab)?)") = {
    AutomataUtils.isSingleton(autABMaybe).isEmpty
  }
}
