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
import ap.terfor.conjunctions.Conjunction

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

  val (funPredicates, axioms, _, funPredMap) =
    Theory.genAxioms(theoryFunctions = functions)
  val predicates = predefPredicates ++ funPredicates

  val functionPredicateMapping = functions zip funPredicates
  val functionalPredicates = funPredicates.toSet
  val predicateMatchConfig : Signature.PredicateMatchConfig = Map()
  val totalityAxioms = Conjunction.TRUE
  val triggerRelevantFunctions : Set[IFunction] = Set()

  override val dependencies : Iterable[Theory] = List(ModuloArithmetic)

  val _str_empty = funPredMap(str_empty)
  val _str_cons  = funPredMap(str_cons)
  val _str_++    = funPredMap(str_++)

  //////////////////////////////////////////////////////////////////////////////

  def plugin = None

  //////////////////////////////////////////////////////////////////////////////

  override def isSoundForSat(
                 theories : Seq[Theory],
                 config : Theory.SatSoundnessConfig.Value) : Boolean =
    config == Theory.SatSoundnessConfig.Existential

  TheoryRegistry register this
  StringTheory register this

}