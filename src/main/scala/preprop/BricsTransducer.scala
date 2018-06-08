/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2018  Matthew Hague, Philipp Ruemmer
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

package strsolver.preprop

import scala.collection.mutable.{HashSet => MHashSet,
                                 HashMap => MHashMap,
                                 Stack => MStack}

import dk.brics.automaton.{Automaton => BAutomaton, State => BState}


object BricsTransducer {
  // TODO: dummy value because i can't think of a better way of getting a
  // builder that knows the value of State and TransitionLabel...
  val dummyTransducer = BricsTransducer()

  def apply() : BricsTransducer =
    new BricsTransducer(new BAutomaton, Set[BState]())

  def getBuilder : BricsTransducer#BricsAutomatonBuilder =
    dummyTransducer.getBuilder
}

/**
 * Implementation of transducers as automata with input and output
 * states.  That is, from an input state, all transitions read a
 * character from input.  From an output state, all transitions produce
 * a character of output
 */
class BricsTransducer(override val underlying : BAutomaton,
                      val inputStates : Set[BState])
  extends BricsAutomaton(underlying) with AtomicStateTransducer {

  /**
   * Whether q is an input or output state.  I.e. transitions from q
   * read or write (all must do same)
   */
  def isInput(s : State) = inputStates.contains(s)

  def preImage(aut : AtomicStateAutomaton) : AtomicStateAutomaton = {
    val baut : BricsAutomaton = aut match {
      case baut : BricsAutomaton => baut
      case _ => throw new IllegalArgumentException("BricsTransducers can only compute pre of a BricsAutomaton")
    }

    // Essentially build product with transducer
    val preBuilder = this.getBuilder

    val sMap = new MHashMap[State, (State, State)]
    val sMapRev = new MHashMap[(State, State), State]

    val initState = underlying.getInitialState
    val initAutState = baut.getInitialState
    val newInitState = preBuilder.getInitialState

    sMap += (newInitState -> ((initState, initAutState)))
    sMapRev += (initState, initAutState) -> newInitState

    // transducer state, automaton state
    def getNewState(ts : State, as : State) = {
      sMapRev.get((ts, as)) match {
        case Some(ps) => ps
        case None => {
          val ps = preBuilder.getNewState
          sMapRev += ((ts, as) -> ps)
          sMap += (ps -> (ts, as))
          ps
        }
      }
    }

    val worklist = MStack((newInitState, initState, initAutState))
    val seenlist = new MHashSet[(State, State)]

    def addWork(ps : State, ts : State, as : State) {
      if (!seenlist.contains((ts, as))) {
        seenlist += ((ts, as))
        worklist.push((ps, ts, as))
      }
    }

    while (!worklist.isEmpty) {
      // pre aut state, transducer state, automaton state
      val (ps, ts, as) = worklist.pop()

      // if ts and as are accepting, ts should also be accepting
      if (isAccept(ts) && baut.isAccept(as))
        preBuilder.setAccept(ps, true)

      // inputs lead to transitions in pre aut
      // outputs lead to joint (silent) step of transducer and aut
      if (isInput(ts)) {
        foreachTransition(ts, (label, tsNext) => {
          // advance transducer but keep same aut state
          val psNext = getNewState(tsNext, as)
          preBuilder.addTransition(ps, label, psNext)
          addWork(psNext, tsNext, as)
        })
      } else {
        foreachTransition(ts, (tlbl, tsNext) => {
            foreachTransition(as, (albl, asNext) => {
                if (labelsOverlap(tlbl, albl)) {
                  addWork(ps, tsNext, asNext)
                }
            })
        })
      }
    }

    preBuilder.getAutomaton
  }

  override def getBuilder : BricsTransducerBuilder = new BricsTransducerBuilder

  class BricsTransducerBuilder extends BricsAutomatonBuilder {
    val inputStates = new MHashSet[BState]

    def setInputState(q : State) =
      inputStates += q

    def setOutputState(q : State) =
      inputStates -= q
  }
}
