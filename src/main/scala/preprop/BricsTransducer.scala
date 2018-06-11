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

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}

import scala.collection.JavaConversions.iterableAsScalaIterable

/**
 * Symbolic operations on input
 */
abstract class InputOp
/**
 * Delete input character
 */
case object Delete extends InputOp
/**
 * Change input character by shifting (+0 to copy)
 */
case class Plus(val n : Int) extends InputOp

/**
 * Output operations for Brics Transducers: (u, o, v) where u is a
 * string to output first, o is an operation to translate the character
 * being read, and v is a string to output after.
 *
 * o can be +n or del
 */
case class BricsOutputOp(val preW : Seq[Char],
                         val op : InputOp,
                         val postW : Seq[Char])

object BricsTransducer {
  // TODO: dummy value because i can't think of a better way of getting a
  // builder that knows the value of State and TransitionLabel...
  val dummyTransducer = BricsTransducer()

  def apply() : BricsTransducer =
    new BricsTransducer(new BAutomaton, Map[(BState, BTransition), BricsOutputOp]())

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
                      val operations : Map[(BState, BTransition), BricsOutputOp])
  extends BricsAutomaton(underlying) with AtomicStateTransducer {

  def preImage(aut : AtomicStateAutomaton) : AtomicStateAutomaton = {
    val baut : BricsAutomaton = aut match {
      case baut : BricsAutomaton => baut
      case _ => throw new IllegalArgumentException("BricsTransducers can only compute pre of a BricsAutomaton")
    }

    val preBuilder = this.getBuilder

    // map states of pre-image aut to state of transducer and state of
    // aut
    val sMap = new MHashMap[State, (State, State)]
    val sMapRev = new MHashMap[(State, State), State]

    val initState = underlying.getInitialState
    val initAutState = baut.getInitialState
    val newInitState = preBuilder.getInitialState

    sMap += (newInitState -> ((initState, initAutState)))
    sMapRev += (initState, initAutState) -> newInitState

    // transducer state, automaton state
    def getState(ts : State, as : State) = {
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

    // when working through a transition ..
    abstract class Mode
    // .. either doing pre part (u remains to do)
    case class Pre(u : Seq[Char]) extends Mode
    // .. applying operation
    case object Op extends Mode
    // .. or working through post part, once done any new transition
    // added to pre-image aut should have label lbl
    case class Post(u : Seq[Char], lbl : TransitionLabel) extends Mode

    // (ps, ts, t, as, m)
    // state of pre aut to add new transitions from
    // current state of transducer reached
    // transition being processed
    // current state of target aut reached
    // mode as above
    val worklist = new MStack[(State, State, BTransition, State, Mode)]
    val seenlist = new MHashSet[(State, State, BTransition, State, Mode)]

    def addWork(ps : State , ts : State, t : BTransition, as : State, m : Mode) {
      if (!seenlist.contains((ps, ts, t, as, m))) {
        seenlist += ((ps, ts, t, as, m))
        worklist.push((ps, ts, t, as, m))
      }
    }

    def reachStates(ts : State, as : State) {
      val ps = getState(ts, as)
      if (isAccept(ts) && baut.isAccept(as))
        preBuilder.setAccept(ps, true)

      for (t <- ts.getTransitions) {
        val tOp = operations(ts, t)
        if (tOp.preW.isEmpty)
          addWork(ps, ts, t, as, Op)
        else
          addWork(ps, ts, t, as, Pre(tOp.preW))
      }
    }

    reachStates(getInitialState, baut.getInitialState)

    while (!worklist.isEmpty) {
      // pre aut state, transducer state, automaton state
      val (ps, ts, t, as, m) = worklist.pop()

      m match {
        case Pre(u) if u.isEmpty => {
          // should never happen
        }
        case Pre(u) if !u.isEmpty => {
          val a = u.head
          val rest = u.tail
          baut.foreachTransition(as, (albl, asNext) => {
              if (labelContains(a, albl)) {
                if (!rest.isEmpty) {
                  addWork(ps, ts, t, asNext, Pre(rest))
                } else {
                  addWork(ps, ts, t, asNext, Op)
                }
              }
          })
        }
        case Op => {
          val tOp = operations(ts, t)
          tOp.op match {
            case Delete => {
              val lbl = (t.getMin, t.getMax)
              addWork(ps, ts, t, as, Post(tOp.postW, lbl))
            }
            case Plus(n) => {
              baut.foreachTransition(as, { case ((amin, amax), asNext) => {
                val apreMin = Math.max(Char.MinValue, amin - n).toChar
                val apreMax = Math.min(Char.MaxValue, amax - n).toChar
                if (apreMin <= apreMax) {
                    val preLbl = intersectLabels((apreMin, apreMax),
                                                 (t.getMin, t.getMax))
                    addWork(ps, ts, t, asNext, Post(tOp.postW, preLbl))
                }
              }})
            }
          }
        }
        case Post(v, lbl) if !v.isEmpty => {
          val a = v.head
          val rest = v.tail
          baut.foreachTransition(as, (albl, asNext) => {
            if (labelContains(a, albl))
              addWork(ps, ts, t, asNext, Post(rest, lbl))
          })
        }
        case Post(v, lbl) if v.isEmpty => {
          val psNext = getState(t.getDest, as)
          val tsNext = t.getDest

          preBuilder.addTransition(ps, lbl, psNext)

          reachStates(tsNext, as)
        }
      }
    }

    preBuilder.getAutomaton
  }

  override def toString = {
    super.toString + '\n' + operations.mkString("\n")
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
