package ostrich.automata.afa2.symbolic

import ostrich.automata.afa2.concrete.BState
import ostrich.automata.afa2.{EpsTransition, Left, Right, Step, SymbTransition}

abstract sealed class SymbBTransition(val targets: Seq[BState])
import ostrich.OstrichStringTheory
import ostrich.automata.afa2.concrete.{AFA2, BState}
import ostrich.automata.afa2.AFA2Utils

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer

case class SymbBEpsTransition(_targets: Seq[BState]) extends SymbBTransition(_targets) {
  def isUniversal(): Boolean = targets.size > 1

  def isExistential(): Boolean = targets.size == 1
}

case class SymbBStepTransition(label: Range,
                               step: Step,
                               _targets: Seq[BState]) extends SymbBTransition(_targets)

class SymbAFA2Builder(theory: OstrichStringTheory) {
  val alphabet_size = theory.alphabetSize
  val max_char = theory.upperBound
  val min_char = 0

  // From the parser!!!
  val decimal = Range(48, 58)
  val uppCaseChars = Range(65, 91)
  val lowCaseChars = Range(97, 123)
  val underscore = Range(95, 96)



  def charrangeAtomic2AFA(dir: Step, range: Range): SymbMutableAFA2 = {
    val iniState = new BState(dir)
    val finState = new BState(dir)

    val trans: ArrayBuffer[(BState, SymbBTransition)] =
      ArrayBuffer[(BState, SymbBTransition)]() += ((iniState, SymbBStepTransition(range, dir, Seq(finState))))

    SymbMutableAFA2(this, iniState, finState, mutable.Set[BState](), trans)
  }

  def allcharAtomic2AFA(dir: Step): SymbMutableAFA2 = {
    val iniState = new BState(dir)
    val finState = new BState(dir)
    val allCharrange = new Range(min_char, alphabet_size, 1)

    val trans: ArrayBuffer[(BState, SymbBTransition)] =
      ArrayBuffer[(BState, SymbBTransition)]() += ((iniState, SymbBStepTransition(allCharrange, dir, Seq(finState))))

    SymbMutableAFA2(this, iniState, finState, mutable.Set[BState](), trans)
  }


  def allAtomic2AFA(dir: Step): SymbMutableAFA2 = {
    val res = allcharAtomic2AFA(dir)
    res.transitions += ((res.initialState, SymbBEpsTransition(Seq(res.mainFinState))))
    res
  }

  // Matches exactly num occurrences of aut
  def loop1Aut2AFA(dir: Step, num: Int, aut: SymbMutableAFA2): SymbMutableAFA2 = {
    num match {
      // According to the semantics, this accepts the epsilon word
      case 0 => epsAtomic2AFA(dir)

      case n =>
        val autArray: Seq[SymbMutableAFA2] = for (i <- 1 to n) yield aut.clone()
        autArray.reduce((l, r) => concat2AFA(dir, l, r))
    }
  }

  // Matches whatever n  in {min to max} iterations of aut. Obtained as alternation of each n
  def loop3Aut2AFA(dir: Step, min: Int, max: Int, aut: SymbMutableAFA2): SymbMutableAFA2 = {
    val autArray: Seq[SymbMutableAFA2] = for (i <- min to max) yield loop1Aut2AFA(dir, i, aut)
    autArray.reduce((l, r) => alternation2AFA(dir, l, r))
  }


  def epsAtomic2AFA(dir: Step): SymbMutableAFA2 = {
    val iniState = new BState(dir)
    val finState = new BState(dir)
    val trans = SymbBEpsTransition(Seq(finState))

    SymbMutableAFA2(this, iniState, finState, mutable.Set[BState](), ArrayBuffer[(BState, SymbBTransition)]((iniState, trans)))
  }


  def emptyAtomic2AFA(dir: Step): SymbMutableAFA2 = {
    val iniState = new BState(dir)
    val finState = new BState(dir)

    SymbMutableAFA2(this, iniState, finState, mutable.Set[BState](), ArrayBuffer[(BState, SymbBTransition)]())
  }


