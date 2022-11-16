package ostrich.parikh.core

import ap.terfor.conjunctions.Conjunction
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ap.terfor.TerForConvenience._
import ostrich.parikh.CostEnrichedConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ostrich.parikh.automata.CostEnrichedAutomaton
import FinalConstraints._
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
import ap.parameters.Param
import ostrich.OstrichMain
import ostrich.parikh.util.TimeoutException
import ostrich.OFlags
import ostrich.parikh.ParikhExploration.Approx
import ostrich.parikh.util.UnknownException

class Result {
  protected var status = ProverStatus.Unknown

  private val model = new OstrichModel

  def isSat = status == ProverStatus.Sat

  def isUnsat = status == ProverStatus.Unsat

  def setStatus(s: ProverStatus.Value): Unit = status = s

  def getStatus = status

  def updateModel(t: Term, v: IdealInt): Unit = model.update(t, v)

  def updateModel(t: Term, v: Seq[Int]): Unit = model.update(t, v)

  def getModel = model.getModel
}


trait FinalConstraintsSolver[A <: FinalConstraints] {

  def solve: Result

  def measureTimeSolve: Result =
    measure(s"${this.getClass.getSimpleName}::solve") {
      solve
    }

  protected var constraints: Seq[A] = Seq()

  protected var integerTerms: Set[Term] = Set()

  def setIntegerTerm(terms: Set[Term]): Unit = integerTerms = terms

  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomaton]): Unit

  def addConstraint(c: A) = constraints = constraints :+ c

}

