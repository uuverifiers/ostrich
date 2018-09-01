/**
 * This file is part of Ostrich.
 *
 * Copyright (C) 2018 Philipp Ruemmer <ph_r@gmx.net>
 *
 * Ostrich is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * Ostrich is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Ostrich.  If not, see <http://www.gnu.org/licenses/>.
 */

package ostrich

import ap.Signature
import ap.parser.{ITerm, IFormula, IExpression, IFunction}
import IExpression.Predicate
import ap.theories.strings._
import ap.theories.{Theory, ModuloArithmetic, TheoryRegistry}
import ap.types.{Sort, MonoSortedIFunction}
import ap.terfor.Term
import ap.terfor.conjunctions.Conjunction
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.util.Seqs

import scala.collection.mutable.{HashMap => MHashMap}

/**
 * The entry class of the Ostrich string solver.
 */
class OstrichStringTheory extends {

  val bitWidth   = 16
  val CharSort   = ModuloArithmetic.UnsignedBVSort(bitWidth) // just use intervals?
  val RegexSort  = new Sort.InfUninterpreted("RegLan")

} with AbstractStringTheoryWithSort {

  private val CSo = CharSort
  private val SSo = StringSort
  private val RSo = RegexSort

  def int2Char(t : ITerm) : ITerm =
    ModuloArithmetic.cast2UnsignedBV(bitWidth, t)

  def char2Int(t : ITerm) : ITerm = t

  val relations : Map[String, Predicate] = Map() // TODO

  //////////////////////////////////////////////////////////////////////////////

  val functions = predefFunctions

  val (funPredicates, axioms, _, functionPredicateMap) =
    Theory.genAxioms(theoryFunctions = functions)
  val predicates = predefPredicates ++ funPredicates

  val functionPredicateMapping = functions zip funPredicates
  val functionalPredicates = funPredicates.toSet
  val predicateMatchConfig : Signature.PredicateMatchConfig = Map()
  val totalityAxioms = Conjunction.TRUE
  val triggerRelevantFunctions : Set[IFunction] = Set()

  override val dependencies : Iterable[Theory] = List(ModuloArithmetic)

  val _str_empty = functionPredicateMap(str_empty)
  val _str_cons  = functionPredicateMap(str_cons)
  val _str_++    = functionPredicateMap(str_++)

  private val predFunMap =
    (for ((f, p) <- functionPredicateMap) yield (p, f)).toMap

  object FunPred {
    def unapply(p : Predicate) : Option[IFunction] = predFunMap get p
  }

  //////////////////////////////////////////////////////////////////////////////

  private val ostrichSolver = new OstrichSolver (this, new OFlags)

  def plugin = Some(new Plugin {
    // not used
    def generateAxioms(goal : Goal)
          : Option[(Conjunction, Conjunction)] = None

    private val modelCache =
      new ap.util.LRUCache[Conjunction, Option[Map[Term, List[Int]]]](3)

    override def handleGoal(goal : Goal)
                       : Seq[Plugin.Action] = goalState(goal) match {

      case Plugin.GoalState.Final => { //  Console.withOut(Console.err) 
        modelCache(goal.facts) { ostrichSolver.findStringModel(goal) } match {
          case Some(m) => List()
          case None => List(Plugin.AddFormula(Conjunction.TRUE))
        }
      }

      case _ => List()
    }

    override def generateModel(goal : Goal) : Option[Conjunction] =
      if (Seqs.disjointSeq(goal.facts.predicates, predicates))
        None
      else
        Some(assignStringValues(goal.facts,
                                (modelCache(goal.facts) {
                                  ostrichSolver.findStringModel(goal)
                                }).get,
                                goal.order))

  })

  //////////////////////////////////////////////////////////////////////////////

  override def isSoundForSat(
                 theories : Seq[Theory],
                 config : Theory.SatSoundnessConfig.Value) : Boolean =
    config == Theory.SatSoundnessConfig.Existential

  TheoryRegistry register this
  StringTheory register this

}