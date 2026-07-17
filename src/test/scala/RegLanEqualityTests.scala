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
    (backend, solver) <- backends
    file <- Seq("symbolic-safety.smt2", "symbolic-disequality.smt2",
                "named-alias.smt2")
  } property(s"$backend: $file never produces a spurious sat") = {
    val results = resultLines("tests/reglan-equality/" + file, solver)
    (results contains "unknown") || (results contains "unsat")
  }

  property("explicit existential RegLan aliases are not inlined") = {
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
