package ostrich.cesolver.stringtheory

import ostrich.automata.TransducerTranslator

import ap.theories.strings.{StringTheory, StringTheoryBuilder, SeqStringTheory}
import ap.util.CmdlParser

import scala.collection.mutable.ArrayBuffer
import ostrich.OFlags
import OFlags.CEABackend.{Unary, Baseline, Catra, Nuxmv}
import ostrich.cesolver.util.ParikhUtil
import ap.CmdlMain

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

  ParikhUtil.todo("add noAutomataProduct option, to disable automata product when using catra and nuxmv backend")
  private var eager, forward, minimizeAuts, useParikh, useCostEnriched, debug, noAutomataProduct =
    false
  private var useLen: OFlags.LengthOptions.Value = OFlags.LengthOptions.Auto
  private var backend: OFlags.CEABackend.Value = Unary
  private var nuxmvBackend: OFlags.NuxmvBackend.Value = OFlags.NuxmvBackend.Ic3
  private var simplifyAut = true

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
    case CmdlParser.Opt("product", value) => 
      noAutomataProduct = !value
    case CmdlParser.Opt("simplify-aut", value) =>
      simplifyAut = value
    case CmdlParser.Opt("costenriched", value) =>
      useCostEnriched = value
    case CmdlParser.Opt("debug", value) =>
      debug = value
      ParikhUtil.debug = value
      CmdlMain.stackTraces = value
    case CmdlParser.Opt("log", value) =>
      ParikhUtil.needlog = value
    case CmdlParser.ValueOpt("ceaBackend", "baseline") =>
      backend = Baseline
    case CmdlParser.ValueOpt("ceaBackend", "unary") =>
      backend = Unary
    case CmdlParser.ValueOpt("ceaBackend", "catra") =>
      backend = Catra
    case CmdlParser.ValueOpt("ceaBackend", "nuxmv") =>
      backend = Nuxmv
    case CmdlParser.ValueOpt("nuxmvBackend", "bmc") =>
      nuxmvBackend = OFlags.NuxmvBackend.Bmc
    case CmdlParser.ValueOpt("nuxmvBackend", "ic3") =>
      nuxmvBackend = OFlags.NuxmvBackend.Ic3
    case str =>
      super.parseParameter(str)
  }

  import StringTheoryBuilder._

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
        simplifyAut = simplifyAut,
        noAutomataProduct = noAutomataProduct,
        NuxmvBackend = nuxmvBackend
      )
    )
  }

}
