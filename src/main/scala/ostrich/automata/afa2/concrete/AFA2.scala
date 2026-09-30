/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2023 Riccado De Masellis, Philipp Ruemmer. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich.automata.afa2.concrete

import ostrich.automata.afa2.{Left, Right, Step, StepTransition}

import java.nio.file.Path
import scala.collection.mutable
import scala.collection.mutable.{HashSet => MHashSet}

/*
 * Existential nondeterminism is implemented by having multiple
 * transitions in the sequence.  Universal nondeterminism is
 * implemented by having multiple target states in Transition.
 */


/*
 * Class AFA2 implements a concrete 2AFA with:
 * - only concrete transitions;
 * - no epsilon transitions;
 * - accepting only at the end of the string.
 * 
 * This class is used as input for the 2AFA -> NFA translation.
 */
case class AFA2(initialStates : Seq[Int],
                finalStates   : Seq[Int],
                transitions   : Map[Int, Seq[StepTransition]]) {

  override def toString: String = {
    val res = new mutable.StringBuilder()
    res.append("Initial states: " + initialStates + "\n")
    res.append("Final states: " + finalStates + "\n")
    for (tr <- transitions) {
      res.append(tr._1 + "goes to \n")
      for (t <- tr._2) res.append(t)
    }
    res.toString()
  }

  assert(!initialStates.isEmpty)

  val states = {
    val states = new MHashSet[Int]

    states ++= initialStates
    states ++= finalStates

    for ((source, ts)                  <- transitions.iterator;
         StepTransition(_, _, targets) <- ts.iterator;
         target                        <- targets.iterator) {
      states += source
      states += target
    }

    states.toIndexedSeq.sorted
  }

  lazy val fwdReachable = {
    val reachable = new MHashSet[Int]
    reachable ++= initialStates

    var oldSize = 0
    while (oldSize < reachable.size) {
      oldSize = reachable.size

      for (s                             <- reachable.toList;
           StepTransition(_, _, targets) <- transitions.getOrElse(s, List())) {
        reachable ++= targets
      }
    }

    reachable.toSet
  }

  lazy val bwdReachable = {
    val reachable = new MHashSet[Int]
    reachable ++= finalStates

    var oldSize = 0
    while (oldSize < reachable.size) {
      oldSize = reachable.size

      for ((source, ts)                  <- transitions.iterator;
           if !(reachable contains source);
           StepTransition(_, _, targets) <- ts.iterator)
        if (targets forall reachable)
          reachable += source
    }

    reachable.toSet
  }

  lazy val reachableStates =
    fwdReachable & bwdReachable


  /*
   * Minimizes the states by merging states that have the same
   * outgoing transitions to the same states.  It performs
   * minimizeStatesStep until the fixpoint (of not being able to
   * remove any more states) is reached.
   */
  def minimizeStates() : AFA2 = {

    def minimizeStatesStep(aut: AFA2): AFA2 = {

      val flatTrans = for ((st, ts) <- aut.transitions.toSeq) yield (ts.toSet, st)

      // Map keeping track of eliminatedState => stateKept
      val stateMap = mutable.HashMap[Int, Int]()

      val transStateMap = flatTrans.groupBy(_._1).mapValues(l => l map (_._2))
      //println("transStateMap:\n" + transStateMap)
      /*
    The above map is still rough, as in the values can contain states that are final, nonfinal, noninitial, initial
    We have to split them in group of states:
    - plain : neither final nor initial
    - fi : final and initial
    - f : final
    - i : initial
     */
      var plainTSM = transStateMap.mapValues(_.filter(x => !aut.initialStates.contains(x) && !aut.finalStates.contains(x)))
      var fiTSM = transStateMap.mapValues(_.filter(x => aut.initialStates.contains(x) && aut.finalStates.contains(x)))
      var fTSM = transStateMap.mapValues(_.filter(x => !aut.initialStates.contains(x) && aut.finalStates.contains(x)))
      var iTSM = transStateMap.mapValues(_.filter(x => aut.initialStates.contains(x) && !aut.finalStates.contains(x)))

      plainTSM = plainTSM.filter(_._2.nonEmpty)
      fiTSM = fiTSM.filter(_._2.nonEmpty)
      fTSM = fTSM.filter(_._2.nonEmpty)
      iTSM = iTSM.filter(_._2.nonEmpty)

      //println("plainTSM:\n" + plainTSM)
      //println("fiTSM:\n" + fiTSM)
      //println("fTSM:\n" + fTSM)
      //println("iTSM:\n" + iTSM)


      for ((_, sts) <- plainTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      for ((_, sts) <- fiTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      for ((_, sts) <- fTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      for ((_, sts) <- iTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      /* Now in the keyset of StateMap contains all and only states that has to be removed.
    The removal strategy is the following:
    (1) filter the transitions map with states to be removed;
    (2) scan such reduced transitions and map the arrival states with stateMap
     */
      val toBeRemoved = stateMap.keySet.toSet
      //println("Removed map:\n" + stateMap)
      //println("To be removed:\n" + toBeRemoved)
      // All other states have to be mapped to themsleves!
      for (s <- aut.states.toSet -- toBeRemoved) stateMap += ((s, s))
      val reducedTrans = aut.transitions.filterNot(x => toBeRemoved.contains(x._1))
      //println("Reduced trans:\n" + reducedTrans)
      val newTrans = reducedTrans.mapValues(_.map(x => StepTransition(x.label, x.step, x.targets.map(stateMap))))

      val newAut = AFA2(aut.initialStates, aut.finalStates, newTrans.toMap)

      newAut.restrictToReachableStates
    }

    /*
    Similar to the one before but trying to take into account self-loop as explained below.
    Currently not used as not extensively tested (but should work). Not much difference with the non-optimized verson.
     */
    def minimizeStatesStepOptimised(aut: AFA2) : AFA2 = {

      //val flatTrans = for ((st, ts) <- aut.transitions.toSeq) yield (ts.toSet, st)
      /*
      Problem: self-transitions do not allow to easily recognise states that have the same outgoing transitions.
      Therefore, is we have a self transition (7, StepTrans(->, [5], Seq(7))) we substitute it with
      (7, StepTrans(->, [5], Seq(SELF))) so they can be recognised.
       */
      val SELF = -5
      val aux = for ((st, ts) <- aut.transitions.toSeq) yield (ts.toSet, st)

      val flatTrans = aux.map{case (transSet, state) =>
        val selfMap: Map[Int, Int] = (for (s <- aut.states) yield (if (s==state) (s, SELF) else (s, s))).toMap
        val newTransSet = transSet.map(x => StepTransition(x.label, x.step, x.targets.map(selfMap)))
        (newTransSet, state)
      }

      // Map keeping track of eliminatedState => stateKept
      val stateMap = mutable.HashMap[Int, Int]()

      val transStateMap = flatTrans.groupBy(_._1).mapValues(l => l map (_._2))
      println("transStateMap:\n" + transStateMap)
      /*
    The above map is still rough, as in the values can contain states that are final, nonfinal, noninitial, initial
    We have to split them in group of states:
    - plain : neither final nor initial
    - fi : final and initial
    - f : final
    - i : initial
     */
      var plainTSM = transStateMap.mapValues(_.filter(x => !aut.initialStates.contains(x) && !aut.finalStates.contains(x)))
      var fiTSM = transStateMap.mapValues(_.filter(x => aut.initialStates.contains(x) && aut.finalStates.contains(x)))
      var fTSM = transStateMap.mapValues(_.filter(x => !aut.initialStates.contains(x) && aut.finalStates.contains(x)))
      var iTSM = transStateMap.mapValues(_.filter(x => aut.initialStates.contains(x) && !aut.finalStates.contains(x)))

      plainTSM = plainTSM.filter(_._2.nonEmpty)
      fiTSM = fiTSM.filter(_._2.nonEmpty)
      fTSM = fTSM.filter(_._2.nonEmpty)
      iTSM = iTSM.filter(_._2.nonEmpty)

      println("plainTSM:\n" + plainTSM)
      println("fiTSM:\n" + fiTSM)
      println("fTSM:\n" + fTSM)
      println("iTSM:\n" + iTSM)


      for ((_, sts) <- plainTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      for ((_, sts) <- fiTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      for ((_, sts) <- fTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      for ((_, sts) <- iTSM) {
        val statesIt = sts.iterator
        // This is the only states that is kept, there is at least one
        val uniqueSt = statesIt.next()
        // Build the map of states that has to be eliminated as key and the replacement as value
        while (statesIt.hasNext) stateMap += ((statesIt.next(), uniqueSt))
      }

      /* Now in the keyset of StateMap contains all and only states that has to be removed.
    The removal strategy is the following:
    (1) filter the transitions map with states to be removed;
    (2) scan such reduced transitions and map the arrival states with stateMap
     */
      val toBeRemoved = stateMap.keySet.toSet
      println("Removed map:\n" + stateMap)
      println("To be removed:\n" + toBeRemoved)
      // All other states have to be mapped to themsleves!
      for (s <- aut.states.toSet--toBeRemoved) stateMap += ((s, s))
      val reducedTrans = aut.transitions.filterNot(x => toBeRemoved.contains(x._1))
      println("Reduced trans:\n" + reducedTrans)
      val newTrans = reducedTrans.mapValues(_.map(x => StepTransition(x.label, x.step, x.targets.map(stateMap))))

      val newTransConverted = newTrans.map{ case (st, ts) =>
        val newTS = ts.map(x => StepTransition(x.label, x.step, x.targets.map(x => {if (x==SELF) st else x}) ))
        (st, newTS)
      }

      val newAut = AFA2(aut.initialStates, aut.finalStates, newTrans.toMap)

      newAut.restrictToReachableStates
    }


    var oldAut = this
    var newAut = minimizeStatesStep(oldAut)
    while (newAut.states.size != oldAut.states.size) {
      oldAut = newAut
      newAut = minimizeStatesStep(oldAut)
    }
    newAut

  }

  // run all available optimizations
  def optimize(): AFA2 = {

    def runAndMeasure(name: String, aut: AFA2, optimization: AFA2 => AFA2): AFA2 = {
      val start = System.currentTimeMillis()
      val statesBefore = aut.states.size

      val result = optimization(aut)

      val time = (System.currentTimeMillis() - start).toDouble / 1000
      val statesAfter = result.states.size

      val reduction =
        if (statesBefore == 0) 0.0
        else (statesBefore - statesAfter).toDouble / statesBefore * 100

      println(s"$name: $time s, $statesBefore -> $statesAfter states (-$reduction%)")

      result
    }

    var reducedAut = this

    reducedAut = runAndMeasure(
      "minimizeStates()",
      reducedAut,
      _.minimizeStates()
    )

    reducedAut = runAndMeasure(
      "partitionRefinement()",
      reducedAut,
      _.partitionRefinement()
    )


    reducedAut = runAndMeasure(
      "localDominatedStateCheck()",
      reducedAut,
      _.localDominatedStateCheck()
    )

    // currently not in use because computing the dominance relation
    // is expensive and yields little
    /**
    reducedAut = runAndMeasure(
      "dominatedStateCheck()",
      reducedAut,
      _.dominatedStateCheck()
    )
    */

    reducedAut
  }

  def merge(q: Int, p: Int): AFA2 = {
    // replace q with p in the initial states
    val newInitialStates = initialStates
      .map(state => if (state == q) p else state)
      .distinct

    // replace a with b in the final states
    val newFinalStates = finalStates
      .map(state => if (state == q) p else state)
      .distinct

    val newTransitions = mutable.HashMap[Int, Seq[StepTransition]]()

    for ((source, outgoingTransitions) <- transitions) {
      // remove q as a source state.
      if (source != q) {
        var mappedTransitions = Seq[StepTransition]()

        for (transition <- outgoingTransitions) {
          // replace q with p in every target list.
          val newTargets = transition.targets
            .map(target => if (target == q) p else target)
            .distinct

          mappedTransitions = mappedTransitions :+
            StepTransition(
              transition.label,
              transition.step,
              newTargets
            )
        }

        newTransitions += ((source, mappedTransitions.distinct))
      }
    }

    AFA2(
      newInitialStates,
      newFinalStates,
      newTransitions.toMap
    ).restrictToReachableStates
  }

  type IncomingTransition = (Int, StepTransition)

  lazy val normalizedIncomingTransitions: Map[Int, Seq[IncomingTransition]] = {
    val incoming = mutable.HashMap[Int, Seq[IncomingTransition]]()

    for ((source, outgoing) <- transitions) {
      for (transition <- outgoing) {
        for (target <- transition.targets.distinct) {

          val normalizedTargets =
            transition.targets.map(t => if (t == target) -1 else t)

          val normalizedTransition = StepTransition(
            transition.label,
            transition.step,
            normalizedTargets
          )

          val current = incoming.getOrElse(target, Seq())
          incoming(target) = current :+ (source, normalizedTransition)
        }
      }
    }

    incoming.toMap
  }

  private def sameIncomingBehavior(q: Int, p: Int, automaton: AFA2): Boolean = {
    automaton.normalizedIncomingTransitions.getOrElse(q, Seq.empty) ==
      automaton.normalizedIncomingTransitions.getOrElse(p, Seq.empty)
  }

  private  def localDominatedStateCheck() : AFA2 = {
    def outgoingBehaviorSubset(q: Int, p: Int, automaton: AFA2): Boolean = {
      val transitionsQ = automaton.transitions.getOrElse(q, Seq()).toSet
      val transitionsP = automaton.transitions.getOrElse(p, Seq()).toSet

      transitionsQ.subsetOf(transitionsP)
    }

    var newAutomaton = AFA2(initialStates, finalStates, transitions)

    var changed = true
    while (changed) {
      changed = false
      for (q <- newAutomaton.states) {
        for (p <- newAutomaton.states) {
          if (q != p && outgoingBehaviorSubset(q, p, newAutomaton) && sameIncomingBehavior(q, p, newAutomaton)) {
            newAutomaton = newAutomaton.merge(q, p)
            changed = true
          }
        }
      }
    }

    newAutomaton.restrictToReachableStates
  }

  private  def dominatedStateCheck() : AFA2 = {

    /**
     * Computes the greatest simulation-based dominance relation.
     *
     * A pair (p, q) is contained in the returned relation iff p dominates q,
     * meaning that every behaviour of q can be matched by p.
     *
     * This relation is computed as the greatest fixpoint:
     * initially every compatible pair is assumed to be in the relation,
     * and pairs are removed until all remaining pairs satisfy the
     * simulation constraints.
     */
    def computeDominanceRelation(automaton: AFA2): Set[(Int, Int)] = {
      def pairIsLocallyValid(p: Int, q: Int): Boolean = {
        // a non-final state cannot dominate a final state
        if (automaton.finalStates.contains(q) && !automaton.finalStates.contains(p))
          return false

        val pTransitions = automaton.transitions.getOrElse(p, Seq.empty)
        val qTransitions = automaton.transitions.getOrElse(q, Seq.empty)

        // collect available (label, direction) combinations
        val pTransitionTypes = pTransitions.map(t => (t.label, t.step)).toSet
        val qTransitionTypes = qTransitions.map(t => (t.label, t.step)).toSet

        // every transition type of q must also be available at p
        qTransitionTypes.subsetOf(pTransitionTypes)
      }

      /*
       * Every state is assumed to dominate every other state
       */
      var relation: Set[(Int, Int)] = {
        for {
          p <- automaton.states
          q <- automaton.states
          if pairIsLocallyValid(p, q)
        } yield (p, q)
      }.toSet

      /**
       * Checks whether a transition of p can simulate a transition of q.
       *
       * The transitions must:
       *  - consume the same input symbol,
       *  - move in the same direction,
       *  - satisfy the universal branching condition.
       *
       * Since one StepTransition represents universal branching,
       * every universal successor of p must dominate some
       * universal successor of q.
       */
      def transitionsMatch(pTransition: StepTransition, qTransition: StepTransition): Boolean = {
        pTransition.label == qTransition.label &&
          pTransition.step == qTransition.step &&
          pTransition.targets.forall { pTarget =>
            qTransition.targets.exists { qTarget =>
              relation.contains((pTarget, qTarget))
            }
          }
      }

      /**
       * Checks whether (p, q) still satisfies the dominance relation.
       * Every transition of q must be matched by some transition of p.
       */
      def pairIsValid(p: Int, q: Int): Boolean = {
        val pTransitions = automaton.transitions.getOrElse(p, Seq.empty)
        val qTransitions = automaton.transitions.getOrElse(q, Seq.empty)

        qTransitions.forall { qTransition =>
          pTransitions.exists { pTransition =>
            transitionsMatch(pTransition, qTransition)
          }
        }
      }

      /*
       * Compute the greatest fixpoint.
       *
       * In every iteration, remove all pairs that no longer satisfy
       * the simulation constraints. Since the relation only shrinks,
       * the algorithm always terminates.
       */
      var changed = true

      while (changed) {

        val newRelation = relation.filter {
          case (p, q) =>
            pairIsValid(p, q)
        }

        changed = newRelation.size != relation.size
        relation = newRelation
      }

      println(
        "Relevant elements in dominance relation: " +
          relation.filter { case (p, q) => p != q }.size
      )

      relation
    }

    def computeEquivalenceClasses(states: Seq[Int], dominance: Set[(Int, Int)]): Map[Int, Int] = {
      var classes = Seq[Set[Int]]()
      for (p <- states) {
        val equivalentStates = states.filter { q =>
          dominance.contains((p, q)) &&
            dominance.contains((q, p))
        }.toSet

        classes :+= equivalentStates
      }
      classes = classes.toSet.toSeq

      var stateMap = Map[Int, Int]()
      for (equivalenceClass <- classes) {
        val representative = equivalenceClass.head
        for (state <- equivalenceClass) {
          stateMap += (state -> representative)
        }
      }

      stateMap
    }

    var newAutomaton = AFA2(initialStates, finalStates, transitions)

    var deletion = true
    while (deletion) {
      deletion = false

      var dominance = computeDominanceRelation(newAutomaton)
      val equivalenceClasses = computeEquivalenceClasses(newAutomaton.states, dominance)
      val relevantClasses = equivalenceClasses.groupBy(_._2).count(_._2.size > 1)
      println("Relevant equivalence classes: " + relevantClasses)

      val mappedAutomaton = mapToClasses(newAutomaton, equivalenceClasses).restrictToReachableStates

      // recompute if classes were found
      if(mappedAutomaton.states.size < newAutomaton.states.size) {
        dominance = computeDominanceRelation(newAutomaton)
      }

      for ((p, q) <- dominance if !deletion && p != q && sameIncomingBehavior(q, p, newAutomaton)) {
        newAutomaton = newAutomaton.merge(q, p).restrictToReachableStates
        deletion = true
      }
    }

    newAutomaton.restrictToReachableStates
  }

  private def mapToClasses(automaton:  AFA2, classes: Map[Int, Int]) : AFA2 = {
    // finally map the states to their partition
    val newInitialStates = automaton.initialStates.map(classes).distinct
    val newFinalStates = automaton.finalStates.map(classes).distinct
    val newTransitions = mutable.HashMap[Int, Seq[StepTransition]]()

    for ((source, outgoing) <- automaton.transitions) {
      val newSource = classes(source)

      val mappedTransitions = for (transition <- outgoing) yield {
        StepTransition(
          transition.label,
          transition.step,
          transition.targets.map(classes)
        )
      }

      // add mapped transitions to the ones that were already mapped
      val buffer = newTransitions.getOrElse(newSource, Seq())
      newTransitions(newSource) = (buffer ++ mappedTransitions).distinct
    }

    // return the reduced automaton
    AFA2(newInitialStates, newFinalStates, newTransitions.toMap)
  }

  /*
   * Reduces the size of the automaton using a partition refinement procedure,
   * that is similar to the hopcroft algorithm for DFAs.
   * We sort states into equivalence classes based on their outgoing transition behavior.
   * A formalization and a correctness proof can be found in chapter 5.2 of the bachelor's thesis
   * "Optimized Methods for Translating Two-Way
   * Alternating Automata to One-Way
   * Non-Deterministic Automata" by Henrik Oback, 2442473
   * available at the "University Library of Regensburg".
   */
  private def partitionRefinement() : AFA2 = {
    // label / left or right / target
    type TransitionSignature = (Int, Step, Set[Int])
    // last partition and set of all transition signatures
    type Signature = (Int, Set[TransitionSignature])

    // map every state to its partition number
    var partitions = mutable.HashMap[Int, Int]()

    // initial partition final/non-final states
    for (state <- finalStates) {
      partitions += ((state, 0))
    }
    for (state <- states) {
      if (!finalStates.contains(state)) {
        partitions += ((state, 1))
      }
    }

    def getSignature(state: Int) : Signature = {
      val outgoingTransitions = transitions.getOrElse(state, Seq())

      // iterate the outgoing transitions and yield their transition signatures
      val transitionSignatures = for (transition <- outgoingTransitions) yield {
        val targetPartitions = transition.targets.iterator.map(partitions).toSet

        // consumed symbol / right or left step / reached partitions
        // there can be multible partitions reached by one transition due to universal branching
        (transition.label, transition.step, targetPartitions)
      }

      // convert to set since duplicate entries should not affect the signature
      (partitions(state), transitionSignatures.toSet)
    }

    // iterate until the last refinement is the same as the current one
    var changed = true
    while(changed) {

      // get the signature of every state
      var allSignatures = mutable.HashMap[Int, Signature]()
      for (state <- states) {
        allSignatures += ((state, getSignature(state)))
      }

      // assign a partition number to every unique signature
      val signatureToPartition = mutable.HashMap[Signature, Int]()
      var nextPartition = 0
      for ((_, signature) <- allSignatures) {
        if (!signatureToPartition.contains(signature)) {
          signatureToPartition += ((signature, nextPartition))
          nextPartition += 1
        }
      }

      // map every state to the partition number of its signature
      val newPartitions = mutable.HashMap[Int, Int]()
      for ((state, signature) <- allSignatures) {
        newPartitions += ((state, signatureToPartition(signature)))
      }

      if (newPartitions == partitions) {
        changed = false
      } else {
        partitions = newPartitions
      }
    }

    // finally map the states to their partition and return the new automaton
    mapToClasses(this, partitions.toMap).restrictToReachableStates
  }

  /*
   * Eliminates non-forward reachable and non-backward reachable states.
   */
  def restrictToReachableStates : AFA2 =
    if (reachableStates.size == states.size) {
      this
    } else {
      val newInitialPre =
        initialStates filter reachableStates
      val newInitial =
        if (newInitialPre.isEmpty)
          initialStates take 1
        else
          newInitialPre

      val newFinal =
        finalStates filter reachableStates
      val newTransitions =
        for ((source, ts) <- transitions;
             if (reachableStates contains source)) yield {
          val newTS =
            for (t@StepTransition(_, _, targets) <- ts;
                 if targets forall reachableStates)
            yield t
          source -> newTS
        }

      AFA2(newInitial, newFinal, newTransitions)
    }

  // Different categories of states:
  //
  // ir: initial,                       outgoing transitions go right
  // ll: incoming transitions go left,  outgoing transitions go left
  // lr: incoming transitions go left,  outgoing transitions go right
  // rl: incoming transitions go right, outgoing transitions go left
  // rr: incoming transitions go right, outgoing transitions go right
  // rf: incoming transitions go right, final

  lazy val (irStates, llStates, lrStates, rlStates, rrStates, rfStates) = {
    val leftIn, rightIn, leftOut, rightOut = new MHashSet[Int]

    for ((source, ts)                     <- transitions.iterator;
         StepTransition(_, step, targets) <- ts.iterator;
         target                           <- targets.iterator) {
      step match {
        case Left  => {
          leftOut  += source
          leftIn   += target
        }
        case Right => {
          rightOut += source
          rightIn  += target
        }
      }
    }

    val onlyLeftIn   = leftIn -- rightIn
    val onlyRightIn  = rightIn -- leftIn
    val onlyLeftOut  = leftOut -- rightOut
    val onlyRightOut = rightOut -- leftOut

    val anyIn        = leftIn ++ rightIn
    val anyOut       = leftOut ++ rightOut

    (initialStates.toSet & onlyRightOut.toSet -- anyIn -- finalStates,
      onlyLeftIn.toSet  & onlyLeftOut.toSet -- initialStates -- finalStates,
      onlyLeftIn.toSet  & onlyRightOut.toSet -- initialStates -- finalStates,
      onlyRightIn.toSet & onlyLeftOut.toSet -- initialStates -- finalStates,
      onlyRightIn.toSet & onlyRightOut.toSet -- initialStates -- finalStates,
      finalStates.toSet & onlyRightIn.toSet -- anyOut -- initialStates)
  }

  lazy val letters =
    (for ((source, ts)            <- transitions.iterator;
          StepTransition(l, _, _) <- ts.iterator)
    yield l).toSet.toIndexedSeq.sorted

  def prettyPrint(): String = {
    val res = new mutable.StringBuilder()

    res.append("Initial: " + initialStates + "\n")
    res.append("Final:   " + finalStates + "\n")

    for ((source, ts) <- transitions) {
      for (t <- ts) {
        res.append(
          source + " --" +
            t.label + "," +
            (if (t.step == Right) "R" else "L") +
            "--> " +
            t.targets.mkString("{", ", ", "}") +
            "\n"
        )
      }
    }

    res.toString()
  }
}
