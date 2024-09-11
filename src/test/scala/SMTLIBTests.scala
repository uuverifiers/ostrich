package ostrich

import ap.CmdlMain
import ap.DialogUtil.asString

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._
import ostrich.cesolver.util.ParikhUtil

object SMTLIBTests extends Properties("SMTLIBTests") {

  import System.lineSeparator

  val timeout      = 30000
  val shortTimeout = 3000
  val longTimeout  = 60000

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

  property("prefix-1.smt2") =
    checkFile("tests/prefix-1.smt2", "unsat")
  property("prefix-2.smt2") =
    checkFile("tests/prefix-2.smt2", "sat")

  property("suffix-1.smt2") =
    checkFile("tests/suffix-1.smt2", "unsat")
  property("suffix-2.smt2") =
    checkFile("tests/suffix-2.smt2", "sat")
  property("suffix-3.smt2") =
    checkFile("tests/suffix-3.smt2", "sat")
  property("suffix-4.smt2") =
    checkFile("tests/suffix-4.smt2", "sat")
  property("suffix-5.smt2") =
    checkFile("tests/suffix-5.smt2", "unsat")

  property("prefix-suffix.smt2") =
    checkFile("tests/prefix-suffix.smt2", "unsat")

  property("contains-1.smt2") =
    checkFile("tests/contains-1.smt2", "sat")
  property("contains-2.smt2") =
    checkFile("tests/contains-2.smt2", "sat")
  property("contains-3.smt2") =
    checkFile("tests/contains-3.smt2", "unsat")

  property("word-equation.smt2") =
    checkFile("tests/word-equation.smt2", "sat")
  property("word-equation-2.smt2") =
    checkFile("tests/word-equation-2.smt2", "sat")
  property("word-equation-3.smt2") =
    checkFile("tests/word-equation-3.smt2", "unsat")
  property("word-equation-4.smt2") =
    checkFile("tests/word-equation-4.smt2", "sat")
  property("word-equation-6.smt2") =
    checkFile("tests/word-equation-6.smt2", "sat")

  property("parikh-constraints.smt2") =
    checkFileOpts("tests/parikh-constraints.smt2", "sat", "+parikh")

  property("replace-special.smt2") =
    checkFile("tests/replace-special.smt2", "unsat")
  property("replace-special-2.smt2") =
    checkFile("tests/replace-special-2.smt2", "unsat")
  property("replace-special-3.smt2") =
    checkFile("tests/replace-special-3.smt2", "unsat")
  property("replace-special-4.smt2") =
    checkFile("tests/replace-special-4.smt2", "unsat")
  property("replace-special-5.smt2") =
    checkFile("tests/replace-special-5.smt2", "unsat")
  property("replace-length.smt2") =
    checkFile("tests/replace-length.smt2", "sat")
  property("replace-length-2.smt2") =
    checkFileOpts("tests/replace-length-2.smt2", "sat", "+parikh")

  property("model-bug.smt2") =
    checkFileOpts("tests/model-bug.smt2", "sat", "", "+model")
  property("null-problem.smt2") =
    checkFileOpts("tests/null-problem.smt2", "sat", "", "+model")
  property("failedProp.smt2") =
    checkFileOpts("tests/failedProp.smt2", "unknown", "", s"-timeout=$shortTimeout")
  property("failedProp2.smt2") =
    checkFileOpts("tests/failedProp2.smt2", "unknown", "", s"-timeout=$shortTimeout")

  property("propagation.smt2") =
    checkFileOpts("tests/propagation.smt2", "sat", "", "+model")
  property("subsumption.smt2") =
    checkFile("tests/subsumption.smt2", "sat")
  property("subsumption2.smt2") =
    checkFile("tests/subsumption2.smt2", "unsat")

  property("case-insensitive.smt2") =
    checkFile("tests/case-insensitive.smt2", "sat")
  property("case-insensitive-2.smt2") =
    checkFile("tests/case-insensitive-2.smt2", "unsat")

  property("minimize-problem.smt2") =
    checkFile("tests/minimize-problem.smt2", "sat")

  property("str.from_int.smt2") =
    checkFile("tests/str.from_int.smt2", "sat")
  property("str.from_int_2.smt2") =
    checkFile("tests/str.from_int_2.smt2", "unsat")
  property("str.from_int_3.smt2") =
    checkFile("tests/str.from_int_3.smt2", "sat")
  property("str.from_int_4.smt2") =
    checkFile("tests/str.from_int_4.smt2", "unsat")
  property("str.from_int_5.smt2") =
    checkFile("tests/str.from_int_5.smt2", "sat")
  property("str.from_int_6.smt2") =
    checkFile("tests/str.from_int_6.smt2", "sat")
  property("str.to_int.smt2") =
    checkFile("tests/str.to_int.smt2", "sat")
  property("str.to_int_2.smt2") =
    checkFile("tests/str.to_int_2.smt2", "unsat")
  property("str.to_int_3.smt2") =
    checkFile("tests/str.to_int_3.smt2", "sat")
  property("str.to_int_4.smt2") =
    checkFile("tests/str.to_int_4.smt2", "unsat")
  property("str.to_int_5.smt2") =
    checkFile("tests/str.to_int_5.smt2", "sat")
  property("str.to_int_6.smt2") =
    checkFile("tests/str.to_int_6.smt2", "sat")

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
    checkFileOpts("tests/empty-union.smt2", "sat", "", "+stringEscapes")

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
  property("anchor-8.smt2") =
    checkFile("tests/anchor-8.smt2", "sat")
  property("anchor-double.smt2") =
    checkFile("tests/anchor-double.smt2", "sat")
  property("anchor-alternate.smt2") =
    checkFile("tests/anchor-alternate.smt2", "sat")

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
    checkFileOpts("tests/loop.smt2", "sat", "", "+stringEscapes")
  property("loop2.smt2") =
    checkFile("tests/loop2.smt2", "unsat")
  property("loop-cg.smt2") =
    checkFile("tests/loop-cg.smt2", "sat")
  property("loop-cg2.smt2") =
    checkFile("tests/loop-cg2.smt2", "sat")
  property("loop-cg3.smt2") =
    checkFile("tests/loop-cg3.smt2", "sat")

