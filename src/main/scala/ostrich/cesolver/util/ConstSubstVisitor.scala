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