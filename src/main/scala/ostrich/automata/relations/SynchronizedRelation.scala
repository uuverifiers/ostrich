/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.automata.relations

import dk.brics.automaton.{Automaton => BAutomaton, State => BState}
import ostrich.automata.{AutomataUtils, BricsAutomaton,
                        BricsAutomatonBuilder, BricsTLabelOps}

import scala.collection.mutable.{HashMap => MHashMap, MultiMap, Queue,
                                 Set => MSet}

/**
 * An exact synchronized relation represented by a BRICS automaton over
 * encoded convolution columns.
 *
 * This class deliberately does not extend OSTRICH's unary `Automaton` or
 * `Transducer` interfaces. Its schema is part of its semantics.
 */
class SynchronizedRelation private[relations] (
    val schema : RelationSchema,
    val automaton : BricsAutomaton,
    val provenance : Vector[Provenance]) {

  lazy val codec = new ConvolutionCodec(schema)

  def stateCount : Int = automaton.states.size
  def transitionCount : Int = automaton.transitions.size
  def isEmpty : Boolean = automaton.isEmpty

  def accepts(values : Map[String, Seq[Int]]) : Boolean =
    automaton(codec.convolve(values))

  def shortestWitness : Option[Map[String, Vector[Int]]] =
    automaton.getAcceptedWord.map(codec.decodeWord)

  def homomorphicImage(
      homomorphisms : Vector[TapeHomomorphism],
      additionalProvenance : Seq[Provenance] = Vector.empty)
      : ExactResult[SynchronizedRelation] =
    SynchronizedHomomorphicImage(
      this, homomorphisms, additionalProvenance)

  /** Re-encode this relation over larger alphabets without changing tuples. */
  def widenAlphabets(targetSchema : RelationSchema) : SynchronizedRelation = {
    require(targetSchema.names == schema.names,
            "alphabet widening must preserve tape names and order")
    require(schema.tapes.zip(targetSchema.tapes).forall {
      case (source, target) => source.alphabet.forall(target.alphabet.contains)
    }, "target alphabets must contain the current tape alphabets")
    if (targetSchema == schema)
      return this

    val targetCodec = new ConvolutionCodec(targetSchema)
    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)
    val stateMap = automaton.states.map { state =>
      val target = if (state == automaton.initialState)
                     builder.initialState
                   else
                     builder.getNewState
      state -> target
    }.toMap
    for (state <- automaton.states)
      builder.setAccept(stateMap(state), automaton.isAccept(state))
    for ((source, label, destination) <- automaton.transitions) {
      val lower = math.max(0, label._1.toInt)
      val upper = math.min(codec.size - 1, label._2.toInt)
      for (symbol <- lower to upper)
        builder.addTransition(
          stateMap(source),
          BricsTLabelOps.singleton(
            targetCodec.encode(codec.decode(symbol))),
          stateMap(destination))
    }
    SynchronizedRelation.fromAutomaton(
      targetSchema, builder.getAutomaton, provenance)
  }

  /** Lift to a compatible schema, aligning shared tapes by name. */
  def align(targetSchema : RelationSchema) : SynchronizedRelation = {
    require(targetSchema.isCompatibleSupersetOf(schema),
            "target schema is not a compatible tape superset")
    if (targetSchema == schema)
      return this

    val targetCodec = new ConvolutionCodec(targetSchema)
    val sourcePositions = schema.names.map(targetSchema.index)
    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)
    val stateMap = automaton.states.map { state =>
      val target = if (state == automaton.initialState)
                     builder.initialState
                   else
                     builder.getNewState
      state -> target
    }.toMap

    for (state <- automaton.states)
      builder.setAccept(stateMap(state), automaton.isAccept(state))

    for (state <- automaton.states; targetColumn <- targetCodec.columns) {
      val sourceColumn = sourcePositions.map(targetColumn)
      val targetLabel = BricsTLabelOps.singleton(targetCodec.encode(targetColumn))
      if (sourceColumn.forall(_.isEmpty)) {
        builder.addTransition(stateMap(state), targetLabel, stateMap(state))
      } else {
        val sourceSymbol = codec.encode(sourceColumn)
        for ((destination, label) <- automaton.outgoingTransitions(state);
             if automaton.LabelOps.labelContains(sourceSymbol, label))
          builder.addTransition(stateMap(state), targetLabel,
                                stateMap(destination))
      }
    }

    SynchronizedRelation.normalized(
      targetSchema,
      SynchronizedRelation.intersect(
        builder.getAutomaton,
        SynchronizedRelation.wellFormed(targetSchema)),
      provenance)
  }

  def rename(mapping : Map[String, String]) : SynchronizedRelation =
    SynchronizedRelation.normalized(schema.rename(mapping), automaton, provenance)

  def join(other : SynchronizedRelation) : SynchronizedRelation = {
    val mergedSchema = schema.merge(other.schema)
    if (mergedSchema == schema && mergedSchema == other.schema)
      return SynchronizedRelation.normalized(
        mergedSchema,
        SynchronizedRelation.intersect(automaton, other.automaton),
        Provenance.merge(provenance, other.provenance))

    val mergedCodec = new ConvolutionCodec(mergedSchema)
    val leftPositions = schema.names.map(mergedSchema.index)
    val rightPositions = other.schema.names.map(mergedSchema.index)
    val leftAutomaton = automaton
    val rightAutomaton = other.automaton
    case class JoinState(left : Set[leftAutomaton.State],
                         right : Set[rightAutomaton.State],
                         ended : Int)

    def leftNext(states : Set[leftAutomaton.State],
                 column : ConvolutionCodec.Column)
        : Option[Set[leftAutomaton.State]] = {
      val projected = leftPositions.map(column)
      if (projected.forall(_.isEmpty))
        Some(states)
      else {
        val symbol = codec.encode(projected)
        val destinations = states.iterator.flatMap(state =>
          leftAutomaton.outgoingTransitions(state).collect {
            case (destination, label)
                if leftAutomaton.LabelOps.labelContains(symbol, label) =>
              destination
          }).toSet
        if (destinations.isEmpty) None else Some(destinations)
      }
    }

    def rightNext(states : Set[rightAutomaton.State],
                  column : ConvolutionCodec.Column)
        : Option[Set[rightAutomaton.State]] = {
      val projected = rightPositions.map(column)
      if (projected.forall(_.isEmpty))
        Some(states)
      else {
        val symbol = other.codec.encode(projected)
        val destinations = states.iterator.flatMap(state =>
          rightAutomaton.outgoingTransitions(state).collect {
            case (destination, label)
                if rightAutomaton.LabelOps.labelContains(symbol, label) =>
              destination
          }).toSet
        if (destinations.isEmpty) None else Some(destinations)
      }
    }

    def advancePadding(mask : Int, column : ConvolutionCodec.Column)
        : Option[Int] = {
      var next = mask
      var index = 0
      while (index < column.size) {
        column(index) match {
          case Some(_) if (mask & (1 << index)) != 0 => return None
          case None => next |= (1 << index)
          case _ =>
        }
        index += 1
      }
      Some(next)
    }

    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)
    val initial = JoinState(
      Set(leftAutomaton.initialState), Set(rightAutomaton.initialState), 0)
    val states = new MHashMap[JoinState, BricsAutomaton#State]
    states.put(initial, builder.initialState)
    val queue = Queue[JoinState](initial)

    while (queue.nonEmpty) {
      val current = queue.dequeue()
      val source = states(current)
      builder.setAccept(
        source,
        current.left.exists(leftAutomaton.isAccept) &&
        current.right.exists(rightAutomaton.isAccept))
      for (column <- mergedCodec.columns;
           nextMask <- advancePadding(current.ended, column);
           nextLeft <- leftNext(current.left, column);
           nextRight <- rightNext(current.right, column)) {
        val next = JoinState(nextLeft, nextRight, nextMask)
        val destination = states.getOrElseUpdate(next, {
          queue.enqueue(next)
          builder.getNewState
        })
        builder.addTransition(
          source,
          BricsTLabelOps.singleton(mergedCodec.encode(column)),
          destination)
      }
    }

    SynchronizedRelation.normalized(
      mergedSchema,
      builder.getAutomaton,
      Provenance.merge(provenance, other.provenance))
  }

  def union(other : SynchronizedRelation) : SynchronizedRelation = {
    require(schema.names.toSet == other.schema.names.toSet,
            "union requires the same set of tapes")
    val aligned = other.align(schema)
    SynchronizedRelation.normalized(
      schema,
      SynchronizedRelation.union(automaton, aligned.automaton),
      Provenance.merge(provenance, other.provenance))
  }

  /** Complement relative to the well-formed convolutions of this schema. */
  def complement : SynchronizedRelation = {
    val complemented = (!automaton).asInstanceOf[BricsAutomaton]
    SynchronizedRelation.normalized(
      schema,
      SynchronizedRelation.intersect(
        complemented, SynchronizedRelation.wellFormed(schema)),
      provenance)
  }

  /** Existentially eliminate every tape not listed in `selectedNames`. */
  def project(selectedNames : Seq[String]) : SynchronizedRelation = {
    val targetSchema = schema.project(selectedNames)
    if (targetSchema == schema)
      return this

    val targetCodec = new ConvolutionCodec(targetSchema)
    val positions = targetSchema.names.map(schema.index)
    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)
    val stateMap = automaton.states.map { state =>
      val target = if (state == automaton.initialState)
                     builder.initialState
                   else
                     builder.getNewState
      state -> target
    }.toMap
    for (state <- automaton.states)
      builder.setAccept(stateMap(state), automaton.isAccept(state))

    val epsilons =
      new MHashMap[BricsAutomaton#State, MSet[BricsAutomaton#State]]
          with MultiMap[BricsAutomaton#State, BricsAutomaton#State]

    for ((source, label, destination) <- automaton.transitions) {
      val lower = math.max(0, label._1.toInt)
      val upper = math.min(codec.size - 1, label._2.toInt)
      for (symbol <- lower to upper) {
        val sourceColumn = codec.decode(symbol)
        val targetColumn = positions.map(sourceColumn)
        if (targetColumn.forall(_.isEmpty)) {
          epsilons.addBinding(stateMap(source), stateMap(destination))
        } else {
          builder.addTransition(
            stateMap(source),
            BricsTLabelOps.singleton(targetCodec.encode(targetColumn)),
            stateMap(destination))
        }
      }
    }

    AutomataUtils.buildEpsilons(builder, epsilons)
    SynchronizedRelation.fromAutomaton(
      targetSchema, builder.getAutomaton, provenance)
  }

  /**
   * Project to one tape and decode convolution symbols to string characters.
   * The returned automaton is an ordinary OSTRICH unary language.
   */
  def unaryProjection(tapeName : String) : BricsAutomaton = {
    val projected = project(Vector(tapeName))
    val tape = projected.schema.tapes.head
    val projectedCodec = projected.codec
    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)
    val stateMap = projected.automaton.states.map { state =>
      val target = if (state == projected.automaton.initialState)
                     builder.initialState
                   else
                     builder.getNewState
      state -> target
    }.toMap

    for (state <- projected.automaton.states)
      builder.setAccept(stateMap(state), projected.automaton.isAccept(state))
    for ((source, label, destination) <- projected.automaton.transitions) {
      val lower = math.max(0, label._1.toInt)
      val upper = math.min(projectedCodec.size - 1, label._2.toInt)
      for (symbol <- lower to upper) {
        val character = projectedCodec.decode(symbol).head.getOrElse(
          throw new IllegalStateException(
            "a unary convolution column cannot be all-padding"))
        require(tape.alphabet.contains(character),
                "decoded character is outside the projected tape alphabet")
        builder.addTransition(
          stateMap(source), BricsTLabelOps.singleton(character.toChar),
          stateMap(destination))
      }
    }
    builder.getAutomaton
  }
}

