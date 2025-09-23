package ostrich

import ap.SimpleAPI
import SimpleAPI.ProverStatus
import ap.parser._
import ap.theories.strings.SeqStringTheory
import ap.util.Debug

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

object ModelTest extends Properties("ModelTest") {

  import ap.parser.IExpression.{Sort => _}

  val withAssertions = true
  val stringTheory = new OstrichStringTheory(List(), OFlags())

  import stringTheory._

  property("(partial) evaluate symbol") = {
    Debug.enableAllAssertions(withAssertions)
    SimpleAPI.withProver(enableAssert = withAssertions) { p =>
      import p._
      val x = createConstant("x", StringSort)
      val s = "str" : ITerm

      addAssertion(x === s)
      checkSat(true)

      val r = partialModel.evalToTerm(x) // evaluate "x"
      Some(s) == r
    }
  }

  property("(partial) evaluate constant") = {
    Debug.enableAllAssertions(withAssertions)
    SimpleAPI.withProver(enableAssert = withAssertions) { p =>
      import p._

      val x = createConstant("x", StringSort)
      val s = "str" : ITerm
      val s2 = "strstr" : ITerm

      addAssertion(x === "abc")
      checkSat(true)

      val r = partialModel.evalToTerm(s)       // evaluate "str"
      val r2 = partialModel.evalToTerm(s ++ s) // evaluate "str" ++ "str"
      Some(s) == r && Some(s2) == r2
    }
  }

  property("(complete) evaluate constant") = {
    Debug.enableAllAssertions(withAssertions)
    SimpleAPI.withProver(enableAssert = withAssertions) { p =>
      import p._

      val x = createConstant("x", StringSort)
      val s = "str" : ITerm

      addAssertion(x === "abc")
      checkSat(true)

      val r = withCompleteModel { m => m.evalToTerm(s) } // evaluate "str"
      s == r
    }
  }
}