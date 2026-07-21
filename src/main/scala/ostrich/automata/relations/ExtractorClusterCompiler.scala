/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.automata.relations

import ap.util.Timeout
import ostrich.automata.{AtomicStateAutomaton, AutomataUtils,
                        BricsAutomaton, BricsAutomatonBuilder,
                        BricsTLabelOps, ExtractorCertificate}

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap,
                                 HashSet => MHashSet, MultiMap, Queue,
                                 Set => MSet}

/** Exact construction for a complete family of shared-source extractors. */
object ExtractorClusterCompiler {
  import ConvolutionCodec.Column

  private val MaxSourceChunks = BigInt(100000)

  /** Characters that can be emitted by each lane on an accepting source run. */
  def productiveOutputAlphabets(
      source : AtomicStateAutomaton,
      sourceAlphabet : Vector[Int],
      certificates : Vector[ExtractorCertificate])
      : ExactResult[Vector[Vector[Int]]] = {
    if (sourceAlphabet != sourceAlphabet.distinct.sorted)
      return Unsupported("the source alphabet is not sorted and duplicate-free")
    if (certificates.isEmpty)
      return Unsupported("an extractor cluster needs at least one certificate")

    val period = certificates.size
    val periods = certificates.map(_.period).distinct
    val stops = certificates.map(_.stop).distinct
    if (periods != Vector(period) ||
        certificates.map(_.phase) != certificates.indices.toVector ||
        stops.size != 1)
      return Unsupported("extractor certificates do not form one complete period")
    val stop = stops.head

    for ((_, label, _) <- source.transitions) {
      val letters = source.LabelOps.enumLetters(label)
      while (letters.hasNext)
        if (!sourceAlphabet.contains(letters.next()))
          return Unsupported("the source language uses a character outside " +
                             "the certified finite alphabet")
    }

    case class ProductState(state : source.State, phase : Int, mask : Int)
    val initial = ProductState(source.initialState, 0, 0)
    val reachable = MHashSet[ProductState](initial)
    val queue = Queue[ProductState](initial)
    val edges = ArrayBuffer[(ProductState, Int, ProductState)]()

    while (queue.nonEmpty) {
      val current = queue.dequeue()
      val lane = current.phase
      for (character <- sourceAlphabet) {
        val destinations = source.outgoingTransitions(current.state).collect {
          case (destination, label)
              if source.LabelOps.labelContains(character.toChar, label) =>
            destination
        }.toVector.distinct
        if (destinations.size > 1)
          return Unsupported("the extractor source language is nondeterministic")
        for (destination <- destinations.headOption) {
          val nextMask =
            if ((current.mask & (1 << lane)) == 0 && character == stop)
              current.mask | (1 << lane)
            else
              current.mask
          val next = ProductState(
            destination, (lane + 1) % period, nextMask)
          edges += ((current, character, next))
          if (reachable.add(next))
            queue.enqueue(next)
        }
      }
    }

    val predecessors = new MHashMap[ProductState, MHashSet[ProductState]]
    for ((from, _, to) <- edges)
      predecessors.getOrElseUpdate(to, MHashSet.empty) += from
    val productive = MHashSet[ProductState]() ++ reachable.filter(state =>
      source.isAccept(state.state))
    val backwards = Queue[ProductState]() ++ productive
    while (backwards.nonEmpty) {
      val current = backwards.dequeue()
      for (previous <- predecessors.getOrElse(current, MHashSet.empty);
           if productive.add(previous))
        backwards.enqueue(previous)
    }

    val laneLetters = Array.fill(period)(MHashSet[Int]())
    for ((from, character, to) <- edges;
         if productive(to) &&
            (from.mask & (1 << from.phase)) == 0 &&
            character != stop)
      laneLetters(from.phase) += character
    Supported(laneLetters.toVector.map(_.toVector.sorted))
  }

