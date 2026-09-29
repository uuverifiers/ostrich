
package ostrich.automata

import scala.collection.mutable.HashMap

import org.scalacheck.Properties
import org.scalacheck.Prop._

import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}

object TransducerUtilsSpecification
    extends Properties("TransducerUtils"){
  import Transducer._

  val replaceAB = {
    // Transducer q0 -- [a], ("b", NOP, "") --> qf
    val builder = BricsTransducer.getBuilder
    val q0 = builder.getNewState
    val qf = builder.getNewState
    builder.setAccept(qf, true)

    val op = OutputOp("b", NOP, "")
    builder.addTransition(q0, ('a', 'a'), op, qf)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  val incrementChars = {
    // Transducer q0 -- [a-d], ("", +1, "") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("", Plus(1), "")
    builder.addTransition(q0, ('a', 'd'), op, qf)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  val decrementChars = {
    // Transducer q0 -- [a-d], ("", +1, "") --> qf
    val builder = BricsTransducer.getBuilder

    val q0 = builder.getNewState
    val qf = builder.getNewState

    builder.setAccept(qf, true)
    val op = OutputOp("", Plus(-1), "")
    builder.addTransition(q0, ('a', 'd'), op, qf)

    builder.setInitialState(q0)

    builder.getTransducer
  }

  property("emptyIntersection") = {
    Some(true) ==
      TransducerUtils.incompleteTransducerNonEmptyIntersection(Seq(), 4)
  }

  property("singleNonEmpty") = {
    Some(true) == TransducerUtils.incompleteTransducerNonEmptyIntersection(
      Seq(replaceAB),
      4
    )
  }

  property("replaceIncrementNonEmpty") = {
    Some(true) == TransducerUtils.incompleteTransducerNonEmptyIntersection(
      Seq(replaceAB,  incrementChars),
      4
    )
  }

  property("decrementIncrementEmpty") = {
    Some(false) == TransducerUtils.incompleteTransducerNonEmptyIntersection(
      Seq(decrementChars,  incrementChars),
      4
    )
  }
}
