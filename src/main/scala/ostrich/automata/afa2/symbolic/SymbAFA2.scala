package ostrich.automata.afa2.symbolic

import ostrich.automata.afa2._
import scala.collection.mutable




case class SymbAFA2(initialStates : Seq[Int],
                    finalStates   : Seq[Int],
                    transitions   : Map[Int, Seq[SymbTransition]]) {

  assert(!initialStates.isEmpty)

  lazy val states: Set[Int] = {
    val states = new mutable.HashSet[Int]

    states ++= initialStates
    states ++= finalStates

    for ((source, trans) <- transitions;
         t <- trans;
         target <- t.targets) {
      states += source
      states += target
    }

    states.toSet
  }

}



case class SymbExtAFA2(initialStates : Seq[Int],
                       finalLeftStates: Seq[Int],
                       finalRightStates: Seq[Int],
                       transitions   : Map[Int, Seq[Transition]]) {

  assert(!initialStates.isEmpty)

  val states : Set[Int] = {
    val states = new mutable.HashSet[Int]

    states ++= initialStates
    states ++= finalLeftStates
    states ++= finalRightStates

    for ( (source, trans) <- transitions;
          t <- trans;
          target <- t.targets) {
      states += source
      states += target
    }

    states.toSet
  }

  lazy val letters =
    (for ((source, ts) <- transitions.iterator;
          SymbTransition(l, _, _) <- ts.iterator)
    yield l).flatten.toSet.toIndexedSeq.sorted


  override def toString: String = {
    val res = new mutable.StringBuilder()
    res.append("Initial states: " + initialStates + "\n")
    res.append("Final begin states: " + finalLeftStates + "\n")
    res.append("Final end states: " + finalRightStates + "\n")
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
  def toSymbDisjointAFA2 : SymbExtAFA2 = SymbExtAFA2(initialStates, finalLeftStates, finalRightStates, toSymbDisjointTrans)

  // TODO: toAFA2 (returns also a map from int to Ranges).
}
