/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2020-2022 Zhilei Han. All rights reserved.
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

package ostrich.automata

import ostrich.{OstrichStringTheory, ECMARegexParser}
import StreamingTransducer._
import AnchoredLabels._

import ap.basetypes.IdealInt
import ap.parser._
import ap.theories.strings.StringTheory

import dk.brics.automaton.{Automaton => BAutomaton,
                           State => BState,
                           Transition => BTransition}

import scala.collection.mutable.{HashMap => MHashMap,
                                 HashSet => MHashSet,
                                 LinkedHashSet => MLinkedHashSet,
                                 Stack => MStack,
                                 TreeSet => MTreeSet,
                                 MultiMap => MMultiMap,
                                 Set => MSet,
                                 Map => MMap}

import java.lang.StringBuilder

object PrioAutomaton {
  type State = BricsAutomaton#State
  type TLabel = AnchoredLabel
  val LabelOps : TLabelOps[TLabel] = AnchoredLabelOps
  type SigmaTransition = (TLabel, State)
  type ETransition = State

  private class PFAState extends BState {
    override def toString = "p" + hashCode
  }

  def getNewState : State = new PFAState
}

// Prioritized Finite Automata
// Contract :
// 1. all transitions going out of `initial` are epsilon transition
// 2. no input transition into `initial`
// 3. no transition going out of any accepting state
// The construction method is manifold, depending on the PFA builder chosen
case class PrioAutomaton(
  val sTran: MMap[PrioAutomaton.State, Seq[PrioAutomaton.SigmaTransition]],
  val preTran: MMap[PrioAutomaton.State, Seq[PrioAutomaton.ETransition]],
  val postTran: MMap[PrioAutomaton.State, Seq[PrioAutomaton.ETransition]],
  val initial: PrioAutomaton.State,
  val accepting: (MSet[PrioAutomaton.State], MSet[PrioAutomaton.State]))
{
    def toDot() : String = {
      val sb = new StringBuilder()
      sb.append("digraph PFA {\n")

      sb.append(initial + "[shape=square];\n")
      val (f1, f2) = accepting
      for (s <- f1) {
        sb.append(s + "[peripheries=2];\n")
      }
      for (s <- f2) {
        sb.append(s + "[peripheries=3];\n")
      }

      var priority = Int.MaxValue
      for (tran <- sTran) {
        val (state, arrows) = tran
        for (arrow <- arrows) {
          val (lbl, dest) = arrow
          sb.append(state + " -> " + dest);
          sb.append("[label=\"" + lbl.toString + "/" + priority + "\"];\n")
          priority -= 1
        }
      }

      priority = Int.MaxValue
      for ((s, arrow) <- preTran; dest <- arrow) {
        sb.append(s + " -> " + dest);
        sb.append("[label=\"preeps" + "/" + priority + "\"];\n")
        priority -= 1
      }

      priority = Int.MaxValue
      for ((s, arrow) <- postTran; dest <- arrow) {
        sb.append(s + " -> " + dest);
        sb.append("[label=\"posteps" + "/" + priority + "\"];\n")
        priority -= 1
      }

      sb.append("}\n")

      return sb.toString()
    }
  }

// A PFA builder constructs PFA based on regular expression structure
// following *certain* semantics of regex.
abstract class PrioAutomatonBuilder(val theory : OstrichStringTheory) {

  type State = PrioAutomaton.State
  type TLabel = PrioAutomaton.TLabel
  val LabelOps : TLabelOps[TLabel] = PrioAutomaton.LabelOps
  type SigmaTransition = PrioAutomaton.SigmaTransition
  type ETransition = PrioAutomaton.ETransition

  /*
   * The Regex2PFA associated with this builder
   */
  val regex2pfa = new Regex2PFA(theory, this)

  def none() : PrioAutomaton
  def epsilon() : PrioAutomaton
  def single(lbl : TLabel) : PrioAutomaton
  def constant(str: String) : PrioAutomaton = {
    if (str.isEmpty) {
      epsilon
    } else {
      val h = str.head
      val t = str.tail
      val haut = single(LabelOps.interval(h.toChar, h.toChar))
      concat(haut, constant(t))
    }
  }

  def alternate(aut1 : PrioAutomaton, aut2 : PrioAutomaton) : PrioAutomaton
  def concat(aut1 : PrioAutomaton, aut2 : PrioAutomaton) : PrioAutomaton

