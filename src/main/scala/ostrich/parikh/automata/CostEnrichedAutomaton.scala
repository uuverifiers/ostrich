package ostrich.parikh.automata

import ostrich.automata._

import scala.collection.JavaConverters.asScala

import dk.brics.automaton.{
  BasicAutomata,
  BasicOperations,
  RegExp,
  Automaton => BAutomaton,
  State => BState
}
import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  LinkedHashSet => MLinkedHashSet,
  Stack => MStack
}

import ap.terfor.Term
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import scala.collection.immutable.Map
import scala.collection.mutable.ArrayBuffer
import ap.terfor.linearcombination.LinearCombination
import scala.collection.mutable.ArrayStack
import ostrich.parikh._
import ap.terfor.TerForConvenience._
import TermGeneratorOrder._
import java.time.LocalDate
import ostrich.parikh.writer.DotWriter
import os.write

object CostEnrichedAutomaton {

  type State = CostEnrichedAutomaton#State
  type TLabel = CostEnrichedAutomaton#TLabel

  def apply(): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(new BAutomaton)

  /** Build CostEnriched automaton from a regular expression in brics format
    */
  def apply(pattern: String): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(new RegExp(pattern).toAutomaton(false))

  def fromString(str: String): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(BasicAutomata makeString str)

  def makeAnyString(): CostEnrichedAutomaton =
    new CostEnrichedAutomaton(BAutomaton.makeAnyString)

  /** Check whether we should avoid ever minimising the given automaton.
    */
  def neverMinimize(aut: BAutomaton): Boolean =
    aut.getSingleton != null || aut.getNumberOfStates > MINIMIZE_LIMIT

  /** Return new automaton builder of compatible type
    */
  def getBuilder: CostEnrichedAutomatonBuilder = {
    new CostEnrichedAutomatonBuilder
  }

  def initMap(aut: CostEnrichedAutomaton): Unit = {
    val transitions = aut.transitions
    val registers = aut.registers

    transitions.foreach { transition =>
      val initEtaMap = (transition -> Seq.fill(registers.size)(0))
      aut.etaMap += initEtaMap
      val initTransTermMap = (transition -> TransitionTerm())
      aut.transTermMap += initTransTermMap
    }
  }

  private val MINIMIZE_LIMIT = 100000
}

/** Wrapper for the BRICS automaton class. New features added:
  *   - registers: a sequence of registers that store integer values
  *   - etaMap: a map from transitions to update vectors
  */
class CostEnrichedAutomaton(
    val underlying: BAutomaton
) extends CostEnrichedAutomatonTrait {

  CostEnrichedAutomaton.initMap(this)

  def unary_! = {
    CEBasicOperations.complement(this)
  }

  def |(that: Automaton): Automaton = {
    CEBasicOperations.union(Seq(this, that.asInstanceOf[CostEnrichedAutomaton]))
  }

  def isEmpty: Boolean = underlying.isEmpty

  def apply(word: Seq[Int]): Boolean =
    BasicOperations.run(
      this.underlying,
      SeqCharSequence(for (c <- word.toIndexedSeq) yield c.toChar).toString
    )

  def getAcceptedWord: Option[Seq[Int]] =
    (this.underlying getShortestExample true) match {
      case null => None
      case str  => Some(for (c <- str) yield c.toInt)
    }

  lazy val initialState: State = underlying.getInitialState

  val acceptingStates: Set[State] =
    (for (s <- states; if s.isAccept) yield s).toSet

  def states: Iterable[State] = {
    // do this the hard way to give a deterministic ordering
    val worklist = new MStack[State]
    val seenstates = new MLinkedHashSet[State]

    worklist.push(initialState)
    seenstates.add(initialState)

    while (!worklist.isEmpty) {
      val s = worklist.pop

      for ((to, _) <- outgoingTransitions(s)) {
        if (!seenstates.contains(to)) {
          worklist.push(to)
          seenstates += to
        }
      }
    }

    seenstates
  }

  def outgoingTransitions(from: State): Iterator[(State, TLabel)] = {
    (for (t <- asScala(from.getSortedTransitions(true)))
      yield (
        t.getDest,
        (t.getMin, t.getMax)
      )).iterator
  }

  def isAccept(s: State): Boolean = s.isAccept

  def toDetailedString: String = underlying.toString()

  def removeDeadTransitions(): Unit =
    underlying.removeDeadTransitions()

  def removeDuplicatedReg(): Unit = {
    def removeIdxsValueOfSeq[A](s: Seq[A], idxs: Seq[Int]): Seq[A] = {
      val res = ArrayBuffer[A]()
      for (i <- 0 until s.size) {
        if (!idxs.contains(i)) {
          res += s(i)
        }
      }
      res.toSeq
    }
    val vectorsT = etaMap.map(_._2).transpose.zipWithIndex
    val vectorsPatition = vectorsT.groupBy(_._1).map(_._2.map(_._2))
    val deplicatedRegs = vectorsPatition.filter(_.size > 1)
    deplicatedRegs.foreach { regidxs =>
      val baseidx = regidxs.head
      regidxs.tail.foreach { idx =>
        regsRelation =
          conj(regsRelation, (registers(baseidx) === registers(idx)))
      }
      registers = removeIdxsValueOfSeq(registers, regidxs.tail.toSeq)
      etaMap = etaMap.map { case (t, v) =>
        (t, removeIdxsValueOfSeq(v, regidxs.tail.toSeq))
      }
    }
  }
}
