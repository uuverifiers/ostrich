package ostrich.parikh.preop

import ap.terfor.Term
import ostrich.automata.Automaton
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.automata.BricsAutomatonWrapper
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ostrich.parikh.RegisterTerm
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._

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

    val ceAut = new CostEnrichedAutomaton
    val lbOps = ceAut.LabelOps

    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val noUpdate = Seq.fill(res.registers.size)(0)
    val resState2new = res.states.map { case s =>
      (s, ceAut.newState())
    }.toMap

    val initialState = ceAut.initialState

    // 0 -> (sigma, (1,0)) -> 0 to update `beginIdx`
    ceAut.addTransition(
      initialState,
      lbOps.sigmaLabel,
      initialState,
      Seq(1, 0) ++ noUpdate
    )
    // 0 -> epsilon -> resState2new(res.initialState)
    res.outgoingTransitionsWithVec(res.initialState).foreach {
      case (t, lbl, vec) =>
        ceAut
          .addTransition(initialState, lbl, resState2new(t), vec ++ Seq(0, 1))
    }
    // i -> (a, (0,1)) -> j to update `length`, where char a and state
    // i,j from `resultConstraint`
    res.transitionsWithVec.foreach { case (s, lbl, t, vec) =>
      ceAut.addTransition(
        resState2new(s),
        lbl,
        resState2new(t),
        Seq(0, 1) ++ vec
      )
    }

    // resState2new(res.finalState) -> (sigma, (0, 0)) -> f
    val finalState = ceAut.newState()
    ceAut.setAccept(finalState, true)
    res.acceptingStates.foreach { case s =>
      ceAut.setAccept(resState2new(s), true)
      ceAut.addTransition(
        resState2new(s),
        lbOps.sigmaLabel,
        finalState,
        Seq(0, 0) ++ noUpdate
      )
    }

    // f -> (sigma, (0,0)) -> f to stand for tail string
    ceAut.addTransition(
      finalState,
      lbOps.sigmaLabel,
      finalState,
      Seq(0, 0) ++ noUpdate
    )

    // registers : (r0, r1)
    val registers = Seq.fill(2)(RegisterTerm())
    ceAut.registers = registers ++ res.registers
    ceAut.regsRelation = (
      (registers(0) === beginIdx) & (registers(1) === length)
    )

    (
      Iterator(
        Seq(
          ceAut,
          BricsAutomatonWrapper.makeAnyString,
          BricsAutomatonWrapper.makeAnyString
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
