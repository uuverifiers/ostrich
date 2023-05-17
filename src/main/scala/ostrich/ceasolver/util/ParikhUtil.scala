package ostrich.ceasolver.util

import scala.collection.mutable.{
  Map => MMap,
  HashSet => MHashSet,
  HashMap => MHashMap,
  ArrayStack
}
import ostrich.ceasolver.automata.CostEnrichedAutomatonBase

import ap.basetypes.IdealInt
import scala.collection.mutable.ArrayBuffer
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.terfor.linearcombination.LinearCombination
import ostrich.ceasolver.core.FinalConstraints
import ap.parser.ITerm
import ap.parser.IExpression._

object ParikhUtil {
  private val CountingRegisters = new MHashSet[ITerm]()
  def addCountingRegister(t: ITerm) = CountingRegisters += t

  type State = CostEnrichedAutomatonBase#State
  type TLabel = CostEnrichedAutomatonBase#TLabel

  def measure[A](
      op: String
  )(comp: => A)(implicit manualFlag: Boolean = true): A =
    if (manualFlag)
      ap.util.Timer.measure(op)(comp)
    else
      comp

  def findAllSCC(aut: CostEnrichedAutomatonBase) = {
    aut.states.zipWithIndex.toMap
    val state2SCC = new MHashMap[State, Set[State]]
    val LReverse = new ArrayBuffer[State]()
    val seenList = MHashSet[State]()
    def dfsReverseAutStep(s: State): Unit = {
      if (!seenList(s)) {
        seenList += s
        for ((t, _, _) <- aut.incomingTransitionsWithVec(s)) {
          dfsReverseAutStep(t)
        }
        LReverse += s
      }
    }
    for (s <- aut.states) {
      if (!seenList(s))
        dfsReverseAutStep(s)
    }
    val L = LReverse.reverse
    val visited = MHashSet[State]()
    var lastSccFirstState = L(0)
    while (visited.size < aut.states.size) {
      val seenSet = MHashSet[State]()
      val worklist = ArrayStack[State]()
      worklist.push(lastSccFirstState)
      while (!worklist.isEmpty) {
        val s = worklist.pop
        seenSet += s
        for ((t, _, vec) <- aut.outgoingTransitionsWithVec(s)) {
          if (!seenSet(t) && !visited(t)) {
            worklist.push(t)
          }
        }
        for (s <- seenSet)
          state2SCC(s) = seenSet.toSet
      }
      visited ++= seenSet
      var i = 0
      while (i < L.size && visited(L(i))) {
        i += 1
      }
      if (i < L.size)
        lastSccFirstState = L(i)
    }
    state2SCC
  }

  def findCycleWordAndUpdate(
      aut: CostEnrichedAutomatonBase,
      entry: State,
      scc: Set[State]
  ): (Seq[Char], Seq[Int]) = {
    val worklist = ArrayStack[(State, Seq[Char], Seq[Int])]()
    val visited = MHashSet[State]()
    worklist.push((entry, Seq(), Seq.fill(aut.registers.length)(0)))
    while (!worklist.isEmpty) {
      val (s, word, update) = worklist.pop
      for ((t, lbl, vec) <- aut.outgoingTransitionsWithVec(s)) {
        if (!visited(t) && scc.contains(t)) {
          val nextword = word :+ lbl._1
          val nextupdate = update.zip(vec).map { case (a, b) => a + b }
          if (t == entry)
            return (nextword, nextupdate)
          worklist.push((t, nextword, nextupdate))
        }
      }
      visited.add(s)
    }
    (Seq(), Seq())
  }

