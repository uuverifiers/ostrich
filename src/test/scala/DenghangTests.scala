package ostrich.cesolver

import ap.CmdlMain
import ap.DialogUtil.asString
import org.scalacheck.Properties
import scala.util.Properties.lineSeparator

object Util{
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
      timeout: Int,
      result: String,
      extractOpts: String*
  ): Boolean =
    expectResult(result) {
      CEMain.main(
        (List(
          "+assert",
          "-timeout=" + timeout,
          filename
        ) ++ extractOpts).toArray
      )
    }

}

object CEATests extends Properties("DenghangTests.cea") {
  import Util._

  import System.lineSeparator

  val timeout = 30000

  // integration tests for length
  property("length_sat.smt2") =
    checkFile("tests/hu-benchmarks/length_sat.smt2", timeout, "sat")

  // integration tests for concatenate
  property("concat_sat.smt2") =
    checkFile("tests/hu-benchmarks/concat_sat.smt2", timeout, "sat")
  property("concat_unsat.smt2") =
    checkFile("tests/hu-benchmarks/concat_unsat.smt2", timeout, "unsat")
  property("concat_backjump_bug.smt2") = 
    checkFile("tests/hu-benchmarks/concat_backjump_bug.smt2", timeout, "sat")

  // integration tests for indexof
  property("indexof_const_index_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_index_sat.smt2", timeout, "sat")
  property("indexof_const_index_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_index_unsat.smt2", timeout, "unsat")
  property("indexof_const_startpos_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_startpos_sat.smt2", timeout, "sat")
  property("indexof_const_startpos_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_startpos_unsat.smt2", timeout, "unsat")
  property("indexof_var_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_var_sat.smt2", timeout, "sat")
  property("indexof_var_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_var_unsat.smt2", timeout, "unsat")
  property("indexof_empty_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_empty_sat.smt2", timeout, "sat")
  property("indexof_empty_sat2.smt2") =
    checkFile("tests/hu-benchmarks/indexof_empty_sat2.smt2", timeout, "sat")
  property("indexof_empty_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_empty_unsat.smt2", timeout, "unsat")

  // integration tests for substring
  property("substr_const_begin_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_begin_sat.smt2", timeout, "sat")
  property("substr_const_begin_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_begin_unsat.smt2", timeout, "unsat")
  property("substr_const_len_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_len_sat.smt2", timeout, "sat")
  property("substr_const_len_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_len_unsat.smt2", timeout, "unsat")
  property("substr_var_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_var_sat.smt2", timeout, "sat")
  property("substr_var_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_var_unsat.smt2", timeout, "unsat")
  property("substr_empty_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_empty_sat.smt2", timeout, "sat")
  property("substr_empty_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_empty_unsat.smt2", timeout, "unsat")
  property("regex_counting_unsat.smt2") =
    checkFile("tests/hu-benchmarks/regex_counting_unsat.smt2", timeout, "unsat")

  // integration tests for replace
  property("replace-length.smt2") =
    checkFile("tests/replace-length.smt2", timeout,"sat")
  property("replace-length-2.smt2") =
    checkFile("tests/replace-length-2.smt2", timeout, "sat")
  property("bug-56-replace-bug2.smt2") =
    checkFile("tests/bug-56-replace-bug2.smt2", timeout, "sat")
  property("bug-58-replace-re") =
    checkFile("tests/bug-58-replace-re.smt2", timeout, "sat")

}

object NuxmvTests extends Properties("DenghangTests.nuxmv"){
  import Util._

  import System.lineSeparator

  val timeout = 30000

  // integration tests for length
  property("length_sat.smt2") =
    checkFile("tests/hu-benchmarks/length_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")

  // integration tests for concatenate
  property("concat_sat.smt2") =
    checkFile("tests/hu-benchmarks/concat_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("concat_unsat.smt2") =
    checkFile("tests/hu-benchmarks/concat_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("concat_backjump_bug.smt2") = 
    checkFile("tests/hu-benchmarks/concat_backjump_bug.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")

  // integration tests for indexof
  property("indexof_const_index_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_index_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_const_index_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_index_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_const_startpos_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_startpos_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_const_startpos_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_const_startpos_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_var_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_var_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_var_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_var_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_empty_sat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_empty_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_empty_sat2.smt2") =
    checkFile("tests/hu-benchmarks/indexof_empty_sat2.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("indexof_empty_unsat.smt2") =
    checkFile("tests/hu-benchmarks/indexof_empty_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")

  // integration tests for substring
  property("substr_const_begin_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_begin_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("substr_const_begin_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_begin_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("substr_const_len_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_len_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("substr_const_len_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_const_len_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("substr_var_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_var_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("substr_var_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_var_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("substr_empty_sat.smt2") =
    checkFile("tests/hu-benchmarks/substr_empty_sat.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("substr_empty_unsat.smt2") =
    checkFile("tests/hu-benchmarks/substr_empty_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  
  // nuxmv timeout
  // property("regex_counting_unsat.smt2") =
  //   checkFile("tests/hu-benchmarks/regex_counting_unsat.smt2", timeout, "unsat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")

  // integration tests for replace
  property("replace-length.smt2") =
    checkFile("tests/replace-length.smt2", timeout,"sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("replace-length-2.smt2") =
    checkFile("tests/replace-length-2.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("bug-56-replace-bug2.smt2") =
    checkFile("tests/bug-56-replace-bug2.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
  property("bug-58-replace-re") =
    checkFile("tests/bug-58-replace-re.smt2", timeout, "sat", "-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory:-backend=nuxmv")
}
