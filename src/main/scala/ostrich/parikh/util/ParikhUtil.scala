package ostrich.parikh

import scala.collection.mutable.{
  Map => MMap,
  HashSet => MHashSet,
  HashMap => MHashMap,
  TreeSet => MTreeSet,
  ArrayStack
}
import ap.terfor.Term
import ostrich.parikh.automata.CostEnrichedAutomatonBase

import ap.basetypes.IdealInt
import scala.collection.mutable.ArrayBuffer
import ap.api.SimpleAPI
import ap.api.SimpleAPI.ProverStatus
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.core.FinalConstraints

object ParikhUtil {
  private val CountingRegisters = new MHashSet[Term]()
  def addCountingRegister(t: Term) = CountingRegisters += t

  type State = CostEnrichedAutomatonBase#State
  type TLabel = CostEnrichedAutomatonBase#TLabel

  def measure[A](
      op: String
  )(comp: => A)(implicit manualFlag: Boolean = true): A =
    if (OstrichConfig.measureTime && manualFlag)
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
      auts: Seq[CostEnrichedAutomatonBase],
      registersModel: MMap[Term, IdealInt]
  ): Option[Seq[Int]] = {

    val productAut = auts.reduceLeft(_ product _)

    val registersValue = productAut.registers.map(registersModel(_).intValue)
    val todoList = new ArrayStack[(State, Seq[Int], Seq[Char])]
    val visited = new MHashSet[(State, Seq[Int])]
    todoList.push(
      (
        productAut.initialState,
        Seq.fill(productAut.registers.size)(0),
        ""
      )
    )
    visited.add(
      (productAut.initialState, Seq.fill(productAut.registers.size)(0))
    )
    while (!todoList.isEmpty) {
      val (state, regsVal, word) = todoList.pop
      if (productAut.isAccept(state) && regsVal == registersValue) {
        return Some(word.map(_.toInt))
      }
      for ((t, l, v) <- productAut.outgoingTransitionsWithVec(state)) {
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
  def findAcceptedWordByRegistersHeuristic(
      auts: Seq[CostEnrichedAutomatonBase],
      registersModel: MMap[Term, IdealInt]
  ): Option[Seq[Int]] = {
    val aut = auts.reduce(_ product _)
    val s2scc = findAllSCC(aut)
    val paths: ArrayBuffer[Seq[State]] = ArrayBuffer()
    val worklist = ArrayStack[Seq[State]]()
    val visited = MHashSet[Seq[State]]()

    worklist.push(Seq(aut.initialState))
    while (worklist.nonEmpty) {
      val path = worklist.pop
      val lastState = path.last
      val lastStateScc = s2scc(lastState)
      if (lastStateScc.find(aut.isAccept).isDefined)
        paths += path
      visited.add(path)
      val tmpWorklist = ArrayStack[State]()
      val tmpVisited = MHashSet[State]()
      tmpWorklist.push(lastState)
      while (tmpWorklist.nonEmpty) {
        val s = tmpWorklist.pop
        tmpVisited.add(s)
        for ((t, _, _) <- aut.outgoingTransitionsWithVec(s)) {
          if (!lastStateScc.contains(t)) {
            val newPath = path :+ t
            if (!visited(newPath)) {
              worklist.push(newPath)
            }
          } else if (!tmpVisited(t)) {
            tmpWorklist.push(t)
          }
        }
      }
    }
    for (path <- paths) {
      findAcceptedWordInPath(aut, registersModel, s2scc, path) match {
        case Some(value) => return Some(value)
        case _           =>
      }
    }
    None
  }

  def findAcceptedWordInPath(
      aut: CostEnrichedAutomatonBase,
      registersModel: MMap[Term, IdealInt],
      s2scc: MMap[State, Set[State]],
      path: Seq[State]
  ): Option[Seq[Int]] = {
    val trans2Word = MHashMap[(State, State), Seq[Char]]()
    var constantUpdate = Seq.fill(aut.registers.length)(0)
    val state2Word = MHashMap[State, Seq[Char]]()
    val state2Update = MHashMap[State, Seq[Int]]()
    val linearsT = ArrayBuffer[Seq[LinearCombination]]()

    val registersValue = aut.registers.map(registersModel(_).intValue)

    SimpleAPI.withProver() { p =>
      import p._
      import ap.terfor.TerForConvenience._

      val state2term = path.map(s => s -> createConstantRaw(s"$s")).toMap
      val pathpair = path.zip(path.tail :+ path.head)
      for ((s, t) <- pathpair) {
        val (cycleWord, cycleUpdate) = findCycleWordAndUpdate(aut, s, s2scc(s))
        if (cycleUpdate.exists(_ > 0)) {
          state2Word(s) = cycleWord
          state2Update(s) = cycleUpdate
        }
        if (t != path.head) {
          val (word, update) = findWordAndUpdate(aut, s, t)
          trans2Word += ((s, t) -> word)
          constantUpdate =
            constantUpdate.zip(update).map { case (a, b) => a + b }
        }
      }

      linearsT += constantUpdate.map(LinearCombination(_))
      for ((s, update) <- state2Update) {
        if (update.find(_ > 0).isDefined)
          linearsT += update.map(i => {
            if (i == 0)
              l(0)
            else
              LinearCombination(i, state2term(s), order)
          })
      }
      implicit val newOrder = order
      val linears = linearsT.transpose.map(_.reduce(_ + _))
      val geqZ = for ((s, t) <- state2term) yield (t >= 0)
      val formula = conj(
        linears.zip(registersValue).map { case (linear, value) =>
          linear === value
        } ++ geqZ
      )

      p addAssertion formula
      ??? match {
        case ProverStatus.Sat =>
          val state2Int = (for (
            (s, t) <- state2term;
            value <- FinalConstraints.evalTerm(t)(p.partialModel);
            if value.intValue > 0
          ) yield (s, value.intValue)).toMap
          var acceptedWord = Seq[Char]()
          for ((s, t) <- pathpair){
            if(state2Int.contains(s)){
              for (_ <- 0 until state2Int(s))
                acceptedWord ++= state2Word(s)
            }
            if(t == path.head)  return Some(acceptedWord.map(_.toInt))
            acceptedWord ++= trans2Word((s,t))
          }
        case _ => // do nothing
      }

    }

    None
  }

  def findAcceptedWordByRegisters(
      auts: Seq[CostEnrichedAutomatonBase],
      registersModel: MMap[Term, IdealInt]
  ): Option[Seq[Int]] = {
    println("find string model")
    findAcceptedWordByRegistersHeuristic(auts, registersModel) match {
      case None => findAcceptedWordByRegistersComplete(auts, registersModel)
      case Some(value) => Some(value)
    }
  }

  /** Given transtion repeat times, check whether there is some word accepted by
    * all of the given automata. Note that this function heuristicly finds a
    * word. It is sound, but not complete.
    */
  // def findAcceptedWordByTranstions(
  //     auts: Seq[CostEnrichedAutomatonTrait],
  //     transtionsModel: MMap[Term, IdealInt]
  // ): Option[Seq[Int]] = {

  //   val transitionRepeatTimes = transtionsModel.map { case (t, i) =>
  //     (t, i.intValue)
  //   }
  //   val fisrtAut = auts(0)

  //   /** One step of intersection
  //     */
  //   def enumNext(
  //       auts: Seq[CostEnrichedAutomatonTrait],
  //       states: Seq[State],
  //       transitionModel: MMap[Term, Int],
  //       intersectedLabels: TLabel
  //   ): Iterator[(Seq[State], MMap[Term, Int], Int)] =
  //     auts match {
  //       case Seq() =>
  //         Iterator(
  //           (
  //             Seq(),
  //             transitionModel.clone(),
  //             fisrtAut.LabelOps.enumLetters(intersectedLabels).next
  //           )
  //         )
  //       case aut +: otherAuts => {
  //         val state +: otherStates = states
  //         for (
  //           (to, label, term) <- aut.outgoingTransitionsWithVecWithTerm(
  //             state
  //           );
  //           newILabel <- aut.LabelOps
  //             .intersectLabels(
  //               intersectedLabels,
  //               label
  //             )
  //             .toSeq;
  //           if (transitionModel(term) > 0);
  //           (tailNext, updatedModel, char) <- enumNext(
  //             otherAuts,
  //             otherStates,
  //             transitionModel + ((
  //               term,
  //               transitionModel(term) - 1
  //             )), // update lengthModel
  //             newILabel
  //           )
  //         )
  //           yield (to +: tailNext, updatedModel, char)
  //       }
  //     }

  //   val initial = (auts map (_.initialState))

  //   if (isAccepting(auts, initial, transitionRepeatTimes))
  //     return Some(Seq())

  //   val visitedStates = new MHashSet[(Seq[State], MMap[Term, Int])]
  //   val todo = new ArrayStack[(Seq[State], MMap[Term, Int], Seq[Int])]

  //   visitedStates += ((initial, transitionRepeatTimes))
  //   todo push ((initial, transitionRepeatTimes, Seq()))

  //   while (!todo.isEmpty) {
  //     val (next, lengthModel, w) = todo.pop
  //     for (
  //       (reached, updatedModel, char) <-
  //         enumNext(
  //           auts,
  //           next,
  //           lengthModel,
  //           auts(0).LabelOps.sigmaLabel
  //         )
  //     ) {

  //       if (visitedStates.add((reached, updatedModel))) {
  //         val newW = w :+ char
  //         if (isAccepting(auts, reached, updatedModel))
  //           return Some(newW)
  //         todo push ((reached, updatedModel, newW))
  //       }
  //     }
  //   }
  //   None
  // }

  /** Given a sequence of automata and synchronized length, return a sequence of
    * automata that is equivalent to the given sequence of automata. And return
    * the map from state to its prefix string
    * @param auts
    *   the sequence of automata
    * @param synclen
    *   the length need to synchronize
    */
  // def getSyncLenAuts(
  //     auts: Seq[CostEnrichedAutomatonBase],
  //     labels: MTreeSet[TLabel],
  //     synclen: Int
  // ): (Seq[CostEnrichedAutomatonBase], MMap[State, Seq[TLabel]]) = {
  //   if (synclen <= 0) {
  //     return (auts, MMap())
  //   }
  //   val newState2Prefix = new MHashMap[State, Seq[TLabel]]
  //   val newAuts = auts.map { case aut =>
  //     val (newAut, map) = getSyncLenAut(aut, labels, synclen)
  //     newState2Prefix ++= map
  //     newAut
  //   }
  //   (newAuts, newState2Prefix)
  // }

  /** Given an automaton and synchronized length, return an automaton that is
    * equivalent to the given automaton. And return the map from state to its
    * prefix string
    * @param aut
    *   the automaton
    * @param synclen
    *   the length need to synchronize
    */
  // def getSyncLenAut(
  //     aut: CostEnrichedAutomatonBase,
  //     labels: MTreeSet[TLabel],
  //     synclen: Int
  // ): (CostEnrichedAutomatonBase, MMap[State, Seq[TLabel]]) = {
  //   assert(synclen >= 1)
  //   // prefix len
  //   val prefixLen = synclen - 1
  //   // (old state, prefix string) pair
  //   val worklist = new ArrayStack[(State, Seq[TLabel])]
  //   val seenSet = new MHashSet[(State, Seq[TLabel])]
  //   // pair (old state, prefix string) to new state
  //   val oldStateWithPrefix2newState = new MHashMap[(State, Seq[TLabel]), State]
  //   // new state to prefix string
  //   val newState2Prefix = new MHashMap[State, Seq[TLabel]]
  //   val builder = aut.getBuilder.asInstanceOf[CostEnrichedAutomatonBuilder]

  //   val initialState = builder.getNewState
  //   builder.setInitialState(initialState)
  //   builder.setAccept(initialState, aut.isAccept(aut.initialState))

  //   worklist.push((aut.initialState, Seq()))
  //   oldStateWithPrefix2newState += ((aut.initialState, Seq()) -> initialState)
  //   newState2Prefix += (initialState -> Seq())

  //   while (!worklist.isEmpty) {
  //     val (oldStatePre, prefix) = worklist.pop
  //     if (seenSet.add((oldStatePre, prefix))) {
  //       val newStatePre = oldStateWithPrefix2newState((oldStatePre, prefix))
  //       for (
  //         (to, (lMin, lMax), vec) <- aut.outgoingTransitionsWithVec(oldStatePre)
  //       ) {
  //         val splitLabelIt = labels
  //           .from((lMin, Char.MinValue))
  //           .to((lMax, Char.MaxValue))
  //           .toIterable
  //         for (label <- splitLabelIt) {
  //           val newPrefix = (prefix :+ label).take(prefixLen)
  //           val newState = oldStateWithPrefix2newState.getOrElse(
  //             (to, newPrefix),
  //             builder.getNewState
  //           )
  //           builder.addTransition(newStatePre, label, newState, vec)
  //           builder.setAccept(newState, aut.isAccept(to))
  //           worklist.push((to, newPrefix))
  //           oldStateWithPrefix2newState += ((to, newPrefix) -> newState)
  //           newState2Prefix += (newState -> newPrefix)
  //         }
  //       }
  //     }
  //   }
  //   builder addRegsRelation (aut.getRegsRelation)
  //   builder prependRegisters (aut.registers)
  //   (builder.getAutomaton, newState2Prefix)
  // }

  /** Given a sequence of automata, return a set of labels. The labels represent
    * all labels in `auts` and have min interval
    * @param auts
    *   the sequence of automata
    */
  // def split2MinLabels(
  //     auts: Seq[CostEnrichedAutomatonBase]
  // ): MTreeSet[TLabel] = {
  //   val oldLabels = new MHashSet[TLabel]
  //   for (aut <- auts)
  //     for ((_, label, _) <- aut.transitions)
  //       oldLabels += label
  //   val splitedLabels = new MTreeSet[TLabel]
  //   new BricsTLabelEnumerator(oldLabels.iterator).enumDisjointLabels.foreach(
  //     splitedLabels += _
  //   )
  //   splitedLabels
  // }

  /** Compute a formula that represents the synchronization of substring from
    * length 1 to `synclen` in `auts`
    * @param auts
    *   the sequence of automata
    * @param states2prefix
    *   the map from state to its prefix string
    * @param labels
    *   the set of splited labels
    * @param synclen
    *   the max length need to synchronize
    */
  // def sync(
  //     auts: Seq[CostEnrichedAutomatonTrait],
  //     states2Prefix: MMap[State, Seq[TLabel]],
  //     labels: MTreeSet[TLabel],
  //     synclen: Int
  // ): Formula = {
  //   if (synclen == 0) return Conjunction.TRUE
  //   var finalFormula = Conjunction.TRUE
  //   var strings: Seq[Traversable[TLabel]] = Seq()
  //   for (i <- 0 until synclen + 1)
  //     strings = strings ++: crossJoin(Seq.fill(i)(labels)).toSeq

  //   val commonStr2LTerm = strings.map { case str => (str, LabelTerm()) }.toMap
  //   for (aut <- auts) {
  //     val lTerm2Terms = new MHashMap[Term, MHashSet[Term]]
  //     for ((from, label, to, tTerm) <- aut.transitionsWithTerm) {
  //       val prefix = states2Prefix(from)
  //       val str = prefix :+ label
  //       val lTerm = commonStr2LTerm(str)
  //       // partition transition terms by transition label
  //       lTerm2Terms.getOrElseUpdate(lTerm, new MHashSet[Term]).add(tTerm)
  //     }
  //     // if the label does not appear in any transtion, the label count is 0
  //     commonStr2LTerm.values.filterNot(lTerm2Terms.contains).foreach { lTerm =>
  //       finalFormula = finalFormula & (lTerm === 0)
  //     }
  //     // label count is the sum of transition terms
  //     lTerm2Terms.foreach { case (lTerm, terms) =>
  //       finalFormula = finalFormula & (lTerm === terms
  //         .reduceOption(_ + _)
  //         .getOrElse(l(0))) & (lTerm >= 0)
  //     }
  //   }
  //   finalFormula
  // }

  /** Compute cross join of a sequence of lists
    * @param list
    *   the list of list need to be cross joined
    */
  // def crossJoin[T](
  //     list: Traversable[Traversable[T]]
  // ): Traversable[Traversable[T]] =
  //   list match {
  //     case Nil       => Nil
  //     case xs :: Nil => xs map (Traversable(_))
  //     case x :: xs =>
  //       for {
  //         i <- x
  //         j <- crossJoin(xs)
  //       } yield Traversable(i) ++ j
  //   }
}
