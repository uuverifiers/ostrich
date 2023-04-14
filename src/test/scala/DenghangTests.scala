import ap.CmdlMain
import ap.DialogUtil.asString
import org.scalacheck.Properties

object DenghangTests extends Properties("DenghangTests") {

  import System.lineSeparator

  val timeout = 30000

  def expectResult[A](expResult: String)(computation: => A): Boolean = {
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

  def checkFile(
      filename: String,
      result: String,
      extractOpts: String*
  ): Boolean =
    expectResult(result) {
      CmdlMain.doMain(
        (List(
          "+assert",
          "-timeout=" + timeout,
          "-stringSolver=ostrich.OstrichStringTheory:+costenriched,-backend=unary",
          filename
        ) ++ extractOpts).toArray,
        false
      )
    }

  def checkFileOpts(
      filename: String,
      result: String,
      ostrichOpts: String,
      extractOpts: String*
  ): Boolean =
    expectResult(result) {
      CmdlMain.doMain(
        (List(
          "+assert",
          "-timeout=" + timeout,
          "-stringSolver=ostrich.OstrichStringTheory:+costenriched,-backend=unary" +
            ostrichOpts,
          filename
        ) ++ extractOpts).toArray,
        false
      )
    }

  property("indexof_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_sat.smt2", "sat")
  property("indexof_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_unsat.smt2", "unsat")
}
