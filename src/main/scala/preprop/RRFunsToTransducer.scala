/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
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

package strsolver.preprop

import ap.SimpleAPI
import ap.parser._
import ap.theories.ModuloArithmetic
import IExpression.Predicate
import SMTParser2InputAbsy.SMTType

import strsolver.SMTLIBStringTheory

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState, Transition => BTransition}

import scala.collection.mutable.{HashSet => MHashSet, HashMap => MHashMap}

object RRFunsToTransducer {
  def addFun2Transducer(fun : IFunction, afa : Transducer) : Unit =
    fun2Transducer.put(fun, afa)

  def addRel2Fun(p : Predicate, fun : IFunction) : Unit =
    rel2Fun.put(p, fun)

  def get(r : Predicate) : Option[Transducer] =
    for (f <- rel2Fun get r; tr <- fun2Transducer get f) yield tr

  private val fun2Transducer = new MHashMap[IFunction, Transducer]
  private val rel2Fun = new MHashMap[Predicate, IFunction]

  def registerRecFunctionsPreProp(funs : Seq[(IFunction, IFormula)],
                                  bitwidth : Int) : Unit = {
    import IExpression._

    val stateFuns = funs map (_._1)
    val tracks = 2

    val funs2Brics =
      (for (f <- stateFuns.iterator) yield (f -> new BState)).toMap
    val funsToState =
      stateFuns.view.zipWithIndex.toMap

    val operations = new MHashMap[(BState, BTransition), OutputOp]

    if (!(stateFuns forall { f => f.arity == tracks }))
      throw new Parser2InputAbsy.TranslationException(
        "Can only handle 2-track transducers")

    Console.withOut(Console.err) {
    println("Parsing transducer (" + funs.head._1.arity + " tracks):")
    println

    SimpleAPI.withProver { p =>

      val inputC = p.createConstant(ModuloArithmetic.UnsignedBVSort(bitwidth))
      val outputC = p.createConstant(ModuloArithmetic.UnsignedBVSort(bitwidth))

      val headConsts = Array(outputC, inputC)
      val headConstReplacer = new SeqHeadReplacer(headConsts)

      for ((f, transitions) <- funs) {
        println("State " + f.name + ":")

        for (trans <-
             LineariseVisitor(Transform2NNF(transitions), IBinJunctor.Or)) {
          val conjuncts = LineariseVisitor(trans, IBinJunctor.And)

          val (targetConds, otherCondsH) = conjuncts partition {
            case EqZ(IFunApp(f, _)) if stateFuns contains f => true
            case _ => false
          }

          val (emptinessConds, otherConds) = otherCondsH partition {
            case Eq(_ : IVariable, IFunApp(seq_empty, _)) => true
            case Eq(IFunApp(seq_empty, _), _ : IVariable) => true
            case _ => false
          }

//                println("emptinessConds: " + emptinessConds)
//                println("targetConds: " + targetConds)
//                println("otherConds: " + otherConds)

          if (conjuncts.size == emptinessConds.size &&
              (SymbolCollector variables and(emptinessConds)) ==
                ((0 until tracks) map (v(_))).toSet) {

            println("  (accepting)")
            funs2Brics(f) setAccept true

          } else targetConds.head match {

            case EqZ(IFunApp(targetFun,
                             Seq(IFunApp(SMTLIBStringTheory.seq_tail,
                                         Seq(IVariable(1))),
                                 IFunApp(SMTLIBStringTheory.seq_tail,
                                         Seq(IVariable(0)))))) => {

              // the non-epsilon case

              val bvLabel = headConstReplacer.visit(and(otherConds),Context(()))
                                             .asInstanceOf[IFormula]
              val presLabel = p.simplify(bvLabel)
              val disjuncts = LineariseVisitor(Transform2NNF(presLabel),
                                               IBinJunctor.Or)
                                               
              for (disjunct <- disjuncts) {
                val conjuncts = LineariseVisitor(disjunct, IBinJunctor.And)

                var inputOp : Option[InputOp] = None
                var lBound : Option[Char] = None
                var uBound : Option[Char] = None
                var outputChars : List[Char] = List()

                for (c <- conjuncts) c match {
                  case EqLit(Difference(`inputC`, `outputC`), offset) =>
                    inputOp = Some(Plus(offset.intValueSafe))
                  case EqLit(Difference(`outputC`, `inputC`), offset) =>
                    inputOp = Some(Plus(-offset.intValueSafe))
                  case EqLit(`inputC`, value) => {
                    lBound = Some(value.intValueSafe.toChar)
                    uBound = Some(value.intValueSafe.toChar)
                  }
                  case EqLit(`outputC`, value) => {
                    inputOp = Some(Delete)
                    outputChars = List(value.intValueSafe.toChar)
                  }
                  case Geq(`inputC`, IIntLit(bound)) =>
                    lBound = Some(bound.intValueSafe.toChar)
                  case Geq(IIntLit(bound), `inputC`) =>
                    uBound = Some(bound.intValueSafe.toChar)
                  case _ =>
                    Console.err.println("Ignoring " + c)
                }

                val trans = new BTransition(lBound getOrElse Char.MinValue,
                                            uBound getOrElse Char.MaxValue,
                                            funs2Brics(targetFun))
                val op = OutputOp(List(), inputOp.get, outputChars)

                println("  " + trans + ":   " + op)

                funs2Brics(f).addTransition(trans)
                operations.put((funs2Brics(f), trans), op)
              }
            }

            case _ =>
              throw new Parser2InputAbsy.TranslationException(
                "Illformed target state")

        }
      }
    }}

    println

    val tran = new BAutomaton
    tran setInitialState funs2Brics(stateFuns.head)

    val btran = new BricsTransducer(tran, operations.toMap)

    addFun2Transducer(stateFuns.head, btran)
  }}

  private class SeqHeadReplacer(headTerms : IndexedSeq[ITerm])
                extends ContextAwareVisitor[Unit, IExpression] {
    def postVisit(t : IExpression, ctxt : Context[Unit],
                  subres : Seq[IExpression]) : IExpression = t match {
      case IFunApp(SMTLIBStringTheory.seq_head, Seq(IVariable(ind)))
        if ind >= ctxt.binders.size &&
           ind - ctxt.binders.size < headTerms.size =>
          headTerms(ind - ctxt.binders.size)
      case _ =>
        t update subres
    }
  }
}
