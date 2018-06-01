
package strsolver.preprop

import ap.terfor.linearcombination.LinearCombination

object ReplaceAllPreOp extends PreOp {

  override def toString = "replaceall"

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton) : Iterator[Seq[Automaton]] = {
    // TODO: assumes argumentConstraints(1)(0) is the single character to
    // replace -- how to do this properly?
    val a = argumentConstraints(1)(0).getAcceptedWord match {
      case Some(w) => w(0).toChar
      case _ => throw new IllegalArgumentException("Second argument in replaceall must be a single character")
    }
    val rc = resultConstraint
    for (box <- CaleyGraph[rc.type](rc).getNodes.iterator) yield {
      val ycons = Seq(rc.replaceTransitions(a, box.getEdges))
      val zcons =
        box.getEdges.map({ case (q1, q2) => rc.setInitAccept(q1, q2) }).toSeq
      ycons ++ zcons
    }
  }

}
