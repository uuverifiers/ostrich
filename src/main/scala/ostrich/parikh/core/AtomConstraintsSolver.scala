package ostrich.parikh.core

import ap.terfor.conjunctions.Conjunction
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.parser.Internal2InputAbsy
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import AtomConstraints._
import ap.terfor.Term
import ap.terfor.Formula
import ostrich.parikh.Config._
import ap.basetypes.IdealInt

object AtomConstraintsSolver {
  var initialLIA: Formula = Conjunction.TRUE

}

class Result {
  protected var status = ProverStatus.Unknown

  private val model = new OstrichModel

  def setStatus(s: ProverStatus.Value): Unit = status = s

  def getStatus = status

  def updateModel(t: Term, v: IdealInt): Unit = model.update(t, v)

  def updateModel(t: Term, v: Seq[Int]): Unit = model.update(t, v)

  def getModel = model.getModel
}

import AtomConstraintsSolver._

trait AtomConstraintsSolver {

  def solve: Result

  protected var constraints: Seq[AtomConstraints] = Seq()

  protected var interestTerms: Set[Term] = Set()

  def setInterestTerm(terms: Set[Term]): Unit = interestTerms = terms

  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomatonTrait]): Unit = {

    val constraint = lengthAbsStrategy match {
      case Unary()  => unaryHeuristicACs(t, auts)
      case Parikh() => parikhACs(t, auts)
      case Catra()  => catraACs(t, auts)
    }

    addConstraint(constraint)
  }

  def addConstraint(constraint: AtomConstraints): Unit =
    constraints ++= Seq(constraint)

}

class LinearAbstractionSolver extends AtomConstraintsSolver {

  def solve: Result = {
    // Sometimes computation of linear abstraction is very expensive
    // So we thy to find a model with less constraints(over-approximation) first
    // Improve me !! (maybe currently compute approximation and linear abstraction)
    val approxRes = solveOverApprox
    approxRes.getStatus match {
      case ProverStatus.Sat => approxRes
      case _                => solveLinearAbs
    }
  }

  def solveOverApprox: Result = solveFixedFormula(
    conj(constraints.map(_.getOverApprox))
  )

  def solveLinearAbs: Result = solveFixedFormula(
    conj(constraints.map(_.getLinearAbs))
  )

  def solveFixedFormula(f: Formula): Result = {
    import AtomConstraints.evalTerm
    val res = new Result
    SimpleAPI.withProver { p =>
      p setConstructProofs true
      val regsRelation = conj(constraints.map(_.getRegsRelation))
      val finalArith = conj(f, initialLIA, regsRelation)
      p addConstantsRaw SymbolCollector.constants(
        Internal2InputAbsy(finalArith)
      )
      p addAssertion finalArith
      p.??? match {
        case ProverStatus.Sat =>
          val partialModel = p.partialModel
          // update string model
          for (singleString <- constraints) {
            singleString.setInterestTermModel(partialModel)
            val value = singleString.getModel
            res.updateModel(singleString.strId, value)
          }
          // update integer model
          for (term <- interestTerms) {
            val value = evalTerm(term, partialModel)
            res.updateModel(term, value)
          }

          res.setStatus(ProverStatus.Sat)
        case _ => res.setStatus(_)
      }
    }
    res
  }

}

// TODO: Encode the final atom constraints to catra input format,
// and then call catra to solve the constraints
class CatraBasedSolver extends AtomConstraintsSolver {

  lazy val automatas: Seq[Seq[CostEnrichedAutomatonTrait]] =
    constraints.map(_.getAutomata)

  def toCatraInput: String = {
    val sb = new StringBuilder
    sb.append(toCatraInputInteger)
    sb.append(toCatraInputAutomata)
    sb.append(toCatraInputLIA)
    sb.toString()
  }

  def toCatraInputInteger: String = {
    val sb = new StringBuilder
    sb.append("counter int ")
    val allIntTerms = interestTerms ++ constraints.flatMap(_.interestTerms)
    sb.append(allIntTerms.mkString(", "))
    sb.append(";\n")
    sb.toString()
  }

  def toCatraInputAutomata: String = {
    val sb = new StringBuilder
    for (constraint <- constraints) {
      sb.append("synchronised {\n")
      val autNamePrefix = constraint.strId.toString
      for ((aut, i) <- constraint.getAutomata.zipWithIndex) {
        sb.append(toCatraInputAutomaton(aut, autNamePrefix + i))
      }
      sb.append("};\n")
    }
    sb.toString()
  }

  def toCatraInputAutomaton(
      aut: CostEnrichedAutomatonTrait,
      name: String
  ): String = {
    val sb = new StringBuilder
    val state2Int = aut.states.zipWithIndex.toMap
    sb.append(s"automaton $name {\n")
    sb.append(s"\tinit s${state2Int(aut.initialState)};\n")
    for ((s, lbl, t, vec) <- aut.transitionsWithVec) {
      sb.append(
        s"\ts${state2Int(s)} -> s${state2Int(t)} ${toCatraInputTLabel(lbl)} "
      )
      sb.append(toCatraInputRegisterUpdate(aut, vec))
      sb.append(";\n")
    }
    sb.append("\taccepting ")
    sb.append(aut.acceptingStates.map("s" + state2Int(_)).mkString(", "))
    sb.append(";\n")
    sb.append("};\n")
    sb.toString()
  }

  def toCatraInputTLabel(lbl: (Char, Char)) = {
    val (c1, c2) = lbl
    s"[${c1.toInt}, ${c2.toInt}]"
  }

  def toCatraInputRegisterUpdate(
      aut: CostEnrichedAutomatonTrait,
      update: Seq[Int]
  ) = {
    val sb = new StringBuilder
    sb.append("{")
    val updateStringSeq = 
    for ((v, i) <- update.zipWithIndex; if v > 0) yield 
      s"${aut.getRegisters(i)} += $v"
    sb.append(updateStringSeq.mkString(", "))
    sb.append("}")
    sb.toString()
  }

  def toCatraInputLIA: String = {
    val sb = new StringBuilder
    sb.append("constraint ")
    sb.append(initialLIA.toString.replaceAll("&", "&&"))
    sb.append(";\n")
    sb.toString()
  }

  def solve: Result = {
    println(toCatraInput)
    new Result
  }
}