object SynchronizedRelation {

  private val wellFormedCache =
    new MHashMap[RelationSchema, BricsAutomaton]

  def fromAutomaton(schema : RelationSchema,
                    automaton : BricsAutomaton,
                    provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation =
    normalized(schema,
               intersect(automaton, wellFormed(schema)),
               provenance)

  def universal(schema : RelationSchema,
                provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation =
    normalized(schema, wellFormed(schema), provenance)

  def empty(schema : RelationSchema,
            provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation =
    normalized(schema, BricsAutomaton.makeEmptyLang(), provenance)

  /** Natural join all components in one reachable-state product. */
  def joinAll(relations : Vector[SynchronizedRelation])
      : SynchronizedRelation = {
    require(relations.nonEmpty, "a multiway join needs at least one relation")
    if (relations.size == 1)
      return relations.head

    val schema = relations.tail.foldLeft(relations.head.schema) {
      case (current, relation) => current.merge(relation.schema)
    }
    val codec = new ConvolutionCodec(schema)
    val positions = relations.map(relation =>
      relation.schema.names.map(schema.index))

    case class PreparedColumn(symbol : Char,
                              projections : Vector[Option[Char]],
                              realMask : Int,
                              paddingMask : Int)
    val columns = codec.columns.map { column =>
      var realMask = 0
      var paddingMask = 0
      for ((letter, index) <- column.zipWithIndex)
        if (letter.isDefined)
          realMask |= (1 << index)
        else
          paddingMask |= (1 << index)
      val projections = relations.zip(positions).map {
        case (relation, relationPositions) =>
          val projected = relationPositions.map(column)
          if (projected.forall(_.isEmpty)) None
          else Some(relation.codec.encode(projected))
      }
      PreparedColumn(codec.encode(column), projections,
                     realMask, paddingMask)
    }

    case class ProductState(states : Vector[Set[BState]], ended : Int)
    val initial = ProductState(
      relations.map(relation => Set(relation.automaton.initialState)), 0)
    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)
    val stateMap = new MHashMap[ProductState, BricsAutomaton#State]
    stateMap.put(initial, builder.initialState)
    val queue = Queue[ProductState](initial)
    val transitionCache =
      new MHashMap[(Int, Set[BState], Char), Set[BState]]

    def next(component : Int, states : Set[BState], symbol : Option[Char])
        : Option[Set[BState]] = symbol match {
      case None => Some(states)
      case Some(character) =>
        val destinations = transitionCache.getOrElseUpdate(
          (component, states, character), {
          val automaton = relations(component).automaton
          states.iterator.flatMap(state =>
            automaton.outgoingTransitions(state).collect {
              case (destination, label)
                  if automaton.LabelOps.labelContains(character, label) =>
                destination
            }).toSet
        })
        if (destinations.isEmpty) None else Some(destinations)
    }

    while (queue.nonEmpty) {
      val current = queue.dequeue()
      val source = stateMap(current)
      builder.setAccept(source, relations.zip(current.states).forall {
        case (relation, states) => states.exists(relation.automaton.isAccept)
      })

      for (column <- columns;
           if (current.ended & column.realMask) == 0) {
        val nextStates = Vector.newBuilder[Set[BState]]
        var valid = true
        var component = 0
        while (valid && component < relations.size) {
          next(component, current.states(component),
               column.projections(component)) match {
            case Some(state) => nextStates += state
            case None        => valid = false
          }
          component += 1
        }
        if (valid) {
          val target = ProductState(
            nextStates.result(), current.ended | column.paddingMask)
          val destination = stateMap.getOrElseUpdate(target, {
            queue.enqueue(target)
            builder.getNewState
          })
          builder.addTransition(
            source, BricsTLabelOps.singleton(column.symbol), destination)
        }
      }
    }

    normalized(
      schema,
      builder.getAutomaton,
      Provenance.merge(relations.flatMap(_.provenance)))
  }

  /** Construct an exact finite relation, primarily useful for testing. */
  def fromTuples(schema : RelationSchema,
                 tuples : Iterable[Map[String, Seq[Int]]],
                 provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation = {
    val codec = new ConvolutionCodec(schema)
    val words = tuples.iterator.map(codec.convolve).toSet.toVector
      .sortBy((word : Vector[Int]) => word.map(_.toChar).mkString)
    val builder = new BricsAutomatonBuilder
    val states = new MHashMap[Vector[Int], BricsAutomaton#State]
    states.put(Vector.empty, builder.initialState)

    for (word <- words) {
      var prefix = Vector.empty[Int]
      var state = states(prefix)
      for (symbol <- word) {
        val nextPrefix = prefix :+ symbol
        val next = states.getOrElseUpdate(nextPrefix, builder.getNewState)
        builder.addTransition(
          state, BricsTLabelOps.singleton(symbol.toChar), next)
        prefix = nextPrefix
        state = next
      }
      builder.setAccept(state, true)
    }

    fromAutomaton(schema, builder.getAutomaton, provenance)
  }

  private[relations] def normalized(
      schema : RelationSchema,
      automaton : BricsAutomaton,
      provenance : Seq[Provenance]) : SynchronizedRelation =
    new SynchronizedRelation(
      schema, automaton, Provenance.merge(provenance))

  private[relations] def intersect(left : BricsAutomaton,
                                   right : BricsAutomaton) : BricsAutomaton =
    (left & right).asInstanceOf[BricsAutomaton]

  private[relations] def union(left : BricsAutomaton,
                               right : BricsAutomaton) : BricsAutomaton =
    (left | right).asInstanceOf[BricsAutomaton]

  private[relations] def wellFormed(schema : RelationSchema) : BricsAutomaton =
    wellFormedCache.synchronized {
      val template =
        wellFormedCache.getOrElseUpdate(schema, buildWellFormed(schema))
      new BricsAutomaton(
        template.underlying.clone().asInstanceOf[BAutomaton])
    }

  private def buildWellFormed(schema : RelationSchema) : BricsAutomaton = {
    val codec = new ConvolutionCodec(schema)
    val builder = new BricsAutomatonBuilder
    builder.setMinimize(false)
    val stateCount = 1 << schema.arity
    val states = Vector.tabulate(stateCount) { mask =>
      if (mask == 0) builder.initialState else builder.getNewState
    }
    for (state <- states)
      builder.setAccept(state, true)

    for (mask <- 0 until stateCount; column <- codec.columns) {
      var nextMask = mask
      var valid = true
      var index = 0
      while (valid && index < schema.arity) {
        val ended = (mask & (1 << index)) != 0
        column(index) match {
          case Some(_) if ended => valid = false
          case None             => nextMask |= (1 << index)
          case _                =>
        }
        index += 1
      }
      if (valid)
        builder.addTransition(
          states(mask), BricsTLabelOps.singleton(codec.encode(column)),
          states(nextMask))
    }
    builder.getAutomaton
  }
}
