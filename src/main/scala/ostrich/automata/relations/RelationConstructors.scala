/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.automata.relations

import ostrich.automata.{AtomicStateAutomaton, BricsAutomatonBuilder,
                        BricsTLabelOps}

import scala.collection.mutable.{HashMap => MHashMap, Queue}

object RelationConstructors {
  import ConvolutionCodec.Column

  /** Lift one existing unary automaton onto a named relation tape. */
  def unary(tape : Tape,
            source : AtomicStateAutomaton,
            provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation = {
    val schema = RelationSchema(Vector(tape))
    val codec = new ConvolutionCodec(schema)
    val builder = new BricsAutomatonBuilder
    val stateMap = source.states.map { state =>
      val target = if (state == source.initialState)
                     builder.initialState
                   else
                     builder.getNewState
      state -> target
    }.toMap

    for (state <- source.states)
      builder.setAccept(stateMap(state), source.isAccept(state))
    for ((from, label, to) <- source.transitions;
         character <- tape.alphabet;
         if source.LabelOps.labelContains(character.toChar, label))
      builder.addTransition(
        stateMap(from),
        BricsTLabelOps.singleton(codec.encode(Vector(Some(character)))),
        stateMap(to))

    SynchronizedRelation.fromAutomaton(
      schema, builder.getAutomaton, provenance)
  }

  /** Construct the relation `left = prefix ++ right`. */
  def fixedPrefix(left : Tape,
                  right : Tape,
                  prefix : Seq[Int],
                  provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation = {
    requireSameAlphabet(left, right)
    require(prefix.forall(left.alphabet.contains),
            "the prefix contains a character outside the tape alphabet")
    val schema = RelationSchema(Vector(left, right))

    stateMachine[Vector[Int]](
      schema,
      prefix.toVector,
      _.isEmpty,
      { case (queue, column) =>
        val expected = column(1) match {
          case Some(character) => queue :+ character
          case None            => queue
        }
        (column(0), expected.headOption) match {
          case (Some(actual), Some(wanted)) if actual == wanted =>
            Some(expected.tail)
          case _ => None
        }
      },
      provenance)
  }

  /** Construct the relation `left = right ++ suffix`. */
  def fixedSuffix(left : Tape,
                  right : Tape,
                  suffix : Seq[Int],
                  provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation = {
    requireSameAlphabet(left, right)
    require(suffix.forall(left.alphabet.contains),
            "the suffix contains a character outside the tape alphabet")
    val schema = RelationSchema(Vector(left, right))
    val suffixVector = suffix.toVector
    val Comparing = -1

    stateMachine[Int](
      schema,
      Comparing,
      state => (state == Comparing && suffixVector.isEmpty) ||
               state == suffixVector.size,
      { case (state, column) =>
        val leftLetter = column(0)
        val rightLetter = column(1)
        if (state == Comparing && rightLetter.nonEmpty) {
          if (leftLetter == rightLetter) Some(Comparing) else None
        } else if (rightLetter.nonEmpty || leftLetter.isEmpty) {
          None
        } else {
          val index = if (state == Comparing) 0 else state
          if (index < suffixVector.size &&
              leftLetter.contains(suffixVector(index)))
            Some(index + 1)
          else
            None
        }
      },
      provenance)
  }

  def equality(left : Tape,
               right : Tape,
               provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation =
    fixedPrefix(left, right, Vector.empty, provenance)

  def disequality(left : Tape,
                  right : Tape,
                  provenance : Seq[Provenance] = Vector.empty)
      : SynchronizedRelation =
    equality(left, right, provenance).complement

  private def requireSameAlphabet(left : Tape, right : Tape) : Unit =
    require(left.alphabet == right.alphabet,
            "both relation tapes need the same alphabet")

  private def stateMachine[S](
      schema : RelationSchema,
      initial : S,
      accepting : S => Boolean,
      step : (S, Column) => Option[S],
      provenance : Seq[Provenance]) : SynchronizedRelation = {
    val codec = new ConvolutionCodec(schema)
    val builder = new BricsAutomatonBuilder
    val states = new MHashMap[S, ostrich.automata.BricsAutomaton#State]
    val queue = new Queue[S]
    states.put(initial, builder.initialState)
    queue.enqueue(initial)

    while (queue.nonEmpty) {
      val state = queue.dequeue()
      val source = states(state)
      builder.setAccept(source, accepting(state))
      for (column <- codec.columns; targetState <- step(state, column)) {
        val target = states.getOrElseUpdate(targetState, {
          queue.enqueue(targetState)
          builder.getNewState
        })
        builder.addTransition(
          source, BricsTLabelOps.singleton(codec.encode(column)), target)
      }
    }

    SynchronizedRelation.fromAutomaton(
      schema, builder.getAutomaton, provenance)
  }
}
