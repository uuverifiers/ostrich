package ostrich.automata.afa2

import ostrich.automata.afa2.AFA2.{EpsTransition, Step, StepTransition, Transition, goLeft, goRight}

import scala.collection.{Seq, mutable}
import scala.collection.mutable.ArrayBuffer

// Used for intermediate computations
case class EpsAFA2(initialState: Int,
                   finalStates: Seq[Int],
                   transitions: Map[Int, Seq[AFA2.Transition]]) {

  lazy val states = {
    val states = mutable.Set[Int](initialState)
    states ++= finalStates
    for ((s, ts) <- transitions;
         t <- ts) {
      states += s
      states ++= t.targets
    }
    states.toIndexedSeq.sorted
    states
  }
}


// Classes for the MacroStates for subset construction
case class MState(states : Set[Int])

abstract sealed class MTransition(val targets: Set[MState])

// Those MEpsTransitions should be universal only!
case class MEpsTransition(_targets: Set[MState]) extends MTransition(_targets) {
  assert(_targets.size!=1)
}

case class MStepTransition(label: Int,
                           step: Step,
                           _targets: Set[MState]) extends MTransition(_targets)

case class MAFA2(initialState: MState,
                 allStates: Set[MState],
                 finalStates: Set[MState],
                 transitions: Map[MState, Seq[MTransition]])

/*
Implements some manipulation and optimisation of various kind of 2afa. See methods for more info.
Terminology:
- AFA2 = Alternating 2 way automata WITHOUT epsilon transition and accepting always at the (right) end of a word (it reads word markers)
- EpsAFA2 = Alternating 2 way automata WITH epsilon transition and accepting always at the (right) end of a word (it reads word markers)
    In the following code it is utilised both with only universal eps transitions and with both univ. and exist. transitions.
- Ext2AFA = Alternating 2 way automata WITH epsilon transitions accepting both at the beginning and end of the word
    (it does not have word markings, but it has two kind of final states)
- MAFA2, macrostate AFA2, it is needed to get rid of existential epsilon transitions with the usual powerset construction and eps-closure.
 */
class EpsReducer(extafa : ExtAFA2) {

  val letters = extafa.letters
  val maxLetter = if (extafa.letters.isEmpty) 0 else extafa.letters.max
  val maxState = extafa.states.max

  val beginMarker = maxLetter + 2
  val endMarker = maxLetter + 4

  var curMaxState = maxState

  def newState: Int = {
    curMaxState = curMaxState + 1
    curMaxState
  }

  val epsafa: EpsAFA2 = extAFA2ToEpsAFA2(extafa)
  AFA2Utils.printAutDotToFile(epsafa, "epsAFA2.dot")

  val mafa: MAFA2 = epsAFA2ToMAFA2(epsafa)
  println("mafa2:\n" + mafa)

  val epsafaReduced: EpsAFA2 = MAFA2ToEpsAFA2(mafa)
  AFA2Utils.printAutDotToFile(epsafaReduced, "epsAFA2-noExistEps.dot")

  val afa: AFA2 = epsAFA2ToAFA2(epsafaReduced)
  AFA2Utils.printAutDotToFile(afa, "AFA2.dot")


  /*
  It translates an epsAFA2 (supposedly with only univ. eps transitions) into a AFA2
   */
  def epsAFA2ToAFA2(epsafa: EpsAFA2) : AFA2 = {
    val epsBackwardsSteps = new ArrayBuffer[(Int, Int)]

    def rewrTransition(t: Transition): Seq[StepTransition] =
      t match {
        case trans: StepTransition =>
          List(trans)
        case EpsTransition(targets) => {
          val newTargets = for (_ <- targets) yield newState
          epsBackwardsSteps ++= newTargets zip targets
          for (l <- letters ++ List(endMarker))
            yield goRight(l, newTargets: _*)
        }
      }

    val newFlatPreTransitions: Seq[(Int, StepTransition)] =
      for ((source, ts) <- epsafa.transitions.toList;
           trans <- ts;
           trans2 <- rewrTransition(trans))
      yield (source -> trans2)

    val extraTransitions: Seq[(Int, StepTransition)] =
      for ((source, target) <- epsBackwardsSteps;
           l <- letters ++ List(endMarker))
      yield (source -> goLeft(l, target))

    val newFlatTransitions = newFlatPreTransitions ++ extraTransitions

    val newTransitions =
      newFlatTransitions groupBy (_._1) mapValues { l => l map (_._2) }

      AFA2(Seq(epsafa.initialState), epsafa.finalStates, newTransitions)
  }

