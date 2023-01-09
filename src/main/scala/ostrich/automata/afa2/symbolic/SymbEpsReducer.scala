package ostrich.automata.afa2.symbolic

import ostrich.OstrichStringTheory
import ostrich.automata.afa2.{AFA2PrintingUtils, EpsTransition, Left, Right, Step, StepTransition, SymbTransition, Transition}
import ostrich.automata.afa2.symbolic.SymbToConcTranslator.toSymbDisjointTrans

import scala.collection.immutable.Set
import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


/*
M stands for Macro(states), those structures are used for the powerset construction needed to get rid
of existential epsilon transitions.
 */

case class MState(states : Set[Int])

abstract class SymbMTransition(val targets: Set[MState])

// Those MEpsTransitions should be universal only!
case class SymbMEpsTransition(_targets: Set[MState]) extends SymbMTransition(_targets) {
  //assert(_targets.size!=1)
}

case class SymbMStepTransition(label: Range,
                               step: Step,
                               _targets: Set[MState]) extends SymbMTransition(_targets)


case class SymbMAFA2(initialState: MState,
                     allStates: Set[MState],
                     finalStates: Set[MState],
                     transitions: Map[MState, Seq[SymbMTransition]])


/*
Implements some manipulation and optimisation of various kind of 2afa. See methods for more info.
Terminology:
- AFA2 = Alternating 2 way automata WITHOUT epsilon transition and accepting always at the (right) end of a word (it reads word markers)
- EpsAFA2 = Alternating 2 way automata WITH epsilon transition and accepting always at the (right) end of a word (it reads word markers)
    In the following code it is utilised both with only universal eps transitions and with both univ. and exist. transitions.
- SymbExt2AFA = Alternating 2 way automata WITH epsilon transitions accepting both at the beginning and end of the word
    (it does not have word markings, but it has two kind of final states)
- SymbMAFA2, symbolic macrostate AFA2, it is needed to get rid of existential epsilon transitions with the usual powerset construction and eps-closure.
 */
class SymbEpsReducer(theory: OstrichStringTheory, extafa: SymbExtAFA2) {


  //val letters = extafa.letters
  //val maxLetter = if (extafa.letters.isEmpty) 0 else extafa.letters.max
  val maxState = extafa.states.max

  val beginMarker = theory.alphabetSize + 2
  val endMarker = theory.alphabetSize + 4

  var curMaxState = maxState

  def newState: Int = {
    curMaxState = curMaxState + 1
    curMaxState
  }

  /*
  Step 1: From symbExtAFA2 (accepting at beginning and end of string) to EpsAFA2 which accepts only
  at the end of the string. The word markers are introduced.
   */
  val epsafa: EpsAFA2 = symbExtAFA2ToEpsAFA2(extafa)
  AFA2PrintingUtils.printAutDotToFile(epsafa, "epsAFA2.dot")

  /*
  Step 2: Eliminate existential eps trans with powerset construction.
  From EpsAFA2 (with univ and exist transitions) to a symb macrostate 2AFA with only univ eps trans.
   */
  val mafa: SymbMAFA2 = epsAFA2ToSymbMAFA2(epsafa)
  //println("mafa2:\n" + mafa)

  /*
  Step 3: From symb macrostate 2AFA back to eps2AFA only with eps univ. transitions.
   */
  val epsafaReduced: EpsAFA2 = symbMAFA2ToEpsAFA2(mafa)
  AFA2PrintingUtils.printAutDotToFile(epsafaReduced, "epsAFA2-noExistEps.dot")

  /*
  Step 4: From Eps2AFA with only univ. eps. trans., to symbolic2AFA with no epsilon transitions.
  This is done by simulating an eps trans with a pair of forward and backward transitions
  reading any symbol (including word markers).
 */
  val afa: SymbAFA2 = epsAFA2ToSymbAFA2(epsafaReduced)
  AFA2PrintingUtils.printAutDotToFile(afa, "AFA2.dot")


