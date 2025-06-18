package ostrich

import ap.SimpleAPI
import SimpleAPI.ProverStatus
import ap.parser._
import ap.theories.strings.SeqStringTheory
import ap.util.Debug

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

object APITest extends Properties("APITest") {

  Debug enableAllAssertions true

  def expect[A](x : A, expected : A) : A = {
    assert(x == expected, "expected: " + expected + ", got: " + x)
    x
  }

  val stringTheory = new OstrichStringTheory(List(), OFlags())
  import stringTheory._
  import IExpression._

  property("concat") =
    SimpleAPI.withProver(enableAssert = true) { p =>
      import p._

      val x, y, z = createConstant(StringSort)
      implicit val ctxt = decoderContext

      scope {
        !! (x === "abc")

        expect(???, ProverStatus.Sat)
        evalToTerm(x)
        expect(asString(eval(x)), "abc")

        !! (x ++ y ++ "xyz" === z)
 
        expect(???, ProverStatus.Sat)
        assert(asString(eval(x)) + asString(eval(y)) + "xyz" == asString(eval(z)))

        !! (y =/= "")

        expect(???, ProverStatus.Sat)
        assert(asString(eval(x)) + asString(eval(y)) + "xyz" == asString(eval(z)))

        scope {
          !! (y === z)
          expect(???, ProverStatus.Unsat)
        }

        ??? == ProverStatus.Sat
      }
    }

  property("head-tail") =
    SimpleAPI.withProver(enableAssert = true) { p =>
      import p._

      val x, y, z = createConstant(StringSort)
      implicit val ctxt = decoderContext

      scope {
        !! (x ++ y === y ++ x)

        scope {
          !! (str_len(x) === 2)
          !! (str_len(y) === 5)
          !! (x =/= "")

          expect(???, ProverStatus.Sat)
          assert(asString(eval(x)) + asString(eval(y)) ==
                   asString(eval(y)) + asString(eval(x)))
          assert(asString(eval(x)).size == 2)
          assert(asString(eval(y)).size == 5)
        }

        scope {
          !! ("abcxyz" === x ++ y)
        
          expect(???, ProverStatus.Sat)
          assert(asString(eval(y)) + asString(eval(x)) == "abcxyz")

          ?? (x === "" | y === "")
          ??? == ProverStatus.Valid
        }
      }
    }

  property("len-no-regex") =
    SimpleAPI.withProver(enableAssert = true) { p =>
      import p._

      val x = createConstant(StringSort)

      !! (str_len(x) > 10)
      expect(???, ProverStatus.Sat)

      // this previous led to unsat, since the generated solution did
      // not actually satisfy the length constraint
      !! (x === evalToTerm(x))
      ??? == ProverStatus.Sat
    }

  property("integer") = 
      SimpleAPI.withProver(enableAssert = true) { p => 
          import p._
          val i = createConstant("i")
          val j = createConstant("j")
          !! (i === j)
          ??? == ProverStatus.Sat
      }

  property("string model test") =
      SimpleAPI.withProver(enableAssert = true) { p => 
        import p._
        val x = createConstant("x", StringSort)
        val s = "str" : ITerm

        addAssertion(x === s)

        ??? == ProverStatus.Sat &&
        partialModel.evalToTerm(x) == Some(s) &&
        evalToTerm(x) == s &&
        withCompleteModel(e => e.evalToTerm(x)) == s
      }

  property("str.from_code") =
      SimpleAPI.withProver(enableAssert = true) { p => 
        import p._
        val x = createConstant("x")
        !! (str_from_code(x) === str_from_code(x))
        ??? == ProverStatus.Sat
      }

  property("str.to_code") =
      SimpleAPI.withProver(enableAssert = true) { p => 
        import p._
        val x = createConstant("x", StringSort)
        !! (str_to_code(x) > 0)
        ??? == ProverStatus.Sat
      }

  property("str.to_code big") =
      SimpleAPI.withProver(enableAssert = true) { p => 
        import p._
        val x = createConstant("x", StringSort)
        !! (str_to_code(x) > 1000000000)
        ??? == ProverStatus.Unsat
      }

  property("str.to_int") =
      SimpleAPI.withProver(enableAssert = true) { p => 
        import p._
        val x = createConstant("x", StringSort)
        !! (str_to_int(x) > 12345)
        ??? == ProverStatus.Sat
      }

}
