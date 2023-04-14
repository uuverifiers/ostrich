package ostrich.parikh.preop

import ap.terfor.Term
import ostrich.automata.Automaton
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import scala.collection.mutable.ArrayBuffer
import ostrich.parikh.LenTerm
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ostrich.parikh.automata.BricsAutomatonWrapper.{
  makeAnyString,
  fromString,
  makeEmpty
}
import ostrich.parikh.automata.BricsAutomatonWrapper
import LengthCEPreOp.lengthPreimage

object IndexOfCEPreOp {
  def apply(startPos: Term, index: Term) =
    new IndexOfCEPreOp(startPos, index)
}

/** argumentConstraints(0) is the automaton of the string term to search.
  * argumentConstraints(1)(0) is the automaton of the constant substring. We
  * generate a new automaton for the searched string term.
  * @param startPos
  *   start position of the search
  * @param index
  *   the index of the first occurrence of the substring
  */
class IndexOfCEPreOp(startPos: Term, index: Term) extends CEPreOp {
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimages = Iterator[Seq[Automaton]]()
    val matchString = argumentConstraints(1)(0).getAcceptedWord.get
    startPos match {
      case LinearCombination.Constant(value) =>
        preimages = preimageOfConstantStart(
          matchString,
          value.intValueSafe,
          index
        )
      case _ =>
        preimages = preimageOfVariableStart(matchString, startPos, index)
    }

    (preimages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val searchedStr = arguments(0).map(_.toChar).mkString
    val matchStr = arguments(1).map(_.toChar).mkString
    val startPos = arguments(2)(0)
    Some(Seq(searchedStr.indexOf(matchStr, startPos)))
  }

  override def toString(): String = {
    "IndexOfCEPreOp"
  }

  private def preimageOfConstantStart(
      matchString: Seq[Int],
      startPos: Int,
      index: Term
  ): Iterator[Seq[CostEnrichedAutomatonBase]] = {
    import ostrich.parikh.automata.CEBasicOperations.{
      concatenate,
      complement,
      intersection
    }
    var preimages = Iterator[Seq[CostEnrichedAutomatonBase]]()
    val matchStr = matchString.map(_.toChar).mkString
    val startPosPrefix = automatonWithLen(startPos)
    val notMatched = complement(
      concatenate(Seq(makeAnyString, fromString(matchStr), makeAnyString))
    )
    index match {
      case LinearCombination.Constant(value) => {
        // index is constant
        val index = value.intValue
        if (index == -1) {
          // startPos > len(searched_string)
          val preimage1 = automatonWithLenLessThan(startPos)

          // startPos <= len(searched_string) and searched_string do not contains matchString after startPos
          val preimage2 = concatenate(
            Seq(startPosPrefix, notMatched)
          )

          preimages = Iterator(
            Seq(preimage1),
            Seq(preimage2)
          )
        } else {
          val notMatchedMiddle = intersection(
            notMatched,
            automatonWithLen(index - startPos)
          )
          val matchedSuffix = concatenate(
            Seq(fromString(matchStr), makeAnyString())
          )
          val preimage = concatenate(
            Seq(startPosPrefix, notMatchedMiddle, matchedSuffix)
          )

          preimages = Iterator(Seq(preimage))
        }
      }
      case _ => {
        // index is variable

        // 1) index = -1
        val preimage1 = automatonWithLenLessThan(startPos)
        preimage1.regsRelation = conj(preimage1.regsRelation, index === -1)
        val preimage2 = concatenate(
          Seq(startPosPrefix, notMatched)
        )
        preimage2.regsRelation = conj(preimage2.regsRelation, index === -1)

        // 2) index >= 0
        val notMatchedMiddle = intersection(
          notMatched,
          lengthPreimage(index - startPos)
        )
        val matchedSuffix = concatenate(
          Seq(fromString(matchStr), makeAnyString())
        )
        val preimage3 = concatenate(
          Seq(startPosPrefix, notMatchedMiddle, matchedSuffix)
        )

        preimages = Iterator(
          Seq(preimage1),
          Seq(preimage2),
          Seq(preimage3)
        )

      }
    }
    preimages
  }

  private def preimageOfVariableStart(
      matchString: Seq[Int],
      startPos: Term,
      index: Term
  ): Iterator[Seq[CostEnrichedAutomatonBase]] = {
    Iterator()
  }

  private def automatonWithLen(len: Int): CostEnrichedAutomatonBase = {
    val automaton = new CostEnrichedAutomatonBase
    val sigma = automaton.LabelOps.sigmaLabel
    val states =
      automaton.initialState +: (for (_ <- 0 to len) yield automaton.newState())
    for (i <- 0 until len) {
      automaton.addTransition(states(i), sigma, states(i + 1), Seq())
    }
    automaton.setAccept(states(len), true)
    automaton
  }

  private def automatonWithLenLessThan(len: Int): CostEnrichedAutomatonBase = {
    if (len <= 0) return makeEmpty()
    val automaton = new CostEnrichedAutomatonBase
    val sigma = automaton.LabelOps.sigmaLabel
    val states =
      automaton.initialState +: (for (_ <- 0 to len) yield automaton.newState())
    for (i <- 0 until len - 1) {
      automaton.setAccept(states(i), true)
      automaton.addTransition(states(i), sigma, states(i + 1), Seq())
    }
    automaton.setAccept(states(len - 1), true)
    automaton
  }
}