  def compile(source : AtomicStateAutomaton,
              sourceAlphabet : Vector[Int],
              outputTapes : Vector[Tape],
              certificates : Vector[ExtractorCertificate],
              provenance : Seq[Provenance] = Vector.empty)
      : ExactResult[SynchronizedRelation] = {
    if (outputTapes.isEmpty)
      return Unsupported("an extractor cluster needs at least one output tape")
    if (sourceAlphabet != sourceAlphabet.distinct.sorted)
      return Unsupported("the source alphabet is not sorted and duplicate-free")

    val periods = certificates.map(_.period).distinct
    val stops = certificates.map(_.stop).distinct
    if (certificates.size != outputTapes.size || periods.size != 1 ||
        periods.head != outputTapes.size ||
        certificates.map(_.phase) != outputTapes.indices.toVector ||
        stops.size != 1)
      return Unsupported("extractor certificates do not form one complete period")

    val stop = stops.head
    productiveOutputAlphabets(source, sourceAlphabet, certificates) match {
      case Unsupported(reason) => return Unsupported(reason)
      case Supported(required) =>
        for (((letters, tape), lane) <-
               required.zip(outputTapes).zipWithIndex)
          if (!letters.forall(tape.alphabet.contains))
            return Unsupported(
              "extractor lane " + lane +
              " can emit a character outside its tape alphabet")
    }

    val fullChunkCount = BigInt(sourceAlphabet.size).pow(outputTapes.size)
    if (fullChunkCount > MaxSourceChunks)
      return Unsupported("the extractor source-block alphabet is too large")

    Supported(build(source, sourceAlphabet, outputTapes, stop, provenance))
  }

  private def build(source : AtomicStateAutomaton,
                    sourceAlphabet : Vector[Int],
                    outputTapes : Vector[Tape],
                    stop : Int,
                    provenance : Seq[Provenance]) : SynchronizedRelation = {
    val period = outputTapes.size
    val schema = RelationSchema(outputTapes)
    val codec = new ConvolutionCodec(schema)
    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)

    val normalStates = new MHashMap[(source.State, Int), BricsAutomaton#State]
    for (sourceState <- source.states; mask <- 0 until (1 << period)) {
      val state = if (sourceState == source.initialState && mask == 0)
                    builder.initialState
                  else
                    builder.getNewState
      normalStates.put((sourceState, mask), state)
      builder.setAccept(state, source.isAccept(sourceState))
    }
    val finalState = builder.getNewState
    builder.setAccept(finalState, true)

    val epsilons =
      new MHashMap[BricsAutomaton#State, MSet[BricsAutomaton#State]]
          with MultiMap[BricsAutomaton#State, BricsAutomaton#State]

    def step(state : source.State, character : Int)
        : Option[source.State] = {
      val destinations = source.outgoingTransitions(state).collect {
        case (destination, label)
            if source.LabelOps.labelContains(character.toChar, label) =>
          destination
      }.toVector.distinct
      destinations.headOption
    }

    def simulate(state : source.State,
                 mask : Int,
                 letters : Vector[Int])
        : Option[(source.State, Int, Column)] = {
      var current = state
      var drained = mask
      val output = Array.fill[Option[Int]](period)(None)
      var lane = 0
      while (lane < letters.size) {
        step(current, letters(lane)) match {
          case Some(next) => current = next
          case None       => return None
        }
        if ((drained & (1 << lane)) == 0) {
          if (letters(lane) == stop)
            drained |= (1 << lane)
          else
            output(lane) = Some(letters(lane))
        }
        lane += 1
      }
      Some((current, drained, output.toVector))
    }

    def add(sourceState : BricsAutomaton#State,
            column : Column,
            targetState : BricsAutomaton#State) : Unit =
      if (column.forall(_.isEmpty))
        epsilons.addBinding(sourceState, targetState)
      else
        builder.addTransition(
          sourceState, BricsTLabelOps.singleton(codec.encode(column)), targetState)

    def laneAlphabets(mask : Int, length : Int) =
      (0 until length).map { lane =>
        if ((mask & (1 << lane)) != 0)
          sourceAlphabet
        else
          (outputTapes(lane).alphabet.filter(sourceAlphabet.contains) :+
           stop).distinct.sorted
      }.toVector

    for (sourceState <- source.states; mask <- 0 until (1 << period)) {
      Timeout.check
      val from = normalStates((sourceState, mask))
      for (letters <- words(laneAlphabets(mask, period));
           (target, nextMask, column) <- simulate(sourceState, mask, letters))
        add(from, column, normalStates((target, nextMask)))

      for (length <- 1 until period;
           letters <- words(laneAlphabets(mask, length));
           (target, _, column) <- simulate(sourceState, mask, letters);
           if source.isAccept(target))
        add(from, column, finalState)
    }

    AutomataUtils.buildEpsilons(builder, epsilons)
    SynchronizedRelation.fromAutomaton(
      schema, builder.getAutomaton, provenance)
  }

  private def words(alphabets : Vector[Vector[Int]])
      : Iterator[Vector[Int]] = {
    if (alphabets.isEmpty)
      Iterator(Vector.empty)
    else
      for (character <- alphabets.head.iterator;
           suffix <- words(alphabets.tail))
      yield character +: suffix
  }
}
