package ostrich.cesolver.preop

import scala.collection.breakOut
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.CETransducer
import ostrich.automata.Automaton
import ostrich.cesolver.convenience.CostEnrichedConvenience.automaton2CostEnriched

object CETransducerPreOp {
  def apply(t : CETransducer) = new CETransducerPreOp(t)
}

/**
* Representation of x = T(y)
*/
class CETransducerPreOp(t : CETransducer) extends CEPreOp {

  override def toString = "CETransducer"

  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]] = {
    assert (arguments.size == 1)
    val arg = arguments(0).map(_.toChar).mkString
    for (s <- t(arg)) yield s.toSeq.map(_.toInt)
  }

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val rc = automaton2CostEnriched(resultConstraint)
    (Iterator(Seq(t.preImage(rc))), List())
  }

}
