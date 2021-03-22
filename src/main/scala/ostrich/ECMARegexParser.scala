/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2021 Philipp Ruemmer. All rights reserved.
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

// import scala.collection.JavaConverters._
import scala.jdk.CollectionConverters._

class ECMARegexParser(theory : OstrichStringTheory) {

  import theory._
  import IExpression._
  val printer = new PrettyPrinterNonStatic

  def string2Term(inputString : String) : ITerm = {
    val pat = parseRegex(inputString)
    TranslationVisitor(pat)
  }

  def parseRegex(inputString : String) : Pattern = {
    val input =
      new java.io.BufferedReader (new java.io.StringReader(inputString))
    val res = parseRegex(input)
    input.close
    // println(printer print res)
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
  val WordBoundary    = new IFunction("WordBoundary", 0, false, false)
  val NonWordBoundary = new IFunction("NonWordBoundary", 0, false, false)

  /**
   * Visitor to translate a regex AST to a term.
   */
  object TranslationVisitor extends FoldVisitor[ITerm, VisitorArg] {
    import IExpression._
    import theory._

    def apply(pat : Pattern) = this.visit(pat, true)

    def leaf(arg : VisitorArg) : ITerm = EPS
    def combine(x : ITerm, y : ITerm, arg : VisitorArg) : ITerm = reCat(x, y)

    override def visit(p : ecma2020regex.Absyn.Pattern, arg : VisitorArg) =
      reUnionStar(p.listalternativec_.asScala.toSeq map (_.accept(this, arg)) : _*)

    override def visit(p : ecma2020regex.Absyn.Alternative,
                       outermost : VisitorArg) = {
      val terms = expandGroups(p.listtermc_.asScala.toSeq) map (_.accept(this, false))

      if (outermost) {
        // handle leading look-aheads and trailing look-behinds

        var midTerms = terms filterNot (_ == EPS)

        val lookAheads = midTerms takeWhile {
          case IFunApp(LookAhead | WordBoundary | NonWordBoundary, _) => true
          case _ => false
        }

        midTerms = midTerms drop lookAheads.size

        val newEnd = midTerms lastIndexWhere {
          case IFunApp(LookBehind | WordBoundary | NonWordBoundary, _) => false
          case _ => true
        }

        val lookBehinds = midTerms takeRight (midTerms.size - newEnd - 1)
        midTerms = midTerms dropRight (midTerms.size - newEnd - 1)

        reInterStar(List(reCatStar(dropAssertions(midTerms) : _*)) ++
                      (for (s <- lookAheads) yield s match {
                         case IFunApp(LookAhead, Seq(t)) =>
                           t
                         case IFunApp(WordBoundary, _) =>
                           re_++(word, ALL)
                         case IFunApp(NonWordBoundary, _) =>
                           re_comp(re_++(word, ALL))
                       }) ++
                      (for (s <- lookBehinds) yield s match {
                         case IFunApp(LookBehind, Seq(t)) =>
                           t
                         case IFunApp(WordBoundary, _) =>
                           re_++(ALL, word)
                         case IFunApp(NonWordBoundary, _) =>
                           re_comp(re_++(ALL, word))
                       }) : _*)

      } else {
        reCatStar(dropAssertions(terms) : _*)
      }
    }

    private def expandGroups(ts : Seq[ecma2020regex.Absyn.TermC])
                                         : Seq[ecma2020regex.Absyn.TermC] = {
      var changed = false
      val newTS =
        for (t <- ts;
             s <- (t match {
               case t : AtomTerm => t.atomc_ match {
                 case g : ecma2020regex.Absyn.GroupAtom
                     if g.listalternativec_.size == 1 => {
                       changed = true
                       altToTerms(g.listalternativec_.asScala.toSeq)
                     }
                 case g : ecma2020regex.Absyn.NonCaptGroup
                     if g.listalternativec_.size == 1 => {
                       changed = true
                       altToTerms(g.listalternativec_.asScala.toSeq)
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
      alt.listtermc_.asScala.toList
    }

    private def dropAssertions(ts : Seq[ITerm]) : Seq[ITerm] =
      ts filter {
        case IFunApp(LookAhead, _) => {
          Console.err.println("Warning: ignoring look-ahead")
          false
        }
        case IFunApp(LookBehind, _) => {
          Console.err.println("Warning: ignoring look-behind")
          false
        }
        case IFunApp(WordBoundary, _) => {
          Console.err.println("Warning: ignoring anchor \\b")
          false
        }
        case IFunApp(NonWordBoundary, _) => {
          Console.err.println("Warning: ignoring anchor \\B")
          false
        }
        case _ =>
          true
      }

    override def visit(p : ecma2020regex.Absyn.GroupAtom, arg : VisitorArg) =
      // capture group
      reUnionStar(p.listalternativec_.asScala.toSeq map (_.accept(this, arg)) : _*)
    override def visit(p : ecma2020regex.Absyn.NonCaptGroup, arg : VisitorArg) =
      // non-capture group
      reUnionStar(p.listalternativec_.asScala.toSeq map (_.accept(this, arg)) : _*)

    override def visit(p : ecma2020regex.Absyn.PosLookahead, arg : VisitorArg) =
      LookAhead(
        reCat(reUnionStar(p.listalternativec_.asScala.toSeq map (_.accept(this, arg)) : _*),
              ALL))
    override def visit(p : ecma2020regex.Absyn.NegLookahead, arg : VisitorArg) =
      LookAhead(
        re_comp(reCat(reUnionStar(
          p.listalternativec_.asScala.toSeq map (_.accept(this, arg)) : _*), ALL)))

    override def visit(p : ecma2020regex.Absyn.PosLookbehind,
                       arg : VisitorArg) =
      LookBehind(
        reCat(ALL, reUnionStar(
                p.listalternativec_.asScala.toSeq map (_.accept(this, arg)) : _*)))

    override def visit(p : ecma2020regex.Absyn.NegLookbehind,
                       arg : VisitorArg) =
      LookBehind(
        re_comp(reCat(ALL, reUnionStar(
                  p.listalternativec_.asScala.toSeq map (_.accept(this, arg)) : _*))))

    override def visit(p : ecma2020regex.Absyn.DotAtom, arg : VisitorArg) =
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

    override def visit(p : ecma2020regex.Absyn.AtomQuanTerm,
                       arg : VisitorArg) = {
      val t = p.atomc_.accept(this, arg)
      val (prefix, greedy) = p.quantifierc_ match {
        case q : ECMAQuantifier      => (q.quantifierprefixc_, true)
        case q : QuantifierNonGreedy => (q.quantifierprefixc_, false)
      }
      prefix match {
        case _ : StarQuantifier  => re_*(t)
        case _ : PlusQuantifier  => re_+(t)
        case _ : OptQuantifier   => re_opt(t)
        case q : Loop1Quantifier => {
          val n = parseDecimalDigits(q.listdecimaldigit_.asScala.toSeq)
          re_loop(n, n, t)
        }
        case q : Loop2Quantifier => {
          val n = parseDecimalDigits(q.listdecimaldigit_.asScala.toSeq)
          reCat(re_loop(n, n, t), re_*(t))
        }
        case q : Loop3Quantifier => {
          val n1 = parseDecimalDigits(q.listdecimaldigit_1.asScala.toSeq)
          val n2 = parseDecimalDigits(q.listdecimaldigit_2.asScala.toSeq)
          re_loop(n1, n2, t)
        }
      }
    }

    override def visit(p : ecma2020regex.Absyn.BegAnchor, arg : VisitorArg) = {
      Console.err.println("Warning: ignoring anchor ^")
      EPS
    }

    override def visit(p : ecma2020regex.Absyn.EndAnchor, arg : VisitorArg) = {
      Console.err.println("Warning: ignoring anchor $")
      EPS
    }

    override def visit(p : ecma2020regex.Absyn.WordAnchor, arg : VisitorArg) =
      WordBoundary()

    override def visit(p : ecma2020regex.Absyn.NonWordAnchor, arg : VisitorArg) =
      NonWordBoundary()

    override def visit(p : ecma2020regex.Absyn.NegClass, arg : VisitorArg) =
      charComplement(p.classrangesc_.accept(this, arg))

    override def visit(p : ecma2020regex.Absyn.EmptyRange, arg : VisitorArg) =
      NONE

    override def visit(p : ecma2020regex.Absyn.ClassCont, arg : VisitorArg) = {
      val left = p.classatomc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRange, arg : VisitorArg) = {
      val r = regexRange(p.classatomc_1.accept(this, arg),
                         p.classatomc_2.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassContNN, arg : VisitorArg) = {
      val left = p.classatomnonegc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRangeNN, arg : VisitorArg) = {
      val r = regexRange(p.classatomnonegc_.accept(this, arg),
                         p.classatomc_.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassContND, arg : VisitorArg) = {
      val left = p.classatomnodashc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRangeND, arg : VisitorArg) = {
      val r = regexRange(p.classatomnodashc_.accept(this, arg),
                         p.classatomc_.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter1, arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter2, arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter3, arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter4, arg : VisitorArg) =
      toSingleCharRegex(printer print p)

    override def visit(p : ecma2020regex.Absyn.NormalCharPat, arg : VisitorArg) =
      toSingleCharRegex(p.normalchar_)
    override def visit(p : ecma2020regex.Absyn.DecimalDigitPat, arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.DashPat, arg : VisitorArg) =
      toSingleCharRegex(printer print p)

    override def visit(p : ecma2020regex.Absyn.DashAtom, arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.NegAtom, arg : VisitorArg) =
      toSingleCharRegex(printer print p)
    
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg1, arg : VisitorArg)=
      toSingleCharRegex(p.normalchar_)
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg2, arg : VisitorArg)=
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg3, arg : VisitorArg)=
      toSingleCharRegex(printer print p)

    // Different escape sequences

    override def visit(p : ecma2020regex.Absyn.DecAtomEscape, arg : VisitorArg) = {
      val firstDigit =
        p.positivedecimal_
      val tailDigits =
        p.maybedecimaldigits_ match {
          case _ : NoDecimalDigits => ""
          case ds : SomeDecimalDigits =>
            (for (d <- ListHasAsScala(ds.listdecimaldigit_).asScala)
             yield (printer print d)).mkString("")
        }
      val captureGroupNum = IdealInt(firstDigit + tailDigits)
      Console.err.println("Warning: over-approximating back-reference as .*")
      ALL
    }

    override def visit(p : ecma2020regex.Absyn.BClassEscape, arg : VisitorArg) =
      charSet(0x0008)
    override def visit(p : ecma2020regex.Absyn.DashClassEscape, arg : VisitorArg) =
      charSet(0x002D)
    override def visit(p : ecma2020regex.Absyn.NullCharEscape, arg : VisitorArg) =
      charSet(0x0000)

    override def visit(p : ecma2020regex.Absyn.LetterCharEscape, arg : VisitorArg) = {
      val letter = printer print p.controlletter_
      assert(letter.size == 1)
      charSet(letter(0).toInt % 32)
    }

    override def visit(p : ecma2020regex.Absyn.ControlEscapeT, arg : VisitorArg) =
      charSet(0x0009)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeN, arg : VisitorArg) =
      charSet(0x000A)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeV, arg : VisitorArg) =
      charSet(0x000B)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeF, arg : VisitorArg) =
      charSet(0x000C)
    override def visit(p : ecma2020regex.Absyn.ControlEscapeR, arg : VisitorArg) =
      charSet(0x000D)

    override def visit(p : ecma2020regex.Absyn.HexEscapeSequence, arg : VisitorArg) =
      charSet(Integer.parseInt((printer print p.hexdigit_1) +
                                 (printer print p.hexdigit_2), 16))

    override def visit(p : ecma2020regex.Absyn.Hex4UniEscapeSequence, arg : VisitorArg) =
      charSet(Integer.parseInt((printer print p.hexdigit_1) +
                                 (printer print p.hexdigit_2) +
                                 (printer print p.hexdigit_3) +
                                 (printer print p.hexdigit_4), 16))

    override def visit(p : ecma2020regex.Absyn.CodepointUniEscapeSequence, arg : VisitorArg) = {
      val str = printer print p
      charSet(Integer.parseInt(str.substring(2, str.size - 1), 16))
    }

    override def visit(p : ecma2020regex.Absyn.IdentityEscape, arg : VisitorArg) =
      toSingleCharRegex(printer print p)

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

  private def reCatStar(xs : ITerm*) = xs.foldLeft(EPS) (reCat _)

  private def reUnion(x : ITerm, y : ITerm) = (x, y) match {
    case (`NONE`, y    ) => y
    case (x,     `NONE`) => x
    case (x,     y     ) => re_union(x, y)
  }

  private def reUnionStar(xs : ITerm*) = xs.foldLeft(NONE) (reUnion _)

  private def reInter(x : ITerm, y : ITerm) = (x, y) match {
    case (`ALL`, y    ) => y
    case (x,     `ALL`) => x
    case (x,     y    ) => re_inter(x, y)
  }

  private def reInterStar(xs : ITerm*) = xs.foldLeft(ALL) (reInter _)

  private lazy val decimal =
    re_charrange(48, 57)

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
  }

  private def parseDecimalDigits(digits : Seq[DecimalDigit]) : IdealInt =
    IdealInt((for (d <- digits) yield (printer print d)).mkString(""))

  private def charSet(chars : Int*) : ITerm =
    (for (c <- chars) yield re_charrange(c, c)).reduceLeft(reUnion _)

}
