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

package strsolver

import ap.parser._
import scala.collection.mutable.{HashSet => MHashSet}

object StringTheoryTranslator {

  def apply(formula : IFormula,
            globalWordVariables :
            Iterable[IExpression.ConstantTerm]) : IFormula = {
    ~(new StringTheoryTranslator(~formula, List(),
      globalWordVariables)).newConstraint
  }

}

class StringTheoryTranslator private (constraint : IFormula,
                                      interestingAtoms : Seq[IAtom],
                                      globalWordVariables :
                                      Iterable[IExpression.ConstantTerm])
  extends ContextAwareVisitor[Unit, IExpression] {

  import IExpression._
  import SMTLIBStringTheory._

  private val toPred = StringTheory.functionPredicateMapping.toMap

  private object SMTLIBPred {
    val reverseMapping =
      (for ((a, b) <- functionPredicateMapping.iterator)
        yield (b, a)).toMap
    def unapply(p : Predicate) : Option[IFunction] =
      reverseMapping get p
  }

  private object StringPred {
    val reverseMapping =
      (for ((a, b) <- toPred.iterator)
        yield (b, a)).toMap
    def unapply(p : Predicate) : Option[IFunction] =
      reverseMapping get p
  }

  //////////////////////////////////////////////////////////////////////////////
  // Detect all character variables/constants in the constraint of the
  // formula

  private val charVariables = new MHashSet[IConstant]

  private object CharVariableDetector extends CollectingVisitor[Unit, Unit] {
    def postVisit(t : IExpression, arg : Unit,
                  subres : Seq[Unit]) : Unit = t match {
      case IExpression.Eq(c : IConstant, d : IConstant) =>
        if ((charVariables contains c) ||
          (charVariables contains d)) {
          charVariables += c
          charVariables += d
        }
      case IAtom(SMTLIBPred(`seq_unit`), Seq(c : IConstant, _)) =>
        charVariables += c
      case IAtom(SMTLIBPred(`seq_cons`), Seq(c : IConstant, _, _)) =>
        charVariables += c
      case IAtom(SMTLIBPred(`seq_rev_cons`), Seq(_, c : IConstant, _)) =>
        charVariables += c
      case IAtom(SMTLIBPred(`seq_head`), Seq(_, c : IConstant)) =>
        charVariables += c
      case IAtom(SMTLIBPred(`seq_last`), Seq(_, c : IConstant)) =>
        charVariables += c
      case IAtom(SMTLIBPred(`seq_nth`), Seq(_, _, c : IConstant)) =>
        charVariables += c
      case IAtom(SMTLIBPred(`re_range`), Seq(c, d, _)) => {
        c match {
          case c : IConstant => charVariables += c
          case _ => // nothing
        }
        d match {
          case d : IConstant => charVariables += d
          case _ => // nothing
        }
      }
      case _ => // nothing
    }
  }

  {
    var oldSize = -1
    while (charVariables.size > oldSize) {
      oldSize = charVariables.size
      CharVariableDetector.visit(constraint, ())
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  private def toTermSeq(s : Seq[IExpression]) =
    (for (e <- s.iterator) yield e.asInstanceOf[ITerm]).toIndexedSeq

  private var constCounter = 0
  private def newConstant = {
    val res = new ConstantTerm("c" + constCounter)
    constCounter = constCounter + 1
    res
  }

  private def polChoice(ctxt : Context[Unit])
                       (pos : => IFormula)(neg : => IFormula) : IFormula =
    if (ctxt.polarity > 0) {
      pos
    } else if (ctxt.polarity < 0) {
      neg
    } else {
      assert(false)
      null
    }

  private def guardedExpr(guard : IFormula, expr : IFormula,
                          ctxt : Context[Unit]) : IFormula =
    polChoice(ctxt) {
      guard & expr
    } {
      guard ==> expr
    }

  //////////////////////////////////////////////////////////////////////////////

  def postVisit(t : IExpression, ctxt : Context[Unit],
                subres : Seq[IExpression]) : IExpression = t match {
    // equations between characters have to be turned into
    // word equations
    case IExpression.Eq(c : IConstant, d)
      if (charVariables contains c) => {
      val a, b = newConstant
      guardedExpr(toPred(StringTheory.wordChar)(c, a) &
        toPred(StringTheory.wordChar)(d, b),
        a === b,
        ctxt)
    }
    case IExpression.Eq(d, c : IConstant)
      if (charVariables contains c) => {
      val a, b = newConstant
      guardedExpr(toPred(StringTheory.wordChar)(c, a) &
        toPred(StringTheory.wordChar)(d, b),
        a === b,
        ctxt)
    }

    case IAtom(SMTLIBPred(`seq_unit`), _) =>
      IAtom(toPred(StringTheory.wordChar), toTermSeq(subres))
    case IAtom(SMTLIBPred(`seq_empty`), _) =>
      IAtom(toPred(StringTheory.wordEps), toTermSeq(subres))
    case IAtom(SMTLIBPred(`seq_concat`), _) =>
      IAtom(toPred(StringTheory.wordCat), toTermSeq(subres))

    case IAtom(SMTLIBPred(`seq_cons`), _) => {
      val Seq(head, tail, res) = toTermSeq(subres)
      val c = newConstant
      guardedExpr(toPred(StringTheory.wordChar)(head, c),
        toPred(StringTheory.wordCat)(c, tail, res),
        ctxt)
    }
    case IAtom(SMTLIBPred(`seq_rev_cons`), _) => {
      val Seq(first, last, res) = toTermSeq(subres)
      val c = newConstant
      guardedExpr(toPred(StringTheory.wordChar)(last, c),
        toPred(StringTheory.wordCat)(first, c, res),
        ctxt)
    }
    case IAtom(SMTLIBPred(`seq_head`), _) => {
      val Seq(str, head) = toTermSeq(subres)
      val a, b, c = newConstant
      guardedExpr(toPred(StringTheory.wordChar)(c, a) &
        toPred(StringTheory.wordCat)(a, b, str),
        c === head,
        ctxt)
    }
    case IAtom(SMTLIBPred(`seq_tail`), _) => {
      val Seq(str, tail) = toTermSeq(subres)
      val a, b, sigma = newConstant
      guardedExpr(toPred(StringTheory.rexSigma)(sigma) &
        StringTheory.member(a, sigma) &
        toPred(StringTheory.wordCat)(a, b, str),
        b === tail,
        ctxt)
    }
    case IAtom(SMTLIBPred(`seq_last`), _) => {
      val Seq(str, last) = toTermSeq(subres)
      val a, b, c = newConstant
      guardedExpr(toPred(StringTheory.wordChar)(c, a) &
        toPred(StringTheory.wordCat)(b, a, str),
        c === last,
        ctxt)
    }
    case IAtom(SMTLIBPred(`seq_first`), _) => {
      val Seq(str, first) = toTermSeq(subres)
      val a, b, sigma = newConstant
      guardedExpr(toPred(StringTheory.rexSigma)(sigma) &
        StringTheory.member(a, sigma) &
        toPred(StringTheory.wordCat)(b, a, str),
        b === first,
        ctxt)
    }

    case IAtom(`seq_prefix_of`, _) => {
      val Seq(shorter, longer) = toTermSeq(subres)
      polChoice(ctxt) {
        toPred(StringTheory.wordCat)(shorter, newConstant, longer)
      } {
        val a, b, aLen, shorterLen, longerLen = newConstant
        (toPred(StringTheory.wordLen)(shorter, shorterLen) &
          toPred(StringTheory.wordLen)(longer, longerLen) &
          toPred(StringTheory.wordCat)(a, b, longer) &
          toPred(StringTheory.wordLen)(a, aLen) &
          (aLen <= shorterLen) & (aLen <= longerLen) &
          ((aLen === shorterLen) | (aLen === longerLen))) ==>
          (a === shorter)
      }
    }
    case IAtom(`seq_suffix_of`, _) => {
      val Seq(shorter, longer) = toTermSeq(subres)
      polChoice(ctxt) {
        toPred(StringTheory.wordCat)(newConstant, shorter, longer)
      } {
        val a, b, aLen, shorterLen, longerLen = newConstant
        (toPred(StringTheory.wordLen)(shorter, shorterLen) &
          toPred(StringTheory.wordLen)(longer, longerLen) &
          toPred(StringTheory.wordCat)(b, a, longer) &
          toPred(StringTheory.wordLen)(a, aLen) &
          (aLen <= shorterLen) & (aLen <= longerLen) &
          ((aLen === shorterLen) | (aLen === longerLen))) ==>
          (a === shorter)
      }
    }
    case IAtom(`seq_subseq_of`, _) => {
      val Seq(shorter, longer) = toTermSeq(subres)
      polChoice(ctxt) {
        val a, b, c = newConstant
        toPred(StringTheory.wordCat)(shorter, b, c) &
          toPred(StringTheory.wordCat)(a, c, longer)
      } {
        // this can be done if "shorter" is a concrete string;
        // for a word variable this looks difficult?
        assert(false)
        null
      }
    }

    case IAtom(SMTLIBPred(`seq_extract`), _) => {
      val Seq(full, lo, hi, res) = toTermSeq(subres)
      val pref, substr, b, c, prefLen, substrLen, fullLen = newConstant
      guardedExpr(toPred(StringTheory.wordCat)(substr, b, c) &
        toPred(StringTheory.wordCat)(pref, c, full) &
        toPred(StringTheory.wordLen)(pref, prefLen) &
        toPred(StringTheory.wordLen)(substr, substrLen) &
        toPred(StringTheory.wordLen)(full, fullLen) &
        ((lo >= 0) ==>
          ((prefLen <= lo) & (prefLen <= fullLen) &
            ((prefLen === lo) | (prefLen === fullLen)))) &
        ((lo < 0) ==> (prefLen === 0)) &
        (((hi >= lo) & (hi >= 0)) ==>
          ((prefLen + substrLen <= hi) &
            ((prefLen + substrLen === hi) |
              (prefLen + substrLen === fullLen)))) &
        (((hi < lo) | (hi < 0)) ==> (substrLen === 0)),
        substr === res,
        ctxt)
    }

    case IAtom(SMTLIBPred(`seq_length`), _) =>
      IAtom(toPred(StringTheory.wordLen), toTermSeq(subres))

    ////////////////////////////////////////////////////////////////////////////

    case IAtom(SMTLIBPred(`re_empty_set`), _) =>
      IAtom(toPred(StringTheory.rexEmpty), toTermSeq(subres))
    case IAtom(SMTLIBPred(`re_full_set`), _) => {
      val Seq(res) = toTermSeq(subres)
      val sigma = newConstant
      guardedExpr(toPred(StringTheory.rexSigma)(sigma),
        toPred(StringTheory.rexStar)(sigma, res),
        ctxt)
    }
    case IAtom(SMTLIBPred(`re_allchar`), _) =>
      IAtom(toPred(StringTheory.rexSigma), toTermSeq(subres))
    case IAtom(SMTLIBPred(`re_concat`), _) =>
      IAtom(toPred(StringTheory.rexCat), toTermSeq(subres))
    case IAtom(SMTLIBPred(`re_empty_seq`), _) =>
      IAtom(toPred(StringTheory.rexEps), toTermSeq(subres))

    case IAtom(SMTLIBPred(`re_star`), _) =>
      IAtom(toPred(StringTheory.rexStar), toTermSeq(subres))
    case IAtom(SMTLIBPred(`re_loop`), _) =>
      assert(false); null
    case IAtom(SMTLIBPred(`re_plus`), _) => {
      val Seq(arg, res) = toTermSeq(subres)
      val a = newConstant
      guardedExpr(toPred(StringTheory.rexStar)(arg, a),
        toPred(StringTheory.rexCat)(arg, a, res),
        ctxt)
    }
    case IAtom(SMTLIBPred(`re_option`), _) => {
      val Seq(arg, res) = toTermSeq(subres)
      val a = newConstant
      guardedExpr(toPred(StringTheory.rexEps)(a),
        toPred(StringTheory.rexUnion)(arg, a, res),
        ctxt)
    }
    case IAtom(SMTLIBPred(`re_range`), _) =>
      IAtom(toPred(StringTheory.rexRange), toTermSeq(subres))

    case IAtom(SMTLIBPred(`re_union`), _) =>
      IAtom(toPred(StringTheory.rexUnion), toTermSeq(subres))
    case IAtom(SMTLIBPred(`re_difference`), _) => {
      val Seq(x, y, res) = toTermSeq(subres)
      val xNeg, xyNeg = newConstant
      guardedExpr(toPred(StringTheory.rexNeg)(x, xNeg) &
        toPred(StringTheory.rexUnion)(xNeg, y, xyNeg),
        toPred(StringTheory.rexNeg)(xyNeg, res),
        ctxt)
    }
    case IAtom(SMTLIBPred(`re_intersect`), _) => {
      val Seq(x, y, res) = toTermSeq(subres)
      val xNeg, yNeg, xyNeg = newConstant
      guardedExpr(toPred(StringTheory.rexNeg)(x, xNeg) &
        toPred(StringTheory.rexNeg)(y, yNeg) &
        toPred(StringTheory.rexUnion)(xNeg, yNeg, xyNeg),
        toPred(StringTheory.rexNeg)(xyNeg, res),
        ctxt)
    }
    case IAtom(SMTLIBPred(`re_complement`), _) =>
      IAtom(toPred(StringTheory.rexNeg), toTermSeq(subres))

    case IAtom(SMTLIBPred(`re_of_pred`), _) =>
      assert(false); null

    case IAtom(`re_member`, _) =>
      IAtom(StringTheory.member, toTermSeq(subres))

    case IAtom(SMTLIBPred(`seq_replace`), _) =>
      IAtom(toPred(StringTheory.replace), toTermSeq(subres))

    case IAtom(SMTLIBPred(`seq_replace_all`), _) =>
      IAtom(toPred(StringTheory.replaceall), toTermSeq(subres))

    case IAtom(SMTLIBPred(`seq_reverse`), _) =>
      IAtom(toPred(StringTheory.reverse), toTermSeq(subres))

    ////////////////////////////////////////////////////////////////////////////

    case t =>
      t update subres
  }

  //////////////////////////////////////////////////////////////////////////////

  private val preConstraint =
    visit(constraint, Context()).asInstanceOf[IFormula]

  //////////////////////////////////////////////////////////////////////////////
  // Detect word variables that are used in word/regex context

  private val wordVariables  = new MHashSet[IConstant]
  private val regexVariables = new MHashSet[IConstant]

  private object WordVariableDetector extends CollectingVisitor[Unit, Unit] {
    def postVisit(t : IExpression, arg : Unit,
                  subres : Seq[Unit]) : Unit = t match {
      case IExpression.Eq(c : IConstant, d : IConstant) => {
        if ((wordVariables contains c) || (wordVariables contains d)) {
          wordVariables += c
          wordVariables += d
        }
        if ((regexVariables contains c) || (regexVariables contains d)) {
          regexVariables += c
          regexVariables += d
        }
      }

      case IAtom(SMTLIBPred(`re_of_seq`),
      Seq(c : IConstant, _)) =>
        regexVariables += c
      case IAtom(StringPred(StringTheory.replace | StringTheory.replaceall 
                            | StringTheory.reverse),
      args) =>
        for (c <- args) c match {
          case c : IConstant => wordVariables += c
          case _ => // nothing
        }
      case IAtom(StringPred(StringTheory.wordLen),
      Seq(c : IConstant, _)) =>
        wordVariables += c
      case IAtom(StringTheory.member,
      Seq(c : IConstant, _)) =>
        wordVariables += c

      case IAtom(StringPred(StringTheory.wordCat),
      Seq(c : IConstant, d : IConstant, e : IConstant)) => {
        if ((wordVariables contains c) ||
          (wordVariables contains d) ||
          (wordVariables contains e)) {
          wordVariables += c
          wordVariables += d
          wordVariables += e
        }
        if (regexVariables contains e) {
          regexVariables += c
          regexVariables += d
        }
      }

      case _ => // nothing
    }
  }

  for (c <- globalWordVariables)
    wordVariables += IConstant(c)

  for (a <- interestingAtoms.iterator;
       c@IConstant(_) <- a.args.iterator)
    wordVariables += c

  {
    var oldWordSize = -1
    var oldRegexSize = -1
    while (wordVariables.size > oldWordSize ||
      regexVariables.size > oldRegexSize) {
      oldWordSize = wordVariables.size
      oldRegexSize = regexVariables.size
      WordVariableDetector.visit(preConstraint, ())
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  // Duplicate/replace word constraints that are used in the context of
  // regular expressions

  private val wordVariableDupl =
    (for (d@IConstant(c) <- wordVariables.iterator;
          if (regexVariables contains d))
      yield (c -> IExpression.i(newConstant))).toMap

  private object WordVariableDuplicator extends CollectingVisitor[Unit, IExpression] {
    def postVisit(t : IExpression, arg : Unit,
                  subres : Seq[IExpression]) : IExpression = t match {
      case IExpression.EqZ(_) => {
        val f = (t update subres).asInstanceOf[IFormula]
        val mapped = ConstantSubstVisitor(f, wordVariableDupl)
        if (mapped == f) f else f & mapped
      }
      case f@IAtom(StringPred(StringTheory.wordEps), Seq(c : IConstant)) =>
        and((if ((wordVariables contains c) ||
          !(regexVariables contains c)) List(f update subres) else List()) ++
          (if (regexVariables contains c)
            List(ConstantSubstVisitor(IAtom(toPred(StringTheory.rexEps),
              toTermSeq(subres)),
              wordVariableDupl))
          else List()))
      case f@IAtom(StringPred(StringTheory.wordChar), Seq(_, c : IConstant)) =>
        and((if ((wordVariables contains c) ||
          !(regexVariables contains c)) List(f update subres) else List()) ++
          (if (regexVariables contains c)
            List(ConstantSubstVisitor(IAtom(toPred(StringTheory.rexChar),
              toTermSeq(subres)),
              wordVariableDupl))
          else List()))
      case f@IAtom(StringPred(StringTheory.wordCat), Seq(_, _, c : IConstant)) =>
        and((if ((wordVariables contains c) ||
          !(regexVariables contains c)) List(f update subres) else List()) ++
          (if (regexVariables contains c)
            List(ConstantSubstVisitor(IAtom(toPred(StringTheory.rexCat),
              toTermSeq(subres)),
              wordVariableDupl))
          else List()))
      case IAtom(SMTLIBPred(`re_of_seq`),
      Seq(IConstant(c), d)) =>
        (wordVariableDupl get c) match {
          case Some(e) => e === d
          case None    => c === d
        }
      case t =>
        t update subres
    }
  }

  val newConstraint =
    WordVariableDuplicator.visit(preConstraint, ()).asInstanceOf[IFormula]

}
