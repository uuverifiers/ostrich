package ostrich.cesolver.preop

import ostrich.automata.Automaton
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.CEBasicOperations
import ap.parser.IExpression
import ap.basetypes.IdealInt
import ap.parser.IIntLit
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.cesolver.util.ParikhUtil
import ostrich.automata.BricsTLabelOps

object SubStrPreImageUtil {
  // An Automaton that accepts all strings not containing c
  def noMatch(c: Char): CostEnrichedAutomatonBase = {
    val noCLabels = BricsTLabelOps.subtractLetter(c, (0.toChar, 65535.toChar))
    val ceAut = new CostEnrichedAutomatonBase
    ceAut.setAccept(ceAut.initialState, true)
    for (lbl <- noCLabels)
      ceAut.addTransition(ceAut.initialState, lbl, ceAut.initialState, Seq())
    ceAut
  }
}

// substring(s, 0, len(s) - 1)
class SubStr_0_lenMinus1 extends CEPreOp {
  override def toString = "SubStr_0_lenMinus1"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val preImage = CEBasicOperations.concatenate(
      Seq(
        res,
        LengthCEPreOp.lengthPreimage(1)
      )
    )
    if (res.isAccept(res.initialState))
      preImage.setAccept(preImage.initialState, true)

    (Iterator(Seq(preImage)), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(arguments(0).slice(0, arguments(0).length - 1))
  }
}

// substring(s, len(s) - 1, 1)
class SubStr_lenMinus1_1 extends CEPreOp {
  override def toString = "SubStr_lenMinus1_1"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val suffix = CEBasicOperations.intersection(
      res,
      PreOpUtil.automatonWithLenLessThan(2)
    )
    val preImage = CEBasicOperations.concatenate(
      Seq(
        BricsAutomatonWrapper.makeAnyString(),
        suffix
      )
    )
    (Iterator(Seq(preImage)), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(arguments(0).slice(arguments(0).length - 1, arguments(0).length))
  }
}

// substring(s, n, len(s) - m)
class SubStr_n_lenMinusM(beginIdx: Integer, offset: Integer) extends CEPreOp {
  override def toString = "SubStr_n_lenMinusM"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val nonEpsResPreImage = CEBasicOperations.concatenate(
      Seq(
        PreOpUtil.automatonWithLen(beginIdx),
        res,
        PreOpUtil.automatonWithLen(offset)
      )
    )
    val epsResPreImage = if (res.isAccept(res.initialState)) {
      val beginPlus1 = beginIdx.intValue + 1
      val offsetPlus1 = offset.intValue + 1
      val epsResPreImage =
        PreOpUtil.automatonWithLenLessThan(beginPlus1.min(offsetPlus1))
      for (r <- res.registers) {
        epsResPreImage.regsRelation &= (r === 0)
      }
      epsResPreImage
    } else {
      BricsAutomatonWrapper.makeEmpty()
    }

    val preImage =
      CEBasicOperations.union(Seq(nonEpsResPreImage, epsResPreImage))

    (
      Iterator(Seq(preImage)),
      Seq()
    )
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    Some(
      arguments(0)
        .slice(
          beginIdx.intValue,
          arguments(0).length - offset.intValue + beginIdx.intValue
        )
    )
  }
}

// substring(s, 0, indexof_c(s, 0))
class SubStr_0_indexofc0(c: Char) extends CEPreOp {
  override def toString = "SubStr_0_indexofc0"

  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val cAut = BricsAutomatonWrapper.fromString(c.toString)
    val resInterNoC =
      CEBasicOperations.intersection(res, SubStrPreImageUtil.noMatch(c))
    val nonEpsResPreImage = CEBasicOperations.concatenate(
      Seq(resInterNoC, cAut, BricsAutomatonWrapper.makeAnyString())
    )
    val epsResPreImage = SubStrPreImageUtil.noMatch(c)
    for (r <- res.registers) {
      epsResPreImage.regsRelation &= (r === 0)
    }
    val preImages =
      if (res.isAccept(res.initialState)) Seq(nonEpsResPreImage, epsResPreImage)
      else Seq(nonEpsResPreImage)
    (Iterator(preImages), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val s = arguments(0)
    val index = s.indexOf(c)
    Some(s.slice(0, index))
  }
}

// substring(s, 0, indexof_c(s, 0) + 1)
class SubStr_0_indexofc0Plus1(c: Char) extends CEPreOp {
  override def toString(): String = "SubStr_0_indexofc0Plus1"
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val cAut = BricsAutomatonWrapper.fromString(c.toString)
    val noMatchC = SubStrPreImageUtil.noMatch(c)
    val resInterNoCC = CEBasicOperations.intersection(
      res,
      CEBasicOperations.concatenate(Seq(noMatchC, cAut))
    )

    val nonEpsResPreImage = CEBasicOperations.concatenate(
      Seq(resInterNoCC, BricsAutomatonWrapper.makeAnyString())
    )
    val epsilonResPreImage = SubStrPreImageUtil.noMatch(c)
    for (r <- res.registers) {
      epsilonResPreImage.regsRelation &= (r === 0)
    }

    val preImages =
      if (res.isAccept(res.initialState))
        Seq(nonEpsResPreImage, epsilonResPreImage)
      else
        Seq(nonEpsResPreImage)

    (Iterator(preImages), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val s = arguments(0)
    val index = s.indexOf(c)
    Some(s.slice(0, index + 1))
  }
}

// substring(s, indexof_c(s, 0) + 1, len(s) - (indexof_c(s, 0) + 1))
class SubStr_indexofc0Plus1_tail(c: Char) extends CEPreOp {
  override def toString(): String = "SubStr_indexofc0Plus1_tail"
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val cAut = BricsAutomatonWrapper.fromString(c.toString)
    val noMatchC = SubStrPreImageUtil.noMatch(c)
    val prefix = CEBasicOperations.concatenate(
      Seq(noMatchC, cAut)
    )

    val nonEpsResPreImage = CEBasicOperations.concatenate(Seq(prefix, res))
    val epsResPreImage = BricsAutomatonWrapper.makeEmptyString()
    for (r <- res.registers) {
      epsResPreImage.regsRelation &= (r === 0)
    }

    val preImages =
      if (res.isAccept(res.initialState))
        Seq(nonEpsResPreImage, epsResPreImage)
      else
        Seq(nonEpsResPreImage)
    (Iterator(preImages), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val s = arguments(0)
    val index = s.indexOf(c)
    Some(s.slice(index + 1, s.length))
  }
}
