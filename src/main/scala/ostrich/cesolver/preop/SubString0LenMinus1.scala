package ostrich.cesolver.preop

import ostrich.automata.Automaton
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.CEBasicOperations
import ap.parser.IExpression

class SubString0LenMinus1 extends CEPreOp {
  override def toString = "SubString0LenMinus1"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val preimage = CEBasicOperations.concatenate(
      Seq(
        res,
        LengthCEPreOp.lengthPreimage(1)
      )
    )
    (Iterator(Seq(preimage)), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(arguments(0).slice(0, arguments(0).length - 1))
  }

}
