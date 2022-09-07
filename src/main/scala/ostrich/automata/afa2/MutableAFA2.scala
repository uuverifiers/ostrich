package ostrich.automata.afa2


import ostrich.automata.afa2.AFA2.{Left, Right, Step}

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer

class BState(_dir: Step) {
	val dir = this._dir


	override def toString() = {
		this.hashCode().toString
	}

	override def clone() = new BState(this.dir)
}

abstract sealed class BTransition(val targets: Seq[BState])

case class BEpsTransition(_targets: Seq[BState]) extends BTransition(_targets) {
	def isUniversal(): Boolean = targets.size > 1
	def isExistential(): Boolean = targets.size == 1
}

case class BStepTransition(label: Int,
                           step: Step,
                           _targets: Seq[BState]) extends BTransition(_targets)


class AFA2Builder(_alphabet: Set[Int]) {
	val alphabet = _alphabet

	def charrangeAtomic2AFA(dir: Step, range: Range): MutableAFA2 = {
		val iniState = new BState(dir)
		val finState = new BState(dir)

		val trans: ArrayBuffer[(BState, BTransition)] =
			ArrayBuffer[(BState, BTransition)]() ++= (for (char <- range) yield (iniState, BStepTransition(char, dir, Seq(finState))))

		MutableAFA2(this, iniState, finState, mutable.Set[BState](), trans)
	}

	def allcharAtomic2AFA(dir: Step): MutableAFA2 = {
		val iniState = new BState(dir)
		val finState = new BState(dir)

		val trans: ArrayBuffer[(BState, BTransition)] =
			ArrayBuffer[(BState, BTransition)]() ++= (for (char <- alphabet) yield (iniState, BStepTransition(char, dir, Seq(finState))))

		MutableAFA2(this, iniState, finState, mutable.Set[BState](), trans)
	}

	def allAtomic2AFA(dir: Step): MutableAFA2 = {
		val res = allcharAtomic2AFA(dir)
		res.transitions += ((res.initialState, BEpsTransition(Seq(res.mainFinState))))
		res
	}


	// Matches exactly num occurrences of aut
	def loop1Aut2AFA(dir: Step, num: Int, aut: MutableAFA2): MutableAFA2 = {
		num match {
			// According to the semantics, this accepts the epsilon word
			case 0 => epsAtomic2AFA(dir)

			case n =>
				val autArray: Seq[MutableAFA2] = for (i <- 1 to n) yield aut.clone()
				autArray.reduce((l, r) => concat2AFA(dir, l, r))
		}
	}

	// Matches whatever n  in {min to max} iterations of aut. Obtained as alternation of each n
	def loop3Aut2AFA(dir: Step, min: Int, max: Int, aut: MutableAFA2): MutableAFA2 = {
		val autArray: Seq[MutableAFA2] = for (i <- min to max) yield loop1Aut2AFA(dir, i, aut)
		autArray.reduce((l, r) => alternation2AFA(dir, l, r))
	}


	def charAtomic2AFA(dir: Step, char: Int): MutableAFA2 = {
		val iniState = new BState(dir)
		val finState = new BState(dir)
		val trans = BStepTransition(char, dir, Seq(finState))

		MutableAFA2(this, iniState, finState, mutable.Set[BState](), ArrayBuffer[(BState, BTransition)]((iniState, trans)))
	}

	def epsAtomic2AFA(dir: Step): MutableAFA2 = {
		val iniState = new BState(dir)
		val finState = new BState(dir)
		val trans = BEpsTransition(Seq(finState))

		MutableAFA2(this, iniState, finState, mutable.Set[BState](), ArrayBuffer[(BState, BTransition)]((iniState, trans)))
	}

	def emptyAtomic2AFA(dir: Step): MutableAFA2 = {
		val iniState = new BState(dir)
		val finState = new BState(dir)

		MutableAFA2(this, iniState, finState, mutable.Set[BState](), ArrayBuffer[(BState, BTransition)]())
	}

	def star2AFA(dir: Step, aut: MutableAFA2): MutableAFA2 = {
		val newInitial = new BState(dir)
		val newFinal = new BState(dir)

		// Add inner eps loop
		aut.transitions += ((aut.mainFinState, BEpsTransition(Seq(aut.initialState))))

		// Add initial eps transition
		aut.transitions += ((newInitial, BEpsTransition(Seq(aut.initialState))))

		// Add final eps transition
		aut.transitions += ((aut.mainFinState, BEpsTransition(Seq(newFinal))))

		// Add outer eps loop
		aut.transitions += ((newInitial, BEpsTransition(Seq(newFinal))))

		// Change initial and final states
		aut.initialState = newInitial
		aut.mainFinState = newFinal

		return aut
	}

