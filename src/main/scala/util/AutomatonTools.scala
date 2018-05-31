package util

import dk.brics.automaton.Automaton
import dk.brics.automaton.State
import scala.collection.JavaConversions._
import scala.collection.mutable.{HashMap, Map}
import dk.brics.automaton.Transition

/**
 * Extra operations on brics automata
 */
object AutomatonTools {
    /**
     * Clones aut and provides a mapping between equivalent states
     *
     * @param aut the aut to clone
     * @return (aut', map) where aut' is a clone of aut and map takes a
     * state of aut into its equivalent state in aut'
     */
    def cloneWithMap(aut : Automaton) : (Automaton, Map[State, State]) =
        substWithMap(aut, (min, max, addTran) => addTran(min, max))

    /**
     * Clones aut and provides a mapping between equivalent states
     * Allows the transitions transformed via a function tranMap which
     * returns a sequence of replacement transitions for a given
     * transition.  The sequence can be empty to delete a transition.
     *
     * transformTran(min, max, addTran) can use addTran(newMin, newMax)
     * to replace transitions q --min, max--> q' with q --newMin, newMax
     * --> q' (can use addTran multiple times)
     *
     * Note: could probably do similar to this with aut.subst, but then
     * we lose the map
     *
     * @param aut the aut to clone
     * @param transformTran a function processing transitions
     * @return (aut', map) where aut' is a clone of aut and map takes a
     * state of aut into its equivalent state in aut'
     */
    def substWithMap(
        aut : Automaton,
        transformTran: (Char, Char, (Char, Char) => Unit) => Unit
    ) : (Automaton, Map[State, State]) = {
        val map = new HashMap[State, State]
        for (q <- aut.getStates)
            map += q -> new State
        for (q <- aut.getStates; t <- q.getTransitions)
            transformTran(t.getMin, t.getMax, (min, max) =>
                map(q).addTransition(new Transition(min, max, map(t.getDest)))
            )
        val aut2 = new Automaton
        aut2.setInitialState(map(aut.getInitialState))
        aut2.restoreInvariant
        (aut2, map)
    }

}
