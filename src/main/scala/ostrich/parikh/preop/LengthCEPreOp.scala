package ostrich.parikh.preop

import ostrich.automata.Automaton
import ap.terfor.{Term, TerForConvenience}
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh._
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._

object LengthCEPreOp {
  def apply(length: Term): LengthCEPreOp = new LengthCEPreOp(length)
}

/**
  * Pre-op for length constraints. 
  * Generate automata like below: 
  * initial state: 0
  * final state: 0
  * transitions: 0 -> (sigma, 1) -> 0
  * registers: (r1)
  * intFormula: r1 === `length`
  * @param length The length 
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
