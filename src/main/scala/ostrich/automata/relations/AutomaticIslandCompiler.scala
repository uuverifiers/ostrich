/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.automata.relations

import ostrich.automata.{AtomicStateAutomaton, AutomataUtils,
                        BricsAutomaton, ExtractorCertificate}

import scala.collection.mutable.{ArrayBuffer, HashSet => MHashSet, Queue}

case class IslandSource(name : String,
                        language : AtomicStateAutomaton,
                        alphabet : Vector[Int],
                        outputs : Vector[Tape],
                        certificates : Vector[ExtractorCertificate],
                        provenance : Vector[Provenance])

case class IslandUnary(tape : Tape,
                       language : AtomicStateAutomaton,
                       provenance : Vector[Provenance])

sealed trait IslandConnector {
  val left : Tape
  val right : Tape
  val provenance : Vector[Provenance]
}

case class IslandEquality(left : Tape,
                          right : Tape,
                          provenance : Vector[Provenance])
    extends IslandConnector

case class IslandDisequality(left : Tape,
                             right : Tape,
                             provenance : Vector[Provenance])
    extends IslandConnector

case class IslandPrefix(left : Tape,
                        right : Tape,
                        word : Vector[Int],
                        provenance : Vector[Provenance]) extends IslandConnector

case class IslandSuffix(left : Tape,
                        right : Tape,
                        word : Vector[Int],
                        provenance : Vector[Provenance]) extends IslandConnector

case class AutomaticIslandProblem(sources : Vector[IslandSource],
                                  unary : Vector[IslandUnary],
                                  connectors : Vector[IslandConnector])

case class RelationMetrics(name : String, states : Int, transitions : Int)

case class CompiledAutomaticIsland(relation : SynchronizedRelation,
                                   components : Vector[RelationMetrics],
                                   joins : Vector[RelationMetrics])

case class UnaryRefinement(tape : Tape, language : BricsAutomaton)

/** Pure compilation of a checked island problem into one exact relation. */
object AutomaticIslandCompiler {

  def compile(problem : AutomaticIslandProblem)
      : ExactResult[CompiledAutomaticIsland] =
    try {
      compileChecked(problem)
    } catch {
      case exception : IllegalArgumentException =>
        Unsupported(exception.getMessage)
    }

  /** Return exactly those unary projections that strengthen current facts. */
  def unaryRefinements(
      problem : AutomaticIslandProblem,
      relation : SynchronizedRelation)
      : ExactResult[Vector[UnaryRefinement]] = {
    val refinements = Vector.newBuilder[UnaryRefinement]
    for (constraint <- problem.unary) {
      val projection = relation.unaryProjection(constraint.tape.name)
      if (AutomataUtils.findAcceptedWord(
            Seq(projection), Seq(constraint.language)).nonEmpty)
        return Unsupported(
          "an island projection escaped its current unary language")
      if (AutomataUtils.findAcceptedWord(
            Seq(constraint.language), Seq(projection)).nonEmpty)
        refinements += UnaryRefinement(constraint.tape, projection)
    }
    Supported(refinements.result())
  }

  /** Recover one shortest concrete source word for every compiled cluster. */
  def sourceWitnesses(
      problem : AutomaticIslandProblem,
      outputWitness : Map[String, Vector[Int]])
      : ExactResult[Map[String, Vector[Int]]] = {
    val result = Map.newBuilder[String, Vector[Int]]
    for (source <- problem.sources)
      sourceWitness(source, outputWitness) match {
        case Some(word) => result += (source.name -> word)
        case None =>
          return Unsupported(
            "an island output witness has no compatible source word")
      }
    Supported(result.result())
  }

