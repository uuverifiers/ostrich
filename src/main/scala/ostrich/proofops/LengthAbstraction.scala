/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Philipp Ruemmer. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from this software without specific prior written permission.
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

package ostrich.proofops

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.theories.{SaturationProcedure, Theory}
import ap.proof.theoryPlugins.Plugin
import ap.terfor.TerForConvenience
import ap.terfor.preds.Atom
import ap.terfor.substitutions.VariableSubst
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination

import ostrich.{OstrichStringTheory, OFlags}
import ostrich.automata.{Automaton, AtomicStateAutomaton, AutomataUtils}

/**
 * Saturation procedure to add the length abstraction of regular
 * languages to a proof goal.
 */
class LengthAbstraction (
  val theory : OstrichStringTheory
) extends SaturationProcedure("LengthAbstraction")
     with PropagationSaturationUtils {
  import theory.{_str_len, str_in_re_id, autDatabase}
  import autDatabase.id2Automaton
  import AutomataUtils.findAcceptedWord

  /**
   * (str_in_re_id(x, autId), _str_len(x, y),
   *  lower-bound-on-y, upper-bound-on-y)
   */
  type ApplicationPoint = (Atom, Atom, IdealInt, Option[IdealInt])

  override def extractApplicationPoints(goal : Goal)
                                             : Iterator[ApplicationPoint] = {
    val predConj =
      goal.facts.predConj
    val strLenMap =
      predConj.positiveLitsWithPred(_str_len).map(a => (a(0), a)).toMap
    val reducer =
      goal.reduceWithFacts

    for (reAtom  <- predConj.positiveLitsWithPred(str_in_re_id).iterator;
         lenAtom <- strLenMap.get(reAtom(0)).iterator;
         len     =  lenAtom(1))
    yield (reAtom, lenAtom,
           reducer.lowerBound(len).getOrElse(IdealInt.ZERO),
           reducer.upperBound(len))
  }

  private def getAut(reAtom : Atom) : Automaton =
    reAtom.last match {
      case LinearCombination.Constant(IdealInt(id)) =>
        id2Automaton(id).get
      case _ =>
        throw new Exception("could not decode automaton in " + reAtom)
    }

  override def applicationPriority(goal : Goal,
                                   p    : ApplicationPoint)
                                        : Int =
    p match {
      case (_, _, IdealInt(lb), Some(IdealInt(ub))) if lb == ub =>
        // just a single word length to test
        0
      case (reAtom, _, IdealInt(lb), Some(IdealInt(ub))) if ub - lb < 100 =>
        // small range of values to test
        (ub - lb) + getAutomatonSize(getAut(reAtom))
      case (reAtom, _, _, _) =>
        // the full length abstraction is needed
        500 + getAutomatonSize(getAut(reAtom))
    }

  override def handleApplicationPoint(goal : Goal,
                                      p    : ApplicationPoint)
                                           : Seq[Plugin.Action] = {
    val (reAtom, lenAtom, _, _) = p
    val posAtomsSet = goal.facts.predConj.positiveLitsAsSet

    if (Set(reAtom, lenAtom) subsetOf posAtomsSet) {
      implicit val order = goal.order
      import TerForConvenience._

      val reducer = goal.reduceWithFacts
      val len     = lenAtom(1)
      val aut     = getAut(reAtom)

      // we compute new lower and upper bounds, the old bounds might
      // be outdated
      val actions =
      (reducer.lowerBound(len).getOrElse(IdealInt.ZERO),
       reducer.upperBound(len)) match {
        case (IdealInt(lb), Some(IdealInt(ub))) if lb == ub =>
          if (findAcceptedWord(List(aut), lb).isDefined) {
            List()
          } else {
            // contradiction, no word of the required length exists
            assert(lenAtom(1).isConstant)
            List(Plugin.CloseByAxiom(List(reAtom, lenAtom), theory))
          }
        case (IdealInt(lb), Some(IdealInt(ub))) if ub - lb < 100 => {
          // just test each of the possible lengths individually
          val impossibleLengths =
            (for (l <- lb to ub; if findAcceptedWord(List(aut),l).isEmpty)
             yield l).toList
          if (impossibleLengths.isEmpty)
            List()
          else
            List(Plugin.AddAxiom(List(reAtom, lenAtom),
                                 impossibleLengths.map(l(_)) =/=/= len,
                                 theory))
        }
        case _ => {
          val lenAbstraction = aut.getLengthAbstraction
          val lenFor = VariableSubst(0, List(len), order)(lenAbstraction)

          List(Plugin.AddAxiom(List(reAtom, lenAtom), conj(lenFor), theory))
        }
      }

      logSaturation("length abstraction") {
        actions
      }
    } else {
      List()
    }
  }
}

