package ostrich.parikh

import ap.parser._
import IExpression._
import ostrich.OstrichStringTheory

class OstrichCostEnrichEncoder(theory: OstrichStringTheory)
    extends ContextAwareVisitor[Unit, IExpression] {
  import theory._

  def apply(f: IFormula): IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(
      t: IExpression,
      ctxt: Context[Unit],
      subres: Seq[IExpression]
  ): IExpression = (t, subres) match {
    case (
          IFunApp(`str_substr`, _),
          Seq(
            bigStr: ITerm,
            Const(begin),
            Difference(IFunApp(`str_len`, Seq(bigStr2)), Const(end))
          )
        ) if bigStr == bigStr2 && begin.signum >= 0 && end >= begin =>
      str_trim(bigStr, begin, end - begin)
    case _ =>
      t update subres
  }
}