  private def sourceWitness(
      source : IslandSource,
      outputWitness : Map[String, Vector[Int]])
      : Option[Vector[Int]] = {
    if (source.certificates.isEmpty ||
        source.certificates.size != source.outputs.size)
      return None

    val period = source.certificates.head.period
    if (period <= 0 ||
        source.certificates.exists(certificate =>
          certificate.period != period || certificate.phase < 0 ||
          certificate.phase >= period))
      return None

    val phaseToLane = Array.fill(period)(-1)
    for ((certificate, lane) <- source.certificates.zipWithIndex) {
      if (phaseToLane(certificate.phase) >= 0)
        return None
      phaseToLane(certificate.phase) = lane
    }
    if (phaseToLane.exists(_ < 0))
      return None

    val targets = source.outputs.map(tape => outputWitness.get(tape.name))
    if (targets.exists(_.isEmpty))
      return None
    val words = targets.flatten
    val automaton = source.language

    case class SearchState(state : automaton.State,
                           phase : Int,
                           positions : Vector[Int],
                           drained : Set[Int])

    val initial = SearchState(
      automaton.initialState, 0, Vector.fill(words.size)(0), Set.empty)
    val queue = Queue[(SearchState, Vector[Int])]((initial, Vector.empty))
    val seen = MHashSet[SearchState](initial)
    val alphabet = source.alphabet.distinct.sorted

    def complete(state : SearchState) : Boolean =
      state.positions.indices.forall(index =>
        state.positions(index) == words(index).size)

    while (queue.nonEmpty) {
      val (current, prefix) = queue.dequeue()
      if (automaton.isAccept(current.state) && complete(current))
        return Some(prefix)

      val lane = phaseToLane(current.phase)
      val certificate = source.certificates(lane)
      for (character <- alphabet;
           (nextState, label) <- automaton.outgoingTransitions(current.state);
           if automaton.LabelOps.labelContains(character.toChar, label)) {
        var positions = current.positions
        var drained = current.drained
        var valid = true
        if (!drained(lane)) {
          if (character == certificate.stop) {
            if (positions(lane) != words(lane).size)
              valid = false
            else
              drained += lane
          } else if (positions(lane) >= words(lane).size ||
                     words(lane)(positions(lane)) != character) {
            valid = false
          } else {
            positions = positions.updated(lane, positions(lane) + 1)
          }
        }
        if (valid) {
          val next = SearchState(
            nextState, (current.phase + 1) % period, positions, drained)
          if (seen.add(next))
            queue.enqueue((next, prefix :+ character))
        }
      }
    }
    None
  }

