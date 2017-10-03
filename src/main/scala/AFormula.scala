/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package strsolver

import scala.collection.GenTraversableOnce

// Symbolic representation of AFA symbol
abstract class AFormula {
  import AFormula.widthOfChar

  override def toString: String = this match {
    case AFAnd(sub1: AFOr, sub2: AFOr) => "(" + sub1 + ") \u2227 (" + sub2 + ")"
    case AFAnd(sub1: AFOr, sub2) => "(" + sub1 + ") \u2227 (" + sub2 + ")"
    case AFAnd(sub1: AFAnd, sub2: AFOr) => sub1 + " \u2227 (" + sub2 + ")"
    case AFAnd(sub1, sub2: AFOr) => "(" + sub1 + ") \u2227 (" + sub2 + ")"
    case AFAnd(sub1, sub2) => sub1 + " \u2227 " + sub2
    case AFOr(sub1: AFOr, sub2: AFAnd) => sub1 + " \u2228 (" + sub2 + ")"
    case AFOr(sub1: AFAnd, sub2: AFOr) => "(" + sub1 + ") \u2228 " + sub2
    case AFOr(sub1: AFAnd, sub2: AFAnd) => "(" + sub1 + ") \u2228 (" + sub2 + ")"
    case AFOr(sub1, sub2) => sub1 + " \u2228 " + sub2
    case AFLet(sub1, sub2 : AFLet) => "[" + sub1 + "] " + sub2
    case AFLet(sub1, sub2) => "[" + sub1 + "] (" + sub2 + ")"
    case AFNot(sub: AFAnd) => "\u00AC(" + sub + ")"
    case AFNot(sub: AFOr) => "\u00AC(" + sub + ")"
    case AFNot(sub) => "\u00AC" + sub
    case AFStateVar(v) => "s_" + v
    case AFCharVar(v) => "a_" + v
    case AFSpecSymb(s) => "e_" + s
    case AFParam(p) => "p_" + p
    case AFDeBrujinVar(ind) => "_" + ind
    case AFFalse => "False"
    case AFTrue  => "True"
  }

  def unary_~ : AFormula = this match {
    case AFTrue => AFFalse
    case AFFalse => AFTrue
    case AFNot(f) => f
    case _ => AFNot(this)
  }

  def &(sub: AFormula): AFormula = {
    if(this == AFFalse || sub == AFFalse || this == ~sub)
      return AFFalse

    if(this == AFTrue)
      return sub

    if(sub == AFTrue || this == sub)
      return this

    AFAnd(this, sub)
  }

  def |(sub: AFormula): AFormula = {
    if(this == AFTrue || sub == AFTrue || this == ~sub)
      return AFTrue

    if(this == AFFalse)
      return sub

    if(sub == AFFalse || this == sub)
      return this

    AFOr(this, sub)
  }

  def ==>(sub: AFormula): AFormula =
    ~this | sub

  def <=>(sub: AFormula): AFormula =
    (this & sub) | (~this & ~sub)

  def ^(sub: AFormula): AFormula =
    (this | sub) & (~this | ~sub)

  def letIn(that : AFormula) : AFormula = {
    if (that == AFTrue || that == AFFalse)
      that
    else
      AFLet(this, that)
  }

  def maxCharIndex : Int = this match {
    case AFAnd(s1, s2) => s1.maxCharIndex max s2.maxCharIndex
    case AFOr(s1, s2)  => s1.maxCharIndex max s2.maxCharIndex
    case AFLet(s1, s2) => s1.maxCharIndex max s2.maxCharIndex
    case AFNot(s)      => s.maxCharIndex
    case AFCharVar(v)  => v
    case _             => 0
  }

  def charClasses : Set[Int] = this match {
    case AFAnd(s1, s2) => s1.charClasses ++ s2.charClasses
    case AFOr(s1, s2)  => s1.charClasses ++ s2.charClasses
    case AFLet(s1, s2) => s1.charClasses ++ s2.charClasses
    case AFNot(s)      => s.charClasses
    case AFCharVar(v)  => Set(v / widthOfChar)
    case AFSpecSymb(v) => Set(v)
    case _             => Set()
  }

  def specSyms : Set[Int] = this match {
    case AFAnd(s1, s2)   => s1.specSyms ++ s2.specSyms
    case AFOr(s1, s2)    => s1.specSyms ++ s2.specSyms
    case AFLet(s1, s2)   => s1.specSyms ++ s2.specSyms
    case AFNot(s)        => s.specSyms
    case AFSpecSymb(ind) => Set(ind)
    case _               => Set()
  }

  def parameters : Set[Int] = this match {
    case AFAnd(s1, s2)   => s1.parameters ++ s2.parameters
    case AFOr(s1, s2)    => s1.parameters ++ s2.parameters
    case AFLet(s1, s2)   => s1.parameters ++ s2.parameters
    case AFNot(s)        => s.parameters
    case AFParam(p)      => Set(p)
    case _               => Set()
  }

