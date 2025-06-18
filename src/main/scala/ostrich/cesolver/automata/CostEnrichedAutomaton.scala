/** This file is part of Ostrich, an SMT solver for strings. Copyright (c) 2023
  * Denghang Hu. All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  * * Redistributions of source code must retain the above copyright notice,
  * this list of conditions and the following disclaimer.
  *
  * * Redistributions in binary form must reproduce the above copyright notice,
  * this list of conditions and the following disclaimer in the documentation
  * and/or other materials provided with the distribution.
  *
  * * Neither the name of the authors nor the names of their contributors may be
  * used to endorse or promote products derived from this software without
  * specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGE.
  */

package ostrich.cesolver.automata

import ostrich.automata.TLabelEnumerator
import scala.collection.mutable.{TreeSet => MTreeSet, HashSet => MHashSet}
import ostrich.cesolver.util.ParikhUtil.debugPrintln

class CostEnrichedAutomaton extends CostEnrichedAutomatonBase

class CETLabelEnumerator(labels: Iterable[(Char, Char)])
    extends TLabelEnumerator[(Char, Char)] {

  /** Keep track of disjoint labels for fast range lookups in enumLabelOverlap.
    * Access with enumDisjointlabels.
    */
  private lazy val disjointLabels: MTreeSet[(Char, Char)] =
    calculateDisjointLabels

  /** Like disjoint labels but covers whole alphabet including internal char.
    */
  private lazy val disjointLabelsComplete: List[(Char, Char)] =
    calculateDisjointLabelsComplete

  /** Enumerate all labels with overlaps removed. E.g. for min/max labels [1,3]
    * [5,10] [8,15] would result in [1,3] [5,8] [8,10] [10,15]
    */
  def enumDisjointLabels: Iterable[(Char, Char)] =
    disjointLabels.toIterable

  /** Enumerate all labels with overlaps removed such that the whole alphabet is
    * covered (including internal characters) E.g. for min/max labels [1,3]
    * [5,10] [8,15] would result in [1,3] [4,4] [5,7] [8,10] [11,15] [15,..]
    */
  def enumDisjointLabelsComplete: Iterable[(Char, Char)] =
    disjointLabelsComplete

  /** iterate over the instances of lbls that overlap with lbl
    */
  def enumLabelOverlap(lbl: (Char, Char)): Iterable[(Char, Char)] = {
    val (lMin, lMax) = lbl
    disjointLabels
      .from((lMin, Char.MinValue))
      .to((lMax, Char.MaxValue))
      .toIterable
  }

  /** Takes disjoint enumeration and splits it at the point defined by Char.
    * E.g. [1,10] split at 5 is [1,4][5][6,10]
    */
  def split(a: Char): TLabelEnumerator[(Char, Char)] =
    new CETLabelEnumerator(disjointLabels + ((a, a)))

  private def calculateDisjointLabels(): MTreeSet[(Char, Char)] = {

    if (labels.isEmpty) return new MTreeSet[(Char, Char)]()

    var disjoint = new MTreeSet[(Char, Char)]()

    val labelPoints = new MTreeSet[Char]

    val mins = new MHashSet[Char]
    val maxes = new MHashSet[Char]
    val originLabels = labels
    for ((min, max) <- labels) {
      mins += min
      maxes += max
      labelPoints += min
      labelPoints += max
    }

    // we only have one label
    if (labelPoints.size == 1)  return MTreeSet((labelPoints.head, labelPoints.head))

    debugPrintln(
      "Original labels: " + originLabels
        .map { case (a, b) => (a.toInt, b.toInt) }
        .mkString(", ")
    )

    def isMin(c: Char): Boolean = mins.contains(c)
    def isMax(c: Char): Boolean = maxes.contains(c)
    def isBoth(c: Char): Boolean = isMin(c) && isMax(c)
    def logicImply(head: Boolean, tail: Boolean): Boolean = !head || tail
    
    // split the labels at the points where they start or end
    labelPoints.zip(labelPoints.tail).foreach {
      case (lead, next) => {
        var possibleMin = lead
        var possibleMax = next
        if (isBoth(lead)) {
          disjoint += ((lead, lead))
          possibleMin = (lead.toInt + 1).toChar
        }
        if (isBoth(next)) {
          disjoint += ((next, next))
          possibleMax = (next.toInt - 1).toChar
        }
        if (isMin(next)) {
          possibleMax = (next.toInt - 1).toChar
        }
        if (isMax(lead)) {
          possibleMin = (lead.toInt + 1).toChar
        }
        if (possibleMin <= possibleMax)
          disjoint += ((possibleMin, possibleMax))
      }
    }

    // assert no original labels will be filtered out
    assert(
      disjoint.forall { case (min, max) =>
        originLabels.forall { case (oMin, oMax) =>
          logicImply(min >= oMin && min <= oMax, max <= oMax) &&
          logicImply(max >= oMin && max <= oMax, min >= oMin)
        }
      }
    )

    // filter out the labels not contained by original labels
    disjoint = disjoint.filter { case (min, max) =>
      originLabels.exists { case (oMin, oMax) => min >= oMin && max <= oMax }
    }

    disjoint
  }

  private def calculateDisjointLabelsComplete(): List[(Char, Char)] = {
    if (disjointLabels.isEmpty) {
      List((Char.MinValue, Char.MaxValue))
    } else {
      val labelsComp = disjointLabels.foldRight(List[(Char, Char)]()) {
        case ((min, max), Nil) => {
          // using Char.MaxValue since we include internal chars
          if (max < Char.MaxValue)
            List((min, max), ((max + 1).toChar, Char.MaxValue))
          else
            List((min, max))
        }
        case ((min, max), (minLast, maxLast) :: lbls) => {
          val minLastPrev = (minLast - 1).toChar
          if (max < minLastPrev)
            (min, max) :: ((max + 1).toChar, minLastPrev) :: (
              minLast,
              maxLast
            ) :: lbls
          else
            (min, max) :: (minLast, maxLast) :: lbls
        }
      }
      if (Char.MinValue < labelsComp.head._1) {
        val nextMin = (labelsComp.head._1 - 1).toChar
        (Char.MinValue, nextMin) :: labelsComp
      } else {
        labelsComp
      }
    }
  }
}
