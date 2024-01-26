import ap.CmdlMain
import ap.DialogUtil.asString
import org.scalacheck.Prop._
import org.scalacheck.Properties
import ostrich.SMTLIBTests.{checkFileOpts, property}

object PropagationTests extends Properties("PropagationTests") {

  import System.lineSeparator

  val timeout = 30000

  def expectResult[A](expResult : String)(computation : => A) : Boolean = {
    val result = asString {
      Console.withErr(ap.CmdlMain.NullStream) {
        computation
      }
    }

    expResult match {
      case "error" =>
        result contains "error"
      case res =>
        (result split lineSeparator) contains res
    }
  }

  def checkFile(filename : String, result : String,
                extractOpts : String*) : Boolean =
    expectResult(result) {
      CmdlMain.doMain((List("+assert", "-timeout=" + timeout,
                            "-stringSolver=ostrich.OstrichStringTheory",
                            filename) ++ extractOpts).toArray,
                        false)
    }

  def checkFileOpts(filename : String, result : String, ostrichOpts : String,
                    extractOpts : String*) : Boolean =
    expectResult(result) {
      CmdlMain.doMain((List("+assert", "-timeout=" + timeout,
                            "-stringSolver=ostrich.OstrichStringTheory:" +
                               ostrichOpts,
                            filename) ++ extractOpts).toArray,
                        false)
    }

  property("noodles-unsat.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat.smt2", "unknown", "", "-timeout=3000")
  property("noodles-unsat.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat.smt2", "unknown", "+forward", "-timeout=3000")
  property("noodles-unsat.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat.smt2", "unsat", "+forwardBackward")
  property("noodles-unsat2.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat2.smt2", "unsat", "+forwardBackward")
  property("noodles-unsat3.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat3.smt2", "unsat", "+forwardBackward")
  property("noodles-unsat4.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat4.smt2", "unsat", "+forwardBackward")
  property("noodles-unsat5.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat5.smt2", "unsat", "+forwardBackward")/*
  property("noodles-unsat6.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat6.smt2", "unsat", "+forwardBackward")
  property("noodles-unsat7.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat7.smt2", "unsat", "+forwardBackward")
  property("noodles-unsat8.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat8.smt2", "unsat", "+forwardBackward")
  property("noodles-unsat9.smt2") =
    checkFileOpts("tests/propagation-benchmarks/noodles-unsat9.smt2", "unsat", "+forwardBackward")
  property("word-equation-6.smt2") =
    checkFileOpts("tests/propagation-benchmarks/word-equation-6.smt2", "unknown", "+forwardBackward","-timeout=3000")
  property("03_track_1.smt2") =
    checkFileOpts("tests/propagation-benchmarks/03_track_1.smt2", "unsat", "+forwardOnly")
  property("03_track_10.smt2.smt2") =
    checkFileOpts("tests/propagation-benchmarks/03_track_10.smt2", "unsat", "+forwardOnly")
  property("03_track_11.smt2.smt2") =
    checkFileOpts("tests/propagation-benchmarks/03_track_11.smt2", "unsat", "+forwardOnly")*/
}
