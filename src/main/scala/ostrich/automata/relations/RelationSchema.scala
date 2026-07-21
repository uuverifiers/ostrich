/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
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
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED.
 */

package ostrich.automata.relations

import scala.collection.mutable.ArrayBuffer

/** One named string tape over an explicit finite alphabet. */
case class Tape(name : String, alphabet : Vector[Int]) {
  require(name.nonEmpty, "a tape name must not be empty")
  require(alphabet.nonEmpty, "a tape alphabet must not be empty")
  require(alphabet == alphabet.distinct.sorted,
          "a tape alphabet must be sorted and duplicate-free")
  require(alphabet.forall(c => c >= Char.MinValue.toInt &&
                                c <= Char.MaxValue.toInt),
          "tape characters must fit the OSTRICH alphabet")
}

/** An ordered collection of uniquely named tapes. */
case class RelationSchema(tapes : Vector[Tape]) {
  require(tapes.nonEmpty, "a relation schema needs at least one tape")
  require(names.distinct.size == names.size, "tape names must be unique")

  lazy val names : Vector[String] = tapes.map(_.name)
  val arity : Int = tapes.size

  def index(name : String) : Int = {
    val result = names.indexOf(name)
    if (result < 0)
      throw new NoSuchElementException("unknown tape " + name)
    result
  }

  def tape(name : String) : Tape = tapes(index(name))

  /** Preserve this order and append right-only tapes deterministically. */
  def merge(other : RelationSchema) : RelationSchema = {
    val merged = ArrayBuffer[Tape]() ++= tapes
    for (candidate <- other.tapes) {
      names.indexOf(candidate.name) match {
        case -1 => merged += candidate
        case index if tapes(index).alphabet != candidate.alphabet =>
          throw new IllegalArgumentException(
            "incompatible alphabets for shared tape " + candidate.name)
        case _ =>
      }
    }
    RelationSchema(merged.toVector)
  }

  def project(selectedNames : Seq[String]) : RelationSchema = {
    val selected = selectedNames.toVector
    require(selected.nonEmpty, "a projected schema needs at least one tape")
    require(selected.distinct.size == selected.size,
            "projected tape names must be unique")
    RelationSchema(selected.map(tape))
  }

  def rename(mapping : Map[String, String]) : RelationSchema = {
    val unknown = mapping.keySet -- names
    require(unknown.isEmpty,
            "cannot rename unknown tapes: " + unknown.toVector.sorted.mkString(", "))
    RelationSchema(tapes.map(tape =>
      Tape(mapping.getOrElse(tape.name, tape.name), tape.alphabet)))
  }

  def isCompatibleSupersetOf(other : RelationSchema) : Boolean =
    other.tapes.forall { candidate =>
      names.indexOf(candidate.name) match {
        case -1    => false
        case index => tapes(index).alphabet == candidate.alphabet
      }
    }
}

/**
 * Canonical right-padded convolution encoding.
 *
 * Padding is represented by `None`, so it cannot collide with an OSTRICH
 * character. The all-padding column is omitted and therefore has no code.
 */
class ConvolutionCodec(val schema : RelationSchema) {
  import ConvolutionCodec.Column

  private val columnCount = schema.tapes.foldLeft(BigInt(1)) {
    case (count, tape) => count * (tape.alphabet.size + 1)
  } - 1

  require(columnCount <= Char.MaxValue.toInt + 1,
          "the convolution alphabet does not fit in a BRICS Char")

  val columns : Vector[Column] = {
    val result = Vector.newBuilder[Column]

    def enumerate(index : Int, prefix : Vector[Option[Int]]) : Unit =
      if (index == schema.arity) {
        if (prefix.exists(_.nonEmpty))
          result += prefix
      } else {
        for (character <- schema.tapes(index).alphabet)
          enumerate(index + 1, prefix :+ Some(character))
        enumerate(index + 1, prefix :+ None)
      }

    enumerate(0, Vector.empty)
    result.result()
  }

  private val columnToSymbol : Map[Column, Char] =
    columns.iterator.zipWithIndex.map {
      case (column, index) => column -> index.toChar
    }.toMap

  def size : Int = columns.size

  def encode(column : Column) : Char =
    columnToSymbol.getOrElse(column,
      throw new IllegalArgumentException(
        "column is outside the relation schema: " + column))

  def decode(symbol : Int) : Column = {
    if (symbol < 0 || symbol >= columns.size)
      throw new IllegalArgumentException(
        "unknown convolution symbol: " + symbol)
    columns(symbol)
  }

  def convolve(values : Map[String, Seq[Int]]) : Vector[Int] = {
    val missing = schema.names.toSet -- values.keySet
    val extra = values.keySet -- schema.names
    require(missing.isEmpty && extra.isEmpty,
            "tuple keys do not match the relation schema")

    val words = schema.tapes.map { tape =>
      val word = values(tape.name).toVector
      require(word.forall(tape.alphabet.contains),
              "word on tape " + tape.name + " contains an invalid character")
      word
    }
    val maxLength = if (words.isEmpty) 0 else words.map(_.size).max

    (for (offset <- 0 until maxLength) yield {
      val column = words.map(word =>
        if (offset < word.size) Some(word(offset)) else None)
      encode(column).toInt
    }).toVector
  }

  def decodeWord(symbols : Seq[Int]) : Map[String, Vector[Int]] = {
    val words = Array.fill(schema.arity)(Vector.newBuilder[Int])
    val ended = Array.fill(schema.arity)(false)

    for (symbol <- symbols) {
      val column = decode(symbol)
      for ((letter, index) <- column.zipWithIndex) letter match {
        case None =>
          ended(index) = true
        case Some(_) if ended(index) =>
          throw new IllegalArgumentException(
            "non-padding character occurs after padding")
        case Some(character) =>
          words(index) += character
      }
    }

    schema.tapes.zip(words).map {
      case (tape, word) => tape.name -> word.result()
    }.toMap
  }
}

object ConvolutionCodec {
  type Column = Vector[Option[Int]]
}