  /*
  It translates a (symbolic) epsAFA2 (supposedly with only univ. eps transitions) into a symbolic AFA2,
  therefore with no epsilon transitions.
   */
  def epsAFA2ToSymbAFA2(epsafa: EpsAFA2): SymbAFA2 = {
    val epsBackwardsSteps = new ArrayBuffer[(Int, Int)]

    def rewrTransition(t: Transition): Seq[SymbTransition] =
      t match {
        case trans: SymbTransition =>
          List(trans)
        case EpsTransition(targets) =>
          val newTargets = for (_ <- targets) yield newState
          epsBackwardsSteps ++= newTargets zip targets
          Seq(
            SymbTransition(new Range(0, theory.alphabetSize, 1), Right, newTargets),
            SymbTransition(new Range(endMarker, endMarker + 1, 1), Right, newTargets)
          )
      }

    val newFlatPreTransitions: Seq[(Int, SymbTransition)] =
      for ((source, ts) <- epsafa.transitions.toList;
           trans <- ts;
           trans2 <- rewrTransition(trans))
      yield (source -> trans2)

    val extraTransitions: Seq[(Int, SymbTransition)] =
      (for ((source, target) <- epsBackwardsSteps) yield
        Seq(
          (source, SymbTransition(new Range(0, theory.alphabetSize, 1), Left, Seq(target))),
          (source, SymbTransition(new Range(endMarker, endMarker + 1, 1), Left, Seq(target)))
        )).flatten

    val newFlatTransitions = newFlatPreTransitions ++ extraTransitions

    val newTransitions =
      newFlatTransitions groupBy (_._1) mapValues { l => l map (_._2) }

    SymbAFA2(Seq(epsafa.initialState), epsafa.finalStates, newTransitions)
  }


  /*
   Transforms the symbolic ExtAFA2, which has the two kinds of accepting states into a (symbolic) epsAFA2 with epsilon transitions
   which accept only at the end of the word.
   */
  def symbExtAFA2ToEpsAFA2(extafa: SymbExtAFA2): EpsAFA2 = {

    val newInitialState = newState
    val newFinalEndState = newState
    val newFinalBeginState = newState

    val flatOldTrans: Seq[(Int, Transition)] = for ((st, ts) <- extafa.transitions.toSeq;
                                                    t <- ts) yield (st, t)

    val newFlatTransWEps = new ArrayBuffer[(Int, Transition)]() ++= flatOldTrans

    newFlatTransWEps ++= (
      for (s <- extafa.initialStates)
        yield (newInitialState -> SymbTransition(new Range(beginMarker, beginMarker + 1, 1), Right, Seq(s)))
      ) ++ (
      for (s <- extafa.finalRightStates)
        yield (s -> SymbTransition(new Range(endMarker, endMarker + 1, 1), Right, Seq(newFinalEndState)))
      ) ++ Seq(
      (newFinalBeginState -> SymbTransition(new Range(0, theory.alphabetSize, 1), Right, Seq(newFinalBeginState))),
      (newFinalBeginState -> SymbTransition(new Range(beginMarker, beginMarker + 1, 1), Right, Seq(newFinalBeginState))),
      (newFinalBeginState -> SymbTransition(new Range(endMarker, endMarker + 1, 1), Right, Seq(newFinalBeginState)))
    ) ++ (
      for (s <- extafa.finalLeftStates)
        yield (s -> SymbTransition(new Range(beginMarker, beginMarker + 1, 1), Left, Seq(newFinalBeginState)))
      )

    val transWEps = newFlatTransWEps.toList.groupBy (_._1) mapValues { l => l map (_._2) }

    EpsAFA2(newInitialState, Seq(newFinalEndState, newFinalBeginState), transWEps)
  }


