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

package ostrich.cesolver.util

import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  ArrayStack,
  ArrayBuffer
}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase

import ap.basetypes.IdealInt
import ap.parser.ITerm
import ostrich.automata.BricsTLabelOps
import ap.parser.IExpression._
import ap.parser.{IFormula, IBinJunctor, IExpression}
import ap.api.SimpleAPI
import ap.parser.SymbolCollector
import ostrich.OFlags
import scala.collection.mutable.Stack

object ParikhUtil {

  type State = CostEnrichedAutomatonBase#State
  type TLabel = CostEnrichedAutomatonBase#TLabel
  type Transition = CostEnrichedAutomatonBase#Transition

  var debugOpt, logOpt = false

  // Constants
  val MAX_MINIMIZE_SIZE =
    500 // if the automaton size is greater than this value, then do not minimize
  val MAX_DETERMIN_EXPAND =
    1.5 // if the automaton size is expanded more than this value, then do not minimize
  val MIN_COUNTING_SIZE_APPROX =
    50 // if the size of countings is greater than this value, then use approximate algorithm for complement of countings
  val MIN_LOG_REG_SUM_PARIKH =
    15 // when finding string by mixed strategy, if the sum of registers logrithm is greater than this value, then use transition times

  def measure[A](
      op: String
  )(comp: => A)(implicit manualFlag: Boolean = true): A =
    if (manualFlag)
      ap.util.Timer.measure(op)(comp)
    else
      comp

