/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich.proofops

import ostrich._

import ap.basetypes.IdealInt
import ap.parameters.Param
import ap.proof.ModelSearchProver
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.terfor.{ConstantTerm, VariableTerm, Formula, Term, TerForConvenience}
import ap.terfor.conjunctions.{Conjunction, ReduceWithConjunction}
import ap.terfor.preds.Atom
import ap.terfor.linearcombination.LinearCombination

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap}

object OstrichNielsenSplitter {

  abstract class DecompPoint(
    val atom    : Atom,
    val leftLen : LinearCombination
  )

  case class SimpleDecompPoint(
    _atom   : Atom,               // Atom containing the terms
    left    : Seq[Term],          // left terms, in reverse order
    _leftLen : LinearCombination, // cumulative length of the left terms
    right   : Seq[Term]           // right terms
  ) extends DecompPoint(_atom, _leftLen)

  case class InsideLitDecompPoint(
    _atom        : Atom,               // Atom containing the terms
    left         : Seq[Term],          // left terms, in reverse order
    _leftLen      : LinearCombination, // cumulative length of the left terms
    right        : Seq[Term],          // right terms
    stringLit    : Int,                // if of the split string literal
    stringLitPos : Int                 // position at which the string literal
                                       // is split
  ) extends DecompPoint(_atom, _leftLen)

}

////////////////////////////////////////////////////////////////////////////////

