package ostrich.cesolver.automata

import ostrich.automata.Regex2Aut
import ap.parser._
import dk.brics.automaton.BasicAutomata
import ap.basetypes.IdealInt
import CEBasicOperations._
import scala.collection.mutable.{Stack, HashMap => MHashMap, HashSet => MHashSet}
import scala.collection.immutable.VectorBuilder
import ostrich.automata.Automaton
import ostrich.OstrichStringTheory
import ostrich.cesolver.util.ParikhUtil
import scala.collection.mutable.ArrayBuffer

class Regex2CEAut(theory: OstrichStringTheory) extends Regex2Aut(theory) {
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
    str_to_re
  }
  import theory.strDatabase.EncodedString

  // TODO: heuristic algorithm for unwinding nested counting
  // 1. use a hashmap to map each counting iterm to a boolean value, where the counting term with true boolean value need to be unwinded
  // 2. to get the hashmap, we need to map each counting iterm in the nested counting to its max counting, and only the largest counting does not need to be unwinded

  private val notUnwindSet = new MHashSet[ITerm]
  // private var id = 0
  // private val counting2id = new MHashMap[ITerm, Int]

  private def traverseRegex(t: ITerm) = {
    ParikhUtil.log(
      "Traverse the counting iterms in the regex t and check if it is nested. Use heuritic algorithm to find the unwinded counting terms and update counting2unwind map"
    )

    // initCounting2id(t)

    // ParikhUtil.debugPrintln(counting2id.values.size)

    val todo = new Stack[ITerm]
    todo push t

    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, _) => {
          val countingTree = buildCountingTree(a)
          val tree2max = buildTree2Max(countingTree, a)
          val notUnwind = buildNotUnwindList(countingTree, tree2max, a)
          notUnwindSet ++= notUnwind
        }
          
        case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp` , _) => {}

        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }
  }

  // private def initCounting2id(t: ITerm) = {
  //    val todo = new Stack[ITerm]
  //   todo push t

  //   while (!todo.isEmpty) {
  //     val a = todo.pop()
  //     a match {
  //       case IFunApp(`re_loop` | `re_loop_?`, args) => {
  //         counting2id += a -> id
  //         id += 1
  //         todo push args(2)
  //       }
          
  //       case IFunApp(_, args) =>
  //         for (arg <- args) todo push arg
  //       case _ =>
  //     }
  //   }
  // }

  private def buildCountingTree(countingParent: ITerm): Map[ITerm, Seq[ITerm]] = {
    val countingTree = MHashMap[ITerm, Seq[ITerm]]()
    val todo = new Stack[ITerm]
    countingParent match {
      case IFunApp(`re_loop` | `re_loop_?`, args) => todo push args(2)
    }
    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop`|`re_loop_?`, _) => {
          countingTree(countingParent) = countingTree.getOrElse(countingParent, Seq()) :+ a
          countingTree ++= buildCountingTree(a)
        }
        case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp` , _) => {}
        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }
    countingTree.toMap
  }

  private def buildTree2Max(tree: Map[ITerm, Seq[ITerm]], root: ITerm): Map[ITerm, Int] = {
    // ParikhUtil.debugPrintln(s"buildTree2Max tree is ${tree.map{case (key, values) => counting2id(key) -> values.map(counting2id(_))}}, root is ${counting2id{root}}")
    val tree2max = MHashMap[ITerm, Int]()
    val rootUpperBound = root match {
        case IFunApp(`re_loop` | `re_loop_?`, Seq(_ , IExpression.Const(IdealInt(n)), _)) =>
          n
        case _ => throw new Exception("The root is not a counting term")
      }
    if (!tree.contains(root)) {
      tree2max(root) = rootUpperBound
    } else {
      var subtreeMaxSum = 0
      for (sub <- tree(root)){
        val subTree2max = buildTree2Max(tree, sub)
        subtreeMaxSum += subTree2max(sub)
        tree2max ++= subTree2max
      }
      tree2max(root) = rootUpperBound max subtreeMaxSum
    }
    tree2max.toMap
  }

  private def buildNotUnwindList(tree: Map[ITerm, Seq[ITerm]], tree2max: Map[ITerm, Int], root: ITerm): Seq[ITerm] = {
    // ParikhUtil.debugPrintln(s"tree2max is ${tree2max.map{case (t, i) => counting2id(t) -> i}}, tree is ${tree.map{case (key, values) => counting2id(key) -> values.map(counting2id(_))}}, root is ${counting2id{root}}")
    root match {
      case IFunApp(`re_loop` | `re_loop_?`, Seq(_ , IExpression.Const(IdealInt(n)), _)) =>
        if (n == tree2max(root) | !tree.contains(root)) Seq(root)
        else {
          tree(root).map(buildNotUnwindList(tree, tree2max, _)).flatten
        }
      case _ => throw new Exception("The root is not a counting term")
    }
  }

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

  private def maybeMin(aut: CostEnrichedAutomatonBase, minimize: Boolean) =
    if (minimize) {
      minimizeHopcroft(aut)
    } else {
      aut
    }

  def toCEAutomaton(
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
        maybeMin(repeat(toCEAutomaton(subt, mustUnwind, minimize), n1, n2, needUnwind), minimize)
      case IFunApp(`re_*` | `re_*?`, Seq(subt)) =>
        maybeMin(repeatUnwind(toCEAutomaton(subt, true, minimize), 0), minimize)

      case IFunApp(`re_+` | `re_+?`, Seq(subt)) =>
        maybeMin(repeatUnwind(toCEAutomaton(subt, true, minimize), 1), minimize)

      case _ => BricsAutomatonWrapper(toBAutomaton(t, true))
    }

  override def buildAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log("Regex2CEAut.buildAut: build automaton for regex " + t)
    traverseRegex(t)
    toCEAutomaton(t, false, minimize)
  }

  def buildComplementAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log(
      "Regex2CEAut.buildComplementAut: build complement automaton for regex " + t
    )
    complement(toCEAutomaton(t, true, minimize))
  }

}
