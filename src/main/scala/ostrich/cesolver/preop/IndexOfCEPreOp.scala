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
import ap.parser.IExpression.Const
import ostrich.cesolver.util.TermGenerator
import ostrich.cesolver.util.ParikhUtil

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
    val startPosPrefix = startPos match {
      case Const(value) => {
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

    val notMatchedStr = index match {
      case Const(value) => {
        concatenate(
          Seq(
            intersection(
              automatonWithLen(value.intValueSafe + matchString.size - 1),
              concatenate(Seq(startPosPrefix, notMatched))
            ),
            makeAnyString()
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
            makeAnyString()
          )
        )
      }
    }

    val matchedStr = index match {
      case Const(value) => {
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
    val positiveIndex = intersection(notMatchedStr, matchedStr)
    positiveIndex.regsRelation = and(Seq(positiveIndex.regsRelation, index >= startPos, startPos >= 0))

    // index = -1
    // len(searchedStr) < startPos
    val negtiveIndex1 = startPos match {
      case Const(value) => {
        if (value.intValueSafe < 0) {
          makeAnyString()
        } else
          automatonWithLenLessThan(value.intValueSafe)
      }
      case _ => {
        val searchedStrLen = termGen.lenTerm
        val smallerThanStartPos = lengthPreimage(searchedStrLen, false)
        smallerThanStartPos.regsRelation = and(Seq(
          smallerThanStartPos.regsRelation,
          searchedStrLen < startPos | startPos < 0
        ))
        smallerThanStartPos
      }
    }
    negtiveIndex1.regsRelation = and(Seq(negtiveIndex1.regsRelation, index === -1))

    // len(searchedStr) > startPos and no match after startPos
    val negtiveIndex2 = startPos match {
      case Const(value) => {
        concatenate(
          Seq(automatonWithLen(value.intValueSafe), notMatched)
        )
      }

      case _ => {
        val searchedStrLen = termGen.lenTerm
        val largerThanStartPos = lengthPreimage(searchedStrLen, false)
        largerThanStartPos.regsRelation = and(Seq(
          largerThanStartPos.regsRelation,
          searchedStrLen >= startPos
        ))
        concatenate(
          Seq(largerThanStartPos, notMatched)
        )
      }
    }
    negtiveIndex2.regsRelation = and(Seq(negtiveIndex2.regsRelation, index === -1))

    // empty match string with index >= 0
    val emptyPositiveIndex = concatenate(Seq(startPosPrefix, makeAnyString()))
    emptyPositiveIndex.regsRelation = and(Seq(emptyPositiveIndex.regsRelation, index === startPos))

    index match {
      case Const(value) if !matchString.isEmpty => {
        if (value.intValueSafe == -1) {
          preimages = Iterator(Seq(negtiveIndex1), Seq(negtiveIndex2))
        } else {
          preimages = Iterator(Seq(positiveIndex))
        }
      }

      case Const(value) if matchString.isEmpty => {
        if (value.intValueSafe == -1) {
          preimages = Iterator(Seq(negtiveIndex1), Seq(negtiveIndex2))
        } else {
          preimages = Iterator(Seq(emptyPositiveIndex))
        }
      }

      case _ if !matchString.isEmpty => {
        preimages = Iterator(Seq(positiveIndex), Seq(negtiveIndex1), Seq(negtiveIndex2))
      }

      case _ if matchString.isEmpty => {
        preimages = Iterator(Seq(emptyPositiveIndex), Seq(negtiveIndex1), Seq(negtiveIndex2))
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