  def star(aut : PrioAutomaton) : PrioAutomaton
  def lazystar(aut : PrioAutomaton) : PrioAutomaton
  def plus(aut : PrioAutomaton) : PrioAutomaton
  def lazyplus(aut : PrioAutomaton) : PrioAutomaton

  def optional(aut : PrioAutomaton) : PrioAutomaton
  def lazyoptional(aut : PrioAutomaton) : PrioAutomaton

  def loop(autA : PrioAutomaton, n1 : IdealInt, n2 : IdealInt) : PrioAutomaton
  def lazyloop(autA : PrioAutomaton, n1 : IdealInt, n2 : IdealInt) : PrioAutomaton

  // return a deep copy of `base` and update the Regex2PFA database
  // which means
  // 1) if state s is related to capture group i
  // then the copyed state s' should be related to i too
  // 2) if state s is an initial state of some automaton corresponding
  // to capture group i, so is the copyed state s'
  def duplicate(base : PrioAutomaton) : PrioAutomaton = {
    import PrioAutomaton.getNewState

    base match {
      case PrioAutomaton(t1, pre1, post1, init1, (f1, f2)) => {

        // map from base.state to copy.state
        val sMap = new MHashMap[State, State]
        // states of old automaton
        val worklist = new MStack[State]

        def mapState(oldstate : State, newstate : State) = {
          sMap += (oldstate -> newstate)
        }
        def getState(oldstate : State) : State = {
          sMap.getOrElse(oldstate, {
            val newstate = getNewState
            mapState(oldstate, newstate)
            worklist.push(oldstate)
            newstate
          })
        }

        val newinit = getState(init1)

        val newf1 = new MHashSet[State]
        val newf2 = new MHashSet[State]
        val newtrans = new MHashMap[State, Seq[SigmaTransition]]
        val newpre = new MHashMap[State, Seq[ETransition]]
        val newpost = new MHashMap[State, Seq[ETransition]]

        // we use a DFS here to exclude unreachable states
        while (!worklist.isEmpty) {
          // note a state is visited only once
          val oldstate = worklist.pop()
          val newstate = getState(oldstate)
          if (f1 contains oldstate) {
            newf1 += newstate
          }
          if (f2 contains oldstate) {
            newf2 += newstate
          }
          for (trans <- t1.get(oldstate).iterator) {
            // trans : Seq[(label, nextState)]
            val t = trans.map(sigmaTrans => {
              val (label, next) = sigmaTrans
              (label, getState(next))
            })
            newtrans += ((newstate, t))
          }
          for (trans <- pre1.get(oldstate).iterator) {
            // trans : Seq[nextState]
            val t = trans.map(s => getState(s))
            newpre += ((newstate, t))
          }
          for (trans <- post1.get(oldstate).iterator) {
            // trans : Seq[nextState]
            val t = trans.map(s => getState(s))
            newpost += ((newstate, t))
          }

          // now the database ...
          for (
            caps <- regex2pfa.stateCap.get(oldstate).iterator;
            cap <- caps
          ) {
            regex2pfa.stateCap.addBinding(newstate, cap)
            regex2pfa.capState.addBinding(cap, newstate)
            if (regex2pfa.capInit.getOrElse(cap, MSet()) contains oldstate) {
              regex2pfa.capInit.addBinding(cap, newstate)
            }
          }
        }
        val newend = (f1, f2)

        PrioAutomaton(newtrans, newpre, newpost, newinit, (newf1, newf2))
      }
    }
  }

}

