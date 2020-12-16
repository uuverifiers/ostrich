/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020 Philipp Ruemmer. All rights reserved.
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

class ECMARegexParser(theory : OstrichStringTheory) {

  import theory._
  import IExpression._
  val printer = new PrettyPrinterNonStatic

  def string2Term(inputString : String) : ITerm = {
    val pat = parseRegex(inputString)
    TranslationVisitor.visit(pat, ())
  }

  def parseRegex(inputString : String) : Pattern = {
    val input =
      new java.io.BufferedReader (new java.io.StringReader(inputString))
    val res = parseRegex(input)
    input.close
    println(printer print res)
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

  object TranslationVisitor extends FoldVisitor[ITerm, Unit] {
    import IExpression._
    import theory._

    def leaf(arg : Unit) : ITerm = EPS
    def combine(x : ITerm, y : ITerm, arg : Unit) : ITerm = reCat(x, y)

    override def visit(p : ecma2020regex.Absyn.Pattern, arg : Unit) =
      (NONE /: (p.listalternativec_ map (_.accept(this, arg)))) (reUnion _)
    override def visit(p : ecma2020regex.Absyn.Alternative, arg : Unit) =
      (EPS /: (p.listtermc_ map (_.accept(this, arg)))) (reCat _)

    override def visit(p : ecma2020regex.Absyn.AtomQuanTerm, arg : Unit) = {
      val t = p.atomc_.accept(this, arg)
      p.quantifierc_ match {
        case q : ECMAQuantifier =>
          q.quantifierprefixc_ match {
            case _ : StarQuantifier  => re_*(t)
            case _ : PlusQuantifier  => re_+(t)
            case _ : OptQuantifier   => re_opt(t)
            case q : Loop1Quantifier => {
              if (q.listdecimaldigit_.isEmpty)
                throw new Exception(
                  "regex repetition needs some digits, not {}")
              val n = parseDecimalDigits(q.listdecimaldigit_)
              re_loop(n, n, t)
            }
          }
      }
    }

    override def visit(p : ecma2020regex.Absyn.BegAnchor, arg : Unit) = {
      Console.err.println("Warning: ignoring anchor ^")
      EPS
    }

    override def visit(p : ecma2020regex.Absyn.EndAnchor, arg : Unit) = {
      Console.err.println("Warning: ignoring anchor $")
      EPS
    }

    override def visit(p : ecma2020regex.Absyn.WordAnchor, arg : Unit) = {
      Console.err.println("Warning: ignoring anchor \\b")
      EPS
    }

    override def visit(p : ecma2020regex.Absyn.NonWordAnchor, arg : Unit) = {
      Console.err.println("Warning: ignoring anchor \\B")
      EPS
    }

    override def visit(p : ecma2020regex.Absyn.NegClass, arg : Unit) =
      re_inter(re_comp(p.classrangesc_.accept(this, arg)), re_allchar())

    override def visit(p : ecma2020regex.Absyn.EmptyRange, arg : Unit) =
      NONE

    override def visit(p : ecma2020regex.Absyn.ClassCont, arg : Unit) = {
      val left = p.classatomc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRange, arg : Unit) = {
      val r = regexRange(p.classatomc_1.accept(this, arg),
                         p.classatomc_2.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassContNN, arg : Unit) = {
      val left = p.classatomnonegc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRangeNN, arg : Unit) = {
      val r = regexRange(p.classatomnonegc_.accept(this, arg),
                         p.classatomc_.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCont2, arg : Unit) = {
      val left = p.classatomnodashc_.accept(this, arg)
      val rest = p.neclassrangesnodashc_.accept(this, arg)
      reUnion(left, rest)
    }

    override def visit(p : ecma2020regex.Absyn.ClassCharRange2, arg : Unit) = {
      val r = regexRange(p.classatomnodashc_.accept(this, arg),
                         p.classatomc_.accept(this, arg))
      val rest = p.classrangesc_.accept(this, arg)
      reUnion(r, rest)
    }

    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter1, arg : Unit) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter2, arg : Unit) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter3, arg : Unit) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.SyntaxCharacter4, arg : Unit) =
      toSingleCharRegex(printer print p)

    override def visit(p : ecma2020regex.Absyn.NormalCharPat, arg : Unit) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.DecimalDigitPat, arg : Unit) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.DashPat, arg : Unit) =
      toSingleCharRegex(printer print p)

    override def visit(p : ecma2020regex.Absyn.DashAtom, arg : Unit) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.NegAtom, arg : Unit) =
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg1, arg : Unit)=
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg2, arg : Unit)=
      toSingleCharRegex(printer print p)
    override def visit(p : ecma2020regex.Absyn.ClassAtomNoDashNeg3, arg : Unit)=
      toSingleCharRegex(printer print p)

  }

  val EPS : ITerm  = re_eps()
  val NONE : ITerm = re_none()

  def reCat(x : ITerm, y : ITerm) = (x, y) match {
    case (`EPS`, y    ) => y
    case (x,     `EPS`) => x
    case (x,     y    ) => re_++(x, y)
  }

  def reUnion(x : ITerm, y : ITerm) = (x, y) match {
    case (`NONE`, y    ) => y
    case (x,     `NONE`) => x
    case (x,     y     ) => re_union(x, y)
  }

  def toSingleCharRegex(str : String) : ITerm =
    if (str.size == 1) {
      val n = str(0).toInt
      re_charrange(n, n)
    } else {
      throw new Exception("Expected string of length 1, not " + str)
    }

  def regexRange(left : ITerm, right : ITerm) : ITerm = (left, right) match {
    case (IFunApp(`re_charrange`, Seq(Const(lower), _)),
          IFunApp(`re_charrange`, Seq(_, Const(upper)))) =>
      re_charrange(lower, upper)
  }

  def parseDecimalDigits(digits : Seq[DecimalDigit]) : IdealInt =
    IdealInt((for (d <- digits) yield (printer print d)).mkString(""))

}
