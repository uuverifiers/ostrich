package ostrich.cesolver.core.finalConstraintsSolver

import ap.parser.{ITerm, IFormula}
import ap.parser.IExpression._

import java.io.File

import ostrich.cesolver.core.finalConstraints.{
  FinalConstraints,
  NuxmvFinalConstraints
}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.api.SimpleAPI
import ap.parser.SymbolCollector
import ostrich.cesolver.util.ParikhUtil

class NuxmvBasedSolver(
    private val inputFormula: IFormula,
    private val freshIntTerm2orgin: Map[ITerm, ITerm]
) extends FinalConstraintsSolver[NuxmvFinalConstraints] {

  def addConstraint(t: ITerm, auts: Seq[CostEnrichedAutomatonBase]): Unit = {
    addConstraint(FinalConstraints.nuxmvACs(t, auts))
  }

  private val baseCommand = Array("nuxmv", "-int")
  private val Unreachable = """^-- invariant .* is true$""".r
  private val Reachable = """^-- invariant .* is false$""".r
  private val CounterValue = """^ {4}counter_(\d+) = (\d+)$""".r

  private val nuxmvCmd = baseCommand

  private val outFile = new File("parikh.smv")

  private def printNUXMVModule(constraints: Seq[NuxmvFinalConstraints]) = {
    val inputVars = constraints.zipWithIndex.map { case (_, i) =>
      s"l$i"
    }
    val state2int =
      constraints.flatMap(_.auts).flatMap(_.states).zipWithIndex.toMap
    val lia = and(inputFormula +: constraints.map(_.getRegsRelation))
    val integerVars = SymbolCollector.constants(lia)

    println("MODULE main")

    println("IVAR")
    // input label variable
    for (inputVar <- inputVars)
      println(s"  $inputVar : integer;")

    println("VAR")
    // state variable for each automaton
    for (c <- constraints; (aut, i) <- c.auts.zipWithIndex)
      println(
        s"  ${c.strId}_aut_$i : {${aut.states.map(state2int).mkString(", ")}};"
      )
    // integer variable
    for (i <- integerVars)
      println(s"  $i : integer;")

    println("ASSIGN")
    // init state variable and integer variable
    for (c <- constraints; (aut, i) <- c.auts.zipWithIndex) {
      println(
        s"  init(${c.strId}_aut_$i) := ${state2int(aut.initialState)};"
      )
    }
    for (i <- integerVars)
      println(s"  init($i) := 0;")

    ParikhUtil.todo("transition and invariant")
  }

  def solve: Result = {
    for (c <- constraints; (aut, i) <- c.auts.zipWithIndex) {
      aut.toDot(s"nuxmv_${c.strId}_${i}")
    }
    printNUXMVModule(constraints)
    val res = new Result
    res.setStatus(SimpleAPI.ProverStatus.Sat)
    res
  }
}
