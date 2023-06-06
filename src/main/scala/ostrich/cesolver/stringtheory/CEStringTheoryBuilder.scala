package ostrich.cesolver.stringtheory

import ostrich.automata.TransducerTranslator

import ap.theories.strings.{StringTheory, StringTheoryBuilder, SeqStringTheory}
import ap.util.CmdlParser

import scala.collection.mutable.ArrayBuffer
import ap.theories.TheoryBuilder
import ostrich.cesolver.core.finalConstraints.FinalConstraints
import ostrich.OFlags
import OFlags.CEABackend.{Unary, Baseline, Catra, Nuxmv}
import ostrich.cesolver.util.ParikhUtil

/** The entry class of the Ostrich string solver.
  */
class CEStringTheoryBuilder extends StringTheoryBuilder {

  val name = "OSTRICH"
  val version = "1.2.1"

  Console.withOut(Console.err) {
    println
    println(
      "Loading " + name + " " + version +
        ", a solver for string constraints"
    )
    println("(c) Denghang Hu, Matthew Hague, Philipp Rümmer, 2018-2023")
    println(
      "With contributions by Riccardo De Masellis, Zhilei Han, Oliver Markgraf."
    )
    println("For more information, see https://github.com/uuverifiers/ostrich")
    println
  }

  def setAlphabetSize(w: Int): Unit = ()

  private var eager, forward, minimizeAuts, useParikh, useCostEnriched, debug =
    false
  private var useLen: OFlags.LengthOptions.Value = OFlags.LengthOptions.Auto
  private var backend: OFlags.CEABackend.Value = Unary
  private var underApprox, simplifyAut = true
  private var underApproxBound = 15

  // TODO: add more command line arguments
  override def parseParameter(str: String): Unit = str match {
    case CmdlParser.Opt("eager", value) =>
      eager = value
    case CmdlParser.Opt("minimizeAutomata", value) =>
      minimizeAuts = value
    case CmdlParser.ValueOpt("length", "off") =>
      useLen = OFlags.LengthOptions.Off
    case CmdlParser.ValueOpt("length", "on") =>
      useLen = OFlags.LengthOptions.On
    case CmdlParser.ValueOpt("length", "auto") =>
      useLen = OFlags.LengthOptions.Auto
    case CmdlParser.Opt("forward", value) =>
      forward = value
    case CmdlParser.Opt("parikh", value) =>
      useParikh = value

    // Options for cost-enriched-automata based solver
    case CmdlParser.Opt("simplify-aut", value) =>
      simplifyAut = value
    case CmdlParser.Opt("costenriched", value) =>
      useCostEnriched = value
    case CmdlParser.Opt("under-approx", value) =>
      underApprox = value
    case CmdlParser.Opt("debug", value) =>
      debug = value
      ParikhUtil.debug = value
    case CmdlParser.ValueOpt("backend", "baseline") =>
      backend = Baseline
    case CmdlParser.ValueOpt("backend", "unary") =>
      backend = Unary
    case CmdlParser.ValueOpt("backend", "catra") =>
      backend = Catra
    case CmdlParser.ValueOpt("backend", "nuxmv") =>
      backend = Nuxmv
    case CmdlParser.ValueOpt("under-approx-bound", value) =>
      underApproxBound = value.toInt
    case str =>
      super.parseParameter(str)
  }

  import StringTheoryBuilder._
  import ap.parser._
  import IExpression._

  lazy val getTransducerTheory: Option[StringTheory] =
    Some(SeqStringTheory(CEStringTheory.alphabetSize))

  private val transducers = new ArrayBuffer[(String, SymTransducer)]

  def addTransducer(name: String, transducer: SymTransducer): Unit = {
    assert(!createdTheory)
    transducers += ((name, transducer))
  }

  private var createdTheory = false

  lazy val theory = {
    createdTheory = true

    val symTransducers =
      for ((name, transducer) <- transducers) yield {
        Console.err.println("Translating transducer " + name + " ...")
        val aut = TransducerTranslator.toBricsTransducer(
          transducer,
          CEStringTheory.alphabetSize,
          getTransducerTheory.get
        )
        (name, aut)
      }

    new CEStringTheory(
      symTransducers.toSeq,
      OFlags(
        eagerAutomataOperations = eager,
        useLength = useLen,
        useParikhConstraints = useParikh,
        forwardApprox = forward,
        minimizeAutomata = minimizeAuts,
        backend = backend,
        useCostEnriched = useCostEnriched,
        debug = debug,
        underApprox = underApprox,
        underApproxBound = underApproxBound,
        simplifyAut = simplifyAut
      )
    )
  }

}
