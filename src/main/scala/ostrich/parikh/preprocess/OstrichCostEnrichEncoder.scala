package ostrich.parikh

import ap.parser._
import IExpression._
import ostrich.OstrichStringTheory
import ap.parser.ITerm
import ostrich.parikh.core.FinalConstraints

class OstrichCostEnrichEncoder(theory: OstrichStringTheory)
    extends ContextAwareVisitor[Unit, IExpression] {
  import theory.{str_to_int, str_in_re_len, str_len, str_in_re,
    re_charrange, re_loop, re_*, re_comp
  }

  private lazy val decimal = re_charrange(48, 57)

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
