package ostrich.ceasolver.preop

import scala.collection.mutable.{HashMap => MHashMap, HashSet => MHashSet}

import ostrich.automata.Automaton
import ostrich.automata.Transducer
import ostrich.automata.BricsTransducer
import ostrich.automata.BricsTransducerBuilder
import ostrich.ceasolver.automata.CostEnrichedAutomatonBase
import Transducer._
import dk.brics.automaton.State
import scala.collection.mutable.Stack
import scala.collection.mutable.ArrayBuffer
import ostrich.ceasolver.util.ParikhUtil.TLabel

object ReplaceCEPreOp {
  // pre-images of replace(x, e, u)
  def apply(pattern: CostEnrichedAutomatonBase, replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern, replacement)
    new ReplaceCEPreOp(transducer)
  }

  // pre-images of replace(x, u1, u2)
  def apply(pattern: Seq[Char], replacement: Seq[Char]) = {
    val transducer = buildTransducer(pattern, replacement)
    new ReplaceCEPreOp(transducer)
  }

  private def buildTransducer(
      pattern: CostEnrichedAutomatonBase,
      replacement: Seq[Char]
  ): BricsTransducer = {
    val builder = new BricsTransducerBuilder
    builder.getTransducer
  }

  private def buildTransducer(
      pattern: Seq[Char],
      replacement: Seq[Char]
  ): BricsTransducer = {
    val builder = BricsTransducer.getBuilder

    val initState = builder.initialState
    val states = initState :: (List.fill(pattern.size - 1)(builder.getNewState))
    val finstates = List.fill(pattern.size)(builder.getNewState)
    val copyRest = builder.getNewState
    val nop = OutputOp("", NOP, "")
    val internal = OutputOp(replacement, Internal, "")
    val copy = OutputOp("", Plus(0), "")
    val end = pattern.size - 1

    builder.setAccept(initState, true)
    finstates.foreach(builder.setAccept(_, true))
    builder.setAccept(copyRest, true)

    // recognise word
    for (i <- 0 until pattern.size - 1) {
      builder.addTransition(
        states(i),
        (pattern(i), pattern(i)),
        nop,
        states(i + 1)
      )
    }
    builder.addTransition(
      states(end),
      (pattern(end), pattern(end)),
      internal,
      copyRest
    )
    // copy rest after the first match
    builder.addTransition(copyRest, builder.LabelOps.sigmaLabel, copy, copyRest)

    // handle word ending in middle of match
    for (i <- 0 until pattern.size - 1) {
      val output = OutputOp(pattern.slice(0, i), Plus(0), "")
      builder.addTransition(
        states(i),
        (pattern(i), pattern(i)),
        output,
        finstates(i)
      )
    }

    // handle the mismatch cases
    for (i <- 0 until pattern.size) {
      val output = OutputOp(pattern.slice(0, i), Plus(0), "")

      // begin again if mismatch
      val anyLbl = builder.LabelOps.sigmaLabel
      for (lbl <- builder.LabelOps.subtractLetter(pattern(i), anyLbl))
        builder.addTransition(states(i), lbl, output, states(0))
    }

    builder.getTransducer
  }
}

