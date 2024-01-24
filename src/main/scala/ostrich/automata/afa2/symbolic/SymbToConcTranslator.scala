/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2023 Riccado De Masellis. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich.automata.afa2.symbolic

import ostrich.automata.{BricsTLabelEnumerator, BricsAutomaton, BricsAutomatonBuilder,
                         AutomataUtils, Regex2Aut}
import ostrich.automata.afa2.concrete.AFA2
import ostrich.automata.afa2.symbolic.SymbToConcTranslator.toSymbDisjointAFA2
import ostrich.automata.afa2.{AFA2PrintingUtils, EpsTransition, Step, StepTransition, SymbTransition, Transition}

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap, MultiMap,
                                 Set => MSet}
import scala.util.Sorting


/*
Implements the symbolic to concrete translation by splitting all ranges so they do not
overlap and keeping a map from ranges to concrete symbols.
 */

object SymbToConcTranslator {

  def toSymbDisjointTrans(trans: Map[Int, Seq[SymbTransition]]): Map[Int, Seq[SymbTransition]] = {

    val flatTrans = for((st, ts) <- trans.toSeq;
                        t <- ts) yield (st, t)

    //println("Flat trans:\n" + flatTrans.map{t => t._2})

    val points = (for ((_, ts) <- trans.toSeq;
                      t <- ts) yield {
                        Seq(
                          (t.symbLabel.start, t.symbLabel.end, true), //open the interval
                          (t.symbLabel.end, t.symbLabel.start, false) //closes the interval
                        )
                      }).flatten.toSet.toArray

    Sorting.quickSort[(Int, Int, Boolean)](points)(Ordering[(Int, Boolean)].on(x => (x._1, x._3)))

    val it = points.iterator
    //println("Points:")
    //while(it.hasNext) println(it.next())

    val ranges = ArrayBuffer[Range]()
    var open = (-1, -1, false) // This is always (index_start, index_end). True means the interval is currently open, false it is closed.

    for ((index_1, index_2, b) <- points) {
      if (b==true) {
        val index_start=index_1
        val index_end=index_2
        if (open._1 != -1 && open._3==true && index_start>open._1) {
          assert(!(index_start > open._2), "Current open range: " + open + " I am seeing opening of: (" + index_1 +"," + index_2+")")
          ranges += Range(open._1, index_start)
        }
        if (index_end>open._2) open=(index_start, index_end, true)
        else open=(index_start, open._2, true)
      }
      else {
        if (open._3 == true) {
          val index_start = index_2
          val index_end = index_1
          ranges += (Range(open._1, index_end))
          assert(!(index_end > open._2), "Current open range: " + open + " I am seeing closure of: (" + index_2 + "," + index_1 + ")")
          if (index_end == open._2) open = (-1, -1, false)
          else open = (index_end, open._2, true)
        }
      }
    }

    val newTransFlat =
      for ((st, t) <- flatTrans;
         rg <- ranges;
         if (t.symbLabel.containsSlice(rg))) yield (st, SymbTransition(rg, t.step, t.targets))

    //println("New flat trans:\n"+ newTransFlat.map{t=>t._2})

    newTransFlat.groupBy(_._1).mapValues(l => l.map(_._2).toSeq).toMap
  }


  // It returns a new SymbAFA2 where all transitions are disjoint. (It does not side effects the original automaton.)
  private def toSymbDisjointAFA2(safa: SymbAFA2): SymbAFA2 = {
    SymbAFA2(safa.initialStates, safa.finalStates, toSymbDisjointTrans(safa.transitions).asInstanceOf[Map[Int, Seq[SymbTransition]]])
  }

}


class SymbToConcTranslator(_safa: SymbAFA2) {

  val safa = toSymbDisjointAFA2(_safa)
  if (Regex2Aut.debug)
    AFA2PrintingUtils.printAutDotToFile(safa, "symbDisjointAFA2.dot")

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

  def bricsBack(aut : BricsAutomaton,
                toEpsLabels : Set[Int]) : BricsAutomaton = {
    val builder =
      new BricsAutomatonBuilder
    val epsilons =
      new MHashMap[BricsAutomaton#State, MSet[BricsAutomaton#State]]
        with MultiMap[BricsAutomaton#State, BricsAutomaton#State]
    val invMap =
      rangeMap.map(_.swap)

    val stateMap =
      (for (s <- aut.states) yield (s -> builder.getNewState)).toMap

    builder.setInitialState(stateMap(aut.initialState))

    for ((s1, s2) <- stateMap)
      if (aut isAccept s1)
        builder.setAccept(s2, true)

    for ((s1, s2) <- stateMap)
      for ((s3, l) <- aut.outgoingTransitions(s1))
        for (c <- aut.LabelOps.enumLetters(l)) {
          val r = invMap(c)
          if (r.start == r.end - 1 && (toEpsLabels contains r.start)) {
            epsilons.addBinding(s2, stateMap(s3))
          } else {
            builder.addTransition(s2, (r.start.toChar, (r.end - 1).toChar), stateMap(s3))
          }
        }

    AutomataUtils.buildEpsilons(builder, epsilons)

    builder.getAutomaton
  }

}
