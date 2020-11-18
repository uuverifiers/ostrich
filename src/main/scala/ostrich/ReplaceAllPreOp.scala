/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2020 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

package ostrich

import ap.terfor.{Term, Formula, TermOrder, TerForConvenience}
import ap.terfor.preds.PredConj

import dk.brics.automaton.RegExp

import scala.collection.mutable.{HashMap => MHashMap,
                                 Stack => MStack,
                                 HashSet => MHashSet}

object ReplaceAllPreOp {
  def apply(a : Char) : PreOp = new ReplaceAllPreOpChar(a)

  def apply(w : Seq[Char]) : PreOp = {
    if (w.size == 1) {
      new ReplaceAllPreOpChar(w(0))
    } else {
      ReplaceAllPreOpWord(w)
    }
  }

  def apply(s : String) : PreOp = ReplaceAllPreOp(s.toSeq)

  /**
   * PreOp for x = replaceall(y, e, z) for regex e
   */
//  def apply(c : Term, context : PredConj) : PreOp =
//    ReplaceAllPreOpRegEx(c, context)

  /**
   * PreOp for x = replaceall(y, e, z) for regex e represented as
   * automaton aut
   */
  def apply(aut : AtomicStateAutomaton) : PreOp =
    ReplaceAllPreOpRegEx(aut)
}

/**
* Representation of x = replaceall(y, a, z) where a is a single
* character.
*/
class ReplaceAllPreOpChar(a : Char) extends PreOp {

  override def toString = "replaceall"

  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]] =
    Some((for (c <- arguments(0).iterator;
               d <- if (c == a)
                      arguments(1).iterator
                    else
                      Iterator single c)
          yield d).toList)

  override def lengthApproximation(arguments : Seq[Term], result : Term,
                                   order : TermOrder) : Formula = {
    import TerForConvenience._
    implicit val _ = order
    (arguments(1) === 1 & result === arguments(0)) |
    (arguments(1) < 1 & result <= arguments(0)) |
    (arguments(1) > 1 & result >= arguments(0))
  }

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val rc : AtomicStateAutomaton = resultConstraint match {
      case resCon : AtomicStateAutomaton => resCon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp needs an AtomicStateAutomaton")
    }
    val zcons = argumentConstraints(1).map(_ match {
      case zcon : AtomicStateAutomaton => zcon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp can only use AtomicStateAutomaton constraints.")
    })
    val cg = CaleyGraph[rc.type](rc, zcons)

    val res =
    for (box <- cg.getAcceptNodes.iterator;
         newYCon = ReplaceCharAutomaton(rc, a, box.getEdges)) yield {
      val newZCons = box.getEdges.map({ case (q1, q2) =>
        val fin = Set(q2).asInstanceOf[Set[AtomicStateAutomaton#State]]
        InitFinalAutomaton(rc, q1, fin)
      }).toSeq
      val newZCon = ProductAutomaton(newZCons)
      Seq(newYCon, newZCon)
    }

    (res, argumentConstraints)
  }

  override def forwardApprox(argumentConstraints : Seq[Seq[Automaton]]) : Automaton = {
    val yCons = argumentConstraints(0).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ConcatPreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val zCons = argumentConstraints(1).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ConcatPreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val yProd = ProductAutomaton(yCons)
    val zProd = ProductAutomaton(zCons)

    NestedAutomaton(yProd, a, zProd)
  }
}

/**
 * Companion object for ReplaceAllPreOpWord, does precomputation of
 * transducer representation of word
 */
object ReplaceAllPreOpWord {
  import Transducer._

  def apply(w : Seq[Char]) = {
    val wtran = buildWordTransducer(w)
    new ReplaceAllPreOpTran(wtran)
  }

