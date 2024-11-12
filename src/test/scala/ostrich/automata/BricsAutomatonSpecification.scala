
package ostrich.automata

import org.scalacheck.Properties

object BricsAutomatonSpecification extends Properties("BricsAutomaton") {

  property("Bug in disjoint labels") = {
    val builder = new BricsAutomatonBuilder

    val qi = builder.initialState
    val qf = builder.getNewState
    builder.setAccept(qi, true)
    builder.setAccept(qf, true)
    builder.addTransition(qi, (Char.MinValue, 'A'), qi)
    builder.addTransition(qi, ('D', Char.MaxValue), qi)
    builder.addTransition(qi, ('b', 'b'), qf)
    builder.addTransition(qf, (Char.MinValue, 'B'), qf)
    builder.addTransition(qf, ('D', Char.MaxValue), qf)

    val aut = builder.getAutomaton
    val disjoint = Set(aut.labelEnumerator.enumDisjointLabels)

//    println(disjoint)

    true
  }
}
