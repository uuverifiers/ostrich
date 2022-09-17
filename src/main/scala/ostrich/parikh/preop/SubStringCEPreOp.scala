package ostrich.parikh.preop

import ap.terfor.Term
import ostrich.automata.Automaton
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.RegisterTerm
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._
import CostEnrichedAutomatonTrait.{getRegisters}

object SubStringCEPreOp {
  def apply(beginIdx: Term, length: Term) =
    new SubStringCEPreOp(beginIdx, length)
}

/** Pre-operator for substring constraint.
  * @param beginIdx
  *   the begin index
  * @param length
  *   the max length of subtring
  */
class SubStringCEPreOp(beginIdx: Term, length: Term) extends CEPreOp {
  override def toString(): String =
    "subStringCEPreOp"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {

    val builder = CostEnrichedAutomaton.getBuilder
    val lbOps = builder.LabelOps

    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonTrait]
    val noUpdate = Seq.fill(getRegisters(res).size)(0)
    val resState2new = res.states.map { case s =>
      (s, builder.getNewState)
    }.toMap

    val initialState = builder.getNewState
    builder.setInitialState(initialState)

    // 0 -> (sigma, (1,0)) -> 0 to update `beginIdx`
    builder.addTransition(
      initialState,
      lbOps.sigmaLabel,
      initialState,
      Seq(1, 0) ++ noUpdate
    )
    // 0 -> epsilon -> resState2new(res.initialState)
    res.outgoingTransitionsWithVec(res.initialState).foreach {
      case (t, lbl, vec) =>
        builder
          .addTransition(initialState, lbl, resState2new(t), vec ++ Seq(0, 1))
    }
    // i -> (a, (0,1)) -> j to update `length`, where char a and state
    // i,j from `resultConstraint`
    res.transitionsWithVec.foreach { case (s, lbl, t, vec) =>
      builder.addTransition(
        resState2new(s),
        lbl,
        resState2new(t),
        Seq(0, 1) ++ vec
      )
    }

    // resState2new(res.finalState) -> (sigma, (0, 0)) -> f
    val finalState = builder.getNewState
    builder.setAccept(finalState, true)
    res.acceptingStates.foreach { case s =>
      builder.setAccept(resState2new(s), true)
      builder.addTransition(
        resState2new(s),
        lbOps.sigmaLabel,
        finalState,
        Seq(0, 0) ++ noUpdate
      )
    }

    // f -> (sigma, (0,0)) -> f to stand for tail string
    builder.addTransition(
      finalState,
      lbOps.sigmaLabel,
      finalState,
      Seq(0, 0) ++ noUpdate
    )

    // registers : (r0, r1)
    val registers = Seq.fill(2)(RegisterTerm())
    builder.prependRegisters(registers ++ getRegisters(res))
    builder.addNewIntFormula(
      (registers(0) === beginIdx) & (registers(1) === length)
    )

    (
      Iterator(
        Seq(
          builder.getAutomaton,
          CostEnrichedAutomaton.makeAnyString,
          CostEnrichedAutomaton.makeAnyString
        )
      ),
      Seq()
    )
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val beginIdx = arguments(1)(0)
    val length = arguments(2)(0)
    val bigString = arguments(0)
    if (beginIdx < 0 || length < 0) {
      Some(Seq()) // empty string
    } else {
      Some(bigString.slice(beginIdx, beginIdx + length))
    }
  }

}
