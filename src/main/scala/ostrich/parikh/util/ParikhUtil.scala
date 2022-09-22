package ostrich.parikh

import scala.collection.mutable.{
  Map => MMap,
  HashSet => MHashSet,
  HashMap => MHashMap,
  TreeSet => MTreeSet,
  ArrayStack
}
import ap.terfor.Term
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import ap.terfor.TerForConvenience._
import TermGeneratorOrder._
import CostEnrichedConvenience._
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.automata.CostEnrichedAutomatonBuilder

import ostrich.automata.BricsTLabelEnumerator
import ap.basetypes.IdealInt

object ParikhUtil {

  type State = CostEnrichedAutomatonTrait#State
  type TLabel = CostEnrichedAutomatonTrait#TLabel

  /** Check whether all states are accepted
    */
  def isAccepting(
      auts: Seq[CostEnrichedAutomatonTrait],
      states: Seq[State],
      integerModel: MMap[Term, Int]
  ): Boolean =
    (states zip auts forall { case (state, aut) =>
      aut.isAccept(state)
    }) && (integerModel.map(_._2).forall(_ == 0))

  def findAcceptedWordByRegisters(
      auts: Seq[CostEnrichedAutomatonTrait],
      registersModel: MMap[Term, IdealInt]
  ): Option[Seq[Int]] = {

    if(registersModel.isEmpty) {
      // no registers
      return auts.reduceLeft(_ & _).getAcceptedWord
    }

    val registersValue = registersModel.map { case (t, r) =>
      (t, r.intValue)
    }
    val fisrtAut = auts(0)

    /** One step of intersection
      */
    def enumNext(
        auts: Seq[CostEnrichedAutomatonTrait],
        states: Seq[State],
        registersModel: MMap[Term, Int],
        intersectedLabels: TLabel
    ): Iterator[(Seq[State], MMap[Term, Int], Int)] =
      auts match {
        case Seq() =>
          Iterator(
            (
              Seq(),
              registersModel.clone(),
              fisrtAut.LabelOps.enumLetters(intersectedLabels).next
            )
          )
        case aut +: otherAuts => {
          val state +: otherStates = states
          val registers = aut.getRegisters
          for (
            (to, label, vec) <- aut.outgoingTransitionsWithVec(
              state
            );
            newILabel <- aut.LabelOps
              .intersectLabels(
                intersectedLabels,
                label
              ).toSeq;
            // if !(vec.zipWithIndex.forall { case (v, i) =>
            //   v == 0 || registersModel(registers(i)) < v
            // });
            (tailNext, updatedModel, char) <- enumNext(
              otherAuts,
              otherStates,
              registersModel ++ (for ((v, i) <- vec.zipWithIndex; if v > 0)
                yield (
                  registers(i),
                  registersModel(registers(i)) - v
                )).toMap, // update lengthModel
              newILabel
            )
          )
            yield (to +: tailNext, updatedModel, char)
        }
      }

    val initial = (auts map (_.initialState))

    if (isAccepting(auts, initial, registersValue))
      return Some(Seq())

    val visitedStates = new MHashSet[(Seq[State], MMap[Term, Int])]
    val todo = new ArrayStack[(Seq[State], MMap[Term, Int], Seq[Int])]

    visitedStates += ((initial, registersValue))
    todo push ((initial, registersValue, Seq()))

    while (!todo.isEmpty) {
      val (next, lengthModel, w) = todo.pop
      for (
        (reached, updatedModel, char) <-
          enumNext(
            auts,
            next,
            lengthModel,
            auts(0).LabelOps.sigmaLabel
          )
      ) {

        if (visitedStates.add((reached, updatedModel))) {
          val newW = w :+ char
          if (isAccepting(auts, reached, updatedModel))
            return Some(newW)
          todo push ((reached, updatedModel, newW))
        }
      }
    }
    None
  }

