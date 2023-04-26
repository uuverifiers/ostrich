package ostrich.parikh.preop

import ostrich.automata.Automaton
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh._
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ap.terfor.Term

object LengthCEPreOp {
  def apply(length: Term): LengthCEPreOp = new LengthCEPreOp(length)

  def lengthPreimage(length: Term) : CostEnrichedAutomatonBase = {
    val preimage = new CostEnrichedAutomaton
    val initalState = preimage.initialState

    // 0 -> (sigma, 1) -> 0
    preimage.addTransition(
      initalState,
      preimage.LabelOps.sigmaLabel,
      initalState,
      Seq(1)
    )
    preimage.setAccept(initalState, true)
    // registers: (r0)
    preimage.registers = Seq(RegisterTerm())
    // intFormula : r0 === `length`
    import ap.terfor.TerForConvenience._ 
    import ostrich.parikh.TermGeneratorOrder._
    preimage.regsRelation = length === preimage.registers(0)
    preimage
  }
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
    (Iterator(Seq(LengthCEPreOp.lengthPreimage(length))), Seq())
  }

  /** Evaluate the described function; return <code>None</code> if the function
    * is not defined for the given arguments.
    */
  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(Seq(arguments(0).length))
  }
}
