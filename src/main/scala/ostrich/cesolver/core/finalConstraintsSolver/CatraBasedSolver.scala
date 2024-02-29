/** This file is part of Ostrich, an SMT solver for strings. Copyright (c) 2023
  * Denghang Hu. All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  * * Redistributions of source code must retain the above copyright notice,
  * this list of conditions and the following disclaimer.
  *
  * * Redistributions in binary form must reproduce the above copyright notice,
  * this list of conditions and the following disclaimer in the documentation
  * and/or other materials provided with the distribution.
  *
  * * Neither the name of the authors nor the names of their contributors may be
  * used to endorse or promote products derived from this software without
  * specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGE.
  */

package ostrich.cesolver.core.finalConstraintsSolver

import ap.api.SimpleAPI.ProverStatus
import ap.parser.{SymbolCollector, PrincessLineariser}
import ap.basetypes.IdealInt
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
import ostrich.OFlags
import java.nio.file.{Files, StandardOpenOption, Paths}
import java.nio.charset.StandardCharsets
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.util.ParikhUtil
import ap.parser.{ITerm, IConstant, IIntLit}
import ostrich.cesolver.util.UnknownException
import ostrich.cesolver.util.TimeoutException
import ostrich.cesolver.util.CatraWriter
import ap.parser.IExpression._
import ap.parser.IFormula
import ostrich.cesolver.core.finalConstraints.CatraFinalConstraints
import ostrich.cesolver.core.finalConstraints.FinalConstraints

