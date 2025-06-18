/** This file is part of Ostrich, an SMT solver for strings. Copyright (c) 2023
  * Denghang Hu. All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  * * Redistributions of source code must retain the above copyright notice,
  * this list of conditions and the following disclaimer.
  *
  * * Redistributions in binary form must reproduce the above copyright notice,
  * this list of conditions and the following disclaimer in the documentation
  * and/or other materials provided with the distribution.
  *
  * * Neither the name of the authors nor the names of their contributors may be
  * used to endorse or promote products derived from this software without
  * specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGE.
  */

package ostrich.cesolver.automata

import ostrich.automata._

import scala.collection.mutable.{
  HashMap => MHashMap,
  Stack => MStack,
  HashSet => MHashSet
}
import scala.collection.immutable.Map
import scala.collection.mutable.ArrayStack
import java.time.LocalDate
import ostrich.cesolver.util.DotWriter
import dk.brics.automaton.{State => BState}
import dk.brics.automaton.BasicOperations
import CEBasicOperations.toBricsAutomaton
import java.io.File
import ap.parser.{ITerm, IFormula, IExpression}
import ostrich.cesolver.util.{ParikhUtil, TermGenerator, ConstSubstVisitor}

/** This is the implementation of cost-enriched finite automaton(CEFA). Each
  * transition of CEFA contains a vector of integers, which is used to record
  * the cost of the transition. The cost of a word is the sum of the costs of
  * its transitions. A linear arithmetic constrait is used to restrict the cost
  * of the word. For example, the accepting condition can be r < 10, where r is
  * the register storing the cost and if r is length of the word, we get a
  * automation accepting words of length less than 10.
  */
class CostEnrichedAutomatonBase extends Automaton {

  type State = BState
  type TLabel = (Char, Char)
  type Update = Seq[Int]
  type Transition = (State, TLabel, State, Update)

  private var stateidx = 0

  /** The accepting condition
    */
  protected var _regsRelation: IFormula = IExpression.Boolean2IFormula(true)

  /** Registers storing count value for accepting state.
    */
  protected var _registers: Seq[ITerm] = Seq()

  /** The unique initial state
    */
  protected var _initialState: State = newState()