  def findWordAndUpdate(
      aut: CostEnrichedAutomatonBase,
      start: State,
      end: State
  ): (Seq[Char], Seq[Int]) = {
    val worklist = ArrayStack[(State, Seq[Char], Seq[Int])]()
    val visited = MHashSet[State]()
    worklist.push((start, Seq(), Seq.fill(aut.registers.length)(0)))
    while (!worklist.isEmpty) {
      val (s, word, update) = worklist.pop
      visited.add(s)
      for ((t, lbl, vec) <- aut.outgoingTransitionsWithVec(s)) {
        if (!visited(t)) {
          val newword = word :+ lbl._1
          val newupdate = update.zip(vec).map { case (a, b) => a + b }
          if (t == end) return (newword, newupdate)
          worklist.push((t, newword, newupdate))
        }
      }
    }
    (Seq(), Seq())
  }

  def findAcceptedWordByRegistersComplete(
      aut: CostEnrichedAutomatonBase,
      registersModel: MMap[ITerm, IdealInt]
  ): Option[Seq[Int]] = {

    val registersValue = aut.registers.map(registersModel(_).intValue)
    val todoList = new ArrayStack[(State, Seq[Int], Seq[Char])]
    val visited = new MHashSet[(State, Seq[Int])]
    todoList.push(
      (
        aut.initialState,
        Seq.fill(aut.registers.size)(0),
        ""
      )
    )
    visited.add(
      (aut.initialState, Seq.fill(aut.registers.size)(0))
    )
    while (!todoList.isEmpty) {
      val (state, regsVal, word) = todoList.pop
      if (aut.isAccept(state) && regsVal == registersValue) {
        return Some(word.map(_.toInt))
      }
      for ((t, l, v) <- aut.outgoingTransitionsWithVec(state)) {
        val newRegsVal = regsVal.zip(v).map { case (r, v) => r + v }
        val newWord = word :+ l._1
        val newState = t
        if (
          !visited.contains((newState, newRegsVal)) &&
          !newRegsVal.zip(registersValue).exists(r => r._1 > r._2)
        ) {
          todoList.push((newState, newRegsVal, newWord))
          visited.add((newState, newRegsVal))
        }
      }
    }
    None
  }

  // Note: A sound but not complete search for string. We can repidly update value of
  // counting register because it is be updated only by the same transition at most times.
  // Sometimes it may be updated by different transitions, so the search is not complete.
  // def findAcceptedWordByRegistersHeuristic(
  //     aut: CostEnrichedAutomatonBase,
  //     registersModel: MMap[ITerm, IdealInt]
  // ): Option[Seq[Int]] = {
  //   // we only heuristically search for string with large register values (the sum is greater than 200)
  //   if (registersModel.map(_._2.intValue).sum <= 200) return None
  //   val s2scc = findAllSCC(aut)
  //   val paths: ArrayBuffer[Seq[State]] = ArrayBuffer()
  //   val worklist = ArrayStack[Seq[State]]()
  //   val visited = MHashSet[Seq[State]]()

  //   worklist.push(Seq(aut.initialState))
  //   while (worklist.nonEmpty) {
  //     val path = worklist.pop
  //     val lastState = path.last
  //     val lastStateScc = s2scc(lastState)
  //     if (lastStateScc.find(aut.isAccept).isDefined)
  //       paths += path
  //     visited.add(path)
  //     val tmpWorklist = ArrayStack[State]()
  //     val tmpVisited = MHashSet[State]()
  //     tmpWorklist.push(lastState)
  //     while (tmpWorklist.nonEmpty) {
  //       val s = tmpWorklist.pop
  //       tmpVisited.add(s)
  //       for ((t, _, _) <- aut.outgoingTransitionsWithVec(s)) {
  //         if (!lastStateScc.contains(t)) {
  //           val newPath = path :+ t
  //           if (!visited(newPath)) {
  //             worklist.push(newPath)
  //           }
  //         } else if (!tmpVisited(t)) {
  //           tmpWorklist.push(t)
  //         }
  //       }
  //     }
  //   }
  //   for (path <- paths) {
  //     findAcceptedWordInPath(aut, registersModel, s2scc, path) match {
  //       case Some(value) => return Some(value)
  //       case _           =>
  //     }
  //   }
  //   None
  // }

