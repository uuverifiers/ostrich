/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.automata.relations

import dk.brics.automaton.{State => BState}
import ostrich.automata.{AutomataUtils, BricsAutomaton,
                        BricsAutomatonBuilder, BricsTLabelOps}

import scala.collection.mutable.{HashMap => MHashMap, HashSet => MHashSet,
                                 MultiMap, Queue, Set => MSet}

/** A total letter-to-word homomorphism between two relation tapes. */
case class TapeHomomorphism(source : Tape,
                            target : Tape,
                            images : Map[Int, Vector[Int]]) {
  require(images.keySet == source.alphabet.toSet,
          "a tape homomorphism must cover exactly the source alphabet")
  require(images.valuesIterator.flatten.forall(target.alphabet.contains),
          "a tape homomorphism image is outside the target alphabet")

  def apply(word : Seq[Int]) : Vector[Int] = {
    require(word.forall(source.alphabet.contains),
            "a homomorphism input is outside the source alphabet")
    word.iterator.flatMap(images).toVector
  }
}

/** Exact componentwise image under a checked convolution-column condition. */
object SynchronizedHomomorphicImage {

  def apply(relation : SynchronizedRelation,
            homomorphisms : Vector[TapeHomomorphism],
            provenance : Seq[Provenance] = Vector.empty)
      : ExactResult[SynchronizedRelation] =
    try {
      compile(relation, homomorphisms, provenance)
    } catch {
      case exception : IllegalArgumentException =>
        Unsupported(exception.getMessage)
    }

  /** Recover one source tuple mapped to the supplied concrete target tuple. */
  def preimageWitness(
      relation : SynchronizedRelation,
      homomorphisms : Vector[TapeHomomorphism],
      targetValues : Map[String, Vector[Int]])
      : Option[Map[String, Vector[Int]]] = {
    val byName = homomorphisms.groupBy(_.source.name)
    if (byName.exists(_._2.size != 1) ||
        byName.keySet != relation.schema.names.toSet)
      return None

    val ordered = relation.schema.tapes.map { tape =>
      val homomorphism = byName(tape.name).head
      if (homomorphism.source != tape)
        return None
      homomorphism
    }
    if (ordered.map(_.target.name).distinct.size != ordered.size)
      return None
    val targets = ordered.map(homomorphism =>
      targetValues.get(homomorphism.target.name))
    if (targets.exists(_.isEmpty))
      return None
    val words = targets.flatten
    if (words.zip(ordered).exists { case (word, homomorphism) =>
          word.exists(character =>
            !homomorphism.target.alphabet.contains(character))
        })
      return None

    val automaton = relation.automaton
    case class SearchState(state : automaton.State,
                           positions : Vector[Int])
    val initial = SearchState(
      automaton.initialState, Vector.fill(ordered.size)(0))
    val queue = Queue[SearchState](initial)
    val witnesses = new MHashMap[SearchState, Vector[Vector[Int]]]
    witnesses.put(initial, Vector.fill(ordered.size)(Vector.empty))

    while (queue.nonEmpty) {
      val current = queue.dequeue()
      val sourceWords = witnesses(current)
      if (automaton.isAccept(current.state) &&
          current.positions.zip(words).forall {
            case (position, word) => position == word.size
          })
        return Some(relation.schema.names.zip(sourceWords).toMap)

      for ((destination, label) <-
             automaton.outgoingTransitions(current.state)) {
        val lower = math.max(0, label._1.toInt)
        val upper = math.min(relation.codec.size - 1, label._2.toInt)
        for (symbol <- lower to upper) {
          val column = relation.codec.decode(symbol)
          val nextPositions = Vector.newBuilder[Int]
          val nextWords = Vector.newBuilder[Vector[Int]]
          var valid = true
          var index = 0
          while (valid && index < ordered.size) {
            column(index) match {
              case None =>
                nextPositions += current.positions(index)
                nextWords += sourceWords(index)
              case Some(character) =>
                val image = ordered(index).images(character)
                val position = current.positions(index)
                val target = words(index)
                if (position + image.size > target.size ||
                    target.slice(position, position + image.size) != image) {
                  valid = false
                } else {
                  nextPositions += position + image.size
                  nextWords += (sourceWords(index) :+ character)
                }
            }
            index += 1
          }
          if (valid) {
            val next = SearchState(destination, nextPositions.result())
            if (!witnesses.contains(next)) {
              witnesses.put(next, nextWords.result())
              queue.enqueue(next)
            }
          }
        }
      }
    }
    None
  }