class PythonPrioAutomatonBuilder(theory : OstrichStringTheory)
  extends PrioAutomatonBuilder(theory) {
  // In python mode, we don't use the second component
  // of the accepted states because we don't differentiate these two types of acceptance condition
  // thus, **all accepting states are in F1**
  private val F2_dummy = new MHashSet[State]

  import PrioAutomaton.getNewState

  def none() : PrioAutomaton = {
      val init = getNewState
      val end = (new MHashSet[State], F2_dummy)
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      val pre = new MHashMap[State, Seq[ETransition]]
      val post = new MHashMap[State, Seq[ETransition]]
      PrioAutomaton(trans, pre, post, init, end)
  }

  def epsilon() : PrioAutomaton = {
      val init = getNewState
      val F1 = new MHashSet[State]
      val newaccepting = getNewState
      F1 += newaccepting
      val end = (F1, F2_dummy)
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      val pre = new MHashMap[State, Seq[ETransition]]
      pre += ((init, Seq(newaccepting)))
      val post = new MHashMap[State, Seq[ETransition]]
      PrioAutomaton(trans, pre, post, init, end)
  }

  def single(lbl : TLabel) : PrioAutomaton = {
    if (LabelOps isNonEmptyLabel lbl) {
      val init = getNewState
      val intermediate = getNewState
      val newaccepting = getNewState
      val F1 = new MHashSet[State]
      F1 += newaccepting
      val end = (F1, F2_dummy)
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      trans += ((intermediate, Seq((lbl, newaccepting))))
      val pre = new MHashMap[State, Seq[ETransition]]
      pre += ((init, Seq(intermediate)))
      val post = new MHashMap[State, Seq[ETransition]]
      PrioAutomaton(trans, pre, post, init, end)
    } else {
      none
    }
  }

  def optional(aut : PrioAutomaton) : PrioAutomaton = {
    alternate(aut, epsilon)
  }

  def lazyoptional(aut : PrioAutomaton) : PrioAutomaton = {
    alternate(epsilon, aut)
  }

  def alternate(aut1 : PrioAutomaton, aut2 : PrioAutomaton) : PrioAutomaton = {
    (aut1, aut2) match {
      case (PrioAutomaton(t1, pre1, post1, init1, (f1_1, _)), PrioAutomaton(t2, pre2, post2, init2, (f1_2, _))) => {
        val init = getNewState
        val f1 = f1_1 ++ f1_2
        val trans = t1 ++ t2
        val pre = pre1 ++ pre2
        pre += ((init, Seq(init1, init2)))
        val post = post1 ++ post2

        PrioAutomaton(trans, pre, post, init, (f1, F2_dummy))
      }
    }
  }

  def concat(aut1 : PrioAutomaton, aut2 : PrioAutomaton) : PrioAutomaton = {
    (aut1, aut2) match {
      case (PrioAutomaton(t1, pre1, post1, init1, (end1, _)), PrioAutomaton(t2, pre2, post2, init2, (end2, _))) => {
        val trans = t1 ++ t2
        val pre = pre1 ++ pre2
        for (s <- end1) {
          pre += ((s, Seq(init2)))
        }
        val post = post1 ++ post2

        PrioAutomaton(trans, pre, post, init1, (end2, F2_dummy))
      }
    }
  }

  def star(aut : PrioAutomaton) : PrioAutomaton = {
    aut match {
      case PrioAutomaton(t1, pre1, post1, init1, (end1, _)) => {
        val init = getNewState
        val end = getNewState
        for (s <- end1) {
          pre1 += ((s, Seq(init1, end)))
        }
        pre1 += ((init, Seq(init1, end)))

        val f1 = new MHashSet[State]
        f1 += end

        PrioAutomaton(t1, pre1, post1, init, (f1, F2_dummy))
      }
    }
  }

  def lazystar(aut : PrioAutomaton) : PrioAutomaton = {
    aut match {
      case PrioAutomaton(t1, pre1, post1, init1, (end1, _)) => {
        val init = getNewState
        val end = getNewState
        for (s <- end1) {
          pre1 += ((s, Seq(end, init1)))
        }
        pre1 += ((init, Seq(end, init1)))

        val f1 = new MHashSet[State]
        f1 += end

        PrioAutomaton(t1, pre1, post1, init, (f1, F2_dummy))
      }
    }
  }

  def plus(aut : PrioAutomaton) : PrioAutomaton = {
    aut match {
      case PrioAutomaton(t1, pre1, post1, init1, (end1, _)) => {
        val end = getNewState
        val init = getNewState
        pre1 += ((init, Seq(init1)))
        for (s <- end1) {
          pre1 += ((s, Seq(init1, end)))
        }
        val f1 = new MHashSet[State]
        f1 += end

        PrioAutomaton(t1, pre1, post1, init, (f1, F2_dummy))
      }
    }
  }

  def lazyplus(aut : PrioAutomaton) : PrioAutomaton = {
    aut match {
      case PrioAutomaton(t1, pre1, post1, init1, (end1, _)) => {
        val end = getNewState
        for (s <- end1) {
          pre1.+=((s, Seq(end, init1)))
        }
        val f1 = new MHashSet[State]
        f1 += end

        PrioAutomaton(t1, pre1, post1, init1, (f1, F2_dummy))
      }
    }
  }

  def loop(autA : PrioAutomaton, n1 : IdealInt, n2 : IdealInt) : PrioAutomaton = {
    // too inefficient
    // maybe there's some other way
    var aut = none
    var i = n1
    while (i <= n2) {
      var j = 0
      var disjunct = epsilon
      while (j < i) {
        val copy = duplicate(autA)
        disjunct = concat(copy, disjunct)
        j = j + 1
      }
      aut = alternate(disjunct, aut)
      i = i + 1
    }
    aut
  }

  def lazyloop(autA : PrioAutomaton, n1 : IdealInt, n2 : IdealInt) : PrioAutomaton = {
    var aut = none
    var i = n1
    while (i <= n2) {
      var j = 0
      var disjunct = epsilon
      while (j < i) {
        val copy = duplicate(autA)
        disjunct = concat(copy, disjunct)
        j = j + 1
      }
      aut = alternate(aut, disjunct) // changed
      i = i + 1
    }
    aut
  }

}

