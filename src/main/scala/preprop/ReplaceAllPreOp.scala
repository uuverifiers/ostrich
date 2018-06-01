
package strsolver.preprop

import dk.brics.automaton.Transition

object ReplaceAllPreOp {
  /**
   * Create a ReplaceAllPreOp(a) PreOp object
   */
  def apply(a : Char) = new ReplaceAllPreOp(a)
}

class ReplaceAllPreOp(val a : Char) extends PreOp {

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : Iterator[Seq[Automaton]] = resultConstraint match {

    case resultConstraint : BricsAutomaton =>
      for (box <- CaleyGraph(resultConstraint).getNodes.iterator)
        yield Seq(getYConstraint(resultConstraint, a, box)) ++
              getZConstraints(resultConstraint, box)

    case _ =>
      throw new IllegalArgumentException
  }

  /**
   * The constraint on Y from the preimage of aut, using box as the
   * guess of state pairs the value of z can move from and to
   *
   * @param aut
   * @param a the char being replaced
   * @param box
   * @return pre of aut when guess is box
   */
  private def getYConstraint(aut : BricsAutomaton,
                             a : Char,
                             box : Box) : Automaton = {
    // A \ a-transitions
    val (aut2, map) = aut.substWithStateMap((min, max, addTran) => {
      if (min <= a && a <= max)
        if (min < a) addTran(min, (a-1).toChar)
        if (a < max) addTran((a+1).toChar, max)
      else
        addTran(min, max)
    })
    // (A \ a-transition) + {q1 -a-> q2 | (q1,q2) in box}
    for ((q1, q2) <- box.edges)
      map(q1).addTransition(new Transition(a, a, map(q2)))

    aut2
  }

  /**
   * The constraints that Z must satisfy q -- val(z) --> q' for each
   * (q,q') in box
   *
   * @param aut
   * @param box
   * @return list of automaton contraints to be consistent with box
   */
  private def getZConstraints(aut : BricsAutomaton,
                              box : Box) : Seq[Automaton] =
    box.edges.map({ case (q1, q2) =>
      // TODO: painful to copy, can we improve?
      val (aut2, map) = aut.cloneWithStateMap
      aut2.setInitialState(map(q1))
      aut2.getAcceptStates.foreach(_.setAccept(false))
      map(q2).setAccept(true)
      aut2
    }).toSeq
}
