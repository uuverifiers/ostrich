
package stringfuns

import scala.collection.JavaConversions._
import scala.collection.mutable.{Map, Set}
import dk.brics.automaton.{Automaton, Transition}

import util.{AutomatonTools, Box, CaleyGraph}

/**
 * Pre for x = ReplaceAll(y, a, z)
 */
object PreReplaceAll {
    /**
     * Given an automaton constraining x, generate possible constraints
     * on y and z.
     *
     * @param aut A regular constraint on the value of x after the
     * replace all
     * @param a the character being replaced
     * @return sequence of possible regular constraints (aut_y, aut_z)
     * on y and z.
     */
    def apply(aut : Automaton, a : Char) : Iterator[(Automaton, Seq[Automaton])] =
        for (box <- CaleyGraph(aut).getNodes.iterator)
            yield (getYConstraint(aut, a, box), getZConstraints(aut, box))

    /**
     * The constraint on Y from the preimage of aut, using box as the
     * guess of state pairs the value of z can move from and to
     *
     * @param aut
     * @param a the char being replaced
     * @param box
     * @return pre of aut when guess is box
     */
    private def getYConstraint(aut : Automaton, a : Char, box : Box) : Automaton = {
        // A \ a-transitions
        val (aut2, map) = AutomatonTools.substWithMap(aut, (min, max, addTran) => {
            if (min <= a && a <= max)
                if (min < a) addTran(min, (a+1).toChar)
                if (a < max) addTran((a-1).toChar, max)
            else
                addTran(min, max)
        })
        // (A \ a-transition) + {q1 -a-> q2 | (q1,q2) in box}
        for ((q1, q2) <- box.edges)
            map(q1).addTransition(new Transition(a, a, map(q2)))

        aut2
    }

    /**
     * The constraints that Z must satisfy q -- val(z) --> q' for each
     * (q,q') in box
     *
     * @param aut
     * @param box
     * @return list of automaton contraints to be consistent with box
     */
    private def getZConstraints(aut : Automaton, box : Box) : Seq[Automaton] =
        box.edges.map({ case (q1, q2) =>
            // TODO: painful to copy, can we improve?
            val (aut2, map) = AutomatonTools.cloneWithMap(aut)
            aut2.setInitialState(map(q1))
            aut2.getAcceptStates.foreach(_.setAccept(false))
            map(q2).setAccept(true)
            aut2
        }).toSeq
}