class JavascriptPrioAutomatonBuilder(theory : OstrichStringTheory)
  extends PrioAutomatonBuilder(theory) {
  // In js mode, we use the first component F1 (res. F2) to denote accepting
  // states which only accepts empty (res. nonempty) traces.
  // to approximate the js semantics as precisely as possible,
  // we need to duplicate automaton at times

  import PrioAutomaton.getNewState

  def none() : PrioAutomaton = {
      val init = getNewState
      val end = (new MHashSet[State], new MHashSet[State])
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      val pre = new MHashMap[State, Seq[ETransition]]
      val post = new MHashMap[State, Seq[ETransition]]
      PrioAutomaton(trans, pre, post, init, end)
  }

  def epsilon() : PrioAutomaton = {
      val init = getNewState
      val F1 = new MHashSet[State]
      val newaccepting = getNewState
      F1 += newaccepting
      val F2 = new MHashSet[State]
      val end = (F1, F2)
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      val pre = new MHashMap[State, Seq[ETransition]]
      pre += ((init, Seq(newaccepting)))
      val post = new MHashMap[State, Seq[ETransition]]
      PrioAutomaton(trans, pre, post, init, end)
  }

  def single(lbl : TLabel) : PrioAutomaton = {
    if (LabelOps isNonEmptyLabel lbl) {
      val init = getNewState
      val intermediate = getNewState
      val newaccepting = getNewState
      val F1 = new MHashSet[State]
      val F2 = new MHashSet[State]
      F2 += newaccepting
      val end = (F1, F2)
      val trans = new MHashMap[State, Seq[SigmaTransition]]
      trans += ((intermediate, Seq((lbl, newaccepting))))
      val pre = new MHashMap[State, Seq[ETransition]]
      pre += ((init, Seq(intermediate)))
      val post = new MHashMap[State, Seq[ETransition]]
      PrioAutomaton(trans, pre, post, init, end)
    } else {
      none
    }
  }

  def alternate(aut1 : PrioAutomaton, aut2 : PrioAutomaton) : PrioAutomaton = {
    (aut1, aut2) match {
      case (PrioAutomaton(t1, pre1, post1, init1, (f1_1, f2_1)), PrioAutomaton(t2, pre2, post2, init2, (f1_2, f2_2))) => {
        val init = getNewState
        val f1 = f1_1 ++ f1_2
        val f2 = f2_1 ++ f2_2
        val trans = t1 ++ t2
        val pre = pre1 ++ pre2
        pre += ((init, Seq(init1, init2)))
        val post = post1 ++ post2

        PrioAutomaton(trans, pre, post, init, (f1, f2))
      }
    }
  }

  def concat(aut1 : PrioAutomaton, aut2 : PrioAutomaton) : PrioAutomaton = {
    (aut1, aut2) match {
      case (PrioAutomaton(t1, pre1, post1, init1, (f1_1, f2_1)),
        PrioAutomaton(t2, pre2, post2, init2, (f1_2, f2_2))) => {
          // for performance, we only copy aut2 when both aut1 and aut2 accept
          // empty string.
          if (f1_1.isEmpty || f1_2.isEmpty) {
            // the same as in Python mode. However, here
            // we move all f1_2 states to f2_2
            val trans = t1 ++ t2
            val pre = pre1 ++ pre2
            for (s <- f1_1) {
              pre += ((s, Seq(init2)))
            }
            for (s <- f2_1) {
              pre += ((s, Seq(init2)))
            }
            val post = post1 ++ post2
            val f1 = new MHashSet[State]
            val f2 = f1_2 ++ f2_2

            PrioAutomaton(trans, pre, post, init1, (f1, f2))
          } else {
            // the hard part
            // first make a copy of aut2
            val aut2copy = duplicate(aut2)
            aut2copy match {
              case PrioAutomaton(t2copy, pre2copy, post2copy, init2copy, (f1_2copy, f2_2copy)) => {
                val trans = t1 ++ t2 ++ t2copy
                val pre = pre1 ++ pre2 ++ pre2copy
                // empty trace from aut1 continues in aut2
                for (s <- f1_1) {
                  pre += ((s, Seq(init2)))
                }
                // nonempty trace from aut1 continues in aut2copy
                for (s <- f2_1) {
                  pre += ((s, Seq(init2copy)))
                }
                val post = post1 ++ post2 ++ post2copy
                val f1 = f1_2
                val f2 = f2_2 ++ f1_2copy ++ f2_2copy

                PrioAutomaton(trans, pre, post, init1, (f1, f2))
            }
          }
        }
      }
    }
  }

  def optional(aut : PrioAutomaton) : PrioAutomaton = {
    // NOTE: in ECMA, e? requires that e does not match empty string
    // so here we remove the field F1 from aut
    aut.accepting._1.clear
    alternate(aut, epsilon)
  }

  def lazyoptional(aut : PrioAutomaton) : PrioAutomaton = {
    aut.accepting._1.clear
    alternate(epsilon, aut)
  }

  def star(aut : PrioAutomaton) : PrioAutomaton = {
    aut match {
      case PrioAutomaton(t1, pre1, post1, init1, (f1, f2)) => {
        val init = getNewState
        val end_empty = getNewState
        val end_nonempty = getNewState

        for (s <- f1) {
          pre1 += ((s, Seq(init1)))
        }
        for (s <- f2) {
          // f2 is only reachable from nonempty matches
          pre1 += ((s, Seq(init1, end_nonempty)))
        }
        pre1 += ((init, Seq(init1, end_empty)))

        val newf1 = new MHashSet[State]
        newf1 += end_empty
        val newf2 = new MHashSet[State]
        newf2 += end_nonempty

        PrioAutomaton(t1, pre1, post1, init, (newf1, newf2))
      }
    }
  }

  def lazystar(aut : PrioAutomaton) : PrioAutomaton = {
    aut match {
      case PrioAutomaton(t1, pre1, post1, init1, (f1, f2)) => {
        val init = getNewState
        val end_empty = getNewState
        val end_nonempty = getNewState

        for (s <- f1) {
          pre1 += ((s, Seq(init1)))
        }
        for (s <- f2) {
          // f2 is only reachable from nonempty matches
          pre1 += ((s, Seq(end_nonempty, init1)))
        }
        pre1 += ((init, Seq(end_empty, init1)))

        val newf1 = new MHashSet[State]
        newf1 += end_empty
        val newf2 = new MHashSet[State]
        newf2 += end_nonempty

        PrioAutomaton(t1, pre1, post1, init, (newf1, newf2))
      }
    }
  }

  def plus(aut : PrioAutomaton) : PrioAutomaton = {
    // aut will be modified during recursion
    // so we must make a copy here
    val autcopy = duplicate(aut)
    val staraut = star(aut)
    concat(autcopy, staraut)
  }

  def lazyplus(aut : PrioAutomaton) : PrioAutomaton = {
    val autcopy = duplicate(aut)
    val staraut = lazystar(aut)
    concat(autcopy, staraut)
  }

  def loop(autA : PrioAutomaton, n1 : IdealInt, n2 : IdealInt) : PrioAutomaton = {
    var current = epsilon
    // firstly, we should match `n1` times,
    // that is, concat autA n1 times
    var i = 1
    while (i <= n1) {
      val copy = duplicate(autA)
      current = concat(current, copy)
      i = i + 1
    }

    // record the accepting traces
    val current_f1 = current.accepting._1.toSet
    var current_f2 = new MHashSet[State]
    current_f2 ++= current.accepting._2

    // now, we can continue to match `n2 - n1` times
    // which is greedy (we assume `loop` is greedy)
    // and disallow matching of empty string.

    // To achieve this, we clear the field F1
    // (standing for empty string) of autA
    // and get autANonEmpty:
    val autANonEmpty = autA match {
      case PrioAutomaton(t1, pre1, post1, init1, (f1, f2)) => {
        val f1new = new MHashSet[State]
        PrioAutomaton(t1, pre1, post1, init1, (f1new, f2))
      }
    }

    // we then concat autANonEmpty n2 - n1 times
    i = 0
    while (i < n2 - n1) {
      val copy = duplicate(autANonEmpty)
      current = concat(current, copy)
      // during the iteration, we record all the final states occurred
      // (since autANonEmpty definitely reject empty string,
      // we just need to record F2)
      current_f2 ++= current.accepting._2
      i = i + 1
    }

    val res = current match {
      case PrioAutomaton(t1, pre1, post1, init1, (_, _)) => {
        // form the final automaton by
        // creating two final states and add transitions
        val newf1 = new MHashSet[State]
        if (!current_f1.isEmpty) {
          val f1 = getNewState
          for (s <- current_f1) {
            post1 += ((s, Seq(f1)))
          }
          newf1 += f1
        }

        val newf2 = new MHashSet[State]
        if (!current_f2.isEmpty) {
          val f2 = getNewState
          for (s <- current_f2) {
            post1 += ((s, Seq(f2)))
          }
          newf2 += f2
        }

        PrioAutomaton(t1, pre1, post1, init1, (newf1, newf2))
      }
    }

    res
  }

  def lazyloop(autA : PrioAutomaton, n1 : IdealInt, n2 : IdealInt) : PrioAutomaton = {
    var current = epsilon
    var i = 1
    while (i <= n1) {
      val copy = duplicate(autA)
      current = concat(current, copy)
      i = i + 1
    }

    val current_f1 = current.accepting._1.toSet
    var current_f2 = new MHashSet[State]
    current_f2 ++= current.accepting._2

    val autANonEmpty = autA match {
      case PrioAutomaton(t1, pre1, post1, init1, (f1, f2)) => {
        val f1new = new MHashSet[State]
        PrioAutomaton(t1, pre1, post1, init1, (f1new, f2))
      }
    }

    i = 0
    while (i < n2 - n1) {
      val copy = duplicate(autANonEmpty)
      current = concat(current, copy)
      // during the iteration, we record all the final states occurred
      // (since autANonEmpty definitely rejects empty string,
      // we just need to record F2)
      current_f2 ++= current.accepting._2
      i = i + 1
    }

    val res = current match {
      case PrioAutomaton(t1, pre1, post1, init1, (_, _)) => {
        val newf1 = new MHashSet[State]
        if (!current_f1.isEmpty) {
          val f1 = getNewState
          for (s <- current_f1) {
            val old_succs = pre1.getOrElse(s, Seq())
            pre1(s) = (f1 +: old_succs)
          }
          newf1 += f1
        }

        val newf2 = new MHashSet[State]
        if (!current_f2.isEmpty) {
          val f2 = getNewState
          for (s <- current_f2) {
            val old_succs = pre1.getOrElse(s, Seq())
            pre1(s) = (f2 +: old_succs)
          }
          newf2 += f2
        }

        PrioAutomaton(t1, pre1, post1, init1, (newf1, newf2))
      }
    }

    res
  }
}

