package ostrich.parikh.automata

import ostrich.automata._
import dk.brics.automaton.{State => BState}

import scala.collection.mutable.{
  HashMap => MHashMap,
  Stack => MStack,
  LinkedHashSet => MLinkedHashSet,
  HashSet => MHashSet
}
import ap.terfor.Term
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import scala.collection.immutable.Map
import scala.collection.mutable.ArrayStack
import java.time.LocalDate
import ostrich.parikh.writer.DotWriter

trait CostEnrichedAutomatonTrait extends Automaton {

  type State = BState

  type TLabel = (Char, Char)

  /** The relations of different registers
    */
  protected var regsRelation: Formula = Conjunction.TRUE

  /** Map from transition to its cost.
    */
  protected var etaMap: Map[(State, TLabel, State), Seq[Int]] = Map()

  /** Registers storing count value for accepting state.
    */
  protected var registers: Seq[Term] = Seq()

  /** The unique initial state
    */
  val initialState: State

  /** The set of accepting states
    */
  def acceptingStates: Set[State]

  /** Iterate over automaton states
    */
  def states: Iterable[State]

  /** Ask if state is accepting
    */
  def isAccept(q: State): Boolean

  /** Given a state, iterate over all outgoing transitions
    */
  def outgoingTransitions(from: State): Iterator[(State, TLabel)]

  def initMap: Unit = {
    transitions.foreach { transition =>
      etaMap += transition -> Seq.fill(registers.size)(0)
    }
  }

  def &(that: Automaton): Automaton = product(that.asInstanceOf[CostEnrichedAutomatonTrait])

  def product(that: CostEnrichedAutomatonTrait): CostEnrichedAutomatonTrait = {
    CEBasicOperations.intersection(this, that)
  }

  val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

  /** Compute states that can only be reached through words with some unique
    * length
    */
  lazy val uniqueLengthStates: Map[State, Int] = {
    val uniqueLengthStates = new MHashMap[State, Int]
    val nonUniqueLengthStates = new MHashSet[State]
    val todo = new ArrayStack[State]

    uniqueLengthStates.put(initialState, 0)
    todo push initialState

    while (!todo.isEmpty) {
      val s = todo.pop
      if (nonUniqueLengthStates contains s) {
        for ((to, _) <- outgoingTransitions(s)) {
          uniqueLengthStates -= to
          if (nonUniqueLengthStates add to)
            todo push to
        }
      } else {
        val sLen = uniqueLengthStates(s)
        for ((to, _) <- outgoingTransitions(s))
          (uniqueLengthStates get to) match {
            case Some(oldLen) =>
              if (oldLen != sLen + 1) {
                uniqueLengthStates -= to
                nonUniqueLengthStates += to
                todo push to
              }
            case None =>
              if (!(nonUniqueLengthStates contains to)) {
                uniqueLengthStates.put(to, sLen + 1)
                todo push to
              }
          }
      }
    }

    uniqueLengthStates.toMap
  }

  /** Unique lengths of accepted words
    */
  lazy val uniqueAcceptedWordLengths: Option[Seq[Int]] = {
    val lengths = for (s <- acceptingStates) yield (uniqueLengthStates get s)
    if (lengths.size > 0 && !(lengths contains None))
      Some(lengths.filter(_ != None).map(_.get).toSeq)
    else
      None
  }

  def getBuilder = new CostEnrichedAutomatonBuilder

  def getLengthAbstraction = Conjunction.TRUE // not use

  /** Iterate over all transitions
    */
  def transitions: Iterator[(State, TLabel, State)] =
    for (s1 <- states.iterator; (s2, lbl) <- outgoingTransitions(s1))
      yield (s1, lbl, s2)
  
