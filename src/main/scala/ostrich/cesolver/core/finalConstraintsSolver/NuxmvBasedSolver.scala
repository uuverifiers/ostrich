package ostrich.cesolver.core.finalConstraintsSolver

import ap.parser.{ITerm, IFormula}
import ap.parser.IExpression._

import java.nio.file.{Files, StandardOpenOption, Paths, Path}
import java.nio.charset.StandardCharsets

import ostrich.cesolver.core.finalConstraints.{
  FinalConstraints,
  NuxmvFinalConstraints
}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.api.SimpleAPI
import ap.parser.SymbolCollector
import ostrich.cesolver.util.ParikhUtil
import ap.basetypes.IdealInt
import ostrich.cesolver.core.Model
import scala.sys.process._
import ostrich.OFlags
import ostrich.cesolver.util.UnknownException
import ap.parser.IBinJunctor

class NuxmvBasedSolver(
    val flags: OFlags,
    val inputFormula: IFormula
) extends FinalConstraintsSolver[NuxmvFinalConstraints] {

  private var count = 0 // for debug

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.nuxmvACs(t, auts))
  }

  private val Unreachable = """^.* is true$""".r
  private val Reachable = """^.* is false$""".r
  private val CounterValue = """^ {4}(.*) = (-?\d+)$""".r

  private def printNUXMVModule(constraints: Seq[NuxmvFinalConstraints]) : String = {
    val sb = new StringBuilder
    val constraintsIdx = constraints.zipWithIndex.toMap
    val autIdx = constraints.flatMap(_.auts).zipWithIndex.toMap
    val labels = constraintsIdx.map { case (_, i) =>
      s"l$i"
    }.toSeq
    val lia = connectSimplify(inputFormula +: constraints.map(_.getRegsRelation), IBinJunctor.And)
    Boolean2IFormula(true)
    val regsRelationAndInputLIA =
      lia.toString.replaceAll("true", "TRUE").replaceAll("false", "FALSE")
    val integers = (SymbolCollector constants lia)
    // padding one trap state for each automaton, should be unique to other states
    var maxStateIdx = 0
    for (c <- constraints; aut <- c.auts; state <- aut.states) {
      val idx = state.toString().substring(1).toInt
      maxStateIdx = idx max maxStateIdx
    }
    val trapState =
      s"s${maxStateIdx + 1}" // trap state, stand for unique accepting state  
    
    sb.append("MODULE main\n")
    sb.append("IVAR\n")
    // input label variable
    for (inputLbl <- labels)
      sb.append(s"  $inputLbl : 0..65536;\n")

    sb.append("VAR\n")
    // state variable for each automaton
    for (c <- constraints; aut <- c.auts) {
      sb.append(
        s"  aut_${c.strDataBaseId}_${autIdx(aut)} : {${(aut.states.toSeq :+ trapState)
            .mkString(", ")}};\n"
      )
    }
    // integer variable
    for (int <- integers) {
      if (flags.NuxmvBackend == OFlags.NuxmvBackend.Bmc)
        sb.append(s"  $int : -1..20;\n")
      else
        sb.append(s"  $int : integer;\n")
    }

    sb.append("ASSIGN\n")
    // init integers (contains registers)
    for (int <- integers)
      sb.append(s"  init($int) := 0;\n")
    for (c <- constraints; aut <- c.auts) {
      // init states
      sb.append(
        s"  init(aut_${c.strDataBaseId}_${autIdx(aut)}) := ${aut.initialState};\n"
      )
    }
    // transitions for each automaton
    for (c <- constraints; aut <- c.auts) {
      val identityUpdateRegs = aut.registers
        .map { r =>
          s"next($r) = $r"
        }
        .mkString(" & ")
      val identityUpdateRegsNuxmv =
        if (identityUpdateRegs.isEmpty) "TRUE"
        else identityUpdateRegs
      sb.append(s"TRANS  ")
      if (aut.transitionsWithVec.isEmpty) {
        // special case: no transition
        if (aut.isAccept(aut.initialState)) {
          sb.append(
            s"((aut_${c.strDataBaseId}_${autIdx(aut)} = ${aut.initialState} & ${labels(
                constraintsIdx(c)
              )} = 65536) & $identityUpdateRegsNuxmv & next(aut_${c.strDataBaseId}_${autIdx(aut)}) = $trapState)"
          )
        } else {
          sb.append(
            s"((aut_${c.strDataBaseId}_${autIdx(aut)} = ${aut.initialState} & ${labels(
                constraintsIdx(c)
              )} = 65536) & $identityUpdateRegsNuxmv & next(aut_${c.strDataBaseId}_${autIdx(aut)}) = ${aut.initialState})"
          )
        }
      } else {
        sb.append(
          aut.transitionsWithVec
            .map {
              case (s, (min, max), t, v) => {
                val updateRegs = aut.registers
                  .zip(v)
                  .map { case (r, update) => s"next($r) = $r + $update" }
                  .mkString(" & ")
                val updateRegsNuxmv =
                  if (updateRegs.isEmpty) "TRUE" else updateRegs
                s"((aut_${c.strDataBaseId}_${autIdx(aut)} = $s & ${labels(
                    constraintsIdx(c)
                  )} >= ${min.toInt} & ${labels(constraintsIdx(c))} <= ${max.toInt} & $updateRegsNuxmv) & next(aut_${c.strDataBaseId}_${autIdx(aut)}) = $t)"
              }
            }
            .mkString(" | ")
        )
        // epsilon transition from accepting state to unique accepting state (trap state), use 65536 as epsilon label
        if (aut.acceptingStates.nonEmpty) {
          sb.append(" | ")
          sb.append(
            aut.acceptingStates
              .map(s =>
                s"((aut_${c.strDataBaseId}_${autIdx(aut)} = $s & ${labels(
                    constraintsIdx(c)
                  )} = 65536 & $identityUpdateRegsNuxmv) & next(aut_${c.strDataBaseId}_${autIdx(aut)}) = $trapState)"
              )
              .mkString(" | ")
          )
        }
      }
      // self loop for trap state
      sb.append(
        s" | ((aut_${c.strDataBaseId}_${autIdx(aut)} = $trapState & ${labels(
            constraintsIdx(c)
          )} = 65536 & $identityUpdateRegsNuxmv) & next(aut_${c.strDataBaseId}_${autIdx(aut)}) = $trapState);\n"
      )

    }

    // invariant
    val accepting =
      (for (c <- constraints; aut <- c.auts)
        yield {
          s"aut_${c.strDataBaseId}_${autIdx(aut)} = $trapState"
        }).mkString(" & ")
    sb.append("INVARSPEC\n")
    sb.append(s"  ($accepting) -> !($regsRelationAndInputLIA);\n")
    sb.toString()
  }

  def solveWithoutGenerateModel(nuxmvBackend: OFlags.NuxmvBackend.Value): Result = {
    if (constraints.isEmpty) return Result.ceaSatResult
    for (c <- constraints; aut <- c.auts; if ParikhUtil.debugOpt) {
      aut.toDot(s"nuxmv_aut_${c.strDataBaseId}_${count}")
      count += 1
    }
    ////////// end of dot file generation
    connectSimplify(inputFormula +: constraints.map(_.getRegsRelation), IBinJunctor.And)
    // val inputVars = SymbolCollector constants lia
    val allIntTerms = integerTerms ++ constraints.flatMap(_.regsTerms)
    val name2ITerm =
      allIntTerms.map(v => v.toString -> v).toMap
    val result = new Result
    val nuxmvInputF =
      if (ParikhUtil.debugOpt)
        Paths.get("nuxmv_input.smv")
      else
        Files.createTempFile("nuxmv_input", ".smv")
    try {
      val root = new java.io.File(".").getCanonicalPath
      val bmcPath = Paths.get(root, "nuxmv_config", "bmc_source")
      val ic3Path = Paths.get(root, "nuxmv_config", "ic3_source")
      val nuxmvCmd =
        if (nuxmvBackend == OFlags.NuxmvBackend.Bmc)
          Seq("nuxmv", "-source", bmcPath.toString(), nuxmvInputF.toString())
        else
          Seq("nuxmv", "-source", ic3Path.toString(), nuxmvInputF.toString())
      val nuxmvInput = printNUXMVModule(constraints).getBytes(StandardCharsets.UTF_8)
      Files.write(
        nuxmvInputF,
        nuxmvInput,
        StandardOpenOption.CREATE,
        StandardOpenOption.WRITE,
        StandardOpenOption.TRUNCATE_EXISTING
      )

      val errLogger = ProcessLogger(_ => (), _ => ())

      val nuxmvResLines = nuxmvCmd.!!(errLogger).split(System.lineSeparator())
      ap.util.Timeout.check

      for (line <- nuxmvResLines) {
        line match {
          case Unreachable() =>
            result.setStatus(SimpleAPI.ProverStatus.Unsat)
          case Reachable() =>
            result.setStatus(SimpleAPI.ProverStatus.Sat)
          case CounterValue(intName, value) =>
            // integer model
            if (name2ITerm.contains(intName)) {
              // filter string term in input lia formula
              result.updateModel(name2ITerm(intName), IdealInt(value))
            }
          case _ => // do nothing
        }
      }
    } catch {
      case e: Throwable =>
        throw UnknownException(e.toString())
    } finally {
      if (!ParikhUtil.debugOpt) {
        Files.deleteIfExists(nuxmvInputF)
      }
    }
    result
  }

  def solve: Result = {
    val result = solveWithoutGenerateModel(flags.NuxmvBackend)
    // sat and generate model
    if (result.getStatus == SimpleAPI.ProverStatus.Sat) {
      // integer model
      val integerModel = result.getModel.map {
        case (i, Model.IntValue(v)) => i -> v
        case _                      => throw new Exception("not integer model")
      }.toMap
      ParikhUtil.log(s"Nuxmv backend solver integerModel: $integerModel")
      // string model
      for (c <- constraints) {
        c.setRegTermsModel(integerModel)
        c.getModel match {
          case Some(value) => 
            c.auts.reduce{(aut1, aut2) => aut1.asInstanceOf[CostEnrichedAutomatonBase] product aut2}.toDot(c.strDataBaseId.toString())
            result.updateModel(c.strDataBaseId, value)
          case None        => // do nothing as unknown result
          // throw new Exception("fail to generate string model")
        }
      }
    }
    result
  }
}
