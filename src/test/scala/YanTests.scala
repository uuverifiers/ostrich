package ostrich

import ap.CmdlMain
import ap.DialogUtil.asString

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

object YanTests extends Properties("YanTests") {

  def expectResult[A](expResult : String)(computation : => A) : Boolean = {
    val result = asString {
      Console.withErr(ap.CmdlMain.NullStream) {
        computation
      }
    }

    (result split "\n") contains expResult
  }

  def checkFile(filename : String, result : String,
                extractOpts : String*) : Boolean =
    expectResult(result) {
      CmdlMain.doMain((List("+assert", "-timeout=10000", filename) ++ extractOpts).toArray,
                        false)
    }

/*
  property("tests/yan-benchmarks/concat-001.smt2") =
    checkFile("tests/yan-benchmarks/concat-001.smt2", "sat")
  property("tests/yan-benchmarks/concat-002.smt2") =
    checkFile("tests/yan-benchmarks/concat-002.smt2", "sat")
  property("tests/yan-benchmarks/concat-003.smt2") =
    checkFile("tests/yan-benchmarks/concat-003.smt2", "sat")
  property("tests/yan-benchmarks/concat-004-unsat.smt2") =
    checkFile("tests/yan-benchmarks/concat-004-unsat.smt2", "unsat")
  property("tests/yan-benchmarks/concat-005-unsat.smt2") =
    checkFile("tests/yan-benchmarks/concat-005-unsat.smt2", "unsat")
  property("tests/yan-benchmarks/concat-006.smt2") =
    checkFile("tests/yan-benchmarks/concat-006.smt2", "sat")
  property("tests/yan-benchmarks/concat-007.smt2") =
    checkFile("tests/yan-benchmarks/concat-007.smt2", "sat")
  property("tests/yan-benchmarks/concat-008.smt2") =
    checkFile("tests/yan-benchmarks/concat-008.smt2", "sat")
  property("tests/yan-benchmarks/concat-009.smt2") =
    checkFile("tests/yan-benchmarks/concat-009.smt2", "sat")
  property("tests/yan-benchmarks/concat-010.smt2") =
    checkFile("tests/yan-benchmarks/concat-010.smt2", "sat")
  property("tests/yan-benchmarks/equal-001.smt2") =
    checkFile("tests/yan-benchmarks/equal-001.smt2", "sat")
  property("tests/yan-benchmarks/regex-001.smt2") =
    checkFile("tests/yan-benchmarks/regex-001.smt2", "sat")
  property("tests/yan-benchmarks/regex-002-unsat.smt2") =
    checkFile("tests/yan-benchmarks/regex-002-unsat.smt2", "unsat")
  property("tests/yan-benchmarks/regex-003.smt2") =
    checkFile("tests/yan-benchmarks/regex-003.smt2", "sat")
  property("tests/yan-benchmarks/regex-004-unsat.smt2") =
    checkFile("tests/yan-benchmarks/regex-004-unsat.smt2", "unsat")
  property("tests/yan-benchmarks/regex-005-unsat.smt2") =
    checkFile("tests/yan-benchmarks/regex-005-unsat.smt2", "unsat")
  property("tests/yan-benchmarks/regex-006.smt2") =
    checkFile("tests/yan-benchmarks/regex-006.smt2", "sat")
  // TODO: Yan did not specify which of these are unsat.  I have done a
  // manual pass but may have made mistakes
  property("tests/yan-benchmarks/replaceAll-001.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-001.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-002.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-002.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-003.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-003.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-004.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-004.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-005.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-005.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-006.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-006.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-007.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-007.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-008.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-008.smt2", "unsat")
  property("tests/yan-benchmarks/replaceAll-009.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-009.smt2", "unsat")
  property("tests/yan-benchmarks/replaceAll-010.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-010.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-011.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-011.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-012.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-012.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-013.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-013.smt2", "unsat")
  property("tests/yan-benchmarks/replaceAll-014.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-014.smt2", "unsat")
  property("tests/yan-benchmarks/replaceAll-015.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-015.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-016.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-016.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-017.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-017.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-018.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-018.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-019.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-019.smt2", "unsat")
  property("tests/yan-benchmarks/replaceAll-020.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-020.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-021.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-021.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-022.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-022.smt2", "unsat")
  property("tests/yan-benchmarks/replaceAll-023.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-023.smt2", "unsat")
  property("tests/yan-benchmarks/replaceAll-024.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-024.smt2", "sat")
  property("tests/yan-benchmarks/replaceAll-025.smt2") =
    checkFile("tests/yan-benchmarks/replaceAll-025.smt2", "sat")
*/
}
