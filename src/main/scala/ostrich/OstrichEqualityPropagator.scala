/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020 Philipp Ruemmer. All rights reserved.
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

package ostrich

import ap.basetypes.IdealInt
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.terfor.{Term, TerForConvenience}
import ap.theories.TheoryRegistry
import ap.util.Seqs

/**
 * Class to propagate equalities between string variables; this is
 * necessary in general to combine the string theory with others theories.
 */
class OstrichEqualityPropagator(theory : OstrichStringTheory) {

  private implicit val seqOrdering = new Ordering[Seq[Int]] {
    def compare(a : Seq[Int], b : Seq[Int]) : Int =
      Seqs.lexCompare(a.iterator, b.iterator)
  }

  def handleSolution(goal : Goal,
                     model : Map[Term, Either[IdealInt, Seq[Int]]])
                   : Seq[Plugin.Action] = {
    // we need to check whether the solution maps distinct variables
    // to the same string; in case such variables also occur in
    // other formulas, then we need to do explicit case splits

    val variableClasses =
      (for ((t, Right(w)) <- model.iterator) yield (t, w)).toList groupBy (_._2)

    if (variableClasses forall { case (_, c) => c.size <= 1 })
      return List()

    val predConj = goal.facts.predConj
    val allAtoms = predConj.positiveLits ++ predConj.negativeLits
    val nonTheoryAtoms =
      allAtoms filterNot {
        a => TheoryRegistry.lookupSymbol(a.pred) match {
          case Some(`theory`) => true
          case _ => false
        }
      }

    // relevant are only constants which also occur in atoms that do not
    // belong to string constraints
    val interestingConstants =
      (for (a <- nonTheoryAtoms; c <- a.constants) yield c).toSet

    if (interestingConstants.isEmpty)
      return List()

    implicit val order = goal.order
    import TerForConvenience._

    // TODO: it is better to do proper binary splitting here
    (for (w <- variableClasses.keySet.toSeq.sorted.iterator;
          terms = variableClasses(w) map (_._1);
          interestingTerms = terms filter {
            t => !Seqs.disjoint(t.constants, interestingConstants)
          };
          if interestingTerms.size > 1) yield {
       val allEq =
         conj(for (Seq(t1, t2) <- interestingTerms sliding 2) yield t1 === t2)
       Plugin.AxiomSplit(List(),
                         (allEq, List()) :: (
                           for (eq <- allEq.iterator)
                           yield (!eq, List())).toList,
                         theory)
     }).toStream.headOption.toSeq
  }

}
