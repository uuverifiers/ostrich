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
import ap.terfor.{Term, TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.substitutions.VariableShiftSubst
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal

import scala.collection.breakOut

object OstrichStrIntConverter {

  val IntRegex = """[0-9]+""".r

}

/**
 * Class to compute inferences for the <code>str.to_int</code>
 * and <code>str.from_int</code> predicates.
 */
class OstrichStrIntConverter(theory : OstrichStringTheory) {

  import OstrichStrIntConverter._
  import theory.functionPredicateMap
  import theory.{int_to_str, str_to_int}
  import theory.{_str_empty, _str_cons, StringSort}

  val _int_to_str = functionPredicateMap(int_to_str)
  val _str_to_int = functionPredicateMap(str_to_int)

  import TerForConvenience._

  def handleGoalEarly(goal : Goal) : Seq[Plugin.Action] = {
    implicit val order = goal.order
    val wordExtractor = theory.WordExtractor(goal)

    val int2StrActions =
      for (a <- goal.facts.predConj positiveLitsWithPred _int_to_str;
           if a(0).isConstant;
           const = a(0).constant;
           str = if (const.signum < 0) "" else a(0).constant.toString;
           strList = for (c <- str) yield c.toInt;
           action <- List(Plugin.RemoveFacts(conj(a)),
                          Plugin.AddAxiom(List(a),
                                          equateTermWithString(a(1), strList),
                                          theory)))
      yield action

    val str2IntActions =
      for (a <- goal.facts.predConj positiveLitsWithPred _str_to_int;
           symWord = wordExtractor extractWord a(0);
           if symWord.tail == None;
           strList = symWord.asConcreteWord;
           str = strList.map(i => i.toChar)(breakOut);
           strVal = str match {
             case IntRegex() => IdealInt(str)
             case _          => IdealInt.MINUS_ONE
           };
           action <- List(Plugin.RemoveFacts(conj(a)),
                          Plugin.AddAxiom(List(a), a(1) === strVal, theory)))
      yield action

    int2StrActions ++ str2IntActions
  }

  def equateTermWithString(t : Term, str : Seq[Int])
                          (implicit order : TermOrder) : Conjunction = {
    val strTerms =
      List(VariableShiftSubst(0, str.size, order)(t)) ++
      (for (n <- 0 until str.size) yield v(n))
    val matrix =
      conj((for ((Seq(v1, v2), ch) <- strTerms.sliding(2) zip str.iterator)
            yield _str_cons(List(l(ch), l(v2), l(v1)))) ++
             Iterator(_str_empty(List(l(strTerms.last)))))
    val complete =
      existsSorted(for (_ <- str) yield StringSort, matrix)
    complete
  }

}
