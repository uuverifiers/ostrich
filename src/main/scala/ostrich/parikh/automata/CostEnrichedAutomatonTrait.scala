package ostrich.parikh.automata

import ostrich.automata._
import dk.brics.automaton.{State => BState, Automaton => BAutomaton}

import scala.collection.immutable.Map
import scala.collection.mutable.{
  HashMap => MHashMap,
  Stack => MStack,
  LinkedHashSet => MLinkedHashSet
}
import ap.terfor.Term
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import scala.collection.immutable.Map
import scala.collection.mutable.ArrayStack
import java.time.LocalDate
import ostrich.parikh.writer.DotWriter

trait CostEnrichedAutomatonTrait {
  type State = BState

  type TLabel = (Char, Char)

  /** The relations of different registers
    */
  protected var regsRelation: Formula = Conjunction.TRUE

  /** Map from transition to its cost.
    */
  protected var etaMap: Map[(State, TLabel, State), Seq[Int]] = Map()

  /** Map from transition to its term.
    */
  protected var transTermMap: Map[(State, TLabel, State), Term] = Map()

  /** Registers storing count value for accepting state.
    */
  protected var registers: Seq[Term] = Seq()

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

  val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

  val labelEnumerator: TLabelEnumerator[TLabel] =
    new BricsTLabelEnumerator(for ((_, lbl, _) <- transitions) yield lbl)

  def getBuilder: CostEnrichedAutomatonBuilder= {
    new CostEnrichedAutomatonBuilder
  }

  def incomingTransitions(t: State): Iterator[(State, TLabel)] = {
    incomingTransitionsMap(t).iterator
  }

  def incomingTransitionsWithVec(t: State) : Iterator[(State, TLabel, Seq[Int])] = 
    for ((s, l) <- incomingTransitions(t)) yield (s, l, etaMap(s, l, t))


  /** Given a state, iterate over all outgoing transitons with vector
    */
  def outgoingTransitionsWithVec(
      s: State
  ): Iterator[(State, TLabel, Seq[Int])] = {
    val tWithV = for ((t, lbl) <- outgoingTransitions(s)) yield (t, lbl, etaMap((s, lbl, t)))
    // Sort by the number of 0 in the vector.
    // e.g (1,1) < (1,0) = (0,1) < (0,0)
    // So the iterator.head will be the transition with vector of
    // the least number of 0. This will benefit the search of find model
    tWithV.toSeq.sortBy(_._3.filter(_ == 0).size).iterator
  }

  /** Given a state, iterate over all outgoing transitons with their terms, try
    * to be deterministic
    */
  def outgoingTransitionsWithTerm(
      s: State
  ): Iterator[(State, TLabel, Term)] = for ((t, lbl) <- outgoingTransitions(s))
    yield (t, lbl, transTermMap((s, lbl, t)))

  /** Given a state, iterate over all outgoing transitons with vector and term
    */
  def outgoingTransitionsWithInfo(
      s: State
  ): Iterator[(State, TLabel, Seq[Int], Term)] = for (
    (t, lbl) <- outgoingTransitions(s)
  ) yield {
    (t, lbl, etaMap((s, lbl, t)), transTermMap((s, lbl, t)))
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

  /** Transitions with their terms
    */
  def transitionsWithTerm: Iterator[(State, TLabel, State, Term)] =
    transitions.map { case (s, lbl, t) =>
      (s, lbl, t, transTermMap((s, lbl, t)))
    }

  /** Transitions with their costs
    */
  def transitionsWithVec: Iterator[(State, TLabel, State, Seq[Int])] =
    transitions.map { case (s, lbl, t) =>
      (s, lbl, t, etaMap((s, lbl, t)))
    }

  def getRegsRelation = regsRelation

  def getRegisters = registers

  def getEtaMap = etaMap

  def getTransTermMap = transTermMap

  def getTransitionsTerms = transTermMap.map(_._2).toSeq

  def setRegisters(_registers: Seq[Term]) = registers = _registers

  def addEtaMap(_etaMap: Map[(State, TLabel, State), Seq[Int]]) =
    etaMap ++= _etaMap

  def addTransTermMap(_transTermMap: Map[(State, TLabel, State), Term]) =
    transTermMap ++= _transTermMap

  def setRegsRelation(f: Formula) = regsRelation = f

  def getTransducerBuilder: TransducerBuilder[State, TLabel] =
    BricsTransducer.getBuilder
  
  override def toString: String = {
    val state2Int = states.zipWithIndex.toMap
    def transition2Str(transition: (State, TLabel, State, Seq[Int])): String = {
      val (s, (left, right), t, vec) = transition
      val registerUpdate =
        s"{${vec.zipWithIndex
            .map { case (veci, i) => s"${registers(i)} += $veci" }
            .mkString(", ")}};"

      s"s${state2Int(s)} -> s${state2Int(t)} [${left.toInt}, ${right.toInt}] $registerUpdate"
    }

    s"""
    automaton a${states.size} {
      init s${state2Int(initialState)};
      ${transitionsWithVec.toSeq
        .sortBy(_._1)
        .map(transition2Str)
        .mkString("\n  ")}
      accepting ${acceptingStates.map(s => s"s${state2Int(s)}").mkString(", ")};
    };
    """
  }

  def toDot(suffix: String) = {
    val state2Int = states.zipWithIndex.toMap
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
        ${acceptingStates.map(s => s"s${state2Int(s)}").mkString(" ")}
        node [shape = circle];
        init -> s${state2Int(initialState)};
        ${transitionsWithVec.toSeq
          .sortBy(_._1)
          .map { case (s, (left, right), t, vec) =>
            s"s${state2Int(s)} -> s${state2Int(t)} [label = \"${left.toInt}, ${right.toInt}:(${vec.mkString(",")})\"]"
          }
          .mkString(";\n")}
      }
      """
    }
    writer.closeAfterWrite(toDotStr)
  }

}
