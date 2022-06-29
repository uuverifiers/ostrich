package ostrich.preop.costenrich

import ostrich.automata.Automaton
import ostrich.automata.costenrich.CostEnrichedAutomaton
import ostrich.automata.InitFinalAutomaton
import ap.terfor.{Formula, TermOrder}
import ap.terfor.TerForConvenience._

object ConcatCEPreOp extends CostEnrichedPreOp {
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = resultConstraint match {
    case resultAut: CostEnrichedAutomaton => {
      val argLengths: Seq[Option[(Automaton, Seq[Int])]] = (
        for (argAuts <- argumentConstraints) yield {
          (for (
            aut <- argAuts;
            if aut.isInstanceOf[CostEnrichedAutomaton];
            lengths <- aut
              .asInstanceOf[CostEnrichedAutomaton]
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
              List(
                InitFinalAutomaton.setFinal(resultAut, Set(s)),
                InitFinalAutomaton.setInitial(resultAut, s)
              )
            }
          val relatedArgs = List(List(lenAut), List())
          (preImage.iterator, relatedArgs)
        case None =>
          argLengths(1) match {
            case Some((lenAut, lengths))
                if resultAut.uniqueAcceptedWordLengths.isDefined => {
              // the suffix needs to be of a certain length
              val resLengths = resultAut.uniqueAcceptedWordLengths.get
              val postImage =
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
                  List(
                    InitFinalAutomaton.setFinal(resultAut, Set(s)),
                    InitFinalAutomaton.setInitial(resultAut, s)
                  )
                }
              val relatedArgs = List(List(), List(lenAut))
              (postImage.iterator, relatedArgs)
            }
            case None =>
              (
                for (s <- resultAut.states.iterator) yield {
                  List(
                    InitFinalAutomaton.setFinal(resultAut, Set(s)),
                    InitFinalAutomaton.setInitial(resultAut, s)
                  )
                },
                List()
              )
          }
      }
    }
    case _ => throw new IllegalArgumentException
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] =
    Some(arguments(0) ++ arguments(1))

  override def lengthConstraints(
      preImageConstraints: Seq[CostEnrichedAutomaton],
      resultConstraint: CostEnrichedAutomaton
  )(implicit order: TermOrder): Formula = {
    val resultRegisters = resultConstraint.registers
    val preImageRegsGroup = preImageConstraints.map(_.registers).transpose
    conj(
      preImageRegsGroup
        .zip(resultRegisters)
        .map { case (_preImageRegs, _resultReg) =>
          _preImageRegs.reduceLeft(_ + _) === _resultReg
        }
    )
  }

}
