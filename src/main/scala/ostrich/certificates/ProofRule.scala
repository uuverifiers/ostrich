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

import ap.proof.certificates._
import ap.terfor.preds.Atom
import ap.terfor.{TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction

import ostrich._
import ostrich.preop.{PreOp, ConcatPreOp}

trait OstrichProofRule extends TheoryRule {

}

case class BwdPropRule(op       : PreOp,
                       funApp   : Atom,
                       image    : Option[Atom],
                       preImage : Seq[Conjunction]) extends OstrichProofRule {

}

class OstrichAletheTheoryPrinter(theory : OstrichStringTheory)
      extends AletheTheoryPrinter {

  def printTheoryAxiomInference(inference       : TheoryAxiomInference,
                                nextInferences  : List[BranchInference],
                                nextAssumptions : List[Set[CertFormula]],
                                childCert       : Certificate,
                                order           : TermOrder,
                                ctxt            : AlethePrinterContext):Unit = {
    println("printTheoryAxiomInference")
    println(nextInferences)
    println(nextAssumptions)
    println(childCert)

    import TerForConvenience._
    implicit val o = order

    inference.theoryRule match {
      case r@BwdPropRule(ConcatPreOp, funApp, image, preImage) => {
        println(r)

        val l = ctxt.introduceClauseThroughStep(
                  "concat_aut_bwd_propagation",
                  List(CertFormula(conj(funApp)), CertFormula(conj(image))),
                  preImage.map(f => (CertFormula(f), false)))

        for ((c, n) <- preImage.zipWithIndex) {
          println(s"Branch $n:")
          val caseFor = CertFormula(c)
          val cert = findSubCert(caseFor, nextInferences, childCert)
          println(cert)
          ctxt.printSubproof(cert, List(caseFor))
        }
      }
      case r => {
        Console.err.println(s"Cannot print Alethe proof for $r")
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