  def star2AFA(dir: Step, aut: SymbMutableAFA2): SymbMutableAFA2 = {
    val newInitial = new BState(dir)
    val newFinal = new BState(dir)

    // Add inner eps loop
    aut.transitions += ((aut.mainFinState, SymbBEpsTransition(Seq(aut.initialState))))

    // Add initial eps transition
    aut.transitions += ((newInitial, SymbBEpsTransition(Seq(aut.initialState))))

    // Add final eps transition
    aut.transitions += ((aut.mainFinState, SymbBEpsTransition(Seq(newFinal))))

    // Add outer eps loop
    aut.transitions += ((newInitial, SymbBEpsTransition(Seq(newFinal))))

    // Change initial and final states
    aut.initialState = newInitial
    aut.mainFinState = newFinal

    return aut
  }


  // laut is modified and returned
  def concat2AFA(dir: Step, laut: SymbMutableAFA2, raut: SymbMutableAFA2): SymbMutableAFA2 = {
    // New final state. Notice the dir is the same of raut
    val newFinal = raut.mainFinState

    // Add eps trans connecting laut and raut
    laut.transitions += ((laut.mainFinState, SymbBEpsTransition(Seq(raut.initialState))))

    // Change final state
    laut.mainFinState = newFinal

    // Add all secondary final states of raut to laut
    laut.finStates ++= raut.finStates

    // Add all raut transitions to laut
    laut.transitions ++= raut.transitions

    return laut
  }


  // laut is modified and returned
  def alternation2AFA(dir: Step, laut: SymbMutableAFA2, raut: SymbMutableAFA2): SymbMutableAFA2 = {
    // New initial and final state
    val newFinal = new BState(dir)
    val newInit = new BState(dir)

    // Add initial transitions
    laut.transitions += ((newInit, SymbBEpsTransition(Seq(laut.initialState))))
    laut.transitions += ((newInit, SymbBEpsTransition(Seq(raut.initialState))))

    // Add final transition
    laut.transitions += ((laut.mainFinState, SymbBEpsTransition(Seq(newFinal))))
    laut.transitions += ((raut.mainFinState, SymbBEpsTransition(Seq(newFinal))))

    // Change initial and final states
    laut.initialState = newInit
    laut.mainFinState = newFinal

    // Add all secondary final states of raut to laut
    laut.finStates ++= raut.finStates

    // Copy raut transitions
    laut.transitions ++= raut.transitions

    return laut
  }

  def wordBoundary2AFA(dir: Step): SymbMutableAFA2 = {
    val init = new BState(dir)
    val trans = ArrayBuffer[(BState, SymbBTransition)]()
    var nonWordChar: Set[Range] = AFA2Utils.rangeDiff(Set(Range(min_char, alphabet_size)), decimal)
    nonWordChar = AFA2Utils.rangeDiff(nonWordChar, uppCaseChars)
    nonWordChar = AFA2Utils.rangeDiff(nonWordChar, lowCaseChars)
    nonWordChar = AFA2Utils.rangeDiff(nonWordChar, underscore)

    // First part: checking if a new word is starting
    val s1 = new BState(Right)
    trans += ((init, SymbBEpsTransition(Seq(s1))))

    val s2 = new BState(Left)
    trans += ((s1, SymbBStepTransition(decimal, Right, Seq(s2))))
    trans += ((s1, SymbBStepTransition(uppCaseChars, Right, Seq(s2))))
    trans += ((s1, SymbBStepTransition(lowCaseChars, Right, Seq(s2))))
    trans += ((s1, SymbBStepTransition(underscore, Right, Seq(s2))))

    val mainFinal = new BState(dir)
    val s3 = new BState(Left)
    trans += ((s2, SymbBStepTransition(Range(min_char, alphabet_size), Left, Seq(mainFinal, s3))))

    val f1 = new BState(dir)
    trans ++= (for (rg <- nonWordChar) yield (s3, SymbBStepTransition(rg, Left, Seq(f1))))

    trans += ((f1, SymbBStepTransition(Range(min_char, alphabet_size), dir, Seq(f1))))


    // Second part: checking if a word is ending
    val s4 = new BState(Right)
    trans += ((init, SymbBEpsTransition(Seq(s4))))

    val s5 = new BState(Left)
    trans ++= (for (rg <- nonWordChar) yield (s4, SymbBStepTransition(rg, Right, Seq(s5))))

    val s6 = new BState(Left)
    trans += ((s5, SymbBStepTransition(Range(min_char, alphabet_size), Left, Seq(mainFinal, s6))))

    val f2 = new BState(dir)
    trans += ((s6, SymbBStepTransition(decimal, Left, Seq(f2))))
    trans += ((s6, SymbBStepTransition(uppCaseChars, Left, Seq(f2))))
    trans += ((s6, SymbBStepTransition(lowCaseChars, Left, Seq(f2))))
    trans += ((s6, SymbBStepTransition(underscore, Left, Seq(f2))))

    trans += ((f2, SymbBStepTransition(Range(min_char, alphabet_size), dir, Seq(f2))))

    SymbMutableAFA2(this, init, mainFinal, mutable.Set(f1, f2), trans)
  }


