package ostrich.automata.afa2.symbolic

import ostrich.OstrichStringTheory
import ostrich.automata.afa2.{AFA2Utils, EpsTransition, Left, Right, Step, StepTransition, SymbTransition, Transition}
import ostrich.automata.afa2.concrete.{EpsAFA2, MState}
import ostrich.automata.afa2.symbolic.SymbToConcTranslator.toSymbDisjointTrans

import scala.collection.immutable.Set
import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


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

  val epsafa: EpsAFA2 = symbExtAFA2ToEpsAFA2(extafa)
  AFA2Utils.printAutDotToFile(epsafa, "epsAFA2.dot")

  val mafa: SymbMAFA2 = epsAFA2ToSymbMAFA2(epsafa)
  //println("mafa2:\n" + mafa)

  val epsafaReduced: EpsAFA2 = symbMAFA2ToEpsAFA2(mafa)
  AFA2Utils.printAutDotToFile(epsafaReduced, "epsAFA2-noExistEps.dot")


  //Getting rid of universal eps transitions
  //val mafa2: SymbMAFA2 = universalEpsAFA2ToSymbMAFA2(epsafaReduced)
  //val epsafaReduced2: EpsAFA2 = symbMAFA2ToEpsAFA2(mafa2)
  //AFA2Utils.printAutDotToFile(epsafaReduced2, "epsAFA2-noUniOrExistEps.dot")

  val afa: SymbAFA2 = epsAFA2ToSymbAFA2(epsafaReduced)
  AFA2Utils.printAutDotToFile(afa, "AFA2.dot")


  /*
  It translates an epsAFA2 (supposedly with only univ. eps transitions) into a AFA2
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
   Transforms the ExtAFA2, which has the two kinds of accepting states into an epsAFA2 with epsilon transitions
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
MacrostateAFA2, which has still universal epsilon transitions.
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
        case concStep: StepTransition => throw new RuntimeException("This should not happen!")
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

      // Add macro step declarative
      /*for (t <- outTransStep) {
        val macroTargets = ArrayBuffer[MState]()
        for (s <- t.targets)
          macroTargets += MState(partialEpsClosure(Set(s)))
        macroTrans += ((mst, SymbMStepTransition(t.symbLabel, t.step, macroTargets.toSet)))
      }*/

      /* THIS IS WRONG
      // Add macro step transitions. WARNING: those should be only existential step transitions!
      val groupOutTransStep = outTransStep.groupBy(x => (x.symbLabel, x.step))
      assert(groupOutTransStep.values.forall(_.forall(_.targets.size == 1)))

      val flatGroupOutTransStep = groupOutTransStep.mapValues(x => x flatMap (_.targets))

      for ((k, v) <- flatGroupOutTransStep) {
        val trgt = MState(partialEpsClosure(v.toSet))
        if (!toAnalyse.contains(trgt) && !analysed.contains(trgt))
          toAnalyse += trgt
        macroTrans += ((mst, SymbMStepTransition(k._1, k._2, Set(trgt))))
      } */

    } // end while loop

    val finMStates = analysed.filter(x => x.states.intersect(epsafa.finalStates.toSet) != Set.empty)

    val mtransMap = macroTrans.groupBy(_._1).mapValues(l => l map (_._2))

    SymbMAFA2(initMState, analysed.toSet, finMStates.toSet, mtransMap)
  }


  /*
It transforms a MAFA2 with universal eps transitions back into a epsAFA2 which has only universal eps-transitions.
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


  /*
It performs a powerset construction to get rid of the universal epsilon transitions.
The problem is that since it's two way, we cannot univ-eps-close macro states which include
both left and right transitions.
The result is therefore a MacrostateAFA2, which has still some universal epsilon transitions.
 */
  def universalEpsAFA2ToSymbMAFA2(epsafa: EpsAFA2): SymbMAFA2 = {

    ///////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////
    /* ************** OLD *********************
    def partialUniversalEpsClosure(states: Set[Int]): Set[Int] = {

      def universalEpsStepfunc(states: Set[Int]): Set[Int] = {
        val res = mutable.Set[Int]() ++= states
        for (s <- states;
             ts <- epsafa.transitions.get(s);
             t <- ts) t match {
          case et: EpsTransition => if (!et.isExistential()) res ++= et.targets
          case _ =>
        }
        res.toSet
      }

      def iterate(oldSet: Set[Int]): Set[Int] = {
        val newSet = universalEpsStepfunc(oldSet)
        if (newSet == oldSet) newSet
        else iterate(newSet)
      }

      iterate(states)
    }
    *************************************************/


    def partialUniversalEpsClosure(states: Seq[Set[Int]]): Seq[Set[Int]] = {

      def universalEpsStepfunc(setStates: Seq[Set[Int]]): Seq[Set[Int]] = {
        val outRes = mutable.Set[Set[Int]]()

        for (set <- setStates) {
          val cartProdList = ArrayBuffer[List[Set[Int]]]()
          for (s <- set) {
            val sClosure = ArrayBuffer[Set[Int]]()

            for (ts <- epsafa.transitions.get(s);
                 t <- ts) t match {
              case et: EpsTransition => if (!et.isExistential()) sClosure += et.targets.toSet
              case _ =>
            }
            cartProdList += sClosure.toList
          }

          // Do the cartesian product of sets in cartProdList
          val aux = cartesianProduct(cartProdList.toList)
          val cp = ArrayBuffer[Set[Int]]()
          for (outmost <- aux) {
            val acc = mutable.Set[Int]()
            for (inner <- outmost) {
              for (s <- inner) acc += s
            }
            cp += acc.toSet
          }
          // Add all cartesian products to outRes
          outRes ++= cp
        }
        outRes.toList
      }

      def iterate(oldSet: Seq[Set[Int]]): Seq[Set[Int]] = {
        val newSet = universalEpsStepfunc(oldSet)
        if (newSet == oldSet) newSet
        else iterate(newSet)
      }

      iterate(states)
    }

    /*
    Categorises states according to outgoing transitions
    (LeftStates, RightStates, LeftAndRightStates, SinkStates) (L, R, LR, S)
     */
    def categoriseStates(states: Set[Int]): Seq[MState] = {
      // First, get rid of states that only have outgoing univ eps trans.
      val filteredSts = states.filterNot(x => epsafa.transitions.get(x) match {
        case Some(ts) => ts.forall(_.isInstanceOf[EpsTransition])
        case None => false
      })
      println("CatSet:\n"+states)
      println("FilteredCatSet:\n"+filteredSts)

      val L = filteredSts.filter(x => epsafa.transitions.get(x) match {
        case Some(ts) =>
          val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
          outNotEps.forall(_.step == Left)
        case None => false
      })

      val R = filteredSts.filter(x => epsafa.transitions.get(x) match {
        case Some(ts) =>
          val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
          outNotEps.forall(_.step == Right)
        case None => false
      })

      val LR = filteredSts.filter(x => epsafa.transitions.get(x) match {
        case Some(ts) =>
          val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
          outNotEps.exists(_.step == Left) && outNotEps.exists(_.step == Right)
        case None => false
      })

      val sink = filteredSts.filter(x => epsafa.transitions.get(x) match {
        case Some(ts) =>
          val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
          outNotEps.isEmpty
        case None => true
      })

      val res = ArrayBuffer[MState]()
      if (R.nonEmpty) res+=MState(R)
      if (L.nonEmpty) res+=MState(L)
      for (s <- LR) res += MState(Set(s))
      if (sink.nonEmpty) res += MState(sink)

      res.toList
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
    ///////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////

    // Keeps track of macrostates already analysed. At the end of the while loop will hold all the MStates
    val analysed = mutable.Set[MState]()
    val macroTrans = ArrayBuffer[(MState, SymbMTransition)]()
    val toAnalyse = mutable.Queue[MState]()



    /*

      /*
    **************** Handling initial state ******************************
     */
    val initClosure = partialUniversalEpsClosure(Set(epsafa.initialState))
    // First, get rid of states that only have outgoing univ eps trans.
    val filteredSts = initClosure.filterNot(x => epsafa.transitions.get(x) match {
      case Some(ts) => ts.forall(_.isInstanceOf[EpsTransition])
      case None => false
    })
    val L = filteredSts.filter(x => epsafa.transitions.get(x) match {
      case Some(ts) =>
        val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
        outNotEps.forall(_.step == Left)
      case None => false
    })

    val R = filteredSts.filter(x => epsafa.transitions.get(x) match {
      case Some(ts) =>
        val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
        outNotEps.forall(_.step == Right)
      case None => false
    })

    val LR = filteredSts.filter(x => epsafa.transitions.get(x) match {
      case Some(ts) =>
        val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
        outNotEps.exists(_.step == Left) && outNotEps.exists(_.step == Right)
      case None => false
    })

    val sink = filteredSts.filter(x => epsafa.transitions.get(x) match {
      case Some(ts) =>
        val outNotEps = ts.filter(_.isInstanceOf[SymbTransition]).asInstanceOf[Seq[SymbTransition]]
        outNotEps.isEmpty
      case None => true
    })

    val newInit: MState =
      if (L.nonEmpty && R.isEmpty && LR.isEmpty && sink.isEmpty) {
        toAnalyse += MState(L)
        MState(L)
      } else if (L.isEmpty && R.nonEmpty && LR.isEmpty && sink.isEmpty) {
        toAnalyse += MState(R)
        MState(R)
      } else {
        val Minit = MState(Set(epsafa.initialState))
        epsafa.transitions.get(epsafa.initialState) match {
          case Some(ts) =>
            if (ts.exists(_.isInstanceOf[EpsTransition])) {
              for (t <- ts; if t.isInstanceOf[EpsTransition]) {
                val catTargets = categoriseStates(partialUniversalEpsClosure(t.targets.toSet))
                macroTrans += ((Minit, SymbMEpsTransition(catTargets.toSet)))
                toAnalyse ++= catTargets
              }
            } else {
              toAnalyse += Minit
            }
          case None => toAnalyse += Minit
        }
        Minit
      }

    /*
    **********************************************************************
    */

     */

    // TODO: temporary!!!
    val newInit = MState(Set(epsafa.initialState))
    toAnalyse+=newInit


    while (!toAnalyse.isEmpty) {
      val mst: MState = toAnalyse.dequeue()
      analysed += mst
      println("mst:\n"+mst)

      /* Select outgoing transitions from macrostate mst which are
        common to every state in mst! (We are considering universal macrostates)
       */

      var preOutms: Map[Int, Seq[Transition]] = epsafa.transitions.filter(x => mst.states.contains(x._1))
      println("preOutms1:\n"+preOutms)

      // filter out universal eps trans which have been already considered.
      preOutms = preOutms.mapValues(x => x.filter(y => y match {
        case et: EpsTransition => if (!et.isExistential()) false else true
        case st: SymbTransition => true
        case concStep: StepTransition => throw new RuntimeException("This should not happen!")
      }))
      println("preOutms2:\n"+preOutms)

      //Double check only symb step transitions!
      assert(preOutms.forall(x => x._2.forall(_.isInstanceOf[SymbTransition])))

      preOutms = toSymbDisjointTrans(preOutms)
      println("preOutms3:\n"+preOutms)

      /*var outms: Seq[(Int, SymbTransition)] = {
        for ((st1, trs1) <- preOutms.toList;
             tr <- trs1;
             if preOutms.forall { case (st2, trs2) =>
               trs2.exists(x => x.asInstanceOf[SymbTransition].step == tr.asInstanceOf[SymbTransition].step &&
                 x.asInstanceOf[SymbTransition].symbLabel == tr.asInstanceOf[SymbTransition].symbLabel)
             })
        yield (st1, tr.asInstanceOf[SymbTransition])
      }*/
      var outms: Seq[(Int, SymbTransition)] = {
        for ((st1, trs1) <- preOutms.toList;
             tr <- trs1;
             if mst.states.forall{x =>
               preOutms.exists{case (k, v) => k==x &
                 v.exists(t => t.asInstanceOf[SymbTransition].step == tr.asInstanceOf[SymbTransition].step &&
                 t.asInstanceOf[SymbTransition].symbLabel == tr.asInstanceOf[SymbTransition].symbLabel)}
             })
        yield (st1, tr.asInstanceOf[SymbTransition])
      }
      println("Outms:\n"+outms)

      // All the symbolic step transitions are existential!
      assert(outms.forall(_._2._targets.size == 1))
      // All are in the same direction
      if (mst.states.size > 1)
        assert(outms.forall(x => x._2.step == Left) || outms.forall(x => x._2.step == Right))

      val aux: Map[(Int, Range, Step), Seq[Int]] =
        outms.groupBy { case (st, t) => (st, t.symbLabel, t.step) }.mapValues(x =>
          (for ((st, t) <- x) yield t._targets).flatten)
      println("Aux:\n"+aux)

      /* For each symb label, each set in the sequence is the (existential)
         targets from each state.
         Example. For label "a" from s1 -> {s5}, s1 -> {s6}, s2 -> {s7}, then:
         ("a", ({s5, s6}, {s7}))
       */
      val targetsMap: Map[(Range, Step), Seq[Seq[Int]]] =
        aux.toList.groupBy(x => (x._1._2, x._1._3)).mapValues(x => for (y <- x) yield y._2)
      println("targetsMap:\n"+targetsMap)

      /*
      For each label, we have to consider all possible combination of outgoing
      states. For the previous example, from macrostate mst which contains s1 and s2
      we have for label "a": mst -> {s5, s7}, mst -> {s6, s7}
       */
      // TODO: debug!
      for( ((rg, st), sts) <- targetsMap ) {
        val cptargets = cartesianProduct(sts)
        println("CartesianProduct:\n" + cptargets)
        for (targets <- cptargets) {
          println("Targets:\n"+targets)
          val clos = partialUniversalEpsClosure(Seq(targets.toSet))
          println("UnivClosure\n:"+clos)
        }
      }


      for (((rg, st), sts) <- targetsMap;
           targets <- cartesianProduct(sts);
           closureTrgts <- partialUniversalEpsClosure(Seq(targets.toSet))) {

        val tgClosure: Seq[MState] = categoriseStates(closureTrgts)
        println("tgClosure:\n"+tgClosure)

        macroTrans += ((mst, SymbMStepTransition(rg, st, tgClosure.toSet)))
        println("MacroTrans:\n" + macroTrans)

        for (ms <- tgClosure)
          if (!analysed.contains(ms) && !toAnalyse.contains(ms)) toAnalyse += ms

      }
    }

    // Universal eps removal case
    val finMStates = analysed.filter(x => x.states.forall(y => epsafa.finalStates.toSet.contains(y)))

    val mtransMap = macroTrans.groupBy(_._1).mapValues(l => l map (_._2))

    SymbMAFA2(newInit, analysed.toSet, finMStates.toSet, mtransMap)

  }


}