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
import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder._
import ostrich.parikh.Config.Parikh
import ostrich.parikh.Config.Unary
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

  private val MINIMIZE_LIMIT = 100000
}

import CostEnrichedAutomaton._

trait CostEnrichedAutomatonTrait extends AtomicStateAutomaton {

  type State = BState

  type TLabel = (Char, Char)

  /** Registers storing count value for accepting state.
    */
  val registers: Seq[Term]

  /** Enssential linear arithmatic constraints for the automaton.
    */
  var intFormula: Formula = Conjunction.TRUE

  /** Add linear arithmatic constraints to the automaton.
    * @param f
    *   the LIA constraints
    */
  def addIntFormula(f: Formula): Unit = {
    intFormula = conj(intFormula, f)
  }

  /** Given a state, iterate over all outgoing transitons with vector
    */
  def outgoingTransitionsWithVec(q: State): Iterator[(State, TLabel, Seq[Int])]

  /** Given a state, iterate over all outgoing transitons with their terms, try
    * to be deterministic
    */
  def outgoingTransitionsWithTerm(q: State): Iterator[(State, TLabel, Term)]

  /** Given a state, iterate over all outgoing transitons with vector and term
    */
  def outgoingTransitionsWithInfo(
      q: State
  ): Iterator[(State, TLabel, Seq[Int], Term)]

  lazy val uniqueAcceptedWordLengths: Option[Seq[Int]] = {
    val lengths = for (s <- acceptingStates) yield (uniqueLengthStates get s)
    if (lengths.size > 0 && !(lengths contains None))
      Some(lengths.filter(_ != None).map(_.get).toSeq)
    else
      None
  }

  /** Prikh image of the automaton
    */
  val registersAbstraction: Formula

  /** Return a sequence of terms representing transtions
    */
  def getTransitionsTerms: Seq[Term]

  def transitionsWithTerm: Iterator[(State, TLabel, State, Term)]

  def transitionsWithVec: Iterator[(State, TLabel, State, Seq[Int])]
}

/** Wrapper for the BRICS automaton class. New features added:
  *   - registers: a sequence of registers that store integer values
  *   - etaMap: a map from transitions to update vectors
  */
