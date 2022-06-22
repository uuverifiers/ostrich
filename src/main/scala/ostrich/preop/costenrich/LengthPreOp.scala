package ostrich.preop.costenrich

import ostrich.automata.Automaton
import ostrich.automata.costenrich.CostEnrichedAutomaton
import ap.terfor.{Formula, Term, TermOrder, TerForConvenience}
import ostrich.automata.costenrich.RegisterTerm

object LengthPreOp {
  def apply(length: Term): LengthPreOp = new LengthPreOp(length)
}

/** Generate pre-image (regular constraints) of length operation. e.g. length
  * operation `i = length(x)` will generate new constraints `x in A_i` where
  * `A_i` is the computed pre-image.
  */
class LengthPreOp(length: Term) extends CostEnrichedPreOp {
  override def toString = "length"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val builder = CostEnrichedAutomaton.getBuilder;
    val initalState = builder.initialState;
    builder.addTransition(
      initalState,
      builder.LabelOps.sigmaLabel,
      initalState,
      Seq(1)
    )
    builder.addRegister(RegisterTerm())

    (Iterator(Seq(builder.getAutomaton)), Seq())
  }

  /** Evaluate the described function; return <code>None</code> if the function
    * is not defined for the given arguments.
    */
  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(Seq(arguments(0).length))
  }

  /** Given a sequence of registers for the arguments and registers for the
    * result, derive a sequence of formula. It is sound to just return `true`
    */
  override def lengthConstraints(
      preImageConstraints: Iterator[Seq[CostEnrichedAutomaton]],
      resultConstraint: CostEnrichedAutomaton
  )(implicit order: TermOrder): Iterator[Formula] = {
    import TerForConvenience._
    import ostrich.CostEnrichedConvenience._

    val lengthRegister = preImageConstraints.next.head.registers(0)

    Iterator(
      lengthRegister === length
    )
  }
}
