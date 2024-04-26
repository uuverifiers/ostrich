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

  private val notUnwindSet = new MHashSet[ITerm]
  private var id = 0
  private val countTerm2id = new MHashMap[ITerm, Int]

  private def findNoUnwindCountFrom(t: ITerm) = {
    ParikhUtil.log(
      "Traverse the counting iterms in the regex t and check if it is nested. Use heuritic algorithm to find the unwinded counting terms and update counting2unwind map"
    )

    initCounting2id(t)

    val todo = new Stack[ITerm]
    todo push t

    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, _) => {
          flags.countUnwindStrategy match {
            case OFlags.NestedCountUnwindBy.MeetFirst =>
              notUnwindSet += a
            case OFlags.NestedCountUnwindBy.MinFisrt => {
              val countingTree = buildCountingTree(a)
              val tree2max = buildTree2Max(countingTree, a)
              val notUnwind = buildNotUnwindList(countingTree, tree2max, a)
              notUnwindSet ++= notUnwind
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

  private def initCounting2id(t: ITerm) = {
    val todo = new Stack[ITerm]
    todo push t

    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, args) => {
          countTerm2id += a -> id
          id += 1
          todo push args(2)
        }

        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }
  }

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
    ParikhUtil.log(s"buildTree2Max tree is ${tree.map { case (key, values) =>
        countTerm2id(key) -> values.map(countTerm2id(_))
      }}, root is ${countTerm2id { root }}")
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
    ParikhUtil.log(
      s"tree2max is ${tree2max.map { case (t, i) => countTerm2id(t) -> i }}, tree is ${tree.map {
          case (key, values) => countTerm2id(key) -> values.map(countTerm2id(_))
        }}, root is ${countTerm2id { root }}"
    )
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
        val needUnwind = mustUnwind | !notUnwindSet.contains(t)
        maybeMin(
          repeat(
            toCEAutomaton(subt, !needUnwind, minimize),
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
      math.max(sizeOfAut(subt1), math.pow(2, sizeOfAut(subt2)).toInt + 1)

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
    findNoUnwindCountFrom(t)
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
      "Regex2CEAut.buildOverComplementAut: build under approxismation complement automaton for regex " + t
    )
    complement(toOverCEAutomaton(t, false, minimize))
  }

  def buildOverComplementAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log(
      "Regex2CEAut.buildOverComplementAut: build over approxismation complement automaton for regex " + t
    )
    findNoUnwindCountFrom(t)
    overComplement(toCEAutomaton(t, false, minimize))
  }

}