  /** Map state to its incoming transitions
    */
  lazy val incomingTransitionsMap: Map[State, Set[(State, TLabel)]] = {
    val map = new MHashMap[State, Set[(State, TLabel)]]
    val worklist = new MStack[State]
    val seenstates = new MLinkedHashSet[State]

    map.put(initialState, Set.empty)

    worklist.push(initialState)
    seenstates.add(initialState)

    while (!worklist.isEmpty) {
      val s = worklist.pop
      outgoingTransitions(s).foreach { case (to, lbl) =>
        val set = map.getOrElseUpdate(to, Set.empty)
        map.put(to, set + ((s, lbl)))
        if (!seenstates.contains(to)) {
          worklist.push(to)
          seenstates.add(to)
        }
      }
    }
    map.toMap
  }

  def incomingTransitions(t: State): Iterator[(State, TLabel)] = {
    incomingTransitionsMap(t).iterator
  }

  def incomingTransitionsWithVec(
      t: State
  ): Iterator[(State, TLabel, Seq[Int])] =
    for ((s, l) <- incomingTransitions(t)) yield (s, l, etaMap(s, l, t))

  /** Given a state, iterate over all outgoing transitons with vector
    */
  def outgoingTransitionsWithVec(
      s: State
  ): Iterator[(State, TLabel, Seq[Int])] = {
    val tWithV =
      for ((t, lbl) <- outgoingTransitions(s))
        yield (t, lbl, etaMap((s, lbl, t)))
    // Sort by the number of 0 in the vector.
    // e.g (1,1) < (1,0) = (0,1) < (0,0)
    // So the iterator.head will be the transition with vector of
    // the least number of 0. This will benefit the search of finding string model
    val sortedTWithV = tWithV.toSeq.sortBy(_._3.filter(_ == 0).size).iterator
    sortedTWithV
  }

  /** Transitions with their costs
    */
  def transitionsWithVec: Iterator[(State, TLabel, State, Seq[Int])] =
    (for (s <- states; (t, l, v) <- outgoingTransitionsWithVec(s)) 
      yield (s, l, t, v)).iterator

  def getRegsRelation = regsRelation

  def getRegisters = registers

  def getEtaMap = etaMap


  def setRegisters(_registers: Seq[Term]) = registers = _registers

  def addEtaMap(_etaMap: Map[(State, TLabel, State), Seq[Int]]) =
    etaMap ++= _etaMap

  def setRegsRelation(f: Formula) = regsRelation = f

  def getTransducerBuilder: TransducerBuilder[State, TLabel] =
    BricsTransducer.getBuilder

  override def toString: String = {
    def transition2Str(transition: (State, TLabel, State, Seq[Int])): String = {
      val (s, (left, right), t, vec) = transition
      s"${s} -> ${t} [${left.toInt}, ${right.toInt}] $vec"
    }

    s"""
    automaton a${states.size} {
      init ${initialState};
      ${transitionsWithVec.toSeq
        .sortBy(_._1)
        .map(transition2Str)
        .mkString("\n  ")}
      accepting ${acceptingStates.map(s => s"${s}").mkString(", ")};
    };
    """
  }

  def toDot(suffix: String) = {
    states.zipWithIndex.toMap
    val outdir = os.pwd / "dot" / LocalDate.now().toString
    os.makeDir.all(outdir)
    val dotfile = outdir / s"${suffix}.dot"
    val writer = new DotWriter(dotfile.toString)
    def toDotStr = {
      s"""
      digraph G {
        rankdir=LR;
        init [shape=point];
        node [shape = doublecircle];
        ${acceptingStates.mkString(" ")}
        node [shape = circle];
        init -> ${initialState};
        ${transitionsWithVec.toSeq
          .sortBy(_._1)
          .map { case (s, (left, right), t, vec) =>
            s"${s} -> ${t} [label = \"${left.toInt}, ${right.toInt}:(${vec.mkString(",")})\"]"
          }
          .mkString(";\n")}
      }
      """
    }
    writer.closeAfterWrite(toDotStr)
  }
}
