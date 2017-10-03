/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package strsolver

import scala.collection.JavaConverters._
import dk.brics.automaton.{Automaton, RegExp, SpecialOperations, State}

import scala.collection.mutable.ArrayBuffer

object ReplaceAll {
  private var var1 = 0
  private var var2 = 1
  private var var3 = 2

  private def buildAutomaton(pattern: String): Automaton = {
    val aut: Automaton = new RegExp(pattern).toAutomaton(true)

    aut.determinize()
    aut.minimize()
    aut
  }

  private def splitTransitions[T](list: List[(T, Int)]) = {
    val orderedList = list.sortWith {case (e1, e2) => e1._2 < e2._2}
    var tuple: Set[T] = Set(orderedList.head._1)
    var start: Int = orderedList.head._2
    var res: List[(Set[T], Range)] = List.empty

    def addElement(states: Set[T], range: Range): Unit = {
      if(res.nonEmpty && res.head._2 == range)
        res = (states ++ res.head._1, range) :: res.tail
      else if(res.nonEmpty &&
              res.head._2.last == range.head &&
              (res.head._1 subsetOf states))
        res = (states, range) :: res.tail
      else if(res.nonEmpty &&
              res.head._2.last == range.head &&
              (states subsetOf res.head._1))
        res = res
      else if(res.nonEmpty &&
              res.head._2.last == range.head &&
              res.head._2.length == 1)
        res = (states, range.head + 1 to range.last) ::
              (res.head._1 ++ states, res.head._2) ::
              res.tail
      else if (res.nonEmpty &&
               res.head._2.last == range.head &&
               res.head._2.length > 1)
        res = (states ++ res.head._1, range) ::
              (res.head._1, res.head._2.head until res.head._2.last) ::
              res.tail
      else
        res = (states, range) :: res
    }

    for(e <- orderedList.tail) {
      if(tuple.isEmpty) {
        tuple += e._1
        start = e._2
      }
      else if(tuple(e._1)) {
        addElement(tuple,
                   if(start >= e._2) e._2 to e._2 else start to e._2)

        tuple -= e._1
        start = e._2 + 1
      }
      else {
        addElement(tuple,
                   if(start >= e._2) e._2 to e._2 else start until e._2)
        tuple += e._1
        start = e._2
      }
    }

    res
  }

  private def createSymbolFromRange(r: Range): AFormula =
    if(r.head == r.last)
      AFormula.createSymbol(r.head, var1)
    else
      AFormula.symbolInRange(r.head, r.last, var1)

  private def buildSymbolIdentity(v1: Int, v2: Int): AFormula =
    (0 until AFormula.widthOfChar).foldLeft[AFormula](AFTrue) {
        case (f, bit) =>
          f & (AFCharVar(bit + AFormula.widthOfChar * v1) <=>
               AFCharVar(bit + AFormula.widthOfChar * v2))
    }

  private def buildBeginMarker(aut: Automaton): AFA = {
    val initSet = Set(aut.getInitialState)
    var cache: Map[State, List[(State, Int)]] = Map.empty
    var workList: List[Set[State]] = List(Set(aut.getInitialState))
    var transitions: Map[Set[State], Map[Set[State], AFormula]] =
      Map(initSet -> Map.empty[Set[State], AFormula])
    def getTransitions(states: Set[State]) = {
      var res: List[(State, Int)] = List.empty

      for(s <- states)
        res = (cache get s match {
          case Some(x) => x
          case None =>
            var res: List[(State, Int)] = List.empty

            for(t <- s.getTransitions.asScala)
              res = (t.getDest, t.getMin.toInt) ::
                    (t.getDest, t.getMax.toInt) :: res

            cache += s -> res
            res
        }) ::: res

      res
    }
    def buildAFA: AFA = {
      val symbolIdentity = buildSymbolIdentity(var1, var2)
      var setToState: Map[Set[State], Int] = Map.empty
      val states: ArrayBuffer[AFormula] =
        ArrayBuffer.fill[AFormula](transitions.size)(AFFalse)

      transitions foreach(e => setToState += e._1 -> (setToState.size + 1))
      transitions foreach { case(s, t) =>
        val formula = t.foldLeft[AFormula](AFFalse) { case (f, e) =>
          f | (AFStateVar(setToState(e._1)) &
               ~AFSpecSymb(var1) & ~AFSpecSymb(var2) & symbolIdentity & e._2)
        }

        states(setToState(s) - 1) =
          if (s forall (!_.isAccept)) {
            formula
          }
          else {
            states += formula
            AFStateVar(states.size)      &
            AFormula.createEpsilon(var1) &
            AFormula.createSpecialSymbol(1, var2)
          }
      }

      val initState = (1 to transitions.size).foldLeft[AFormula](AFFalse) {
        _ | AFStateVar(_) } &
        AFormula.createEpsilon(var1) &
        AFormula.createEpsilon(var2)

      val resStates = initState +: states.toVector
      val finalFormula = ((0 until resStates.size).toSet - 
        setToState(Set(aut.getInitialState))).foldLeft[AFormula](AFTrue) (
          _ & ~AFStateVar(_)
        )

      new AFA(AFStateVar(0),
              resStates, 
              finalFormula)
    }

    while(workList.nonEmpty) {
      val tuple = workList.head
      val res = splitTransitions(getTransitions(tuple + aut.getInitialState))
      var neg: AFormula = AFFalse
      var upperBound: Int = 0xffff  // max. value of unicode.
      def update(map: Map[Set[State], AFormula], f: AFormula) =
        map + (tuple -> (map.getOrElse(tuple, AFFalse) | f))

      workList = workList.tail
      res foreach { e =>
        if(e._2.last != upperBound)
          neg |= createSymbolFromRange((e._2.last + 1) to upperBound)

        upperBound = e._2.head - 1
        transitions += e._1 -> (transitions get e._1 match {
        case Some(x) =>
          update(x, createSymbolFromRange(e._2))

        case None =>
          workList = e._1 :: workList
          Map(tuple -> createSymbolFromRange(e._2))
      })}

      if(upperBound > 0 ) neg |= createSymbolFromRange(0 to upperBound)
      transitions += initSet -> update(transitions(initSet), neg)
    }

    buildAFA
  }

