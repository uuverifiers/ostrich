
package strsolver.preprop

object ReplaceAllPreOp {
  /**
   * Create a ReplaceAllPreOp(a) PreOp object
   */
  def apply(a : Char) = new ReplaceAllPreOp(a)
}

class ReplaceAllPreOp(val a : Char) extends PreOp {

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton) : Iterator[Seq[Automaton]] = {
    val rc = resultConstraint
    for (box <- CaleyGraph[rc.type](rc).getNodes.iterator) yield {
      val ycons = Seq(rc.replaceTransitions(a, box.getEdges))
      val zcons =
        box.getEdges.map({ case (q1, q2) => rc.setInitAccept(q1, q2) }).toSeq
      ycons ++ zcons
    }
  }

}