	// laut is modified and returned
	def concat2AFA(dir: Step, laut: MutableAFA2, raut: MutableAFA2): MutableAFA2 = {
		// New final state. Notice the dir is the same of raut
		val newFinal = raut.mainFinState

		// Add eps trans connecting laut and raut
		laut.transitions += ((laut.mainFinState, BEpsTransition(Seq(raut.initialState))))

		// Change final state
		laut.mainFinState = newFinal

		// Add all secondary final states of raut to laut
		laut.finStates ++= raut.finStates

		// Add all raut transitions to laut
		laut.transitions ++= raut.transitions

		return laut
	}

	// laut is modified and returned
	def alternation2AFA(dir: Step, laut: MutableAFA2, raut: MutableAFA2): MutableAFA2 = {
		// New initial and final state
		val newFinal = new BState(dir)
		val newInit = new BState(dir)

		// Add initial transitions
		laut.transitions += ((newInit, BEpsTransition(Seq(laut.initialState))))
		laut.transitions += ((newInit, BEpsTransition(Seq(raut.initialState))))

		// Add final transition
		laut.transitions += ((laut.mainFinState, BEpsTransition(Seq(newFinal))))
		laut.transitions += ((raut.mainFinState, BEpsTransition(Seq(newFinal))))

		// Change initial and final states
		laut.initialState = newInit
		laut.mainFinState = newFinal

		// Add all secondary final states of raut to laut
		laut.finStates ++= raut.finStates

		// Copy raut transitions
		laut.transitions ++= raut.transitions

		return laut
	}


	def lookaround2AFA(dir: Step, aut: MutableAFA2): MutableAFA2 = {
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
		aut.transitions ++= {
			for (char <- alphabet) yield
				(aut.mainFinState, BStepTransition(char, aut.mainFinState.dir, Seq(aut.mainFinState)))
		}

		// The mainFinal state becomes secondary final state.
		aut.finStates += aut.mainFinState

		// Add universal eps initial transitions
		aut.transitions += ((newInitial, BEpsTransition(Seq(aut.initialState, newMainFinState))))

		// Change initial and final states
		aut.initialState = newInitial
		aut.mainFinState = newMainFinState

		return aut
	}


	def negLookaround2AFA(dir: Step, aut: MutableAFA2): MutableAFA2 = {
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
		aut.transitions ++= {
			for (char <- alphabet) yield
				(aut.mainFinState, BStepTransition(char, aut.mainFinState.dir, Seq(aut.mainFinState)))
		}

		// The mainFinal state becomes secondary final state.
		aut.finStates += aut.mainFinState

		val negAut = aut.complement()

		// Add universal eps initial transitions
		negAut.transitions += ((newInitial, BEpsTransition(Seq(negAut.initialState, newMainFinState))))

		// Change initial and final states
		negAut.initialState = newInitial
		negAut.mainFinState = newMainFinState //The correct final state is set, recall that negAut had a fake final states so far.

		return negAut
	}

}


