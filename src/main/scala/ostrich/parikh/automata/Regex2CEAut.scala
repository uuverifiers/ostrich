package ostrich.parikh.automata

import ostrich.OstrichStringTheory
import ostrich.automata.Regex2Aut
import ap.parser._
import scala.collection.mutable.ArrayBuffer
import dk.brics.automaton.{
  BasicAutomata,
  BasicOperations,
  RegExp,
  Automaton => BAutomaton,
  State
}
import ap.basetypes.IdealInt
import scala.jdk.CollectionConverters._
import CEBasicOperations._
import scala.collection.mutable.ArrayStack
import scala.collection.immutable.VectorBuilder
import ostrich.automata.AtomicStateAutomaton
import ostrich.automata.Automaton
import ostrich.parikh.ParikhUtil

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
    re_all,
    str_to_re
  }
  import theory.strDatabase.EncodedString

  private def translateLeaves(
      t: ITerm,
      op: IFunction,
      unwind: Boolean
  ): Seq[CostEnrichedAutomaton] = {
    val leaves = collectLeaves(t, re_++)
    val leaveAuts = for (s <- leaves) yield toCEAutomaton(s, unwind)
    leaveAuts
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

  def toCEAutomaton(t: ITerm, unwind: Boolean): CostEnrichedAutomaton =
    t match {
      case IFunApp(`re_++`, _) =>
        concatenate(translateLeaves(t, re_++, unwind))

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
              CostEnrichedAutomaton(
                BasicAutomata.makeStringUnion(strings: _*)
              )
            )
          }

        val nonSingletonAuts =
          for (s <- nonSingletons) yield toCEAutomaton(s, unwind)

        (singletonAuts, nonSingletonAuts) match {
          case (Seq(aut), Seq()) => aut
          case (Seq(), Seq(aut)) => aut
          case (auts1, auts2) =>
            union(auts1 ++ auts2)
        }
      }

      case IFunApp(`re_inter`, _) => {
        val leaves = collectLeaves(t, re_inter)
        val leaveAuts = for (s <- leaves) yield toCEAutomaton(s, unwind)
        leaveAuts reduceLeft { (aut1, aut2) =>
          intersection(aut1, aut2)
        }
      }

      case IFunApp(`re_diff`, Seq(t1, t2)) =>
        diff(toCEAutomaton(t1, unwind), toCEAutomaton(t2, unwind))

      case IFunApp(`re_opt` | `re_opt_?`, Seq(t)) =>
        optional(toCEAutomaton(t, unwind))

      case IFunApp(`re_comp`, Seq(t)) =>
        complement(toCEAutomaton(t, unwind))

      case IFunApp(
            `re_loop` | `re_loop_?`,
            Seq(IIntLit(IdealInt(n1)), IIntLit(IdealInt(n2)), t)
          ) =>
        if (unwind)  {
          println("unwind")
          repeatUnwind(toCEAutomaton(t, unwind), n1, n2)
        }
        else repeat(toCEAutomaton(t, unwind), n1, n2)
      case IFunApp(`re_*` | `re_*?`, Seq(t)) =>
        repeatUnwind(toCEAutomaton(t, true), 0)

      case IFunApp(`re_+` | `re_+?`, Seq(t)) =>
        repeatUnwind(toCEAutomaton(t, true), 1)

      case _ => CostEnrichedAutomaton(toBAutomaton(t, true))

    }

  override def buildAut(t: ITerm, minimize: Boolean): Automaton = {
    // minimize always, not use the parameter `minimize`
    try {
      val a = toCEAutomaton(t, false)
      a
    } catch {
      case e: Exception => {
        println("Error in building automaton for " + t)
        e.printStackTrace()
        throw e
      }
    }
  }

}
