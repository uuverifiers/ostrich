package ostrich.parikh.preop

import ostrich.automata.Automaton
import ostrich.parikh.automata.CostEnrichedAutomaton
import ostrich.parikh.automata.BricsAutomatonWrapper
import ostrich.parikh.automata.CostEnrichedAutomatonBase
import ostrich.parikh.RegisterTerm
import ostrich.parikh.TermGeneratorOrder._
import PreOpUtil.{automatonWithLen, automatonWithLenLessThan}
import ostrich.parikh.automata.CEBasicOperations.{intersection, concatenate}
import ostrich.parikh.LenTerm
import ostrich.automata.BricsAutomaton
import ap.parser.ITerm
import ap.parser.IExpression._
import ap.parser.IIntLit

object SubStringCEPreOp {
  def apply(beginIdx: ITerm, length: ITerm) =
    new SubStringCEPreOp(beginIdx, length)
}

/** Pre-operator for substring constraint.
  * @param beginIdx
  *   the begin index
  * @param length
  *   the max length of subtring
  */
class SubStringCEPreOp(beginIdx: ITerm, length: ITerm) extends CEPreOp {
  override def toString(): String =
    "subStringCEPreOp"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimages = Iterator[Seq[Automaton]]()
    var preimagesOfEmptyStr = Iterator[Seq[Automaton]]()
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    if (res.isAccept(res.initialState)) {
      // empty string result
      val preimageOfEmp1 = BricsAutomatonWrapper.makeAnyString
      preimageOfEmp1.regsRelation = and(Seq(
        preimageOfEmp1.regsRelation,
        length <= 0
      ))
      val preimageOfEmp2 = beginIdx match {
        case  IIntLit(value) => {
          automatonWithLenLessThan(value.intValueSafe)
        }
        case _ => {
          val searchedStrLen = LenTerm()
          val preimage = LengthCEPreOp.lengthPreimage(searchedStrLen)
          preimage.regsRelation = and(Seq(
            preimage.regsRelation,
            searchedStrLen <= beginIdx
          ))
          preimage
        }
      }
      for (r <- res.registers) {
        // tansmit the empty string integer info
        preimageOfEmp1.regsRelation =
          and(Seq(preimageOfEmp1.regsRelation, r === 0))
        preimageOfEmp2.regsRelation =
          and(Seq(preimageOfEmp2.regsRelation, r === 0))
      }
      preimagesOfEmptyStr =
        Iterator(Seq(preimageOfEmp1), Seq(preimageOfEmp2))
    }
    val beginIdxPrefix = beginIdx match {
      case IIntLit(value) => {
        automatonWithLen(value.intValueSafe)
      }
      case _ => {
        LengthCEPreOp.lengthPreimage(beginIdx)
      }
    }

    val middleSubStr = length match {
      case IIntLit(value) => {
        intersection(
          automatonWithLen(value.intValueSafe),
          res
        )
      }
      case _ => {
        intersection(
          LengthCEPreOp.lengthPreimage(length),
          res
        )
      }
    }

    val smallLenSuffix = length match {
      case IIntLit(value) => {
        intersection(
          automatonWithLenLessThan(value.intValueSafe),
          res
        )
      }
      case _ => {
        val smallLen = LenTerm()
        val smallLenSuffix = intersection(
          LengthCEPreOp.lengthPreimage(smallLen),
          res
        )
        smallLenSuffix.regsRelation = and(Seq(
          smallLenSuffix.regsRelation,
          smallLen <= length
        ))
        smallLenSuffix
      }
    }
    val anyStrSuffix = BricsAutomatonWrapper.makeAnyString

    val preimage1 = concatenate(Seq(
      beginIdxPrefix,
      middleSubStr,
      anyStrSuffix
    ))

    val preimage2 = concatenate(
      Seq(beginIdxPrefix, smallLenSuffix)
    )

    preimages = Iterator(Seq(preimage1), Seq(preimage2))

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

}
