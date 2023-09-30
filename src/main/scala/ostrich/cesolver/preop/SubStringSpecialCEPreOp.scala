package ostrich.cesolver.preop

import ostrich.automata.Automaton
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.CEBasicOperations
import ap.parser.IExpression

// substring(s, 0, len(s) - 1)
class SubString0LenMinus1 extends CEPreOp {
  override def toString = "SubString0LenMinus1"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val preImage = CEBasicOperations.concatenate(
      Seq(
        res,
        LengthCEPreOp.lengthPreimage(1)
      )
    )
    if (res.isAccept(res.initialState))
      preImage.setAccept(preImage.initialState, true)
      
    (Iterator(Seq(preImage)), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(arguments(0).slice(0, arguments(0).length - 1))
  }

}

// substring(s, len(s) - 1, 1)
class SubStringLenMinus1_1 extends CEPreOp {
  override def toString = "SubStringLenMinus1_1"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
   (Iterator(Seq()), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(arguments(0).slice(arguments(0).length - 1, 1))
  }

}

