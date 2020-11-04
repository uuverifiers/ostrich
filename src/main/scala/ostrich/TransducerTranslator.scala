/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2018-2020  Matthew Hague, Philipp Ruemmer
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
import IExpression._
import ap.SimpleAPI
import ap.basetypes.IdealInt
import SimpleAPI.ProverStatus
import ap.theories.ModuloArithmetic
import ap.theories.strings.{StringTheory, StringTheoryBuilder}

/**
 * Helper methods to translate transducers in symbolic representation
 * (an arbitrary formula associated with each transition) to the
 * Brics representation.
 */
object TransducerTranslator {

  import StringTheoryBuilder._

  def toBricsTransducer(transducer : SymTransducer,
                        alphabetSize : Int,
                        transducerStringTheory : StringTheory) : Transducer = {
    val SymTransducer(transitions, accepting) = transducer
    val states =
      (for (TransducerTransition(from, to, _, _, _) <- transitions.iterator;
            s <- Iterator(from, to))
       yield s).toSet ++ accepting ++ List(0)

    if (!(transitions forall {
            case TransducerTransition(_, _, epsilons, _,_) => epsilons.size == 2
          }))
      throw new Exception(
        "Can only handle 2-track transducers")

    val builder = BricsTransducer.getBuilder

    val states2Brics =
      (for (s <- states.toList.sorted) yield (s -> builder.getNewState)).toMap

    for (s <- accepting)
      builder.setAccept(states2Brics(s), true)

    SimpleAPI.withProver { p =>

      p.addTheory(transducerStringTheory)

      val inputC, outputC =
        p.createConstant(ModuloArithmetic.ModSort(IdealInt.ZERO,
                                                  IdealInt(alphabetSize - 1)))
      val OutputInputOffsetEq =
        OffsetEq(outputC, inputC)

      for (TransducerTransition(fromState, toState, epsilons, constraint, _) <-
             transitions) {

        val bvLabel =
          VariableSubstVisitor(constraint, (List(inputC, outputC), 0))

        epsilons match {
          case Seq(true, false) => p.scope {
            for (out <- enumLabelSolutions(bvLabel, outputC,
                                           p, transducerStringTheory)) {
              val op = OutputOp(out.intValueSafe.toChar.toString, NOP, "")

              Console.err.println("" + fromState + "- <eps> -> " +
                                  toState + ": \t" + op)

              builder.addETransition(states2Brics(fromState), op,
                                     states2Brics(toState))
            }
          }

          case Seq(true, true) => {
            val op = OutputOp("", NOP, "")

            Console.err.println("" + fromState +
                                "- <eps> -> " +
                                "" + toState + ": \t" + op)

            builder.addETransition(states2Brics(fromState), op,
                                   states2Brics(toState))
          }

          case Seq(false, outEps) => {
            val presLabel =
              IntCastEliminator(
                PartialEvaluator(
                  simplifyLabel(bvLabel, p, transducerStringTheory)))

            if (!ContainsSymbol.isPresburger(presLabel))
              throw new Exception(
                "Could not translate constraint: " + p.pp(constraint))

            val splitLabel = NegEqSplitter(Transform2NNF(presLabel))
            
            for (disjunct <- DNFConverter mbDNF splitLabel) {
              var inputOp : Option[InputOp] = None
              var lBound : Option[Char] = None
              var uBound : Option[Char] = None
              var outputChars : List[Char] = List()

              for (c <- LineariseVisitor(disjunct, IBinJunctor.And)) c match {
                case IBoolLit(true) =>
                  // nothing
                case OutputInputOffsetEq(offset) =>
                  inputOp = Some(Plus(offset.intValueSafe))
                case EqLit(`outputC`, value) => {
                  inputOp = Some(NOP)
                  outputChars = List(value.intValueSafe.toChar)
                }
                case Geq(`inputC`, Const(bound)) =>
                  lBound = Some(bound.intValueSafe.toChar)
                case Geq(Const(bound), `inputC`) =>
                  uBound = Some(bound.intValueSafe.toChar)
                case EqLit(`inputC`, value) => {
                  lBound = Some(value.intValueSafe.toChar)
                  uBound = Some(value.intValueSafe.toChar)
                }
                case _ =>
                  throw new Exception(
                    "cannot handle transducer constraint " + c)
              }

              val lb = lBound getOrElse Char.MinValue
              val ub = uBound getOrElse Char.MaxValue

              if (outEps)
                inputOp = Some(NOP)

              val op = OutputOp("", inputOp.get, outputChars)

              Console.err.println("" + fromState +
                                  "-  [" + lb + ", " + ub + "] -> " +
                                  toState + ": \t" + op)

              builder.addTransition(states2Brics(fromState),
                                    (lb, ub), op,
                                    states2Brics(toState))
            }
          }
        }
      }

    }

    builder setInitialState states2Brics(0)

    builder.getTransducer
  }

