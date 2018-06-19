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

import scala.collection.mutable.{HashMap => MHashMap, ArrayStack,
                                 HashSet => MHashSet, MultiMap,
                                 Set => MSet}
import scala.collection.{Set => GSet}

object AtomicStateAutomatonAdapter {
  def intern(a : Automaton) : Automaton = a match {
    case a : InternalisableAtomicStateAutomatonAdapter => a.internalise
    case a => a
  }
  def intern(a : AtomicStateAutomaton) : AtomicStateAutomaton = a match {
    case a : InternalisableAtomicStateAutomatonAdapter => a.internalise
    case a => a
  }
}

trait InternalisableAtomicStateAutomatonAdapter extends AtomicStateAutomaton  {
  import AtomicStateAutomatonAdapter.intern

  def |(that : Automaton) : Automaton =
    intern(this) | intern(that)
  def &(that : Automaton) : Automaton =
    intern(this) & intern(that)

  def apply(word : Seq[Int]) : Boolean =
    internalise.apply(word)     // TODO: optimise

  def getAcceptedWord : Option[Seq[Int]] =
    internalise.getAcceptedWord // TODO: optimise

  def internalise : AtomicStateAutomaton = {
    val builder = getBuilder
    val smap = new MHashMap[State, State]

    for (s <- states)
      smap.put(s, builder.getNewState)

    for (s <- states) {
      val t = smap(s)
      for ((to, label) <- outgoingTransitions(s))
        builder.addTransition(t, label, smap(to))
      builder.setAccept(t, isAccept(s))
    }

    builder.setInitialState(smap(initialState))

    builder.getAutomaton
  }
}

abstract class AtomicStateAutomatonAdapter[A <: AtomicStateAutomaton]
                                          (val underlying : A)
         extends AtomicStateAutomaton
         with InternalisableAtomicStateAutomatonAdapter {

  type State = underlying.State
  type TLabel = underlying.TLabel
  override val LabelOps = underlying.LabelOps

  def isEmpty : Boolean =
    !AutomataUtils.areConsistentAtomicAutomata(List(this))

  protected def computeReachableStates(initState : State,
                                       accStates : Set[State])
                                     : GSet[State] = {
    val fwdReachable, bwdReachable = new MHashSet[State]
    fwdReachable += initState

    val worklist = new ArrayStack[State]
    worklist push initState

    while (!worklist.isEmpty)
      for ((s, _) <- underlying.outgoingTransitions(worklist.pop))
        if (fwdReachable add s)
          worklist push s

    val backMapping = new MHashMap[State, MHashSet[State]]

    for (s <- fwdReachable)
      for ((t, _) <- underlying.outgoingTransitions(s))
        backMapping.getOrElseUpdate(t, new MHashSet) += s

    for (_s <- accStates; s = _s.asInstanceOf[State])
      if (fwdReachable contains s) {
        bwdReachable += s
        worklist push s
      }

    while (!worklist.isEmpty)
      for (list <- backMapping get worklist.pop; s <- list)
        if (bwdReachable add s)
          worklist push s

    if (bwdReachable.isEmpty)
      bwdReachable add initState

    bwdReachable
  }

  def getTransducerBuilder : AtomicStateTransducerBuilder[State, TLabel] =
    underlying.getTransducerBuilder

  def getBuilder : AtomicStateAutomatonBuilder[State, TLabel] =
    underlying.getBuilder

  def isAccept(s : State) : Boolean =
    acceptingStates contains s

  // The fellowing fields can be redefined to modify the automaton

  lazy val initialState = underlying.initialState

  lazy val states = underlying.states

  lazy val acceptingStates = underlying.acceptingStates

  lazy val labelEnumerator = underlying.labelEnumerator

  def outgoingTransitions(from : State) : Iterator[(State, TLabel)] =
    underlying.outgoingTransitions(from)

}

////////////////////////////////////////////////////////////////////////////////

