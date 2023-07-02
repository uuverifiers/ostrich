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
import ap.terfor.linearcombination.LinearCombination
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import scala.collection.mutable.ArrayBuffer
import ostrich.cesolver.automata.BricsAutomatonWrapper.{
  makeAnyString,
  fromString,
  makeEmpty
}
import PreOpUtil.{automatonWithLen, automatonWithLenLessThan}
import ostrich.cesolver.automata.BricsAutomatonWrapper
import LengthCEPreOp.lengthPreimage
import ostrich.cesolver.automata.CEBasicOperations.{
  concatenate,
  complement,
  intersection
}
import ap.parser.ITerm
import ap.parser.IExpression._
import ap.parser.IIntLit
import ostrich.cesolver.util.TermGenerator

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

  private val termGen = TermGenerator(hashCode())
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimages = Iterator[Seq[Automaton]]()

    val startPosPrefix = startPos match {
      case IIntLit(value) => {
        automatonWithLen(value.intValueSafe)
      }
      case _ => {
        lengthPreimage(startPos)
      }
    }

    val notMatched = complement(
      concatenate(
        Seq(makeAnyString(), fromString(matchString), makeAnyString())
      )
    )

    val notMatchedPrefix = index match {
      case IIntLit(value) => {
        concatenate(
          Seq(
            intersection(
              automatonWithLen(value.intValueSafe + matchString.size - 1),
              concatenate(Seq(startPosPrefix, notMatched))
            ),
            makeAnyString
          )
        )
      }
      case _ => {
        concatenate(
          Seq(
            intersection(
              lengthPreimage(index + matchString.size - 1),
              concatenate(Seq(startPosPrefix, notMatched))
            ),
            makeAnyString
          )
        )
      }
    }

    val matchedSuffix = index match {
      case IIntLit(value) => {
        concatenate(
          Seq(
            automatonWithLen(value.intValueSafe),
            fromString(matchString),
            makeAnyString()
          )
        )
      }
      case _ => {
        concatenate(
          Seq(
            lengthPreimage(index),
            fromString(matchString),
            makeAnyString()
          )
        )
      }
    }


    // index >= 0
    val preimage1 = intersection(notMatchedPrefix, matchedSuffix)
    preimage1.regsRelation = and(Seq(preimage1.regsRelation, index >= startPos))

    // index = -1
    // len(searchedStr) < startPos
    val preimage2 = startPos match {
      case IIntLit(value) => {
        if (value.intValueSafe < 0) {
          makeAnyString()
        } else
          automatonWithLenLessThan(value.intValueSafe)
      }
      case _ => {
        val searchedStrLen = termGen.lenTerm
        val smallerThanStartPos = lengthPreimage(searchedStrLen)
        smallerThanStartPos.regsRelation = and(Seq(
          smallerThanStartPos.regsRelation,
          searchedStrLen < startPos | startPos < 0
        ))
        smallerThanStartPos
      }
    }
    preimage2.regsRelation = and(Seq(preimage2.regsRelation, index === -1))

    // len(searchedStr) > startPos and no match after startPos
    val preimage3 = startPos match {
      case IIntLit(value) => {
        concatenate(
          Seq(automatonWithLen(value.intValueSafe), notMatched)
        )
      }

      case _ => {
        val searchedStrLen = termGen.lenTerm
        val largerThanStartPos = lengthPreimage(searchedStrLen)
        largerThanStartPos.regsRelation = and(Seq(
          largerThanStartPos.regsRelation,
          searchedStrLen >= startPos
        ))
        concatenate(
          Seq(largerThanStartPos, notMatched)
        )
      }
    }
    preimage3.regsRelation = and(Seq(preimage3.regsRelation, index === -1))

    // empty match string with index >= 0
    val preimage4 = concatenate(Seq(startPosPrefix, makeAnyString()))
    preimage4.regsRelation = and(Seq(preimage4.regsRelation, index === startPos))

    index match {
      case IIntLit(value) if !matchString.isEmpty => {
        if (value.intValueSafe == -1) {
          preimages = Iterator(Seq(preimage2), Seq(preimage3))
        } else {
          preimages = Iterator(Seq(preimage1))
        }
      }

      case IIntLit(value) if matchString.isEmpty => {
        if (value.intValueSafe == -1) {
          preimages = Iterator(Seq(preimage2), Seq(preimage3))
        } else {
          preimages = Iterator(Seq(preimage4))
        }
      }

      case _ if !matchString.isEmpty => {
        preimages = Iterator(Seq(preimage1), Seq(preimage2), Seq(preimage3))
      }

      case _ if matchString.isEmpty => {
        preimages = Iterator(Seq(preimage4), Seq(preimage2), Seq(preimage3))
      }
    }

    (preimages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val searchedStr = arguments(0).map(_.toChar).mkString
    val matchStr = arguments(1).map(_.toChar).mkString
    val startPos = arguments(2)(0)
    if (startPos < 0) {
      // the semantic of smtlb 2.6
      return Some(Seq(-1))
    }
    Some(Seq(searchedStr.indexOfSlice(matchStr, startPos)))

  }

  override def toString(): String = {
    "IndexOfCEPreOp"
  }
}
