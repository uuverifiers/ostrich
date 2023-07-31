package ostrich.cesolver.core.finalConstraintsSolver

import ap.parser.{ITerm, IFormula}
import ap.parser.IExpression._

import java.io.File
import java.nio.file.Files

import ostrich.cesolver.core.finalConstraints.{
  FinalConstraints,
  NuxmvFinalConstraints
}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.api.SimpleAPI
import ap.parser.SymbolCollector
import ostrich.cesolver.util.ParikhUtil
import java.io.PrintWriter
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.util.concurrent.TimeUnit
import ap.basetypes.IdealInt
import ap.parser.Internal2InputAbsy
import ostrich.cesolver.core.Model
import ap.parser.IExpression
import java.time.LocalDate
import ap.types.SortedConstantTerm
import ostrich.OstrichStringTheory.OstrichStringSort

class NuxmvBasedSolver(
    private val inputFormula: IFormula
) extends FinalConstraintsSolver[NuxmvFinalConstraints] {

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.nuxmvACs(t, auts))
  }

  private val baseCommand = Array("nuxmv", "-int")
  private val Unreachable = """^.* is true$""".r
  private val Reachable = """^.* is false$""".r
  private val CounterValue = """^ {4}(.*) = (-?\d+)$""".r

  private val nuxmvCmd = baseCommand

  private val outFile =
    if (ParikhUtil.debug)
      new File("nuxmv.smv")
    else
      Files.createTempFile("nuxmv", ".smv").toFile

  private def printNUXMVModule(constraints: Seq[NuxmvFinalConstraints]) = {
    val constraintsIdx = constraints.zipWithIndex.toMap
    val transIdx = constraints
      .flatMap(_.auts)
      .flatMap(_.transitionsWithVec)
      .zipWithIndex
      .toMap
    val labels = constraintsIdx.map { case (_, i) =>
      s"l$i"
    }.toSeq
    val nondeterminControlInputVar = "nondeterminism"
    val lia = and(inputFormula +: constraints.map(_.getRegsRelation))
    val nuxmvlia =
      lia.toString.replaceAll("true", "TRUE").replaceAll("false", "FALSE")
    val integers = (SymbolCollector constants lia)
    // padding one special state for each automaton, the state is reached from accepting states if lia is santisfied
    val paddingOf =
      constraints.flatMap(_.auts).map(a => a -> a.newState()).toMap

    println("MODULE main")

    println("IVAR")
    // input label variable
    for (inputLbl <- labels :+ nondeterminControlInputVar)
      println(s"  $inputLbl : integer;")

    println("VAR")
    // state variable for each automaton
    for (c <- constraints; aut <- c.auts) {
      println(
        s"  aut_${c.strDataBaseId}_${aut.hashCode} : {${(aut.states.toSeq :+ paddingOf(aut))
            .mkString(", ")}};"
      )
    }
    // integer variable
    for (int <- integers)
      println(s"  $int : integer;")

    println("ASSIGN")
    // init integers (contains registers)
    for (int <- integers)
      println(s"  init($int) := 0;")
    for (c <- constraints; aut <- c.auts) {
      // init states and next states
      println(
        s"  init(aut_${c.strDataBaseId}_${aut.hashCode}) := ${aut.initialState};"
      )
      val constraintsidx = constraintsIdx(c)
      println(s"  next(aut_${c.strDataBaseId}_${aut.hashCode}) := case")
      for (s <- aut.states) {
        for ((t, l, v) <- aut.outgoingTransitionsWithVec(s)) {
          val transidx = transIdx((s, l, t, v))
          println(
            s"    aut_${c.strDataBaseId}_${aut.hashCode} = $s & ${labels(
                constraintsidx
              )} >= ${l._1.toInt} & ${labels(constraintsidx)} <= ${l._2.toInt} & $nondeterminControlInputVar = $transidx: $t;"
          )
        }
        println(s"    aut_${c.strDataBaseId}_${aut.hashCode} = $s: $s;")
      }
      println(s"    esac;")

      // next registers
      if (aut.registers.nonEmpty) {
        for ((reg, i) <- aut.registers.zipWithIndex) {
          println(s"  next($reg) := case")
          for ((s, l, t, v) <- aut.transitionsWithVec) {
            val transidx = transIdx((s, l, t, v))
            println(
              s"    aut_${c.strDataBaseId}_${aut.hashCode} = $s & ${labels(
                  constraintsidx
                )} >= ${l._1.toInt} & ${labels(constraintsidx)} <= ${l._2.toInt} & $nondeterminControlInputVar = $transidx: $reg + ${v(i)};"
            )
          }
          println(s"    TRUE: $reg;")
          println(s"    esac;")
        }
      }
    }

    // invariant
    val accepting = (for (c <- constraints; aut <- c.auts) yield {
      val acceptingStates = aut.acceptingStates
      s"(${acceptingStates.map(s => s"aut_${c.strDataBaseId}_${aut.hashCode} = $s").mkString(" | ")})"
    }).mkString(" & ")
    println("INVARSPEC")
    println(s"  ($accepting) -> !($nuxmvlia);")
  }

  def solve: Result = {
    if (constraints.isEmpty) return Result.ceaSatResult
    // remove dot files directory and generate them
    def cleanDirectory(directory: File): Unit = {
      if (directory.exists()) {
        val files = directory.listFiles()
        if (files != null) {
          for (file <- files) {
            if (file.isDirectory) {
              cleanDirectory(file)
            } else {
              file.delete()
            }
          }
        }
        directory.delete()
      }
    }
    val outdir = "dot" + File.separator + LocalDate.now().toString
    if (ParikhUtil.debug) cleanDirectory(new File(outdir))
    for (c <- constraints; aut <- c.auts) {
      aut.toDot(s"nuxmv_aut_${c.strDataBaseId}_${aut.hashCode}")
    }
    ////////// end of dot file generation
    val lia = and(inputFormula +: constraints.map(_.getRegsRelation))
    // val inputVars = SymbolCollector constants lia
    val allIntTerms = integerTerms ++ constraints.flatMap(_.regsTerms)
    val name2ITerm =
      allIntTerms.map(v => v.toString -> v).toMap
    val res = {
      val result = new Result
      val out = new java.io.FileOutputStream(outFile)
      Console.withOut(out) {
        printNUXMVModule(constraints)
      }
      out.close()

      val process = Runtime.getRuntime.exec(nuxmvCmd)
      val stdin = process.getOutputStream
      val stderr = process.getErrorStream
      val stdout = process.getInputStream

      val stdinWriter = new PrintWriter(new OutputStreamWriter(stdin))
      val stdoutReader = new BufferedReader(new InputStreamReader(stdout))

      def sendCommand(cmd: String): Unit = {
        stdinWriter.println(cmd)
        stdinWriter.flush()
      }

      def readLine: String = stdoutReader.readLine

      sendCommand("read_model -i " + outFile + ";")
      sendCommand("flatten_hierarchy;")
      sendCommand("encode_variables;")
      sendCommand("go_msat;")
      sendCommand("check_invar_ic3;")
      sendCommand("quit;")

      var cont = true

      while (cont) {
        ap.util.Timeout.check
        cont = readLine match {
          case null =>
            // The process has closed the stream. Wait for it to finish, but
            // don't wait for too long and kill it if it's too slow.
            val didExit = process.waitFor(1, TimeUnit.SECONDS)
            if (!didExit) {
              // Wait for the process to really, really exit.
              process.destroyForcibly().waitFor()
            }
            false // We're done!
          case Unreachable() =>
            result.setStatus(SimpleAPI.ProverStatus.Unsat)
            false // There's nothing more to parse.
          case Reachable() =>
            result.setStatus(SimpleAPI.ProverStatus.Sat)
            true // Capture the model assignment
          case CounterValue(intName, value) =>
            // integer model
            if (name2ITerm.contains(intName)) {
              // filter string term in input lia formula
              result.updateModel(name2ITerm(intName), IdealInt(value))
            }
            true
          case _ => true
        }
      }
      ParikhUtil.todo("Generate model smarter. Unstable nuxmv implementation.")
      // sat and generate model
      if (result.getStatus == SimpleAPI.ProverStatus.Sat) {
        // string model
        val integerModel = result.getModel.map {
          case (i, Model.IntValue(v)) => i -> v
          case _ => throw new Exception("not integer model")
        }.toMap
        for (c <- constraints) {
          c.setRegTermsModel(integerModel)
          c.getModel match {
            case Some(value) => result.updateModel(c.strDataBaseId, value)
            case None => throw new Exception("fail to generate string model")
          }
        }
      }

      // close stream
      stdinWriter.close()
      stdoutReader.close()
      stderr.close()
      result
    }
    res
  }
}
