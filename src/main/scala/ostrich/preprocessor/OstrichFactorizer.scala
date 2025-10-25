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
 * Factor out certain common sub-expressions, whose translation
 * to more basic string functions is complicated.
 */
class OstrichFactorizer(theory : OstrichStringTheory) {
  import IExpression._
  import theory._

  def apply(f : IFormula) : IFormula = {
    val parts =
    for (INamedPart(name, f) <- PartExtractor(f)) yield {
      val skeleton = SubExprAbbreviator(f, factor _).asInstanceOf[IFormula]
      val newF = quanConsts(Quantifier.ALL, newConsts.toSeq,
                           factoredExpressions ==> skeleton)
      clear()
      INamedPart(name, newF)
    }
    or(parts)
  }

  def clear() = {
    newConsts.clear()
    factoredExpressions = i(true)
  }

  private val newConsts = new ArrayBuffer[ConstantTerm]
  private var factoredExpressions : IFormula = i(true)

  private def factor(e : IExpression) : IExpression = e match {
    case e@IFunApp(`str_indexof` | `str_at` | `str_substr`, _)
              if ContainsSymbol.isClosed(e) => {
      val sort = Sort.sortOf(e)
      val c = sort.newConstant("X")
      newConsts += c
      factoredExpressions = factoredExpressions &&& (e === c)
      c
    }
    case e => e
  }

}