  /*
   Transforms the ExtAFA2, which has the two kinds of accepting states into an epsAFA2 with epsilon transitions
   which accept only at the end of the word.
   */
  def extAFA2ToEpsAFA2(extafa: ExtAFA2) : EpsAFA2 = {

    val newInitialState = newState
    val newFinalEndState = newState
    val newFinalBeginState = newState

    val flatOldTrans : Seq[(Int, Transition)] = for ((st, ts) <- extafa.transitions.toSeq;
                                                     t <- ts) yield (st, t)

    val newFlatTransWEps = new ArrayBuffer[(Int, Transition)]() ++= flatOldTrans

    newFlatTransWEps ++= (
      for (s <- extafa.initialStates)
        yield (newInitialState -> goRight(beginMarker, s))
      ) ++ (
      for (s <- extafa.finalRightStates)
        yield (s -> goRight(endMarker, newFinalEndState))
      ) ++ (
      for (l <- extafa.letters ++ List(beginMarker, endMarker))
        yield (newFinalBeginState -> goRight(l, newFinalBeginState))
      ) ++ (
      for (s <- extafa.finalLeftStates)
        yield (s -> goLeft(beginMarker, newFinalBeginState))
      )

    val transWEps = newFlatTransWEps groupBy (_._1) mapValues { l => l map (_._2) }

    EpsAFA2(newInitialState, Seq(newFinalEndState, newFinalBeginState), transWEps)
  }

/*
It performs a powerset construction to get rid of the existential epsilon transitions. The result is therefore a
MacrostateAFA2, which has still universal epsilon transitions.
 */
  def epsAFA2ToMAFA2(epsafa : EpsAFA2) = {

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
    val macroTrans = ArrayBuffer[(MState, MTransition)]()
    val toAnalyse = mutable.Queue[MState](initMState)

    while (!toAnalyse.isEmpty) {
      val mst: MState = toAnalyse.dequeue()
      analysed += mst
      // All outgoing transitions from macrostate mst
      var outms = epsafa.transitions.filter(x => mst.states.contains(x._1))

      // filter out existential eps trans which have been already considered.
      outms = outms.mapValues(x => x.filter(y => y match {
        case et: EpsTransition => if (et.isExistential()) false else true
        case st: StepTransition => true
      }))

      // We do not need the starting states of those transitions anymore (as they are all in mst)
      var outTrans = outms.values.flatten
      var outTransEps: Seq[EpsTransition] = outTrans.filter(_.isInstanceOf[EpsTransition]).asInstanceOf[Seq[EpsTransition]]
      // Epsilon transitions should be universal
      assert(outTransEps.forall(_.targets.size!=1))
      var outTransStep: Seq[StepTransition] = outTrans.filter(_.isInstanceOf[StepTransition]).asInstanceOf[Seq[StepTransition]]

      // Add macro uni eps transitions
      val epsTargets: Seq[Seq[MState]] = for (t <- outTransEps) yield {
                                              for (s <- t.targets) yield MState(partialEpsClosure(Set(s)))
                                              }
      for (seqms <- epsTargets) {
        toAnalyse ++= (for (ms <- seqms; if !toAnalyse.contains(ms) && !analysed.contains(ms)) yield ms)
        macroTrans += ((mst, MEpsTransition(seqms.toSet)))
      }

      // Add macro step transitions. WARNING: those should be only existential step transitions!
      val groupOutTransStep = outTransStep.groupBy(x => (x.label, x.step))
      assert(groupOutTransStep.values.forall(_.forall(_.targets.size==1)))

      val flatGroupOutTransStep = groupOutTransStep.mapValues(x => x flatMap (_.targets))

      for ((k, v) <- flatGroupOutTransStep) {
        val trgt = MState(partialEpsClosure(v.toSet))
        if (!toAnalyse.contains(trgt) && !analysed.contains(trgt))
          toAnalyse += trgt
        macroTrans += ((mst, MStepTransition(k._1, k._2, Set(trgt))))
      }
    } // end while loop

    val finMStates = analysed.filter(x => x.states.intersect(epsafa.finalStates.toSet)!=Set.empty)

    val mtransMap = macroTrans.groupBy(_._1).mapValues(l => l map (_._2))

    MAFA2(initMState, analysed.toSet, finMStates.toSet, mtransMap)
  }


  // Merges states that have the same outgoing transitions if they are all final or non-final
  def approxMinimizer(epsafa: EpsAFA2): EpsAFA2 = ??? /*{

    // reverse transition map
    val revTrans = mutable.Map[Seq[Transition], Set[Int]]()
      for ((s, ts) <- epsafa.transitions) {
        if (revTrans.contains(ts)) {
          val newVal = revTrans.get(ts).get += s
          revTrans += (ts, newVal)
        } else revTrans += (ts, Set(s))
      }

    val newFlatTrans = ArrayBuffer[(Int, Transition)]()
    val aux: Map[(Seq[Transition], Set[Int]), Int] = revTrans.zipWithIndex.map{case (v, i) => (v, i)}.toMap
    val oldNewMap = mutable.Map[Int, Int]()
    for((k, v) <- aux; s <- k._2)
      oldNewMap += (s, v)

    // TODO: Two things are missing: 1) add states with no outgoing transitions: 2) split set of states with final and nonfinal states.
    val sink = epsafa.states -- (for((_, v) <- revTrans) yield v).flatten


    for ((ts, ss) <- revTrans;
         t <- ts) {
      // add outgoing transitions to newState
      newFlatTrans += ( (aux.get((ts,ss)).get, t match {
        case EpsTransition(tgs) => EpsTransition(tgs.map(oldNewMap))
        case StepTransition(lab, step, tgs) => StepTransition(lab, step, tgs.map(oldNewMap))
      } ))
    }

    }*/


/*
It transforms a MAFA2 with universal eps transitions back into a epsAFA2 which has only universal eps-transitions.
 */
  def MAFA2ToEpsAFA2(mafa: MAFA2): EpsAFA2 = {
    val stMap : Map[MState, Int] = mafa.allStates.zipWithIndex.map{case (v, i) => (v, i)}.toMap
    val initState = stMap.get(mafa.initialState).get
    val finalStates = mafa.finalStates.map(stMap)
    val flatMafaTrans : Seq[(MState, MTransition)] = for ((k, v) <- mafa.transitions.toSeq;
                                                         t <- v) yield (k, t)

    println(flatMafaTrans)
    val flatTrans = for ((st, t) <- flatMafaTrans) yield t match {
      case et:MEpsTransition => (stMap.get(st).get, EpsTransition(et._targets.map(stMap).toSeq))
      case str:MStepTransition => (stMap.get(st).get, StepTransition(str.label, str.step, str.targets.map(stMap).toSeq))
    }
    val trans = flatTrans.groupBy(_._1).mapValues(l => l map (_._2))

    EpsAFA2(initState, finalStates.toSeq, trans)
  }

}
