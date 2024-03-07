package ostrich.cesolver.automata

import ostrich.automata.Regex2Aut
import ap.parser._
import dk.brics.automaton.BasicAutomata
import ap.basetypes.IdealInt
import CEBasicOperations._
import scala.collection.mutable.{ArrayStack, HashMap => MHashMap}
import scala.collection.immutable.VectorBuilder
import ostrich.automata.Automaton
import ostrich.OstrichStringTheory
import ostrich.cesolver.util.ParikhUtil

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

  private val counting2unwind = new MHashMap[ITerm, Boolean]()

  private def traverseRegex(t: ITerm) {
    ParikhUtil.log(
      "Traverse the counting iterms in the regex t and check if it is nested. Use heuritic algorithm to find the unwinded counting terms and update counting2unwind map"
    )

    val todo = new ArrayStack[ITerm]
    todo push t

    while (!todo.isEmpty) {
      val a = todo.pop()
      a match {
        case IFunApp(`re_loop` | `re_loop_?`, _) =>
          traverseCounting(a)
          
        case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp` , _) => {}

        case IFunApp(_, args) =>
          for (arg <- args) todo push arg
        case _ =>
      }
    }

    def traverseCounting(t: ITerm) {
      val counting2max = MHashMap[ITerm, Int]()
      val todo = new ArrayStack[ITerm]
      todo push t

      while (!todo.isEmpty) {
        val a = todo.pop()
        a match {
          case IFunApp(
                `re_loop` | `re_loop_?`,
                Seq(
                  IExpression.Const(IdealInt(n1)),
                  IExpression.Const(IdealInt(n2)),
                  t1
                )
              ) => {
            counting2max += a -> n2
            todo push t1
          }
          case IFunApp(`re_*` | `re_*?` | `re_+` | `re_+?` | `re_comp` , _) => {}

          case IFunApp(_, args) =>
            for (arg <- args) todo push arg
            
          case _ =>
        }
      }
      var (nonUnwindT, max) = counting2max.head
      for ((countingterm, cmax) <- counting2max; if cmax >= max) {
        nonUnwindT = countingterm
        max = cmax
      }
      for ((countingterm, cmax) <- counting2max) {
        if (countingterm == nonUnwindT)
          counting2unwind += countingterm -> false
        else
          counting2unwind += countingterm -> true
      }
    }
  }

  private def collectLeaves(t: ITerm, op: IFunction): Seq[ITerm] = {
    val todo = new ArrayStack[ITerm]
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

      case IFunApp(`re_diff`, Seq(t1, t2)) =>
        maybeMin(
          diff(
            toCEAutomaton(t1, mustUnwind, minimize),
            toCEAutomaton(t2, true, minimize)
          ),
          minimize
        )

      case IFunApp(`re_opt` | `re_opt_?`, Seq(t)) =>
        maybeMin(optional(toCEAutomaton(t, mustUnwind, minimize)), minimize)

      case IFunApp(`re_comp`, Seq(t)) =>
        maybeMin(complement(toCEAutomaton(t, true, minimize)), minimize)

      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(
              IExpression.Const(IdealInt(n1)),
              IExpression.Const(IdealInt(n2)),
              t1
            )
          ) =>
        val currentUnwind = if (mustUnwind) true else counting2unwind(t)
        maybeMin(repeat(toCEAutomaton(t1, mustUnwind, minimize), n1, n2, currentUnwind), minimize)
      case IFunApp(`re_*` | `re_*?`, Seq(t)) =>
        maybeMin(repeatUnwind(toCEAutomaton(t, true, minimize), 0), minimize)

      case IFunApp(`re_+` | `re_+?`, Seq(t)) =>
        maybeMin(repeatUnwind(toCEAutomaton(t, true, minimize), 1), minimize)

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
