package ostrich.automata.afa2

  abstract class Transition(val targets: Seq[Int])



  case class EpsTransition(_targets: Seq[Int])
    extends Transition(_targets) {

    override def toString: String = "eps " + _targets

    def isExistential() = this.targets.size == 1
  }



case class StepTransition(label: Int,
                                              step: Step,
                                              _targets: Seq[Int])
  extends Transition(_targets) {

  override def toString: String = {
    step + "[" + label + "] " + _targets
  }

}


case class SymbTransition(symbLabel: Range, //Range is what changes here.
                                              step: Step,
                                              _targets: Seq[Int])
  extends Transition(_targets) {

  override def toString: String = step + toStringLabel + " " + targets

  def toStringLabel(): String = "[" + symbLabel.start + "-" + (symbLabel.end) + "]"

}





