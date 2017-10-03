/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
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

package strsolver

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.terfor.{ConstantTerm, Term}
import ap.terfor.preds.{Atom, PredConj}

import scala.collection.mutable.LinkedHashSet

object StringPreprocessing {
  import StringTheory._

  private val p = functionPredicateMap
  private val wordVariables = new LinkedHashSet[Term]
  private val sigmaStars = new LinkedHashSet[Term]
  private val stringVariables = new LinkedHashSet[Term]

  private def getDiffAtoms(goal: Goal) = {
    import ap.terfor.TerForConvenience._
    implicit val _ = goal.order

    val newAtoms = new LinkedHashSet[Atom]
    val variables = wordVariables -- stringVariables
    var oldSize = -1

    while (newAtoms.size > oldSize) {
      oldSize = newAtoms.size
      for (Seq((IdealInt.ONE, c : ConstantTerm),
               (IdealInt.MINUS_ONE, d : ConstantTerm)) <-
              goal.facts.arithConj.negativeEqs;
           lc = l(c);
           ld = l(d);
           if ((variables contains lc) ||
               (variables contains ld)) &&
              !((sigmaStars contains lc) ||
                (sigmaStars contains ld))) {
        newAtoms += wordDiff(List(lc, ld))
        wordVariables += lc
        wordVariables += ld
      }
    }

    newAtoms
  }

  def apply(goal: Goal) = {
    val atoms = goal.facts.predConj
    val regex2AFA = new Regex2AFA(atoms)
    val transVariables   = new LinkedHashSet[Term]
    val constraintDeps  = new LinkedHashSet[Term]
    var regularVariables = List.empty[Term]
    val constraintPositiveAtoms = new LinkedHashSet[Atom]
    val constraintNegativeAtoms = new LinkedHashSet[Atom]
    val wordAtoms = new LinkedHashSet[Atom]

    atoms.positiveLits foreach {
      case a if a.pred == p(replace) || a.pred == p(replaceall) =>
        wordVariables ++= Iterator(a(0), a(3))
        transVariables ++= Iterator(a(0), a(3))
        constraintDeps += a.head
        constraintPositiveAtoms += a

      case a if a.pred == member =>
        wordVariables += a.head
        regularVariables ::= a.head
        constraintDeps += a.head
        constraintPositiveAtoms += a

      case a if a.pred == p(wordCat) =>
        wordVariables += a.last
        sigmaStars ++= a.init
        stringVariables ++= a.iterator
        wordAtoms += a

      case a if a.pred == p(wordChar) =>
        wordVariables += a.last
        stringVariables += a.last
        wordAtoms += a

      case a if a.pred == p(wordEps) =>
        wordVariables += a.head
        stringVariables += a.head
        wordAtoms += a

      case a if (RRFunsToAFA get a.pred).isDefined =>
        wordVariables ++= a.init
        transVariables ++= a.init
        constraintDeps += a.head
        constraintPositiveAtoms += a

      case _ => // nothing
    }

    constraintPositiveAtoms ++= getDiffAtoms(goal)
    atoms.negativeLits foreach {
      case a if a.pred == member =>
        wordVariables += a.head
        regularVariables ::= a.head
        constraintDeps += a.head
        constraintNegativeAtoms += a

      case a => // nothing
        throw new Exception("Unexpected atom: " + a)
    }

    sigmaStars --= wordVariables

    var vars = Set.empty[Term]
    val withConcat = !(constraintDeps forall {v =>
      val string = regex2AFA.buildStrings(v)

      if(string.hasNext) {
        string.next.forall {
          case Right(x) if x == v =>
            true
          case Left(x) =>
            true
          case Right(x) =>
            val res = sigmaStars(x) && !(vars contains x)
            vars += x
            res
        }
      }
      else
        throw new Exception("Unexpected situation")
    })

    (PredConj(constraintPositiveAtoms.toList, constraintNegativeAtoms.toList, goal.order),
     wordVariables ++ sigmaStars,
     PredConj(wordAtoms.toList, List(), goal.order),
     withConcat)
  }
}