  // def findAcceptedWordInPath(
  //     aut: CostEnrichedAutomatonBase,
  //     registersModel: MMap[ITerm, IdealInt],
  //     s2scc: MMap[State, Set[State]],
  //     path: Seq[State]
  // ): Option[Seq[Int]] = {
  //   val trans2Word = MHashMap[(State, State), Seq[Char]]()
  //   var constantUpdate = Seq.fill(aut.registers.length)(0)
  //   val state2Word = MHashMap[State, Seq[Char]]()
  //   val state2Update = MHashMap[State, Seq[Int]]()
  //   val linearsT = ArrayBuffer[Seq[LinearCombination]]()

  //   val registersValue = aut.registers.map(registersModel(_).intValue)

  //   SimpleAPI.withProver() { p =>
  //     import p._

  //     val state2term = path.map(s => s -> createConstantRaw(s"$s")).toMap
  //     val pathpair = path.zip(path.tail :+ path.head)
  //     for ((s, t) <- pathpair) {
  //       val (cycleWord, cycleUpdate) = findCycleWordAndUpdate(aut, s, s2scc(s))
  //       if (cycleUpdate.exists(_ > 0)) {
  //         state2Word(s) = cycleWord
  //         state2Update(s) = cycleUpdate
  //       }
  //       if (t != path.head) {
  //         val (word, update) = findWordAndUpdate(aut, s, t)
  //         trans2Word += ((s, t) -> word)
  //         constantUpdate =
  //           constantUpdate.zip(update).map { case (a, b) => a + b }
  //       }
  //     }

  //     linearsT += constantUpdate.map(LinearCombination(_))
  //     for ((s, update) <- state2Update) {
  //       if (update.find(_ > 0).isDefined)
  //         linearsT += update.map(i => {
  //           if (i == 0)
  //             l(0)
  //           else
  //             LinearCombination(i, state2term(s), order)
  //         })
  //     }
  //     implicit val newOrder = order
  //     val linears = linearsT.transpose.map(_.reduce(_ + _))
  //     val geqZ = for ((s, t) <- state2term) yield (t >= 0)
  //     val formula = and(
  //       linears.zip(registersValue).map { case (linear, value) =>
  //         linear === value
  //       } ++ geqZ
  //     )

  //     p addAssertion formula
  //     ??? match {
  //       case ProverStatus.Sat =>
  //         val state2Int = (for (
  //           (s, t) <- state2term;
  //           value <- FinalConstraints.evalTerm(t)(p.partialModel);
  //           if value.intValue > 0
  //         ) yield (s, value.intValue)).toMap
  //         var acceptedWord = Seq[Char]()
  //         for ((s, t) <- pathpair) {
  //           if (state2Int.contains(s)) {
  //             for (_ <- 0 until state2Int(s))
  //               acceptedWord ++= state2Word(s)
  //           }
  //           if (t == path.head) return Some(acceptedWord.map(_.toInt))
  //           acceptedWord ++= trans2Word((s, t))
  //         }
  //       case _ => // do nothing
  //     }

  //   }
  //   None
  // }

  def findAcceptedWordByRegisters(
      auts: Seq[CostEnrichedAutomatonBase],
      registersModel: MMap[ITerm, IdealInt]
  ): Option[Seq[Int]] = {
    val aut = auts.reduce(_ product _)
    // if (OstrichConfig.findStringHeu) {
    //   findAcceptedWordByRegistersHeuristic(aut, registersModel) match {
    //     case None => findAcceptedWordByRegistersComplete(aut, registersModel)
    //     case Some(value) => Some(value)
    //   }
    // } else
    findAcceptedWordByRegistersComplete(aut, registersModel)

  }

  def debugPrintln(s: Any) = {
    println("Debug: " + s)
  }

  def todo(s:Any) = {
    println("TODO:" + s)
  }
}
