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
import ostrich.cesolver.automata.CEBasicOperations

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
  ParikhUtil.debugPrintln(
    "substring op index + length is : " + (beginIdx + length)
  )

  override def toString(): String =
    "subStringCEPreOp"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {

    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val resLen = termGen.lenTerm
    val resWithLen = intersection(res, LengthCEPreOp.lengthPreimage(resLen, false))
    val prefixLen = termGen.lenTerm
    val prefix = LengthCEPreOp.lengthPreimage(prefixLen, false)
    val suffixLen = termGen.lenTerm
    val suffix = LengthCEPreOp.lengthPreimage(suffixLen, false)
    val preimage = concatenate(Seq(prefix, resWithLen, suffix))
    val argLen = prefixLen + resLen + suffixLen
    val epsilonResFormula =
      (length <= 0 | beginIdx < 0 | beginIdx > argLen - 1) & resLen === 0
    val nonEpsilonResFormula =
      ((resLen <= length & suffixLen === 0) | (resLen === length & suffixLen > 0)) & beginIdx === prefixLen
    preimage.regsRelation = and(
      Seq(preimage.regsRelation, (epsilonResFormula | nonEpsilonResFormula))
    )
    preimage.toDot("substring" + SubStringCEPreOp.debugId)
    (Iterator(Seq(preimage)), Seq())
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
