package ostrich.automata.afa2

/*
Trait used to represent which symbol (left or right to the current head in the string)
the two-way (alternating) automata should read on a specific transition.
 */
sealed trait Step //extends Product with Serializable

case object Left extends Step {
  override def toString: String = "<-"
}

case object Right extends Step {
  override def toString: String = "->"
}