class OstrichNielsenSplitter(goal : Goal,
                             theory : OstrichStringTheory,
                             flags : OFlags) {
  import theory.{_str_++, _str_len, strDatabase, StringSort}
  import OFlags.debug
  import OstrichNielsenSplitter._

  val order        = goal.order
  val X            = new ConstantTerm("X")
  val extOrder     = order extend X

  val rand         = Param.RANDOM_DATA_SOURCE(goal.settings)

  val facts        = goal.facts
  val predConj     = facts.predConj
  val concatLits   = predConj.positiveLitsWithPred(_str_++)
  val concatPerRes = concatLits groupBy (_(2))
  val lengthLits   = predConj.positiveLitsWithPred(_str_len)
  val lengthMap    = (for (a <- lengthLits.iterator) yield (a(0), a(1))).toMap

  def resolveConcat(t : LinearCombination)
                  : Option[(LinearCombination, LinearCombination)] =
    for (lits <- concatPerRes get t) yield (lits.head(0), lits.head(1))

  def lengthFor(t : LinearCombination) : LinearCombination =
    if (strDatabase isConcrete t)
      LinearCombination((strDatabase term2ListGet t).size)
    else
      lengthMap(t)

  def eval(t           : LinearCombination,
           lengthModel : ReduceWithConjunction) : Int = {
    import TerForConvenience._
    implicit val o = extOrder

    val f = lengthModel(t === X)
    assert(f.size == 1 && f.constants == Set(X))
    (-f.head.constant).intValueSafe
  }

  def evalLengthFor(t : LinearCombination,
                    lengthModel : ReduceWithConjunction) : Int =
    eval(lengthFor(t), lengthModel)

  type ChooseSplitResult =
    (Seq[LinearCombination], // left terms
     LinearCombination,      // length of concat of left terms
     LinearCombination,      // term to split
     Seq[LinearCombination]) // right terms

  def chooseSplit(splitLit1    : Atom,
                  splitLit2    : Atom,
                  lengthModel  : ReduceWithConjunction)
                               : ChooseSplitResult = {
    val splitLenConc = evalLengthFor(splitLit2(0), lengthModel)
    chooseSplit(splitLit1, splitLenConc, lengthModel,
                List(), List(), List())
  }

  def chooseSplit(t            : LinearCombination,
                  splitLen     : Int,
                  lengthModel  : ReduceWithConjunction,
                  leftTerms    : List[LinearCombination],
                  leftLenTerms : List[LinearCombination],
                  rightTerms   : List[LinearCombination])
                               : ChooseSplitResult =
    (concatPerRes get t) match {
      case Some(lits) =>
        chooseSplit(lits.head, splitLen, lengthModel,
                    leftTerms, leftLenTerms, rightTerms)
      case None =>
        ((leftTerms.reverse,
          LinearCombination.sum(
            for (t <- leftLenTerms) yield (IdealInt.ONE, t), order),
          t, rightTerms))
    }

  def chooseSplit(lit          : Atom,
                  splitLen     : Int,
                  lengthModel  : ReduceWithConjunction,
                  leftTerms    : List[LinearCombination],
                  leftLenTerms : List[LinearCombination],
                  rightTerms   : List[LinearCombination])
                               : ChooseSplitResult = {
    val left        = lit(0)
    val right       = lit(1)
    val leftLen     = lengthFor(left)
    val leftLenConc = eval(leftLen, lengthModel)

    if (splitLen <= leftLenConc)
      chooseSplit(left, splitLen, lengthModel,
                  leftTerms, leftLenTerms, right :: rightTerms)
    else
      chooseSplit(right, splitLen - leftLenConc, lengthModel,
                  left :: leftTerms, leftLen :: leftLenTerms, rightTerms)
  }

  def splittingFormula(split     : ChooseSplitResult,
                       splitLit2 : Atom)
                                 : Conjunction = {
    val builder = new FormulaBuilder(goal, theory)

    val (leftTerms, _, symToSplit, rightTerms) = split

    val leftSplitSym, rightSplitSym = builder.newVar(StringSort)

    builder.addConcat(leftSplitSym, rightSplitSym, symToSplit)

    builder.addConcatN(leftTerms ++ List(leftSplitSym),   splitLit2(0))
    builder.addConcatN(List(rightSplitSym) ++ rightTerms, splitLit2(1))

    builder.result
  }

  def diffLengthFormula(split : ChooseSplitResult,
                        splitLit2 : Atom) : Conjunction = {
    import TerForConvenience._
    implicit val o = order

    val (_, leftTermsLen, symToSplit, _) = split
    val splitLen = lengthFor(splitLit2(0))

    (splitLen < leftTermsLen) |
    (splitLen > leftTermsLen + lengthFor(symToSplit))
  }

  /**
   * Compute all prefix/suffix pairs for the given concat term.
   */
  def decompositionPoints(lit : Atom) : Seq[SimpleDecompPoint] = {
    implicit val o = order

    val points = new ArrayBuffer[SimpleDecompPoint]

    def genPoints(t          : LinearCombination,
                  leftTerms  : List[Term],
                  len        : LinearCombination,
                  rightTerms : List[Term],
                  leftMost   : Boolean) : Unit =
      if (strDatabase isConcrete t) {
        if (!leftMost)
          points += SimpleDecompPoint(lit, leftTerms, len, t :: rightTerms)
      } else {
        (concatPerRes get t) match {
          case Some(Seq(concatLit)) => {
            genPoints(concatLit(0),
                      leftTerms,
                      len,
                      concatLit(1) :: rightTerms,
                      leftMost)
            genPoints(concatLit(1),
                      concatLit(0) :: leftTerms,
                      len + lengthFor(concatLit(0)),
                      rightTerms,
                      false)
          }
          case _ =>
            if (!leftMost)
              points += SimpleDecompPoint(lit, leftTerms, len, t :: rightTerms)
        }
      }

    genPoints(lit(0), List(),       LinearCombination.ZERO, List(lit(1)), true)
    genPoints(lit(1), List(lit(0)), lengthFor(lit(0)),      List(),       false)

    points.toSeq
  }

  /**
   * Compute all prefix/suffix pairs for the given concat term; also
   * split string literals in the term into prefix/suffix pairs.
   */
  def decompositionPointsWithLits(lit : Atom) : Seq[DecompPoint] = {
    import LinearCombination.Constant

    val rawPoints = decompositionPoints(lit)

    def splitLits(decomp : DecompPoint) : Seq[DecompPoint] = decomp match {
      case SimpleDecompPoint(atom,
                             Seq(Constant(IdealInt(strId))),
                             leftLen,
                             right) => {
        val strLen =
          strDatabase.id2List(strId).size
        val newSplits =
          for (n <- 1 until strLen)
          yield InsideLitDecompPoint(atom, List(),
                                     LinearCombination(n), right, strId, n)
        newSplits ++ List(decomp)
      }
      case SimpleDecompPoint(atom,
                             left,
                             leftLen,
                             Seq(Constant(IdealInt(strId)), right @ _*)) => {
        val strLen =
          strDatabase.id2List(strId).size
        val newSplits =
          for (n <- 1 until strLen)
          yield InsideLitDecompPoint(atom, left, leftLen + n, right, strId, n)
        List(decomp) ++ newSplits
      }
      case decomp =>
        List(decomp)
    }

    for (decomp    <- rawPoints;
         newDecomp <- splitLits(decomp))
    yield newDecomp
  }

  def concatLeft(decomp : DecompPoint)
                (implicit builder : FormulaBuilder) : Term = decomp match {
    case decomp : SimpleDecompPoint =>
      builder.concat(decomp.left.reverse)
    case decomp : InsideLitDecompPoint => {
      import decomp.{left, stringLit, stringLitPos}
      val strId =
        strDatabase.list2Id(strDatabase.id2List(stringLit).take(stringLitPos))
      builder.concat((List(LinearCombination(strId)) ++ left).reverse)
    }
  }

  def concatRight(decomp : DecompPoint)
                 (implicit builder : FormulaBuilder) : Term = decomp match {
    case decomp : SimpleDecompPoint =>
      builder.concat(decomp.right)
    case decomp : InsideLitDecompPoint => {
      import decomp.{right, stringLit, stringLitPos}
      val strId =
        strDatabase.list2Id(strDatabase.id2List(stringLit).drop(stringLitPos))
      builder.concat(List(LinearCombination(strId)) ++ right)
    }
  }

  /**
   * Decompose equations of the form a.b = c.d if it can be derived
   * that |a| = |c|.
   */
  def decompEquations : Seq[Plugin.Action] = {
    if (lengthLits.isEmpty)
      return List()

    val multiGroups =
      concatPerRes filter {
        case (res, lits) => lits.size >= 2 && !(strDatabase isConcrete res)
      }

    val decompActions =
      (for ((res, lits) <- multiGroups;
            act <- decompEquation(res, lits))
       yield act).toSeq

    decompActions
  }

  def decompEquation(resultTerm     : Term,
                     concatLiterals : Seq[Atom]) : Seq[Plugin.Action] = {
    implicit val o = order
    import TerForConvenience._

    val splitPoints = new MHashMap[Term, DecompPoint]

    val actions = new ArrayBuffer[Plugin.Action]

    for (lit <- concatLiterals) {
      val decomps = decompositionPointsWithLits(lit)

      var stop = false

      for (decomp <- decomps; if !stop) {
        import decomp.leftLen
        (splitPoints get leftLen) match {
          case Some(otherDecomp) => {
            val otherDecomp = splitPoints(leftLen)
            stop = true

            Console.err.println("Decomposing equation:")
            Console.err.println("  " +
                                  term2String(otherDecomp.atom(0)) + " . " +
                                  term2String(otherDecomp.atom(1)) + " == " +
                                  term2String(decomp.atom(0)) + " . " +
                                  term2String(decomp.atom(1)))

            actions += Plugin.RemoveFacts(conj(lit))

            implicit val builder = new FormulaBuilder(goal, theory)

            val newLeft    = concatLeft (decomp)
            val newRight   = concatRight(decomp)
            val otherLeft  = concatLeft (otherDecomp)
            val otherRight = concatRight(otherDecomp)

            builder addConjunct (newLeft  === otherLeft)
            builder addConjunct (newRight === otherRight)

            actions +=
              Plugin.AddAxiom(concatLits ++ lengthLits, // TODO: make specific
                              builder.result,
                              theory)
          }
          case None => {
            splitPoints.put(decomp.leftLen, decomp)
          }
        }
      }
    }

    actions.toSeq
  }

  /**
   * Decompose equations of the form a.b = w, in which w is some
   * concrete word.
   */
  def decompSimpleEquations : Seq[Plugin.Action] = {
    if (lengthLits.isEmpty)
      return List()

    for (lit <- concatLits;
         if strDatabase isConcrete lit.last;
         act <- decompSimpleEquation(lit))
    yield act
  }

  /**
   * Decompose one equation of the form a.b = w, in which w is some
   * concrete word.
   */
  def decompSimpleEquation(lit : Atom) : Seq[Plugin.Action] = {
    import LinearCombination.Constant
    import TerForConvenience._

    val decomps = decompositionPoints(lit)

    val constLenPoints =
      for (SimpleDecompPoint(_, left, Constant(IdealInt(len)), right) <-
           decomps.iterator)
      yield (left, len, right)

    if (constLenPoints.hasNext) {
      val (left, len, right) = constLenPoints.next

      val result       = strDatabase term2ListGet lit.last
      val resultPrefix = strDatabase.list2Id(result take len)
      val resultSuffix = strDatabase.list2Id(result drop len)

      val builder = new FormulaBuilder(goal, theory)

      builder.addConcatN(left.reverse, l(resultPrefix))
      builder.addConcatN(right,        l(resultSuffix))

      List(Plugin.RemoveFacts(lit),
           Plugin.AddAxiom(concatLits ++ lengthLits, // TODO: make specific
                           builder.result,
                           theory))
    } else {
      /*
      for ((_, t :: left, len, right) <- decomps)
        if (strDatabase isConcrete t) {
          println
          println("Concrete: " + decomps)
          println
        }

      for ((_, left, len, Seq(t)) <- decomps)
        if (strDatabase isConcrete t) {
          println
          println("Concrete: " + decomps)
          println
        }
       */

      List()
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  /**
   * Apply the Nielsen transformation to some selected equation.
   */
  def splitEquation : Seq[Plugin.Action] = {
    if (!flags.nielsenSplitter){
      return List()
    }
    val multiGroups =
      concatPerRes filter {
        case (res, lits) => lits.size >= 2 && !(strDatabase isConcrete res)
      }

    val splittableTerms =
      concatLits.iterator.map(_(2)).filter(multiGroups.keySet).toList.distinct

    if (splittableTerms.isEmpty)
      return List()

    val termToSplit = splittableTerms(rand nextInt splittableTerms.size)
    val literals    = multiGroups(termToSplit)

    val splitLit1   = literals(rand nextInt literals.size)
    val splitLit2   = (literals filterNot (_ == splitLit1))(
                        rand nextInt (literals.size - 1))

    if (lengthLits.isEmpty)
      throw new Exception("Nielsen transformation is currently only enabled" +
                            " in combination with option -length=on.")

    splitEquationWithLen(splitLit1, splitLit2, multiGroups.size)
  }

  //////////////////////////////////////////////////////////////////////////////

  /**
   * TODO: this needs more work, currently not used!
   */
  private def splitEquationNoLen(splitLit1 : Atom, splitLit2 : Atom,
                                 multiGroupNum : Int)
                                                 : Seq[Plugin.Action] = {

    import TerForConvenience._
    implicit val o = order

    val split1 = (List(),
                  null,
                  splitLit1(0), List(splitLit1(1)))
    val split2 = (List(splitLit1(0)),
                  null,
                  splitLit1(1), List())

    Console.err.println(
      "Applying Nielsen transformation (# word equations: " + multiGroupNum +
        ")")
    Console.err.println("  " +
                          term2String(splitLit1(0)) + " . " +
                          term2String(splitLit1(1)) + " == " +
                          term2String(splitLit2(0)) + " . " +
                          term2String(splitLit2(1)))

    val nil = strDatabase.str2Id("")

    val zeroCases =
      List(
        (conj(splitLit2(0) === nil), List()),
        (conj(splitLit2(0) =/= nil, splitLit2(1) === nil), List())
      )

    val splitCases =
      for (split <- List(split1, split2)) yield {
        (splittingFormula(split, splitLit2) &
           splitLit2(0) =/= nil & splitLit2(1) =/= nil,
         List(Plugin.RemoveFacts(Conjunction.conj(splitLit2, order))))
      }

    List(
      Plugin.AxiomSplit(concatLits,
                        zeroCases ++
                          (if (rand.nextBoolean) splitCases else splitCases.reverse),
                        theory))
  }

  //////////////////////////////////////////////////////////////////////////////

  private def splitEquationWithLen(splitLit1 : Atom, splitLit2 : Atom,
                                   multiGroupNum : Int)
                                                  : Seq[Plugin.Action] = {
    val lengthModel =
      ModelSearchProver(Conjunction.negate(facts.arithConj, order), order)

    if (lengthModel.isFalse)
      return List(Plugin.AddAxiom(List(facts.arithConj), Conjunction.FALSE, theory))

    val lengthRed =
      ReduceWithConjunction(lengthModel, extOrder)

/*
    for (t <- 
    (for (lit <- concatLits.iterator;
          t <- lit.iterator;
          if !t.isConstant)
     yield t).toSet[LinearCombination].toList.sortBy(_.toString)) {
      Console.err.println("  |" + t + "| = " + evalLengthFor(t, lengthRed))
    }
*/
    val zeroSyms = for (t <- (splitLit2 take 2).iterator;
                        if evalLengthFor(t, lengthRed) == 0)
                   yield t

    if (zeroSyms.hasNext) {
      val zeroSym = zeroSyms.next
      Console.err.println("Assuming " + zeroSym + " = \"\"")

      import TerForConvenience._
      implicit val o = order
      List(
        Plugin.AxiomSplit(List(),
                          List((zeroSym === strDatabase.str2Id(""), List()),
                               (lengthFor(zeroSym) > 0,             List())),
                          theory)
      )
    } else {
      val split    = chooseSplit(splitLit1, splitLit2, lengthRed)
      val splitSym = split._3

      Console.err.println(
        "Applying Nielsen transformation (# word equations: " + multiGroupNum +
          "), splitting " + term2String(splitSym))
      Console.err.println("  " +
                            term2String(splitLit1(0)) + " . " +
                            term2String(splitLit1(1)) + " == " +
                            term2String(splitLit2(0)) + " . " +
                            term2String(splitLit2(1)))

      val f1 = splittingFormula(split, splitLit2)
      val f2 = diffLengthFormula(split, splitLit2)

      List(
        Plugin.AxiomSplit(concatLits ++ lengthLits, // TODO: make specific
                          List((f1,
                                List(Plugin.RemoveFacts(
                                       Conjunction.conj(splitLit2, order)))),
                               (f2, List())),
                          theory)
      )
    }
  }

  private def term2String(t : Term) =
    (strDatabase term2Str t) match {
      case Some(str) => "\"" + str + "\""
      case None => t.toString
    }

}
