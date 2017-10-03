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

import ap._
import ap.parser._
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.Predicate
import ap.theories._

object SMTLIBStringTheory extends Theory {

  override def toString = "SMTLIBStringTheory"

  // TODO: use proper sorts for the operations

  // Sequences

  val seq_unit        = new IFunction("seq_unit",      1, true, false)
  val seq_empty       = new IFunction("seq_empty",     0, true, false)
  val seq_concat      = new IFunction("seq_concat",    2, true, false)

  val seq_cons        = new IFunction("seq_cons",      2, true, false)
  val seq_rev_cons    = new IFunction("seq_rev_cons",  2, true, false)
  val seq_head        = new IFunction("seq_head",      1, true, false)
  val seq_tail        = new IFunction("seq_tail",      1, true, false)
  val seq_last        = new IFunction("seq_last",      1, true, false)
  val seq_first       = new IFunction("seq_first",     1, true, false)

  val seq_prefix_of   = new Predicate("seq_prefix_of", 2)
  val seq_suffix_of   = new Predicate("seq_suffix_of", 2)
  val seq_subseq_of   = new Predicate("seq_subseq_of", 2)

  val seq_extract     = new IFunction("seq_extract",   3, true, false)
  val seq_nth         = new IFunction("seq_nth",       2, true, false)

  val seq_length      = new IFunction("seq_length",    1, true, false)

  val seq_replace     = new IFunction("seq_replace", 3, true, false)
  val seq_replace_all = new IFunction("seq_replace_all", 3, true, false)

  // Regexes

  val re_empty_set    = new IFunction("re_empty_set",  0, true, false)
  val re_full_set     = new IFunction("re_full_set",   0, true, false)
  val re_allchar      = new IFunction("re.allchar",    0, true, false)
  val re_concat       = new IFunction("re_concat",     2, true, false)
  val re_of_seq       = new IFunction("re_of_seq",     1, true, false)
  val re_empty_seq    = new IFunction("re_empty_seq",  0, true, false)

  val re_star         = new IFunction("re_star",       1, true, false)
  val re_loop         = new IFunction("re_loop",       3, true, false)
  val re_plus         = new IFunction("re_plus",       1, true, false)
  val re_option       = new IFunction("re_option",     1, true, false)
  val re_range        = new IFunction("re_range",      2, true, false)

  val re_union        = new IFunction("re_union",      2, true, false)
  val re_difference   = new IFunction("re_difference", 2, true, false)
  val re_intersect    = new IFunction("re_intersect",  2, true, false)
  val re_complement   = new IFunction("re_complement", 1, true, false)

  val re_of_pred      = new IFunction("re_of_pred",    1, true, false)

  val re_member       = new Predicate("re_member",      2)

  //////////////////////////////////////////////////////////////////////////////

  val functions = List(seq_unit, seq_empty, seq_concat,
    seq_cons, seq_rev_cons, seq_head, seq_tail, seq_last,
    seq_first, seq_extract, seq_nth, seq_length,
    re_empty_set, re_full_set, re_allchar, re_concat,
    re_of_seq, re_empty_seq,
    re_star, re_loop, re_plus, re_option, re_range,
    re_union, re_difference, re_intersect, re_complement,
    re_of_pred, seq_replace, seq_replace_all)

  val (predicates, functionPredicateMapping, functionalPredicates) = {
    val functionEnc = new FunctionEncoder (true, false)
    val predicates = for (f <- functions) yield (functionEnc addFunction f)
    val allPredicates =
      List(seq_prefix_of, seq_suffix_of, seq_subseq_of, re_member) ::: predicates

    (allPredicates,
      functions zip predicates,
      predicates.toSet)
  }

  val axioms = Conjunction.TRUE
  val totalityAxioms = Conjunction.TRUE

  val predicateMatchConfig : Signature.PredicateMatchConfig = Map()
  val triggerRelevantFunctions : Set[IFunction] = functions.toSet

  def plugin = None

  TheoryRegistry register this

}