  private def brics2AFATransducer(aut : Automaton,
                                  v: Int,
                                  ev: Int) : AFA = {
    var finalStates: AFormula = AFFalse
    val initState = aut.getInitialState
    val states = initState +: (aut.getStates.asScala - initState).toVector
    val stateInd = states.iterator.zipWithIndex.toMap
    val partOfLabel = ~AFSpecSymb(v) & AFormula.createEpsilon(ev)
    val transFors: Vector[AFormula] = states map { state =>
      if(state.isAccept)
        finalStates |= AFStateVar(stateInd(state))

      state.getTransitions.asScala.foldLeft[AFormula](AFFalse) {
        case (f, t) =>
          val targetConstr = AFStateVar(stateInd(t.getDest))
          val labelConstr =
            if (t.getMin == t.getMax)
              partOfLabel & AFormula.createSymbol(t.getMin, v)
            else
              partOfLabel & AFormula.symbolInRange(t.getMin, t.getMax, v)

          f | (targetConstr & labelConstr)
      }
    }

    new AFA(AFStateVar(0), transFors, finalStates)
  }

  private def concatenation(lAfa: AFA, rAfa: AFA): AFA = {
    val reAfa: AFA = rAfa shiftStateVariables lAfa.states.size
    val rAfaIS: AFormula = reAfa.states.head
    var states: Vector[AFormula] = lAfa.states ++: reAfa.states
    val finalStates: AFormula =
      if(rAfa.finalStateSet(0))
        lAfa.finalStates | reAfa.finalStates
      else
        reAfa.finalStates

    lAfa.finalStateSet.foreach(s => states = states.updated(s, rAfaIS | states(s)))
    new AFA(AFStateVar(0), states, finalStates)
  }

  private def product(aut1: Automaton, aut2: Automaton): AFA = {
    val afa1: AFA = brics2AFATransducer(aut1, var2, var3)
    val afa2: AFA = brics2AFATransducer(aut2, var3, var2)
    val symbol = AFormula.createSpecialSymbol(1, var2) & AFormula.createEpsilon(var3)
    val states = (afa1.states.view.zipWithIndex map {case (transitions, state) =>
      if(afa1.finalStateSet contains state)
        AFFalse
      else
        transitions | (AFStateVar(state) & symbol)
    }).toVector

    concatenation(new AFA(AFStateVar(0), states, afa1.finalStates), afa2)
  }

  private def A4ReplaceAllReluctant(pattern: Automaton, substit: Automaton): AFA = {
    def createSymbolFormula(range: Range, v: Int): AFormula =
      range.foldLeft[AFormula](AFFalse)(_ | AFormula.createSymbol(_, v))

    pattern.getAcceptStates.asScala.foreach(_.getTransitions.clear())
    pattern.determinize()
    pattern.minimize()
    val afa: AFA = product(pattern, substit) shiftStateVariables 1
    val initTrans =
      (AFStateVar(0) & ~AFSpecSymb(var2) & ~AFSpecSymb(var3) & buildSymbolIdentity(var2, var3)) |
      (AFStateVar(1) & AFormula.createSpecialSymbol(1, var2) & AFormula.createEpsilon(var3))
    var states: Vector[AFormula] = initTrans +: afa.states
    val symbol: AFormula = AFormula.createEpsilon(var2) & AFormula.createEpsilon(var3)
    val finalFormula = (1 until states.size).foldLeft[AFormula](AFTrue) (
      _ & ~AFStateVar(_)
    )

    afa.finalStateSet.foreach { state =>
      states = states.updated(state, AFormula(Set(0)) & symbol)
    }

    new AFA(AFStateVar(0), states, finalFormula)
  }

  private def buildBeginMarker(pattern: String): AFA = {
    val aut: Automaton = buildAutomaton(pattern)

    SpecialOperations.reverse(aut)
    aut.determinize()
    aut.minimize()

    buildBeginMarker(aut)
  }

  def apply(pattern: String, substitution: String): AFA = {
    val autPattern: Automaton = buildAutomaton(pattern)
    val autSubstitution: Automaton = buildAutomaton(substitution)
    AFA.synchronise(buildBeginMarker(pattern),
                    A4ReplaceAllReluctant(autPattern, autSubstitution), var2)
  }

  def getAFAs(pattern: String, substitution: String): (AFA, AFA) = {
    val autPattern: Automaton = buildAutomaton(pattern)
    val autSubstitution: Automaton = buildAutomaton(substitution)
    var1 = 1
    var2 = 0
    val res1 = buildBeginMarker(pattern)
    var2 = 1
    var3 = 0
    val res2 = A4ReplaceAllReluctant(autPattern, autSubstitution)
    
    (res1, res2)
  }

  def apply(pattern: String, substitution: String, v1: Int, v2: Int): AFA = {
    var1 = v1
    var3 = v2
    apply(pattern, substitution)
  }
}
