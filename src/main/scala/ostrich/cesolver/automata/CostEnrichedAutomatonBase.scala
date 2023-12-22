/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich.cesolver.automata

import ostrich.automata._

import scala.collection.mutable.{
  HashMap => MHashMap,
  Stack => MStack,
  HashSet => MHashSet,
  ArrayBuffer
}
import scala.collection.immutable.Map
import scala.collection.mutable.ArrayStack
import java.time.LocalDate
import ostrich.cesolver.util.DotWriter
import dk.brics.automaton.{State => BState}
import dk.brics.automaton.BasicOperations
import CEBasicOperations.toBricsAutomaton
import java.io.File
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._
import ap.parser.IExpression

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

  def newState(): State = {
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

  /** Ask if state is accepting
    */
  def isAccept(q: State): Boolean = q.isAccept

  /** Given a state, iterate over all outgoing transitons with vector
    */
  def outgoingTransitionsWithVec(
      s: State
  ): Iterable[(State, (Char, Char), Seq[Int])] =
    _state2transtions.get(s) match {
      case None      => Iterable.empty
      case Some(set) => set
    }

  def incomingTransitionsWithVec(
      t: State
  ): Iterable[(State, (Char, Char), Seq[Int])] =
    _state2incomingTranstions.get(t) match {
      case None => Iterable.empty
      // incoming states may not be reachable from initial state, filter them out
      case Some(set) => set.filter(trans => states.toSet.contains(trans._1))
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
    if (!regsRelation.isTrue | registers.nonEmpty) {
      throw new UnsupportedOperationException
    }
    val seenlist = new MHashSet[State]
    val worklist = new MStack[State]
    var acceptedword = Seq[Int]()
    worklist.push(initialState)
    seenlist.add(initialState)
    while (!worklist.isEmpty) {
      val s = worklist.pop
      if (isAccept(s)) {
        return Some(acceptedword)
      }
      for (
        (to, (lbl, _), _) <- outgoingTransitionsWithVec(s)
        if !seenlist.contains(to)
      ) {
        acceptedword = acceptedword :+ lbl.toInt
        worklist.push(to)
        seenlist.add(to)
      }
    }
    None
  }

  // not implement methods
  def unary_! = {
    if (registers.nonEmpty) throw new UnsupportedOperationException
    BricsAutomatonWrapper(BasicOperations.complement(toBricsAutomaton(this)))
  }
  def apply(word: Seq[Int]): Boolean = throw new UnsupportedOperationException
  // def isEmpty: Boolean = throw new UnsupportedOperationException

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

  // optimization and minimization ////
  def removeDuplicatedReg(): Unit = {
    def removeValuesInIdxs[A](s: Seq[A], idxs: Set[Int]): Seq[A] = {
      val res = ArrayBuffer[A]()
      for (i <- 0 until s.size) {
        if (!idxs.contains(i)) {
          res += s(i)
        }
      }
      res.toSeq
    }
    // transpose the vectors, so that each vector is a column containing all updates of a register
    val vectorsT =
      transitionsWithVec
        .map { case (_, _, _, v) => v }
        .toSeq
        .transpose
        .zipWithIndex
    val vectors2Idxs = new MHashMap[Seq[Int], Set[Int]]()
    // map the transposed vectors to their updated register
    for ((v, i) <- vectorsT) {
      if (!vectors2Idxs.contains(v)) {
        vectors2Idxs += (v -> Set[Int]())
      }
      vectors2Idxs(v) += i
    }
    // if a transposed vector map to more than one register, then these registers are duplicated
    val duplicatedRegs =
      vectors2Idxs.map { case (_, idxs) => idxs }.filter(_.size > 1)
    if (duplicatedRegs.nonEmpty) {
      // remove the duplicated registers and add lia constraints to ensure they are equal
      val removeIdxs = new MHashSet[Int]()
      duplicatedRegs.foreach { regidxs =>
        val baseidx = regidxs.head
        regidxs.tail.foreach { idx =>
          _regsRelation =
            and(Seq(_regsRelation, (_registers(baseidx) === _registers(idx))))
        }
        removeIdxs ++= regidxs.tail

      }
      _registers = removeValuesInIdxs(_registers, removeIdxs.toSet)
      val newTransitionWithVec = transitionsWithVec.map {
        case (from, lbl, to, vec) =>
          (from, lbl, to, removeValuesInIdxs(vec, removeIdxs.toSet))
      }.toSeq
      _state2transtions.clear()
      _state2incomingTranstions.clear()
      for ((from, lbl, to, vec) <- newTransitionWithVec) {
        addTransition(from, lbl, to, vec)
      }
    }
  }
  /////////////////////////////////////

  override def toString: String = {
    val s2str = states.zipWithIndex.map { case (state, int) =>
      (state, s"s${int}")
    }.toMap
    def transition2Str(transition: (State, TLabel, State, Seq[Int])): String = {
      val (s, (left, right), t, vec) = transition
      s"${s2str(s)} -> ${s2str(t)} [${left.toInt}, ${right.toInt}] $vec"
    }

    val random = new scala.util.Random

    s"""
    automaton A${random.nextInt(10000)} {
      init ${s2str(initialState)};
      ${transitionsWithVec.toSeq
        .sortBy(_._1)
        .map(transition2Str)
        .mkString("\n  ")}
      accepting ${acceptingStates.map(s => s"${s2str(s)}").mkString(", ")};
    };
    """
  }

  def toDot(suffix: String) = {
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
    strbuilder.append("}")
    writer.closeAfterWrite(strbuilder.toString())
  }
}