  /*
It performs a powerset construction to get rid of the existential epsilon transitions. The result is therefore a
symbolic MacrostateAFA2, which has still universal epsilon transitions.
 */
  def epsAFA2ToSymbMAFA2(epsafa: EpsAFA2): SymbMAFA2 = {

    def partialEpsClosure(states: Set[Int]): Set[Int] = {

      def epsStepfunc(states: Set[Int]): Set[Int] = {
        val res = mutable.Set[Int]() ++= states
        for (s <- states;
             ts <- epsafa.transitions.get(s);
             t <- ts) t match {
          case et: EpsTransition => if (et.isExistential()) res ++= et.targets
          case _ =>
        }
        res.toSet
      }

      def iterate(oldSet: Set[Int]): Set[Int] = {
        val newSet = epsStepfunc(oldSet)
        if (newSet == oldSet) newSet
        else iterate(newSet)
      }

      iterate(states)
    }

    val initMState = MState(partialEpsClosure(Set(epsafa.initialState)))
    // Keeps track of macrostates already analysed. At the end of the while lopp will hold all the MStates
    val analysed = mutable.Set[MState]()
    val macroTrans = ArrayBuffer[(MState, SymbMTransition)]()
    val toAnalyse = mutable.Queue[MState](initMState)

    while (!toAnalyse.isEmpty) {
      val mst: MState = toAnalyse.dequeue()
      analysed += mst
      // All outgoing transitions from macrostate mst
      var outms = epsafa.transitions.filter(x => mst.states.contains(x._1))

      // filter out existential eps trans which have been already considered.
      outms = outms.mapValues(x => x.filter(y => y match {
        case et: EpsTransition => if (et.isExistential()) false else true
        case st: SymbTransition => true
        case concStep: StepTransition =>
          throw new RuntimeException(
            "Unexpected transition in epsilon elimination: " + concStep)
      }))

      // We do not need the starting states of those transitions anymore (as they are all in mst)
      val outTrans = outms.values.flatten
      val outTransEps: Seq[EpsTransition] = outTrans.filter(_.isInstanceOf[EpsTransition]).asInstanceOf[Seq[EpsTransition]]
      // Epsilon transitions should be universal
      assert(outTransEps.forall(_.targets.size != 1))
      val outTransStep: Seq[SymbTransition] = outTrans.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]

      // Add macro uni eps transitions
      val epsTargets: Seq[Seq[MState]] = for (t <- outTransEps) yield {
        for (s <- t.targets) yield MState(partialEpsClosure(Set(s)))
      }
      for (seqms <- epsTargets) {
        toAnalyse ++= (for (ms <- seqms; if !toAnalyse.contains(ms) && !analysed.contains(ms)) yield ms)
        macroTrans += ((mst, SymbMEpsTransition(seqms.toSet)))
      }

      // Add macro step transition functional
      macroTrans ++= (
        for (t <- outTransStep) yield
          (mst, SymbMStepTransition(t.symbLabel, t.step,
            (for (s <- t.targets) yield {
              val mtgt = MState(partialEpsClosure(Set(s)))
              if (!toAnalyse.contains(mtgt) && !analysed.contains(mtgt))
                toAnalyse += mtgt
              mtgt
            }).toSet)) )

    } // end while loop

    val finMStates = analysed.filter(x => x.states.intersect(epsafa.finalStates.toSet) != Set.empty)

    val mtransMap = macroTrans.groupBy(_._1).mapValues(l => l map (_._2))

    SymbMAFA2(initMState, analysed.toSet, finMStates.toSet, mtransMap)
  }


  /*
It transforms a MAFA2 with universal eps transitions back into an epsAFA2 which has only universal eps-transitions.
 */
  def symbMAFA2ToEpsAFA2(mafa: SymbMAFA2): EpsAFA2 = {
    val stMap: Map[MState, Int] = mafa.allStates.zipWithIndex.map { case (v, i) => (v, i) }.toMap
    val initState = stMap.get(mafa.initialState).get
    val finalStates = mafa.finalStates.map(stMap)
    val flatMafaTrans: Seq[(MState, SymbMTransition)] = for ((k, v) <- mafa.transitions.toList;
                                                             t <- v) yield (k, t)

    val flatTrans = for ((st, t) <- flatMafaTrans) yield t match {
      case et: SymbMEpsTransition => (stMap.get(st).get, EpsTransition(et._targets.map(stMap).toList))
      case str: SymbMStepTransition => (stMap.get(st).get, SymbTransition(str.label, str.step, str.targets.map(stMap).toList))
    }
    val trans = flatTrans.toList.groupBy(_._1).mapValues(l => l map (_._2))

    EpsAFA2(initState, finalStates.toSeq, trans)
  }



  def cartesianProduct[T](in: Seq[Seq[T]]): Seq[Seq[T]] = {
    @scala.annotation.tailrec
    def loop(acc: Seq[Seq[T]], rest: Seq[Seq[T]]): Seq[Seq[T]] = {
      rest match {
        case Nil =>
          acc
        case seq :: remainingSeqs =>
          // Equivalent of:
          // val next = seq.flatMap(i => acc.map(a => i+: a))
          val next = for {
            i <- seq
            a <- acc
          } yield i +: a
          loop(next, remainingSeqs)
      }
    }

    loop(Seq(Nil), in.reverse)
  }


}
