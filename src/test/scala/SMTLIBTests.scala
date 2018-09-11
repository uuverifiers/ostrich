package ostrich

import ap.CmdlMain
import ap.DialogUtil.asString

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

object SMTLIBTests extends Properties("SMTLIBTests") {

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
      CmdlMain.doMain((List("+assert", "-timeout=10000",
                            "-stringSolver=ostrich.OstrichStringTheory",
                            filename) ++ extractOpts).toArray,
                        false)
    }

  property("concat-regex.smt2") =
    checkFile("tests/concat-regex.smt2", "sat")
  property("concat-regex2.smt2") =
    checkFile("tests/concat-regex2.smt2", "unsat")
  property("concat-regex3.smt2") =
    checkFile("tests/concat-regex3.smt2", "sat")
  property("concat-regex4.smt2") =
    checkFile("tests/concat-regex4.smt2", "sat")

/*
  property("concat-regex.smt2 eager") =
    checkFile("tests/concat-regex.smt2", "sat", "+eager")
  property("concat-regex2.smt2 eager") =
    checkFile("tests/concat-regex2.smt2", "unsat", "+eager")
  property("concat-regex3.smt2 eager") =
    checkFile("tests/concat-regex3.smt2", "sat", "+eager")
  property("concat-regex4.smt2 eager") =
    checkFile("tests/concat-regex4.smt2", "sat", "+eager")
*/

  property("test-replace.smt2") =
    checkFile("tests/test-replace.smt2", "sat")
  property("test-replace2.smt2") =
    checkFile("tests/test-replace2.smt2", "unsat")

  property("test-replace3.smt2") =
    checkFile("tests/test-replace3.smt2", "sat")
  property("test-replace4.smt2") =
    checkFile("tests/test-replace4.smt2", "unsat")

  property("test-replace-word.smt2") =
    checkFile("tests/test-replace-word.smt2", "sat")
  property("test-replace-word2.smt2") =
    checkFile("tests/test-replace-word2.smt2", "unsat")

/*
  property("test-replace-regex.smt2") =
    checkFile("tests/test-replace-regex.smt2", "sat")
  property("test-replace-regex2.smt2") =
    checkFile("tests/test-replace-regex2.smt2", "unsat")
*/

/*
  property("membership_427.smt2") =
    checkFile("tests/membership_427.smt2", "unsat")
*/

  property("test-reverse.smt2") =
    checkFile("tests/test-reverse.smt2", "sat")
  property("test-reverse2.smt2") =
    checkFile("tests/test-reverse2.smt2", "unsat")

  property("transducer1.smt2") =
    checkFile("tests/transducer1.smt2", "sat")
  property("transducer2.smt2") =
    checkFile("tests/transducer2.smt2", "unsat")
  property("transducer2b.smt2") =
    checkFile("tests/transducer2b.smt2", "unsat")
  property("transducer2c.smt2") =
    checkFile("tests/transducer2c.smt2", "unsat")
  property("transducer2d.smt2") =
    checkFile("tests/transducer2d.smt2", "sat")

  property("1234.corecstrs.readable.smt2") =
    checkFile("tests/1234.corecstrs.readable.smt2", "sat")

/*
  property("extract-1.smt2") =
    checkFile("tests/extract-1.smt2", "unsat")
  property("extract-1b.smt2") =
    checkFile("tests/extract-1b.smt2", "unsat")
  property("extract-1c.smt2") =
    checkFile("tests/extract-1c.smt2", "sat")
*/

  property("simple-cvc-smtlib.smt2") =
    checkFile("tests/simple-cvc-smtlib.smt2", "sat", "+model")
  property("simple-cvc-smtlib-b.smt2") =
    checkFile("tests/simple-cvc-smtlib-b.smt2", "unsat")
  property("simple-cvc-smtlib-c.smt2") =
    checkFile("tests/simple-cvc-smtlib-c.smt2", "sat", "+model")

/*
  property("simple-cvc-smtlib.smt2 +eager") =
    checkFile("tests/simple-cvc-smtlib.smt2", "sat", "+model", "+eager")
  property("simple-cvc-smtlib-b.smt2 +eager") =
    checkFile("tests/simple-cvc-smtlib-b.smt2", "unsat", "+eager")
  property("simple-cvc-smtlib-c.smt2 +eager") =
    checkFile("tests/simple-cvc-smtlib-c.smt2", "sat", "+model", "+eager")
*/

  property("no-regexes.smt2") =
    checkFile("tests/no-regexes.smt2", "unsat")

  property("adt.smt2") =
    checkFile("tests/adt.smt2", "sat")
  property("adt2.smt2") =
    checkFile("tests/adt2.smt2", "sat")

}