  private def getStates(f: AFormula): Set[Int] = f match {
    case AFAnd(sub1, sub2) => getStates(sub1) ++ getStates(sub2)
    case AFOr(sub1, sub2) => getStates(sub1) ++ getStates(sub2)
    case AFLet(sub1, sub2) => getStates(sub1) ++ getStates(sub2)
    case AFStateVar(v) => Set(v)
    case AFNot(s) => getStates(s)
    case _ => Set()
  }

  def getStates: Set[Int] = getStates(this)

  def shiftStateVariables(inc: Int): AFormula = this match {
    case AFAnd(sub1, sub2) =>
      AFAnd(sub1 shiftStateVariables inc, sub2 shiftStateVariables inc)
    case AFOr(sub1, sub2) =>
      AFOr(sub1 shiftStateVariables inc, sub2 shiftStateVariables inc)
    case AFLet(sub1, sub2) =>
      AFLet(sub1 shiftStateVariables inc, sub2 shiftStateVariables inc)
    case AFNot(s) =>
      AFNot(s shiftStateVariables inc)
    case AFStateVar(v) =>
      AFStateVar(v + inc)
    case x => x
  }

  def permuteChars(mapping : Map[Int, Int]) : AFormula = this match {
    case AFAnd(sub1, sub2) =>
      AFAnd(sub1 permuteChars mapping, sub2 permuteChars mapping)
    case AFOr(sub1, sub2) =>
      AFOr(sub1 permuteChars mapping, sub2 permuteChars mapping)
    case AFLet(sub1, sub2) =>
      AFLet(sub1 permuteChars mapping, sub2 permuteChars mapping)
    case AFNot(s) =>
      AFNot(s permuteChars mapping)
    case AFCharVar(v) => {
      val varInd = v / widthOfChar
      val bit = v % widthOfChar
      AFCharVar(mapping(varInd) * widthOfChar + bit)
    }
    case AFSpecSymb(s) =>
      AFSpecSymb(mapping(s))
    case x => x
  }

  def renameVariables(s: Int, mapping : Map[Int, Int]): AFormula = this match {
    case AFAnd(sub1, sub2) =>
      AFAnd(sub1.renameVariables(s, mapping), sub2.renameVariables(s, mapping))
    case AFOr(sub1, sub2) =>
      AFOr(sub1.renameVariables(s, mapping), sub2.renameVariables(s, mapping))
    case AFLet(sub1, sub2) =>
      AFLet(sub1.renameVariables(s, mapping), sub2.renameVariables(s, mapping))
    case AFNot(sub) =>
      AFNot(sub.renameVariables(s, mapping))
    case AFStateVar(v) =>
      AFStateVar(v + s)
    case AFCharVar(v) => {
      val varInd = v / widthOfChar
      val bit = v % widthOfChar
      AFCharVar(mapping(varInd) * widthOfChar + bit)
    }
    case AFSpecSymb(s) =>
      AFSpecSymb(mapping(s))
    case x => x
  }

  def paramToState(mapping : Map[Int, (Int, Int)],
                   negated : Boolean) : AFormula = this match {
    case AFAnd(sub1, sub2) =>
      AFAnd(sub1.paramToState(mapping, negated),
        sub2.paramToState(mapping, negated))
    case AFOr(sub1, sub2) =>
      AFOr(sub1.paramToState(mapping, negated),
        sub2.paramToState(mapping, negated))
    case AFLet(sub1, sub2) =>
      throw new IllegalArgumentException
    case AFNot(s) =>
      AFNot(s.paramToState(mapping, !negated))
    case AFParam(p) =>
      if (negated) ~AFStateVar(mapping(p)._2) else AFStateVar(mapping(p)._1)
    case x => x
  }
}

object AFormula {
  val widthOfChar = 8

  def and(fors : Iterable[AFormula]) : AFormula =
    and(fors.iterator)

  def and(fors : Iterator[AFormula]) : AFormula =
    if (fors.hasNext)
      fors reduceLeft (_ & _)
    else
      AFTrue

  def or(fors : Iterable[AFormula]) : AFormula =
    or(fors.iterator)

  def or(fors : Iterator[AFormula]) : AFormula =
    if (fors.hasNext)
      fors reduceLeft (_ | _)
    else
      AFFalse

  /**
    * Bit-vector equality
    */
  def bvEq(a : Seq[AFormula], b : Seq[AFormula]) : AFormula =
    and(for ((x, y) <- a.iterator zip b.iterator) yield (x <=> y))

  // unsigned bit-vector comparison of two bit-strings, each
  // starting with the most-significant bit

  def bvLt(a : Seq[AFormula], b : Seq[AFormula]) =
    bvLess(a, b, false)

  def bvLeq(a : Seq[AFormula], b : Seq[AFormula]) =
    bvLess(a, b, true)

