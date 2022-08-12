package ostrich.parikh.preop

import ostrich.automata.Automaton
import ap.terfor.{Formula, Term, TermOrder, TerForConvenience}
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh._
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._

object LengthCEPreOp {
  def apply(length: Term): LengthCEPreOp = new LengthCEPreOp(length)
}

/** Generate pre-image (regular constraints) of length operation. e.g. length
  * operation `i = length(x)` will generate new constraints `x in A_i` where
  * `A_i` is the computed pre-image.
  */
class LengthCEPreOp(length: Term) extends CEPreOp {
  override def toString = "lengthCEPreOp"

  def addLengthPreRegsFormula(lenPreAut: CostEnrichedAutomatonTrait): Unit = {
    lenPreAut.addIntFormula(lenPreAut.registers(0) === length)
  }
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
    builder.setAccept(initalState, true)
    builder.addRegister(RegisterTerm())

    val baut = builder.getAutomaton
    addLengthPreRegsFormula(baut)
    (Iterator(Seq(baut)), Seq())
  }

  /** Evaluate the described function; return <code>None</code> if the function
    * is not defined for the given arguments.
    */
  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(Seq(arguments(0).length))
  }
}
