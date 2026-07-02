/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Matthew Hague, Philipp Ruemmer. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from this software without specific prior written permission.
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

package ostrich.certificates

import ap.basetypes.IdealInt
import ap.parser.SMTLineariser
import ap.proof.certificates._
import ap.terfor.preds.{Atom, PredConj}
import ap.terfor.{Formula, Term, TermOrder, TerForConvenience, ConstantTerm}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.types.Sort

import ostrich._
import ostrich.preop.{PreOp, ConcatPreOp}
import ostrich.automata.AtomicStateAutomaton

class OstrichAletheTheoryPrinter(theory : OstrichStringTheory)
      extends AletheTheoryPrinter {
  import theory.{FunPred, strDatabase, autDatabase,
                 str_++, str_in_re_id, agePred}

  def printTheoryAtom(a    : Atom,
                      vs   : List[String],
                      ctxt : AletheFormulaPrinterContext) : Boolean = {
    import ctxt.printTerm
    a.pred match {
      case FunPred(`str_++`) => {
        print("(= ")
        printStringTerm(a(2), vs, ctxt)
        print(" (str.++ ")
        printStringTerm(a(0), vs, ctxt)
        print(" ")
        printStringTerm(a(1), vs, ctxt)
        print("))")
        true
      }
      case `str_in_re_id` => {
        print("(str.in_re ")
        printStringTerm(a(0), vs, ctxt)
        print(" (re.from_automaton \"")
        val LinearCombination.Constant(IdealInt(id)) = a(1)
        val aut =
          autDatabase.id2Automaton(id).get.asInstanceOf[AtomicStateAutomaton]
        print(ostrich.AutomatonParser.toString(aut))
        print("\"))")
        true
      }
      case _ =>
        false
    }
  }

  def printTheoryEquation(lc        : LinearCombination,
                          variables : List[String],
                          ctxt      : AletheFormulaPrinterContext) : Boolean =
    lc match {
      case LinearCombination.CoeffTermWithOffset(
             IdealInt.ONE, c : ConstantTerm, IdealInt(offset))
          if Sort.sortOf(c) == theory.StringSort => {
        print(s"(= ${SMTLineariser.quoteIdentifier(c.name)} ")
        printEncodedString(-offset)
        print(")")
        true
      }
      case _ =>
        false
    }

  private def printStringTerm(t         : Term,
                              variables : List[String],
                              ctxt      : AletheFormulaPrinterContext) : Unit =
    t match {
      case LinearCombination.Constant(IdealInt(id)) =>
        printEncodedString(id)
      case t =>
        ctxt.printTerm(t, variables)
    }

  private def printEncodedString(id : Int) : Unit = {
    val str = theory.strDatabase.id2Str(id)
    print("\"")
    print(SMTLineariser.escapeString(str))
    print("\"")
  }

  def hideTheoryAtom(a : Atom) = a.pred == agePred

  def printTheoryAxiomInference(inference       : TheoryAxiomInference,
                                nextInferences  : List[BranchInference],
                                nextAssumptions : List[Set[CertFormula]],
                                childCert       : Certificate,
                                order           : TermOrder,
                                ctxt            : AlethePrinterContext):Unit = {
/*    println("printTheoryAxiomInference: " + inference)
    println(nextInferences)
    println(nextAssumptions)
    println(childCert) */

    import TerForConvenience._
    implicit val o = order

    inference.theoryRule match {
      case BwdPropagationRule(ConcatPreOp, funApp, image, preImage, _) => {
        val l = ctxt.introduceMultiClauseThroughStep(
                  "concat_aut_bwd_propagation",
                  List(CertFormula(conj(funApp)), CertFormula(conj(image))),
                  preImage.map(fors =>
                    fors.map(f => (CertFormula(conj(f)), false))))

        val subLabels = for ((c, n) <- preImage.zipWithIndex) yield {
          val caseFor = CertFormula(conj(c))
          val cert = findSubCert(caseFor, nextInferences, childCert)
          ctxt.printlnComment(s"Case $n of backward propagation:")
          ctxt.printSubproof(cert, List(caseFor))
        }

        // TODO: need to make sure that conjunctions are in the right order
        ctxt.hyperResolutionStr(l, subLabels, "")
      }

      case r@InconsistentRegexRule(atoms, _) => {
        val literals = atoms.map {
          case a : Atom =>
            (CertFormula(a), true)
          case p : Formula if p.groundAtoms.size == 1 =>
            (CertFormula(p.groundAtoms.iterator.next), false)
          case _ =>
            throw new Exception(s"cannot print Alethe proof using $r")
        }

        val l = ctxt.introduceClauseThroughStep("re_empty_intersection", List(),
                                                literals)

        val assumptions = literals.map {
          case (a, true)  => a
          case (a, false) => !a
        }
        ctxt.hyperResolution(l, assumptions, CertFormula.FALSE)
      }

      case r => {
        // A proof rule we do not understand, let's invoke magic!

        ctxt.introduceFormulaThroughStep("magic", List(), Some(inference.axiom))
        ctxt.continuePrinting(nextInferences, childCert)
      }
    }
  }

  private def findSubCert(formula        : CertFormula,
                          nextInferences : List[BranchInference],
                          childCert      : Certificate) : Certificate = {
    (nextInferences, childCert) match {
      case (inf :: remInfs, childCert)
          if inf.assumedFormulas.contains(formula) =>
        BranchInferenceCertificate.prepend(nextInferences, childCert,
                                           childCert.order) // TODO: use right order
      case (_ :: remInfs, childCert) =>
        findSubCert(formula, remInfs, childCert)
      case (List(), childCert)
          if childCert.localAssumedFormulas.contains(formula) =>
        childCert
      case (List(), BetaCertificate(_, _, _, leftChild, rightChild, _)) =>
        if (leftChild.assumedFormulas.contains(formula))
          findSubCert(formula, List(), leftChild)
        else
          findSubCert(formula, List(), rightChild)
    }
  }

}
