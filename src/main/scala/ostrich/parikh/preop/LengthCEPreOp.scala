package ostrich.parikh.preop

import ostrich.automata.Automaton
import ap.terfor.{Term, TerForConvenience}
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh._
import TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._

object LengthCEPreOp {
  def apply(length: Term): LengthCEPreOp = new LengthCEPreOp(length)
}

/**
  * Pre-op for length constraints. 
  * @param length The length 
  */
class LengthCEPreOp(length: Term) extends CEPreOp {

  override def toString = "lengthCEPreOp"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val builder = CostEnrichedAutomaton.getBuilder;
    val initalState = builder.initialState;

    // 0 -> (sigma, 1) -> 0
    builder.addTransition(
      initalState,
      builder.LabelOps.sigmaLabel,
      initalState,
      Seq(1)
    )
    builder.setAccept(initalState, true)
    // registers: (r0)
    val registers = Seq(RegisterTerm())
    builder.prependRegisters(registers)
    // intFormula : r0 === `length`
    builder.addNewIntFormula(registers(0) === length)
    (Iterator(Seq(builder.getAutomaton)), Seq())
  }

  /** Evaluate the described function; return <code>None</code> if the function
    * is not defined for the given arguments.
    */
  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(Seq(arguments(0).length))
  }
}
