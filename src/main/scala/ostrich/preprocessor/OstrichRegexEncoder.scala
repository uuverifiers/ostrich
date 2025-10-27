/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2019-2025 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.preprocessor

import ap.basetypes.IdealInt
import ap.parser._
import ap.theories.strings.StringTheory

import ostrich._
import scala.collection.mutable.ArrayBuffer

/**
 * Pre-processor for replacing regular expressions with just numeric ids,
 * which streamlines the translation to automata.
 */
class OstrichRegexEncoder(theory : OstrichStringTheory)
      extends ContextAwareVisitor[Unit, IExpression] {
  import IExpression._
  import theory._

  private val backrefs = new Backreferences(theory)
  import backrefs.{stubBackRefs, containsReference}

  def apply(f : IFormula) : IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(t : IExpression,
                ctxt : Context[Unit],
                subres : Seq[IExpression]) : IExpression = (t, subres) match {
    case (IAtom(`str_in_re`, _),
          Seq(s : ITerm, ConcreteRegex(regex))) =>
      if (containsReference(regex)) {
//        println(regex)
        val (stubbedRegex, _) = stubBackRefs(regex, Map())
//        println(stubbedRegex)
        str_in_re_id(s, theory.autDatabase.regex2Id(stubbedRegex)) &
        str_in_re_delayed(s, regex)
      } else {
        str_in_re_id(s, theory.autDatabase.regex2Id(regex))
      }
    case (IAtom(`str_in_re`, _), Seq(_, regex)) => {
      Console.err.println(
        "Warning: could not encode regular expression right away," +
          " post-poning: " + regex)
      t update subres
    }
    case _ =>
      t update subres
  }

}
