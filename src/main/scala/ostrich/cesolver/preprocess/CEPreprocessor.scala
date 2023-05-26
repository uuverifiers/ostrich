package ostrich.cesolver.preprocess

import ap.parser._
import IExpression._
import ap.theories.strings.StringTheory.ConcreteString
import ostrich.cesolver.stringtheory.CEStringTheory
import ostrich.cesolver.util.ParikhUtil

class CEPreprocessor(theory: CEStringTheory)
    extends ContextAwareVisitor[Unit, IExpression] {
  import theory._

  private def reCat(ts: ITerm*): ITerm = ts match {
    case Seq() => re_eps()
    case ts    => ts reduceLeft (re_++(_, _))
  }

  private def reUnion(ts: ITerm*): ITerm = ts match {
    case Seq() => re_none()
    case ts    => ts reduceLeft (re_union(_, _))
  }

  private def strCat(ts: ITerm*): ITerm = ts match {
    case Seq() => str_empty()
    case ts    => ts reduceLeft (str_++(_, _))
  }

  def apply(f: IFormula): IFormula =
    this.visit(f, Context(())).asInstanceOf[IFormula]

  def postVisit(
      t: IExpression,
      ctxt: Context[Unit],
      subres: Seq[IExpression]
  ): IExpression = {
    (t, subres) match {
      case (
            IAtom(`str_contains`, _),
            Seq(bigStr: ITerm, subStr @ ConcreteString(_))
          ) => {
        val asRE = reCat(re_all(), str_to_re(subStr), re_all())
        str_in_re(bigStr, asRE)
      }

      case (
            IAtom(`str_prefixof`, _),
            Seq(subStr @ ConcreteString(_), bigStr: ITerm)
          ) => {
        val asRE = re_++(str_to_re(subStr), re_all())
        str_in_re(bigStr, asRE)
      }
      case (IAtom(`str_suffixof`, _), Seq(x, y)) if (x == y) => {
        IBoolLit(true)
      }
      case (IAtom(`str_contains`, _), Seq(x, y)) if (x == y) => {
        IBoolLit(true)
      }
      case (
            IAtom(`str_suffixof`, _),
            Seq(subStr @ ConcreteString(_), bigStr: ITerm)
          ) => {
        val asRE = re_++(re_all(), str_to_re(subStr))
        str_in_re(bigStr, asRE)
      }
      case (IAtom(`str_suffixof`, _), Seq(subStr: ITerm, bigStr: ITerm))
          if ctxt.polarity < 0 => {
        val s = VariableShiftVisitor(subStr, 0, 1)
        val t = VariableShiftVisitor(bigStr, 0, 1)
        StringSort.ex(str_++(v(0, StringSort), s) === t)
      }

      // case (
      //       IFunApp(`str_at`, _),
      //       Seq(
      //         bigStr: ITerm,
      //         Difference(IFunApp(`str_len`, Seq(bigStr2)), Const(offset))
      //       )
      //     ) if bigStr == bigStr2 && offset >= 1 =>
        // str_at_right(bigStr, offset - 1)

      case (IFunApp(`str_at`, _), Seq(bigStr: ITerm, index: ITerm)) => {
        ParikhUtil.todo("optimize str.at right")
        str_substr(bigStr, index, 1)
      }
      case (IFunApp(`str_++`, _), Seq(ConcreteString(""), t)) => t
      case (IFunApp(`str_++`, _), Seq(t, ConcreteString(""))) => t

      case (
            IFunApp(`str_++`, _),
            Seq(ConcreteString(str1), ConcreteString(str2))
          ) =>
        string2Term(str1 + str2)

      case (IFunApp(`str_from_code`, _), Seq(Const(code))) =>
        if (code >= 0 & code < theory.alphabetSize)
          str_cons(code, str_empty())
        else
          str_empty()

      case (IFunApp(`str_from_code`, _), Seq(code: ITerm)) =>
        ite(
          code >= 0 & code < theory.alphabetSize,
          str_cons(code, str_empty()),
          str_empty()
        )

      case (IFunApp(`str_from_char`, _), Seq(c: ITerm)) =>
        str_cons(c, str_empty())

      case (IFunApp(`re_range`, _),
          Seq(IFunApp(`str_cons`, Seq(lower, IFunApp(`str_empty`, _))),
              IFunApp(`str_cons`, Seq(upper, IFunApp(`str_empty`, _))))) =>
      re_charrange(lower, upper)
      
      case _ => // do nothing now
        t update subres
    }
  }
}
