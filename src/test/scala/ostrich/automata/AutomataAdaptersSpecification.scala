
package ostrich.automata

import scala.collection.mutable.HashMap

import org.scalacheck.Properties
import org.scalacheck.Prop._

object AutomataAdaptersSpecification
    extends Properties("AutomataAdapters"){

  val autAStar = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    builder.setAccept(q0, true)
    builder.addTransition(q0, ('a', 'a'),  q0)
    builder.setInitialState(q0)
    builder.getAutomaton
  }

  val autAPlusOrBThenC = {
    val builder = new BricsAutomatonBuilder
    val q0 = builder.getNewState
    val q1 = builder.getNewState
    val q2 = builder.getNewState
    val q3 = builder.getNewState
    builder.setInitialState(q0)
    builder.addTransition(q0, ('a', 'a'),  q1)
    builder.addTransition(q1, ('a', 'a'),  q1)
    builder.addTransition(q1, ('c', 'c'),  q3)
    builder.addTransition(q0, ('b', 'b'),  q2)
    builder.addTransition(q2, ('c', 'c'),  q3)
    builder.setAccept(q3, true)
    builder.getAutomaton
  }

  def seq(s : String) = s.map(_.toInt)

  property("aStar no bound") = {
    val aut = LengthBoundedAutomaton(autAStar, None, None)
    (
      aut(seq(""))
        && aut(seq("a"))
        && aut(seq("aaaaaaaaa"))
        && aut(seq("aaaaaaaaaaaaaaaaa"))
    )
  }

  property("aStar min bound") = {
    val aut = LengthBoundedAutomaton(autAStar, Some(3), None)
    (
      !aut(seq(""))
        && !aut(seq("a"))
        && aut(seq("aaaaaaaaa"))
        && aut(seq("aaaaaaaaaaaaaaaaa"))
    )
  }

  property("aStar max bound") = {
    val aut = LengthBoundedAutomaton(autAStar, None, Some(3))
    (
      aut(seq(""))
        && aut(seq("a"))
        && !aut(seq("aaaaaaaaa"))
        && !aut(seq("aaaaaaaaaaaaaaaaa"))
    )
  }

  property("aStar both bounds") = {
    val aut = LengthBoundedAutomaton(autAStar, Some(2), Some(3))
    (
      !aut(seq(""))
        && aut(seq("aa"))
        && aut(seq("aaa"))
        && !aut(seq("aaaa"))
        && !aut(seq("aaaaaaaaaaaaaaaaa"))
    )
  }

  property("autAPlusOrBThenC no bound") = {
    val aut = LengthBoundedAutomaton(autAPlusOrBThenC, None, None)
    (
      aut(seq("ac"))
        && aut(seq("bc"))
        && aut(seq("aaaaaaaaac"))
        && aut(seq("aaaaaaaaaaaaaaaaac"))
    )
  }

  property("autAPlusOrBThenC min bound") = {
    val aut = LengthBoundedAutomaton(autAPlusOrBThenC, Some(3), None)
    (
      !aut(seq("ac"))
        && !aut(seq("bc"))
        && aut(seq("aaaaaaaaac"))
        && aut(seq("aaaaaaaaaaaaaaaaac"))
    )
  }

  property("autAPlusOrBThenC max bound") = {
    val aut = LengthBoundedAutomaton(autAPlusOrBThenC, None, Some(3))
    (
      aut(seq("ac"))
        && aut(seq("bc"))
        && !aut(seq("aaaaaaaaac"))
        && !aut(seq("aaaaaaaaaaaaaaaaac"))
    )
  }

  property("autAPlusOrBThenC both bounds") = {
    val aut = LengthBoundedAutomaton(autAPlusOrBThenC, Some(3), Some(4))
    (
      !aut(seq("ac"))
        && !aut(seq("bc"))
        && aut(seq("aac"))
        && aut(seq("aaac"))
        && !aut(seq("aaaaaaaaaaaaaaaaac"))
    )
  }
}