  private def compile(
      relation : SynchronizedRelation,
      homomorphisms : Vector[TapeHomomorphism],
      provenance : Seq[Provenance]) : ExactResult[SynchronizedRelation] = {
    val byName = homomorphisms.groupBy(_.source.name)
    if (byName.exists(_._2.size != 1))
      return Unsupported("multiple homomorphisms were supplied for one tape")
    if (byName.keySet != relation.schema.names.toSet)
      return Unsupported("homomorphisms do not match the relation tapes")

    val ordered = relation.schema.tapes.map { tape =>
      val homomorphism = byName(tape.name).head
      if (homomorphism.source != tape)
        return Unsupported(
          "a homomorphism source alphabet does not match its relation tape")
      homomorphism
    }
    val targetSchema = RelationSchema(ordered.map(_.target))
    val sourceCodec = relation.codec
    val targetCodec = new ConvolutionCodec(targetSchema)
    val automaton = relation.automaton
    val (reachable, coreachable) = productiveStateSets(automaton)

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
      new MHashMap[BState, MSet[BState]] with MultiMap[BState, BState]

    for ((source, label, destination) <- automaton.transitions;
         if reachable(source) && coreachable(destination)) {
      val lower = math.max(0, label._1.toInt)
      val upper = math.min(sourceCodec.size - 1, label._2.toInt)
      for (symbol <- lower to upper) {
        outputBlock(sourceCodec.decode(symbol), ordered) match {
          case Left(reason) => return Unsupported(reason)
          case Right(block) if block.isEmpty =>
            epsilons.addBinding(stateMap(source), stateMap(destination))
          case Right(block) =>
            var current = stateMap(source)
            for ((column, index) <- block.zipWithIndex) {
              val next = if (index == block.size - 1)
                           stateMap(destination)
                         else
                           builder.getNewState
              builder.addTransition(
                current,
                BricsTLabelOps.singleton(targetCodec.encode(column)),
                next)
              current = next
            }
        }
      }
    }

    AutomataUtils.buildEpsilons(builder, epsilons)
    val description = ordered.map { homomorphism =>
      val mapping = homomorphism.images.toVector.sortBy(_._1).map {
        case (letter, image) => letter + "->" + image.mkString("[", ",", "]")
      }.mkString(",")
      homomorphism.source.name + "->" + homomorphism.target.name +
        "{" + mapping + "}"
    }.mkString("; ")
    Supported(SynchronizedRelation.fromAutomaton(
      targetSchema,
      builder.getAutomaton,
      Provenance.merge(
        relation.provenance,
        provenance,
        Vector(Provenance(
          "column-synchronized homomorphic image", description)))))
  }

  private def productiveStateSets(automaton : BricsAutomaton)
      : (Set[BState], Set[BState]) = {
    val reachable = MHashSet[BState](automaton.initialState)
    val queue = Queue[BState](automaton.initialState)
    while (queue.nonEmpty) {
      val state = queue.dequeue()
      for ((target, _) <- automaton.outgoingTransitions(state);
           if reachable.add(target))
        queue.enqueue(target)
    }

    val incoming =
      new MHashMap[BState, MSet[BState]] with MultiMap[BState, BState]
    for ((source, _, target) <- automaton.transitions)
      incoming.addBinding(target, source)
    val coreachable = MHashSet[BState]() ++
      automaton.states.filter(automaton.isAccept)
    queue ++= coreachable
    while (queue.nonEmpty) {
      val state = queue.dequeue()
      for (source <- incoming.getOrElse(state, MSet.empty[BState]);
           if coreachable.add(source))
        queue.enqueue(source)
    }
    (reachable.toSet, coreachable.toSet)
  }

  private def outputBlock(
      column : ConvolutionCodec.Column,
      homomorphisms : Vector[TapeHomomorphism])
      : Either[String, Vector[ConvolutionCodec.Column]] = {
    val images = column.zip(homomorphisms).map {
      case (None, _) => None
      case (Some(letter), homomorphism) => Some(homomorphism.images(letter))
    }
    val lengths = images.flatten.map(_.size)
    if (lengths.distinct.size > 1)
      return Left(
        "a productive convolution column is not synchronized: " +
        "active image lengths=" + lengths.mkString("[", ",", "]"))

    val length = lengths.headOption.getOrElse(0)
    Right(Vector.tabulate(length) { offset =>
      images.map(_.map(_(offset)))
    })
  }
}