  private def buildWordTransducer(w : Seq[Char]) : Transducer = {
    val builder = BricsTransducer.getBuilder

    val initState = builder.initialState
    val states = initState::(List.fill(w.size - 1)(builder.getNewState))
    val finstates = List.fill(w.size)(builder.getNewState)
    val nop = OutputOp("", NOP, "")
    val internal = OutputOp("", Internal, "")
    val end = w.size - 1

    builder.setAccept(initState, true)
    finstates.foreach(builder.setAccept(_, true))

    // recognise word
    // deliberately miss last element
    for (i <- 0 until w.size - 1) {
      builder.addTransition(states(i), (w(i), w(i)), nop, states(i+1))
    }
    builder.addTransition(states(end), (w(end), w(end)), internal, states(0))

    for (i <- 0 until w.size) {
      // the amount of w read up to state i
      val buffer = w.slice(0, i)
      // for when we need to output whole prefix read so far
      val output = OutputOp(w.slice(0, i), Plus(0), "")

      // if mismatch, look for the largest suffix of the output buffer
      // that is a correct prefix of the word being searched for. Then
      // return to the state corresponding to that part of the word.
      val anyLbl = builder.LabelOps.sigmaLabel

      // chars that are handled specially (do not return to start)
      // e.g. the next letter in w
      val handledChars= new MHashSet[Char]
      handledChars.add(w(i))

      // for each prefix - we go in reverse so we get the longest ones
      // first
      for (j <- i - 1 to 0 by -1) {
        val prefix = w.slice(0, j)
        val charNext = w(prefix.size)

        if (!handledChars.contains(charNext) && buffer.endsWith(prefix)) {
          val rejectedOldMatchSize = buffer.size - prefix.size
          val rejectedOldMatchPart = buffer.slice(0, rejectedOldMatchSize)
          val rejectedOutput = OutputOp(rejectedOldMatchPart, NOP, "")

          builder.addTransition(states(i),
                                (charNext, charNext),
                                rejectedOutput,
                                states(prefix.size + 1))

          handledChars.add(charNext)
        }
      }

      // letters that should return to start
      for (lbl <- builder.LabelOps.subtractLetters(handledChars, anyLbl)) {
        builder.addTransition(states(i), lbl, output, states(0))
      }

      // handle word ending in middle of match
      val outop = if (i == w.size -1) internal else output
      builder.addTransition(states(i), (w(i), w(i)), outop, finstates(i))
    }

    val res = builder.getTransducer
    res
  }
}

/**
 * Companion class for building representation of x = replaceall(y, e,
 * z) for a regular expression e.
 */
object ReplaceAllPreOpRegEx {
  import Transducer._

  /**
   * Build preop from c and context giving regex to be replaced
   */
//  def apply(c : Term, context : PredConj) : PreOp = {
//    val tran = buildTransducer(c, context)
//    new ReplaceAllPreOpTran(tran)
//  }

  /**
   * Build preop from aut giving regex to be replaced
   */
  def apply(aut : AtomicStateAutomaton) : PreOp = {
    val tran = buildTransducer(aut)
    new ReplaceAllPreOpTran(tran)
  }

  /**
   * Builds transducer that identifies leftmost and longest matches of
   * regex by rewriting matches to internalChar
   */
//  private def buildTransducer(c : Term, context : PredConj) : Transducer =
//    buildTransducer(BricsAutomaton(c, context))

  /**
   * Builds transducer that identifies leftmost and longest matches of
   * regex by rewriting matches to internalChar.
   *
   * TODO: currently does not handle empty matches
   */
  private def buildTransducer(aut : AtomicStateAutomaton) : Transducer = {
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier : Set[aut.State]) extends Mode
    // last transition finished a match and reached frontier
    case class EndMatch(val frontier : Set[aut.State]) extends Mode

    val labels = aut.labelEnumerator.enumDisjointLabelsComplete
    val builder = aut.getTransducerBuilder
    val nop = OutputOp("", NOP, "")
    val copy = OutputOp("", Plus(0), "")
    val internal = OutputOp("", Internal, "")

    // TODO: encapsulate this worklist automaton construction

    // states of transducer have current mode and a set of states that
    // should never reach a final state (if they do, a match has been
    // missed)
    val sMap = new MHashMap[aut.State, (Mode, Set[aut.State])]
    val sMapRev = new MHashMap[(Mode, Set[aut.State]), aut.State]

    // states of new transducer to be constructed
    val worklist = new MStack[aut.State]

    def mapState(s : aut.State, q : (Mode, Set[aut.State])) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    // creates and adds to worklist any new states if needed
    def getState(m : Mode, noreach : Set[aut.State]) : aut.State = {
      sMapRev.getOrElse((m, noreach), {
        val s = builder.getNewState
        mapState(s, (m, noreach))
        val goodNoreach = !noreach.exists(aut.isAccept(_))
        builder.setAccept(s, m match {
          case NotMatching => goodNoreach
          case EndMatch(_) => goodNoreach
          case Matching(_) => false
        })
        if (goodNoreach)
          worklist.push(s)
        s
      })
    }

