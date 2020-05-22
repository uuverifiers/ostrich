/*
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (C) 2018-2020  Matthew Hague, Philipp Ruemmer
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

package ostrich

import scala.collection.mutable.{HashSet => MHashSet,
                                 LinkedHashSet => MLinkedHashSet,
                                 HashMap => MHashMap,
                                 Stack => MStack,
                                 MultiMap => MMultiMap,
                                 Set => MSet}

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}

import scala.collection.JavaConversions.{iterableAsScalaIterable,asJavaCollection}

import java.lang.StringBuilder

object BricsTransducer {
  def apply() : BricsTransducer =
    getBuilder.getTransducer

  def getBuilder : BricsTransducerBuilder =
    new BricsTransducerBuilder

  class TransducerState extends BState {
    override def toString = "q" + hashCode
  }
}

/**
 * Implementation of transducers as automata with input and output
 * states.  That is, from an input state, all transitions read a
 * character from input.  From an output state, all transitions produce
 * a character of output
 */
class BricsTransducer(val initialState : BricsAutomaton#State,
                      val lblTrans: Map[BricsAutomaton#State,
                                        Set[BricsTransducer#TTransition]],
                      val eTrans: Map[BricsAutomaton#State,
                                      Set[BricsTransducer#TETransition]],
                      val acceptingStates : Set[BricsAutomaton#State])
    extends Transducer {
  import BricsTransducer.TransducerState

  val LabelOps : TLabelOps[BricsAutomaton#TLabel] = BricsTLabelOps

  type TTransition = (BricsAutomaton#TLabel, OutputOp, BricsAutomaton#State)
  type TETransition = (OutputOp, BricsAutomaton#State)

  private def label(t : TTransition) = t._1
  private def operation(t : TTransition) = t._2
  private def dest(t : TTransition) : BricsAutomaton#State = t._3
  private def operation(t : TETransition) = t._1
  private def dest(t : TETransition) : BricsAutomaton#State = t._2
  private def dest(t : Either[TTransition, TETransition]) : BricsAutomaton#State
    = t match {
      case Left(lblTran) => dest(lblTran)
      case Right(eTran) => dest(eTran)
    }

  def isAccept(s : BricsAutomaton#State) = acceptingStates.contains(s)

  def preImage[A <: AtomicStateAutomaton]
              (aut : A,
               internal : Iterable[(A#State, A#State)]
                 = Iterable[(A#State, A#State)]()) : AtomicStateAutomaton =
  /* Exploration.measure("transducer pre-op") */ {

    val preBuilder = aut.getBuilder

    val internalMap =
      new MHashMap[aut.State, MSet[aut.State]]
          with MMultiMap[aut.State, aut.State] {
        override def default(q : aut.State) : MSet[aut.State] =
          MLinkedHashSet.empty[aut.State]
      }

    for ((s1, s2) <- internal)
      internalMap.addBinding(s1.asInstanceOf[aut.State],
                             s2.asInstanceOf[aut.State])

    // map states of pre-image aut to state of transducer and state of
    // aut
    val sMap = new MHashMap[aut.State, (BricsAutomaton#State, aut.State)]
    val sMapRev = new MHashMap[(BricsAutomaton#State, aut.State), aut.State]

    val initAutState = aut.initialState
    val newInitState = preBuilder.getNewState
    preBuilder setInitialState newInitState

    sMap += (newInitState -> ((initialState, initAutState)))
    sMapRev += (initialState, initAutState) -> newInitState

    // collect silent transitions during main loop and eliminate them
    // after (TODO: think of more efficient solution)
    val silentTransitions = new MHashMap[aut.State, MSet[aut.State]]
                            with MMultiMap[aut.State, aut.State]

    // transducer state, automaton state
    def getState(ts : BricsAutomaton#State, as : aut.State) = {
      sMapRev.getOrElse((ts, as), {
        val ps = preBuilder.getNewState
        sMapRev += ((ts, as) -> ps)
        sMap += (ps -> (ts, as))
        ps
      })
    }

    // when working through a transition ..
    abstract class Mode
    // .. either doing pre part (u remains to do)
    case class Pre(u : Seq[Char]) extends Mode
    // .. applying operation
    case object Op extends Mode
    // .. or working through post part, once done any new transition
    // added to pre-image aut should have label lbl
    case class Post(u : Seq[Char], lbl : aut.TLabel) extends Mode
    // post part for adding etran
    case class EPost(u : Seq[Char]) extends Mode

    // (ps, ts, t, as, m)
    // state of pre aut to add new transitions from
    // current state of transducer reached
    // transition being processed
    // current state of target aut reached
    // mode as above
    val worklist = new MStack[(aut.State,
                               BricsAutomaton#State,
                               Either[TTransition, TETransition],
                               aut.State,
                               Mode)]
    val seenlist = new MHashSet[(aut.State,
                                 BricsAutomaton#State,
                                 Either[TTransition, TETransition],
                                 aut.State,
                                 Mode)]

    def addWork(ps : aut.State ,
                ts : BricsAutomaton#State,
                t : Either[TTransition, TETransition],
                as : aut.State,
                m : Mode) {
      if (!seenlist.contains((ps, ts, t, as, m))) {
        seenlist += ((ps, ts, t, as, m))
        worklist.push((ps, ts, t, as, m))
      }
    }

    def reachStates(ts : BricsAutomaton#State, as : aut.State) {
      val ps = getState(ts, as)
      if (isAccept(ts) && aut.isAccept(as))
        preBuilder.setAccept(ps, true)

      for (trans <- lblTrans.get(ts); t <- trans) {
        val tOp = operation(t)
        if (tOp.preW.isEmpty)
          addWork(ps, ts, Left(t), as, Op)
        else
          addWork(ps, ts, Left(t), as, Pre(tOp.preW))
      }

      for (trans <- eTrans.get(ts); t <- trans) {
        val tOp = operation(t)
        if (tOp.preW.isEmpty)
          addWork(ps, ts, Right(t), as, Op)
        else
          addWork(ps, ts, Right(t), as, Pre(tOp.preW))
      }
    }

    reachStates(initialState, aut.initialState)

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
          for ((asNext, albl) <- aut.outgoingTransitions(as)) {
            if (aut.LabelOps.labelContains(a, albl)) {
              if (!rest.isEmpty) {
                addWork(ps, ts, t, asNext, Pre(rest))
              } else {
                addWork(ps, ts, t, asNext, Op)
              }
            }
          }
        }
        case Op => {
          t match {
            case Left(lblTran) => {
              val tOp = operation(lblTran)
              val (min, max) = label(lblTran)
              val tlbl = aut.LabelOps.interval(min, max)
              tOp.op match {
                case NOP => {
                  addWork(ps, ts, t, as, Post(tOp.postW, tlbl))
                }
                case Internal => {
                  for (asNext <- internalMap(as))
                    addWork(ps, ts, t, asNext, Post(tOp.postW, tlbl))
                }
                case Plus(n) => {
                  for ((asNext, albl) <- aut.outgoingTransitions(as)) {
                    val shftLbl = aut.LabelOps.shift(albl, -n)
                    if (aut.LabelOps.isNonEmptyLabel(shftLbl)) {
                      for (preLbl <- aut.LabelOps.intersectLabels(shftLbl, tlbl)) {
                        addWork(ps, ts, t, asNext, Post(tOp.postW, preLbl))
                      }
                    }
                  }
                }
              }
            }

            case Right(eTran) => {
              val tOp = operation(eTran)
              tOp.op match {
                case NOP => {
                  // deleting an e-label means doing nothing
                  addWork(ps, ts, t, as, EPost(tOp.postW))
                }
                case Internal => {
                  for (asNext <- internalMap(as))
                    addWork(ps, ts, t, asNext, EPost(tOp.postW))
                }
                case Plus(_) => {
                  // treat as delete -- can't shift e-tran
                  addWork(ps, ts, t, as, EPost(tOp.postW))
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
              addWork(ps, ts, t, asNext, Post(rest, lbl))
          }
        }
        case Post(v, lbl) if v.isEmpty => {
          val tsNext = dest(t)
          val psNext = getState(dest(t), as)

          preBuilder.addTransition(ps, lbl, psNext)

          reachStates(tsNext, as)
        }
        case EPost(v) if !v.isEmpty => {
          val a = v.head
          val rest = v.tail
          for ((asNext, albl) <- aut.outgoingTransitions(as)) {
            if (aut.LabelOps.labelContains(a, albl))
              addWork(ps, ts, t, asNext, EPost(rest))
          }
        }
        case EPost(v) if v.isEmpty => {
          val tsNext = dest(t)
          val psNext = getState(dest(t), as)

          silentTransitions.addBinding(ps, psNext)

          reachStates(tsNext, as)
        }
      }
    }

    AutomataUtils.buildEpsilons(preBuilder, silentTransitions)

    preBuilder.getAutomaton
  }

  def postImage[A <: AtomicStateAutomaton]
               (aut : A, internalAut : Option[A] = None)
      : AtomicStateAutomaton = {
    val builder = aut.getBuilder

    // map states of pre-image aut to state of transducer and state of
    // aut
    val sMap = new MHashMap[aut.State, (BricsAutomaton#State, aut.State)]
    val sMapRev = new MHashMap[(BricsAutomaton#State, aut.State), aut.State]

    val internalStateMap : Option[Map[A#State, aut.State]] =
      internalAut.map(_.states.map(s => (s -> builder.getNewState)).toMap)
    val internalInit : Option[aut.State] =
      internalAut.map(ia => internalStateMap.get(ia.initialState))
    val internalFins : Option[Set[aut.State]] =
      internalAut.map(_.acceptingStates.map(internalStateMap.get))

    val initAutState = aut.initialState
    val newInitState = builder.initialState

    sMap += (newInitState -> ((initialState, initAutState)))
    sMapRev += (initialState, initAutState) -> newInitState

    // collect silent transitions during main loop and eliminate them
    // after (TODO: think of more efficient solution)
    val silentTransitions = new MHashMap[aut.State, MSet[aut.State]]
                            with MMultiMap[aut.State, aut.State]

    val worklist = new MStack[aut.State]
    worklist.push(newInitState)

    // transducer state, automaton state
    def getState(ts : BricsAutomaton#State, as : aut.State) = {
      sMapRev.getOrElse((ts, as), {
        val ps = builder.getNewState
        if (isAccept(ts) && aut.isAccept(as))
          builder.setAccept(ps, true)
        sMapRev += ((ts, as) -> ps)
        sMap += (ps -> (ts, as))
        worklist.push(ps)
        ps
      })
    }

    // add transitions to run over word reaching targState if given (and
    // word not empty).  Returns state reached (which is targState or a
    // new state if no targState)
    def wordRun(ps : aut.State,
                word : Seq[Char],
                targState : Option[aut.State]) : aut.State = {
      if (word.isEmpty) {
        ps
      } else if (word.size == 1 && !targState.isEmpty) {
        val targ = targState.get
        builder.addTransition(ps, aut.LabelOps.singleton(word(0)), targ)
        targ
      } else {
        val psNext = builder.getNewState
        builder.addTransition(ps, aut.LabelOps.singleton(word(0)), psNext)
        wordRun(psNext, word.tail, targState)
      }
    }

    while (!worklist.isEmpty) {
      // pre aut state, transducer state, automaton state
      val ps = worklist.pop()
      val (ts, as) = sMap(ps)

      for (ts <- lblTrans.get(ts);
           t <- ts;
           (asNext, aLbl) <- aut.outgoingTransitions(as);
           (min, max) = label(t);
           tLbl = aut.LabelOps.interval(min, max);
           lbl <- aut.LabelOps.intersectLabels(aLbl, tLbl)) {
        val psNext = getState(dest(t), asNext)
        val tOp = operation(t)
        tOp.op match {
          case NOP => {
            if (tOp.preW.isEmpty && tOp.postW.isEmpty) {
              silentTransitions.addBinding(ps, psNext)
            } else if (tOp.postW.isEmpty) {
              wordRun(ps, tOp.preW, Some(psNext))
            } else  {
              val psMid = wordRun(ps, tOp.preW, None)
              wordRun(psMid, tOp.postW, Some(psNext))
            }
          }
          case Internal => {
            if (internalAut.isEmpty) {
              throw new IllegalArgumentException("Post image of a transducer with internal transitions needs and internalAut")
            } else {
              silentTransitions.addBinding(ps, internalInit.get)
              for (f <- internalFins.get)
                silentTransitions.addBinding(f, psNext)
            }
          }
          case Plus(n) => {
            val shiftLbl = aut.LabelOps.shift(lbl, n)
            if (aut.LabelOps.isNonEmptyLabel(shiftLbl)) {
              val psMid = wordRun(ps, tOp.preW, None)
              if (tOp.postW.isEmpty) {
                builder.addTransition(psMid, shiftLbl, psNext)
              } else {
                val psMidNext = builder.getNewState
                builder.addTransition(psMid, shiftLbl, psMidNext)
                wordRun(psMidNext, tOp.postW, Some(psNext))
              }
            }
          }
        }
      }

      for (ts <- eTrans.get(ts); t <- ts) {
        val psNext = getState(dest(t), as)
        val tOp = operation(t)

        def handleNoOut(tOp : OutputOp) = {
          if (tOp.preW.isEmpty && tOp.postW.isEmpty) {
            silentTransitions.addBinding(ps, psNext)
          } else if (tOp.postW.isEmpty) {
            wordRun(ps, tOp.preW, Some(psNext))
          } else  {
            val psMid = wordRun(ps, tOp.preW, None)
            wordRun(psMid, tOp.postW, Some(psNext))
          }
        }

        tOp.op match {
          case NOP => handleNoOut(tOp)
          case Internal => {
            if (internalAut.isEmpty) {
              throw new IllegalArgumentException("Post image of a transducer with internal transitions needs and internalAut")
            } else {
              silentTransitions.addBinding(ps, internalInit.get)
              for (f <- internalFins.get)
                silentTransitions.addBinding(f, psNext)
            }
          }
          // treat as delete
          case Plus(_) => handleNoOut(tOp)
        }
      }
    }

    if (!internalAut.isEmpty) {
      for ((is1, ilbl, is2) <- internalAut.get.transitions)
        builder.addTransition(internalStateMap.get(is1),
                              ilbl.asInstanceOf[aut.TLabel],
                              internalStateMap.get(is2))
    }

    AutomataUtils.buildEpsilons(builder, silentTransitions)

    builder.getAutomaton
  }

  override def toString = {
    "init: " + initialState + "\n" +
    "finals: " + acceptingStates + "\n" +
    lblTrans.mkString("\n") +
    eTrans.mkString("\n")
  }

  /**
   * Apply the transducer to the input, replacing any internal
   * characters with the given string.
   *
   * Assumes transducer is functional, so returns the first found output
   */
  def apply(input : String, internal : String = "") : Option[String] = {
    if (input.size == 0 && isAccept(initialState))
      return Some("")

    val worklist = new MStack[(BricsAutomaton#State, Int, String)]
    val seenlist = new MHashSet[(BricsAutomaton#State, Int)]

    worklist.push((initialState, 0, ""))

    while (!worklist.isEmpty) {
      val (s, pos, output) = worklist.pop

      if (pos < input.size) {
        val a = input(pos)
        for (ts <- lblTrans.get(s); t <- ts) {
          val pnext = pos + 1
          val snext = dest(t)
          val lbl = label(t)
          if (LabelOps.labelContains(a, lbl) && !seenlist.contains((snext, pnext))) {
            val tOp = operation(t)
            val opOut = tOp.op match {
              case NOP => ""
              case Internal => internal
              case Plus(n) => (a + n).toChar.toString
            }
            val outnext = output + tOp.preW.mkString + opOut + tOp.postW.mkString
            if (pnext >= input.length && isAccept(snext))
              return Some(outnext)
            worklist.push((snext, pnext, outnext))
          }
        }
      }

      for (ts <- eTrans.get(s); t <- ts) {
        val pnext = pos
        val snext = dest(t)
        if (!seenlist.contains((snext, pnext))) {
          val tOp = operation(t)
          val opOut = tOp.op match {
            case NOP => ""
            case Internal => internal
            // treat as delete
            case Plus(_) => ""
          }
          val outnext = output + tOp.preW.mkString + opOut + tOp.postW.mkString
          if (pnext >= input.length && isAccept(snext))
            return Some(outnext)
          worklist.push((snext, pnext, outnext))
        }
      }
    }

    return None
  }

  override def toDot() : String = {
    val sb = new StringBuilder()
    sb.append("digraph transducer {\n")

    sb.append(initialState + "[shape=square];\n")
    for (f <- acceptingStates)
        sb.append(f + "[peripheries=2];\n")

    for (trans <- lblTrans) {
      val (state, arrows) = trans
      for (arrow <- arrows) {
        val (lbl, op, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"" + lbl + "/" + op + "\"];\n")
      }
    }

    for (trans <- eTrans) {
      val (state, arrows) = trans
      for (arrow <- arrows) {
        val (op, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"epsilon /" + op + "\"];\n")
      }
    }

    sb.append("}\n")

    return sb.toString()
  }
}

class BricsTransducerBuilder
    extends TransducerBuilder[BricsAutomaton#State,
                              BricsAutomaton#TLabel] {
  val LabelOps : TLabelOps[BricsAutomaton#TLabel] = BricsTLabelOps

  var initialState : BricsAutomaton#State = getNewState
  val acceptingStates : MSet[BricsAutomaton#State]
    = new MLinkedHashSet[BricsAutomaton#State]

  val lblTrans
    = new MHashMap[BricsAutomaton#State, MSet[BricsTransducer#TTransition]]
      with MMultiMap[BricsAutomaton#State, BricsTransducer#TTransition] {
      override def default(q : BricsAutomaton#State) : MSet[BricsTransducer#TTransition] =
        MLinkedHashSet.empty[BricsTransducer#TTransition]
    }
  val eTrans
    = new MHashMap[BricsAutomaton#State, MSet[BricsTransducer#TETransition]]
      with MMultiMap[BricsAutomaton#State, BricsTransducer#TETransition] {
      override def default(q : BricsAutomaton#State) : MSet[BricsTransducer#TETransition] =
        MLinkedHashSet.empty[BricsTransducer#TETransition]
    }

  def getNewState : BricsAutomaton#State = new BricsTransducer.TransducerState

  def setInitialState(s : BricsAutomaton#State) = {
    initialState = s
  }

  def isAccept(s : BricsAutomaton#State) = acceptingStates.contains(s)

  def setAccept(s : BricsAutomaton#State, isAccept : Boolean) =
    if (isAccept)
      acceptingStates += s
    else
      acceptingStates -= s

  def addTransition(s1 : BricsAutomaton#State,
                    lbl : BricsAutomaton#TLabel,
                    op : OutputOp,
                    s2 : BricsAutomaton#State) =
    if (LabelOps.isNonEmptyLabel(lbl))
      lblTrans.addBinding(s1, (lbl, op, s2))

  def addETransition(s1 : BricsAutomaton#State,
                     op : OutputOp,
                     s2 : BricsAutomaton#State) =
    eTrans.addBinding(s1, (op, s2))

  def getTransducer = {
    minimize()
    // TODO: restrict to live reachable states
    new BricsTransducer(initialState,
                        lblTrans.toMap.mapValues(_.toSet),
                        eTrans.toMap.mapValues(_.toSet),
                        acceptingStates.toSet)
  }

  private def minimize() = {

    def dest(t : BricsTransducer#TTransition) : BricsAutomaton#State = t._3
    def edest(t : BricsTransducer#TETransition) : BricsAutomaton#State = t._2

    val fwdReach = new MHashSet[BricsAutomaton#State]
    val bwdMap = new MHashMap[BricsAutomaton#State, MSet[BricsAutomaton#State]]
                 with MMultiMap[BricsAutomaton#State, BricsAutomaton#State]
    val worklist = new MStack[BricsAutomaton#State]

    fwdReach += initialState
    worklist.push(initialState)

    while (!worklist.isEmpty) {
      val s = worklist.pop
      for (trans <- lblTrans.get(s); t <- trans) {
        val snext = dest(t)
        bwdMap.addBinding(snext, s)
        if (fwdReach.add(snext))
          worklist.push(snext)
      }
      for (trans <- eTrans.get(s); t <- trans) {
        val snext = edest(t)
        bwdMap.addBinding(snext, s)
        if (fwdReach.add(snext))
          worklist.push(snext)
      }
    }

    val bwdReach = new MHashSet[BricsAutomaton#State]

    for (s <- fwdReach; if isAccept(s)) {
      bwdReach += s
      worklist.push(s)
    }

    while (!worklist.isEmpty) {
      val s = worklist.pop

      for (snexts <- bwdMap.get(s);
           snext <- snexts;
           if fwdReach.contains(snext))
        if (bwdReach.add(snext))
          worklist.push(snext)
    }

    acceptingStates.retain(bwdReach.contains(_))
    lblTrans.retain((k, v) => bwdReach.contains(k))
    eTrans.retain((k, v) => bwdReach.contains(k))
    lblTrans.foreach({ case (k, v) => v.retain(t => bwdReach.contains(dest(t))) })
    eTrans.foreach({ case (k, v) => v.retain(t => bwdReach.contains(edest(t))) })
  }
}

