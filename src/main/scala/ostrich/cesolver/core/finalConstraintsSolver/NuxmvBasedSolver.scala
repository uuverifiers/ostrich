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

class NuxmvBasedSolver(
    private val inputFormula: IFormula,
    private val freshIntTerm2orgin: Map[ITerm, ITerm]
) extends FinalConstraintsSolver[NuxmvFinalConstraints] {

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.nuxmvACs(t, auts))
  }

  private val baseCommand = Array("nuxmv", "-int")
  private val Unreachable = """^-- invariant .* is true$""".r
  private val Reachable = """^-- invariant .* is false$""".r
  private val CounterValue = """^ {4}(.*) = (\d+)$""".r

  private val nuxmvCmd = baseCommand

  private val outFile = new File("parikh.smv")

  private def printNUXMVModule(constraints: Seq[NuxmvFinalConstraints]) = {
    val labels = constraints.zipWithIndex.map { case (_, i) =>
      s"l$i"
    }
    val lia = and(inputFormula +: constraints.map(_.getRegsRelation))
    val nuxmvlia =
      lia.toString.replaceAll("true", "TRUE").replaceAll("false", "FALSE")
    val inputVars = SymbolCollector constants lia
    val registers = constraints.flatMap(_.getRegisters)
    // padding one special state for each automaton, the state is reached from accepting states if lia is santisfied
    val paddingOf =
      constraints.flatMap(_.auts).map(a => a -> a.newState()).toMap

    println("MODULE main")

    println("IVAR")
    // input label variable
    for (inputVar <- labels)
      println(s"  $inputVar : integer;")

    println("VAR")
    // state variable for each automaton
    for (c <- constraints; aut <- c.auts) {

      println(
        s"  aut_${c.strId}_${aut.hashCode} : {${(aut.states.toSeq :+ paddingOf(aut)).mkString(", ")}};"
      )
    }
    // integer variable
    for (variable <- inputVars)
      println(s"  $variable : integer;")

    println("ASSIGN")
    // init state variable and integer variable
    for (c <- constraints; aut <- c.auts) {
      println(
        s"  init(aut_${c.strId}_${aut.hashCode}) := ${aut.initialState};"
      )
    }
    for (variable <- registers)
      println(s"  init($variable) := 0;")

    // transitions
    println("TRANS")
    val autsTrans =
      (for (
        (c, l) <- constraints.zip(labels);
        aut <- c.auts;
        (s, a, t, v) <- aut.transitionsWithVec
      ) yield {
        val min = a._1.toInt
        val max = a._2.toInt
        val regsUpdates =
          if (registers.isEmpty)
            "TRUE"
          else
            aut.registers.zipWithIndex
              .map { case (r, i) => s"next($r) = $r + ${v(i)}" }
              .mkString(" & ")
        s"($l >= $min & $l <= $max & aut_${c.strId}_${aut.hashCode} = $s & next(aut_${c.strId}_${aut.hashCode}) = $t & $regsUpdates)"
      }).mkString(" | \n")
    val acceptingToPadding =
      (for (c <- constraints; aut <- c.auts) yield {
        s"((${aut.acceptingStates
            .map(s => s"aut_${c.strId}_${aut.hashCode} = $s")
            .mkString(" | ")}) & next(aut_${c.strId}_${aut.hashCode}) = ${paddingOf(aut)})"
      }).mkString(" | ")
    val metainModel =
      if (inputVars.isEmpty)
        "TRUE"
      else
        inputVars.map(v => s"next($v) = $v").mkString(" & ")
    println(
      s"($autsTrans) | \n(($acceptingToPadding) & ($metainModel) & $nuxmvlia)"
    )
    // invariant
    println("INVARSPEC")
    val accepting = (for (c <- constraints; aut <- c.auts) yield {
      s"aut_${c.strId}_${aut.hashCode} = ${paddingOf(aut)}"
    }).mkString(" & ")
    // If nuxmv finding a counterexample, accepting is true and !(nuxmvlia) is false. So the constraints are satisfiable and the counterexample is a model
    println(s"!($accepting)")
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
    cleanDirectory(new File(outdir))
    for (c <- constraints; aut <- c.auts) {
      aut.toDot(s"nuxmv_aut_${c.strId}_${aut.hashCode}")
    }
    ////////// end of dot file generation
    val lia = and(inputFormula +: constraints.map(_.getRegsRelation))
    val inputVars = (SymbolCollector constants lia).map(Internal2InputAbsy(_))
    val origin2fresh = freshIntTerm2orgin.map(_.swap)
    val originName2FreshITerm = origin2fresh.map { case (k, v) =>
      k.toString -> v
    }
    val name2ITerm =
      inputVars.map(v => v.toString -> v).toMap ++ originName2FreshITerm
    ParikhUtil.debugPrintln(name2ITerm)
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
          case CounterValue(intName, value) if name2ITerm.contains(intName) =>
            // integer model
            result.updateModel(name2ITerm(intName), IdealInt(value))
            true
          case _ => true
        }
      }
      ParikhUtil.todo("Generate model smarter")
      ParikhUtil.todo("Unstable nuxmv, not tested")
      // sat and generate model
      if (result.getStatus == SimpleAPI.ProverStatus.Sat) {
        // update constant integer model
        for ((k, v) <- freshIntTerm2orgin) {
          v match {
            case IExpression.Const(value) => result.updateModel(k, value)
            case _                        =>
          }
        }
        // string model
        val integerModel = result.getModel.map {
          case (i, Model.IntValue(v)) => i -> v
          case _ => throw new Exception("not integer model")
        }.toMap
        for (c <- constraints) {
          c.setInterestTermModel(integerModel)
          c.getModel match {
            case Some(value) => result.updateModel(c.strId, value)
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
