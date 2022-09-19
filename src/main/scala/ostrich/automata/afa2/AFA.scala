package ostrich.automata.afa2


import scala.collection.mutable
import scala.collection.mutable.{HashSet => MHashSet}

object AFA2 {

  sealed trait Step extends Product with Serializable
  case object Left  extends Step {
    override def toString: String = "<-"
  }
  case object Right extends Step {
    override def toString: String = "->"
  }

  //TODO: change Position to trait and LeftMost, Any and RightMost as case objects
  object Position extends Enumeration {
    val LeftMost, Any, RightMost = Value
  }

  abstract sealed class Transition(val targets : Seq[Int])

  case class StepTransition(label   : Int,
                            step    : Step,
                            _targets : Seq[Int])
    extends Transition(_targets) {

    override def toString: String = {
      step + "["+ label + "] " + _targets
    }

  }

  case class EpsTransition(_targets : Seq[Int])
    extends Transition(_targets) {

    override def toString: String = "eps " + _targets

    def isExistential() = this.targets.size==1
  }


  case class SymbTransition(symbLabel   : Range, //Range is what changes here.
                            step    : Step,
                            _targets: Seq[Int])
    extends Transition(_targets) {

    override def toString: String = step + toStringLabel + " " + targets

    def toStringLabel() : String = "["+symbLabel.start+"-"+(symbLabel.end)+"]"

  }


  def goRight(label : Int, targets : Int*) =
    StepTransition(label, Right, targets)
  def goLeft (label : Int, targets : Int*) =
    StepTransition(label, Left,  targets)
  def eps    (targets : Int*) =
    EpsTransition(targets)

  def goRight(range : Range, targets : Int*) =
    SymbTransition(range, Right, targets)
  def goLeft (range : Range, targets : Int*) =
    SymbTransition(range, Left,  targets)

}

/*
Existential nondeterminism is implemented by having multiple transitions in the sequence.
Universal   nondeterminism is implemented by having multiple target states in Transition.
 */
case class AFA2(initialStates : Seq[Int],
                finalStates   : Seq[Int],
                transitions   : Map[Int, Seq[AFA2.StepTransition]]) {

  override def toString: String = {
    val res = new mutable.StringBuilder()
    res.append("Initial states: " + initialStates + "\n")
    res.append("Final states: " + finalStates + "\n")
    for (tr <- transitions) {
      res.append(tr._1 + "goes to \n")
      for (t <- tr._2) res.append(t)
    }
    res.toString()
  }

  import AFA2._

  assert(!initialStates.isEmpty)

  val states = {
    val states = new MHashSet[Int]

    states ++= initialStates
    states ++= finalStates

    for ((source, ts)                  <- transitions.iterator;
         StepTransition(_, _, targets) <- ts.iterator;
         target                        <- targets.iterator) {
      states += source
      states += target
    }

    states.toIndexedSeq.sorted
  }

  lazy val fwdReachable = {
    val reachable = new MHashSet[Int]
    reachable ++= initialStates

    var oldSize = 0
    while (oldSize < reachable.size) {
      oldSize = reachable.size

      for (s                             <- reachable.toList;
           StepTransition(_, _, targets) <- transitions.getOrElse(s, List())) {
        reachable ++= targets
      }
    }

    reachable.toSet
  }

  lazy val bwdReachable = {
    val reachable = new MHashSet[Int]
    reachable ++= finalStates

    var oldSize = 0
    while (oldSize < reachable.size) {
      oldSize = reachable.size

      for ((source, ts)                  <- transitions.iterator;
           if !(reachable contains source);
           StepTransition(_, _, targets) <- ts.iterator)
        if (targets forall reachable)
          reachable += source
    }

    reachable.toSet
  }

  lazy val reachableStates =
    fwdReachable & bwdReachable

  def restrictToReachableStates : AFA2 =
    if (reachableStates.size == states.size) {
      this
    } else {
      val newInitialPre =
        initialStates filter reachableStates
      val newInitial =
        if (newInitialPre.isEmpty)
          initialStates take 1
        else
          newInitialPre

      val newFinal =
        finalStates filter reachableStates
      val newTransitions =
        for ((source, ts) <- transitions;
             if (reachableStates contains source)) yield {
          val newTS =
            for (t@StepTransition(_, _, targets) <- ts;
                 if targets forall reachableStates)
            yield t
          source -> newTS
        }

      AFA2(newInitial, newFinal, newTransitions)
    }

  // Different categories of states:
  //
  // ir: initial,                       outgoing transitions go right
  // ll: incoming transitions go left,  outgoing transitions go left
  // lr: incoming transitions go left,  outgoing transitions go right
  // rl: incoming transitions go right, outgoing transitions go left
  // rr: incoming transitions go right, outgoing transitions go right
  // rf: incoming transitions go right, final

  lazy val (irStates, llStates, lrStates, rlStates, rrStates, rfStates) = {
    val leftIn, rightIn, leftOut, rightOut = new MHashSet[Int]

    for ((source, ts)                     <- transitions.iterator;
         StepTransition(_, step, targets) <- ts.iterator;
         target                           <- targets.iterator) {
      step match {
        case Left  => {
          leftOut  += source
          leftIn   += target
        }
        case Right => {
          rightOut += source
          rightIn  += target
        }
      }
    }

    val onlyLeftIn   = leftIn -- rightIn
    val onlyRightIn  = rightIn -- leftIn
    val onlyLeftOut  = leftOut -- rightOut
    val onlyRightOut = rightOut -- leftOut

    val anyIn        = leftIn ++ rightIn
    val anyOut       = leftOut ++ rightOut

    (initialStates.toSet & onlyRightOut.toSet -- anyIn -- finalStates,
      onlyLeftIn.toSet  & onlyLeftOut.toSet -- initialStates -- finalStates,
      onlyLeftIn.toSet  & onlyRightOut.toSet -- initialStates -- finalStates,
      onlyRightIn.toSet & onlyLeftOut.toSet -- initialStates -- finalStates,
      onlyRightIn.toSet & onlyRightOut.toSet -- initialStates -- finalStates,
      finalStates.toSet & onlyRightIn.toSet -- anyOut -- initialStates)
  }

  lazy val letters =
    (for ((source, ts)            <- transitions.iterator;
          StepTransition(l, _, _) <- ts.iterator)
    yield l).toSet.toIndexedSeq.sorted

}