object Regex2PFA {
  type State = PrioAutomaton.State
  type TLabel = PrioAutomaton.TLabel
  val LabelOps : TLabelOps[TLabel] = PrioAutomaton.LabelOps

  // the automaton,
  // number of capture groups,
  // map from state to the capture groups it's in,
  // map from capture group to initial states of its PFA counterpart
  type completeInfo = (PrioAutomaton, Int, Map[State, Set[Int]], Map[Int, Set[State]])

  def printInfo(info : completeInfo) = {
    val (aut, numCap, state2Caps, cap2Init) = info
    Console.withOut(Console.err) {
      println("   Generated PFA with " + numCap + " capture groups:")
      println(aut.toDot)
      println("   State to Capture Groups:")
      for ((s, caps) <- state2Caps) {
        println(s + " -> { " + caps + " }")
      }
      println("   Capture group to Initial States:")
      for ((cap, inits) <- cap2Init) {
        println(cap + " -> { " + inits + " }")
      }
    }
  }
}

class Regex2PFA(theory : OstrichStringTheory, builder : PrioAutomatonBuilder) {

  import Regex2PFA._
  import theory.{re_none, re_all, re_eps, re_allchar, re_charrange,
    re_++, re_union, re_inter, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?, re_comp,
    re_loop, re_loop_?, str_to_re, re_from_str,
    re_begin_anchor, re_end_anchor,
    re_capture, re_reference, re_from_ecma2020, re_from_ecma2020_flags}
  import theory.strDatabase.EncodedString

