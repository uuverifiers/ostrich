package ostrich

import ap.CmdlMain
import ap.DialogUtil.asString

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

object SMTLIBTests extends Properties("SMTLIBTests") {

  val timeout = 20000

  def expectResult[A](expResult : String)(computation : => A) : Boolean = {
    val result = asString {
      Console.withErr(ap.CmdlMain.NullStream) {
        computation
      }
    }

    expResult match {
      case "error" =>
        (result split "\n") exists { str => str contains "error" }
      case res =>
        (result split "\n") contains res
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

  property("propagation.smt2") =
    checkFileOpts("tests/propagation.smt2", "sat", "", "+model")

  property("case-insensitive.smt2") =
    checkFile("tests/case-insensitive.smt2", "sat")
  property("case-insensitive-2.smt2") =
    checkFile("tests/case-insensitive-2.smt2", "unsat")

  property("str.from_int.smt2") =
    checkFile("tests/str.from_int.smt2", "sat")
  property("str.from_int_2.smt2") =
    checkFile("tests/str.from_int_2.smt2", "unsat")
  property("str.to_int.smt2") =
    checkFile("tests/str.to_int.smt2", "sat")
  property("str.to_int_2.smt2") =
    checkFile("tests/str.to_int_2.smt2", "unsat")

  property("chars.smt2") =
    checkFile("tests/chars.smt2", "sat")
  property("chars2.smt2") =
    checkFile("tests/chars2.smt2", "sat")
  property("chars3.smt2") =
    checkFile("tests/chars3.smt2", "sat")

  property("concat-regex.smt2") =
    checkFile("tests/concat-regex.smt2", "sat")
  property("concat-regex2.smt2") =
    checkFile("tests/concat-regex2.smt2", "unsat")
  property("concat-regex3.smt2") =
    checkFile("tests/concat-regex3.smt2", "sat")
  property("concat-regex4.smt2") =
    checkFile("tests/concat-regex4.smt2", "sat")
  property("empty-union.smt2") =
    checkFile("tests/empty-union.smt2", "sat")

  property("non-greedy-quantifiers.smt2") =
    checkFile("tests/non-greedy-quantifiers.smt2", "sat")
  property("anchor-1.smt2") =
    checkFile("tests/anchor-1.smt2", "sat")
  property("anchor-2.smt2") =
    checkFile("tests/anchor-2.smt2", "sat")
  property("anchor-3.smt2") =
    checkFile("tests/anchor-3.smt2", "unsat")
  property("anchor-4.smt2") =
    checkFile("tests/anchor-4.smt2", "sat")
  property("anchor-5.smt2") =
    checkFile("tests/anchor-5.smt2", "sat")
  property("anchor-6.smt2") =
    checkFile("tests/anchor-6.smt2", "unsat")
  property("anchor-7.smt2") =
    checkFile("tests/anchor-7.smt2", "sat")

  property("regex_cg.smt2") =
    checkFile("tests/regex_cg.smt2", "sat")
  property("regex_cg_2.smt2") =
    checkFile("tests/regex_cg_2.smt2", "sat")
  property("regex_cg_3.smt2") =
    checkFile("tests/regex_cg_3.smt2", "sat")
  property("regex_cg_4.smt2") =
    checkFile("tests/regex_cg_4.smt2", "unsat")
  property("regex_cg_5.smt2") =
    checkFile("tests/regex_cg_5.smt2", "unsat")
  property("regex_cg_6.smt2") =
    checkFile("tests/regex_cg_6.smt2", "sat")
  property("regex_cg_ref.smt2") =
    checkFile("tests/regex_cg_ref.smt2", "sat")
  property("regex_cg_ref2.smt2") =
    checkFile("tests/regex_cg_ref2.smt2", "sat")
  property("regex_cg_ref3.smt2") =
    checkFile("tests/regex_cg_ref3.smt2", "sat")
  property("regex_cg_ref4.smt2") =
    checkFile("tests/regex_cg_ref4.smt2", "sat")

  property("concat-regex.smt2 eager") =
    checkFileOpts("tests/concat-regex.smt2", "sat", "+eager")
  property("concat-regex2.smt2 eager") =
    checkFileOpts("tests/concat-regex2.smt2", "unsat", "+eager")
  property("concat-regex3.smt2 eager") =
    checkFileOpts("tests/concat-regex3.smt2", "sat", "+eager")
  property("concat-regex4.smt2 eager") =
    checkFileOpts("tests/concat-regex4.smt2", "sat", "+eager")

  property("priorityTransducer.smt2") =
    checkFile("tests/priorityTransducer.smt2", "unsat")
  property("priorityTransducer2.smt2") =
    checkFile("tests/priorityTransducer2.smt2", "sat")
  property("priorityTransducer3.smt2") =
    checkFile("tests/priorityTransducer3.smt2", "sat")
  property("priorityTransducer4.smt2") =
    checkFile("tests/priorityTransducer4.smt2", "unsat")

  property("loop.smt2") =
    checkFile("tests/loop.smt2", "sat")
  property("loop2.smt2") =
    checkFile("tests/loop2.smt2", "unsat")

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

  property("test-replace-regex.smt2") =
    checkFile("tests/test-replace-regex.smt2", "sat")
  property("test-replace-regex2.smt2") =
    checkFile("tests/test-replace-regex2.smt2", "unsat")

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
  property("transducer1b.smt2") =
    checkFile("tests/transducer1b.smt2", "sat")
  property("transducer1c.smt2") =
    checkFile("tests/transducer1c.smt2", "sat")
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

  property("extract-1.smt2") =
    checkFile("tests/extract-1.smt2", "unsat")
  property("extract-1b.smt2") =
    checkFile("tests/extract-1b.smt2", "unsat")
  property("extract-1c.smt2") =
    checkFile("tests/extract-1c.smt2", "sat")

  property("extract-cg.smt2") =
    checkFile("tests/extract-cg.smt2", "sat")
  property("extract-cg2.smt2") =
    checkFile("tests/extract-cg2.smt2", "unsat")
  property("extract-cg3.smt2") =
    checkFile("tests/extract-cg3.smt2", "sat")

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

  property("escapeSequences-1a.smt2") =
    checkFile("tests/escapeSequences-1a.smt2", "unsat")
  property("escapeSequences-1b.smt2") =
    checkFile("tests/escapeSequences-1b.smt2", "sat")

  property("len-bug.smt2") =
    checkFile("tests/len-bug.smt2", "unsat")

  property("prefix.smt2") =
    checkFile("tests/prefix.smt2", "sat")
  property("prefix2.smt2") =
    checkFile("tests/prefix2.smt2", "unsat")
  property("prefix3.smt2") =
    checkFile("tests/prefix3.smt2", "sat")

  property("str.at.smt2") =
    checkFile("tests/str.at.smt2", "sat")
  property("str.at-2.smt2") =
    checkFile("tests/str.at-2.smt2", "unsat")
  property("str.at-bug.smt2") =
    checkFile("tests/str.at-bug.smt2", "sat")

  property("email-regex.smt2") =
    checkFile("tests/email-regex.smt2", "sat")
  property("name-regex.smt2") =
    checkFile("tests/name-regex.smt2", "unsat")
  property("brackets-regex.smt2") =
    checkFile("tests/brackets-regex.smt2", "sat")

  property("indexof.smt2") =
    checkFile("tests/indexof.smt2", "sat")
  property("substring.smt2") =
    checkFile("tests/substring.smt2", "sat")
  property("substring-bug.smt2") =
    checkFile("tests/substring-bug.smt2", "sat")

  property("parse-regex.smt2") =
    checkFile("tests/parse-regex.smt2", "sat")
  property("parse-regex2.smt2") =
    checkFile("tests/parse-regex2.smt2", "sat")
  property("parse-regex3.smt2") =
    checkFile("tests/parse-regex3.smt2", "unsat")
  property("parse-regex2b.smt2") =
    checkFile("tests/parse-regex2b.smt2", "unsat")
  property("parse-regex4.smt2") =
    checkFile("tests/parse-regex4.smt2", "sat")

  property("parse-ecma-cases.smt2") =
    checkFile("tests/parse-ecma-cases.smt2", "unsat")
  property("parse-ecma-groups.smt2") =
    checkFile("tests/parse-ecma-groups.smt2", "sat")
  property("parse-ecma-replace.smt2") =
    checkFile("tests/parse-ecma-replace.smt2", "sat")
  property("parse-ecma-bug1.smt2") =
    checkFile("tests/parse-ecma-bug1.smt2", "sat")

  property("parse-regex-lookahead.smt2") =
    checkFile("tests/parse-regex-lookahead.smt2", "sat")
  property("parse-regex-lookahead2.smt2") =
    checkFile("tests/parse-regex-lookahead2.smt2", "sat")
  property("parse-regex-lookahead2b.smt2") =
    checkFile("tests/parse-regex-lookahead2b.smt2", "unsat")
  property("parse-regex-lookahead3.smt2") =
    checkFile("tests/parse-regex-lookahead3.smt2", "sat")
  property("parse-regex-lookahead3b.smt2") =
    checkFile("tests/parse-regex-lookahead3b.smt2", "unsat")
  property("parse-regex-lookahead4.smt2") =
    checkFile("tests/parse-regex-lookahead4.smt2", "sat")

  // Negated equations in general are not handled yet, but should
  // not give incorrect results
  property("negated-equation-1.smt2") =
    checkFile("tests/negated-equation-1.smt2", "unsat")
  property("negated-equation-2.smt2") =
    checkFile("tests/negated-equation-2.smt2", "error")
  property("concat-empty.smt2") =
    checkFile("tests/concat-empty.smt2", "unsat")
  property("replace-bug.smt2") =
    checkFile("tests/replace-bug.smt2", "error")

}
