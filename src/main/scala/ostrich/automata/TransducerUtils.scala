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
  def incompleteTransducerEmptyIntersection(
    t1 : AtomicStateTransducer,
    t2 : AtomicStateTransducer,
    depth : Int
  ) : Option[Boolean] = {

    // keeps (s1, s2, w1, w2, d1, d2)
    // s1, s2 = states of t1, t2
    // w1, w2 = unmatched buffer from t1, t2 (one should always be
    // empty, assume both have same label type)
    // d1, d2 = depth explored into t1, t2
    type TProductState
      = (t1.State, t2.State, Seq[t1.TLabel], Seq[t1.TLabel], Int, Int)

    val worklist = new MStack[TProductState]
    val seenlist = MHashSet[TProductState]()

    def addWork(
      s1 : t1.State,
      s2 : t2.State,
      w1 : Seq[t1.TLabel],
      w2 : Seq[t1.TLabel],
      d1 : Int,
      d2 : Int
    ) {
      val item = (s1, s2, w1, w2, d1, d2)
      if (!seenlist.contains(item))
        worklist.push(item)
    }

    /**
     * Get sequence resulting from applying op to lbl
     *
     * Or None for epsilon
     */
    def getOpSeq(
      lbl : Option[t1.TLabel],
      op : Transducer.OutputOp
    ) : Seq[t1.TLabel] = {
      val lblSeq = if (lbl.isEmpty) {
        Seq()
      } else {
        op.op match {
          case Transducer.NOP => Seq()
          case Transducer.Plus(n) => Seq(t1.LabelOps.shift(lbl.get, n))
          // TODO: handle internal somehow
        }
      }
      return (
        (op.preW.map(c => t1.LabelOps.singleton(c)))
        ++ lblSeq
        ++ (op.postW.map(c => t1.LabelOps.singleton(c)))
      )
    }

    /**
     * Remove matching items from the front of w1, w2
     *
     * @return None if prefixes have a conflict, else the trimmed
     * buffers, at least one of which has been emptied
     */
    def trimFrontBuffers(w1 : Seq[t1.TLabel], w2 : Seq[t1.TLabel])
      : Option[(Seq[t1.TLabel], Seq[t1.TLabel])] = {
      var u1 = w1
      var u2 = w2
      while (u1.size > 0 && u2.size > 0) {
        if (!t1.LabelOps.labelsOverlap(u1.head, u2.head))
          return None

        u1 = u1.tail
        u2 = u2.tail
      }
      return Some((u1, u2))
    }

    val winit = Seq[t1.TLabel]()
    worklist push ((t1.initialState, t2.initialState, winit, winit, 0, 0))

    // shift t1 and t2 independently, using w1, w2 to buffer
    while (!worklist.isEmpty) {
      val (s1, s2, w1, w2, d1, d2) = worklist.pop()

      // found a match
      if (t1.isAccept(s1) && t2.isAccept(s2) && w1.isEmpty && w2.isEmpty)
        return Some(true)

      if (d1 < depth) {
        for (
          (lbl, op, s1next) <- (
            t1.outgoingTransitions(s1).map(t => (Some(t._1), t._2, t._3))
            ++ t1.outgoingETransitions(s1).map(t => (None, t._1, t._2))
          )
        ) {
          val trimmedBuffers = trimFrontBuffers(w1 ++ getOpSeq(lbl, op), w2)
          if (trimmedBuffers.nonEmpty) {
            // explored past depth
            if (d1 >= depth && d2 >= depth)
              return None

            val (w1next, w2next) = trimmedBuffers.get
            addWork(s1next, s2, w1next, w2next, d1 + 1, d2)
          }
        }
      }

      if (d2 < depth) {
        for (
          (lbl, op, s2next) <- (
            t2.outgoingTransitions(s2).map(t =>
              (Some(t._1.asInstanceOf[t1.TLabel]), t._2, t._3)
            ) ++ t2.outgoingETransitions(s2).map(t => (None, t._1, t._2))
          )
        ) {
          val trimmedBuffers = trimFrontBuffers(w1, w2 ++ getOpSeq(lbl, op))
          if (trimmedBuffers.nonEmpty) {
            // explored past depth
            if (d1 >= depth && d2 >= depth)
              return None

            val (w1next, w2next) = trimmedBuffers.get
            addWork(s1, s2next, w1next, w2next, d1, d2 + 1)
          }
        }
      }
    }

    // did not find a shared run or a run longer than the depth, so
    // empty
    return Some(false)
  }
}