  private val simplifier = new Regex2Aut.DiffEliminator(theory)

  // mutable maps collecting info during translation
  val capState =
    new MHashMap[Int, MSet[State]]
    with MMultiMap[Int, State]
  val stateCap =
    new MHashMap[State, MSet[Int]]
    with MMultiMap[State, Int]
  val capInit =
    new MHashMap[Int, MSet[State]]
    with MMultiMap[Int, State]

  // this is the map from literal numbering to internal numbering of
  // capture groups. It is for translating the replacement string.
  private val capNumTransform =
    new MHashMap[Int, Int]

  def buildReplaceInfo(pat : ITerm, rep: ITerm) : (completeInfo, Seq[UpdateOp]) = {
    reset

    val info = buildPatternRegex(pat)
    val ops = buildReplacementRegex(rep)

    (info, ops)
  }

  def buildExtractInfo(index: Int, pat: ITerm) : (Int, completeInfo) = {
    reset

    val info = buildPatternRegex(pat)
    val localindex =
      (capNumTransform get index) match {
        case None =>
          throw new IllegalArgumentException("Undefined capture group referenced: " + index)
        case Some(l) => l
      }

    (localindex, info)
  }

  def reset() = {
    capNumTransform.clear
    capState.clear
    stateCap.clear
    capInit.clear
  }

