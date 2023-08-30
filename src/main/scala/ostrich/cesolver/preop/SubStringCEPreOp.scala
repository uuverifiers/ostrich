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

object SubStringCEPreOp {
  private var count = 0 // debug

  def apply(beginIdx: ITerm, length: ITerm) = {
    count = count + 1 // debug
    new SubStringCEPreOp(beginIdx, length, count - 1)
  }
  
  
}

/** Pre-operator for substring constraint.
  * @param beginIdx
  *   the begin index
  * @param length
  *   the max length of subtring
  */
class SubStringCEPreOp(beginIdx: ITerm, length: ITerm, debugId: Int) extends CEPreOp {
  private val termGen = TermGenerator()

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
        case  Const(value) => {
          automatonWithLenLessThan(value.intValueSafe)
        }
        case _ => {
          val searchedStrLen = termGen.lenTerm
          val preimage = LengthCEPreOp.lengthPreimage(searchedStrLen)
          preimage.regsRelation = and(Seq(
            preimage.regsRelation,
            searchedStrLen <= beginIdx
          ))
          preimage
        }
      }
      for (r <- res.registers) {
        // make sure all registers are 0
        preimageOfEmp1.regsRelation =
          and(Seq(preimageOfEmp1.regsRelation, r === 0))
        preimageOfEmp2.regsRelation =
          and(Seq(preimageOfEmp2.regsRelation, r === 0))
      }

      // transmit the result automaton's registers info
      preimageOfEmp1.regsRelation =
        and(Seq(preimageOfEmp1.regsRelation, res.regsRelation))
      preimageOfEmp2.regsRelation =
        and(Seq(preimageOfEmp2.regsRelation, res.regsRelation))

      preimagesOfEmptyStr =
        Iterator(Seq(preimageOfEmp1), Seq(preimageOfEmp2))
    }
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
        smallLenSuffix.regsRelation = and(Seq(
          smallLenSuffix.regsRelation,
          smallLen <= length
        ))
        smallLenSuffix
      }
    }
    val anyStrSuffix = BricsAutomatonWrapper.makeAnyString

    val midSubStr = concatenate(Seq(
      beginIdxPrefix,
      middleSubStr,
      anyStrSuffix
    ))

    val suffixSubStr = concatenate(
      Seq(beginIdxPrefix, smallLenSuffix)
    )

    preimages = Iterator(Seq(suffixSubStr), Seq(midSubStr))

    suffixSubStr.toDot("suffixSubStr " + debugId)
    midSubStr.toDot("midSubStr " + debugId)
    
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