  property("cg-star.smt2") =
    checkFileOpts("tests/cg-star.smt2", "sat", "", "+stringEscapes")

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
  property("test-replace-regex3") =
    checkFile("tests/test-replace-regex3.smt2", "sat")
  property("test-replace-regex4") =
    checkFile("tests/test-replace-regex4.smt2", "unsat")

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
    checkFileOpts("tests/escapeSequences-1a.smt2", "unsat", "", "+stringEscapes")
  property("escapeSequences-1b.smt2") =
    checkFileOpts("tests/escapeSequences-1b.smt2", "sat", "", "+stringEscapes")

  property("len-bug.smt2") =
    checkFile("tests/len-bug.smt2", "unsat")
  property("monadic-length.smt2") =
    checkFile("tests/monadic-length.smt2", "sat")

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
  property("str.at-3.smt2") =
    checkFile("tests/str.at-3.smt2", "sat")
  property("str.at-3b.smt2") =
    checkFile("tests/str.at-3b.smt2", "unsat")
  property("str.at-3c.smt2") =
    checkFile("tests/str.at-3c.smt2", "unsat")
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
  property("indexof-2.smt2") =
    checkFile("tests/indexof-2.smt2", "unsat")
  property("indexof-3.smt2") =
    checkFile("tests/indexof-3.smt2", "sat")
  property("indexof-4.smt2") =
    checkFile("tests/indexof-4.smt2", "sat")
  property("indexof-5.smt2") =
    checkFile("tests/indexof-5.smt2", "sat")
  property("indexof-6.smt2") =
    checkFile("tests/indexof-6.smt2", "unsat")

  property("substring.smt2") =
    checkFile("tests/substring.smt2", "sat")
  property("substring-bug.smt2") =
    checkFile("tests/substring-bug.smt2", "sat")
  property("substring-bug2.smt2") =
    checkFile("tests/substring-bug2.smt2", "unsat")
  property("substring2.smt2") =
    checkFile("tests/substring2.smt2", "unsat")
  property("substring2b.smt2") =
    checkFile("tests/substring2b.smt2", "sat")

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
  property("parse-ecma-cases-2.smt2") =
    checkFile("tests/parse-ecma-cases-2.smt2", "unsat", s"-timeout=$longTimeout")
  property("parse-ecma-cases-3.smt2") =
    checkFileOpts("tests/parse-ecma-cases-3.smt2", "sat", "-regexTranslator=complete", "")
  property("parse-ecma-groups.smt2") =
    checkFile("tests/parse-ecma-groups.smt2", "sat")
  property("parse-ecma-replace.smt2") =
    checkFile("tests/parse-ecma-replace.smt2", "sat")
  property("parse-ecma-bug1.smt2") =
    checkFile("tests/parse-ecma-bug1.smt2", "sat")
  property("parse-ecma-bug2.smt2") =
    checkFile("tests/parse-ecma-bug2.smt2", "unsat")

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
    checkFile("tests/negated-equation-2.smt2", "unknown")
  property("concat-empty.smt2") =
    checkFile("tests/concat-empty.smt2", "unsat")
  property("replace-bug.smt2") =
    checkFile("tests/replace-bug.smt2", "unsat")
  property("bug-56-replace-bug2.smt2") =
    checkFile("tests/bug-56-replace-bug2.smt2", "sat")
  property("bug-58-replace-re") =
    checkFile("tests/bug-58-replace-re.smt2", "sat")
  property("str-leq") =
    checkFile("tests/str-leq.smt2", "unsat")
  property("str-leq2") =
    checkFile("tests/str-leq2.smt2", "sat")
  property("str-leq3") =
    checkFile("tests/str-leq3.smt2", "sat")
  property("str-leq4") =
    checkFile("tests/str-leq4.smt2", "unsat")
  property("str-leq5") =
    checkFile("tests/str-leq5.smt2", "sat")
  property("str-leq6") =
    checkFile("tests/str-leq6.smt2", "sat")
  property("str-leq7") =
    checkFile("tests/str-leq7.smt2", "sat")
  property("str-leq8") =
    checkFile("tests/str-leq8.smt2", "unsat")
  property("str-leq9") =
    checkFile("tests/str-leq9.smt2", "sat")
  property("str-leq10") =
    checkFile("tests/str-leq10.smt2", "unsat")
  property("str-leq11") =
    checkFile("tests/str-leq11.smt2", "sat")
  property("str-leq12") =
    checkFile("tests/str-leq12.smt2", "sat")
  property("str-leq13") =
    checkFile("tests/str-leq13.smt2", "error")
  property("str-leq14") =
    checkFile("tests/str-leq14.smt2", "unsat")
  property("str-lt") =
    checkFile("tests/str-lt.smt2", "sat")
  property("str-lt2") =
    checkFile("tests/str-lt2.smt2", "unsat")
  property("str-leq-reflexive") =
    checkFile("tests/str-leq-reflexive.smt2", "sat")
  property("str-leq-reflexive-2") =
    checkFile("tests/str-leq-reflexive-2.smt2", "sat")
}