class CatraBasedSolver(
    private val inputFormula: IFormula
) extends FinalConstraintsSolver[CatraFinalConstraints] {

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.catraACs(t, auts))
  }

  def runInstances(arguments: CommandLineOptions): Try[CatraResult] = {
    // only run one file
    val fileName = arguments.inputFiles(0)
    val inputFileHandle = Source.fromFile(fileName)
    val fileContents = inputFileHandle.mkString("")
    inputFileHandle.close()
    val parsed =
      ParikhUtil.measure(s"${this.getClass().getSimpleName()}::parsed")(
        InputFileParser.parse(fileContents)
      )
    val result =
      ParikhUtil.measure(
        s"${this.getClass().getSimpleName()}::findRegistersModel"
      ) {
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
    val lia = and(inputFormula +: constraints.map(_.getRegsRelation))
    val liaIntTerms = SymbolCollector.constants(lia)
    val autIntTerms =
      (for (
        constraint <- constraints;
        aut <- constraint.auts;
        IConstant(c) <- aut.registers
      )
        yield c).toSet
    val allIntTerms = liaIntTerms ++ autIntTerms

    if (allIntTerms.isEmpty) return ""

    sb.append("counter int ")
    sb.append(allIntTerms.mkString(", "))
    sb.append(";\n")
    sb.toString()
  }

  def toCatraInputAutomata: String = {
    val sb = new StringBuilder
    for (constraint <- constraints) {
      sb.append("synchronised {\n")
      val autNamePrefix = constraint.strDataBaseId.toString
      for ((aut, i) <- constraint.auts.zipWithIndex) {
        sb.append(toCatraInputAutomaton(aut, autNamePrefix + i))
      }
      sb.append("};\n")
    }
    sb.toString()
  }

  def toCatraInputAutomaton(
      aut: CostEnrichedAutomatonBase,
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
    if (!aut.acceptingStates.isEmpty) {
      sb.append("\taccepting ")
      sb.append(aut.acceptingStates.map("s" + state2Int(_)).mkString(", "))
      sb.append(";\n")
    }
    sb.append("};\n")
    sb.toString()
  }

  def toCatraInputTLabel(lbl: (Char, Char)) = {
    val (c1, c2) = lbl
    s"[${c1.toInt}, ${c2.toInt}]"
  }

  def toCatraInputRegisterUpdate(
      aut: CostEnrichedAutomatonBase,
      update: Seq[Int]
  ) = {
    val sb = new StringBuilder
    sb.append("{")
    val updateStringSeq =
      for ((v, i) <- update.zipWithIndex)
        yield s"${aut.registers(i)} += $v"
    sb.append(updateStringSeq.mkString(", "))
    sb.append("}")
    sb.toString()
  }

  def toCatraInputLIA: String = {
    val sb = new StringBuilder
    // to match the semantic of catra, we need to generate a constraint R = 0 if
    // the automaton only accepts empty string and has register R
    val zeroConstraint =
      and(
        for (
          c <- constraints; aut <- c.auts; reg <- aut.registers;
          if ParikhUtil.isEmptyString(aut)
        )
          yield reg === IIntLit(0)
      )

    val lia = and(
      inputFormula +: constraints.map(_.getRegsRelation) :+ zeroConstraint
    )
    if (lia.isTrue) return ""
    sb.append("constraint ")
    sb.append(
      PrincessLineariser
        .asString(lia)
        .replaceAll("&", "&&")
        .replaceAll("[|]", "||")
    )
    sb.append(";\n")
    sb.toString()
  }

  def decodeCatraResult(res: CatraResult): Result = {
    val result = new Result
    res match {
      case Sat(assignments) => {
        // update integer model
        new StringBuilder
        // lia may contains some string term which should be ignored
        and(inputFormula +: constraints.map(_.getRegsRelation))
        val allIntTerms = integerTerms ++ constraints.flatMap(_.regsTerms)
        val name2Term = allIntTerms.map(t => (t.toString(), t)).toMap

        val termModel =
          (for ((_, t: IConstant) <- name2Term)
            yield (t.asInstanceOf[ITerm] -> IdealInt.ZERO)).toMap ++
            (for (
              (k, v) <- assignments;
              t <- name2Term.get(k.name)
            ) yield (t, IdealInt(v)))

        for ((a, b) <- termModel)
          result.updateModel(a, b)

        // update string model
        for (singleString <- constraints) {
          singleString.setRegTermsModel(termModel)
          val value = ParikhUtil.measure(
            s"${this.getClass().getSimpleName()}::findStringModel"
          )(singleString.getModel)
          value match {
            case Some(v) => result.updateModel(singleString.strDataBaseId, v)
            case None    => throw UnknownException("Cannot find string model")
          }
        }

        // update integer model
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
    var result = new Result
    val catraInputF =
      if (ParikhUtil.debugOpt) Paths.get("catra_input.par")
      else Files.createTempFile("catra_input", ".par")
    try {
      val catraInput = toCatraInput.getBytes(StandardCharsets.UTF_8)
      Files.write(
        catraInputF,
        catraInput,
        StandardOpenOption.CREATE,
        StandardOpenOption.WRITE,
        StandardOpenOption.TRUNCATE_EXISTING
      )
      val arguments = CommandLineOptions(
        inputFiles = Seq(catraInputF.toString()),
        timeout_ms = Some(OFlags.timeout),
        dumpSMTDir = None,
        dumpGraphvizDir = None,
        printDecisions = false,
        runMode = SolveSatisfy,
        // backend = ChooseNuxmv,
        backend = ChooseLazy,
        checkTermSat = true,
        checkIntermediateSat = true,
        eliminateQuantifiers = true,
        dumpEquationDir = None,
        nrUnknownToMaterialiseProduct = 6,
        enableClauseLearning = true,
        enableRestarts = true,
        restartTimeoutFactor = 500L,
        randomSeed = 1234567,
        printProof = false
      )

      val catraRes = ParikhUtil.measure(
        s"${this.getClass().getSimpleName()}::findIntegerModel"
      )(runInstances(arguments))

      catraRes match {
        case Success(_catraRes) =>
          result = decodeCatraResult(_catraRes)
        case Failure(_) => // do nothing as unknown resultå
      }
    } finally {
      if (!ParikhUtil.debugOpt)
        Files.deleteIfExists(catraInputF)
    }
    result
  }
}