  def findAcceptedWordByRegistersComplete(
      aut: CostEnrichedAutomatonBase,
      registersModel: Map[ITerm, IdealInt],
      flags: OFlags
  ): Option[Seq[Int]] = {
    log("Finding the accepted word by registers")
    log(s"Registers model: $registersModel")
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
      ap.util.Timeout.check
      val (state, regsVal, word) = todoList.pop()
      if (aut.isAccept(state) && regsVal == registersValue) {
        return Some(word.map(_.toInt))
      }
      val sortedByVecSum =
        aut.outgoingTransitionsWithVec(state).toSeq.sortBy(_._3.sum).reverse
      for ((t, l, v) <- sortedByVecSum) {
        val newRegsVal = sumVec(regsVal, v)
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

  private def canArriveOtherTransFrom(
      aut: CostEnrichedAutomatonBase,
      trans: Transition,
      transTimes: Map[Transition, Int]
  ): Boolean = {
    val visited = new Stack[Transition]
    val todoList = new Stack[Transition]
    todoList.push(trans)
    visited.push(trans)
    while (!todoList.isEmpty) {
      val currentTrans = todoList.pop()
      val (_, _, to, _) = currentTrans
      for ((nextTo, l, v) <- aut.outgoingTransitionsWithVec(to)) {
        if (
          transTimes.contains((to, l, nextTo, v)) && !visited.contains(
            (to, l, nextTo, v)
          )
        ) {
          todoList.push((to, l, nextTo, v))
          visited.push((to, l, nextTo, v))
        }
      }
    }
    transTimes.keySet.forall(visited.contains(_))
  }

  private def findAcceptedWordByTransitionTimes(
      aut: CostEnrichedAutomatonBase,
      transModel: Map[Transition, IdealInt],
      flags: OFlags
  ): Option[Seq[Int]] = {
    val transTimes = transModel
      .map { case (tran, value) => (tran, value.intValue) }
      .filterNot(_._2 == 0)
    val todoList = new ArrayStack[(State, Map[Transition, Int], Seq[Char])]
    val visited = new MHashSet[(State, Map[Transition, Int])]
    todoList.push((aut.initialState, transTimes, ""))
    visited.add((aut.initialState, transTimes))
    while (!todoList.isEmpty) {
      ap.util.Timeout.check
      val (state, lastTransTimes, word) = todoList.pop()
      if (aut.isAccept(state) && lastTransTimes.forall(_._2 == 0)) {
        return Some(word.map(_.toInt))
      }
      val sortedByVecSum =
        aut
          .outgoingTransitionsWithVec(state)
          .filter { case (t, l, v) =>
            lastTransTimes.contains((state, l, t, v))
          }
          .toSeq
          .sortBy { case (t, l, v) =>
            v.sum
          }
          .reverse
      for ((t, l, v) <- sortedByVecSum) {
        val currentTrans = (state, l, t, v)
        val currTransTimes = lastTransTimes(currentTrans) - 1
        val newTransTimes =
          if (currTransTimes > 0)
            lastTransTimes.updated(currentTrans, currTransTimes)
          else lastTransTimes - currentTrans
        val newWord = word :+ l._1
        val newState = t
        if (
          !visited.contains(
            (newState, newTransTimes)
          ) && canArriveOtherTransFrom(aut, currentTrans, newTransTimes)
        ) {
          todoList.push((newState, newTransTimes, newWord))
          visited.add((newState, newTransTimes))
        }
      }
    }
    // }
    None
  }

  // Compute the transitions times based on registers values and find the string by DFS for each transition
  def findAcceptedWordByTransTimesComplete(
      aut: CostEnrichedAutomatonBase,
      registersModel: Map[ITerm, IdealInt],
      flags: OFlags
  ): Option[Seq[Int]] = {
    log("Finding the accepted word by transition times")
    val termGen = TermGenerator()
    val trans2Term =
      aut.transitionsWithVec.map(t => (t, termGen.transitionTerm)).toMap
    val registerFormulas = aut.registers.map(r => r === registersModel(r))
    val findingTransTimesF = connectSimplify(
      registerFormulas :+ parikhImage(aut, trans2Term),
      IBinJunctor.And
    )
    SimpleAPI.withProver(enableAssert = false) { p =>
      val consts = SymbolCollector.constants(findingTransTimesF)
      p.addConstantsRaw(consts)
      p !! findingTransTimesF
      p.checkSat(false)
      val status = measure("findAcceptedWordByTransTimesComplete") {
        while (p.getStatus(100) == SimpleAPI.ProverStatus.Running) {
          ap.util.Timeout.check
        }
        p.???
      }
      status match {
        case SimpleAPI.ProverStatus.Sat =>
          val model = p.partialModel
          val transModel = aut.transitionsWithVec
            .map(t => (t, model.eval(trans2Term(t)).get))
            .toMap
          log(
            s"Transitions model: ${transModel.map(t => trans2Term(t._1) + " = " + t._2)}"
          )
          return findAcceptedWordByTransitionTimes(aut, transModel, flags)
        case _ =>
          throw new Exception(
            "Cannot find the transtions model when finding the accepted word by transition times"
          )
      }
    }
    None
  }

  def findAcceptedWord(
      auts: Seq[CostEnrichedAutomatonBase],
      registersModel: Map[ITerm, IdealInt],
      flags: OFlags
  ): Option[Seq[Int]] = {
    val aut = auts.reduce(_ product _)
    val registersLogrithmSum =
      registersModel.map(_._2.intValue).filter(_ > 0).map(math.log(_)).sum
    if (registersLogrithmSum > ParikhUtil.MIN_LOG_REG_SUM_PARIKH)
      findAcceptedWordByTransTimesComplete(aut, registersModel, flags)
    else
      findAcceptedWordByRegistersComplete(aut, registersModel, flags)

  }

  def parikhImage(
      aut: CostEnrichedAutomatonBase,
      explicitTrans2Term: Map[CostEnrichedAutomatonBase#Transition, ITerm] =
        Map()
  ): IFormula = {
    ParikhUtil.log(
      s"Computing the parikh image of the automaton A${aut.hashCode()}..."
    )
    val termGen = TermGenerator()
    lazy val transtion2Term =
      if (explicitTrans2Term.nonEmpty) explicitTrans2Term
      else
        aut.transitionsWithVec.map(t => (t, termGen.transitionTerm)).toMap
    def outFlowTerms(from: State): Seq[ITerm] = {
      val outFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
      aut.outgoingTransitionsWithVec(from).foreach { case (to, lbl, vec) =>
        outFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      outFlowTerms.toSeq
    }

    def inFlowTerms(to: State): Seq[ITerm] = {
      val inFlowTerms: ArrayBuffer[ITerm] = new ArrayBuffer
      aut.incomingTransitionsWithVec(to).foreach { case (from, lbl, vec) =>
        inFlowTerms += transtion2Term(from, lbl, to, vec)
      }
      inFlowTerms.toSeq
    }

    val zTerm = aut.states.map((_, termGen.zTerm)).toMap

    val preStatesWithTTerm = new MHashMap[State, MHashSet[(State, ITerm)]]
    for ((from, lbl, to, vec) <- aut.transitionsWithVec) {
      val set = preStatesWithTTerm.getOrElseUpdate(to, new MHashSet)
      val tTerm = transtion2Term(from, lbl, to, vec)
      set += ((from, tTerm))
    }
    // consistent flow ///////////////////////////////////////////////////////////////
    var consistentFlowFormula = or(
      for (acceptState <- aut.acceptingStates)
        yield {
          val consistentFormulas =
            for (s <- aut.states)
              yield {
                val inFlow =
                  if (s == aut.initialState)
                    inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0)) + i(
                      1
                    )
                  else inFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
                val outFlow =
                  if (s == acceptState)
                    outFlowTerms(s)
                      .reduceLeftOption(_ + _)
                      .getOrElse(i(0)) + i(1)
                  else outFlowTerms(s).reduceLeftOption(_ + _).getOrElse(i(0))
                inFlow === outFlow
              }
          connectSimplify(consistentFormulas, IBinJunctor.And)
        }
    )

    // every transtion term should greater than 0
    val transtionTerms = transtion2Term.map(_._2).toSeq
    transtionTerms.foreach { term =>
      consistentFlowFormula =
        connectSimplify(Seq(consistentFlowFormula, term >= 0), IBinJunctor.And)
    }
    /////////////////////////////////////////////////////////////////////////////////

    // connection //////////////////////////////////////////////////////////////////
    val zVarInitFormulas = aut.transitionsWithVec.map {
      case (from, lbl, to, vec) => {
        val tTerm = transtion2Term(from, lbl, to, vec)
        if (from == aut.initialState)
          (zTerm(from) === 0)
        else
          (tTerm === 0) | (zTerm(from) > 0)
      }
    }

    val connectFormulas = aut.states.map {
      case s if s != aut.initialState =>
        (zTerm(s) === 0) | or(
          preStatesWithTTerm(s).map { case (from, tTerm) =>
            if (from == aut.initialState)
              connectSimplify(Seq(tTerm > 0, zTerm(s) === 1), IBinJunctor.And)
            else
              connectSimplify(
                Seq(
                  zTerm(from) > 0,
                  tTerm > 0,
                  zTerm(s) === zTerm(from) + 1
                ),
                IBinJunctor.And
              )
          }
        )
      case _ => IExpression.Boolean2IFormula(true)
    }

    val connectionFormula =
      connectSimplify(zVarInitFormulas ++ connectFormulas, IBinJunctor.And)
    /////////////////////////////////////////////////////////////////////////////////

    // registers update formula ////////////////////////////////////////////////////
    // registers update map
    val registerUpdateMap: Map[ITerm, ArrayBuffer[ITerm]] = {
      val registerUpdateMap =
        new MHashMap[ITerm, ArrayBuffer[ITerm]]
      aut.transitionsWithVec.foreach { case (from, lbl, to, vec) =>
        val trasitionTerm = transtion2Term(from, lbl, to, vec)
        vec.zipWithIndex.foreach {
          case (veci, i) if veci > 0 => {
            val update =
              registerUpdateMap.getOrElseUpdate(
                aut.registers(i),
                new ArrayBuffer[ITerm]
              )
            update.append(trasitionTerm * veci)
          }
          case _ => // do nothing
        }
      }
      registerUpdateMap.toMap
    }

    val registerUpdateFormula =
      connectSimplify(
        for (
          r <- aut.registers;
          update <- Some(registerUpdateMap.getOrElse(r, Seq(i(0))))
        )
          yield {
            r === update.reduce { (t1, t2) => t1 + t2 }
          },
        IBinJunctor.And
      )

    /////////////////////////////////////////////////////////////////////////////////
    val parikhImage = connectSimplify(
      Seq(
        registerUpdateFormula,
        consistentFlowFormula,
        connectionFormula
      ),
      IBinJunctor.And
    )
    ParikhUtil.log(
      s"Parikh image of the automaton A${aut.hashCode()} computed."
    )
    parikhImage
  }

  /** find all states vec triple (s, t, v) such that s ---str--> t and vec is
    * the sum of updates on the path
    */
  def partition(
      aut: CostEnrichedAutomatonBase,
      str: Seq[Char]
  ): Iterable[(State, State, Seq[Int])] = {

    val labelOps = BricsTLabelOps

    var pairs: Iterable[(State, State, Seq[Int])] =
      aut.states.map(s => (s, s, Seq.fill(aut.registers.size)(0)))

    var strStack = str
    while (strStack.nonEmpty) {
      val currentChar = strStack.head
      strStack = strStack.tail
      pairs =
        for (
          (s, t, vec) <- pairs;
          (tNext, lNext, vecNext) <- aut.outgoingTransitionsWithVec(t);
          if labelOps.labelContains(currentChar, lNext)
        ) yield (s, tNext, sumVec(vec, vecNext))
    }
    pairs
  }

  // sum of two Seq
  def sumVec(v1: Seq[Int], v2: Seq[Int]): Seq[Int] = {
    v1.zip(v2).map { case (x, y) => x + y }
  }

  def getImage(
      aut: CostEnrichedAutomatonBase,
      states: Set[State],
      lbl: TLabel
  ): Set[State] = {
    (for (
      s <- states; (t, lblAut, _) <- aut.outgoingTransitionsWithVec(s);
      if aut.LabelOps.labelsOverlap(lbl, lblAut)
    )
      yield t).toSet
  }

  // check if the aut only accepts empty string
  def isEmptyString(aut: CostEnrichedAutomatonBase): Boolean = {
    aut.isAccept(aut.initialState) && aut.transitionsWithVec.isEmpty
  }

  def debugPrintln(s: Any) = {
    if (debugOpt)
      println("Debug: " + s)
  }

  def todo(s: Any, urgency: Int) = {
    if (logOpt)
      println(
        s"TODO (urgency level $urgency):" + s + "  (lower level is more urgent)"
      )
  }
  def bug(s: Any) = {
    println("Bug:" + s)
  }

  def log(s: Any) = {
    if (logOpt)
      println("Log: " + s)
  }

  def throwWithStackTrace(e: Throwable) = {
    if (debugOpt)
      e.printStackTrace
    throw e
    
  }
}
