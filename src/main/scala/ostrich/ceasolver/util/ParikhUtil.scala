package ostrich.ceasolver.util

import scala.collection.mutable.{
  Map => MMap,
  HashSet => MHashSet,
  HashMap => MHashMap,
  ArrayStack
}
import ostrich.ceasolver.automata.CostEnrichedAutomatonBase

import ap.basetypes.IdealInt
import scala.collection.mutable.ArrayBuffer
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.terfor.linearcombination.LinearCombination
import ostrich.ceasolver.core.FinalConstraints
import ap.parser.ITerm
import ap.parser.IExpression._

object ParikhUtil {
  private val CountingRegisters = new MHashSet[ITerm]()
  def addCountingRegister(t: ITerm) = CountingRegisters += t

  type State = CostEnrichedAutomatonBase#State
  type TLabel = CostEnrichedAutomatonBase#TLabel

  def measure[A](
      op: String
  )(comp: => A)(implicit manualFlag: Boolean = true): A =
    if (manualFlag)
      ap.util.Timer.measure(op)(comp)
    else
      comp

  def findAcceptedWordByRegistersComplete(
      aut: CostEnrichedAutomatonBase,
      registersModel: MMap[ITerm, IdealInt]
  ): Option[Seq[Int]] = {

    val registersValue = aut.registers.map(registersModel(_).intValue)
    val todoList = new ArrayStack[(State, Seq[Int], Seq[Char])]
    val visited = new MHashSet[(State, Seq[Int])]
    todoList.push(
      (
        aut.initialState,
        Seq.fill(aut.registers.size)(0),
        ""
      )
    )
    visited.add(
      (aut.initialState, Seq.fill(aut.registers.size)(0))
    )
    while (!todoList.isEmpty) {
      val (state, regsVal, word) = todoList.pop
      if (aut.isAccept(state) && regsVal == registersValue) {
        return Some(word.map(_.toInt))
      }
      for ((t, l, v) <- aut.outgoingTransitionsWithVec(state)) {
        val newRegsVal = regsVal.zip(v).map { case (r, v) => r + v }
        val newWord = word :+ l._1
        val newState = t
        if (
          !visited.contains((newState, newRegsVal)) &&
          !newRegsVal.zip(registersValue).exists(r => r._1 > r._2)
        ) {
          todoList.push((newState, newRegsVal, newWord))
          visited.add((newState, newRegsVal))
        }
      }
    }
    None
  }

  def findAcceptedWordByRegisters(
      auts: Seq[CostEnrichedAutomatonBase],
      registersModel: MMap[ITerm, IdealInt]
  ): Option[Seq[Int]] = {
    val aut = auts.reduce(_ product _)
    findAcceptedWordByRegistersComplete(aut, registersModel)

  }

  def debugPrintln(s: Any) = {
    println("Debug: " + s)
  }

  def todo(s:Any) = {
    println("TODO:" + s)
  }
}
