package ostrich.parikh.preop

import ap.terfor.Term
import ostrich.automata.Automaton

object IndexOfCEPreOp {
  def apply(matchStr: Seq[Int], startPos: Term, endPos: Term) =
    new IndexOfCEPreOp(matchStr, startPos, endPos)
}

class IndexOfCEPreOp(matchStr: Seq[Int], startPos: Term, endPos: Term) extends CEPreOp {
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    // index = -1
    (Iterator(), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(Seq())
  }
}