  def nonWordBoundary2AFA(dir: Step): SymbMutableAFA2 = {
    val init = new BState(dir)
    val trans = ArrayBuffer[(BState, SymbBTransition)]()
    var nonWordChar: Set[Range] = AFA2Utils.rangeDiff(Set(Range(min_char, alphabet_size)), decimal)
    nonWordChar = AFA2Utils.rangeDiff(nonWordChar, uppCaseChars)
    nonWordChar = AFA2Utils.rangeDiff(nonWordChar, lowCaseChars)
    nonWordChar = AFA2Utils.rangeDiff(nonWordChar, underscore)

    // First part: checking if a new word is starting
    val s1 = new BState(Right)
    trans += ((init, SymbBEpsTransition(Seq(s1))))

    val s2 = new BState(Left)
    trans += ((s1, SymbBStepTransition(decimal, Right, Seq(s2))))
    trans += ((s1, SymbBStepTransition(uppCaseChars, Right, Seq(s2))))
    trans += ((s1, SymbBStepTransition(lowCaseChars, Right, Seq(s2))))
    trans += ((s1, SymbBStepTransition(underscore, Right, Seq(s2))))

    val mainFinal = new BState(dir)
    val s3 = new BState(Left)
    trans += ((s2, SymbBStepTransition(Range(min_char, alphabet_size), Left, Seq(mainFinal, s3))))

    val f1 = new BState(dir)
    trans += ((s3, SymbBStepTransition(decimal, Left, Seq(f1))))
    trans += ((s3, SymbBStepTransition(uppCaseChars, Left, Seq(f1))))
    trans += ((s3, SymbBStepTransition(lowCaseChars, Left, Seq(f1))))
    trans += ((s3, SymbBStepTransition(underscore, Left, Seq(f1))))

    trans += ((f1, SymbBStepTransition(Range(min_char, alphabet_size), dir, Seq(f1))))


    // Second part: checking if a word is ending
    val s4 = new BState(Right)
    trans += ((init, SymbBEpsTransition(Seq(s4))))

    val s5 = new BState(Left)
    trans ++= (for (rg <- nonWordChar) yield (s4, SymbBStepTransition(rg, Right, Seq(s5))))

    val s6 = new BState(Left)
    trans += ((s5, SymbBStepTransition(Range(min_char, alphabet_size), Left, Seq(mainFinal, s6))))

    val f2 = new BState(dir)
    trans ++= (for (rg <- nonWordChar) yield (s6, SymbBStepTransition(rg, Left, Seq(f2))))

    trans += ((f2, SymbBStepTransition(Range(min_char, alphabet_size), dir, Seq(f2))))

    SymbMutableAFA2(this, init, mainFinal, mutable.Set(f1, f2), trans)

  }


  def lookaround2AFA(dir: Step, aut: SymbMutableAFA2): SymbMutableAFA2 = {
    // new initial state
    val newInitial = new BState(dir)
    // new final state
    val newMainFinState = new BState(dir)

    // Add inner loop on aut final state
    /*
      **WARNING:** what should be the direction of this self loop? In general, it is the same as dir, but if there is a
      nesting of, e.g., lookahead and lookbehind, then the aut.mainFinState.dir != dir. Then we have to choose: which
      direction should the loop be? It does not really matter, because it is a final sink state. For consistency,
      I have chosen to be the same direction of the state direction.
    */
    aut.transitions += ((aut.mainFinState, SymbBStepTransition(new Range(min_char, alphabet_size, 1), aut.mainFinState.dir, Seq(aut.mainFinState))))

    // The mainFinal state becomes secondary final state.
    aut.finStates += aut.mainFinState

    // Add universal eps initial transitions
    aut.transitions += ((newInitial, SymbBEpsTransition(Seq(aut.initialState, newMainFinState))))

    // Change initial and final states
    aut.initialState = newInitial
    aut.mainFinState = newMainFinState

    return aut
  }


