package ostrich.parikh.preop

import ap.terfor.Term
import ostrich.automata.Automaton
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import scala.collection.mutable.ArrayBuffer
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ostrich.parikh.automata.BricsAutomatonWrapper.{
  makeAnyString,
  fromString,
  makeEmpty
}
import PreOpUtil.{automatonWithLen, automatonWithLenLessThan}
import ostrich.parikh.automata.BricsAutomatonWrapper
import LengthCEPreOp.lengthPreimage
import ostrich.parikh.LenTerm
import ostrich.parikh.automata.CEBasicOperations.{
  concatenate,
  complement,
  intersection
}

object IndexOfCEPreOp {
  def apply(startPos: Term, index: Term, matchStr: String) =
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
class IndexOfCEPreOp(startPos: Term, index: Term, matchString: String)
    extends CEPreOp {
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimages = Iterator[Seq[Automaton]]()

    val startPosPrefix = startPos match {
      case LinearCombination.Constant(value) => {
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
      case LinearCombination.Constant(value) => {
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
      case LinearCombination.Constant(value) => {
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
    preimage1.regsRelation = conj(preimage1.regsRelation, index >= startPos)

    // index = -1
    // len(searchedStr) < startPos
    val preimage2 = startPos match {
      case LinearCombination.Constant(value) => {
        if (value.intValueSafe < 0) {
          makeAnyString()
        } else
          automatonWithLenLessThan(value.intValueSafe)
      }
      case _ => {
        val searchedStrLen = LenTerm()
        val smallerThanStartPos = lengthPreimage(searchedStrLen)
        smallerThanStartPos.regsRelation = conj(
          smallerThanStartPos.regsRelation,
          searchedStrLen < startPos | startPos < 0
        )
        smallerThanStartPos
      }
    }
    preimage2.regsRelation = conj(preimage2.regsRelation, index === -1)

    // len(searchedStr) > startPos and no match after startPos
    val preimage3 = startPos match {
      case LinearCombination.Constant(value) => {
        concatenate(
          Seq(automatonWithLen(value.intValueSafe), notMatched)
        )
      }

      case _ => {
        val searchedStrLen = LenTerm()
        val largerThanStartPos = lengthPreimage(searchedStrLen)
        largerThanStartPos.regsRelation = conj(
          largerThanStartPos.regsRelation,
          searchedStrLen >= startPos
        )
        concatenate(
          Seq(largerThanStartPos, notMatched)
        )
      }
    }
    preimage3.regsRelation = conj(preimage3.regsRelation, index === -1)

    // empty match string with index >= 0
    val preimage4 = concatenate(Seq(startPosPrefix, makeAnyString()))
    preimage4.regsRelation = conj(preimage4.regsRelation, index === startPos)

    index match {
      case LinearCombination.Constant(value) if !matchString.isEmpty => {
        if (value.intValueSafe == -1) {
          preimages = Iterator(Seq(preimage2), Seq(preimage3))
        } else {
          preimages = Iterator(Seq(preimage1))
        }
      }

      case LinearCombination.Constant(value) if matchString.isEmpty => {
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