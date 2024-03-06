package ostrich.cesolver.automata

import ostrich.automata.Regex2Aut
import ap.parser._
import dk.brics.automaton.BasicAutomata
import ap.basetypes.IdealInt
import CEBasicOperations._
import scala.collection.mutable.ArrayStack
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
      unwind: Boolean,
      minimize: Boolean
  ): CostEnrichedAutomatonBase =
    t match {
      case IFunApp(`re_++`, _) =>
        {
          val leaves = collectLeaves(t, re_++)
          val leaveAuts =
            for (s <- leaves) yield toCEAutomaton(s, unwind, minimize)
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
          for (s <- nonSingletons) yield toCEAutomaton(s, unwind, minimize)

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
          for (s <- leaves) yield toCEAutomaton(s, unwind, minimize)
        leaveAuts reduceLeft { (aut1, aut2) =>
          intersection(aut1, aut2)
        }
      }

      case IFunApp(`re_diff`, Seq(t1, t2)) =>
        maybeMin(
          diff(
            toCEAutomaton(t1, unwind, minimize),
            toCEAutomaton(t2, true, minimize)
          ),
          minimize
        )

      case IFunApp(`re_opt` | `re_opt_?`, Seq(t)) =>
        maybeMin(optional(toCEAutomaton(t, unwind, minimize)), minimize)

      case IFunApp(`re_comp`, Seq(t)) =>
        maybeMin(complement(toCEAutomaton(t, true, minimize)), minimize)

      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(
              IExpression.Const(IdealInt(n1)),
              IExpression.Const(IdealInt(n2)),
              t
            )
          ) =>
        if (unwind) {
          maybeMin(
            repeatUnwind(toCEAutomaton(t, true, minimize), n1, n2),
            minimize
          )
        } else
          maybeMin(repeat(toCEAutomaton(t, true, minimize), n1, n2), minimize)
      case IFunApp(`re_*` | `re_*?`, Seq(t)) =>
        maybeMin(repeatUnwind(toCEAutomaton(t, true, minimize), 0), minimize)

      case IFunApp(`re_+` | `re_+?`, Seq(t)) =>
        maybeMin(repeatUnwind(toCEAutomaton(t, true, minimize), 1), minimize)

      case _ => BricsAutomatonWrapper(toBAutomaton(t, true))
    }

  override def buildAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log("Regex2CEAut.buildAut: build automaton for regex " + t)
    toCEAutomaton(t, false, minimize)
  }

  def buildComplementAut(t: ITerm, minimize: Boolean): Automaton = {
    ParikhUtil.log(
      "Regex2CEAut.buildComplementAut: build complement automaton for regex " + t
    )
    complement(toCEAutomaton(t, true, minimize))
  }

}
