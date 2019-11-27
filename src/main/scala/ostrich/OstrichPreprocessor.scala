/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2019  Matthew Hague, Philipp Ruemmer
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

package ostrich

import ap.parser._

class OstrichPreprocessor(theory : OstrichStringTheory)
      extends ContextAwareVisitor[Unit, IExpression] {

  import IExpression._
  import theory._

  def apply(f : IFormula) : IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(t : IExpression,
                ctxt : Context[Unit],
                subres : Seq[IExpression]) : IExpression = t match {
    case IAtom(`str_prefixof`, _) if ctxt.polarity < 0 => {
      val s = VariableShiftVisitor(subres(0).asInstanceOf[ITerm], 0, 1)
      val t = VariableShiftVisitor(subres(1).asInstanceOf[ITerm], 0, 1)
      StringSort.ex(str_++(s, v(0)) === t)
    }
    case t =>
      t update subres
  }

}
