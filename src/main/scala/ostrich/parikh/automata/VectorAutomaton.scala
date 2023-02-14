package ostrich.parikh.automata

import ostrich.automata.Automaton
import scala.collection.mutable.{HashSet => MHashSet, HashMap => MHashMap, Stack}

object VectorAutomaton {
  type State = VectorAutomaton#State

  // convert a cost-enriched automaton to a vector automaton
  def apply(aut: CostEnrichedAutomatonTrait): VectorAutomaton = {
    val builder = new CostEnrichedAutomatonBuilder
    val old2new = aut.states.map{state => state -> builder.getNewState}.toMap 
    val vecAut = new VectorAutomaton(old2new(aut.initialState))
    for ((s,_,t,v) <- aut.transitionsWithVec){
      vecAut.addTransition(old2new(s), old2new(t), v)
    }
    for (s <- aut.acceptingStates)
      vecAut.setAccept(old2new(s), true)
    vecAut.setRegsRelation(aut.getRegsRelation)
    vecAut.setRegisters(aut.getRegisters)
    vecAut
  }
}

// Vector automaton is a cost-enriched automaton without any letter, we only consider the vectors.
// So this automaton can not intersect, union, or concatenate with other automata.
// It is used to represent the cost of a accept string for a specific cost-enriched automaton.
class VectorAutomaton(val initialState : CostEnrichedAutomatonTrait#State) extends CostEnrichedAutomatonTrait{
  override def &(that: Automaton): Automaton = throw new Exception("Vector automaton can not intersect with other automata")
  override def |(that: Automaton): Automaton = throw new Exception("Vector automaton can not union with other automata")
  def apply(word: Seq[Int]): Boolean = throw new Exception("Vector automaton can not apply word")
  def unary_! = throw new Exception("Vector automaton can not complement")
  def getAcceptedWord: Option[Seq[Int]] = throw new Exception("Vector automaton can not get accepted word")
  def isEmpty: Boolean = throw new Exception("Vector automaton can not check if it is empty")
  // def outgoingTransitions(from: State): Iterator[(State, (Char, Char))] = throw new Exception("Vector automaton can not get outgoing transitions")
  def outgoingTransitions(from: State): Iterator[(State, (Char, Char))] = {
    state2transtions(from).iterator.map{case (s,_) => (s, ('a', 'a'))}
  }

  private val state2transtions = new MHashMap[State, MHashSet[(State, Seq[Int])]]
  private val state2reverseTrastions = new MHashMap[State, MHashSet[(State, Seq[Int])]]
  private var stateidx = 0
  def getNewState: State = {
    stateidx += 1
    new State(){
      val idx = stateidx
      override def toString(): String = {
        s"s${idx}"
      }
    }
  }

  def setAccept(s: State, b: Boolean): Unit = {
    s.setAccept(b)
  }

  def addTransition(from: State, to: State, vec: Seq[Int]): Unit = {
    state2transtions.get(from) match {
      case Some(set) => set.add((to, vec))
      case None => {
        val set = new MHashSet[(State, Seq[Int])]
        set.add((to, vec))
        state2transtions.put(from, set)
      }
    }
    state2reverseTrastions.get(to) match {
      case Some(set) => set.add((from, vec))
      case None => {
        val set = new MHashSet[(State, Seq[Int])]
        set.add((from, vec))
        state2reverseTrastions.put(to, set)
      }
    }
  }

  override def incomingTransitionsWithVec(t: State): Iterator[(State, (Char, Char), Seq[Int])] = {
    state2reverseTrastions.get(t) match {
      case Some(set) => set.iterator.map{case (from, vec) => (from, ('0', '0'), vec)}
      case None => Iterator.empty
    }
  }

  override def outgoingTransitionsWithVec(s: State): Iterator[(State, (Char, Char), Seq[Int])] = {
    state2transtions.get(s) match {
      case Some(set) => set.iterator.map{case (to, vec) => (to, ('0', '0'), vec)}
      case None => Iterator.empty
    }
  }

  def states: Iterable[State] = {
    val seenlist = new MHashSet[State]
    val worklist = new Stack[State]
    worklist.push(initialState)
    seenlist.add(initialState)
    while (!worklist.isEmpty) {
      val s = worklist.pop
      for ((to, _, _) <- outgoingTransitionsWithVec(s) if !seenlist.contains(to)) {
        worklist.push(to)
        seenlist.add(to)
      }
    }
    seenlist.toIterable
  }
  def acceptingStates: Set[State] = (for (s <- states; if isAccept(s)) yield s).toSet
  
  def isAccept(s:State) = s.isAccept()
}