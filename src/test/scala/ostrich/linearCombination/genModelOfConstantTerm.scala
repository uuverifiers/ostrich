package ostrich.linearCombination

import ap.SimpleAPI
import ostrich.automata.costenrich.RegisterTerm
import ap.terfor.TerForConvenience
import org.scalacheck.Properties
import org.scalacheck.Prop._
import ap.terfor.TermOrder
import ap.parser.Internal2InputAbsy
import ap.util.Debug
import ap.terfor.OneTerm

object genModelOfConstantTerm extends Properties("Generate Model") {

  Debug enableAllAssertions true

  def expect[A](x: A, expected: A): A = {
    assert(x == expected, "expected: " + expected + ", got: " + x)
    x
  }

  property("constantTerm") = Console.withErr(ap.CmdlMain.NullStream) {
    SimpleAPI.withProver(enableAssert = true) { p =>
      implicit val _ = TermOrder.EMPTY
      import p._
      import TerForConvenience._
      val r1 = RegisterTerm()
      addConstant(Internal2InputAbsy(r1))
      addAssertion(Internal2InputAbsy(r1) === 1)
      val res = ???
      expect(eval(Internal2InputAbsy(r1)).intValueSafe, 1)
      res == SimpleAPI.ProverStatus.Sat
    }
  }

}
