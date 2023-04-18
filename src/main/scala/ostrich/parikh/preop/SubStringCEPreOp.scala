package ostrich.parikh.preop

import ap.terfor.Term
import ostrich.automata.Automaton
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.automata.BricsAutomatonWrapper
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ostrich.parikh.RegisterTerm
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._
import PreOpUtil.{automatonWithLen, automatonWithLenLessThan}
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.automata.CEBasicOperations.{intersection, concatenate}
import ostrich.parikh.LenTerm
import ostrich.automata.BricsAutomaton

object SubStringCEPreOp {
  def apply(beginIdx: Term, length: Term) =
    new SubStringCEPreOp(beginIdx, length)
}

/** Pre-operator for substring constraint.
  * @param beginIdx
  *   the begin index
  * @param length
  *   the max length of subtring
  */
class SubStringCEPreOp(beginIdx: Term, length: Term) extends CEPreOp {
  override def toString(): String =
    "subStringCEPreOp"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimages = Iterator[Seq[Automaton]]()
    var preimagesOfEmptyStr = Iterator[Seq[Automaton]]()
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    beginIdx match {
      case LinearCombination.Constant(value) => {
        if (res.isAccept(res.initialState)) {
          val preimageOfEmp1 = BricsAutomatonWrapper.makeAnyString
          preimageOfEmp1.regsRelation = conj(
            preimageOfEmp1.regsRelation,
            length <= 0
          )
          val preimageOfEmp2 = automatonWithLenLessThan(value.intValueSafe)
          for (r <- res.registers) {
            // tansmit the empty string integer info
            preimageOfEmp1.regsRelation =
              conj(preimageOfEmp1.regsRelation, r === 0)
            preimageOfEmp2.regsRelation =
              conj(preimageOfEmp2.regsRelation, r === 0)
          }
          preimagesOfEmptyStr =
            Iterator(Seq(preimageOfEmp1), Seq(preimageOfEmp2))
        }
        preimages = preimagesOfConstBeginIdx(
          value.intValueSafe,
          length,
          res
        )
      }
      case _ => {
        if (res.isAccept(res.initialState)) {
          val preimageOfEmp1 = BricsAutomatonWrapper.makeAnyString
          preimageOfEmp1.regsRelation = conj(
            preimageOfEmp1.regsRelation,
            length <= 0
          )
          val searchedStrLen = LenTerm()
          val preimageOfEmp2 = LengthCEPreOp.lengthPreimage(searchedStrLen)
          preimageOfEmp2.regsRelation = conj(
            preimageOfEmp2.regsRelation,
            searchedStrLen <= beginIdx
          )
          for (r <- res.registers) {
            // tansmit the empty string integer info
            preimageOfEmp1.regsRelation =
              conj(preimageOfEmp1.regsRelation, r === 0)
            preimageOfEmp2.regsRelation =
              conj(preimageOfEmp2.regsRelation, r === 0)
          }
          preimagesOfEmptyStr =
            Iterator(Seq(preimageOfEmp1), Seq(preimageOfEmp2))
        }

        preimages = preimagesOfVarBeginIdx(beginIdx, length, res)
      }
    }
    (preimagesOfEmptyStr ++ preimages, Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val beginIdx = arguments(1)(0)
    val length = arguments(2)(0)
    val bigString = arguments(0)
    if (beginIdx < 0 || length < 0) {
      Some(Seq()) // empty string
    } else {
      Some(bigString.slice(beginIdx, beginIdx + length))
    }
  }

  private def preimagesOfConstBeginIdx(
      beginIdx: Int,
      length: Term,
      resultConstraint: CostEnrichedAutomatonBase
  ): Iterator[Seq[Automaton]] = {
    var preimages = Iterator[Seq[CostEnrichedAutomatonBase]]()
    val beginIdxPrefix = automatonWithLen(beginIdx)
    length match {
      case LinearCombination.Constant(value) => {
        preimages = preimagesOfConstLen(
          beginIdxPrefix,
          value.intValueSafe,
          resultConstraint
        )
      }
      case _ => {
        preimages = preimagesOfVarLen(beginIdxPrefix, length, resultConstraint)
      }
    }
    preimages
  }

  private def preimagesOfVarBeginIdx(
      beginIdx: Term,
      length: Term,
      resultConstraint: Automaton
  ): Iterator[Seq[Automaton]] = {
    var preimages = Iterator[Seq[CostEnrichedAutomatonBase]]()
    val beginIdxPrefix = LengthCEPreOp.lengthPreimage(beginIdx)
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    length match {
      case LinearCombination.Constant(value) => {
        preimages = preimagesOfConstLen(beginIdxPrefix, value.intValueSafe, res)
      }
      case _ => {
        preimages = preimagesOfVarLen(beginIdxPrefix, length, res)
      }
    }
    preimages
  }

  def preimagesOfConstLen(
      beginIdxPrefix: CostEnrichedAutomatonBase,
      length: Int,
      resultConstraint: CostEnrichedAutomatonBase
  ): Iterator[Seq[CostEnrichedAutomatonBase]] = {
    var preimages = Iterator[Seq[CostEnrichedAutomatonBase]]()
    val anyStringSuffix = BricsAutomatonWrapper.makeAnyString
    val middleSubStr = intersection(
      automatonWithLen(length),
      resultConstraint
    )
    val preimage1 = concatenate(
      Seq(beginIdxPrefix, middleSubStr, anyStringSuffix)
    )
    val smallLenSuffix = intersection(
      automatonWithLenLessThan(length),
      resultConstraint
    )
    val preimage2 = concatenate(Seq(beginIdxPrefix, smallLenSuffix))

    preimages = Iterator(
      Seq(preimage1),
      Seq(preimage2)
    )
    preimages
  }

  def preimagesOfVarLen(
      beginIdxPrefix: CostEnrichedAutomatonBase,
      length: Term,
      resultConstraint: CostEnrichedAutomatonBase
  ): Iterator[Seq[CostEnrichedAutomatonBase]] = {
    var preimages = Iterator[Seq[CostEnrichedAutomatonBase]]()
    val anyStringSuffix = BricsAutomatonWrapper.makeAnyString
    val middleSubStr = intersection(
      LengthCEPreOp.lengthPreimage(length),
      resultConstraint
    )
    val preimage1 = concatenate(
      Seq(beginIdxPrefix, middleSubStr, anyStringSuffix)
    )
    val smallLen = LenTerm()
    val smallLenSuffix = intersection(
      LengthCEPreOp.lengthPreimage(smallLen),
      resultConstraint
    )
    smallLenSuffix.regsRelation = conj(
      smallLenSuffix.regsRelation,
      smallLen < length
    )
    val preimage2 = concatenate(Seq(beginIdxPrefix, smallLenSuffix))
    preimages = Iterator(
      Seq(preimage1),
      Seq(preimage2)
    )
    preimages
  }
}
