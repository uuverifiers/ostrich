package ostrich.automata.afa2


import ap.util.Combinatorics

object AFA2StateDuplicator {

  def apply(afa : AFA2) : AFA2 =
    new AFA2StateDuplicator(afa).result

}

/**
 * Class to duplicate states in such a way that they can be
 * categorised into ir, ll, lr, rl, rr, rf.
 */
class AFA2StateDuplicator(afa : AFA2) {

  import AFA2.{Step, StepTransition}
  import afa.{finalStates, initialStates, transitions}

  def ir(s : Int) = 6*s + 0
  def ll(s : Int) = 6*s + 1
  def lr(s : Int) = 6*s + 2
  def rl(s : Int) = 6*s + 3
  def rr(s : Int) = 6*s + 4
  def rf(s : Int) = 6*s + 5

  val newInitial =
    for (s <- initialStates) yield ir(s)

  val newFinal =
    (for (s <- finalStates) yield rf(s)) ++
    (for (s <- initialStates; if finalStates contains s) yield ir(s))

  val flatNewTransitions =
    (for ((source, ts)                     <- transitions.iterator;
          trans@StepTransition(_, step, _) <- ts.iterator;
          newSource                        <- rewrSources(source, step);
          newTrans                         <- rewrTransition(trans))
     yield (newSource, newTrans)).toList

  val newTransitions =
    flatNewTransitions groupBy (_._1) mapValues { l => l map (_._2) }

  def rewrSources(s : Int, step : Step) : Iterator[Int] =
    step match {
      case AFA2.Left  =>
        Iterator(ll(s), rl(s))
      case AFA2.Right =>
        Iterator(lr(s), rr(s)) ++
        (if (initialStates contains s) Iterator(ir(s)) else Iterator())
    }

  def rewrTransition(t : StepTransition) : Iterator[StepTransition] = {
    val StepTransition(label, step, targets) = t
    val domains =
      for (s <- targets) yield {
        step match {
          case AFA2.Left  =>
            List(ll(s), lr(s))
          case AFA2.Right =>
            List(rl(s), rr(s)) ++
            (if (finalStates contains s) List(rf(s)) else List())
        }
      }
    for (comb <- Combinatorics.cartesianProduct(domains.toList))
    yield StepTransition(label, step, comb)
  }

  val result =
    new AFA2(newInitial, newFinal, newTransitions).restrictToReachableStates

}
