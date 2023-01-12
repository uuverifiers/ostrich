/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2022 Philipp Ruemmer. All rights reserved.
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

import ap.parser._
import ap.basetypes.IdealInt

import ecma2020regex._
import ecma2020regex.Absyn._
import ecma2020regex.Absyn.{Quantifier => ECMAQuantifier}

import scala.collection.JavaConversions.{asScalaBuffer, asScalaIterator}

object ECMARegexParser {

  val OctalEscape = """[0-7]{1,3}""".r

  val UnsupportedFlag = """[^ius]""".r

}

class ECMARegexParser(theory : OstrichStringTheory,
                      flags : String = "",
                      convertCaptureGroups : Boolean = false) {

  import theory._
  import IExpression._
  import ECMARegexParser._

  for (flag <- UnsupportedFlag.findAllMatchIn(flags))
    Console.err.println("Warning: ignoring unsupported regex flag " +
                          flag.matched)

  val printer = new PrettyPrinterNonStatic

  def string2Term(inputString : String) : ITerm =
    string2TermWithReduction(inputString)._1

  def string2TermExact(inputString : String) : ITerm = {
    val pat = parseRegex(inputString)
    val res = applyTranslationVisitorExact(pat)
    if (flags contains "i")
      theory.re_case_insensitive(res)
    else
      res
  }

  /**
   * Translate the given regex to a standard SMT-LIB regex term. This
   * will try to replace look-arounds and anchors with intersection. The
   * returned Boolean flag tells whether this reduction was precise, or
   * had to ignore some parts of the regex.
   */
  def string2TermWithReduction(inputString : String) : (ITerm, Boolean) = {
    val pat = parseRegex(inputString)
    val (res, incomplete) = applyTranslationVisitorRed(pat)
    val res2 =
      if (flags contains "i")
        theory.re_case_insensitive(res)
      else
        res
    (res2, incomplete)
  }

  def parseRegex(inputString : String) : Pattern = {
    val input =
      new java.io.BufferedReader (new java.io.StringReader(inputString))
    val res = parseRegex(input)
    input.close
    res
  }

  def parseRegex(input : java.io.Reader) : Pattern = {
    val l = new Yylex(input)
    val p = new parser(l) {
      override def report_error(message : String, info : Object) : Unit = {
        Console.err.println(message)
      }
    }

    p.pPatternC.asInstanceOf[Pattern]
  }

  //////////////////////////////////////////////////////////////////////////////

  // Currently the visitor argument just determines whether an expression
  // is outermost or not.
  type VisitorArg = Boolean

  val LookAhead       = new IFunction("LookAhead",  1, false, false)
  val LookBehind      = new IFunction("LookBehind", 1, false, false)
  val NegLookAhead    = new IFunction("NegLookAhead", 1, false, false)
  val NegLookBehind   = new IFunction("NegLookBehind", 1, false, false)
  val WordBoundary    = new IFunction("WordBoundary", 0, false, false)
  val NonWordBoundary = new IFunction("NonWordBoundary", 0, false, false)

  private def applyTranslationVisitorExact(pat : Pattern) = {
    val visitor = new TranslationVisitor(false)
    visitor.visit (pat, true)
  }

  private def applyTranslationVisitorRed(pat : Pattern) : (ITerm, Boolean) = {
    val visitor = new TranslationVisitor(true)
    val rawRes = visitor.visit (pat, true)
    val res = dropAssertions (rawRes)
    (res, res != rawRes)
  }

  private def dropAssertions(t : ITerm,
                             negative : Boolean = false) : ITerm = t match {

    case IFunApp(`re_begin_anchor`, _) => {
      Console.err.println("Warning: ignoring anchor ^")
      if (negative) NONE else EPS
    }
    case IFunApp(`re_end_anchor`, _) => {
      Console.err.println("Warning: ignoring anchor $")
      if (negative) NONE else EPS
    }

    case IFunApp(LookAhead, _) => {
      Console.err.println("Warning: ignoring look-ahead")
      if (negative) NONE else EPS
    }
    case IFunApp(LookBehind, _) => {
      Console.err.println("Warning: ignoring look-behind")
      if (negative) NONE else EPS
    }
    case IFunApp(NegLookAhead, _) => {
      Console.err.println("Warning: ignoring look-ahead")
      if (negative) NONE else EPS
    }
    case IFunApp(NegLookBehind, _) => {
      Console.err.println("Warning: ignoring look-behind")
      if (negative) NONE else EPS
    }
    case IFunApp(WordBoundary, _) => {
      Console.err.println("Warning: ignoring anchor \\b")
      if (negative) NONE else EPS
    }
    case IFunApp(NonWordBoundary, _) => {
      Console.err.println("Warning: ignoring anchor \\B")
      if (negative) NONE else EPS
    }
    case IFunApp(`re_comp`, Seq(arg)) =>
      re_comp(dropAssertions(arg, !negative))
    case IFunApp(f, args) =>
      f((for (arg <- args) yield dropAssertions(arg, negative)) : _*)
    case t =>
      t
  }


  /**
   * Visitor to translate a regex AST to a term.
   */
  class TranslationVisitor(APPROX : Boolean) extends FoldVisitor[ITerm, VisitorArg] {
    import IExpression._
    import theory._

    private var captGroupNum = 1

    def leaf(arg : VisitorArg) : ITerm = EPS
    def combine(x : ITerm, y : ITerm, arg : VisitorArg) : ITerm = reCat(x, y)

    override def visit(p : ecma2020regex.Absyn.Pattern, arg : VisitorArg) =
      reUnionStar(p.listalternativec_ map (_.accept(this, arg)) : _*)

    override def visit(p : ecma2020regex.Absyn.Alternative,
                       outermost : VisitorArg) = {
      val terms = expandGroups(p.listtermc_) map (_.accept(this, false))

      if (outermost && APPROX) {
        // handle leading look-aheads and trailing look-behinds

        var midTerms = terms filterNot (_ == EPS)

        val lookAheads = midTerms takeWhile {
          case IFunApp(`re_begin_anchor` | `re_end_anchor` |
                         LookAhead | NegLookAhead | WordBoundary | NonWordBoundary, _)
              => true
          case _
              => false
        }

        midTerms = midTerms drop lookAheads.size

        val newEnd = midTerms lastIndexWhere {
          case IFunApp(`re_begin_anchor` | `re_end_anchor` |
                         LookBehind | NegLookBehind | WordBoundary | NonWordBoundary, _)
              => false
          case _
              => true
        }

        val lookBehinds = midTerms takeRight (midTerms.size - newEnd - 1)
        midTerms = midTerms dropRight (midTerms.size - newEnd - 1)

        reInterStar(List(reCatStar(midTerms : _*)) ++
                      (for (s <- lookAheads) yield s match {
                         case IFunApp(`re_begin_anchor`, _) =>
                           ALL
                         case IFunApp(`re_end_anchor`, _) =>
                           EPS
                         case IFunApp(LookAhead, Seq(t)) =>
                           t
                         case IFunApp(NegLookAhead, Seq(t)) =>
                           t
                         case IFunApp(WordBoundary, _) =>
                           re_++(word, ALL)
                         case IFunApp(NonWordBoundary, _) =>
                           re_comp(re_++(word, ALL))
                       }) ++
                      (for (s <- lookBehinds) yield s match {
                         case IFunApp(`re_begin_anchor`, _) =>
                           EPS
                         case IFunApp(`re_end_anchor`, _) =>
                           ALL
                         case IFunApp(LookBehind, Seq(t)) =>
                           t
                         case IFunApp(NegLookBehind, Seq(t)) =>
                           t
                         case IFunApp(WordBoundary, _) =>
                           re_++(ALL, word)
                         case IFunApp(NonWordBoundary, _) =>
                           re_comp(re_++(ALL, word))
                       }) : _*)

      } else {
        reCatStar(terms : _*)
      }
    }

    private def expandGroups(ts : Seq[ecma2020regex.Absyn.TermC])
                                         : Seq[ecma2020regex.Absyn.TermC] = {
      if (convertCaptureGroups)
        return ts

      var changed = false
      val newTS =
        for (t <- ts;
             s <- (t match {
               case t : AtomTerm => t.atomc_ match {
                 case g : ecma2020regex.Absyn.GroupAtom
                     if g.listalternativec_.size == 1 => {
                       changed = true
                       altToTerms(g.listalternativec_)
                     }
                 case g : ecma2020regex.Absyn.NonCaptGroup
                     if g.listalternativec_.size == 1 => {
                       changed = true
                       altToTerms(g.listalternativec_)
                     }
                 case _ =>
                   List(t)
               }
               case t =>
                 List(t)
             }))
        yield s

      if (changed) expandGroups(newTS) else ts
    }

    private def altToTerms(a : Seq[ecma2020regex.Absyn.AlternativeC])
                         : Seq[ecma2020regex.Absyn.TermC] = {
      assert(a.size == 1)
      val alt = a.head.asInstanceOf[ecma2020regex.Absyn.Alternative]
      alt.listtermc_.toList
    }

    private def translateLookAhead(t : ITerm) : ITerm = {
      val ts = catToList(t) filterNot (_ == EPS)
      ts.lastOption match {
        case Some(IFunApp(`re_end_anchor`, _)) =>
          reCatStar(ts.init : _*)
        case _ =>
          reCatStar(ts ++ List(ALL) : _*)
      }
    }

    private def translateLookBehind(t : ITerm) : ITerm = {
      val ts = catToList(t) filterNot (_ == EPS)
      ts.headOption match {
        case Some(IFunApp(`re_begin_anchor`, _)) =>
          reCatStar(ts.tail : _*)
        case _ =>
          reCatStar(List(ALL) ++ ts : _*)
      }
    }


    private def catToList(t : ITerm) : Seq[ITerm] = t match {
      case IFunApp(`re_++`, Seq(a, b)) => catToList(a) ++ catToList(b)
      case t                         => List(t)
    }

    override def visit(p : ecma2020regex.Absyn.GroupAtom, arg : VisitorArg) = {
      // capture group
      val body = reUnionStar(p.listalternativec_ map (_.accept(this, arg)) : _*)
      val num = captGroupNum
      captGroupNum = captGroupNum + 1
      re_capture(num, body)
    }
    override def visit(p : ecma2020regex.Absyn.NonCaptGroup, arg : VisitorArg) =
      // non-capture group
      reUnionStar(p.listalternativec_ map (_.accept(this, arg)) : _*)

    override def visit(p : ecma2020regex.Absyn.PosLookahead, arg : VisitorArg) = {
      APPROX match {
        case true => LookAhead(
          translateLookAhead(
            reUnionStar(p.listalternativec_ map (_.accept(this, arg)): _*)))

        case false => {
          //println("Inside lookahead: " + p.listalternativec_)
          LookAhead(
            reUnionStar(p.listalternativec_ map (_.accept(this, arg)): _*))
        }
      }
    }

    override def visit(p : ecma2020regex.Absyn.NegLookahead, arg : VisitorArg) = {
      APPROX match {
        case true =>
          NegLookAhead(
            re_comp(translateLookAhead(reUnionStar(
              p.listalternativec_ map (_.accept(this, arg)): _*))))

        case false =>
          NegLookAhead(
            reUnionStar(p.listalternativec_ map (_.accept(this, arg)): _*))
      }
    }

    override def visit(p : ecma2020regex.Absyn.PosLookbehind,
                       arg : VisitorArg) = {
      APPROX match {
        case true => LookBehind(
          translateLookBehind(reUnionStar(
            p.listalternativec_ map (_.accept(this, arg)): _*)))
        case false => {
          //println("Inside lookbehind: " + (p.listalternativec_ map (_.accept(this, arg))) )
          LookBehind(
            reUnionStar(p.listalternativec_ map (_.accept(this, arg)): _*))
        }
      }
    }

    override def visit(p : ecma2020regex.Absyn.NegLookbehind, arg : VisitorArg) = {
      APPROX match {
        case true =>
          NegLookBehind (
            re_comp (
              translateLookBehind (
                reUnionStar (
                  p.listalternativec_ map (_.accept (this, arg) ): _*) ) ) )
        case false =>
          NegLookBehind(
            reUnionStar(p.listalternativec_ map (_.accept(this, arg)): _*))
      }
    }

    override def visit(p : ecma2020regex.Absyn.DotAtom, arg : VisitorArg) =
      if (flags contains "s")
        ALL_CHAR
      else
        charComplement(lineTerminator) // . is anything apart from a line term.

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscaped,
                       arg : VisitorArg) =
      decimal

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscapeD,
                       arg : VisitorArg) =
      charComplement(decimal)

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscapes,
                       arg : VisitorArg) =
      whitespace

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscapeS,
                       arg : VisitorArg) =
      charComplement(whitespace)

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscapew,
                       arg : VisitorArg) =
      word

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscapeW,
                       arg : VisitorArg) =
      charComplement(word)

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscapep,
                       arg : VisitorArg) = {
      val str = printer print p.unicodepropertyvalueexpressionc_
      if (flags contains "u")
        translateUnicodeProperty(str)
      else
        // If the Unicode flag is not set, the escape sequence should
        // be interpreted literally
        // TODO: this will not correctly model interaction with quantifiers
        str_to_re(theory.string2Term("p{" + str + "}"))
    }

    override def visit(p : ecma2020regex.Absyn.CharacterClassEscapeP,
                       arg : VisitorArg) = {
      val str = printer print p.unicodepropertyvalueexpressionc_
      if (flags contains "u")
        re_comp(translateUnicodeProperty(str))
      else
        // If the Unicode flag is not set, the escape sequence should
        // be interpreted literally.
        // TODO: this will not correctly model interaction with quantifiers
        str_to_re(theory.string2Term("P{" + str + "}"))
    }

    override def visit(p : ecma2020regex.Absyn.AtomQuanTerm,
                       arg : VisitorArg) = {
      val t = p.atomc_.accept(this, arg)
      val (prefix, greedy) = p.quantifierc_ match {
        case q : ECMAQuantifier      => (q.quantifierprefixc_, true)
        case q : QuantifierNonGreedy => (q.quantifierprefixc_, false)
      }
      prefix match {
        case _ : StarQuantifier  =>
          if (greedy) re_*(t) else re_*?(t)
        case _ : PlusQuantifier  =>
          if (greedy) re_+(t) else re_+?(t)
        case _ : OptQuantifier   =>
          if (greedy) re_opt(t) else re_opt_?(t)
        case q : Loop1Quantifier => {
          val n = parseDecimalDigits(q.listdecimaldigit_)
          re_loop(n, n, t)
        }
        case q : Loop2Quantifier => {
          val n = parseDecimalDigits(q.listdecimaldigit_)
          reCat(re_loop(n, n, t), if (greedy) re_*(t) else re_*?(t))
        }
        case q : Loop3Quantifier => {
          val n1 = parseDecimalDigits(q.listdecimaldigit_1)
          val n2 = parseDecimalDigits(q.listdecimaldigit_2)
          if (greedy) re_loop(n1, n2, t) else re_loop_?(n1, n2, t)
        }
      }
    }

    override def visit(p : ecma2020regex.Absyn.BegAnchor, arg : VisitorArg) =
      re_begin_anchor()

    override def visit(p : ecma2020regex.Absyn.EndAnchor, arg : VisitorArg) =
      re_end_anchor()

    override def visit(p : ecma2020regex.Absyn.WordAnchor,
                       arg : VisitorArg) =
      WordBoundary()

    override def visit(p : ecma2020regex.Absyn.NonWordAnchor,
                       arg : VisitorArg) =
      NonWordBoundary()

    override def visit(p : ecma2020regex.Absyn.NegClass,
                       arg : VisitorArg) =
      charComplement(p.classrangesc_.accept(this, arg))

    override def visit(p : ecma2020regex.Absyn.EmptyRange,
                       arg : VisitorArg) =
      NONE

    override def visit(p : ecma2020regex.Absyn.ClassCont,
                       arg : VisitorArg) = {
      val left = p.classatomc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRange,
                       arg : VisitorArg) = {
      val r = regexRange(p.classatomc_1.accept(this, arg),
                         p.classatomc_2.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassContNN,
                       arg : VisitorArg) = {
      val left = p.classatomnonegc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRangeNN,
                       arg : VisitorArg) = {
      val r = regexRange(p.classatomnonegc_.accept(this, arg),
                         p.classatomc_.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassContND,
                       arg : VisitorArg) = {
      val left = p.classatomnodashc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRangeND,
                       arg : VisitorArg) = {
      val r = regexRange(p.classatomnodashc_.accept(this, arg),
                         p.classatomc_.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter1,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter2,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter3,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter4,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)

    override def visit(p : ecma2020regex.Absyn.NormalCharPat,
                       arg : VisitorArg) =
      toSingleCharRegex(p.normalchar_)
    override def visit(p : ecma2020regex.Absyn.DecimalDigitPat,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.DashPat,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)

    override def visit(p : ecma2020regex.Absyn.DashAtom,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.NegAtom,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.NegAtomND,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.DashAtomNN,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg1,
                       arg : VisitorArg)=
      toSingleCharRegex(p.normalchar_)
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg2,
                       arg : VisitorArg)=
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg3,
                       arg : VisitorArg)=
      toSingleCharRegex(printer print p)

    // Different escape sequences

    override def visit(p : ecma2020regex.Absyn.DecAtomEscape,
                       arg : VisitorArg) = {
      val firstDigit =
        printer print p.decimaldigit_
      val tailDigits =
        p.maybedecimaldigits_ match {
          case _ : NoDecimalDigits => ""
          case ds : SomeDecimalDigits =>
            (for (d <- ds.listdecimaldigit_)
             yield (printer print d)).mkString("")
        }
      val allDigits =
        firstDigit + tailDigits

      allDigits match {
        case OctalEscape() =>
          charSet(Integer.parseInt(allDigits, 8))
        case _ => {
          val captureGroupNum = IdealInt(allDigits)
          re_reference(captureGroupNum)
        }
      }
    }

    override def visit(p : ecma2020regex.Absyn.BClassEscape,
                       arg : VisitorArg) =
      charSet(0x0008)
    override def visit(p : ecma2020regex.Absyn.DashClassEscape,
                       arg : VisitorArg) =
      charSet(0x002D)

    override def visit(p : ecma2020regex.Absyn.LetterCharEscape,
                       arg : VisitorArg) = {
      val letter = printer print p.controlletter_
      assert(letter.size == 1)
      charSet(letter(0).toInt % 32)
    }

    override def visit(p : ecma2020regex.Absyn.ControlEscapeT,
                       arg : VisitorArg) =
      charSet(0x0009)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeN,
                       arg : VisitorArg) =
      charSet(0x000A)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeV,
                       arg : VisitorArg) =
      charSet(0x000B)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeF,
                       arg : VisitorArg) =
      charSet(0x000C)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeR,
                       arg : VisitorArg) =
      charSet(0x000D)

    override def visit(p : ecma2020regex.Absyn.HexEscapeSequence,
                       arg : VisitorArg) =
      charSet(Integer.parseInt((printer print p.hexdigit_1) +
                                 (printer print p.hexdigit_2), 16))

    override def visit(p : ecma2020regex.Absyn.Hex4UniEscapeSequence,
                       arg : VisitorArg) =
      charSet(Integer.parseInt((printer print p.hexdigit_1) +
                                 (printer print p.hexdigit_2) +
                                 (printer print p.hexdigit_3) +
                                 (printer print p.hexdigit_4), 16))

    override def visit(p : ecma2020regex.Absyn.CodepointUniEscapeSequence,
                       arg : VisitorArg) = {
      val str = printer print p
      if (flags contains "u") {
        charSet(Integer.parseInt(str.substring(2, str.size - 1), 16))
      } else {
        // If the Unicode flag is not set, the escape sequence should
        // be interpreted literally
        // TODO: this will not correctly model interaction with quantifiers
        str_to_re(theory.string2Term(str))
      }
    }

    override def visit(p : ecma2020regex.Absyn.IdentityEscape,
                       arg : VisitorArg) =
      toSingleCharRegex(printer print p)

    override def visit(p : ecma2020regex.Absyn.OctClassEscape1,
                       arg : VisitorArg) =
      charSet(Integer.parseInt(printer print p.octaldigit_, 8))

    override def visit(p : ecma2020regex.Absyn.OctClassEscape2,
                       arg : VisitorArg) =
      charSet(Integer.parseInt((printer print p.octaldigit_1) +
                               (printer print p.octaldigit_2), 8))

    override def visit(p : ecma2020regex.Absyn.OctClassEscape3,
                       arg : VisitorArg) =
      charSet(Integer.parseInt((printer print p.octaldigit_1) +
                               (printer print p.octaldigit_2) +
                               (printer print p.octaldigit_3), 8))
  }

  //////////////////////////////////////////////////////////////////////////////

  private val EPS : ITerm       = re_eps()
  private val NONE : ITerm      = re_none()
  private val ALL : ITerm       = re_all()
  private val ALL_CHAR : ITerm  = re_allchar()

  private def reCat(x : ITerm, y : ITerm) = (x, y) match {
    case (`EPS`, y    ) => y
    case (x,     `EPS`) => x
    case (x,     y    ) => re_++(x, y)
  }

  private def reCatStar(xs : ITerm*) = (EPS /: xs) (reCat _)

  private def reUnion(x : ITerm, y : ITerm) = (x, y) match {
    case (`NONE`, y    ) => y
    case (x,     `NONE`) => x
    case (x,     y     ) => re_union(x, y)
  }

  private def reUnionStar(xs : ITerm*) = (NONE /: xs) (reUnion _)

  private def reInter(x : ITerm, y : ITerm) = (x, y) match {
    case (`ALL`, y    ) => y
    case (x,     `ALL`) => x
    case (x,     y    ) => re_inter(x, y)
  }

  private def reInterStar(xs : ITerm*) = (ALL /: xs) (reInter _)

  lazy val decimal = re_charrange(48, 57)
  lazy val uppCaseChars = re_charrange(65, 90)
  lazy val lowCaseChars = re_charrange(97, 122)
  lazy val underscore = re_charrange(95, 95)

  lazy val alphabet: Set[Int] = (48 to 57).toSet ++ (65 to 90).toSet ++ (97 to 122).toSet ++ Set(95) ++ Set(9, 10, 11, 12, 13, 32, 160, 0xFEFF, 0x2028, 0x2029)

  lazy val alphabetDebug = (97 to 101).toSet

  //lazy val alphabet: Set[Int] = (0 to 255).toSet

  private lazy val whitespace =
    charSet(9,          // TAB,   \t
            10,         // LF,    \n
            11,         // VT,    \v
            12,         // FF,    \f
            13,         // CR,    \r
            32,         // SPACE
            160,        // NBSP,  \xA0
            0xFEFF,     // ZWNBSP
            0x2028,     // LS, line separator
            0x2029)     // PS, paragraph separator

  private lazy val lineTerminator =
    charSet(10,         // LF,    \n
            13,         // CR,    \r
            0x2028,     // LS, line separator
            0x2029)     // PS, paragraph separator

  // TODO: canonicalise?
  private lazy val word =
    reUnionStar(re_charrange(65, 90),   // A-Z
                re_charrange(97, 122),  // a-z
                decimal,                // 0-9
                re_charrange(95, 95))   // _

  private def toSingleCharRegex(str : String) : ITerm =
    if (str.size == 1) {
      val n = str(0).toInt
      re_charrange(n, n)
    } else {
      throw new Exception("Expected string of length 1, not " + str)
    }

  private def toSingleCharRegex(p : ecma2020regex.Absyn.NormalChar) : ITerm =
    p match {
      case p : ecma2020regex.Absyn.SpecialLetterNormalChar =>
        toSingleCharRegex(p.specialnormalchar_)
      case p =>
        toSingleCharRegex(printer print p)
    }

  private def charComplement(t : ITerm) =
    re_diff(ALL_CHAR, t)

  private def regexRange(left : ITerm,
                         right : ITerm) : ITerm = (left, right) match {
    case (IFunApp(`re_charrange`, Seq(Const(lower), _)),
          IFunApp(`re_charrange`, Seq(_, Const(upper)))) =>
      re_charrange(lower, upper)
    case _ =>
      throw new Exception("Illformed character range in a regular expression")
  }

  private def parseDecimalDigits(digits : Seq[DecimalDigit]) : IdealInt =
    IdealInt((for (d <- digits) yield (printer print d)).mkString(""))

  private def charSet(chars : Int*) : ITerm =
    (for (c <- chars) yield re_charrange(c, c)).reduceLeft(reUnion _)

  /**
   * Currently we just match the general category properties.
   */
  private def translateUnicodeProperty(prop : String) : ITerm = {
    val norm = UnicodeData.normalizeGeneralProperty(prop)
    (UnicodeData.generalProperties get norm) match {
      case Some(intervals) =>
        reUnionStar((for ((l, u) <- intervals;
                          if u <= OstrichStringTheory.alphabetSize)
                     yield re_charrange(l, u)) : _*)
      case None =>
        throw new Exception("Could not decode Unicode property " + prop)
    }
  }

}
