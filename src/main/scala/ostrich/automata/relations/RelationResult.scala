/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.automata.relations

case class Provenance(source : String, detail : String = "") {
  require(source.nonEmpty, "a provenance source must not be empty")
}

object Provenance {
  def merge(groups : Seq[Provenance]*) : Vector[Provenance] = {
    val result = Vector.newBuilder[Provenance]
    var seen = Set[Provenance]()
    for (group <- groups; item <- group; if !seen(item)) {
      seen += item
      result += item
    }
    result.result()
  }
}

sealed trait ExactResult[+A]
case class Supported[A](value : A) extends ExactResult[A]
case class Unsupported(reason : String) extends ExactResult[Nothing] {
  require(reason.nonEmpty, "an unsupported result needs a reason")
}
