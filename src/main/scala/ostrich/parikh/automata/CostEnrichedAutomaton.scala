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
import TermGeneratorOrder.order
import java.time.LocalDate
import ostrich.parikh.writer.DotWriter
import os.write
import ostrich.parikh.core.FinalConstraints
import scala.collection.JavaConverters.asScala

object CostEnrichedAutomaton {

  type State = CostEnrichedAutomaton#State
  type TLabel = CostEnrichedAutomaton#TLabel

  def apply(): CostEnrichedAutomaton =
    CostEnrichedAutomaton(new BAutomaton)

  def apply(underlying: BAutomaton): CostEnrichedAutomaton = {
    val builder = new CostEnrichedAutomatonBuilder
    val old2new = asScala(underlying.getStates()).map { state =>
      state -> builder.getNewState
    }.toMap
    builder.setInitialState(old2new(underlying.getInitialState))
    for (state <- asScala(underlying.getStates())) {
      val newState = old2new(state)
      builder.setAccept(newState, state.isAccept)
      for (transition <- asScala(state.getTransitions())) {
        builder.addTransition(
          old2new(state),
          (transition.getMin, transition.getMax),
          old2new(transition.getDest),
          Seq()
        )
      }
    }
    val a = builder.getAutomaton
    a
  }

  /** Build CostEnriched automaton from a regular expression in brics format
    */
  def apply(pattern: String): CostEnrichedAutomaton =
    CostEnrichedAutomaton(new RegExp(pattern).toAutomaton(false))

  def fromString(str: String): CostEnrichedAutomaton =
    CostEnrichedAutomaton(BasicAutomata makeString str)

  def makeAnyString(): CostEnrichedAutomaton =
    CostEnrichedAutomaton(BAutomaton.makeAnyString)

  /** Check whether we should avoid ever minimising the given automaton.
    */
  def neverMinimize(aut: BAutomaton): Boolean =
    aut.getSingleton != null || aut.getNumberOfStates > MINIMIZE_LIMIT

  /** Return new automaton builder of compatible type
    */
  def getBuilder: CostEnrichedAutomatonBuilder = {
    new CostEnrichedAutomatonBuilder
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

  def removeDuplicatedReg(): Unit = {
    def removeIdxsValueOfSeq[A](s: Seq[A], idxs: Set[Int]): Seq[A] = {
      val res = ArrayBuffer[A]()
      for (i <- 0 until s.size) {
        if (!idxs.contains(i)) {
          res += s(i)
        }
      }
      res.toSeq
    }
    val vectorsT = etaMap.map{case (t, v) => v}.transpose.zipWithIndex
    val vectors2Idxs = new MHashMap[Seq[Int], Set[Int]]()
    for ((v, i) <- vectorsT) {
      val seqv = v.toSeq
      if (!vectors2Idxs.contains(seqv)) {
        vectors2Idxs += (seqv -> Set[Int]())
      }
      vectors2Idxs(seqv) += i
    }
    val duplicatedRegs = vectors2Idxs.map{case(v, idxs) => idxs}.filter(_.size > 1)
    // val vectorsPatition = vectorsT.groupBy(_._1).map(_._2.map(_._2))
    // val duplicatedRegs = vectorsPatition.filter(_.size > 1)
    val removeIdxs = new MHashSet[Int]()
    duplicatedRegs.foreach { regidxs =>
      val baseidx = regidxs.head
      regidxs.tail.foreach { idx =>
        regsRelation = conj(regsRelation, (registers(baseidx) === registers(idx)))
      }
      removeIdxs ++= regidxs.tail

    }
    registers = removeIdxsValueOfSeq(registers, removeIdxs.toSet)
    etaMap = etaMap.map { case (t, v) =>
      (t, removeIdxsValueOfSeq(v, removeIdxs.toSet))
    }

  }
}