class UnaryBasedSolver extends FinalConstraintsSolver[UnaryFinalConstraints] {

  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomaton]): Unit = {
    addConstraint(unaryHeuristicACs(t, auts))
  }

  def solve: Result = {
    // var res = solveUnderApprox
    // if (!res.isSat)
    //   res = solveOverApprox
    // res
    solveOverApprox
  }

  def solveUnderApprox: Result = {
    // add bound iterately
    val maxBound = 30
    val step = 5
    var nowBound = 5
    var result = new Result
    while (nowBound < maxBound && !result.isSat) {
      result = solveFormula(
        conj(constraints.map(_.getUnderApprox(nowBound)))
      )
      nowBound += step
    }
    result
  }

  def solveOverApprox: Result = solveFormula(
    conj(constraints.map(_.getOverApprox))
  )

  def solveCompleteLIA: Result = solveFormula(
    conj(constraints.map(_.getCompleteLIA))
  )

  def solveFormula(f: Formula): Result = {
    import FinalConstraints.evalTerm
    val res = new Result
    SimpleAPI.withProver { p =>
      p setConstructProofs true
      val regsRelation = conj(constraints.map(_.getRegsRelation))
      val finalArith = conj(f, regsRelation, FinalConstraints())
      val constants =
        SymbolCollector.constants(finalArith) ++ integerTerms

      p addConstants constants

      // p addConstantsRaw initialConstTerms
      p addAssertion finalArith
      val status = measure(
        s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
      ) {
        p.???
      }
      status match {
        case ProverStatus.Sat =>
          val partialModel = p.partialModel
          // update string model
          for (singleString <- constraints) {
            singleString.setInterestTermModel(partialModel)
            val value = measure(
              s"${this.getClass.getSimpleName}::findStringModel"
            )(singleString.getModel)
            value match {
              case Some(v) => res.updateModel(singleString.strId, v)
              case None    => throw UnknownException("Cannot find string model")
            }

          }
          // update integer model
          for (term <- integerTerms) {
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

// Encode the final atom constraints to catra input format,
// and then call catra to solve the constraints
class CatraBasedSolver extends FinalConstraintsSolver[CatraFinalConstraints] {

  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomaton]): Unit = {
    addConstraint(catraACs(t, auts))
  }

  def runInstances(arguments: CommandLineOptions): Try[CatraResult] = {
    // only run one file
    val fileName = arguments.inputFiles(0)
    val inputFileHandle = Source.fromFile(fileName)
    val fileContents = inputFileHandle.mkString("")
    inputFileHandle.close()
    val parsed = measure(s"${this.getClass().getSimpleName()}::parsed")(
      InputFileParser.parse(fileContents)
    )
    val result =
      measure(s"${this.getClass().getSimpleName()}::findRegistersModel") {
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
          case _ => Failure(new Exception("Unknown error when parse"))
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
    val lia = conj(FinalConstraints() +: constraints.map(_.getRegsRelation))
    val allIntTerms = (integerTerms ++ constraints.flatMap(
      _.interestTerms
    ) ++ integerTerms ++ SymbolCollector.constants(lia))
      .filterNot(_.isInstanceOf[LinearCombination])
      .toSet
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
      aut: CostEnrichedAutomaton,
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
      aut: CostEnrichedAutomaton,
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
    val lia = conj(FinalConstraints() +: constraints.map(_.getRegsRelation))
    sb.append(lia.toString.replaceAll("&", "&&"))
    sb.append(";\n")
    sb.toString()
  }

  def decodeCatraResult(res: CatraResult): Result = {
    val result = new Result
    res match {
      case Sat(assignments) => {
        val strIntersted = constraints.flatMap(_.interestTerms)
        val name2Term = (strIntersted ++ integerTerms)
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
          val value = measure(
            s"${this.getClass().getSimpleName()}::findStringModel"
          )(singleString.getModel)
          value match {
            case Some(v) => result.updateModel(singleString.strId, v)
            case None    => throw UnknownException("Cannot find string model")
          }
        }
        for ((k, v) <- assignments; t <- name2Term.get(k.name)) {
          result.updateModel(t, IdealInt(v))
        }
        result.setStatus(ProverStatus.Sat)
      }
      case OutOfMemory => throw new Exception("Out of memory")
      case Timeout(timeout_ms) =>
        throw new TimeoutException(timeout_ms / 1_000)
      case Unsat => result.setStatus(ProverStatus.Unsat)
      case _     => throw new Exception("Unknown result of catra")
    }
    result
  }

  def solve: Result = {
    if (constraints.isEmpty) {
      val result = new Result
      result.setStatus(ProverStatus.Sat)
      return result
    }
    val interFlie = os.temp(dir = os.pwd, suffix = "hhh")
    val writer = new CatraWriter(interFlie.toString())
    writer.write(toCatraInput)
    writer.close()
    val arguments = CommandLineOptions(
      inputFiles = Seq(interFlie.toString()),
      timeout_ms = Some(OFlags.timeout),
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
    val catraRes = measure(
      s"${this.getClass().getSimpleName()}::findIntegerModel"
    )(runInstances(arguments))
    var result = new Result
    catraRes match {
      case Success(_catraRes) =>
        result = decodeCatraResult(_catraRes)
      case Failure(e) => throw e
    }
    result
  }
}

class BaselineSolver extends FinalConstraintsSolver[BaselineFinalConstraints] {
  def addConstraint(t: Term, auts: Seq[CostEnrichedAutomaton]): Unit = {
    addConstraint(baselineACs(t, auts))
  }

  def solve: Result = {
    val f = conj(constraints.map(_.getCompleteLIA))
    import FinalConstraints.evalTerm
    val res = new Result
    SimpleAPI.withProver { p =>
      p setConstructProofs true
      val regsRelation = conj(constraints.map(_.getRegsRelation))
      val finalArith = conj(f, regsRelation, FinalConstraints())
      val constants =
        SymbolCollector.constants(finalArith) ++ integerTerms

      p addConstants constants

      // p addConstantsRaw initialConstTerms
      p addAssertion finalArith
      val status = measure(
        s"${this.getClass.getSimpleName}::solveFixedFormula::findIntegerModel"
      ) {
        p.???
      }
      status match {
        case ProverStatus.Sat =>
          val partialModel = p.partialModel
          // update string model
          for (singleString <- constraints) {
            singleString.setInterestTermModel(partialModel)
            val value = measure(
              s"${this.getClass.getSimpleName}::findStringModel"
            )(singleString.getModel)
            value match {
              case Some(v) => res.updateModel(singleString.strId, v)
              case None    => throw UnknownException("Cannot find string model")
            }

          }
          // update integer model
          for (term <- integerTerms) {
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
