package ostrich.parikh

import ap.parser._
import IExpression._
import ostrich.OstrichStringTheory

class OstrichCostEnrichEncoder(theory: OstrichStringTheory)
    extends ContextAwareVisitor[Unit, IExpression] {
  import theory.re_charrange

  re_charrange(48, 57)

  def apply(f: IFormula): IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(
      t: IExpression,
      ctxt: Context[Unit],
      subres: Seq[IExpression]
  ): IExpression = (t, subres) match {
    case (t, _) =>
      t update subres
  }
}
