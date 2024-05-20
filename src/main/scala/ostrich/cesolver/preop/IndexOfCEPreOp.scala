/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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

package ostrich.cesolver.preop

import ostrich.automata.Automaton
import ostrich.cesolver.automata.BricsAutomatonWrapper.{
  makeAnyString,
  fromString
}
import PreOpUtil.automatonWithLenLessThan
import LengthCEPreOp.lengthPreimage
import ostrich.cesolver.automata.CEBasicOperations.{
  concatenate,
  complement,
  intersection
}
import ap.parser.ITerm
import ap.parser.IExpression._
import ap.parser.IExpression.Const
import ostrich.cesolver.util.TermGenerator
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IBinJunctor

object IndexOfCEPreOp {
  def apply(startPos: ITerm, index: ITerm, matchStr: String) =
    new IndexOfCEPreOp(startPos, index, matchStr)
}

/** argumentConstraints(0) is the automaton of the string term to search.
  * argumentConstraints(1)(0) is the automaton of the constant substring. We
  * generate a new automaton for the searched string term.
  * @param startPos
  *   start position of the search
  * @param index
  *   the index of the first occurrence of the substring
  */
class IndexOfCEPreOp(startPos: ITerm, index: ITerm, matchString: String)
    extends CEPreOp {

  private val termGen = TermGenerator()
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimages = Iterator[Seq[Automaton]]()
    val startPosPrefix = lengthPreimage(startPos)
    val notMatched = complement(
      concatenate(
        Seq(makeAnyString(), fromString(matchString), makeAnyString())
      )
    )
    val notMatchedLen =
      ((new ap.parser.Simplifier())(index + matchString.size - 1))
    val notMatchedStr = concatenate(
      Seq(
        intersection(
          lengthPreimage(notMatchedLen),
          concatenate(Seq(startPosPrefix, notMatched))
        ),
        makeAnyString()
      )
    )
    val matchedStr = concatenate(
      Seq(
        lengthPreimage(index),
        fromString(matchString),
        makeAnyString()
      )
    )

    // index >= 0, condition : len(argStr) >= startPos & stratPos >= 0
    val nonEpsMatchPosIdx = intersection(notMatchedStr, matchedStr)
    nonEpsMatchPosIdx.regsRelation = connectSimplify(
      Seq(nonEpsMatchPosIdx.regsRelation, index >= startPos, startPos >= 0),
      IBinJunctor.And
    )

    // index = -1, condition : len(argStr) < startPos | startPos < 0
    val negIdx1 = startPos match {
      case Const(value) => {
        if (value.intValueSafe < 0) {
          makeAnyString()
        } else
          automatonWithLenLessThan(value.intValueSafe)
      }
      case _ => {
        val argStrLen = termGen.lenTerm
        val smallerThanStartPos = lengthPreimage(argStrLen, false)
        smallerThanStartPos.regsRelation = connectSimplify(
          Seq(
            smallerThanStartPos.regsRelation,
            argStrLen < startPos | startPos < 0
          ),
          IBinJunctor.And
        )
        smallerThanStartPos
      }
    }
    negIdx1.regsRelation = connectSimplify(
      Seq(negIdx1.regsRelation, index === -1),
      IBinJunctor.And
    )

    // len(argStr) >= startPos and no match after startPos
    // bug in negIdx2 ！！！！！！！！
    val negIdx2 = concatenate(
      Seq(lengthPreimage(startPos), notMatched)
    )
    negIdx2.regsRelation = connectSimplify(
      Seq(negIdx2.regsRelation, index === -1),
      IBinJunctor.And
    )

    // epsilon match string with index >= 0
    val epsMatchPosIdx = concatenate(Seq(startPosPrefix, makeAnyString()))
    epsMatchPosIdx.regsRelation = connectSimplify(
      Seq(epsMatchPosIdx.regsRelation, index === startPos),
      IBinJunctor.And
    )

    index match {
      case Const(value) if !matchString.isEmpty => {
        if (value.intValueSafe == -1) {
          preimages = Iterator(Seq(negIdx1), Seq(negIdx2))
        } else {
          preimages = Iterator(Seq(nonEpsMatchPosIdx))
        }
      }

      case Const(value) if matchString.isEmpty => {
        if (value.intValueSafe == -1) {
          preimages = Iterator(Seq(negIdx1), Seq(negIdx2))
        } else {
          preimages = Iterator(Seq(epsMatchPosIdx))
        }
      }

      case _ if !matchString.isEmpty => {
        preimages =
          Iterator(Seq(negIdx1), Seq(negIdx2), Seq(nonEpsMatchPosIdx))
      }

      case _ if matchString.isEmpty => {
        preimages = Iterator(
          Seq(negIdx1),
          Seq(negIdx2),
          Seq(epsMatchPosIdx)
        )
      }
    }
    
    (preimages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val argStr = arguments(0).map(_.toChar).mkString
    val matchStr = arguments(1).map(_.toChar).mkString
    val startPos = arguments(2)(0)
    if (startPos < 0) {
      // the semantic of smtlb 2.6
      return Some(Seq(-1))
    }
    Some(Seq(argStr.indexOfSlice(matchStr, startPos)))

  }

  override def toString(): String = {
    "indexOfCEPreOp"
  }
}
