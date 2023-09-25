package ostrich.cesolver.preop

import ostrich.automata.Automaton
import ostrich.cesolver.automata.CostEnrichedAutomaton
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import PreOpUtil.{automatonWithLen, automatonWithLenLessThan}
import ostrich.cesolver.automata.CEBasicOperations.{intersection, concatenate}
import ostrich.automata.BricsAutomaton
import ap.parser.ITerm
import ap.parser.IExpression._
import ostrich.cesolver.util.TermGenerator
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IBoolLit

object SubStringCEPreOp {
  private var debugId = 0

  def apply(beginIdx: ITerm, length: ITerm) = {
    new SubStringCEPreOp(beginIdx, length)
  }
}

/** Pre-operator for substring constraint.
  * @param beginIdx
  *   the begin index
  * @param length
  *   the max length of subtring
  */
class SubStringCEPreOp(beginIdx: ITerm, length: ITerm) extends CEPreOp {
  private val termGen = TermGenerator()
  ParikhUtil.debugPrintln("substring op index + length is : " + (beginIdx + length))

  override def toString(): String =
    "subStringCEPreOp"

  private def emptyResultPreImage(
      res: CostEnrichedAutomatonBase
  ): Iterator[Seq[Automaton]] = {
    val emptyPreImage1 = BricsAutomatonWrapper.makeAnyString
    // length <= 0
    emptyPreImage1.regsRelation = and(
      Seq(
        emptyPreImage1.regsRelation,
        length <= 0
      )
    )
    // length > 0
    val emptyPreImage2 = beginIdx match {
      case Const(value) => {
        if (value.intValueSafe >= 0)
          automatonWithLenLessThan(value.intValueSafe + 1)
        else
          BricsAutomatonWrapper.makeAnyString()
      }
      case _ => {
        val argStrLen = termGen.lenTerm
        val preimage = LengthCEPreOp.lengthPreimage(argStrLen)
        preimage.regsRelation = and(
          Seq(
            preimage.regsRelation,
            argStrLen <= beginIdx | beginIdx < 0
          )
        )
        preimage
      }
    }
    // make sure all registers are 0
    val zeroRegsitersFormula =
      res.registers.map(_ === 0).reduceOption(_ & _).getOrElse(IBoolLit(true))
    // transmit the result automaton's registers info
    emptyPreImage1.regsRelation = and(
      Seq(emptyPreImage1.regsRelation, res.regsRelation, zeroRegsitersFormula)
    )
    emptyPreImage2.regsRelation = and(
      Seq(emptyPreImage2.regsRelation, res.regsRelation, zeroRegsitersFormula)
    )
    length match {
      case Const(value) => {
        if (value.intValueSafe <= 0) {
          Iterator(Seq(emptyPreImage1))
        } else {
          Iterator()
        }
      }
      case _: ITerm => Iterator(Seq(emptyPreImage1), Seq(emptyPreImage2))
    }
  }

  private def nonEmptyResultPreImage(
      res: CostEnrichedAutomatonBase
  ): Iterator[Seq[Automaton]] = {
    val beginIdxPrefix = beginIdx match {
      case Const(value) => {
        automatonWithLen(value.intValueSafe)
      }
      case _ => {
        LengthCEPreOp.lengthPreimage(beginIdx)
      }
    }
    val middleSubStr = length match {
      case Const(value) => {
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
      case Const(value) => {
        intersection(
          automatonWithLenLessThan(value.intValueSafe),
          res
        )
      }
      case _ => {
        val smallLen = termGen.lenTerm
        val smallLenSuffix = intersection(
          LengthCEPreOp.lengthPreimage(smallLen),
          res
        )
        smallLenSuffix.regsRelation = and(
          Seq(
            smallLenSuffix.regsRelation,
            smallLen <= length
          )
        )
        smallLenSuffix
      }
    }
    val SubstrInMidPreImage = concatenate(
      Seq(
        beginIdxPrefix,
        middleSubStr,
        BricsAutomatonWrapper.makeAnyString()
      )
    )
    val SubstrInSuffixPreImage = concatenate(
      Seq(beginIdxPrefix, smallLenSuffix)
    )
    // debug
    import SubStringCEPreOp.debugId
    SubstrInSuffixPreImage.toDot("suffixSubStr " + debugId)
    SubstrInMidPreImage.toDot("midSubStr " + debugId)
    debugId += 1
    Iterator(Seq(SubstrInMidPreImage), Seq(SubstrInSuffixPreImage))
  }

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    var preimagesOfEmptyStr = Iterator[Seq[Automaton]]()
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    // empty string result
    if (res.isAccept(res.initialState)) {
      preimagesOfEmptyStr = emptyResultPreImage(res)
    }
    val preimages = nonEmptyResultPreImage(res)
    (preimages ++ preimagesOfEmptyStr, Seq())
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
