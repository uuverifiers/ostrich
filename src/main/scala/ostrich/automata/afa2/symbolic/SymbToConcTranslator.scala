package ostrich.automata.afa2.symbolic

import ostrich.automata.BricsTLabelEnumerator
import ostrich.automata.afa2.concrete.AFA2
import ostrich.automata.afa2.symbolic.SymbToConcTranslator.toSymbDisjointAFA2
import ostrich.automata.afa2.{AFA2PrintingUtils, EpsTransition, Step, StepTransition, SymbTransition, Transition}

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import scala.util.Sorting


/*
Implements the symbolic to concrete translation by splitting all ranges so they do not
overlap and keeping a map from ranges to concrete symbols.
 */

object SymbToConcTranslator {

  def toSymbDisjointTrans(trans: Map[Int, Seq[SymbTransition]]): Map[Int, Seq[SymbTransition]] = {

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


  // It returns a new SymbAFA2 where all transitions are disjoint. (It does not side effects the original automaton.)
  private def toSymbDisjointAFA2(safa: SymbAFA2): SymbAFA2 = {
    SymbAFA2(safa.initialStates, safa.finalStates, toSymbDisjointTrans(safa.transitions).asInstanceOf[Map[Int, Seq[SymbTransition]]])
  }

}


class SymbToConcTranslator(_safa: SymbAFA2) {

  val safa = toSymbDisjointAFA2(_safa)
  AFA2PrintingUtils.printAutDotToFile(safa, "symbDisjointAFA2.dot")

  val rangeMap : Map[Range, Int] = {
    val trans : Set[Range] = safa.transitions.values.flatten.map(_.symbLabel).toSet
    trans.zipWithIndex.map {case (k, v) => (k, v)}.toMap
  }

  //println("Range map:\n" + rangeMap)

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
