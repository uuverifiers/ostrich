/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2021-2024 Riccardo de Masellis, Philipp Ruemmer. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich

import ostrich.automata.{AutDatabase, BricsAutomaton}
import ap.basetypes.IdealInt
import ap.parser.{IBoolLit, IFunApp, IIntLit, IExpression}
import ap.terfor.{ComputationLogger, Formula, TerForConvenience, Term, TermOrder}
import ap.terfor.conjunctions.{Conjunction, NegatedConjunctions, Quantifier,
                               ReduceWithConjunction, ReducerPlugin,
                              ReducerPluginFactory}
import ap.terfor.arithconj.ArithConj
import ap.terfor.preds.{Atom, PredConj, Predicate}
import ap.terfor.linearcombination.LinearCombination
import ap.util.PeekIterator
import AutDatabase.{ComplementedAut, NamedAutomaton, PositiveAut}

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

object OstrichReducer {
  def extractLanguageConstraints(conj : PredConj,
                                 theory : OstrichStringTheory)
                               : Map[Term, List[NamedAutomaton]] = {
    val languages = new MHashMap[Term, List[NamedAutomaton]]

    for (a <- conj positiveLitsWithPred theory.str_in_re_id)
      if (a(0).variables.isEmpty) {
        val id = regexAtomToId(a)
        languages.put(a(0),
                      PositiveAut(id) :: languages.getOrElse(a(0), List()))
      }
/*
    // We do not collect negative language constraints, since this would
    // interfere with the class OstrichStrInReTranslator, which will
    // systematically make all constraints positive.
    for (a <- conj negativeLitsWithPred theory.str_in_re_id)
      if (a(0).variables.isEmpty) {
        val id = regexAtomToId(a)
        languages.put(a(0),
                      ComplementedAut(id) :: languages.getOrElse(a(0), List()))
      }
*/
    languages.toMap
  }

  def regexAtomToId(a : Atom) : Int = {
    assert(a(1).isConstant)
    a(1).constant.intValueSafe
  }

  val IntRegex                = """[0-9]+""".r
  val IntNoLeadingZeroesRegex = """[1-9][0-9]*|0""".r
}

class OstrichReducerFactory protected[ostrich] (theory : OstrichStringTheory)
      extends ReducerPluginFactory {
  import OstrichReducer.extractLanguageConstraints

  import theory.{str_len, int_to_str, str_to_int, str_prefixof, str_indexof,
                 FunPred}

  def apply(conj : Conjunction, order : TermOrder) =
    new OstrichReducer(theory,
                       new OstrichStringFunctionTranslator(theory, conj),
                       List(extractLanguageConstraints(conj.predConj, theory)),
                       this,
                       order)

  val _str_len      = FunPred(str_len)
  val _int_to_str   = FunPred(int_to_str)
  val _str_to_int   = FunPred(str_to_int)
  val _str_indexof  = FunPred(str_indexof)

}

/**
 * Reducer for string constraints. This class is responsible for
 * simplifying string formulas during proof construction.
 */
