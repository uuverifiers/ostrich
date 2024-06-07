import ap.CmdlMain
import ap.DialogUtil.asString
import org.scalacheck.Prop._
import org.scalacheck.Properties
import ostrich.SMTLIBTests.{checkFileOpts, property}

object PropagationTests extends Properties("PropagationTests") {

  import System.lineSeparator

  val timeout = 60000

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
      checkFileOpts("tests/propagation-benchmarks/noodles-unsat.smt2", "unsat", "+forwardPropagation,+backwardPropagation,-nielsenSplitter")
    property("noodles-unsat2.smt2") =
      checkFileOpts("tests/propagation-benchmarks/noodles-unsat2.smt2", "unsat", "+forwardPropagation,+backwardPropagation,-nielsenSplitter")
    property("noodles-unsat3.smt2") =
      checkFileOpts("tests/propagation-benchmarks/noodles-unsat3.smt2", "unsat", "+forwardPropagation,+backwardPropagation,-nielsenSplitter")
    property("noodles-unsat4.smt2") =
      checkFileOpts("tests/propagation-benchmarks/noodles-unsat4.smt2", "unsat", "+forwardPropagation,+backwardPropagation,-nielsenSplitter")

}
