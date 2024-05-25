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

import ostrich.automata.Regex2Aut
import ap.parser._
import dk.brics.automaton.BasicAutomata
import ap.basetypes.IdealInt
import CEBasicOperations._
import scala.collection.mutable.{
  Stack,
  HashMap => MHashMap,
  HashSet => MHashSet
}
import scala.collection.immutable.VectorBuilder
import ostrich.automata.Automaton
import ostrich.OstrichStringTheory
import ostrich.cesolver.util.ParikhUtil
import scala.collection.mutable.ArrayBuffer
import ostrich.OFlags

class Regex2CEAut(theory: OstrichStringTheory, flags: OFlags)
    extends Regex2Aut(theory) {
  import theory.{
    re_inter,
    re_union,
    re_diff,
    re_*,
    re_*?,
    re_+,
    re_+?,
    re_opt,
    re_opt_?,
    re_loop,
    re_loop_?,
    re_++,
    re_comp,
    str_to_re,
    re_range,
    re_charrange,
    re_eps,
    re_all,
    re_allchar
  }
  import theory.strDatabase.EncodedString

  // Heuristic algorithm for unwinding nested counting
  // 1. use a hashmap to map each counting iterm to a boolean value, where the counting term with true boolean value need to be unwinded
  // 2. to get the hashmap, we need to map each counting iterm in the nested counting to its max counting, and only the largest counting does not need to be unwinded

  private val symbolicUnwindSet = new MHashSet[ITerm]
  // private var id = 0
  // private val countTerm2id = new MHashMap[ITerm, Int]

  private def findSymbolicUnwindCount(t: ITerm) = {
    ParikhUtil.log(
      "Traverse the counting iterms in the regex t and check if it is nested. Use heuritic algorithm to find the unwinded counting terms and update counting2unwind map"
    )
    symbolicUnwindSet.clear()
    // initCounting2id(t)

    val todo = new Stack[ITerm]
    todo push t

    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, _) => {
          flags.countUnwindStrategy match {
            case OFlags.NestedCountUnwindBy.MeetFirst =>
              symbolicUnwindSet += a
            case OFlags.NestedCountUnwindBy.MinFisrt => {
              // val countingTree = buildCountingTree(a)
              // val tree2max = buildTree2Max(countingTree, a)
              // val notUnwind = buildNotUnwindList(countingTree, tree2max, a)
              // symbolicUnwindSet ++= notUnwind
              sizeWithRegsCount(a, false)
            }
          }
        }

        case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp`, _) => {}

        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }
  }

  private def allUnwind(t: ITerm): Unit = {
    val todo = new Stack[ITerm]
    todo push t

    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, _) => {
          symbolicUnwindSet -= a
        }

        case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp`, _) => {}

        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }
  }

  private def sizeWithRegsCount(t: ITerm, unwind: Boolean): (Int, Int) = {

    t match {
      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(_, IExpression.Const(IdealInt(upper)), subt)
          ) => {
        if (unwind) {
          val (subtSize, subtRegs) = sizeWithRegsCount(subt, unwind)
          (subtSize * upper, subtRegs * upper)
        } else {
          // the term t is unwinded
          val (subtSize1, subtRegs1) = sizeWithRegsCount(subt, false)
          val (tSize1, tRegs1) = (subtSize1 * upper, subtRegs1 * upper)
          // the term t is not unwinded
          val (subtSize2, subtRegs2) = sizeWithRegsCount(subt, true)
          val (tSize2, tRegs2) = (subtSize2, subtRegs2 + 1)
          if (
            math.log(tSize1) + math.log(tRegs1+1) < math
              .log(tSize2) + math.log(tRegs2+1)
          ) {
            (tSize1, tRegs1)
          } else {
            symbolicUnwindSet += t
            allUnwind(subt)
            (tSize2, tRegs2)
          }
        }
      }

      case IFunApp(`re_++`, _) => {
        val leaves = collectLeaves(t, re_++)
        val a = leaves.map(sizeWithRegsCount(_, unwind)).toMap
        (a.keys.sum, a.values.sum)
      }

      case IFunApp(`re_union`, _) => {
        val leaves = collectLeaves(t, re_union)
        val a = leaves.map(sizeWithRegsCount(_, unwind)).toMap
        (a.keys.sum, a.values.sum + leaves.size)
      }

      case IFunApp(`re_inter`, _) => {
        val leaves = collectLeaves(t, re_inter)
        val a = leaves.map(sizeWithRegsCount(_, unwind)).toMap
        (a.keys.toSeq.sorted.last, a.values.sum)
      }

      case _ =>
        (sizeOfAut(t), 0)
    }
  }

  // private def initCounting2id(t: ITerm) = {
  //   val todo = new Stack[ITerm]
  //   todo push t

  //   while (!todo.isEmpty) {
  //     val a = todo.pop()
  //     a match {
  //       case IFunApp(`re_loop` | `re_loop_?`, args) => {
  //         countTerm2id += a -> id
  //         id += 1
  //         todo push args(2)
  //       }

  //       case IFunApp(_, args) =>
  //         for (arg <- args) todo push arg
  //       case _ =>
  //     }
  //   }
  // }

  private def buildCountingTree(
      countingParent: ITerm
  ): Map[ITerm, Seq[ITerm]] = {
    val countingTree = MHashMap[ITerm, Seq[ITerm]]()
    val todo = new Stack[ITerm]
    countingParent match {
      case IFunApp(`re_loop` | `re_loop_?`, args) => {
        countingTree(countingParent) = Seq()
        todo push args(2)
      }
    }
    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, _) => {
          countingTree(countingParent) :+= a
          countingTree ++= buildCountingTree(a)
        }
        case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp`, _) => {}
        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }
    countingTree.toMap
  }

  private def buildTree2Max(
      tree: Map[ITerm, Seq[ITerm]],
      root: ITerm
  ): Map[ITerm, Int] = {
    // ParikhUtil.log(s"buildTree2Max tree is ${tree.map { case (key, values) =>
    //     countTerm2id(key) -> values.map(countTerm2id(_))
    //   }}, root is ${countTerm2id { root }}")
    val tree2max = MHashMap[ITerm, Int]()
    val rootUpperBound = root match {
      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(_, IExpression.Const(IdealInt(n)), _)
          ) =>
        n
      case _ => throw new Exception("The root is not a counting term")
    }
    if (!tree.contains(root)) {
      tree2max(root) = rootUpperBound
    } else {
      var subtreeMaxSum = 0
      for (sub <- tree(root)) {
        val subTree2max = buildTree2Max(tree, sub)
        subtreeMaxSum += subTree2max(sub)
        tree2max ++= subTree2max
      }
      tree2max(root) = rootUpperBound max subtreeMaxSum
    }
    tree2max.toMap
  }

  private def buildNotUnwindList(
      tree: Map[ITerm, Seq[ITerm]],
      tree2max: Map[ITerm, Int],
      root: ITerm
  ): Seq[ITerm] = {
    // ParikhUtil.log(
    //   s"tree2max is ${tree2max.map { case (t, i) => countTerm2id(t) -> i }}, tree is ${tree.map {
    //       case (key, values) => countTerm2id(key) -> values.map(countTerm2id(_))
    //     }}, root is ${countTerm2id { root }}"
    // )
    root match {
      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(_, IExpression.Const(IdealInt(n)), _)
          ) =>
        if (n == tree2max(root) | tree(root).isEmpty) Seq(root)
        else {
          tree(root).map(buildNotUnwindList(tree, tree2max, _)).flatten
        }
      case _ => throw new Exception("The root is not a counting term")
    }
  }

  private def maybeMin(aut: CostEnrichedAutomatonBase, minimize: Boolean) =
    if (minimize) {
      minimizeHopcroft(aut)
    } else {
      aut
    }

  // collect leaved from a regex term t with operator op
  private def collectLeaves(t: ITerm, op: IFunction): Seq[ITerm] = {
    val todo = new Stack[ITerm]
    todo push t

    val res = new VectorBuilder[ITerm]

    while (!todo.isEmpty)
      todo.pop match {
        case IFunApp(`op`, args) =>
          for (s <- args.reverseIterator)
            todo push s
        case s =>
          res += s
      }

    res.result
  }

  private def toCEAutomaton(
      t: ITerm,
      mustUnwind: Boolean,
      minimize: Boolean
  ): CostEnrichedAutomatonBase =
    t match {
      case IFunApp(`re_++`, _) => {
        val leaves = collectLeaves(t, re_++)
        val leaveAuts =
          for (s <- leaves) yield toCEAutomaton(s, mustUnwind, minimize)
        concatenate(leaveAuts)

      }

      case IFunApp(`re_union`, _) => {
        val leaves = collectLeaves(t, re_union)
        val (singletons, nonSingletons) = leaves partition {
          case IFunApp(`str_to_re`, _) => true
          case _                       => false
        }

        val singletonAuts =
          if (singletons.isEmpty) {
            List()
          } else {
            val strings =
              (for (IFunApp(_, Seq(EncodedString(str))) <- singletons)
                yield str).toArray
            List(
              BricsAutomatonWrapper(
                BasicAutomata.makeStringUnion(strings: _*)
              )
            )
          }

        val nonSingletonAuts =
          for (s <- nonSingletons) yield toCEAutomaton(s, mustUnwind, minimize)

        (singletonAuts, nonSingletonAuts) match {
          case (Seq(aut), Seq()) => aut
          case (Seq(), Seq(aut)) => aut
          case (auts1, auts2) =>
            union(auts1 ++ auts2)
        }
      }

      case IFunApp(`re_inter`, _) => {
        val leaves = collectLeaves(t, re_inter)
        val leaveAuts =
          for (s <- leaves) yield toCEAutomaton(s, mustUnwind, minimize)
        leaveAuts reduceLeft { (aut1, aut2) =>
          intersection(aut1, aut2)
        }
      }

      case IFunApp(`re_diff`, Seq(subt1, subt2)) =>
        maybeMin(
          diff(
            toCEAutomaton(subt1, mustUnwind, minimize),
            toCEAutomaton(subt2, true, minimize)
          ),
          minimize
        )

      case IFunApp(`re_opt` | `re_opt_?`, Seq(subt)) =>
        maybeMin(optional(toCEAutomaton(subt, mustUnwind, minimize)), minimize)

      case IFunApp(`re_comp`, Seq(subt)) =>
        maybeMin(complement(toCEAutomaton(subt, true, minimize)), minimize)

      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(
              IExpression.Const(IdealInt(n1)),
              IExpression.Const(IdealInt(n2)),
              subt
            )
          ) =>
        val needUnwind = mustUnwind | !symbolicUnwindSet.contains(t)
        maybeMin(
          repeat(
            toCEAutomaton(subt, mustUnwind, minimize),
            n1,
            n2,
            needUnwind
          ),
          minimize
        )
      case IFunApp(`re_*` | `re_*?`, Seq(subt)) =>
        maybeMin(repeatUnwind(toCEAutomaton(subt, true, minimize), 0), minimize)

      case IFunApp(`re_+` | `re_+?`, Seq(subt)) =>
        maybeMin(repeatUnwind(toCEAutomaton(subt, true, minimize), 1), minimize)

      case _ => BricsAutomatonWrapper(toBAutomaton(t, true))
    }

  private def toOverCEAutomaton(
      t: ITerm,
      noOver: Boolean,
      minimize: Boolean
  ): CostEnrichedAutomatonBase = t match {
    case IFunApp(`re_++`, _) => {
      val leaves = collectLeaves(t, re_++)
      val leaveAuts =
        for (s <- leaves) yield toOverCEAutomaton(s, false, minimize)
      concatenate(leaveAuts)

    }

    case IFunApp(`re_union`, _) => {
      val leaves = collectLeaves(t, re_union)
      val (singletons, nonSingletons) = leaves partition {
        case IFunApp(`str_to_re`, _) => true
        case _                       => false
      }

      val singletonAuts =
        if (singletons.isEmpty) {
          List()
        } else {
          val strings =
            (for (IFunApp(_, Seq(EncodedString(str))) <- singletons)
              yield str).toArray
          List(
            BricsAutomatonWrapper(
              BasicAutomata.makeStringUnion(strings: _*)
            )
          )
        }

      val nonSingletonAuts =
        for (s <- nonSingletons) yield toOverCEAutomaton(s, false, minimize)

      (singletonAuts, nonSingletonAuts) match {
        case (Seq(aut), Seq()) => aut
        case (Seq(), Seq(aut)) => aut
        case (auts1, auts2) =>
          union(auts1 ++ auts2)
      }
    }

    case IFunApp(`re_inter`, _) => {
      val leaves = collectLeaves(t, re_inter)
      val leaveAuts =
        for (s <- leaves) yield toOverCEAutomaton(s, false, minimize)
      leaveAuts reduceLeft { (aut1, aut2) =>
        intersection(aut1, aut2)
      }
    }

    case IFunApp(`re_diff`, Seq(subt1, subt2)) =>
      maybeMin(
        diff(
          toOverCEAutomaton(subt1, false, minimize),
          toOverCEAutomaton(subt2, true, minimize)
        ),
        minimize
      )

    case IFunApp(`re_opt` | `re_opt_?`, Seq(subt)) =>
      maybeMin(optional(toOverCEAutomaton(subt, false, minimize)), minimize)

    case IFunApp(`re_comp`, Seq(subt)) =>
      maybeMin(complement(toOverCEAutomaton(subt, true, minimize)), minimize)

    case IFunApp(
          `re_loop` | `re_loop_?`,
          Seq(
            IExpression.Const(IdealInt(n1)),
            IExpression.Const(IdealInt(n2)),
            subt
          )
        ) => {
      val noOverUpper = 10
      if (noOver || n2 < noOverUpper) {
        maybeMin(
          repeatUnwind(toOverCEAutomaton(subt, true, minimize), n1, n2),
          minimize
        )
      } else {
        // over approximation
        maybeMin(
          repeatUnwind(toOverCEAutomaton(subt, false, minimize), 0),
          minimize
        )
      }
    }
    case IFunApp(`re_*` | `re_*?`, Seq(subt)) =>
      maybeMin(
        repeatUnwind(toOverCEAutomaton(subt, false, minimize), 0),
        minimize
      )

    case IFunApp(`re_+` | `re_+?`, Seq(subt)) =>
      maybeMin(
        repeatUnwind(toOverCEAutomaton(subt, false, minimize), 1),
        minimize
      )

    case _ => BricsAutomatonWrapper(toBAutomaton(t, minimize))

  }

  // compute the sum of max states sizes of counting sub-regexes
  def sizeOfCountingSubRegexes(regex: ITerm): Int = {
    var sum = 0
    val todo = new Stack[ITerm]
    todo push regex

    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, _) => {
          sum += sizeOfAut(a)
        }

        case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp`, _) => {}

        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }
    sum
  }

  // compute the max states size of regex
  def sizeOfAut(regex: ITerm): Int = regex match {
    case IFunApp(
          `re_charrange` | `re_range` | `re_eps` | `re_all` | `re_allchar`,
          _
        ) =>
      1

    case IFunApp(`str_to_re`, Seq(EncodedString(str))) => str.size

    case IFunApp(`re_++`, _) => {
      val leaves = collectLeaves(regex, re_++)
      leaves.map(sizeOfAut).sum
    }

    case IFunApp(`re_union`, _) => {
      val leaves = collectLeaves(regex, re_union)
      leaves.map(sizeOfAut).sum
    }

    case IFunApp(`re_inter`, _) => {
      val leaves = collectLeaves(regex, re_inter)
      leaves.map(sizeOfAut).sorted.last
    }

    case IFunApp(`re_diff`, Seq(subt1, subt2)) =>
      math.min(sizeOfAut(subt1), math.pow(2, sizeOfAut(subt2)).toInt + 1)

    case IFunApp(`re_comp`, Seq(subt)) =>
      math.pow(2, sizeOfAut(subt)).toInt + 1

    case IFunApp(
          `re_loop` | `re_loop_?`,
          Seq(_, IExpression.Const(IdealInt(n2)), subt)
        ) =>
      n2 * sizeOfAut(subt)

    case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?`, Seq(subt)) =>
      sizeOfAut(subt)

    case _ => 0
  }

  override def buildAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log("Regex2CEAut.buildAut: build automaton for regex " + t)
    findSymbolicUnwindCount(t)
    toCEAutomaton(t, false, minimize)
  }

  def buildComplementAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log(
      "Regex2CEAut.buildComplementAut: build complement automaton for regex " + t
    )
    complement(toCEAutomaton(t, true, minimize))
  }

  def buildUnderComplementAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log(
      "Regex2CEAut.buildUnderComplementAut: build under approximation complement automaton for regex " + t
    )
    complement(toOverCEAutomaton(t, false, minimize))
  }

  def buildOverComplementAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log(
      "Regex2CEAut.buildOverComplementAut: build over approximation complement automaton for regex " + t
    )
    findSymbolicUnwindCount(t)
    overComplement(toCEAutomaton(t, false, minimize))
  }

}