  protected val _state2transtions =
    new MHashMap[State, MHashSet[(State, TLabel, Update)]]
  protected val _state2incomingTranstions =
    new MHashMap[State, MHashSet[(State, TLabel, Update)]]

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
        for ((to, _, _) <- outgoingTransitionsWithVec(s)) {
          uniqueLengthStates -= to
          if (nonUniqueLengthStates add to)
            todo push to
        }
      } else {
        val sLen = uniqueLengthStates(s)
        for ((to, _, _) <- outgoingTransitionsWithVec(s))
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

  override def clone(): CostEnrichedAutomatonBase = {
    val newAut = new CostEnrichedAutomatonBase
    val old2new = states.map(s => s -> newAut.newState()).toMap
    newAut.initialState = old2new(initialState)
    val regSubst = registers.map { case t =>
      t -> TermGenerator().registerTerm
    }.toMap
    newAut.registers = regSubst.values.toSeq
    newAut.regsRelation = new ConstSubstVisitor().apply(regsRelation, regSubst)
    for ((from, lbl, to, vec) <- transitionsWithVec) {
      newAut.addTransition(old2new(from), lbl, old2new(to), vec)
    }
    for (s <- acceptingStates) {
      newAut.setAccept(old2new(s), true)
    }
    newAut
  }

  def newState(): State = synchronized {
    stateidx += 1
    new State() {
      val idx = stateidx
      override def toString(): String = {
        s"s${idx}"
      }
    }
  }

  /** The set of accepting states
    */
  def acceptingStates: Set[State] =
    (for (s <- states; if isAccept(s)) yield s).toSet
  def setAccept(s: State, b: Boolean) = s.setAccept(b)

  /** Iterate over automaton states
    */
  lazy val states: Iterable[State] = {
    val seenlist = new MHashSet[State]
    val worklist = new MStack[State]
    worklist.push(initialState)
    seenlist.add(initialState)
    while (!worklist.isEmpty) {
      val s = worklist.pop
      for (
        (to, _, _) <- outgoingTransitionsWithVec(s) if !seenlist.contains(to)
      ) {
        worklist.push(to)
        seenlist.add(to)
      }
    }
    seenlist.toSeq
  }

  def size(): Int = _state2transtions.values.flatten.size

  /** Ask if state is accepting
    */
  def isAccept(q: State): Boolean = q.isAccept

  /** Given a state, iterate over all outgoing transitons with vector
    */
  def outgoingTransitionsWithVec(
      s: State
  ): Iterable[(State, (Char, Char), Seq[Int])] =
    _state2transtions.get(s) match {
      case None           => Iterable.empty
      case Some(transSet) => transSet
    }

  def incomingTransitionsWithVec(
      t: State
  ): Iterable[(State, (Char, Char), Seq[Int])] =
    _state2incomingTranstions.get(t) match {
      case None => Iterable.empty
      // incoming states may not be reachable from initial state, filter them out
      case Some(transSet) =>
        transSet.filter(trans => states.toSet.contains(trans._1))
    }

  def transitionsWithVec: Iterable[(State, TLabel, State, Seq[Int])] = {
    for (from <- states; (to, lbl, vec) <- outgoingTransitionsWithVec(from))
      yield (from, lbl, to, vec)
  }

  def addTransition(
      from: State,
      lbl: TLabel,
      to: State,
      vec: Seq[Int]
  ): Unit = {
    _state2transtions.get(from) match {
      case Some(set) => set.add((to, lbl, vec))
      case None      => _state2transtions.put(from, MHashSet((to, lbl, vec)))
    }
    _state2incomingTranstions.get(to) match {
      case Some(set) => set.add((from, lbl, vec))
      case None => _state2incomingTranstions.put(to, MHashSet((from, lbl, vec)))
    }
  }

  def addEpsilon(s: State, t: State): Unit = {
    if (isAccept(t)) setAccept(s, true)
    for ((to, lbl, vec) <- outgoingTransitionsWithVec(t)) {
      addTransition(s, lbl, to, vec)
    }
  }

  def |(that: Automaton): Automaton = {
    CEBasicOperations.union(
      Seq(this, that.asInstanceOf[CostEnrichedAutomatonBase])
    )
  }

  def &(that: Automaton): Automaton = product(
    that.asInstanceOf[CostEnrichedAutomatonBase]
  )

  // check whether the NFA form of this automaton is empty
  def isEmpty: Boolean = {
    val seenlist = new MHashSet[State]
    val worklist = new MStack[State]
    worklist.push(initialState)
    seenlist.add(initialState)
    while (!worklist.isEmpty) {
      val s = worklist.pop
      if (isAccept(s)) {
        return false
      }
      for (
        (to, _, _) <- outgoingTransitionsWithVec(s) if !seenlist.contains(to)
      ) {
        worklist.push(to)
        seenlist.add(to)
      }
    }
    true
  }

  def getAcceptedWord: Option[Seq[Int]] = {
    if (registers.nonEmpty) {
      throw new UnsupportedOperationException
    }
    val seenlist = new MHashSet[State]
    val worklist = new MStack[(State, Seq[Int])]
    worklist.push((initialState, Seq()))
    seenlist.add(initialState)
    while (!worklist.isEmpty) {
      val (s, word) = worklist.pop
      if (isAccept(s)) {
        return Some(word)
      }
      for (
        (to, (lbl, _), _) <- outgoingTransitionsWithVec(s)
        if !seenlist.contains(to)
      ) {
        val newWord = word :+ lbl.toInt
        worklist.push((to, newWord))
        seenlist.add(to)
      }
    }
    None
  }

  def unary_! = {
    if (registers.nonEmpty) throw new UnsupportedOperationException
    CEBasicOperations.complement(this)
  }
  def apply(word: Seq[Int]): Boolean = {
    ParikhUtil.log(
      "Naively run word on CEFA without registers. Indeed, the CEFA with registers can be easily supported in the future."
    )
    // if (registers.nonEmpty) throw new UnsupportedOperationException
    BasicOperations.run(toBricsAutomaton(this), word.map(_.toChar).mkString)
  }

  def product(that: CostEnrichedAutomatonBase): CostEnrichedAutomatonBase = {
    CEBasicOperations.intersection(this, that)
  }

  def getLengthAbstraction = throw new UnsupportedOperationException
  // Accessors and Mutators ////
  def initialState = _initialState

  def initialState_=(s: State) = _initialState = s

  def regsRelation = _regsRelation

  def registers = _registers

  def registers_=(registers: Seq[ITerm]) = _registers = registers

  def regsRelation_=(f: IFormula) = _regsRelation = f
  /////////////////////////////

  override def toString: String = {
    def transition2Str(transition: (State, TLabel, State, Seq[Int])): String = {
      val (s, (left, right), t, vec) = transition
      s"${s} -> ${t} [${left.toInt}, ${right.toInt}] $vec"
    }

    s"""
    automaton A${hashCode()} {
      init ${initialState};
      ${transitionsWithVec.toSeq
        .sortBy(_._1)
        .map(transition2Str)
        .mkString("\n    ")}
      accepting ${acceptingStates.map(s => s"${s}").mkString(", ")};
      Registers ${registers.mkString(", ")};
      RegsRelation ${regsRelation};
    };
    """
  }

  def toDot(suffix: String): Unit = {
    if (!ParikhUtil.debugOpt) return
    states.zipWithIndex.toMap
    val outdir = "dot" + File.separator + LocalDate.now().toString
    new File(outdir).mkdirs()
    val dotfile = outdir + File.separator + s"${suffix}.dot"
    val writer = new DotWriter(dotfile.toString)
    val strbuilder = new StringBuilder
    strbuilder.append(s"""
      digraph G {
        rankdir=LR;
        init [shape=point];
        node [shape = doublecircle];
        ${acceptingStates.mkString(" ")}
        node [shape = circle];
        init -> ${initialState};""")

    for ((s, (left, right), t, vec) <- transitionsWithVec.toSeq.sortBy(_._1)) {
      strbuilder.append(s"""
        ${s} -> ${t} [label = \"${left.toInt},${right.toInt}:(${vec.mkString(
          ","
        )})\"]""")
    }
    strbuilder.append("\n")
    strbuilder.append(
      s"""        \"${registers.mkString(", ")}\" [shape=plaintext]"""
    )
    strbuilder.append("\n      }")
    writer.closeAfterWrite(strbuilder.toString())
  }
}
