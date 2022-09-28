package ostrich.automata.afa2.symbolic

import ostrich.automata.BricsTLabelEnumerator
import ostrich.automata.afa2.concrete.AFA2
import ostrich.automata.afa2.symbolic.SymbToConcTranslator.toSymbDisjointAFA2
import ostrich.automata.afa2.{AFA2Utils, EpsTransition, Step, StepTransition, SymbTransition, Transition}

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import scala.util.Sorting


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

object SymbToConcTranslator {

  def toSymbDisjointTransBis(trans: Map[Int, Seq[SymbTransition]]): Map[Int, Seq[SymbTransition]] = {

    def isContained(r1: Range, r2: Range): Boolean = {
      r1.start>=r2.start && r1.end<=r2.end
    }

    val flatTrans = for((st, ts) <- trans.toSeq;
                        t <- ts) yield (st, t)

    //println("Flat trans:\n"+flatTrans)

    val points = (for ((st, ts) <- trans.toSeq;
                      t <- ts) yield {
                        Seq(
                          (t.symbLabel.start, true),
                          (t.symbLabel.end, false)
                        )
                      }).flatten.toSet.toArray

    Sorting.quickSort[(Int, Boolean)](points)(Ordering[(Int, Boolean)].on(x => (x._1, x._2)))

    //val it = points.iterator
    //println("Points:")
    //while(it.hasNext) println(it.next())

    val ranges = ArrayBuffer[Range]()
    var lastStart = (-1, false)

    for ((index, b) <- points) {
      if (b==true) {
        if (lastStart._1 != -1 && lastStart._2==true) ranges += Range(lastStart._1, index)
      lastStart=(index, b)
      } else {
        ranges+= (Range(lastStart._1, index))
        lastStart=(index, b)
      }
    }

    val newTransFlat =
      for ((st, t) <- flatTrans;
         rg <- ranges;
         if (isContained(rg, t.symbLabel))) yield (st, SymbTransition(rg, t.step, t.targets))

    //println("New flat trans:\n"+newTransFlat)

    newTransFlat.groupBy(_._1).mapValues(l => l map (_._2))
  }



  /*
  It returns a new set of transitions where the ranges are all disjoint, therefore ready to
  be mapped to single symbolic values.
  The algo works also for AFA2 with epsilon transition, but SymbAFA2 has only Symbolic transitions.
  */
  def toSymbDisjointTrans(trans: Map[Int, Seq[Transition]]): Map[Int, Seq[Transition]] = {

    // Accumulator, holds the new set of disjoint transitions for the SymbolicDisjointAFA2.
    val newTrans = mutable.Set[(Int, Transition)]()

    // Queue ordered by sweeping event REVERSED, used later for the sweeping algo.
    val eventQueue = mutable.PriorityQueue[SweepingEvent]()(SweepingEventOrdering.reverse);

    var i = 0;
    for ((s, trSeq) <- trans;
         tr <- trSeq) {
      tr match {
        // if it is a symb transition...
        case tr: SymbTransition =>
            eventQueue += SweepingEvent(i, LB, tr.symbLabel, (s, tr))
            eventQueue += SweepingEvent(i, RB, tr.symbLabel, (s, tr))
            i += 1;

        // otherwise add directly to the newTrans queue.
        //case tr: StepTransition => newTrans += ((s, SymbTransition(new Range(tr.label, tr.label + 1, 1), tr.step, tr._targets)))
        //case tr: EpsTransition => newTrans += ((s, tr));
      }
    }

    // println("Event queue:\n" + eventQueue)

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
          for (j <- open.indices;
               op = open(j)) {
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
          for (j <- open.indices;
               op = open(j)) {
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

    //println("Disjoint trans flat: \n" + newTrans)
    val res = newTrans.toSeq.groupBy(_._1).mapValues(l => l map (_._2))
    //println("Disjoint trans: \n" + res)
    res

  }


  // It returns a new SymbAFA2 where all transitions are disjoint. (It does not side effects the original automaton.)
  private def toSymbDisjointAFA2(safa: SymbAFA2): SymbAFA2 = {
    SymbAFA2(safa.initialStates, safa.finalStates, toSymbDisjointTransBis(safa.transitions).asInstanceOf[Map[Int, Seq[SymbTransition]]])
  }

}


class SymbToConcTranslator(_safa: SymbAFA2) {

  val safa = toSymbDisjointAFA2(_safa)
  AFA2Utils.printAutDotToFile(safa, "symbDisjointAFA2.dot")

  val rangeMap : Map[Range, Int] = {
    val trans : Set[Range] = safa.transitions.values.flatten.map(_.symbLabel).toSet
    trans.zipWithIndex.map {case (k, v) => (k, v)}.toMap
  }


  def forth(): AFA2 = {
    val newTrans = safa.transitions.map{case (st, trSeq) =>
      (st, trSeq.map(x => StepTransition(rangeMap.get(x.symbLabel).get, x.step, x._targets)) )}

    AFA2(safa.initialStates, safa.finalStates, newTrans)
  }


  def back(afa: AFA2): SymbAFA2 = {
    val invMap = rangeMap.map(_.swap)
    val newTrans = afa.transitions.map{case (st, trSeq) =>
      (st, trSeq.map(x => SymbTransition(invMap.get(x.label).get, x.step, x._targets))) }

    SymbAFA2(afa.initialStates, afa.finalStates, newTrans)
  }

}
