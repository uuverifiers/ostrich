package ostrich

import org.scalacheck.Prop._
import org.scalacheck.Properties

object AutomaticIslandFlagSpecification
    extends Properties("AutomaticIslandFlag") {

  property("disabled by default") = {
    val builder = new OstrichStringTheoryBuilder
    !builder.theory.theoryFlags.automaticIslands
  }

  property("parses the opt-in flag") = {
    val builder = new OstrichStringTheoryBuilder
    builder.parseParameter("+automaticIslands")
    builder.theory.theoryFlags.automaticIslands
  }
}
