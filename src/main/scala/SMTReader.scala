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

import ap.parameters.{Param, ParserSettings}
import ap.parser._

object SMTReader {
  import IExpression._

  def eliminateUniQuantifiers(formula : IFormula) = {
    var clause = formula
    var parameterConsts = List[ITerm]()

    // transformation to prenex normal form
    clause = Transform2Prenex(Transform2NNF(clause))

    while (clause.isInstanceOf[IQuantified]) {
      val IQuantified(Quantifier.ALL, d) = clause
      clause = d
      parameterConsts =
        (new ConstantTerm ("P" + parameterConsts.size)) :: parameterConsts
    }

    subst(clause, parameterConsts, 0)
  }
}

/** This class is borrowed from Eldarica,
    https://github.com/uuverifiers/eldarica  */
class SMTReader(fileName: String) {
  import SMTReader._

  private val reader = new java.io.BufferedReader (
    new java.io.FileReader(new java.io.File (fileName)))
  private val settings = Param.BOOLEAN_FUNCTIONS_AS_PREDICATES.set(
    ParserSettings.DEFAULT, true)
  private val parser = SMTLIBStringParser(settings)
  val (rawFormula, _, signature) = parser(reader)
  reader.close
  //  println(signature.order)

  val includesGetModel = parser.includesGetModel

  private val allConstants = parser.env.nullaryFunctions.toSeq sortBy (_.name)

  val (wordConstants, otherConstants) =
    allConstants partition { c =>
      parser.env.lookupSym(c.name) match {
        case Environment.Constant(_, _,
        SMTLIBStringParser.SMTSeq(_)) => true
        case _ => false
      }}

  val bitwidth = parser.observedBitwidth getOrElse 8
  Console.err.println("Assuming bit-vectors of width " + bitwidth)

  def elimEqv(aF : ap.parser.IFormula) : ap.parser.IFormula = {
    aF match {
      case f@IBinFormula(IBinJunctor.Eqv,f1,f2) =>
        val ff1 = elimEqv(f1)
        val ff2 = elimEqv(f2)
        IBinFormula(IBinJunctor.And,
          IBinFormula(IBinJunctor.Or,INot(ff1),ff2),
          IBinFormula(IBinJunctor.Or,INot(ff2),ff1))
      case f => f
    }
  }
  def nnf(aF : ap.parser.IFormula, b : Boolean) : ap.parser.IFormula = {
    aF match {
      case INot(f) =>
        nnf(f,!b)
      case IQuantified(q,f) =>
        val qq = if (!b) q else q.dual
        IQuantified(qq,nnf(f,b))
      case IBinFormula(j,f1,f2) =>
        j match {
          case IBinJunctor.And =>
            val jj = if (!b) IBinJunctor.And else IBinJunctor.Or
            IBinFormula(jj,nnf(f1,b),nnf(f2,b))
          case IBinJunctor.Or =>
            val jj = if (!b) IBinJunctor.Or else IBinJunctor.And
            IBinFormula(jj,nnf(f1,b),nnf(f2,b))
          case IBinJunctor.Eqv =>
            assert(false)
            IBoolLit(true)
        }
      case f : IAtom => if (!b) f else INot(f)
      case f : IBoolLit => if (!b) f else INot(f)
      case f : IIntFormula => if (!b) f else INot(f)
      case _ =>
        assert(false)
        IBoolLit(true)
    }
  }
  // negation normal form
  def nnf(aF : ap.parser.IFormula) : ap.parser.IFormula = {
    val f_noEqv = elimEqv(aF)
    nnf(f_noEqv,false)
  }

