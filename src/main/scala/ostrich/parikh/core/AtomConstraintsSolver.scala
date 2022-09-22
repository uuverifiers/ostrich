package ostrich.parikh.core

import ap.terfor.conjunctions.Conjunction
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.terfor.TerForConvenience._
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import AtomConstraints._
import ap.terfor.Term
import ap.terfor.Formula
import ostrich.parikh.Config._
import ap.basetypes.IdealInt
import ostrich.parikh.writer.CatraWriter
import uuverifiers.catra.CommandLineOptions
import scala.io.Source
import uuverifiers.catra.InputFileParser
import fastparse.Parsed
import uuverifiers.catra.{Invalid, Valid}
import scala.util.Failure
import uuverifiers.catra.SolveRegisterAutomata.runInstance
import scala.util.Try
import uuverifiers.catra.{Result => CatraResult}
import uuverifiers.catra.ChooseLazy
import uuverifiers.catra.SolveSatisfy
import scala.util.Success
import uuverifiers.catra.Sat
import uuverifiers.catra.OutOfMemory
import uuverifiers.catra.Timeout
import uuverifiers.catra.Unsat
import ap.terfor.ConstantTerm
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.ParikhUtil.measure

object AtomConstraintsSolver {
  var initialLIA: Formula = Conjunction.TRUE
  var initialConstTerms: Seq[Term] = Seq()
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
      p addConstantsRaw SymbolCollector.constants(finalArith)

      p addConstantsRaw initialConstTerms
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


  def runInstances(arguments: CommandLineOptions): Try[CatraResult] = {
    // only run one file
    val fileName = arguments.inputFiles(0)
    val inputFileHandle = Source.fromFile(fileName)
    val fileContents = inputFileHandle.mkString("")
    inputFileHandle.close()
    val parsed = measure("CatraBasedSolver::runInstances::parsed")(
      InputFileParser.parse(fileContents)
    )
    val result = measure("CatraBasedSolver::runInstances::findModel") {
      parsed match {
        case Parsed.Success(instance, _) =>
          instance.validate() match {
            case Valid => runInstance(instance, arguments)
            case Invalid(motivation) =>
              Failure(new Exception(s"Invalid input: $motivation"))
          }
        case Parsed.Failure(expected, _, extra) =>
          Console.err.println(s"E: parse error $expected")
          Console.err.println(s"E: ${extra.trace().longMsg}")
          Failure(new Exception(s"parse error: ${extra.trace().longMsg}"))
      }
    }
    result
  }

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
    val lia = conj(initialLIA +: constraints.map(_.getRegsRelation))
    val allIntTerms = (interestTerms ++ constraints.flatMap(
      _.interestTerms
    ) ++ initialConstTerms ++ SymbolCollector.constants(lia)).filterNot(_.isInstanceOf[LinearCombination]).toSet
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
    sb.append(s"automaton aut_$name {\n")
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
      for ((v, i) <- update.zipWithIndex; if v > 0)
        yield s"${aut.getRegisters(i)} += $v"
    sb.append(updateStringSeq.mkString(", "))
    sb.append("}")
    sb.toString()
  }

  def toCatraInputLIA: String = {
    val sb = new StringBuilder
    sb.append("constraint ")
    val lia = conj(initialLIA +: constraints.map(_.getRegsRelation))
    sb.append(lia.toString.replaceAll("&", "&&"))
    sb.append(";\n")
    sb.toString()
  }

  def decodeCatraResult(res: CatraResult): Result = {
    val result = new Result
    res match {
      case Sat(assignments) => {
        val strIntersted = constraints.flatMap(_.interestTerms)
        val name2Term = (strIntersted ++ interestTerms)
          .filter(_.isInstanceOf[ConstantTerm])
          .map { case t: ConstantTerm =>
            (t.name, t)
          }
          .toMap
        val termModel =
          for (
            (k, v) <- assignments;
            t <- name2Term.get(k.name)
          ) yield (t, IdealInt(v))
        // update string model
        for (singleString <- constraints) {
          singleString.setInterestTermModel(termModel)
          val value = singleString.getModel
          result.updateModel(singleString.strId, value)
        }
        for ((k, v) <- assignments; t <- name2Term.get(k.name)) {
          result.updateModel(t, IdealInt(v))
        }
        result.setStatus(ProverStatus.Sat)
      }
      case OutOfMemory => throw new Exception("Out of memory")
      case Timeout(timeout_ms) =>
        throw new Exception(s"Timeout with time limit ${timeout_ms / 1_000} s")
      case Unsat => result.setStatus(ProverStatus.Unsat)
    }
    result
  }

  def solve: Result = {
    if (constraints.isEmpty) {
      val result = new Result
      result.setStatus(ProverStatus.Sat)
      return result
    }
    val interFlie = "intermediate.par"
    val writer = new CatraWriter(interFlie)
    writer.write(toCatraInput)
    writer.close()
    val arguments = CommandLineOptions(
      inputFiles = Seq(interFlie),
      timeout_ms = Some(30_000),
      trace = false,
      printDecisions = false,
      dumpSMTDir = None,
      dumpGraphvizDir = None,
      runMode = SolveSatisfy,
      backend = ChooseLazy,
      checkTermSat = true,
      checkIntermediateSat = true,
      eliminateQuantifiers = true,
      dumpEquationDir = None,
      nrUnknownToMaterialiseProduct = 2,
      enableClauseLearning = true,
      enableRestarts = true
    )
    val catraRes = runInstances(arguments)
    var result = new Result
    catraRes match {
      case Success(_catraRes) =>
        result = decodeCatraResult(_catraRes)
      case Failure(e) => e.printStackTrace; throw e
    }
    result
  }
}
