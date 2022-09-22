package ostrich.automata.afa2.symbolic

import ostrich.automata.afa2._
import scala.collection.mutable




case class SymbAFA2(initialStates : Seq[Int],
                    finalStates   : Seq[Int],
                    transitions   : Map[Int, Seq[SymbTransition]]) {

  assert(!initialStates.isEmpty)

  lazy val states: Set[Int] = {
    val states = new mutable.HashSet[Int]

    states ++= initialStates
    states ++= finalStates

    for ((source, trans) <- transitions;
         t <- trans;
         target <- t.targets) {
      states += source
      states += target
    }

    states.toSet
  }

}



case class SymbExtAFA2(initialStates : Seq[Int],
                       finalLeftStates: Seq[Int],
                       finalRightStates: Seq[Int],
                       transitions   : Map[Int, Seq[Transition]]) {

  assert(!initialStates.isEmpty)

  val states : Set[Int] = {
    val states = new mutable.HashSet[Int]

    states ++= initialStates
    states ++= finalLeftStates
    states ++= finalRightStates

    for ( (source, trans) <- transitions;
          t <- trans;
          target <- t.targets) {
      states += source
      states += target
    }

    states.toSet
  }

  lazy val letters =
    (for ((source, ts) <- transitions.iterator;
          SymbTransition(l, _, _) <- ts.iterator)
    yield l).flatten.toSet.toIndexedSeq.sorted


  override def toString: String = {
    val res = new mutable.StringBuilder()
    res.append("Initial states: " + initialStates + "\n")
    res.append("Final begin states: " + finalLeftStates + "\n")
    res.append("Final end states: " + finalRightStates + "\n")
    for (tr <- transitions) {
      res.append(tr._1 + " goes to: \n")
      for (t <- tr._2) res.append("\t" + t + "\n")
      res.append("\n")
    }
    res.toString()
  }

}