  def bvLess(ar : Seq[AFormula], br : Seq[AFormula],
             orEqual : Boolean) : AFormula = {
    assert(ar.size == br.size)

    val a = ar.reverse
    val b = br.reverse

    var curFor : AFormula =
      if (orEqual)
        AFDeBrujinVar(0) | AFDeBrujinVar(1)
      else
        AFDeBrujinVar(0)

    for (i <- a.indices) {
      curFor =
        (AFDeBrujinVar(1) | (~a(i) & b(i) & AFDeBrujinVar(2))) letIn curFor
      curFor =
        ((a(i) <=> b(i)) & AFDeBrujinVar(1)) letIn curFor
    }

    curFor = AFFalse letIn curFor
    curFor = AFTrue letIn curFor

    curFor
  }

  def nat2bv(value: Int): Seq[AFormula] = {
    var res: List[AFormula] = List.empty
    for (i <- 0 until AFormula.widthOfChar) {
      res = (if((value & (1 << i)) != 0) AFTrue else AFFalse) :: res
    }

    res
  }

  def bvSub(a: Seq[AFormula], b: Seq[AFormula]): Seq[AFormula] = {
    var tmp: AFormula = AFFalse
    var res: List[AFormula] = List.empty

    for(i <- a.indices.reverse) {
      res = (tmp ^ a(i) ^ b(i)) :: res

      tmp = (~a(i) & b(i)) | (tmp & ~a(i)) | (tmp & b(i))
    }

    res
  }

  def bvAdd(a: Seq[AFormula], b: Seq[AFormula]): Seq[AFormula] = {
    var tmp: AFormula = AFFalse
    var res: List[AFormula] = List.empty

    for(i <- a.indices.reverse) {
      res = (tmp ^ a(i) ^ b(i)) :: res

      tmp = (tmp & a(i)) | (tmp & b(i)) | (a(i) & b(i))
    }

    res
  }

  def bvShl(vec: Seq[AFormula], s: Int): Seq[AFormula] = {
    var res = vec

    for(i <- 0 until s) {
      res = res.tail :+ AFFalse
    }

    res
  }

  def createSymbol(char: Int, offset: Int): AFormula = {
    var index = 0x1 << widthOfChar - 1

    ((offset * widthOfChar) until (widthOfChar + widthOfChar * offset)).foldLeft[AFormula](AFTrue) { case (formula, bit) =>
      val tmp =
        if((char & index) != 0)
          AFCharVar(bit)
        else
          AFNot(AFCharVar(bit))

      index >>= 1
      formula & tmp
    }
  }

  def symbolInRange(valMin : Int, valMax : Int) : AFormula = {
    val vars = for (i <- 0 until widthOfChar) yield AFCharVar(i)
    val minBits = for (i <- 0 until widthOfChar) yield {
      if ((valMin & (1 << i)) != 0) AFTrue else AFFalse
    }
    val maxBits = for (i <- 0 until widthOfChar) yield {
      if ((valMax & (1 << i)) != 0) AFTrue else AFFalse
    }
    bvLeq(minBits.reverse, vars) & bvLeq(vars, maxBits.reverse)
  }

  ///
  /// With a specific track t
  ///
  def symbolInRange(valMin : Int, valMax : Int, t: Int = 0) : AFormula = {
    val vars = for (i <- 0 until widthOfChar) yield
      AFCharVar(i + t * widthOfChar)
    val minBits = for (i <- 0 until widthOfChar) yield {
      if ((valMin & (1 << i)) != 0) AFTrue else AFFalse
    }
    val maxBits = for (i <- 0 until widthOfChar) yield {
      if ((valMax & (1 << i)) != 0) AFTrue else AFFalse
    }
    bvLeq(minBits.reverse, vars) & bvLeq(vars, maxBits.reverse)
  }

  def createEpsilon(offset: Int): AFormula =
    AFSpecSymb(offset) & createSymbol(0, offset)
  def createSpecialSymbol(char: Int, offset: Int) =
    AFSpecSymb(offset) & createSymbol(char, offset)

  def apply(states: GenTraversableOnce[Int], neg: Boolean = false): AFormula =
    if(neg)
      states.foldLeft[AFormula](AFTrue) { case (formula, state) => formula & AFNot(AFStateVar(state)) }
    else
      states.foldLeft[AFormula](AFFalse) { case (formula, state) => formula | AFStateVar(state) }
}

case class AFAnd(sub1: AFormula, sub2: AFormula) extends AFormula
case class AFOr(sub1: AFormula, sub2: AFormula) extends AFormula
case class AFNot(sub: AFormula) extends AFormula
case class AFLet(definition : AFormula, in : AFormula) extends AFormula
case class AFStateVar(v: Int) extends AFormula
case class AFCharVar(v: Int) extends AFormula
case class AFSpecSymb(s: Int) extends AFormula
case class AFParam(p: Int) extends AFormula
case class AFDeBrujinVar(ind: Int) extends AFormula
object AFFalse extends AFormula
object AFTrue extends AFormula
