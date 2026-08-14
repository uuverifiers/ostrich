/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Matthew Hague. All rights reserved.
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

package ostrich.automata

import scala.collection.mutable.{HashSet => MHashSet,
                                 Stack => MStack}

object TransducerUtils {
  /**
   * Fixed depth search for emptiness of intersection
   *
   * Requires/assumes all transducers have same label and state type.
   *
   * @return None if could not be determined, else true/false if
   * non-empty or not
   */
  def incompleteTransducerNonEmptyIntersection(
    ts : Seq[AtomicStateTransducer],
    depth : Int
  ) : Option[Boolean] = {

    if (ts.isEmpty)
      return Some(true)

    val head = ts.head

    // keeps (t, s, w, d) for each transducer
    // t the transducer, for convenience
    // s state of transducer
    // w unmatched buffer (what transducer has output that hasn't been
    // matched by others -- at least one of these is always empty,
    // blocking matching for the rest)
    // d = depth explored into transducer
    type TProductState
      = Vector[(AtomicStateTransducer, head.State, Seq[head.TLabel], Int)]

    val worklist = new MStack[TProductState]
    val seenlist = MHashSet[TProductState]()

    def addWork(work : TProductState) {
      if (!seenlist.contains(work))
        worklist.push(work)
    }

    /**
     * Get sequence resulting from applying op to lbl
     *
     * Or None for epsilon
     */
    def getOpSeq(
      lbl : Option[head.TLabel],
      op : Transducer.OutputOp
    ) : Seq[head.TLabel] = {
      val lblSeq = if (lbl.isEmpty) {
        Seq()
      } else {
        op.op match {
          case Transducer.NOP => Seq()
          case Transducer.Plus(n) => Seq(head.LabelOps.shift(lbl.get, n))
          // TODO: handle internal somehow
        }
      }
      return (
        (op.preW.map(c => head.LabelOps.singleton(c)))
        ++ lblSeq
        ++ (op.postW.map(c => head.LabelOps.singleton(c)))
      )
    }

    /**
     * Remove matching items from the front of w buffers
     *
     * @return None if prefixes have a conflict, else the trimmed
     * buffers, at least one of which has been emptied
     */
    def trimFrontBuffers(ws : Seq[Seq[head.TLabel]])
      : Option[Seq[Seq[head.TLabel]]] = {
      var us = ws
      while (us.forall(_.nonEmpty)) {

        var intersectionLbl = head.LabelOps.sigmaLabel
        for (w <- ws) {
          val tryIntersection
            = head.LabelOps.intersectLabels(intersectionLbl, w.head)
          if (tryIntersection.isEmpty)
            return None
          intersectionLbl = tryIntersection.get
        }

        us = us.map(_.tail)
      }
      return Some(us)
    }

    worklist.push(
      ts.map(
        t => (
          t,
          t.initialState.asInstanceOf[head.State],
          Seq[head.TLabel](),
          0
        )
      ).toVector
    )

    // shift each transducer independently, using buffers to sync
    while (!worklist.isEmpty) {
      val states = worklist.pop()

      // found a match
      val isAccept = states.forall { case (t, s, w, _) =>
        t.isAccept(s.asInstanceOf[t.State]) && w.isEmpty
      }
      if (isAccept)
        return Some(true)

      for (i <- 0 to states.size) {
        val (t, s, w, d) = states(i)
        if (d < depth) {
          // m for "move" instead of t for transition since t for transducer
          val s4t = s.asInstanceOf[t.State]
          for (
            (lbl4t, op, snext4t) <- (
              t.outgoingTransitions(s4t).map(m => (Some(m._1), m._2, m._3))
              ++ t.outgoingETransitions(s4t).map(m => (None, m._1, m._2))
            )
          ) {
            val lbl = lbl4t.map(_.asInstanceOf[head.TLabel])
            val snext = snext4t.asInstanceOf[head.State]

            val outLbls = getOpSeq(lbl, op)
            val nextTState = (t, snext, w ++ outLbls, d + 1)
            val nextStates = states.updated(i, nextTState)

            // exploration could continue past depth, give up
            if (nextStates.forall(_._4 >= depth))
              return None

            val ws = nextStates.map(_._3).toVector
            val trimmedWs = trimFrontBuffers(ws)
            if (trimmedWs.nonEmpty) {
              val trimmedNextStates
                = nextStates.zipWithIndex.map { case (state, i) =>
                  val (t1, s1, _, d1) = state
                  (t1, s1, trimmedWs.get(i), d1)
                }.toVector
              addWork(trimmedNextStates)
            }
          }
        }
      }
    }

    // did not find a shared run or a run longer than the depth, so
    // empty
    return Some(false)
  }
}

