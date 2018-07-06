/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017-2018  Philipp Ruemmer, Petr Janku
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
import SimpleAPI.ProverStatus
import ap.parser._
import ap.theories.ModuloArithmetic
import IExpression.Predicate
import SMTParser2InputAbsy.SMTType

import strsolver.SMTLIBStringTheory

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState, Transition => BTransition}

import scala.collection.mutable.{HashSet => MHashSet, HashMap => MHashMap,
                                 ArrayBuffer}

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

      val inputC, outputC =
         p.createConstant(ModuloArithmetic.UnsignedBVSort(bitwidth))
      val headConsts = Array(outputC, inputC)
      val headConstReplacer = new SeqHeadReplacer(headConsts)

      val epsTransitionsPost =
        new MHashMap[IFunction, ArrayBuffer[(Option[Char], IFunction)]]
      val epsTransitionsPre =
        new MHashMap[IFunction, ArrayBuffer[(Option[Char], IFunction)]]
      // has incoming non-e transition
      val hasIncoming = new MHashSet[IFunction]

      // When collecting predecessor e-transitions, we introduce a
      // transition from every found state that may be the stopping
      // point of a non-empty transition.  I.e. directly has an
      // incoming, or is final (see outputWordsPost), or is initial.
      //
      // First final seen will be last stopping point need to consider
      // except for initial state.  Any incoming transitions will meet
      // us at the final state.  Note, in general this is not true if
      // two final states appear on a path of e-transitions, but this
      // would imply a non-functional transducer.
      //
      // We are more conservative with post.
      def outputWordsPre(to: IFunction,
                         seenStates : Set[IFunction] = Set(),
                         initialOnly : Boolean = false)
                        : Iterator[(List[Char], IFunction)] = {
        if (seenStates contains to)
          throw new Exception(
            "Found transducer cycle that does not read any letters: " +
            to.name)
        val isFin = funs2Brics(to).isAccept
        val add = (!initialOnly && (hasIncoming.contains(to) || isFin)) ||
                  (to == stateFuns.head)
        val tran = if (add) Iterator((List(), to))
                   else Iterator()
        val restTrans = (epsTransitionsPre get to) match {
          case Some(transitions) =>
            for ((c, from) <- transitions.iterator;
                 (l, finalFrom) <- outputWordsPre(from,
                                                  seenStates + to,
                                                  initialOnly || isFin))
            yield (l ::: c.toList, finalFrom)
          case None => Iterator()
        }

        tran ++ restTrans
      }

      // when adding post e-transitions we always introduce a transition
      // to the direct successor (no e-tran) as this would be the
      // meeting point for any e-transitions coming back to  us.  After
      // that we rely on pre coming back except for final transitions.
      // We introduce a post transition to the first final state we see
      // on a run.  No need to look for a second as it will imply a
      // non-functional transducer.
      def outputWordsPost(from : IFunction,
                          seenStates : Set[IFunction] = Set())
                        : Iterator[(List[Char], IFunction)] = {
        if (seenStates contains from)
          throw new Exception(
            "Found transducer cycle that does not read any letters: " +
            from.name)
        if (funs2Brics(from).isAccept)
          return Iterator((List(), from))

        // always have transition with no e-transitions taken
        val firstTran = if (seenStates.isEmpty) Iterator((List(), from))
                        else Iterator()
        val restTrans = (epsTransitionsPost get from) match {
          case Some(transitions) =>
            for ((c, to) <- transitions.iterator;
                 (l, finalTo) <- outputWordsPost(to, seenStates + from))
            yield (c.toList ::: l, finalTo)
          case None =>
            Iterator((List(), from))
        }

        firstTran ++ restTrans
      }

      // we traverse the transition formulas twice:
      // first to identify input-epsilon transitions, and then to
      // collect all the other transitions

      for (phase <- List(1, 2)) {

      for ((f, transitions) <- funs) {
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

          val bvLabel = headConstReplacer.visit(and(otherConds),Context(()))
                                         .asInstanceOf[IFormula]

          if (conjuncts.size == emptinessConds.size &&
              (SymbolCollector variables and(emptinessConds)) ==
                ((0 until tracks) map (v(_))).toSet) {

            funs2Brics(f) setAccept true
            if (phase == 2) {
              println(f.name + " (accepting)")
            }

          } else targetConds.head match {

            case EqZ(IFunApp(targetFun,
                             Seq(IVariable(1),
                                 IFunApp(SMTLIBStringTheory.seq_tail,
                                         Seq(IVariable(0)))))) =>
            if (phase == 1) {
              val transBufferPost =
                epsTransitionsPost.getOrElseUpdate(f, new ArrayBuffer)
              p.scope {
                import p._
                !! (bvLabel)
                while (??? == ProverStatus.Sat) {
                  val out = eval(outputC)
                  transBufferPost += ((Some(out.intValueSafe.toChar), targetFun))
                  val transBufferPre =
                    epsTransitionsPre.getOrElseUpdate(targetFun, new ArrayBuffer)
                  transBufferPre += ((Some(out.intValueSafe.toChar), f))
                  !! (outputC =/= out)
                }
              }
            }

            case EqZ(IFunApp(targetFun,
                             Seq(IVariable(1), IVariable(0)))) =>
            if (phase == 1) {
              val transBufferPost =
                epsTransitionsPost.getOrElseUpdate(f, new ArrayBuffer)
              transBufferPost += ((None, targetFun))
              val transBufferPre =
                epsTransitionsPre.getOrElseUpdate(targetFun, new ArrayBuffer)
              transBufferPre += ((None, f))
            }

            case EqZ(IFunApp(targetFun,
                             Seq(IFunApp(SMTLIBStringTheory.seq_tail,
                                         Seq(IVariable(1))),
                                 outPat@(IVariable(0) |
                                         IFunApp(SMTLIBStringTheory.seq_tail,
                                                 Seq(IVariable(0))))))) =>
            if (phase == 1) {
              // assume label will be non-empty
              hasIncoming += targetFun
            }
            if (phase == 2) {
              val presLabel = p.simplify(bvLabel)
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
                    inputOp = Some(Delete)
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

                if (outPat == IVariable(0))
                  // this means no output is produced
                  inputOp = Some(Delete)

                for ((head, finalSource) <- outputWordsPre(f);
                     (tail, finalTarget) <- outputWordsPost(targetFun)) {
                  val trans = new BTransition(lb, ub, funs2Brics(finalTarget))
                  val op = OutputOp(head, inputOp.get,
                                    (outputChars ::: tail).mkString)

                  println(finalSource.name +
                          "-  [" + lb + ", " + ub + "] -> " +
                          finalTarget.name + ": \t" + op)

                  funs2Brics(finalSource).addTransition(trans)
                  operations.put((funs2Brics(finalSource), trans), op)
                }
              }
            }

            case t =>
              throw new Parser2InputAbsy.TranslationException(
                "Illformed target state: " + t)

        }
      }
    }}
    }

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