  /** Given transtion repeat times, check whether there is some word accepted by
    * all of the given automata. Note that this function heuristicly finds a
    * word. It is sound, but not complete.
    */
  def findAcceptedWordByTranstions(
      auts: Seq[CostEnrichedAutomatonTrait],
      transtionsModel: MMap[Term, IdealInt]
  ): Option[Seq[Int]] = {

    val transitionRepeatTimes = transtionsModel.map { case (t, i) =>
      (t, i.intValue)
    }
    val fisrtAut = auts(0)

    /** One step of intersection
      */
    def enumNext(
        auts: Seq[CostEnrichedAutomatonTrait],
        states: Seq[State],
        transitionModel: MMap[Term, Int],
        intersectedLabels: TLabel
    ): Iterator[(Seq[State], MMap[Term, Int], Int)] =
      auts match {
        case Seq() =>
          Iterator(
            (
              Seq(),
              transitionModel.clone(),
              fisrtAut.LabelOps.enumLetters(intersectedLabels).next
            )
          )
        case aut +: otherAuts => {
          val state +: otherStates = states
          for (
            (to, label, term) <- aut.outgoingTransitionsWithTerm(
              state
            );
            newILabel <- aut.LabelOps
              .intersectLabels(
                intersectedLabels,
                label
              )
              .toSeq;
            if (transitionModel(term) > 0);
            (tailNext, updatedModel, char) <- enumNext(
              otherAuts,
              otherStates,
              transitionModel + ((
                term,
                transitionModel(term) - 1
              )), // update lengthModel
              newILabel
            )
          )
            yield (to +: tailNext, updatedModel, char)
        }
      }

    val initial = (auts map (_.initialState))

    if (isAccepting(auts, initial, transitionRepeatTimes))
      return Some(Seq())

    val visitedStates = new MHashSet[(Seq[State], MMap[Term, Int])]
    val todo = new ArrayStack[(Seq[State], MMap[Term, Int], Seq[Int])]

    visitedStates += ((initial, transitionRepeatTimes))
    todo push ((initial, transitionRepeatTimes, Seq()))

    while (!todo.isEmpty) {
      val (next, lengthModel, w) = todo.pop
      for (
        (reached, updatedModel, char) <-
          enumNext(
            auts,
            next,
            lengthModel,
            auts(0).LabelOps.sigmaLabel
          )
      ) {

        if (visitedStates.add((reached, updatedModel))) {
          val newW = w :+ char
          if (isAccepting(auts, reached, updatedModel))
            return Some(newW)
          todo push ((reached, updatedModel, newW))
        }
      }
    }
    None
  }

  /** Given a sequence of automata and synchronized length, return a sequence of
    * automata that is equivalent to the given sequence of automata. And return
    * the map from state to its prefix string
    * @param auts
    *   the sequence of automata
    * @param synclen
    *   the length need to synchronize
    */
  def getSyncLenAuts(
      auts: Seq[CostEnrichedAutomatonTrait],
      labels: MTreeSet[TLabel],
      synclen: Int
  ): (Seq[CostEnrichedAutomatonTrait], MMap[State, Seq[TLabel]]) = {
    if (synclen <= 0) {
      return (auts, MMap())
    }
    val newState2Prefix = new MHashMap[State, Seq[TLabel]]
    val newAuts = auts.map { case aut =>
      val (newAut, map) = getSyncLenAut(aut, labels, synclen)
      newState2Prefix ++= map
      newAut
    }
    (newAuts, newState2Prefix)
  }

