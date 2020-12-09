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

import ecma2020regex._
import ecma2020regex.Absyn._

class ECMARegexParser(theory : OstrichStringTheory) {

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

  object TranslationVisitor extends FoldVisitor[ITerm, Unit] {
    import IExpression._
    import theory._

    val eps = re_eps()

    def leaf(arg : Unit) : ITerm = eps
    def combine(x : ITerm, y : ITerm, arg : Unit) : ITerm = (x, y) match {
      case (`eps`, y    ) => y
      case (x,     `eps`) => x
      case (x,     y    ) => re_++(x, y)
    }

    override def visit(p : ecma2020regex.Absyn.BegAnchor, arg : Unit) = {
      Console.err.println("Warning: ignoring anchor ^")
      re_eps()
    }

    override def visit(p : ecma2020regex.Absyn.EndAnchor, arg : Unit) = {
      Console.err.println("Warning: ignoring anchor $")
      re_eps()
    }

    override def visit(p : ecma2020regex.Absyn.ClassChar, arg : Unit) =
      extractLetter(printer print p)

    override def visit(p : ecma2020regex.Absyn.ClassCharNN, arg : Unit) =
      extractLetter(printer print p)

    override def visit(p : ecma2020regex.Absyn.ClassChar2, arg : Unit) =
      extractLetter(printer print p)

  }

  def extractLetter(str : String) : Int =
    if (str.size == 1) {
      str(0).toInt
    } else {
      throw new Exception("Expected string of length 1, not " + str)
    }

}