// Builds an Extended Symbolic 2AFA.
case class MutableAFA2(builder: AFA2Builder,
											 var initialState: BState,
											 var mainFinState: BState,
											 finStates: mutable.Set[BState],
											 transitions: ArrayBuffer[(BState, BTransition)]) {

	override def clone() = {
		val oldStates = this.getStates()
		val oldNew = ( for (old <- oldStates) yield (old, old.clone()) ).toMap
		val newfinStates = for (st <- this.finStates) yield oldNew.get(st).get

		val newTrans = ArrayBuffer[(BState, BTransition)]()
		newTrans ++= (for ((st, tr) <- this.transitions)
												yield (oldNew.get(st).get,
													tr match {
													case stept: BStepTransition => BStepTransition(stept.label, stept.step, stept._targets.map(oldNew) )
													case epst: BEpsTransition => BEpsTransition(epst._targets.map (oldNew) )
													}))
		MutableAFA2(this.builder, oldNew.get(this.initialState).get, oldNew.get(this.mainFinState).get, newfinStates, newTrans)
	}


	override def toString() = {
		val res = new mutable.StringBuilder("Initial: " + initialState + "\n")
		res.append("Main final: " + mainFinState + "\n")
		res.append("Secondary final: " + finStates + "\n")

		res.append("Transitions:\n")
		val transMap = transToMap()
		for (key <- transMap.keySet) {
			res.append(key + "\n")
			for (ts <- transMap.get(key); t<-ts)
				res.append("\t" + ts + "\n")
		}

		res.toString()
	}


	def getStates(): Set[BState] = {
		val allStates = mutable.Set[BState](initialState, mainFinState)
		allStates ++= finStates
		allStates ++= {for ((from, trans) <- transitions;
		                   target <- trans.targets) yield Seq(from, target)}.flatten
		Set.empty ++ allStates
	}

	private def transToMap(): Map[BState, Seq[BTransition]] = transitions.groupBy(_._1).mapValues(l => l map (_._2))

	/*
	Checks for the following, which should hold given our translation.
	(1) All states have either all outgoing epsilon or all outgoing step transitions or no outgoing transitions;
	(2) All states with all outgoing eps transitions, those transitions are either all existential or one universal;
	(3) States with all outgoing step transitions have those transitions with the same direction of the state direction;
	(4) States with all outgoing step transitions, those transitions are all deterministic
	(5) mainFinStates is not contained in finStates;
	(6) same checks are done after untrimming the automata but with:
			(1 bis): All states have either all outgoing epsilon or all outgoing step transitions;
			(8): All states with outgoing step transitions have the number of such transitions equal to the size of alphabet
	(7) same checks of (6) are done after complementing the automata.
	 */
	def checkConsistency(): Unit = {
		var aut = this.copy()

		var transMap: Map[BState, Seq[BTransition]] = aut.transToMap()

		var transMapEps: Map[BState, Seq[BEpsTransition]] =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BEpsTransition])).asInstanceOf[Map[BState, Seq[BEpsTransition]]]

		var negTransMapEps: Map[BState, Seq[BStepTransition]] =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BStepTransition])).asInstanceOf[Map[BState, Seq[BStepTransition]]]

		var transBufNotEps: ArrayBuffer[(BState, BStepTransition)] =
			transitions.filter(x => x._2.isInstanceOf[BStepTransition]).asInstanceOf[ArrayBuffer[(BState, BStepTransition)]]

		var transMapStep: Map[(BState, Int), Seq[Seq[BState]]] =
			transBufNotEps.groupBy(x => (x._1, x._2.label)).mapValues(x => x map (y => y._2.targets))


		// check (1)
		//println(aut)
		//AutomatonUtils.printAutDotToFile(aut.builderToExtAFA(),"debugMutableAFA2.dot")
		assert(transMapEps.keySet.intersect(negTransMapEps.keySet).isEmpty, "Check (1) failed")

		// check (2)
		assert(transMapEps.forall(x => (x._2.size==1 || x._2.forall(_.targets.size==1))), "Check (2) failed")

		// check (3)
		assert(negTransMapEps.forall(x => x._2.forall(_.step==x._1.dir)), "Check (3) failed")

		//check (4)
		assert(transMapStep.forall(x => (x._2.size==1 && x._2(0).size==1) ), "Check (4) failed")

		//check (5)
		// Should hold, but actually during neg lookaheads there when the resulting automaton is not yet ready it does not hold.
		//assert(!aut.finStates.contains(aut.mainFinState), "Check (5) failed")

		// ************************** UNTRIM *************************************
		/*
		aut.untrim()
		transMap = aut.transToMap()
		transMapEps =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BEpsTransition])).asInstanceOf[Map[BState, Seq[BEpsTransition]]]

		negTransMapEps =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BStepTransition])).asInstanceOf[Map[BState, Seq[BStepTransition]]]

		transBufNotEps =
			transitions.filter(x => x._2.isInstanceOf[BStepTransition]).asInstanceOf[ArrayBuffer[(BState, BStepTransition)]]

		transMapStep =
			transBufNotEps.groupBy(x => (x._1, x._2.label)).mapValues(x => x map (y => y._2.targets))

		// check (1 bis)
		assert(transMapEps.keySet.intersect(negTransMapEps.keySet).isEmpty &&
			       transMapEps.keySet.union(negTransMapEps.keySet)==aut.getStates(), "Check (1)bis failed")

		// check (2)
		assert(transMapEps.forall(x => (x._2.size == 1 || x._2.forall(_.targets.size == 1))), "Check (2) after untrim failed")

		// check (3)
		assert(negTransMapEps.forall(x => x._2.forall(_.step == x._1.dir)), "Check (3) after untrim failed")

		//check (4)
		assert(transMapStep.forall(x => (x._2.size == 1 && x._2(0).size == 1)), "Check (4) after untrim failed")

		//check (5)
		// Should hold, but actually during neg lookaheads there when the resulting automaton is not yet ready it does not hold.
		//assert(!aut.finStates.contains(aut.mainFinState), "Check (5) after untrim failed")

		//check (8)
		assert(negTransMapEps.forall(_._2.size==builder.alphabet.size), "Check (8) after untrim failed")

		// ******************************* COMPLEMENT *******************************
		aut = aut.complement()
		transMap = aut.transToMap()

		transMapEps =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BEpsTransition])).asInstanceOf[Map[BState, Seq[BEpsTransition]]]

		negTransMapEps =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BStepTransition])).asInstanceOf[Map[BState, Seq[BStepTransition]]]

		transBufNotEps =
			transitions.filter(x => x._2.isInstanceOf[BStepTransition]).asInstanceOf[ArrayBuffer[(BState, BStepTransition)]]

		transMapStep =
			transBufNotEps.groupBy(x => (x._1, x._2.label)).mapValues(x => x map (y => y._2.targets))

		// check (1 bis)
		assert(transMapEps.keySet.intersect(negTransMapEps.keySet).isEmpty &&
			       transMapEps.keySet.union(negTransMapEps.keySet) == aut.getStates(), "Check (1)bis after complement failed")

		// check (2)
		assert(transMapEps.forall(x => (x._2.size == 1 || x._2.forall(_.targets.size == 1))), "Check (2) after complement failed")

		// check (3)
		assert(negTransMapEps.forall(x => x._2.forall(_.step == x._1.dir)), "Check (3) after complement failed")

		//check (4)
		assert(transMapStep.forall(x => (x._2.size == 1 && x._2(0).size == 1)), "Check (4) after complement failed")

		//check (5)
		// Should hold, but actually during neg lookaheads there when the resulting automaton is not yet ready it does not hold.
		//assert(!aut.finStates.contains(aut.mainFinState), "Check (5) after complement failed")

		//check (8)
		assert(negTransMapEps.forall(_._2.size == builder.alphabet.size), "Check (8) after complement failed")

		 */
	}

	/*
	Untrims the automaton by making the transition function total. It ignores eps trans. The *complete alphabet* is required.
	What does it mean total transition function in our case? States are categorised into Left and Right states. Therefore
	given a state, a (Right or Left) state has a total transition function iff:
		- it only has outgoing eps-trans;
		- otherwise, for each char in the alphabet there is a (Right or Left respectively) outgoing transition
	 */
	private def untrim(): Unit = {
		val leftUnacceptSinkState = new BState(Left)
		val rightUnacceptSinkState = new BState(Right)
		// Compute all states
		val allStates = getStates() ++ Set(leftUnacceptSinkState, rightUnacceptSinkState)
		val transMap = transToMap()

		// Do not untrim states that have at least one outgoing eps transition and all outgoing eps trans
		val allEpsStates = for (s <- allStates
		                         if {
			                         transMap.get(s) match {
				                         case None           => false
				                         case Some(transSeq) =>
					                         if (transSeq.forall(_.isInstanceOf[BEpsTransition])) true
					                         else false
			                         }
		                         }) yield s

		val allStepStates = allStates diff allEpsStates

		for (state <- allStepStates) {
			// Compute the set of char NOT appearing in outgoing transitions
			val missingTrans = {
				builder.alphabet diff {
					transMap.get(state) match {
						case None => Set()
						case Some(transSeq) =>
							{for (t <- transSeq
							     if t.isInstanceOf[BStepTransition]) yield
								t.asInstanceOf[BStepTransition].label}.toSet
					}
				}
			}

			transitions ++= { for (char <- missingTrans) yield
				state.dir match {
					case Left => (state, BStepTransition(char, Left, Seq(leftUnacceptSinkState)))
					case Right => (state, BStepTransition(char, Right, Seq(rightUnacceptSinkState)))
				}
			}
		}
	}


	/*
	Returns a *new* automaton which is the complement of this by:
	(2) untrimming;
	(3) swapping initial and final states and universal and existential transitions.
	**WARNING:** All new final states are secondary final states!** meaning that this method is useful only for complementing
	in a negative lookaround procedure.

	**WARNING:** All step transitions are deterministic!
	*/
	// TODO: Remove consistency checks! Remove debug prints!
	def complement(): MutableAFA2 = {
		// Check consistency, otherwise the complementation algo does not work
		this.checkConsistency()
		AutomatonUtils.printAutDotToFile(this.builderToExtAFA(),"debug-trimmed.dot")
		this.untrim()
		AutomatonUtils.printAutDotToFile(this.builderToExtAFA(),"debug-untrimmed.dot")
		this.checkConsistency()

		val oldStates = getStates()

		// Map oldStates -> newStates
		val oldNew = ( for (old <- oldStates) yield (old, old.clone()) ).toMap

		//Swap final states. Again, **WARNING** all secondary final states.
		val newFinStates = mutable.Set() ++=
			(for ( old <- oldStates;
						 if !(old==mainFinState || finStates.contains(old)) ) yield oldNew.get(old).get)

		val transMap = transToMap()
		//println("TransMap:\n" + transMap)
		val transMapEps : Map[BState, Seq[BEpsTransition]] =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BEpsTransition])).asInstanceOf[Map[BState, Seq[BEpsTransition]]]
		val negTransMapEps : Map[BState, Seq[BStepTransition]] =
			transMap.filter(x => x._2.forall(_.isInstanceOf[BStepTransition])).asInstanceOf[Map[BState, Seq[BStepTransition]]]

		assert(transMapEps.keySet.intersect(negTransMapEps.keySet).isEmpty)
		assert(negTransMapEps.forall(x => (x._2.forall(_._targets.size==1))))

		val transBufNotEps : ArrayBuffer[(BState, BStepTransition)] =
			transitions.filter(x => x._2.isInstanceOf[BStepTransition]).asInstanceOf[ArrayBuffer[(BState, BStepTransition)]]

		val newTransitions = ArrayBuffer[(BState, BTransition)]()

		//Swap universal/existential epsilon transitions.
		// **WARNING** this works because self eps loop do not impact, so we have either all universal or all existential
		// outgoing transition.
		newTransitions ++=
			(for(old <- oldStates;
			     trans <- transMapEps.get(old)) yield {

				assert(trans.forall(_.isExistential()) || ( trans.size==1 && trans.forall(_.isUniversal()) ) )

				trans.forall(_.isExistential()) match {
					case true => Seq( (oldNew.get(old).get, BEpsTransition( (for (tr <- trans) yield tr.targets).flatten.map(oldNew) )) )
					case false => for (tr <- trans;
					                   st <- tr.targets) yield (oldNew.get(old).get, BEpsTransition( Seq(oldNew.get(st).get) ))
				}
			}).flatten

		//println("Old trans:\n" + transMapEps)
		//println("New trans:\n" + newTransitions)

		//Nothing to be done with Step transitions, they should be all deterministic.
		val newTransBufNotEps = for ((st, tr) <- transBufNotEps) yield
			(oldNew.get(st).get, BStepTransition(tr.label, tr.step, tr.targets.map(oldNew)))
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

		val res = MutableAFA2(this.builder,
								oldNew.get(initialState).get,
		            new BState(Left), //fake, it will be replaced in the negative lookaround procedure
		            newFinStates,
		            newTransitions)

		res.checkConsistency()
		AutomatonUtils.printAutDotToFile(res.builderToExtAFA(),"debug-complement.dot")
		res

	}

	def builderToExtAFA(): ExtAFA2 = {
		val stMap: Map[BState, Int] = this.getStates().zipWithIndex.map{case (v, i) => (v, i)}.toMap
		val initialState = stMap.get(this.initialState).get
		val oldFinalStates = this.finStates.toSet + this.mainFinState
		val finalLeftStates = for (fs <- oldFinalStates if fs.dir==Left) yield stMap.get(fs).get
		val finalRightStates = for (fs <- oldFinalStates if fs.dir==Right) yield stMap.get(fs).get
		val trans = for ((st, tr) <- this.transitions)
									yield (stMap.get(st).get,
										tr match {
											case st: BStepTransition => AFA2.StepTransition(st.label, st.step, st._targets.map(stMap))
											case et: BEpsTransition => AFA2.EpsTransition(et._targets.map(stMap))
										})

		val transMap = trans.groupBy(_._1).mapValues(l => l map (_._2))

		ExtAFA2(Seq(initialState), finalLeftStates.toSeq, finalRightStates.toSeq, transMap)
	}

} //end class AFABuilder