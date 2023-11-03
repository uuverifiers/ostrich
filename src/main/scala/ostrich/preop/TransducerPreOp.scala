/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.preop

import ostrich.automata.{Transducer, AtomicStateAutomaton, Automaton,
                         ProductAutomaton, PostImageAutomaton}

import scala.collection.breakOut

object TransducerPreOp {
  def apply(t : Transducer) = new TransducerPreOp(t)
}

/**
* Representation of x = T(y)
*/
class TransducerPreOp(t : Transducer) extends PreOp {

  override def toString = "transducer"

  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]] = {
    assert (arguments.size == 1)
    val arg = arguments(0).map(_.toChar).mkString
    for (s <- t(arg)) yield s.toSeq.map(_.toInt)
  }

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton, concreteWords : Seq[Option[List[Int]]])
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val rc : AtomicStateAutomaton = resultConstraint match {
      case resCon : AtomicStateAutomaton => resCon
      case _ => throw new IllegalArgumentException("TransducerPreOp needs an AtomicStateAutomaton")
    }
    (Iterator(Seq(t.preImage(rc))), List())
  }

  override def forwardApprox(argumentConstraints : Seq[Seq[Automaton]]) : Automaton = {
    val cons = argumentConstraints(0).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ConcatPreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val prod = ProductAutomaton(cons)
    PostImageAutomaton(prod, t)
  }
}
