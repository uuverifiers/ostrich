package ostrich.cesolver.core.finalConstraintsSolver

import ap.parser.{ITerm, IFormula}
import ap.parser.IExpression._

import java.io.File

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

class NuxmvBasedSolver(
    val flags: OFlags,
    val inputFormula: IFormula
) extends FinalConstraintsSolver[NuxmvFinalConstraints] {

  private var count = 0 // for debug

  ParikhUtil.debugPrintln("maybe more efficient to use simplified product automaton before nuxmv encoding")

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.nuxmvACs(t, auts))
  }

  private val Unreachable = """^.* is true$""".r
  private val Reachable = """^.* is false$""".r
  private val CounterValue = """^ {4}(.*) = (-?\d+)$""".r

  private def printNUXMVModule(constraints: Seq[NuxmvFinalConstraints]) = {
    val constraintsIdx = constraints.zipWithIndex.toMap
    val autIdx = constraints.flatMap(_.auts).zipWithIndex.toMap
    val labels = constraintsIdx.map { case (_, i) =>
      s"l$i"
    }.toSeq
    val lia = and(inputFormula +: constraints.map(_.getRegsRelation))
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

    println("MODULE main")

    println("IVAR")
    // input label variable
    for (inputLbl <- labels)
      println(s"  $inputLbl : 0..65536;")

    println("VAR")
    // state variable for each automaton
    for (c <- constraints; aut <- c.auts) {
      println(
        s"  aut_${c.strDataBaseId}_${autIdx(aut)} : {${(aut.states.toSeq :+ trapState)
            .mkString(", ")}};"
      )
    }
    // integer variable
    for (int <- integers) {
      if (flags.NuxmvBackend == OFlags.NuxmvBackend.Bmc)
        println(s"  $int : -1..20;")
      else
        println(s"  $int : integer;")
    }

    println("ASSIGN")
    // init integers (contains registers)
    for (int <- integers)
      println(s"  init($int) := 0;")
    for (c <- constraints; aut <- c.auts) {
      // init states
      println(
        s"  init(aut_${c.strDataBaseId}_${autIdx(aut)}) := ${aut.initialState};"
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
      print(s"TRANS  ")
      if (aut.transitionsWithVec.isEmpty) {
        // special case: no transition
        if (aut.isAccept(aut.initialState)) {
          print(
            s"((aut_${c.strDataBaseId}_${autIdx(aut)} = ${aut.initialState} & ${labels(
                constraintsIdx(c)
              )} = 65536) & $identityUpdateRegsNuxmv & next(aut_${c.strDataBaseId}_${autIdx(aut)}) = $trapState)"
          )
        } else {
          print(
            s"((aut_${c.strDataBaseId}_${autIdx(aut)} = ${aut.initialState} & ${labels(
                constraintsIdx(c)
              )} = 65536) & $identityUpdateRegsNuxmv & next(aut_${c.strDataBaseId}_${autIdx(aut)}) = ${aut.initialState})"
          )
        }
      } else {
        print(
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
          print(" | ")
          print(
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
      print(
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
    println("INVARSPEC")
    println(s"  ($accepting) -> !($regsRelationAndInputLIA);")
  }

  def solveWithoutGenerateModel(nuxmvBackend: OFlags.NuxmvBackend.Value): Result = {
    if (constraints.isEmpty) return Result.ceaSatResult
    for (c <- constraints; aut <- c.auts; if ParikhUtil.debug) {
      aut.toDot(s"nuxmv_aut_${c.strDataBaseId}_${count}")
      count += 1
    }
    ////////// end of dot file generation
    and(inputFormula +: constraints.map(_.getRegsRelation))
    // val inputVars = SymbolCollector constants lia
    val allIntTerms = integerTerms ++ constraints.flatMap(_.regsTerms)
    val name2ITerm =
      allIntTerms.map(v => v.toString -> v).toMap
    val result = new Result
    val nuxmvInputF =
      if (ParikhUtil.debug)
        new File("nuxmv.smv")
      else
        File.createTempFile("nuxmv", ".smv")
    try {
      val out = new java.io.FileOutputStream(nuxmvInputF)
      val nuxmvCmd =
        if (nuxmvBackend == OFlags.NuxmvBackend.Bmc)
          Seq("nuxmv", "-source", "bmc_source", nuxmvInputF.toString())
        else
          Seq("nuxmv", "-source", "ic3_source", nuxmvInputF.toString())
      Console.withOut(out) {
        printNUXMVModule(constraints)
      }
      out.close()

      val nuxmvResLines = nuxmvCmd.!!.split(System.lineSeparator())
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
      if (!ParikhUtil.debug) {
        nuxmvInputF.delete()
      }
    }
    result
  }

  def solve: Result = {
    val result = solveWithoutGenerateModel(flags.NuxmvBackend)
    ParikhUtil.todo("Generate model by nuxmv xml output.")
    // sat and generate model
    if (result.getStatus == SimpleAPI.ProverStatus.Sat) {
      // integer model
      val integerModel = result.getModel.map {
        case (i, Model.IntValue(v)) => i -> v
        case _                      => throw new Exception("not integer model")
      }.toMap
      ParikhUtil.debugPrintln(s"integerModel: $integerModel")
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
