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

      for (TransducerTransition(fromState, toState, epsilons, constraint, _) <-
             transitions) {

        val bvLabel =
          VariableSubstVisitor(constraint, (List(inputC, outputC), 0))

        epsilons match {
          case Seq(true, false) => p.scope {
            import p._
            !! (bvLabel)
            while (??? == ProverStatus.Sat) {
              val out = eval(outputC)

              val op = OutputOp(out.intValueSafe.toChar.toString, NOP, "")

              Console.err.println("" + fromState + "- <eps> -> " +
                                  toState + ": \t" + op)

              builder.addETransition(states2Brics(fromState), op,
                                     states2Brics(toState))
              !! (outputC =/= out)
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
            val presLabel = p.simplify(bvLabel)
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
                case EqLit(Difference(`inputC`, `outputC`), offset) =>
                  inputOp = Some(Plus(-offset.intValueSafe))
                case EqLit(Difference(`outputC`, `inputC`), offset) =>
                  inputOp = Some(Plus(offset.intValueSafe))
                case EqLit(`outputC`, value) => {
                  inputOp = Some(NOP)
                  outputChars = List(value.intValueSafe.toChar)
                }
                case Geq(`inputC`, IIntLit(bound)) =>
                  lBound = Some(bound.intValueSafe.toChar)
                case Geq(IIntLit(bound), `inputC`) =>
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

}