class CostEnrichedAutomaton(
    val underlying: BAutomaton,
    val etaMap: MHashMap[(State, TLabel, State), Seq[Int]],
    val registers: Seq[Term],
    val transTermMap: MHashMap[(State, TLabel, State), Term]
) extends CostEnrichedAutomatonTrait {

  def transitionsWithTerm: Iterator[(State, TLabel, State, Term)] =
    transitions.map { case (from, l, to) =>
      (from, l, to, transTermMap((from, l, to)))
    }

  def transitionsWithVec: Iterator[(State, (Char, Char), State, Seq[Int])] = {
    transitions.map { case (from, l, to) =>
      (from, l, to, etaMap((from, l, to)))
    }
  }

  /** constructor */
  def this(underlying: BAutomaton) =
    this(underlying, new MHashMap, Seq(), new MHashMap)

  def this(
      underlying: BAutomaton,
      etaMap: MHashMap[(State, TLabel, State), Seq[Int]],
      registers: Seq[Term]
  ) =
    this(underlying, etaMap, registers, new MHashMap)

  // Traverse etaMap and transTermMap and init all undefined keys
  def initMaps = {
    transitions.foreach { transition =>
      if (!etaMap.contains(transition)) {
        etaMap.put(transition, Seq.fill(registers.size)(0))
      } else {
        assert(etaMap(transition).size == registers.size)
      }
      if (!transTermMap.contains(transition)) {
        transTermMap.put(transition, TransitionTerm())
      }
    }
  }

  initMaps

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

    // old transtion term to a set of new transition terms
    // the value of old transtion term is the sum of values of new transtion terms
    // the value of olde transtion term will be used to find accepted word
    // val oldTerm2NewTerms = new MHashMap[Term, MHashSet[Term]]

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
    autBuilder.addIntFormula(aut1.intFormula)
    autBuilder.addIntFormula(aut2.intFormula)
    autBuilder.addRegisters(aut1.registers ++ aut2.registers)
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

  def outgoingTransitionsWithTerm(q: State): Iterator[(State, TLabel, Term)] = {
    for (t <- q.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax),
        transTermMap((q, (t.getMin, t.getMax), t.getDest))
      )
  }

  def outgoingTransitionsWithVec(
      q: State
  ): Iterator[(State, TLabel, Seq[Int])] = {
    for (t <- q.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax),
        etaMap((q, (t.getMin, t.getMax), t.getDest))
      )
  }

  def outgoingTransitionsWithInfo(
      q: State
  ): Iterator[(State, (Char, Char), Seq[Int], Term)] = {
    for (t <- q.getSortedTransitions(true).iterator)
      yield (
        t.getDest,
        (t.getMin, t.getMax),
        etaMap((q, (t.getMin, t.getMax), t.getDest)),
        transTermMap((q, (t.getMin, t.getMax), t.getDest))
      )
  }

  /** Map state to its incoming transitions
    */
  lazy val incomingTransitions: Map[State, Set[(State, TLabel)]] = {
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

  def isAccept(s: State): Boolean = s.isAccept

  def getBuilder: AtomicStateAutomatonBuilder[State, TLabel] = {
    new CostEnrichedAutomatonBuilder
  }

  def getTransducerBuilder: TransducerBuilder[State, TLabel] =
    BricsTransducer.getBuilder

  def toDetailedString: String = underlying.toString()

  /** Get terms representing the transtions
    */
  def getTransitionsTerms: Seq[Term] = {
    val terms = new ArrayBuffer[Term]
    transTermMap.foreach({ case (_, term) =>
      terms += term
    })
    terms
  }

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
    getTransitionsTerms.foreach { term =>
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

  /** Treat this automaton as unary NFA because we only care the LIA on the
    * automaton. Use algorithm in Saw Z, RP 2010 to get the formula of registers
    */
  lazy val unaryNFAImage: Formula = {
    val n = states.size
    val concreteLen = 300
    println("unary ---------------------------------------------")
    val kSet = new MHashSet[Term]
    def abstractionOfRi(i: Int): Formula = {
      val s = computeS(i)
      val t = computeT(i)
      val periods = computePeriods(s(n), i)
      val r1Formula = disjFor(
        for (
          j <- 0 until concreteLen;
          if !s(j).isEmpty && !s(j).forall(!isAccept(_))
        ) yield {
          registers(i) === j
        }
      )
      val r2Formula = disjFor(
        for (
          d <- 1 until n + 1;
          c <- 2 * n * n - d until 2 * n * n;
          if (periods.contains(d) && !t(c - n).isEmpty)
        ) yield {
          val k = KTerm()
          kSet += k
          registers(i) === c + k * d
        }
      )
      val kFormula = conj(
        for (k <- kSet) yield {
          k >= 1
        }
      )

      conj(disj(r1Formula, r2Formula), kFormula)
    }

    /** computing S_(2n^2+n-1), ..., S_0. Terminate if S_(2n^2+n-1) is computed
      * or succ(S_i) is empty
      * @return
      *   S
      */
    def computeS(i: Int) = {
      states.size
      val Slen = concreteLen
      val S = ArrayBuffer.fill(Slen)(Set[State]())
      S(0) = sameSucc(initialState, i).toSet
      var idx = 0
      while (idx < Slen - 1 && !S(idx).isEmpty) {
        idx += 1
        S(idx) = S(idx - 1).flatMap(succ(_, i))
        S(idx) = S(idx).flatMap(sameSucc(_, i))
      }
      println("finish")
      S
    }

    /** computing T_(2n^2-n-1), ..., T_0. Terminate if T_(2n^2-n-1) is computed
      * or pre(S_i) is empty
      * @param i
      */
    def computeT(i: Int) = {
      val n = states.size
      val Tlen = 2 * n * n - n
      val T = ArrayBuffer.fill(Tlen)(Set[State]())
      for (s <- acceptingStates) {
        T(0) = samePre(s, i).toSet
      }
      var idx = 0
      while (idx < Tlen - 1 && !T(idx).isEmpty) {
        idx += 1
        T(idx) = T(idx - 1).flatMap(pre(_, i))
        T(idx) = T(idx).flatMap(samePre(_, i))
      }
      T
    }

    def computePeriods(states: Set[State], i: Int): Set[Int] = {
      val periods = new ArrayBuffer[Int]
      for (s <- states) {
        periods ++= computePeriodsStep(s, i)
      }
      periods.toSet
    }

    def computePeriodsStep(s: State, i: Int): Set[Int] = {
      val periods = new ArrayBuffer[Int]
      val n = states.size
      var period = 0
      val nextStates = succ(s, i).flatMap(sameSucc(_, i))
      while (period < n && !nextStates.isEmpty) {
        period += 1
        if (nextStates.contains(s)) {
          periods.append(period)
        }
      }
      periods.toSet
    }

    def sameSucc(s: State, i: Int): Iterator[State] =
      (for (
        (t, lbl, vec) <- outgoingTransitionsWithVec(s);
        if vec(i) == 0
      ) yield {
        Iterator(t) ++ sameSucc(t, i)
      }).flatten ++ Iterator(s)

    def succ(s: State, i: Int): Iterator[State] =
      for (
        (t, lbl, vec) <- outgoingTransitionsWithVec(s);
        if vec(i) > 0
      ) yield t

    def samePre(t: State, i: Int): Iterator[State] =
      (for (
        (s, lbl) <- incomingTransitions(t).iterator;
        if etaMap((s, lbl, t))(i) == 0
      ) yield {
        Iterator(s) ++ samePre(s, i)
      }).flatten ++ Iterator(t)

    def pre(t: State, i: Int): Iterator[State] =
      for (
        (s, lbl) <- incomingTransitions(t).iterator;
        if etaMap((s, lbl, t))(i) > 0
      ) yield s

    conj(for (i <- 0 until registers.size) yield abstractionOfRi(i))
  }

  lazy val registersAbstraction: Formula = Config.lengthAbsStrategy match {
    case Parikh() => parikhImage
    case Unary()  => unaryNFAImage
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
automaton ${states.size} {
  init s${state2Int(initialState)};
  ${transitionsWithVec.toSeq.sortBy(_._1).map(transition2Str).mkString("\n  ")}
  accepting ${acceptingStates.map(s => s"s${state2Int(s)}").mkString(", ")};
};
    """
  }

}