  /**
   * Enumerate the solutions of a label that contains <code>outputC</code>
   * as the only variable.
   */
  private def enumLabelSolutions(f       : IFormula,
                                 outputC : ITerm,
                                 p       : SimpleAPI,
                                 tdST    : StringTheory) : Iterator[IdealInt] ={
    import IExpression._
    import tdST._
    f match {
      case Eq(`outputC`,
              IFunApp(`str_to_code`,
                      Seq(IFunApp(`str_cons`,
                                  Seq(IFunApp(ModuloArithmetic.mod_cast,
                                              Seq(IIntLit(lower),IIntLit(upper),
                                                  Const(value))),
                                      IFunApp(`str_empty`, Seq())))))) =>
        Iterator single ModuloArithmetic.evalModCast(lower, upper, value)
      case f => {
        import p._
        !! (f)
        new Iterator[IdealInt] {
          def hasNext : Boolean =
            (??? == ProverStatus.Sat)
          def next : IdealInt = {
            ???
            val res = eval(outputC)
            !! (outputC =/= res)
            res
          }
        }
      }
    }
  }

  /**
   * Simplify the label of a transition, with some optimisations for
   * simple/common labels.
   */
  private def simplifyLabel(f    : IFormula,
                            p    : SimpleAPI,
                            tdST : StringTheory) : IFormula = {
    import IExpression._
    import tdST._
    f match {
      case f : IBoolLit =>
        f
      case f @ Eq(_ : IConstant, _ : IConstant) =>
        f
      case Eq(c : IConstant,
              IFunApp(`str_to_code`,
                      Seq(IFunApp(`str_cons`,
                                  Seq(IFunApp(ModuloArithmetic.mod_cast,
                                              Seq(IIntLit(lower),IIntLit(upper),
                                                  Const(value))),
                                      IFunApp(`str_empty`, Seq())))))) =>
        c === ModuloArithmetic.evalModCast(lower, upper, value)
      case f =>
        p.simplify(f)
    }
  }

  /**
   * Visitor that splits negated equations into two inequalities.
   */
  private object NegEqSplitter extends CollectingVisitor[Unit, IExpression] {
    import IExpression._

    def apply(f : IFormula) : IFormula =
      visit(f, ()).asInstanceOf[IFormula]
    def postVisit(t : IExpression, arg : Unit,
                  subres : Seq[IExpression]) : IExpression =
      (t update subres) match {
        case INot(EqLit(t, value)) => t <= (value-1) | t >= (value+1)
        case s =>                     s
      }
  }

  /**
   * Visitor that eliminates the <code>ModuloArithmetic.int_cast</code>
   * function.
   */
  private object IntCastEliminator extends CollectingVisitor[Unit, IExpression]{
    def apply(f : IFormula) : IFormula =
      visit(f, ()).asInstanceOf[IFormula]
    def postVisit(t : IExpression, arg : Unit,
                  subres : Seq[IExpression]) : IExpression =
      t match {
        case IFunApp(ModuloArithmetic.int_cast, _) => subres.head
        case _ => t update subres
      }
  }

  /**
   * Extractor that matches equations equivalent to
   * <code>sym1 = sym2 + offset</code>.
   */
  private case class OffsetEq(sym1 : ITerm, sym2 : ITerm) {
    private val Sym1Eq  = SymbolEquation(sym1)
    private val Sym2Sum = SymbolSum(sym2)

    def unapply(f : IFormula) : Option[IdealInt] = f match {
      case Sym1Eq(sym1Coeff, Sym2Sum(sym2Coeff, Const(offset))) =>
        (sym1Coeff, sym2Coeff) match {
          case (IdealInt.ONE, IdealInt.ONE)             => Some(offset)
          case (IdealInt.MINUS_ONE, IdealInt.MINUS_ONE) => Some(-offset)
          case _                                        => None
        }
      case _ =>
        None
    }
  }

}