class OstrichReducer protected[ostrich]
           (theory              : OstrichStringTheory,
            funTranslator       : OstrichStringFunctionTranslator,
            languageConstraints : List[Map[Term, List[NamedAutomaton]]],
            val factory         : OstrichReducerFactory,
            order               : TermOrder)
      extends ReducerPlugin {

  import OstrichReducer._

  import theory.{_str_empty, _str_cons, _str_++, str_<=, _str_char_count,
                 str_empty, str_cons, str_in_re_id, str_prefixof, str_extract,
                 str_suffixof, str_contains,
                 str_replace, str_replaceall,
                 re_++, re_*, re_+, str_to_re, re_all, re_comp, re_charrange,
                 strDatabase, autDatabase, FunPred, string2Term, int2Char}
  import factory.{_str_len, _int_to_str, _str_to_int, _str_indexof}
  def passQuantifiers(num : Int) = this

  def addAssumptions(arithConj : ArithConj,
                     mode : ReducerPlugin.ReductionMode.Value) = this

  def addAssumptions(predConj : PredConj,
                     mode : ReducerPlugin.ReductionMode.Value) =
    mode match {
      case ReducerPlugin.ReductionMode.Contextual => {
        val newLangs =
          extractLanguageConstraints(predConj, theory) match {
            case m if m.isEmpty => languageConstraints
            case m              => m :: languageConstraints
          }
        val newFunTranslator =
          funTranslator.addFacts(Conjunction.conj(predConj, order), order)
        new OstrichReducer(theory, newFunTranslator, newLangs, factory, order)
      }
      case _ =>
        this
  }

  def finalReduce(conj : Conjunction) = conj

  def reduce(predConj : PredConj,
             reducer  : ReduceWithConjunction,
             logger   : ComputationLogger,
             mode     : ReducerPlugin.ReductionMode.Value)
           :  ReducerPlugin.ReductionResult = {
    reduce1(predConj, reducer, logger, mode) orElse
    reduce2(predConj, reducer, logger, mode)
  }

  /**
   * Reduction based on contextual knowledge.
   */
  private def reduce1(predConj : PredConj,
                      reducer  : ReduceWithConjunction,
                      logger   : ComputationLogger,
                      mode     : ReducerPlugin.ReductionMode.Value)
                    : ReducerPlugin.ReductionResult = {
    implicit val _order = order
    import TerForConvenience._
    import strDatabase.{isConcrete, hasValue, term2List, term2ListGet,
                        list2Id, str2Id, term2Str}

    def getLanguages(t : Term) : Iterator[NamedAutomaton] =
      for (c <- languageConstraints.iterator;
           l <- (c get t).iterator;
           aut <- l.iterator)
      yield aut

    val rewritablePredicates =
      (List(_str_empty, _str_cons, str_in_re_id, _str_len, _str_char_count,
            str_<=, _int_to_str, _str_to_int, _str_indexof,
            str_prefixof, str_suffixof, str_contains,
            FunPred(str_replace), FunPred(str_replaceall)) ++
       funTranslator.translatablePredicates).distinct

    // We inform the OstrichStringFunctionTranslator about the atoms
    // that will not be rewritten. Those atoms might contain regex definitions,
    // which the OstrichStringFunctionTranslator depends on.
    lazy val extendedFunTranslator = {
      val rewritable = rewritablePredicates.toSet
      val otherAtoms = predConj.positiveLits.filter(a =>
                         !rewritable(a.pred) && a.variables.isEmpty)
      funTranslator.addFacts(conj(otherAtoms), order)
    }

    ReducerPlugin.rewritePreds(predConj, rewritablePredicates,
                               order, logger) { a =>
      a.pred match {
        case `_str_empty` =>
          a.last === strDatabase.iTerm2Id(IFunApp(str_empty, List()))

        case `_str_cons` =>
          if (a(0).isConstant && isConcrete(a(1))) {
            a.last ===
            strDatabase.iTerm2Id(IFunApp(str_cons,
                                         List(IIntLit(a(0).constant),
                                              IIntLit(a(1).constant))))
          } else {
            a
          }

        case `_str_++` if hasValue(a(0), List()) =>
          a(1) === a(2)
        case `_str_++` if hasValue(a(1), List()) =>
          a(0) === a(2)

        case `str_in_re_id` => {
          val autId = regexAtomToId(a)
          if (autId == autDatabase.emptyLangId) {
            Conjunction.FALSE
          } else if (autId == autDatabase.anyStringId) {
            Conjunction.TRUE
          } else if (isConcrete(a(0))) {
            val Some(str) = term2List(a(0))
            val Some(aut) = autDatabase.id2Automaton(autId)
            if (aut(str)) Conjunction.TRUE else Conjunction.FALSE
          } else {
            val aut = PositiveAut(autId)
            val knownLanguages = getLanguages(a(0))

            var res : Formula = a
            var reduced = false
            while (!reduced && knownLanguages.hasNext) {
              val knownAut = knownLanguages.next
              if (autDatabase.emptyIntersection(aut, knownAut)) {
                res = Conjunction.FALSE
                reduced = true
              } else if (autDatabase.isSubsetOf(knownAut, aut)) {
                res = Conjunction.TRUE
                reduced = true
              }
            }

            res
          }
        }

        case `_str_len` =>
          if (isConcrete(a(0))) {
            a.last === term2ListGet(a(0)).size
          } else if (a.last.isConstant && a.last.constant.isZero) {
            a(0) === list2Id(List())
          } else {
            a
          }

        case `_str_char_count` =>
          if (a(0).isConstant && isConcrete(a(1))) {
            val char = a(0).constant.intValueSafe
            a.last === term2ListGet(a(1)).count(_ == char)
          } else {
            a
          }

        case `_int_to_str` =>
          if (a(0).isConstant) {
            val const = a(0).constant
            val str   = if (const.signum < 0) "" else a(0).constant.toString
            val id    = str2Id(str)
            a.last === id
          } else if (isConcrete(a(1))) {
            val str = term2Str(a(1)).get
            str match {
              case IntNoLeadingZeroesRegex() => {
                val strVal = IdealInt(str)
                a(0) === strVal
              }
              case "" =>
                a(0) < 0
              case _ =>
                Conjunction.FALSE
            }
          } else {
            a
          }

        case `_str_to_int` =>
          if (isConcrete(a(0))) {
            val str = term2Str(a(0)).get
            val strVal = str match {
              case IntRegex() => IdealInt(str)
              case _          => IdealInt.MINUS_ONE
            }
            a.last === strVal
          } else if (a(1).isConstant) {
            a(1).constant match {
              case IdealInt.MINUS_ONE => {
                // argument must be something different from a decimal number
                val autId = {
                  import IExpression._
                  val re =
                    re_comp(re_+(re_charrange(int2Char(48), int2Char(57))))
                  autDatabase.regex2Id(re)
                }
                str_in_re_id(List(a(0), l(autId)))
              }
              case const if const.signum >= 0 => {
                val autId = {
                  import IExpression._
                  val num = const.toString
                  val re  = re_++(re_*(str_to_re("0")), str_to_re(num))
                  autDatabase.regex2Id(re)
                }
                str_in_re_id(List(a(0), l(autId)))
              }
              case _ =>
                Conjunction.FALSE
            }
          } else {
            a
          }

        case `str_prefixof` if a(0) == a(1) =>
          Conjunction.TRUE
        case `str_suffixof` if a(0) == a(1) =>
          Conjunction.TRUE
        case `str_contains` if a(0) == a(1) =>
          Conjunction.TRUE

        case `str_suffixof` =>
          if (isConcrete(a(0))) {
            assert(a(0).isConstant)
            val asRE  = IFunApp(re_++,
              List(IFunApp(re_all, List()),IFunApp(str_to_re, List(a(0).constant))
                ))
            val autId = autDatabase.regex2Id(asRE)
            str_in_re_id(List(a(1), l(autId)))
          } else if (isConcrete(a(1))) {
            val str   = term2Str(a(1)).get
            val autId = autDatabase.automaton2Id(
              BricsAutomaton.suffixAutomaton(str))
            str_in_re_id(List(a(0), l(autId)))
          } else {
            a
          }

        case `str_contains` =>
          if (isConcrete(a(1))) {
            assert(a(1).isConstant)
            val asRE  =
              IFunApp(re_++,
              List(IFunApp(re_all, List()),IFunApp(str_to_re, List(a(1).constant))
              , IFunApp(re_all, List())))
            val autId = autDatabase.regex2Id(asRE)
            str_in_re_id(List(a(0), l(autId)))
          } else if (isConcrete(a(0))) {
            val str   = term2Str(a(0)).get
            val autId = autDatabase.automaton2Id(
              BricsAutomaton.containsAutomaton(str))
            str_in_re_id(List(a(1), l(autId)))
          } else {
            a
          }

        case `str_prefixof` =>
          if (isConcrete(a(0))) {
            assert(a(0).isConstant)
            val asRE  = IFunApp(re_++,
                                List(IFunApp(str_to_re, List(a(0).constant)),
                                     IFunApp(re_all, List())))
            val autId = autDatabase.regex2Id(asRE)
            str_in_re_id(List(a(1), l(autId)))
          } else if (isConcrete(a(1))) {
            val str   = term2Str(a(1)).get
            val autId = autDatabase.automaton2Id(
                          BricsAutomaton.prefixAutomaton(str))
            str_in_re_id(List(a(0), l(autId)))
          } else {
            a
          }

        case `_str_indexof` => {
          import LinearCombination.Constant
          import strDatabase.IntEncodedString
          (a(0), a(1), a(2), a(3)) match {
            case (_, _, Constant(startIndex), result)
              if startIndex < 0 =>
                result === -1
            case (IntEncodedString(bigStr), _, Constant(startIndex), result)
              if startIndex > bigStr.size =>
                result === -1
            case (IntEncodedString(bigStr), IntEncodedString(searchStr),
                  Constant(IdealInt(startIndex)), result) => {
              val searchLen = searchStr.size
              val matches =
                for (ind <- (startIndex to (bigStr.size - searchLen)).iterator;
                     if bigStr.substring(ind, ind + searchLen) == searchStr)
                yield ind
              if (matches.hasNext)
                result === matches.next
              else
                result === -1
            }
            case _ =>
              a
          }
        }

        case FunPred(`str_replace` | `str_replaceall`) if a(1) == a(2) =>
          a(0) === a(3)

        case FunPred(`str_replace`) if a(0) == a(1) =>
          a(2) === a(3)

        case FunPred(`str_replace` | `str_replaceall`)
            if isConcrete(a(0)) && isConcrete(a(1)) &&
               !(term2ListGet(a(0)) containsSlice term2ListGet(a(1))) =>
          a(0) === a(3)

        case FunPred(`str_replace`) if hasValue(a(1), List()) =>
          _str_++(List(a(2), a(0), a(3)))

        case FunPred(`str_replaceall`) if hasValue(a(1), List()) =>
          a(0) === a(3)

        case `str_<=` if (isConcrete(a(1))) => {
          val autId =
            autDatabase.automaton2Id(
              BricsAutomaton.smallerEqAutomaton(term2Str(a(1)).get))
          str_in_re_id(List(a(0), l(autId)))
        }

        case `str_<=` if (isConcrete(a(0))) => {
          val autId =
            autDatabase.automaton2Id(
              BricsAutomaton.greaterEqAutomaton(term2Str(a(0)).get))
          str_in_re_id(List(a(1), l(autId)))
        }

        case `str_<=` => {
          // case we cannot handle yet
          a
        }

        case p => {
          assert(funTranslator.translatablePredicates contains p,
                 "Unhandled case in reducer: " + p)
          extendedFunTranslator(a) match {
            case Some((op, args, res)) if (args forall isConcrete) => {
              val argStrs = args map term2ListGet
              op().eval(argStrs) match {
                case Some(resStr) =>
                  res === list2Id(resStr)
                case None =>
                  // If the function is not defined for the given concrete
                  // arguments, the atom cannot be satisfied.
                  Conjunction.FALSE
              }
            }
            case _ =>
              a
          }
        }
      }
    }
  }

  /**
   * Subsumption and consistency checks for regexes.
   */
  private def reduce2(predConj : PredConj,
                      reducer : ReduceWithConjunction,
                      logger : ComputationLogger,
                      mode : ReducerPlugin.ReductionMode.Value)
                    : ReducerPlugin.ReductionResult =
    mode match {
      case ReducerPlugin.ReductionMode.Contextual => {
        val posLits = predConj positiveLitsWithPred str_in_re_id
        val negLits = predConj negativeLitsWithPred str_in_re_id

        if (posLits.size + negLits.size >= 2) {
          implicit val order = predConj.order

          val posIt = PeekIterator(posLits.iterator)
          val negIt = PeekIterator(negLits.iterator)

          val newPos, newNeg, curPos, curNeg = new ArrayBuffer[Atom]

          import autDatabase.{isSubsetOf, isSubsetOfBE, emptyIntersection}

          def pickNextTerm : Term =
            if (posIt.hasNext) {
              if (negIt.hasNext) {
                val a = posIt.peekNext(0)
                val b = negIt.peekNext(0)
                if (order.compare(a, b) >= 0) a else b
              } else {
                posIt.peekNext(0)
              }
            } else {
              negIt.peekNext(0)
            }

          def isConflicting(aut : NamedAutomaton) : Boolean =
            (curPos exists { a =>
               emptyIntersection(PositiveAut(regexAtomToId(a)), aut) }) ||
            (curNeg exists { a =>
               emptyIntersection(ComplementedAut(regexAtomToId(a)), aut) })

          // TODO: the use of isSubsetOfBE is problematic. With option
          // +assert, assertions switched on, this can lead to an
          // assertion failure in ReduceWithConjunction, since
          // applying the reducer multiple times can have different results.

          def isFwdSubsumed(aut : NamedAutomaton) : Boolean =
            (curPos exists { a =>
               isSubsetOfBE(PositiveAut(regexAtomToId(a)), aut) ==
               Some(true) }) ||
            (curNeg exists { a =>
               isSubsetOfBE(ComplementedAut(regexAtomToId(a)), aut) ==
               Some(true) })

          def removeBwdSubsumed(aut : NamedAutomaton) : Unit = {
            var n = 0

            while (n < curPos.size)
              if (isSubsetOfBE(aut, PositiveAut(regexAtomToId(curPos(n)))) ==
                    Some(true))
                curPos remove n
              else
                n = n + 1

            n = 0
            while (n < curNeg.size)
              if (isSubsetOfBE(aut, ComplementedAut(regexAtomToId(curNeg(n))))==
                    Some(true))
                curNeg remove n
              else
                n = n + 1
          }

          def otherAtoms(atoms : Seq[Atom]) : Seq[Atom] =
            atoms filterNot { a => a.pred == str_in_re_id }

          def addConstraint(a : Atom, aut : NamedAutomaton,
                            set : ArrayBuffer[Atom]) : Boolean =
            if (isFwdSubsumed(aut)) {
              false
            } else if (isConflicting(aut)) {
              true
            } else {
              removeBwdSubsumed(aut)
              set += a
              false
            }

          while (posIt.hasNext || negIt.hasNext) {
            val nextTerm = pickNextTerm

            while (posIt.hasNext && posIt.peekNext(0) == nextTerm) {
              val a = posIt.next
              if (addConstraint(a, PositiveAut(regexAtomToId(a)), curPos))
                return ReducerPlugin.FalseResult
            }

            while (negIt.hasNext && negIt.peekNext(0) == nextTerm) {
              val a = negIt.next
              if (addConstraint(a, ComplementedAut(regexAtomToId(a)), curNeg))
                return ReducerPlugin.FalseResult
            }

            newPos ++= curPos
            newNeg ++= curNeg

            curPos.clear
            curNeg.clear
          }

          if (newPos.size != posLits.size || newNeg.size != negLits.size) {
            val newPredConj =
              PredConj(otherAtoms(predConj.positiveLits) ++ newPos,
                       otherAtoms(predConj.negativeLits) ++ newNeg,
                       order)
            ReducerPlugin.ChangedConjResult(ArithConj.TRUE,
                                            newPredConj,
                                            NegatedConjunctions.TRUE)
          } else {
            ReducerPlugin.UnchangedResult
          }
        } else {
          ReducerPlugin.UnchangedResult
        }
      }
      case _ =>
        ReducerPlugin.UnchangedResult
    }

}
