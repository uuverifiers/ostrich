package ostrich.parikh.automata

import ostrich.automata._

import scala.collection.JavaConversions.asScalaIterator

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

  import CostEnrichedAutomaton.{initMap}

  initMap(this) // init etaMap and transTermMap
  
  /** @deprecated
    *   not implemented
    */
  def |(that: Automaton): Automaton =
    new CostEnrichedAutomaton(new BAutomaton)

  def &(that: Automaton): Automaton = {
    import CostEnrichedAutomatonAdapter.intern
    val aut1 = this
    val aut2 = intern(that)
    val autBuilder = new CostEnrichedAutomatonBuilder

    // begin intersection
    val initialState1 = aut1.initialState
    val initialState2 = aut2.initialState
    val initialState = autBuilder.getNewState
    autBuilder.setInitialState(initialState)
    autBuilder.setAccept(
      initialState,
      aut1.isAccept(initialState1) && aut2.isAccept(initialState2)
    )

    // from old states pair to new state
    val pair2state = new MHashMap[(State, State), State]
    val worklist = new ArrayStack[(State, State)]

    pair2state.put((initialState1, initialState2), initialState)
    worklist.push((initialState1, initialState2))

    while (!worklist.isEmpty) {
      val (from1, from2) = worklist.pop()
      val from = pair2state(from1, from2)
      for (
        (to1, label1, vec1, term1) <- aut1.outgoingTransitionsWithInfo(from1);
        (to2, label2, vec2, term2) <- aut2.outgoingTransitionsWithInfo(from2)
      ) {
        // intersect transition
        LabelOps.intersectLabels(label1, label2) match {
          case Some(label) => {
            if (pair2state.contains((to1, to2))) {
              val to = pair2state((to1, to2))
              val vector = vec1 ++ vec2
              val term = TransitionTerm()
              autBuilder.addTransition(
                from,
                label,
                to,
                vector,
                term
              )
              autBuilder.setAccept(
                to,
                aut1.isAccept(to1) && aut2.isAccept(to2)
              )
            } else {
              val to = autBuilder.getNewState
              pair2state.put((to1, to2), to)
              worklist.push((to1, to2))
              val vector = vec1 ++ vec2
              val term = TransitionTerm()
              autBuilder.addTransition(
                from,
                label,
                to,
                vector,
                term
              )
              autBuilder.setAccept(
                to,
                aut1.isAccept(to1) && aut2.isAccept(to2)
              )
            }
          }
          case _ => // do nothing
        }
      }
    }
    autBuilder.addNewIntFormula(aut1.regsRelation)
    autBuilder.addNewIntFormula(aut2.regsRelation)
    autBuilder.prependRegisters(aut1.registers ++ aut2.registers)
    val res = autBuilder.getAutomaton
    res.removeDeadTransitions()
    res
  }

  /** @deprecated
    *   not implemented
    */
  def unary_! : Automaton =
    new CostEnrichedAutomaton(new BAutomaton)

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

  override val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

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

  val labelEnumerator: TLabelEnumerator[TLabel] =
    new BricsTLabelEnumerator(for ((_, lbl, _) <- transitions) yield lbl)

  def outgoingTransitions(from: State): Iterator[(State, TLabel)] = {
    for (t <- from.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax)
      )
  }

  def isAccept(s: State): Boolean = s.isAccept

  def getBuilder: AtomicStateAutomatonBuilder[State, TLabel] = {
    new CostEnrichedAutomatonBuilder
  }

  def getTransducerBuilder: TransducerBuilder[State, TLabel] =
    BricsTransducer.getBuilder

  def toDetailedString: String = underlying.toString()

  /** Parikh image of this automaton, using algorithm in Verma et al, CADE 2005.
    * Encode the formula of registers meanwhile.
    */
  lazy val parikhImage: Formula = {
    // Bug : do not consider connection
    import ap.terfor.TerForConvenience._
    import TermGeneratorOrder._

    println("parikh ---------------------------------")
    def outFlowTerms(from: State): Seq[Term] = {
      val outFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      outgoingTransitions(from).foreach { case (to, lbl) =>
        outFlowTerms += transTermMap(from, lbl, to)
      }
      outFlowTerms
    }

    def inFlowTerms(to: State): Seq[Term] = {
      val inFlowTerms: ArrayBuffer[Term] = new ArrayBuffer
      incomingTransitions(to).foreach { case (from, lbl) =>
        inFlowTerms += transTermMap(from, lbl, to)
      }
      inFlowTerms
    }

    val zTerm = states.map((_, ZTerm())).toMap

    val preStatesWithTTerm = new MHashMap[State, MHashSet[(State, Term)]]
    for ((s, _, t, tTerm) <- transitionsWithTerm) {
      val set = preStatesWithTTerm.getOrElseUpdate(t, new MHashSet)
      set += ((s, tTerm))
    }
    // consistent flow ///////////////////////////////////////////////////////////////
    var consistentFlowFormula = disj(
      for (acceptState <- acceptingStates)
        yield {
          val consistentFormulas =
            for (s <- states)
              yield {
                val inFlow: LinearCombination =
                  if (s == initialState)
                    inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0)) + 1
                  else inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0))
                val outFlow: LinearCombination =
                  if (s == acceptState)
                    outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0)) + 1
                  else outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(l(0))
                inFlow === outFlow
              }
          conj(consistentFormulas)
        }
    )

    // every transtion term should greater than 0
    val transtionTerms = transTermMap.map(_._2).toSeq
    transtionTerms.foreach { term =>
      consistentFlowFormula = conj(consistentFlowFormula, term >= 0)
    }
    /////////////////////////////////////////////////////////////////////////////////

    // connection //////////////////////////////////////////////////////////////////
    val zVarInitFormulas = transitionsWithTerm.map { case (from, _, _, tTerm) =>
      if (from == initialState)
        (zTerm(from) === 0)
      else
        (tTerm === 0) | (zTerm(from) > 0)
    }

    val connectFormulas = states.map {
      case s if s != initialState =>
        (zTerm(s) === 0) | disj(
          preStatesWithTTerm(s).map { case (from, tTerm) =>
            if (from == initialState)
              conj(tTerm > 0, zTerm(s) === 1)
            else
              conj(
                zTerm(from) > 0,
                tTerm > 0,
                zTerm(s) === zTerm(from) + 1
              )
          }
        )
      case _: BState => Conjunction.TRUE
    }

    val connectionFormula = conj(zVarInitFormulas ++ connectFormulas)
    /////////////////////////////////////////////////////////////////////////////////

    // registers update formula ////////////////////////////////////////////////////
    // registers update map
    val registerUpdateMap: Map[Term, ArrayBuffer[LinearCombination]] = {
      val registerUpdateMap = new MHashMap[Term, ArrayBuffer[LinearCombination]]
      val transitionsWithVector: Iterator[(State, TLabel, State, Seq[Int])] =
        for (
          s <- states.iterator;
          (to, label, vec) <- outgoingTransitionsWithVec(s)
        )
          yield (
            (
              s,
              label,
              to,
              vec
            )
          )
      transitionsWithVector.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transTermMap(from, lbl, to)
        vec.zipWithIndex.foreach {
          case (veci, i) => {
            val registerTerm = registers(i)
            val update =
              registerUpdateMap.getOrElseUpdate(
                registerTerm,
                new ArrayBuffer[LinearCombination]
              )
            update.append(trasitionTerm * veci)
          }
        }
      }
      registerUpdateMap.toMap
    }

    val registerUpdateFormula = conj(
      for ((registerTerm, update) <- registerUpdateMap)
        yield {
          registerTerm === update.reduce(_ + _)
        }
    )

    /////////////////////////////////////////////////////////////////////////////////

    conj(registerUpdateFormula, consistentFlowFormula, connectionFormula)
  }

  def removeDeadTransitions(): Unit = {
    underlying.removeDeadTransitions()
  }

  override lazy val getLengthAbstraction: Formula = Conjunction.TRUE

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
  ${transitionsWithVec.toSeq.sortBy(_._1).map(transition2Str).mkString("\n  ")}
  accepting ${acceptingStates.map(s => s"s${state2Int(s)}").mkString(", ")};
};
    """
  }

}
