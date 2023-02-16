package ostrich.parikh.preop

import ostrich.automata.Automaton
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.automata.CostEnrichedInitFinalAutomaton
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._
import ostrich.parikh.automata.CostEnrichedAutomatonBase
object ConcatCEPreOp extends CEPreOp {
  override def toString(): String = "concatCEPreOp"

  def addConcatPreRegsFormula(
      concatLeft: CostEnrichedAutomatonBase,
      concatRight: CostEnrichedAutomatonBase,
      result: CostEnrichedAutomatonBase
  ): Unit = {
    val leftRegs = concatLeft.registers
    val rightRegs = concatRight.registers
    val resultRegs = result.registers
    val derivedRegsRelation = conj(leftRegs.zipWithIndex.map { case (reg, i) =>
      (reg + rightRegs(i)) === resultRegs(i)
    })
    val letfRegsRelation = concatLeft.regsRelation
    val resRegsRelation = result.regsRelation
    concatLeft.regsRelation = conj(letfRegsRelation, derivedRegsRelation, resRegsRelation)
  }

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val resultAut = automaton2CostEnriched(resultConstraint)
    val argLengths = (
      for (argAuts <- argumentConstraints) yield {
        (for (
          aut <- argAuts;
          if aut.isInstanceOf[CostEnrichedAutomatonBase];
          lengths <- aut
            .asInstanceOf[CostEnrichedAutomatonBase]
            .uniqueAcceptedWordLengths
        )
          yield (aut, lengths)).toSeq.headOption
      }
    ).toSeq

    argLengths(0) match {
      case Some((lenAut, lengths)) =>
        // the prefix needs to be of a certain length
        val preImage =
          for (
            s <- resultAut.states;
            if ((resultAut.uniqueLengthStates get s) match {
              case Some(l) => lengths.contains(l)
              case None    => true
            })
          ) yield {
            val concatLeft =
              CostEnrichedInitFinalAutomaton.setFinal(resultAut, Set(s))
            val concatRight =
              CostEnrichedInitFinalAutomaton.setInitial(resultAut, s)
            addConcatPreRegsFormula(concatLeft, concatRight, resultAut)
            List(concatLeft, concatRight)
          }
        val relatedArgs = List(List(lenAut), List())
        (preImage.iterator, relatedArgs)
      case None =>
        argLengths(1) match {
          case Some((lenAut, lengths))
              if resultAut.uniqueAcceptedWordLengths.isDefined => {
            // the suffix needs to be of a certain length
            val resLengths = resultAut.uniqueAcceptedWordLengths.get
            val preImage =
              for (
                s <- resultAut.states;
                if ((resultAut.uniqueLengthStates get s) match {
                  case Some(l) =>
                    resLengths
                      .find(resLength =>
                        lengths.find(_ + l == resLength).isDefined
                      )
                      .isDefined
                  case None => true
                })
              ) yield {
                val concatLeft =
                  CostEnrichedInitFinalAutomaton.setFinal(resultAut, Set(s))
                val concatRight =
                  CostEnrichedInitFinalAutomaton.setInitial(resultAut, s)
                addConcatPreRegsFormula(concatLeft, concatRight, resultAut)
                List(concatLeft, concatRight)
              }
            val relatedArgs = List(List(), List(lenAut))
            (preImage.iterator, relatedArgs)
          }
          case _ =>
            val preImage =
              for (s <- resultAut.states) yield {
                val concatLeft =
                  CostEnrichedInitFinalAutomaton.setFinal(resultAut, Set(s))
                val concatRight =
                  CostEnrichedInitFinalAutomaton.setInitial(resultAut, s)
                addConcatPreRegsFormula(concatLeft, concatRight, resultAut)
                List(concatLeft, concatRight)
              }
            (preImage.iterator, List())
        }
    }
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] =
    Some(arguments(0) ++ arguments(1))
}