case class ExtAFA2(initialStates    : Seq[Int],
                   finalLeftStates : Seq[Int],
                   finalRightStates   : Seq[Int],
                   transitions      : Map[Int, Seq[AFA2.Transition]]) {

  import AFA2._

  assert(!initialStates.isEmpty)

  val states = {
    val states = new MHashSet[Int]

    states ++= initialStates
    states ++= finalLeftStates
    states ++= finalRightStates

    for ((source, ts) <- transitions.iterator;
         trans        <- ts.iterator;
         target       <- trans.targets.iterator) {
      states += source
      states += target
    }

    states.toIndexedSeq.sorted
  }

  lazy val letters =
    (for ((source, ts)            <- transitions.iterator;
          StepTransition(l, _, _) <- ts.iterator)
    yield l).toSet.toIndexedSeq.sorted

}


case class SymbExtAFA2(initialStates : Seq[Int],
                       finalBeginStates: Seq[Int],
                       finalEndStates: Seq[Int],
                       transitions   : Map[Int, Seq[AFA2.Transition]]) {

  import AFA2._

  assert(!initialStates.isEmpty)

  val states : Set[Int] = {
    val states = new MHashSet[Int]

    states ++= initialStates
    states ++= finalBeginStates
    states ++= finalEndStates

    for ( (source, trans) <- transitions;
          t <- trans;
          target <- t.targets) {
      states += source
      states += target
    }

    states.toSet
  }

  override def toString: String = {
    val res = new mutable.StringBuilder()
    res.append("Initial states: " + initialStates + "\n")
    res.append("Final begin states: " + finalBeginStates + "\n")
    res.append("Final end states: " + finalEndStates + "\n")
    for (tr <- transitions) {
      res.append(tr._1 + " goes to: \n")
      for (t <- tr._2) res.append("\t" + t + "\n")
      res.append("\n")
    }
    res.toString()
  }


  // ------------- Some structures we need for the sweeping algorithm
  sealed trait Border

  case object LB extends Border

  case object RB extends Border

  case class SweepingEvent(id: Int, border: Border, range: Range, singleTrans: (Int, SymbTransition))

  object SweepingEventOrdering extends Ordering[SweepingEvent] {

    override def compare(x: SweepingEvent, y: SweepingEvent): Int = {
      (x.border, y.border) match {
        case (LB, RB) => scala.math.Ordering.Int.compare(x.range.start, y.range.end)
        case (RB, LB) => scala.math.Ordering.Int.compare(x.range.end, y.range.start)
        case (LB, LB) =>
          if (scala.math.Ordering.Int.compare(x.range.start, y.range.start) == 0)
            scala.math.Ordering.Int.compare(x.range.end, y.range.end)
          else
            scala.math.Ordering.Int.compare(x.range.start, y.range.start)
        case (RB, RB) => scala.math.Ordering.Int.compare(x.range.end, y.range.end)
      }
    }
  }
  // ------------------


  def toSymbDisjointTrans : Map[Int, Seq[Transition]] = {

    // Accumulator, holds the new set of disjoint transitions for the SymbolicDisjointAFA2.
    val newTrans = mutable.Set[(Int, Transition)]()

    // Queue ordered by sweeping event REVERSED, used later for the sweeping algo.
    val eventQueue = mutable.PriorityQueue[SweepingEvent]()(SweepingEventOrdering.reverse);

    var i = 0;
    for ((s, trSeq) <- transitions;
         tr <- trSeq) {
      tr match {
        // if it is a symb transition...
        case tr: SymbTransition =>
          //... with one value only, add it to the newTrans (no sweeping algo needed)
          if (tr.symbLabel.length == 1) newTrans += ((s, tr))
          // else add to the event queue: twice, for the beginning of the range and the end.
          else {
            eventQueue += SweepingEvent(i, LB, tr.symbLabel, (s, tr))
            eventQueue += SweepingEvent(i, RB, tr.symbLabel, (s, tr))
            i += 1;
          }

        // otherwise add directly to the newTrans queue.
        case tr: StepTransition => newTrans += ((s, SymbTransition(new Range(tr.label, tr.label + 1, 1), tr.step, tr._targets)))
        case tr: EpsTransition => newTrans += ((s, tr));
      }
    }

    // Compute disjoint intervals
    val open = mutable.ArrayBuffer[SweepingEvent]()
    var it = 0;
    while (!(eventQueue isEmpty)) {

      ///////////////////// Debug prints
      /*val queue = eventQueue.clone()
      println("******************* it ="+it)
      it+=1
      while (!(queue isEmpty)) {
        val ev = queue.dequeue()
        println(ev.border + " " + ev.range)
      }
      println
      /////////////////////////////////
      */

      val next = eventQueue.dequeue()
      next.border match {

        case LB =>
          // Add next to the open intervals
          open += (next);
          for (j <- open.indices; op = open(j)) {
            // if there is overlap, then split op
            if (next.range.start > op.range.start && next.range.start < op.range.end) { // second conjunct shouldn't happen as events are ordered.
              val newTransRange = new Range(op.range.start, next.range.start, 1)
              val newOpRange = new Range(next.range.start, op.range.end, 1)
              newTrans += ((op.singleTrans._1, SymbTransition(newTransRange, op.singleTrans._2.step, op.singleTrans._2.targets)))
              open.update(j, SweepingEvent(op.id, LB, newOpRange, op.singleTrans))
              eventQueue += SweepingEvent(op.id, LB, newOpRange, op.singleTrans)
            }
            // else do nothing because it will be managed by the closing event.
          }


        case RB =>
          var indexToRemove: Option[Int] = None
          for (j <- open.indices; op = open(j)) {
            if (op.id == next.id) { // found the open interval corresponding to this (next) closing event
              // Notice that op range is up to date, but next range is not!
              newTrans += ((op.singleTrans._1, SymbTransition(op.range, op.singleTrans._2.step, op.singleTrans._2.targets)))
              indexToRemove = Some(j);
            }
            else {
              if (next.range.end > op.range.start && next.range.end < op.range.end) { // I have to split op
                val newTransRange = new Range(op.range.start, next.range.end, 1)
                val newOpRange = new Range(next.range.end, op.range.end, 1)
                newTrans += ((op.singleTrans._1, SymbTransition(newTransRange, op.singleTrans._2.step, op.singleTrans._2.targets)))
                open.update(j, SweepingEvent(op.id, LB, newOpRange, op.singleTrans))
                eventQueue += SweepingEvent(op.id, LB, newOpRange, op.singleTrans)
              }
              // else op has the same range of next, so it will be handled by op corresponding closing event.
            }
          }
          indexToRemove match {
            case Some(index) => open.remove(index)
            case None => //this ever happens
          }
      }
    }

    /*
    // rebuild the transitions as a (mutable) map
    def seqToMap(seq: Seq[(Int, Transition)]): Map[Int, Seq[Transition]] = {
      @tailrec
      def seqToMapAux(seq: Seq[(Int, Transition)], map: mutable.Map[Int, Seq[Transition]]): mutable.Map[Int, Seq[Transition]] = {
        seq match {
          case Nil => map
          case x :: xs =>
            val currState = x._1
            map.get(currState) match {
              case Some(seq) =>
                map.update(currState, x._2 +: seq)
                seqToMapAux(xs, map)
              case None =>
                map += ((currState, Seq(x._2)))
                seqToMapAux(xs, map)
            }
        }
      }

      seqToMapAux(seq, mutable.Map[Int, Seq[Transition]]()).toMap
    }

    seqToMap(newTrans.toList)
     */

    newTrans.toSeq.groupBy(_._1).mapValues(l => l map (_._2))

  }

  // It returns a new SymbAFA2 where all transitions are disjoint. (It does not side effects the original automaton.)
  def toSymbDisjointAFA2 : SymbExtAFA2 = SymbExtAFA2(initialStates, finalBeginStates, finalEndStates, toSymbDisjointTrans)

  // TODO: toAFA2 (returns also a map from int to Ranges).
}