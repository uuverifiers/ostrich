package ostrich.parikh.util

import ostrich.automata.Automaton
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import CostEnrichedAutomatonTrait.{getRegisters}

object Print {
  def catraFormat(auts: Seq[Automaton]): String = {
s"""
synchronised {
  ${auts.map(_.toString).mkString("")}
};
"""
  }

  def printFinalConstraints(
      termConstraints: Seq[Seq[CostEnrichedAutomatonTrait]]
  ): Unit = {

    val str =
s"""
counter int ${termConstraints.flatten
          .flatMap(getRegisters(_))
          .mkString(",")};
${termConstraints.map(catraFormat).mkString("")}
"""
    println(str)
  }
}