  private def compileChecked(problem : AutomaticIslandProblem)
      : ExactResult[CompiledAutomaticIsland] = {
    if (problem.sources.isEmpty)
      return Unsupported("an automatic island needs at least one source")

    val outputTapes = problem.sources.flatMap(_.outputs)
    val outputNames = outputTapes.map(_.name).toSet
    if (problem.unary.map(_.tape.name).toSet != outputNames)
      return Unsupported("every output tape needs a unary language")
    if (problem.connectors.exists(connector =>
          !outputNames(connector.left.name) ||
          !outputNames(connector.right.name)))
      return Unsupported("a connector refers to a non-output tape")

    val clusterRelations = Vector.newBuilder[(String, SynchronizedRelation)]
    val componentMetrics = Vector.newBuilder[RelationMetrics]

    for ((source, sourceIndex) <- problem.sources.zipWithIndex) {
      val seenNames = MHashSet[String]()
      val privateLanes = Vector.newBuilder[(Tape, Tape)]
      val laneTapes = source.outputs.zipWithIndex.map {
        case (tape, lane) if seenNames.add(tape.name) =>
          tape
        case (tape, lane) =>
          var suffix = 0
          var name = "__island_" + sourceIndex + "_lane_" + lane
          while (outputNames(name)) {
            suffix += 1
            name = "__island_" + sourceIndex + "_lane_" + lane +
                   "_" + suffix
          }
          val privateTape = Tape(name, tape.alphabet)
          privateLanes += ((privateTape, tape))
          privateTape
      }

      ExtractorClusterCompiler.compile(
          source.language, source.alphabet, laneTapes,
          source.certificates, source.provenance) match {
        case Unsupported(reason) => return Unsupported(reason)
        case Supported(rawCluster) =>
          componentMetrics += metrics("cluster_" + source.name, rawCluster)
          var cluster = rawCluster
          val duplicateLanes = privateLanes.result()
          for ((privateTape, publicTape) <- duplicateLanes)
            cluster = cluster.join(RelationConstructors.equality(
              privateTape, publicTape, source.provenance))
          if (duplicateLanes.nonEmpty)
            cluster = cluster.project(source.outputs.map(_.name).distinct)
          for (constraint <- problem.unary;
               if source.outputs.exists(_.name == constraint.tape.name)) {
            val unary = RelationConstructors.unary(
              constraint.tape, constraint.language, constraint.provenance)
            componentMetrics += metrics("unary_" + constraint.tape.name, unary)
            cluster = cluster.join(unary)
          }
          clusterRelations += (("cluster_" + source.name, cluster))
      }
    }

    val connectors = problem.connectors.zipWithIndex.map {
      case (connector, index) =>
      val relation = connector match {
        case IslandEquality(left, right, provenance) =>
          RelationConstructors.equality(left, right, provenance)
        case IslandDisequality(left, right, provenance) =>
          RelationConstructors.disequality(left, right, provenance)
        case IslandPrefix(left, right, word, provenance) =>
          RelationConstructors.fixedPrefix(left, right, word, provenance)
        case IslandSuffix(left, right, word, provenance) =>
          RelationConstructors.fixedSuffix(left, right, word, provenance)
      }
      val name = "connector_" + index
      componentMetrics += metrics(name, relation)
      (name, relation)
    }

    val clusters = clusterRelations.result()
    val components = (clusters ++ connectors).map(_._2)
    val joinMetrics = Vector.newBuilder[RelationMetrics]
    val relation = eliminateForEmptiness(components) match {
      case Some(emptyRelation) =>
        joinMetrics += metrics("elimination_empty", emptyRelation)
        emptyRelation
      case None =>
        val fullRelation = SynchronizedRelation.joinAll(components)
        joinMetrics += metrics("join_all", fullRelation)
        fullRelation
    }

    Supported(CompiledAutomaticIsland(
      relation, componentMetrics.result(), joinMetrics.result()))
  }

  private def metrics(name : String,
                      relation : SynchronizedRelation) : RelationMetrics =
    RelationMetrics(name, relation.stateCount, relation.transitionCount)

  /** Exact bucket elimination used only to establish global emptiness. */
  private def eliminateForEmptiness(
      components : Vector[SynchronizedRelation])
      : Option[SynchronizedRelation] = {
    val remaining = ArrayBuffer[SynchronizedRelation]() ++= components

    while (remaining.nonEmpty) {
      remaining.find(_.isEmpty) match {
        case some @ Some(_) => return some
        case None =>
      }

      val tapeNames = remaining.iterator.flatMap(_.schema.names).toSet
      val candidates = tapeNames.toVector.map { tapeName =>
        val bucket = remaining.filter(_.schema.names.contains(tapeName)).toVector
        val merged = bucket.tail.foldLeft(bucket.head.schema) {
          case (schema, relation) => schema.merge(relation.schema)
        }
        val columnCount = merged.tapes.foldLeft(BigInt(1)) {
          case (count, tape) => count * (tape.alphabet.size + 1)
        } - 1
        (columnCount, merged.arity, tapeName, bucket)
      }
      val (_, _, tapeName, bucket) = candidates.minBy {
        case (columns, arity, name, _) => (columns, arity, name)
      }

      remaining --= bucket
      val joined = SynchronizedRelation.joinAll(bucket)
      if (joined.isEmpty)
        return Some(joined)
      val retained = joined.schema.names.filterNot(_ == tapeName)
      if (retained.nonEmpty) {
        val projected = joined.project(retained)
        if (projected.isEmpty)
          return Some(projected)
        remaining += projected
      }
    }

    None
  }
}
