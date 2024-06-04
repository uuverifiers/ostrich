/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

import ostrich.automata.{Automaton, AtomicStateAutomaton, InitFinalAutomaton,
                         ProductAutomaton, ConcatAutomaton}

import ap.terfor.{Term, Formula, TermOrder, TerForConvenience}

import scala.collection.JavaConverters.asScala

/**
 * Pre-image computation for the concatenation operator.
 */
object ConcatPreOp extends PreOp {

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) =
    resultConstraint match {

      case resultConstraint : AtomicStateAutomaton => {
        // processes states in det order so long as the automaton's
        // .states method returns them in a deterministic order (this is
        // true for BricsAutomaton)

        val argLengths =
          (for (argAuts <- argumentConstraints.iterator) yield {
             (for (aut <- argAuts.iterator;
                   if aut.isInstanceOf[AtomicStateAutomaton];
                   l <- aut.asInstanceOf[AtomicStateAutomaton]
                           .uniqueAcceptedWordLength.iterator)
              yield (aut, l)).toSeq.headOption
           }).toSeq

        argLengths(0) match {
          case Some((lenAut, len)) =>
            // the prefix needs to be of a certain length, only pick
            // states correspondingly
            (for (s <- resultConstraint.states.iterator;
                  if ((resultConstraint.uniqueLengthStates get s) match {
                    case Some(l) => l == len
                    case None => true
                  })) yield {
               List(InitFinalAutomaton.setFinal(resultConstraint, Set(s)),
                    InitFinalAutomaton.setInitial(resultConstraint, s))
             },
             List(List(lenAut), List()))

          case None =>
            argLengths(1) match {
              case Some((lenAut, len))
                if resultConstraint.uniqueAcceptedWordLength.isDefined => {
                // the suffix needs to be of a certain length
                val resLength = resultConstraint.uniqueAcceptedWordLength.get
                (for (s <- resultConstraint.states.iterator;
                      if ((resultConstraint.uniqueLengthStates get s) match {
                        case Some(l) => l + len == resLength
                        case None => true
                      })) yield {
                   List(InitFinalAutomaton.setFinal(resultConstraint, Set(s)),
                        InitFinalAutomaton.setInitial(resultConstraint, s))
                 },
                 List(List(), List(lenAut)))
              }

              case _ =>
                (for (s <- resultConstraint.states.iterator) yield {
                   List(InitFinalAutomaton.setFinal(resultConstraint, Set(s)),
                        InitFinalAutomaton.setInitial(resultConstraint, s))
                 },
                 List())
            }
        }

      }

      case _ =>
        throw new IllegalArgumentException
    }

  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]] =
    Some(arguments(0) ++ arguments(1))

  override def lengthApproximation(arguments : Seq[Term], result : Term,
                                   order : TermOrder) : Formula = {
    import TerForConvenience._
    implicit val o = order
    result === arguments(0) + arguments(1)
  }

  override def charCountApproximation(char : Int,
                                      arguments : Seq[Term], result : Term,
                                      order : TermOrder) : Formula =
    lengthApproximation(arguments, result, order)

  override def forwardApprox(argumentConstraints : Seq[Seq[Automaton]]) : Automaton = {
    val fstCons = argumentConstraints(0).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ConcatPreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val sndCons = argumentConstraints(1).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ConcatPreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val fstProd = ProductAutomaton(fstCons)
    val sndProd = ProductAutomaton(sndCons)
    ConcatAutomaton(fstProd, sndProd)
  }

  override def toString = "concat"

}
