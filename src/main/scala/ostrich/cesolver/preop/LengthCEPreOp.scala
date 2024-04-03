package ostrich.cesolver.preop

import ostrich.automata.Automaton
import ostrich.cesolver.automata.CostEnrichedAutomaton
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ostrich.cesolver.util.TermGenerator
import ap.parser.IExpression
import ap.basetypes.IdealInt
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.cesolver.util.ParikhUtil

object LengthCEPreOp {

  private val termGen = TermGenerator()

  def apply(length: ITerm): LengthCEPreOp = new LengthCEPreOp(length)

  def lengthPreimage(
      length: ITerm,
      newReg: Boolean = true
  ): CostEnrichedAutomatonBase = {
    val preimage = new CostEnrichedAutomaton
    val initalState = preimage.initialState

    length match {
      case IExpression.Const(IdealInt(value)) =>
        PreOpUtil.automatonWithLen(value)
      case _: ITerm =>
        // 0 -> (sigma, 1) -> 0
        preimage.addTransition(
          initalState,
          preimage.LabelOps.sigmaLabel,
          initalState,
          Seq(1)
        )
        preimage.setAccept(initalState, true)
        // registers: (r0)
        val reg = if (newReg) termGen.registerTerm else length
        preimage.registers = Seq(reg)
        // intFormula : r0 === `length`
        if (newReg) preimage.regsRelation = reg === length
        preimage
    }

  }
}

/** Pre-op for length constraints.
  * @param length
  *   The length
  */
class LengthCEPreOp(length: ITerm) extends CEPreOp {

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
