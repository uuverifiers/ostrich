/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2018  Matthew Hague, Philipp Ruemmer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package ostrich

import ap.terfor.{Term, Formula, TermOrder, TerForConvenience}

import scala.collection.JavaConversions.{asScalaIterator,
                                         iterableAsScalaIterable}

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
    implicit val _ = order
    result === arguments(0) + arguments(1)
  }

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
