package ostrich.automata.afa2

sealed trait Step //extends Product with Serializable

case object Left extends Step {
  override def toString: String = "<-"
}

case object Right extends Step {
  override def toString: String = "->"
}