    val autInit = aut.initialState
    val tranInit = builder.initialState

    mapState(tranInit, (NotMatching, Set.empty[aut.State]))
    builder.setAccept(tranInit, true)
    worklist.push(tranInit)

    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = aut.getImage(autInit, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            val dontMatch = getState(NotMatching, noreachImg ++ initImg)
            builder.addTransition(ts, lbl, copy, dontMatch)

            if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), noreachImg)
              builder.addTransition(ts, lbl, nop, newMatch)
            }

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(EndMatch(initImg), noreachImg)
              builder.addTransition(ts, lbl, internal, oneCharMatch)
            }
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = aut.getImage(frontier, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            if (!frontImg.isEmpty) {
              val contMatch = getState(Matching(frontImg), noreachImg)
              builder.addTransition(ts, lbl, nop, contMatch)
            }

            if (frontImg.exists(aut.isAccept(_))) {
                val stopMatch = getState(EndMatch(frontImg), noreachImg)
                builder.addTransition(ts, lbl, internal, stopMatch)
            }
          }
        }
        case EndMatch(frontier) => {
          for (lbl <- labels) {
            val initImg = aut.getImage(autInit, lbl)
            val frontImg = aut.getImage(frontier, lbl)
            val noreachImg = aut.getImage(noreach, lbl)

            val noMatch = getState(NotMatching, initImg ++ frontImg ++ noreachImg)
            builder.addTransition(ts, lbl, copy, noMatch)

            if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), frontImg ++ noreachImg)
              builder.addTransition(ts, lbl, nop, newMatch)
            }

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(EndMatch(initImg), frontImg ++ noreachImg)
              builder.addTransition(ts, lbl, internal, oneCharMatch)
            }
          }
        }
      }
    }

    val tran = builder.getTransducer
    tran
  }
}

/**
 * Representation of x = replaceall(y, tran, z) where tran is a
 * transducer that replaces parts of the word to be replaced with
 * internalChar.  Build with companion object ReplaceAllPreOpWord or
 * ReplaceAllPreOpTran
 */
class ReplaceAllPreOpTran(tran : Transducer) extends PreOp {

  override def toString = "replaceall-tran"

  def eval(arguments : Seq[Seq[Int]]) : Option[Seq[Int]] = {
    val arg1 = arguments(0).map(_.toChar).mkString
    val arg2 = arguments(1).map(_.toChar).mkString
    for (s <- tran(arg1, arg2)) yield s.toSeq.map(_.toInt)
  }

  def apply(argumentConstraints : Seq[Seq[Automaton]],
            resultConstraint : Automaton)
          : (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val rc : AtomicStateAutomaton = resultConstraint match {
      case resCon : AtomicStateAutomaton => resCon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp needs an AtomicStateAutomaton")
    }
    val zcons = argumentConstraints(1).map(_ match {
      case zcon : AtomicStateAutomaton => zcon
      case _ => throw new IllegalArgumentException("ReplaceAllPreOp can only use AtomicStateAutomaton constraints.")
    })

    // x = replaceall(y, w, z) internally translated to
    // y' = tran(y); x = replaceall(y', w, z)
    val cg = CaleyGraph[rc.type](rc, zcons)
    val res =
    for (box <- cg.getAcceptNodes.iterator;
         newYCon = PreImageAutomaton(tran, rc, box.getEdges)) yield {
      val newZCons = box.getEdges.map({ case (q1, q2) =>
        val fin = Set(q2).asInstanceOf[Set[AtomicStateAutomaton#State]]
        InitFinalAutomaton(rc, q1, fin)
      }).toSeq
      val newZCon = ProductAutomaton(newZCons)
      Seq(newYCon, newZCon)
    }

    (res, argumentConstraints)
  }

  override def forwardApprox(argumentConstraints : Seq[Seq[Automaton]]) : Automaton = {
    val yCons = argumentConstraints(0).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ConcatPreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val zCons = argumentConstraints(1).map(_ match {
        case saut : AtomicStateAutomaton => saut
        case _ => throw new IllegalArgumentException("ConcatPreOp.forwardApprox can only approximate AtomicStateAutomata")
    })
    val yProd = ProductAutomaton(yCons)
    val zProd = ProductAutomaton(zCons)

    PostImageAutomaton(yProd, tran, Some(zProd))
  }
}


