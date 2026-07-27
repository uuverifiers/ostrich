package ostrich

import ap.CmdlMain
import ap.DialogUtil.asString
import ap.SimpleAPI
import SimpleAPI.ProverStatus
import ap.parser.IExpression

import org.scalacheck.Properties
import org.scalacheck.Prop._

/** Regression tests for extensional equality over the SMT-LIB RegLan sort. */
object RegLanEqualityTests extends Properties("RegLanEqualityTests") {

  private val timeout = 30000

  private val backends = Seq(
    "standard" -> "ostrich.OstrichStringTheory",
    "cea"      -> "ostrich.cesolver.stringtheory.CEStringTheory"
  )

  private val exactCases = Seq(
    "equivalent-equality.smt2"    -> "sat",
    "equivalent-disequality.smt2" -> "unsat",
    "different-equality.smt2"     -> "unsat",
    "different-disequality.smt2"  -> "sat",
    "empty-intersection.smt2"     -> "sat",
    "nonempty-intersection.smt2"  -> "unsat"
  )

  private def resultLines(filename : String, solver : String) : Set[String] = {
    val output = asString {
      Console.withErr(CmdlMain.NullStream) {
        CmdlMain.doMain(Array(
          "+assert",
          "-timeout=" + timeout,
          "-stringSolver=" + solver,
          filename
        ), false)
      }
    }

    (output split System.lineSeparator).iterator.map(_.trim).toSet
  }

  for {
    (backend, solver) <- backends
    (file, expected)  <- exactCases
  } property(s"$backend: $file") = {
    resultLines("tests/reglan-equality/" + file, solver) contains expected
  }

  for {
    (file, expected) <- Seq(
      "symbolic-safety.smt2"       -> "unsat",
      "symbolic-disequality.smt2"  -> "sat",
      "named-alias.smt2"           -> "unsat",
      "alias-membership-sat.smt2"  -> "sat",
      "alias-membership-unsat.smt2" -> "unsat",
      "alias-composite-membership-unsat.smt2" -> "unsat",
      "alias-capture-consumer-sat.smt2" -> "sat",
      "alias-chain-unsat.smt2"     -> "unsat"
    )
  } property(s"standard: $file") = {
    resultLines("tests/reglan-equality/" + file,
                "ostrich.OstrichStringTheory") contains expected
  }

  for {
    (file, expected) <- Seq(
      "symbolic-safety.smt2"      -> "unsat",
      "symbolic-disequality.smt2" -> "sat",
      "named-alias.smt2"          -> "unsat"
    )
  } property(s"cea: $file returns the expected result or unknown") = {
    val results = resultLines("tests/reglan-equality/" + file,
                              "ostrich.cesolver.stringtheory.CEStringTheory")
    (results contains "unknown") || (results contains expected)
  }

  property("standard: symbolic composites remain incomplete") = {
    val results = resultLines("tests/reglan-equality/symbolic-composite.smt2",
                              "ostrich.OstrichStringTheory")
    (results contains "unknown") || (results contains "unsat")
  }

  property("standard: capture-sensitive equality remains incomplete") = {
    val results =
      resultLines("tests/reglan-equality/capture-language-equality.smt2",
                  "ostrich.OstrichStringTheory")
    (results contains "unknown") || (results contains "unsat")
  }

  property("syntax-sensitive regexes disable language ids") = {
    val theory = new OstrichStringTheory(List(), OFlags())
    import theory._
    import IExpression._

    !usesSyntaxSensitiveRegex(re_union(str_to_re("a"), str_to_re("b"))) &&
    usesSyntaxSensitiveRegex(re_from_ecma2020("a")) &&
    usesSyntaxSensitiveRegex(re_capture(1, str_to_re("a"))) &&
    usesSyntaxSensitiveRegex(re_*?(str_to_re("a")))
  }

  property("explicit existential RegLan values remain inconclusive") = {
    val theory = new OstrichStringTheory(List(), OFlags())
    import theory._
    import IExpression._

    SimpleAPI.withProver(enableAssert = true) { p =>
      import p._

      val r = createExistentialConstant("r", RegexSort)
      !! (r =/= str_to_re("a"))

      ??? == ProverStatus.Inconclusive
    }
  }
}