  def dnf_base(dnf1 : List[ap.parser.IFormula], dnf2 : List[ap.parser.IFormula]) = {
    var dnf : List[ap.parser.IFormula] = List()
    for (f1 <- dnf1) {
      for (f2 <- dnf2) {
        dnf = (f1 &&& f2) :: dnf
      }
    }
    dnf
  }
  def cnf_base(cnf1 : List[ap.parser.IFormula], cnf2 : List[ap.parser.IFormula]) = {
    var cnf : List[ap.parser.IFormula] = List()
    for (f1 <- cnf1) {
      for (f2 <- cnf2) {
        cnf = (f1 ||| f2) :: cnf
      }
    }
    cnf
  }
  // disjunctive normal form (quantified subformulas are considered as atoms)
  def ddnf(aF : ap.parser.IFormula) : List[ap.parser.IFormula] = {
    var dnf : List[IFormula] = Nil
    aF match {
      case IBinFormula(j,f1,f2) =>
        val dnf1 = ddnf(f1)
        val dnf2 = ddnf(f2)
        j match {
          case IBinJunctor.And =>
            dnf = dnf_base(dnf1,dnf2)
          case IBinJunctor.Or =>
            dnf = dnf1 ::: dnf2
          case IBinJunctor.Eqv =>
            assert(false)
        }
      case f@INot(IAtom(_,_)) => dnf = f :: Nil
      case f@INot(IBoolLit(_)) => dnf = f :: Nil
      case f@INot(IIntFormula(_,_)) => dnf = f :: Nil
      case f : IAtom => dnf = f :: Nil
      case f : IBoolLit => dnf = f :: Nil
      case f : IIntFormula => dnf = f :: Nil
      case f : IQuantified => dnf = f :: Nil
      case _ =>
        assert(false)
    }
    dnf
  }
  // conjunctive normal form (quantified subformulas are considered as atoms)
  def ccnf(aF : ap.parser.IFormula) : List[ap.parser.IFormula] = {
    var cnf : List[IFormula] = Nil
    aF match {
      case IBinFormula(j,f1,f2) =>
        val cnf1 = ccnf(f1)
        val cnf2 = ccnf(f2)
        j match {
          case IBinJunctor.And =>
            cnf = cnf1 ::: cnf2
          case IBinJunctor.Or =>
            cnf = cnf_base(cnf1,cnf2)
          case IBinJunctor.Eqv =>
            assert(false)
        }
      case f@INot(IAtom(_,_)) => cnf = f :: Nil
      case f@INot(IBoolLit(_)) => cnf = f :: Nil
      case f@INot(IIntFormula(_,_)) => cnf = f :: Nil
      case f : IAtom => cnf = f :: Nil
      case f : IBoolLit => cnf = f :: Nil
      case f : IIntFormula => cnf = f :: Nil
      case f : IQuantified => cnf = f :: Nil
      case _ =>
        assert(false)
    }
    cnf
  }
  def containsPredicate(aF : IFormula) : Boolean = {
    aF match {
      case IQuantified(q,f) => containsPredicate(f)
      case IBinFormula(j,f1,f2) => containsPredicate(f1) || containsPredicate(f2)
      case INot(f) => containsPredicate(f)
      case a : IAtom => true
      case _ =>false
    }
  }
  def quantifiers(aF : IFormula) : List[ap.terfor.conjunctions.Quantifier] = {
    aF match {
      case IQuantified(q,f) =>
        q :: quantifiers(f)
      case IBinFormula(j,f1,f2) =>
        quantifiers(f1) ::: quantifiers(f2)
      case INot(f) =>
        quantifiers(f)
      case _ => Nil
    }
  }
  def cnt_quantif(aF : IFormula) : Int = {
    quantifiers(aF).length
  }
  // prenex normal form
  // aF -- a formula formed only by atoms, quantifiers, not, and, or, eqv
  def pnf(aF : ap.parser.IFormula) : ap.parser.IFormula = {
    val f_nnf = nnf(aF)
    var x = cnt_quantif(f_nnf)
    // quantifier prefix of PNF
    var q_prefix = List[IExpression.Quantifier]()
    // aInx -- de Bruijn index
    def remove_quant(aF : IFormula, aInx : Int) : IFormula = {
      aF match {
        case IQuantified(q,f) =>
          val ff = remove_quant(f,aInx+1)
          q_prefix = q :: q_prefix
          x = x-1
          // _aInx becomes _x
          // for each i in 0..(aInx-1), _i stays _i
          var ll = List[IVariable]()
          ll = IExpression.v(x) :: ll
          for (i <- aInx-1 to 0 by -1) {
            ll = IExpression.v(i) :: ll
          }
          val aux = VariableSubstVisitor(ff,(ll,0))
          aux
        case IBinFormula(j,f1,f2) =>
          val ff1 = remove_quant(f1,aInx)
          val ff2 = remove_quant(f2,aInx)
          IBinFormula(j,ff1,ff2)
        case INot(f) =>
          val ff = remove_quant(f,aInx)
          INot(ff)
        case f => f
      }
    }
    // new de Bruijn indices: 0,1,...,x-1
    // renaming of variables in post-order traversal, starting with x-1
    var f_pnf = remove_quant(f_nnf,0)
    // add the quantifier prefix
    // quantifiers (q1,q2,...) in q_prefix have de Bruijn indices (0,1,...)
    for (q <- q_prefix.reverse) {
      f_pnf = IQuantified(q,f_pnf)
    }
    f_pnf
  }
}