object InitFinalAutomaton {
  def setInitial[A <: AtomicStateAutomaton]
                (aut : A, initialState : A#State) =
    aut match {
      case InitFinalAutomaton(a, oldInit, oldFinal) =>
        InitFinalAutomaton(a, initialState, oldFinal)
      case _ =>
        InitFinalAutomaton(
          aut, initialState,
          aut.acceptingStates.asInstanceOf[Set[AtomicStateAutomaton#State]]
        )
    }

  def setFinal[A <: AtomicStateAutomaton]
              (aut : A, acceptingStates : Set[AtomicStateAutomaton#State]) =
    aut match {
      case InitFinalAutomaton(a, oldInit, oldFinal) =>
        InitFinalAutomaton(a, oldInit, acceptingStates)
      case _ =>
        InitFinalAutomaton(aut, aut.initialState, acceptingStates)
    }
}

case class InitFinalAutomaton[A <: AtomicStateAutomaton]
                             (_underlying : A,
                              val _initialState : A#State,
                              val _acceptingStates : Set[A#State])
     extends AtomicStateAutomatonAdapter[A](_underlying) {
  import AtomicStateAutomatonAdapter.intern

  override lazy val initialState = _initialState.asInstanceOf[State]

  override lazy val states =
    computeReachableStates(_initialState.asInstanceOf[State],
                           _acceptingStates.asInstanceOf[Set[State]])

  override lazy val acceptingStates =
    _acceptingStates.asInstanceOf[Set[State]] & states

  override def outgoingTransitions(from : State) : Iterator[(State, TLabel)] = {
    val _states = states
    for (p@(s, _) <- underlying.outgoingTransitions(from);
         if _states contains s)
    yield p
  }
}


/**
 * Representation of A with char-transitions removed and replaced with
 * s -- char --> s' for all (s, s') in replacements
 */
case class ReplaceCharAutomaton[A <: AtomicStateAutomaton]
                               (_underlying : A,
                                private val char: Char,
                                private val replacements : Iterable[(A#State, A#State)])
    extends AtomicStateAutomatonAdapter[A](_underlying) {
  import AtomicStateAutomatonAdapter.intern

  private lazy val replacementMap =
    replacements.foldLeft(new MHashMap[State, MSet[State]]
                                 with MultiMap[State, State])({
      case (m, (s1, s2)) => m.addBinding(s1.asInstanceOf[State],
                                         s2.asInstanceOf[State])
    })

  // TODO: fix label enumerator

  override def outgoingTransitions(from : State)
      : Iterator[(State, TLabel)] = {
    val itOrig =
      for ((s, lbl) <- underlying.outgoingTransitions(from);
           newLbl <- underlying.LabelOps.subtractLetter(char, lbl))
        yield (s, newLbl)

    if (replacementMap contains from) {
        val aLbl = underlying.LabelOps.singleton(char)
        val itNew =
          for (s <- replacementMap(from).iterator)
            yield (s, aLbl)
        itOrig ++ itNew
    } else {
      itOrig
    }
  }
}

/**
 * Representation of transducer pre-image
 */
case class TransducerPreImageAutomaton[A <: AtomicStateAutomaton]
                                      (val targ : A,
                                       val tran : AtomicStateTransducer)
    extends InternalisableAtomicStateAutomatonAdapter {
  import AtomicStateAutomatonAdapter.intern

  type State = (tran.State, targ.State)
  type TLabel = targ.TLabel
  override val LabelOps = targ.LabelOps

  def isEmpty : Boolean =
    !AutomataUtils.areConsistentAtomicAutomata(List(this))

  def getTransducerBuilder : AtomicStateTransducerBuilder[State, TLabel] =
    targ.getTransducerBuilder

  def getBuilder : AtomicStateAutomatonBuilder[State, TLabel] =
    targ.getBuilder

  def isAccept(s : State) : Boolean = {
    val (ts, as) = s
    tran.isAccept(ts) && targ.isAccept(as)
  }

  lazy val initialState = (tran.initialState, targ.initialState)

  // TODO: optimise
  lazy val states =
    for (ts <- tran.states; as <- targ.states) yield (ts, as)

  // TODO: optimise
  lazy val acceptingStates =
    for (ts <- tran.states; as <- targ.states) yield (ts, as)

  // TODO: fix this, it is not right
  lazy val labelEnumerator = targ.labelEnumerator

  override def outgoingTransitions(from : State)
      : Iterator[(State, TLabel)] = {
    val (ts, asInit) = from

    // when working through a transition ..
    abstract class Mode
    // .. either doing pre part (u remains to do)
    case class Pre(u : Seq[Char]) extends Mode
    // .. applying operation
    case object Op extends Mode
    // .. or working through post part, once done any new transition
    // added to pre-image aut should have label lbl
    case class Post(u : Seq[Char], lbl : aut.TLabel) extends Mode

    new Iterator[(State, TLabel)] {
      val itTranOut = tran.outgoingTransitions(ts)
      val worklist = new ArrayStack[(aut.State, Mode)]
      val nextState : Option[State] = getNext

      def hasNext : Boolean = nextState.isEmpty

      def next : (State, TLabel) = {
        val res = nextState
        nextState = getNext
        res
      }

      private def getNext : (State, TLabel) = {
        if (worklist.isEmpty) {
          if (itTranOut.hasNext) {
            if (tOp.preW.isEmpty)
              worklist.push((asInit, Op))
            else
              worklist.push((asInit, Pre(op.preW)))
          } else {
            return None
          }
        }

        while (!worklist.isEmpty) {
          val (as, m) = worklist.pop()

          m match {
            case Pre(u) if u.isEmpty => {
              // should never happen
            }
            case Pre(u) if !u.isEmpty => {
              val a = u.head
              val rest = u.tail
              for ((asNext, albl) <- aut.outgoingTransitions(as)) {
                if (aut.LabelOps.labelContains(a, albl)) {
                  if (!rest.isEmpty) {
                    worklist.push((asNext, Pre(rest)))
                  } else {
                    worklist.push((asNext, Op))
                  }
                }
              }
            }
            case Op => {
              tOp.op match {
                case Delete => {
                  worklist.push((as, Post(tOp.postW, tlbl)))
                }
                case Plus(n) => {
                  for ((asNext, albl) <- aut.outgoingTransitions(as)) {
                    val shftLbl = aut.LabelOps.shift(albl, n)
                    if (aut.LabelOps.isNonEmptyLabel(shftLbl)) {
                      for (preLbl <- aut.LabelOps.intersectLabels(shftLbl, tlbl)) {
                        worklist.push((asNext, Post(tOp.postW, preLbl)))
                      }
                    }
                  }
                }
              }
            }
            case Post(v, lbl) if !v.isEmpty => {
              val a = v.head
              val rest = v.tail
              for ((asNext, albl) <- aut.outgoingTransitions(as)) {
                if (aut.LabelOps.labelContains(a, albl))
                  worklist.push((asNext, Post(rest, lbl)))
              }
            }
            case Post(v, lbl) if v.isEmpty => {
              val psNext = getState(t.getDest, as)
              val tsNext = t.getDest
              return ((tsNext, as), lbl)
            }
          }
        }
        return None
      }
    }
  }
}
