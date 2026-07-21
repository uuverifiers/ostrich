package ostrich.automata

import org.scalacheck.Prop._
import org.scalacheck.Properties

object CertifiedModuloExtractorSpecification
    extends Properties("CertifiedModuloExtractor") {

  import Transducer._

  private def extractor(phase : Int,
                        stop : Char = 'p',
                        decorated : Boolean = false) : BricsTransducer = {
    val builder = BricsTransducer.getBuilder
    val cycle = Vector.fill(3)(builder.getNewState)
    val drain = builder.getNewState

    for (state <- cycle :+ drain)
      builder.setAccept(state, true)
    builder.setInitialState(cycle.head)

    for ((state, index) <- cycle.zipWithIndex) {
      val next = cycle((index + 1) % cycle.size)
      if (index == phase) {
        if (stop > Char.MinValue)
          builder.addTransition(
            state,
            (Char.MinValue, (stop - 1).toChar),
            OutputOp(if (decorated) "x" else "", Plus(0), ""),
            next)
        builder.addTransition(
          state, (stop, stop), OutputOp("", NOP, ""), drain)
        if (stop < Char.MaxValue)
          builder.addTransition(
            state,
            ((stop + 1).toChar, Char.MaxValue),
            OutputOp("", Plus(0), ""),
            next)
      } else {
        builder.addTransition(
          state, BricsTLabelOps.sigmaLabel, OutputOp("", NOP, ""), next)
      }
    }
    builder.addTransition(
      drain, BricsTLabelOps.sigmaLabel, OutputOp("", NOP, ""), drain)
    builder.getTransducer
  }

  property("certifies every modulo-3 phase") = {
    (0 until 3).forall { phase =>
      CertifiedModuloExtractor.certify(extractor(phase)) contains
        CertifiedModuloExtractor.Certificate(3, phase, 'p'.toInt)
    }
  }

  property("rejects hidden output decoration") = {
    CertifiedModuloExtractor.certify(extractor(0, decorated = true)).isEmpty
  }

  property("rejects a silent transducer") = {
    CertifiedModuloExtractor.certify(BricsTransducer.SilentTransducer).isEmpty
  }
}
