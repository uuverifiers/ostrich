
package strsolver.preprop

import ap.terfor.Term

object ReplaceAllPreOp {
  def apply(a : Char) = new ReplaceAllPreOp(a)

  /**
   * preop for a replaceall(_, w, _) for whatever we get out of
   * PrepropSolver.
   */
  def apply(w : List[Either[Int,Term]]) =
    if (w.length == 1) {
      w(0) match {
        case Left(c) => {
          new ReplaceAllPreOp(c.toChar)
        }
        case _ =>
          throw new IllegalArgumentException("ReplaceAllPreOp only supports single character replacement.")
      }
    } else {
      throw new IllegalArgumentException("ReplaceAllPreOp only supports single character replacement")
    }
}

/**
* Representation of x = replaceall(y, a, z) where a is a single
* character.
*/
class ReplaceAllPreOp(a : Char) extends PreOp {

  override def toString = "replaceall"

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton) : Iterator[Seq[Automaton]] = {
    val rc : AtomicStateAutomaton = resultConstraint match {
      case resCon : AtomicStateAutomaton => resCon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp needs an AtomicStateAutomaton")
    }
    val zcons = argumentConstraints(1).map(_ match {
      case zcon : AtomicStateAutomaton => zcon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp can only use AtomicStateAutomaton constraints.")
    })
    val cg = CaleyGraph[rc.type](rc)

    for (box <- cg.getAcceptNodes(zcons).iterator) yield {
      val newYCons = Seq(rc.replaceTransitions(a, box.getEdges))
      val newZCons =
        box.getEdges.map({ case (q1, q2) => rc.setInitAccept(q1, q2) }).toSeq
      newYCons ++ newZCons
    }
  }
}
