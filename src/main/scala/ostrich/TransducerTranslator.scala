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

import scala.collection.mutable.{HashMap => MHashMap, HashSet => MHashSet,
                                 ArrayBuffer}

/**
 * Helper methods to translate transducers in symbolic representation
 * (an arbitrary formula associated with each transition) to the
 * Brics representation.
 * 
 * TODO: check that transducers are deterministic!
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

    val usePriorities =
      transducer.transitions exists { t => !t.blockedTransitions.isEmpty }
    val builder =
      if (usePriorities)
        BricsPrioTransducer.getBuilder
      else
        BricsTransducer.getBuilder

    val states2Brics =
      (for (s <- states.toList.sorted) yield (s -> builder.getNewState)).toMap

    for (s <- accepting)
      builder.setAccept(states2Brics(s), true)

    val epsTransitions =
      new MHashMap[Int, ArrayBuffer[TransducerTransition]]

    SimpleAPI.withProver { p =>

      p.addTheory(transducerStringTheory)

      val inputC, outputC =
        p.createConstant(ModuloArithmetic.ModSort(IdealInt.ZERO,
                                                  IdealInt(alphabetSize - 1)))

      for (transition@
             TransducerTransition(fromState, toState, epsilons, constraint,
                                blockedTransitions) <- transitions) {

        val bvLabel =
          VariableSubstVisitor(constraint, (List(inputC, outputC), 0))

        epsilons match {
          case Seq(true, false) => p.scope {
            if (!blockedTransitions.isEmpty)
              throw new Exception(
                "Priorities can only be use for epsilon-transitions")

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

          case Seq(true, true) =>
            epsTransitions.getOrElseUpdate(fromState, new ArrayBuffer) +=
              transition

          case Seq(false, outEps) => {
            if (!blockedTransitions.isEmpty)
              throw new Exception(
                "Priorities can only be use for epsilon-transitions")

            val presLabel = PartialEvaluator(p.simplify(bvLabel))

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

    val nop = OutputOp("", NOP, "")

    for (fromState <- epsTransitions.keys.toVector.sorted) {
      val transitions = epsTransitions(fromState)

      if (transitions exists {
            case TransducerTransition(_, _, _, _, blocked) =>
              blocked exists {
                case BlockedTransition(_, Seq(false, true)) => false
                case _ => true
              }
          })
        throw new Exception (
          "Priority guards can only quantify the second track of a transducer")

      val allTransitions =
        for (TransducerTransition(_, toState, _, _, blockedTransitions) <-
               transitions) yield {
          val blockedStates =
            for (BlockedTransition(s, _) <- blockedTransitions) yield s
          (toState, blockedStates.toSet)
        }

      var remTransitions = allTransitions
      val finishedStates = new MHashSet[Int]
      var curPriority = 10

      while (!remTransitions.isEmpty) {
        val (chosen, rem) = remTransitions partition {
          case (_, blocked) => blocked == finishedStates
        }

        if (chosen.isEmpty)
          throw new Exception(
            "Epsilon transitions are not correctly prioritised")

        remTransitions = rem
        for ((toState, _) <- chosen) {
          if (usePriorities) {
            builder.asInstanceOf[BricsPrioTransducerBuilder]
                   .addETransition(states2Brics(fromState), nop, curPriority,
                                   states2Brics(toState))
            Console.err.println("" + fromState +
                                "- <eps-" + curPriority + "> -> " +
                                "" + toState + ": \t" + nop)
          } else {
            builder.addETransition(states2Brics(fromState), nop,
                                   states2Brics(toState))
            Console.err.println("" + fromState +
                                "- <eps> -> " +
                                "" + toState + ": \t" + nop)
          }
          finishedStates += toState
        }

        curPriority = curPriority - 1
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
