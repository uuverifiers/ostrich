package ostrich.parikh

import ap.parser._
import IExpression._
import ostrich.OstrichStringTheory
import ap.theories.strings.StringTheory

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
          IFunApp(`str_len`, _),
          Seq(str: ITerm)
        ) =>
      str_len_cea(str)
    case (
          IFunApp(`str_indexof`, _),
          Seq(
            searchedStr: ITerm,
            matchStr: ITerm,
            startIndex: ITerm
          )
        ) =>
      str_indexof_cea(searchedStr, matchStr, startIndex)
    case (
          IFunApp(`str_++`, _),
          Seq(str1: ITerm, str2: ITerm)
        ) =>
      str_concate_cea(str1, str2)
    case (
          IFunApp(`str_substr`, _),
          Seq(str: ITerm, startIndex: ITerm, length: ITerm)
        ) =>
      str_substr_cea(str, startIndex, length)
      
    case _ =>
      t update subres
  }
}
