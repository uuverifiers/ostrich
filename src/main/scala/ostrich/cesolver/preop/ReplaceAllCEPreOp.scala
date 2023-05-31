package ostrich.cesolver.preop

import scala.collection.mutable.{HashSet => MHashSet, HashMap => MHashMap, Stack=> MStack}

import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.automata.CETransducer
import ostrich.automata.BricsTLabelOps
import ostrich.cesolver.util.ParikhUtil.{State, partition, getImage}
import ostrich.automata.Automaton
import ostrich.automata.Transducer._
import ostrich.cesolver.util.ParikhUtil
import ostrich.automata.BricsTLabelEnumerator
import ostrich.cesolver.convenience.CostEnrichedConvenience.automaton2CostEnriched

object ReplaceAllCEPreOp {
  // pre-images of x = replaceall(y, e, u)
  def apply(pattern: CostEnrichedAutomatonBase, replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern)
    new ReplaceCEPreOp(transducer, replacement)
  }

  // pre-images of x = replaceall(y, u1, u2)
  def apply(pattern: Seq[Char], replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern)
    new ReplaceCEPreOp(transducer, replacement)
  }

  private def buildTransducer(aut: CostEnrichedAutomatonBase) : CETransducer = {
    ParikhUtil.todo("ReplaceAllCEPreOp: not handle empty match in pattern")
    abstract class Mode
    // not matching
    case object NotMatching extends Mode
    // matching, word read so far could reach any state in frontier
    case class Matching(val frontier : Set[aut.State]) extends Mode
    // last transition finished a match and reached frontier
    case class EndMatch(val frontier : Set[aut.State]) extends Mode

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
        val s = ceTran.newState()
        mapState(s, (m, noreach))
        val goodNoreach = !noreach.exists(aut.isAccept(_))
        ceTran.setAccept(s, m match {
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
    val tranInit = ceTran.initialState

    mapState(tranInit, (NotMatching, Set.empty[aut.State]))
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
            val initImg = getImage(aut, Set(autInit), lbl)
            val frontImg = getImage(aut, frontier, lbl)
            val noreachImg = getImage(aut, noreach, lbl)

            val noMatch = getState(NotMatching, initImg ++ frontImg ++ noreachImg)
            ceTran.addTransition(ts, lbl, copy, noMatch)

            if (!initImg.isEmpty) {
              val newMatch = getState(Matching(initImg), frontImg ++ noreachImg)
              ceTran.addTransition(ts, lbl, nop, newMatch)
            }

            if (initImg.exists(aut.isAccept(_))) {
              val oneCharMatch = getState(EndMatch(initImg), frontImg ++ noreachImg)
              ceTran.addTransition(ts, lbl, internal, oneCharMatch)
            }
          }
        }
      }
    }
    ceTran
  }

  private def buildTransducer(w: Seq[Char]) : CETransducer = {
    val ceTran = new CETransducer

    val initState = ceTran.initialState
    val states = initState::(List.fill(w.size - 1)(ceTran.newState()))
    val finstates = List.fill(w.size)(ceTran.newState())
    val nop = OutputOp("", NOP, "")
    val internal = OutputOp("", Internal, "")
    val end = w.size - 1

    ceTran.setAccept(initState, true)
    finstates.foreach(ceTran.setAccept(_, true))

    // recognise word
    // deliberately miss last element
    for (i <- 0 until w.size - 1) {
      ceTran.addTransition(states(i), (w(i), w(i)), nop, states(i+1))
    }
    ceTran.addTransition(states(end), (w(end), w(end)), internal, states(0))

    for (i <- 0 until w.size) {
      // the amount of w read up to state i
      val buffer = w.slice(0, i)
      // for when we need to output whole prefix read so far
      val output = OutputOp(w.slice(0, i), Plus(0), "")

      // if mismatch, look for the largest suffix of the output buffer
      // that is a correct prefix of the word being searched for. Then
      // return to the state corresponding to that part of the word.
      val anyLbl = ceTran.LabelOps.sigmaLabel

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

          ceTran.addTransition(states(i),
                                (charNext, charNext),
                                rejectedOutput,
                                states(prefix.size + 1))

          handledChars.add(charNext)
        }
      }

      // letters that should return to start
      for (lbl <- ceTran.LabelOps.subtractLetters(handledChars, anyLbl)) {
        ceTran.addTransition(states(i), lbl, output, states(0))
      }

      // handle word ending in middle of match
      val outop = if (i == w.size -1) internal else output
      ceTran.addTransition(states(i), (w(i), w(i)), outop, finstates(i))
    }

    ceTran
  }
}


class ReplaceAllCEPreOp(tran: CETransducer, replacement: Seq[Char]) extends CEPreOp{

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

  override def toString(): String = "ReplaceAllCEPreOp"

}