  private def buildPatternRegex(pat : ITerm) : completeInfo = {

    var numCapture : Int = 0

    def buildPatternImpl(t : ITerm) : (PrioAutomaton, Set[Int]) = { // returns PFA and capture groups within
      t match {
        case IFunApp(`re_none`, _) =>
          (builder.none, Set())
        case IFunApp(`re_eps`, _) =>
          (builder.epsilon, Set())
        case IFunApp(`re_allchar`, _) =>
          (builder.single(LabelOps.sigmaLabel), Set())
        case IFunApp(`re_begin_anchor`, _) =>
          (builder.single(BeginAnchor), Set())
        case IFunApp(`re_end_anchor`, _) =>
          (builder.single(EndAnchor), Set())
        case IFunApp(`re_all`, _) => {
          val aut_allchar = builder.single(LabelOps.sigmaLabel)
          val aut_all = builder.star(aut_allchar)
          (aut_all, Set())
        }
        case IFunApp(`re_charrange`,
          Seq(IIntLit(IdealInt(a)), IIntLit(IdealInt(b)))) => {
            val lbl = LabelOps.interval(a.toChar, b.toChar) // XXX:Int to Char?
            (builder.single(lbl), Set())
        }
        case IFunApp(`re_++`, Seq(a, b)) => {
          val (autA, capA) = buildPatternImpl(a)
          val (autB, capB) = buildPatternImpl(b)
          (builder.concat(autA, autB), capA ++ capB)
        }
        case IFunApp(`re_union`, Seq(a, b)) => {
          val (autA, capA) = buildPatternImpl(a)
          val (autB, capB) = buildPatternImpl(b)
          (builder.alternate(autA, autB), capA ++ capB)
        }
        case IFunApp(`re_inter`, Seq(a, b)) => {
          throw new IllegalArgumentException(
            "regex with capture groups does not support intersection " + t)
        }
        case IFunApp(`re_comp`, Seq(a)) => {
          throw new IllegalArgumentException(
            "regex with capture groups does not support complement " + t)
        }
        case IFunApp(`re_*`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          (builder.star(autA), capA)
        }
        case IFunApp(`re_*?`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          (builder.lazystar(autA), capA)
        }
        case IFunApp(`re_+`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          (builder.plus(autA), capA)
        }
        case IFunApp(`re_+?`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)

          (builder.lazyplus(autA), capA)
        }
        case IFunApp(`re_opt`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)
          (builder.optional(autA), capA)
        }
        case IFunApp(`re_opt_?`, Seq(a)) => {
          val (autA, capA) = buildPatternImpl(a)
          (builder.lazyoptional(autA), capA)
        }
        case IFunApp(`re_loop`, Seq(IIntLit(n1), IIntLit(n2), a)) => {
          val (autA, capA) = buildPatternImpl(a)
          val aut = builder.loop(autA, n1, n2)
          (aut, capA)
        }
        case IFunApp(`re_loop_?`, Seq(IIntLit(n1), IIntLit(n2), a)) => {
          val (autA, capA) = buildPatternImpl(a)
          val aut = builder.lazyloop(autA, n1, n2)
          (aut, capA)
        }
        case IFunApp(`re_capture`, Seq(IIntLit(IdealInt(litCaptureNum)), a)) => {
          val localCaptureNum = numCapture
          numCapture += 1 // capture group is numbered from 0 to numCapture - 1

          (capNumTransform get litCaptureNum) match {
            case None => { capNumTransform += (litCaptureNum -> localCaptureNum)}
            case Some(_) => {
              throw new IllegalArgumentException(
                "Duplicate capture group : " + litCaptureNum)
            }
          }

          val (autA, capA) = buildPatternImpl(a)

          for ((s, trans) <- autA.sTran; (lbl, tgt) <- trans) {
            capState.addBinding(localCaptureNum, tgt)
            capState.addBinding(localCaptureNum, s)
            stateCap.addBinding(tgt, localCaptureNum)
            stateCap.addBinding(s, localCaptureNum)
          }
          for ((s, trans) <- autA.preTran; tgt <- trans) {
            capState.addBinding(localCaptureNum, s)
            capState.addBinding(localCaptureNum, tgt)
            stateCap.addBinding(tgt, localCaptureNum)
            stateCap.addBinding(s, localCaptureNum)
          }
          for ((s, trans) <- autA.postTran; tgt <- trans) {
            capState.addBinding(localCaptureNum, s)
            capState.addBinding(localCaptureNum, tgt)
            stateCap.addBinding(tgt, localCaptureNum)
            stateCap.addBinding(s, localCaptureNum)
          }
          capInit.addBinding(localCaptureNum, autA.initial)

          (autA, capA + localCaptureNum)
        }
        case IFunApp(`str_to_re`, Seq(EncodedString(a))) => {
          (builder.constant(a), Set())
        }
        case IFunApp(`re_from_ecma2020`, Seq(EncodedString(str))) => {
          val parser = new ECMARegexParser(theory, convertCaptureGroups = true)
          val t = parser.string2Term(str)
          buildPatternImpl(simplifier(t))
        }
        case IFunApp(`re_from_ecma2020_flags`,
                     Seq(EncodedString(str), EncodedString(fl))) => {
          val parser = new ECMARegexParser(theory, flags = fl,
                                           convertCaptureGroups = true)
          val t = parser.string2Term(str)
          buildPatternImpl(simplifier(t))
        }
        case _ =>
          throw new IllegalArgumentException(
            "could not translate " + t + " to an automaton")
        // TODO: re_from_str ??
      }
    }

    val (aut, _) = buildPatternImpl(simplifier(pat))

    val state2Capture = (for ((s, caps) <- stateCap)
      yield (s, caps.toSet)).toMap

    val cap2Init = (for ((cap, inits) <- capInit)
      yield (cap, inits.toSet)).toMap

    (aut, numCapture, state2Capture, cap2Init)
  }

  private def buildReplacementRegex(t : ITerm) : Seq[UpdateOp] = {
    t match {
      case IFunApp(`re_eps`, _) => Seq.empty[UpdateOp]
      case IFunApp(`re_++`, Seq(a, b)) => {
        val opsa = buildReplacementRegex(a)
        val opsb = buildReplacementRegex(b)
        opsa ++ opsb
      }
      case IFunApp(`re_reference`, Seq(IIntLit(IdealInt(litCaptureNum)))) => {
        (capNumTransform get litCaptureNum) match {
          case None =>
            throw new IllegalArgumentException("Undefined capture group referenced: " + litCaptureNum)
          case Some(localCaptureNum) => List(RefVariable(localCaptureNum))
        }
      }
      case IFunApp(`str_to_re`, Seq(EncodedString(str))) => {
        (for (v <- str)
          yield Constant(v.toChar)).toSeq
      }
      case _ =>
        throw new IllegalArgumentException(
          "could not use " + t + " in the replacement string")
    }
  }

}
