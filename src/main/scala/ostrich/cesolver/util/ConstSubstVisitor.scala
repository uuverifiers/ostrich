/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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
package ostrich.cesolver.util

import ap.parser.CollectingVisitor
import ap.parser.{IExpression, IFormula}
import ap.parser.ITerm
import ap.parser.IConstant

class ConstSubstVisitor extends CollectingVisitor[Map[ITerm, ITerm], IExpression] {
  def apply(t: IExpression, substMap: Map[ITerm, ITerm]): IExpression = {
    visit(t, substMap)
  }
  def apply(t : ITerm, substMap : Map[ITerm, ITerm]) : ITerm =
    apply(t.asInstanceOf[IExpression], substMap).asInstanceOf[ITerm]
  def apply(t : IFormula, substMap : Map[ITerm, ITerm]) : IFormula =
    apply(t.asInstanceOf[IExpression], substMap).asInstanceOf[IFormula]

  override def preVisit(t: IExpression, substMap: Map[ITerm, ITerm]): PreVisitResult = t match {
    case t: IConstant if substMap.contains(t) => {
      ShortCutResult(substMap(t))
    }
    case _ => KeepArg
  }

  def postVisit(t: IExpression, arg: Map[ITerm,ITerm], subres: Seq[IExpression]): IExpression = {
    t update subres
  }

}