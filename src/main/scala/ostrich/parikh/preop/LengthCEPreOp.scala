package ostrich.parikh.preop

import ostrich.automata.Automaton
import ap.terfor.TerForConvenience
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh._
import TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._
import ap.terfor.linearcombination.LinearCombination

object LengthCEPreOp {
  def apply(length: LinearCombination): LengthCEPreOp = new LengthCEPreOp(length)
}

/**
  * Pre-op for length constraints. 
  * @param length The length 
  */
class LengthCEPreOp(length: LinearCombination) extends CEPreOp {

  override def toString = "lengthCEPreOp"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val ceAut = new CostEnrichedAutomaton
    val initalState = ceAut.initialState

    // 0 -> (sigma, 1) -> 0
    ceAut.addTransition(
      initalState,
      ceAut.LabelOps.sigmaLabel,
      initalState,
      Seq(1)
    )
    ceAut.setAccept(initalState, true)
    // registers: (r0)
    ceAut.registers = Seq(RegisterTerm())
    // intFormula : r0 === `length`
    ceAut.regsRelation = length === ceAut.registers(0)
    (Iterator(Seq(ceAut)), Seq())
  }

  /** Evaluate the described function; return <code>None</code> if the function
    * is not defined for the given arguments.
    */
  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(Seq(arguments(0).length))
  }
}