  /** Given an automaton and synchronized length, return an automaton that is
    * equivalent to the given automaton. And return the map from state to its
    * prefix string
    * @param aut
    *   the automaton
    * @param synclen
    *   the length need to synchronize
    */
  def getSyncLenAut(
      aut: CostEnrichedAutomatonTrait,
      labels: MTreeSet[TLabel],
      synclen: Int
  ): (CostEnrichedAutomatonTrait, MMap[State, Seq[TLabel]]) = {
    assert(synclen >= 1)
    // prefix len
    val prefixLen = synclen - 1
    // (old state, prefix string) pair
    val worklist = new ArrayStack[(State, Seq[TLabel])]
    val seenSet = new MHashSet[(State, Seq[TLabel])]
    // pair (old state, prefix string) to new state
    val oldStateWithPrefix2newState = new MHashMap[(State, Seq[TLabel]), State]
    // new state to prefix string
    val newState2Prefix = new MHashMap[State, Seq[TLabel]]
    val builder = aut.getBuilder.asInstanceOf[CostEnrichedAutomatonBuilder]

    val initialState = builder.getNewState
    builder.setInitialState(initialState)
    builder.setAccept(initialState, aut.isAccept(aut.initialState))

    worklist.push((aut.initialState, Seq()))
    oldStateWithPrefix2newState += ((aut.initialState, Seq()) -> initialState)
    newState2Prefix += (initialState -> Seq())

    while (!worklist.isEmpty) {
      val (oldStatePre, prefix) = worklist.pop
      if (seenSet.add((oldStatePre, prefix))) {
        val newStatePre = oldStateWithPrefix2newState((oldStatePre, prefix))
        for (
          (to, (lMin, lMax), vec) <- aut.outgoingTransitionsWithVec(oldStatePre)
        ) {
          val splitLabelIt = labels
            .from((lMin, Char.MinValue))
            .to((lMax, Char.MaxValue))
            .toIterable
          for (label <- splitLabelIt) {
            val newPrefix = (prefix :+ label).take(prefixLen)
            val newState = oldStateWithPrefix2newState.getOrElse(
              (to, newPrefix),
              builder.getNewState
            )
            builder.addTransition(newStatePre, label, newState, vec)
            builder.setAccept(newState, aut.isAccept(to))
            worklist.push((to, newPrefix))
            oldStateWithPrefix2newState += ((to, newPrefix) -> newState)
            newState2Prefix += (newState -> newPrefix)
          }
        }
      }
    }
    builder addNewIntFormula (aut.getRegsRelation)
    builder prependRegisters (aut.getRegisters)
    (builder.getAutomaton, newState2Prefix)
  }

  /** Given a sequence of automata, return a set of labels. The labels represent
    * all labels in `auts` and have min interval
    * @param auts
    *   the sequence of automata
    */
  def split2MinLabels(
      auts: Seq[CostEnrichedAutomatonTrait]
  ): MTreeSet[TLabel] = {
    val oldLabels = new MHashSet[TLabel]
    for (aut <- auts)
      for ((_, label, _) <- aut.transitions)
        oldLabels += label
    val splitedLabels = new MTreeSet[TLabel]
    new BricsTLabelEnumerator(oldLabels.iterator).enumDisjointLabels.foreach(
      splitedLabels += _
    )
    splitedLabels
  }

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
  def sync(
      auts: Seq[CostEnrichedAutomatonTrait],
      states2Prefix: MMap[State, Seq[TLabel]],
      labels: MTreeSet[TLabel],
      synclen: Int
  ): Formula = {
    if (synclen == 0) return Conjunction.TRUE
    var finalFormula = Conjunction.TRUE
    var strings: Seq[Traversable[TLabel]] = Seq()
    for (i <- 0 until synclen + 1)
      strings = strings ++: crossJoin(Seq.fill(i)(labels)).toSeq

    val commonStr2LTerm = strings.map { case str => (str, LabelTerm()) }.toMap
    for (aut <- auts) {
      val lTerm2Terms = new MHashMap[Term, MHashSet[Term]]
      for ((from, label, to, tTerm) <- aut.transitionsWithTerm) {
        val prefix = states2Prefix(from)
        val str = prefix :+ label
        val lTerm = commonStr2LTerm(str)
        // partition transition terms by transition label
        lTerm2Terms.getOrElseUpdate(lTerm, new MHashSet[Term]).add(tTerm)
      }
      // if the label does not appear in any transtion, the label count is 0
      commonStr2LTerm.values.filterNot(lTerm2Terms.contains).foreach { lTerm =>
        finalFormula = finalFormula & (lTerm === 0)
      }
      // label count is the sum of transition terms
      lTerm2Terms.foreach { case (lTerm, terms) =>
        finalFormula = finalFormula & (lTerm === terms
          .reduceOption(_ + _)
          .getOrElse(l(0))) & (lTerm >= 0)
      }
    }
    finalFormula
  }

  /** Compute cross join of a sequence of lists
    * @param list
    *   the list of list need to be cross joined
    */
  def crossJoin[T](
      list: Traversable[Traversable[T]]
  ): Traversable[Traversable[T]] =
    list match {
      case Nil       => Nil
      case xs :: Nil => xs map (Traversable(_))
      case x :: xs =>
        for {
          i <- x
          j <- crossJoin(xs)
        } yield Traversable(i) ++ j
    }

  def measure[A](op : String)(comp : => A) : A =
    if (Config.measureTime)
      ap.util.Timer.measure(op)(comp)
    else
      comp

}