  def negLookaround2AFA(dir: Step, aut: SymbMutableAFA2): SymbMutableAFA2 = {
    // new initial state
    val newInitial = new BState(dir)
    // new final state
    val newMainFinState = new BState(dir)

    // First I add the inner loop in the final state and THEN I complement!
    /*
          **WARNING:** what should be the direction of this self loop? In general, it is the same as dir, but if there is a
          immediate nesting of, e.g., lookahead and lookbehind, <(>a) then the aut.mainFinState.dir != dir.
          * Then we have to choose: which
          direction should the loop be? It does not really matter, because it is a final sink state anyway. For consistency,
          I have chosen to be the same direction of the state direction.
        */
    aut.transitions +=
      ((aut.mainFinState, SymbBStepTransition(new Range(min_char, alphabet_size, 1), aut.mainFinState.dir, Seq(aut.mainFinState))))

    // The mainFinal state becomes secondary final state.
    aut.finStates += aut.mainFinState

    val negAut = aut.complement()

    // Add universal eps initial transitions
    negAut.transitions += ((newInitial, SymbBEpsTransition(Seq(negAut.initialState, newMainFinState))))

    // Change initial and final states
    negAut.initialState = newInitial
    negAut.mainFinState = newMainFinState //The correct final state is set, recall that negAut had a fake final states so far.

    return negAut
  }
}




