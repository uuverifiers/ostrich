package ostrich.parikh.util

import ostrich.automata.Automaton
import ostrich.parikh.automata.CostEnrichedAutomatonTrait

object Print {
  def catraFormat(auts: Seq[Automaton]) = {
s"""
synchronised {
  ${auts.map(_.toString).mkString("")}
};
"""
  }

  def printFinalConstraints(
      termConstraints: Seq[Seq[CostEnrichedAutomatonTrait]]
  ) = {

    val str =
s"""
counter int ${termConstraints.flatten
          .flatMap(_.registers)
          .mkString(",")};
${termConstraints.map(catraFormat).mkString("")}
"""
    println(str)
  }
}
