package ostrich.cesolver.preop

import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  Stack => MStack
}

import ostrich.automata.Automaton
import ostrich.automata.Transducer
import ostrich.automata.BricsTransducer
import ostrich.automata.BricsTransducerBuilder
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import Transducer._
import scala.collection.mutable.Stack
import scala.collection.mutable.ArrayBuffer
import ostrich.cesolver.util.ParikhUtil.TLabel
import ostrich.cesolver.automata.CETransducer
import ostrich.cesolver.util.ParikhUtil
import ostrich.automata.BricsTLabelOps
import ostrich.automata.BricsTLabelEnumerator
import ostrich.cesolver.util.ParikhUtil.{partition, State, getImage}
import ostrich.cesolver.convenience.CostEnrichedConvenience.automaton2CostEnriched

object ReplaceCEPreOp {
  // pre-images of x = replace(y, e, u)
  def apply(pattern: CostEnrichedAutomatonBase, replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern)
    new ReplaceCEPreOp(transducer, replacement)
  }

  // pre-images of x = replace(y, u1, u2)
  def apply(pattern: Seq[Char], replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern)
    new ReplaceCEPreOp(transducer, replacement)
  }

  private def buildTransducer(
      aut: CostEnrichedAutomatonBase
  ): CETransducer = {
    // ParikhUtil.todo("ReplaceCEPreOp: not handle empty match in pattern")
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier: Set[State]) extends Mode
    // last transition finished a match and reached frontier
    case class EndMatch(val frontier: Set[State]) extends Mode
    // copy the rest of the word after first match
    case object CopyRest extends Mode

    val labelEnumerator = new BricsTLabelEnumerator(
      aut.transitionsWithVec.map(_._2).toIterator
    )
    val labels = labelEnumerator.enumDisjointLabelsComplete
    val ceTran = new CETransducer
    val nop = OutputOp("", NOP, "")
    val copy = OutputOp("", Plus(0), "")
    val internal = OutputOp("", Internal, "")

    // TODO: encapsulate this worklist automaton construction

    // states of transducer have current mode and a set of states that
    // should never reach a final state (if they do, a match has been
    // missed)
    val sMap = new MHashMap[State, (Mode, Set[State])]
    val sMapRev = new MHashMap[(Mode, Set[State]), State]

    // states of new transducer to be constructed
    val worklist = new MStack[State]

    def mapState(s: State, q: (Mode, Set[State])) = {
      sMap += (s -> q)
      sMapRev += (q -> s)
    }

    // creates and adds to worklist any new states if needed
    def getState(m: Mode, noreach: Set[State]): State = {
      sMapRev.getOrElse(
        (m, noreach), {
          val s = ceTran.newState()
          mapState(s, (m, noreach))
          val goodNoreach = !noreach.exists(aut.isAccept(_))
          ceTran.setAccept(
            s,
            m match {
              case NotMatching => goodNoreach
              case EndMatch(_) => goodNoreach
              case Matching(_) => false
              case CopyRest    => goodNoreach
            }
          )
          if (goodNoreach)
            worklist.push(s)
          s
        }
      )
    }

    val autInit = aut.initialState
    val tranInit = ceTran.initialState

    mapState(tranInit, (NotMatching, Set.empty[State]))
    ceTran.setAccept(tranInit, true)
    worklist.push(tranInit)

    while (!worklist.isEmpty) {
      val ts = worklist.pop()
      val (mode, noreach) = sMap(ts)

      mode match {
        case NotMatching => {
          for (lbl <- labels) {
            val initImg = getImage(aut, Set(autInit), lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            val dontMatch = getState(NotMatching, noreachImg ++ initImg)
            ceTran.addTransition(ts, lbl, copy, dontMatch)

            if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), noreachImg)
              ceTran.addTransition(ts, lbl, nop, newMatch)
            }

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(EndMatch(initImg), noreachImg)
              ceTran.addTransition(ts, lbl, internal, oneCharMatch)
            }
          }
        }
        case Matching(frontier) => {
          for (lbl <- labels) {
            val frontImg = getImage(aut, frontier, lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            if (!frontImg.isEmpty) {
              val contMatch = getState(Matching(frontImg), noreachImg)
              ceTran.addTransition(ts, lbl, nop, contMatch)
            }

            if (frontImg.exists(aut.isAccept(_))) {
              val stopMatch = getState(EndMatch(frontImg), noreachImg)
              ceTran.addTransition(ts, lbl, internal, stopMatch)
            }
          }
        }
        case EndMatch(frontier) => {
          for (lbl <- labels) {
            val frontImg = getImage(aut, frontier, lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            val noMatch = getState(CopyRest, frontImg ++ noreachImg)

            ceTran.addTransition(ts, lbl, copy, noMatch)
          }
        }
        case CopyRest => {
          for (lbl <- labels) {
            val noreachImg = getImage(aut, noreach, lbl)
            val copyRest = getState(CopyRest, noreachImg)
            ceTran.addTransition(ts, lbl, copy, copyRest)
          }
        }
      }
    }

    ceTran
  }

  private def buildTransducer(
      w: Seq[Char]
  ): CETransducer = {
    val ceTran = new CETransducer

    val initState = ceTran.initialState
    val states = initState :: (List.fill(w.size - 1)(ceTran.newState()))
    val finstates = List.fill(w.size)(ceTran.newState())
    val copyRest = ceTran.newState()
    val nop = OutputOp("", NOP, "")
    // TODO: internal
    val internal = OutputOp("", Internal, "")
    val copy = OutputOp("", Plus(0), "")
    val end = w.size - 1

    ceTran.setAccept(initState, true)
    finstates.foreach(ceTran.setAccept(_, true))
    ceTran.setAccept(copyRest, true)

    // recognise word
    // deliberately miss last element
    for (i <- 0 until w.size - 1) {
      ceTran.addTransition(states(i), (w(i), w(i)), nop, states(i + 1))
    }
    ceTran.addTransition(states(end), (w(end), w(end)), internal, copyRest)

    // copy rest after first match
    ceTran.addTransition(copyRest, ceTran.LabelOps.sigmaLabel, copy, copyRest)

    for (i <- 0 until w.size) {
      val output = OutputOp(w.slice(0, i), Plus(0), "")

      // begin again if mismatch
      val anyLbl = ceTran.LabelOps.sigmaLabel
      for (lbl <- ceTran.LabelOps.subtractLetter(w(i), anyLbl))
        ceTran.addTransition(states(i), lbl, output, states(0))

      // handle word ending in middle of match
      val outop = if (i == w.size - 1) internal else output
      ceTran.addTransition(states(i), (w(i), w(i)), outop, finstates(i))
    }
    ceTran
  }
}

class ReplaceCEPreOp(tran: CETransducer, replacement: Seq[Char])
    extends CEPreOp {
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    // x = replace(y, pattern, replacement)
    val rc = automaton2CostEnriched(resultConstraint)
    val internals = partition(rc, replacement)
    val newYCon = tran.preImage(rc, internals)
    (Iterator(Seq(newYCon)), argumentConstraints)
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
     for (s <- tran(arguments(0).map(_.toChar).mkString,
                   replacement.mkString))
    yield s.toSeq.map(_.toInt)
  }

  override def toString(): String = "ReplaceCEPreOp"

}