class ReplaceCEPreOp(tran: BricsTransducer) extends CEPreOp {
  def apply(
      argumentConstraints: Seq[Seq[Automaton]],
      resultConstraint: Automaton
  ): (Iterator[Seq[Automaton]], Seq[Seq[Automaton]]) = {
    val preimage = new CostEnrichedAutomatonBase
    val res = resultConstraint.asInstanceOf[CostEnrichedAutomatonBase]
    val emptyUpdate = Seq.fill(preimage.registers.length)(0)
    val old2new = MHashMap[(State, State), State]()
    old2new.put((tran.initialState, res.initialState), preimage.initialState)
    val seenlist = MHashSet[(State, State)]()
    val worklist = Stack[(State, State)]()
    worklist.push((tran.initialState, res.initialState))
    seenlist.add((tran.initialState, res.initialState))

    while (worklist.nonEmpty) {
      val (tranCurr, resAutCurr) = worklist.pop()
      for (
        outTrans <- tran.lblTrans.get(tranCurr);
        (tranLbl, op, tranSucc) <- outTrans
      ) {
        op match {
          // noop
          case OutputOp(_, NOP, _) => {
            val preimageSucc = old2new.getOrElseUpdate(
              (tranSucc, resAutCurr),
              preimage.newState()
            )
            preimage.addTransition(
              old2new((tranCurr, resAutCurr)),
              tranLbl,
              preimageSucc,
              emptyUpdate
            )
            if (!seenlist((tranSucc, resAutCurr))) {
              seenlist.add((tranSucc, resAutCurr))
              worklist.push((tranSucc, resAutCurr))
            }
          }

          // copy mismatched char and current char
          case OutputOp(prefix, Plus(0), _) => {
            // copy mismatched char
            var resAutCurrs = Set(resAutCurr)
            var old2newTmp = res.states.map(s => (s, preimage.newState())).toMap
            old2newTmp += (resAutCurr -> old2new((tranCurr, resAutCurr)))
            val prefixStack = Stack[Char]()
            for (c <- prefix.reverse) prefixStack.push(c)
            var findC = true   // flag to indicate if we have found the current char in res
            while (prefixStack.nonEmpty) {
              findC = false
              val c = prefixStack.pop()
              val resAutNext =
                for (
                  resAutCurr <- resAutCurrs;
                  (next, lbl, vec) <- res.outgoingTransitionsWithVec(
                    resAutCurr
                  );
                  interLbl <- res.LabelOps.intersectLabels((c, c), lbl)
                ) yield {
                  preimage.addTransition(
                    old2newTmp(resAutCurr),
                    interLbl,
                    old2newTmp(next),
                    vec
                  )
                  findC = true
                  next
                }
              resAutCurrs = resAutNext
            }
            // copy current lbl
            if (prefixStack.isEmpty && findC) {
              for (
                resAutCurr <- resAutCurrs;
                (next, lbl, vec) <- res.outgoingTransitionsWithVec(resAutCurr);
                interLbl <- res.LabelOps.intersectLabels(tranLbl, lbl)
              ) {
                preimage.addTransition(
                  old2newTmp(resAutCurr),
                  interLbl,
                  old2new.getOrElseUpdate(
                    (tranSucc, next),
                    preimage.newState()
                  ),
                  vec
                )
                if (!seenlist((tranSucc, next))) {
                  seenlist.add((tranSucc, next))
                  worklist.push((tranSucc, next))
                }
              }

            }
          }

          // replace pattern to replacement
          case OutputOp(replacement, Internal, _) => {
            for (
              (resAutSucc, vec) <- succOfString(
                res,
                resAutCurr,
                replacement.map(c => (c, c))
              )
            ) {
              val preimageSucc = old2new.getOrElseUpdate(
                (tranSucc, resAutSucc),
                preimage.newState()
              )
              preimage.addTransition(
                old2new((tranCurr, resAutCurr)),
                tranLbl,
                preimageSucc,
                vec
              )
              if (!seenlist((tranSucc, resAutSucc))) {
                seenlist.add((tranSucc, resAutSucc))
                worklist.push((tranSucc, resAutSucc))
              }
            }
          }

        }
      }
    }
    preimage.regsRelation = res.regsRelation
    preimage.registers = res.registers
    for (((tranState, resAutState), preimageState) <- old2new) {
      if (tran.isAccept(tranState) && res.isAccept(resAutState))
        preimage.setAccept(preimageState, true)
    }
    (Iterator(Seq(preimage)), Seq())
  }

  def eval(arguments: Seq[Seq[Int]]): Option[Seq[Int]] = {
    val replacedStr = arguments(0).map(_.toChar).mkString
    val pattern = arguments(1).map(_.toChar).mkString
    val replacement = arguments(2).map(_.toChar).mkString
    Some(replacedStr.replace(pattern, replacement).toCharArray().map(_.toInt))
  }

  override def toString(): String = "ReplaceCEPreOp"

  // use bread-first search to find the states reachable from start by
  // consuming str and the corresponding update vectors
  private def succOfString(
      aut: CostEnrichedAutomatonBase,
      start: State,
      str: Seq[TLabel]
  ): Iterator[(State, Seq[Int])] = {
    var bfsnow = Set((start, Seq.fill(aut.registers.length)(0)))
    val strStack = Stack[TLabel]()
    for (c <- str.reverse) strStack.push(c)
    while (strStack.nonEmpty && bfsnow.nonEmpty) {
      val c = strStack.pop()
      val next = (for (
        (state, vec) <- bfsnow;
        (succ, lbl, succVec) <- aut.outgoingTransitionsWithVec(state);
        _ <- aut.LabelOps.intersectLabels(c, lbl)
      ) yield (succ, sum(vec, succVec))).toSet
      bfsnow = next
    }

    if (strStack.nonEmpty) Iterator()
    else bfsnow.iterator
  }

  private def sum(v1: Seq[Int], v2: Seq[Int]): Seq[Int] = {
    v1.zip(v2).map { case (x, y) => x + y }
  }

}