case class SymbMutableAFA2(builder: SymbAFA2Builder,
                           var initialState: BState,
                           var mainFinState: BState,
                           finStates: mutable.Set[BState],
                           transitions: ArrayBuffer[(BState, SymbBTransition)]) {


  override def clone() : SymbMutableAFA2 = {
    val oldStates = this.getStates()
    val oldNew = (for (old <- oldStates) yield (old, old.clone())).toMap
    val newfinStates = for (st <- this.finStates) yield oldNew.get(st).get

    val newTrans = ArrayBuffer[(BState, SymbBTransition)]()
    newTrans ++= (for ((st, tr) <- this.transitions)
      yield (oldNew.get(st).get,
        tr match {
          case stept: SymbBStepTransition => SymbBStepTransition(stept.label, stept.step, stept._targets.map(oldNew))
          case epst: SymbBEpsTransition => SymbBEpsTransition(epst._targets.map(oldNew))
        }))
    SymbMutableAFA2(this.builder, oldNew.get(this.initialState).get, oldNew.get(this.mainFinState).get, newfinStates, newTrans)
  }


  override def toString() = {
    val res = new mutable.StringBuilder("Initial: " + initialState + "\n")
    res.append("Main final: " + mainFinState + "\n")
    res.append("Secondary final: " + finStates + "\n")

    res.append("Transitions:\n")
    val transMap = transToMap()
    for (key <- transMap.keySet) {
      res.append(key + "\n")
      for (ts <- transMap.get(key); t <- ts)
        res.append("\t" + ts + "\n")
    }

    res.toString()
  }

  def getStates(): Set[BState] = {
    val allStates = mutable.Set[BState](initialState, mainFinState)
    allStates ++= finStates
    allStates ++= {
      for ((from, trans) <- transitions;
           target <- trans.targets) yield Seq(from, target)
    }.flatten
    Set.empty ++ allStates
  }

  private def transToMap(): Map[BState, Seq[SymbBTransition]] = transitions.groupBy(_._1).mapValues(l => l map (_._2))


  def builderToSymbExtAFA(): SymbExtAFA2 = {
    val stMap: Map[BState, Int] = this.getStates().zipWithIndex.map { case (v, i) => (v, i) }.toMap
    val initialState = stMap.get(this.initialState).get
    val oldFinalStates = this.finStates.toSet + this.mainFinState
    val finalLeftStates = for (fs <- oldFinalStates if fs.dir == Left) yield stMap.get(fs).get
    val finalRightStates = for (fs <- oldFinalStates if fs.dir == Right) yield stMap.get(fs).get
    val trans = for ((st, tr) <- this.transitions)
      yield (stMap.get(st).get,
        tr match {
          case st: SymbBStepTransition => SymbTransition(st.label, st.step, st._targets.map(stMap))
          case et: SymbBEpsTransition => EpsTransition(et._targets.map(stMap))
        })

    val transMap = trans.groupBy(_._1).mapValues(l => l map (_._2))

    SymbExtAFA2(Seq(initialState), finalLeftStates.toSeq, finalRightStates.toSeq, transMap)
  }



  private def findSinkStates() : Set[BState] = {
    val allStates = this.getStates()
    val transMap = this.transToMap()
    for (s <- allStates;
         ts <- transMap.get(s).iterator;
          t <- ts;
         if (t.isInstanceOf[SymbBStepTransition] &&
           t.asInstanceOf[SymbBStepTransition].label==new Range(builder.min_char, builder.alphabet_size, 1) &&
           t.targets==Seq(s)))
      yield s
  }

  private def untrim(): Unit = {
    val sinkStates = this.findSinkStates()
    val leftUnacceptSinkState = sinkStates.find(x =>
            x.dir==Left && this.mainFinState!=x && !this.finStates.contains(x)) match {
      case Some(x) => x
      case None => new BState(Left)
    }

    val rightUnacceptSinkState = sinkStates.find(x =>
      x.dir == Right && this.mainFinState != x && !this.finStates.contains(x)) match {
      case Some(x) => x
      case None => new BState(Right)
    }

    //val leftUnacceptSinkState = new BState(Left)
    //val rightUnacceptSinkState = new BState(Right)
    // Compute all states
    val allStates = getStates() ++ Set(leftUnacceptSinkState, rightUnacceptSinkState)
    val transMap = transToMap()

    // Do not untrim states that have at least one outgoing eps transition and all outgoing eps trans
    val allEpsStates = for (s <- allStates
                            if {
                              transMap.get(s) match {
                                case None => false
                                case Some(transSeq) =>
                                  if (transSeq.forall(_.isInstanceOf[SymbBEpsTransition])) true
                                  else false
                              }
                            }) yield s

    val allStepStates = allStates diff allEpsStates

    for (state <- allStepStates) {
      // Compute the set of ranges NOT appearing in outgoing transitions
      var outRanges = Set(new Range(builder.min_char, builder.alphabet_size, 1))
      for (ts <- transMap.get(state);
           t <- ts) t match {
        case SymbBStepTransition(label, _, _) => {
          outRanges = AFA2Utils.rangeDiff(outRanges, label)
        }
        case SymbBEpsTransition(_) =>
      }

      transitions ++= {
        for (rng <- outRanges) yield {
          state.dir match {
            case Left => (state, SymbBStepTransition (rng, Left, Seq (leftUnacceptSinkState) ) )
            case Right => (state, SymbBStepTransition (rng, Right, Seq (rightUnacceptSinkState) ) )
          }

        }
      }
    }
  }


  def complement(): SymbMutableAFA2 = {
    // Check consistency, otherwise the complementation algo does not work
    this.checkConsistency()
    //AFA2Utils.printAutDotToFile(this.builderToExtAFA(), "debug-trimmed.dot")
    this.untrim()
    //AFA2Utils.printAutDotToFile(this.builderToExtAFA(), "debug-untrimmed.dot")

    val oldStates = this.getStates()

    // Map oldStates -> newStates
    val oldNew = (for (old <- oldStates) yield (old, old.clone())).toMap

    //Swap final states. Again, **WARNING** all secondary final states.
    val newFinStates = mutable.Set() ++=
      (for (old <- oldStates;
            if !(old == mainFinState || finStates.contains(old))) yield oldNew.get(old).get)

    val transMap = transToMap()
    //println("TransMap:\n" + transMap)
    val transMapEps: Map[BState, Seq[SymbBEpsTransition]] =
      transMap.filter(x => x._2.forall(_.isInstanceOf[SymbBEpsTransition])).asInstanceOf[Map[BState, Seq[SymbBEpsTransition]]]
    val negTransMapEps: Map[BState, Seq[SymbBStepTransition]] =
      transMap.filter(x => x._2.forall(_.isInstanceOf[SymbBStepTransition])).asInstanceOf[Map[BState, Seq[SymbBStepTransition]]]

    assert(transMapEps.keySet.intersect(negTransMapEps.keySet).isEmpty)
    assert(negTransMapEps.forall(x => (x._2.forall(_._targets.size == 1))))

    val transBufNotEps: ArrayBuffer[(BState, SymbBStepTransition)] =
      transitions.filter(x => x._2.isInstanceOf[SymbBStepTransition]).asInstanceOf[ArrayBuffer[(BState, SymbBStepTransition)]]

    val newTransitions = ArrayBuffer[(BState, SymbBTransition)]()

    //Swap universal/existential epsilon transitions.
    // **WARNING** this works because self eps loop do not impact, so we have either all universal or all existential
    // outgoing transition.
    newTransitions ++=
      (for (old <- oldStates;
            trans <- transMapEps.get(old)) yield {

        assert(trans.forall(_.isExistential()) || (trans.size == 1 && trans.forall(_.isUniversal())))

        trans.forall(_.isExistential()) match {
          case true => Seq((oldNew.get(old).get, SymbBEpsTransition((for (tr <- trans) yield tr.targets).flatten.map(oldNew))))
          case false => for (tr <- trans;
                             st <- tr.targets) yield (oldNew.get(old).get, SymbBEpsTransition(Seq(oldNew.get(st).get)))
        }
      }).flatten

    //println("Old trans:\n" + transMapEps)
    //println("New trans:\n" + newTransitions)

    //Nothing to be done with Step transitions, they should be all deterministic.
    val newTransBufNotEps = for ((st, tr) <- transBufNotEps) yield
      (oldNew.get(st).get, SymbBStepTransition(tr.label, tr.step, tr.targets.map(oldNew)))
    newTransitions ++= newTransBufNotEps

    /*
    //Swap step transition
    newTransitions ++=
    for ( ((s, char), lls) <- transMapStep ) yield {
      /*
      CHECK:
        for each state s, either multiple existential outgoing transitions or a single universal outgoing transition
    */
      assert(lls.size == 1 || lls.forall(_.size == 1))

      lls.size == 1 match {
        // it is a universal transition
        case true => for (st <- lls.flatten) yield (oldNew.get(s).asInstanceOf[BState], BStepTransition(char, s.dir, Seq(oldNew.get(st).asInstanceOf[BState])))
        // it is an existential transition
        case false => Seq((oldNew.get(s).asInstanceOf[BState], BStepTransition(char, s.dir, lls.flatten.map(oldNew))))
      }
    }
     */

    assert(transitions.forall(x => !x._2.targets.isEmpty))
    assert(newTransitions.forall(x => !x._2.targets.isEmpty))

    val res = SymbMutableAFA2(this.builder,
      oldNew.get(initialState).get,
      new BState(Left), //fake, it will be replaced in the negative lookaround procedure
      newFinStates,
      newTransitions)

    res.checkConsistency()
    AFA2Utils.printAutDotToFile(res.builderToSymbExtAFA(), "debug-complement.dot")
    res

  }


  def checkConsistency(): Unit = {
    var aut = this.copy()

    var transMap: Map[BState, Seq[SymbBTransition]] = aut.transToMap()

    var transMapEps: Map[BState, Seq[SymbBEpsTransition]] =
      transMap.filter(x => x._2.forall(_.isInstanceOf[SymbBEpsTransition])).asInstanceOf[Map[BState, Seq[SymbBEpsTransition]]]

    var negTransMapEps: Map[BState, Seq[SymbBStepTransition]] =
      transMap.filter(x => x._2.forall(_.isInstanceOf[SymbBStepTransition])).asInstanceOf[Map[BState, Seq[SymbBStepTransition]]]

    var transBufNotEps: ArrayBuffer[(BState, SymbBStepTransition)] =
      transitions.filter(x => x._2.isInstanceOf[SymbBStepTransition]).asInstanceOf[ArrayBuffer[(BState, SymbBStepTransition)]]

    var transMapStep: Map[(BState, Range), Seq[Seq[BState]]] =
      transBufNotEps.groupBy(x => (x._1, x._2.label)).mapValues(x => x map (y => y._2.targets))


    // check (1)
    //println(aut)
    //AutomatonUtils.printAutDotToFile(aut.builderToExtAFA(),"debugMutableAFA2.dot")
    assert(transMapEps.keySet.intersect(negTransMapEps.keySet).isEmpty, "Check (1) failed")

    // check (2)
    assert(transMapEps.forall(x => (x._2.size == 1 || x._2.forall(_.targets.size == 1))), "Check (2) failed")

    // check (3)
    assert(negTransMapEps.forall(x => x._2.forall(_.step == x._1.dir)), "Check (3) failed")

    //check (4)
    assert(transMapStep.forall(x => (x._2.size == 1 && x._2(0).size == 1)), "Check (4) failed")

    //check (5)
    // Should hold, but actually during neg lookaheads there when the resulting automaton is not yet ready it does not hold.
    //assert(!aut.finStates.contains(aut.mainFinState), "Check (5) failed")
  }

}
