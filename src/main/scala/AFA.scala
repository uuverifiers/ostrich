/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017  Philipp Ruemmer, Petr Janku
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package strsolver

object AFA {
  import AFormula.widthOfChar
  
  /**
   * Construct the intersection of two AFA, with appropriate
   * mapping of their character variables.
   */
  def synchronise(a : AFA, aCharMapping : Map[Int, Int],
                  b : AFA, bCharMapping : Map[Int, Int],
                  syncTrack : Int) : AFA =
    synchronise(a permuteChars aCharMapping,
                b permuteChars bCharMapping,
                syncTrack)

  /**
   * Construct the intersection of two AFA, with appropriate
   * mapping of their character variables.
   */
  def synchronise(a : AFA, b : AFA, syncTrack : Int) : AFA = {
    def buildConstraint(c: Set[Int]) =
      c.foldLeft[AFormula](AFormula.createEpsilon(syncTrack)) {
        case (res, c) => res & AFormula.createEpsilon(c)
      }

    val aCharConstraint =
      if (b alwaysNonEps syncTrack)
        AFFalse
      else
        buildConstraint(a.charClasses - syncTrack)
    val bCharConstraint =
      if (a alwaysNonEps syncTrack)
        AFFalse
      else
        buildConstraint(b.charClasses - syncTrack)
      
    val newAStates =
      for ((s, num) <- a.states.zipWithIndex)
      yield (s | (aCharConstraint & AFStateVar(num)))
    val newBStates =
      for ((s, num) <- b.states.zipWithIndex)
      yield ((s | (bCharConstraint & AFStateVar(num)))
              .shiftStateVariables(a.states.size))
    val newInitial =
      a.initialStates &
      b.initialStates.shiftStateVariables(a.states.size)
    val newFinal =
      a.finalStates &
      b.finalStates.shiftStateVariables(a.states.size)

    new AFA (newInitial, newAStates ++ newBStates, newFinal)
  }

  /**
   * Construct the union of two AFAs talking about distinct sets of
   * tracks.
   */
  def conjoin(a : AFA, b : AFA) : AFA = {
    assert((a.charClasses & b.charClasses).isEmpty)

    def buildConstraint(c: Set[Int]) =
      AFormula.and(for (x <- c) yield AFormula.createEpsilon(x))

    val aCharConstraint = buildConstraint(a.charClasses)
    val bCharConstraint = buildConstraint(b.charClasses)
    val newAStates =
      for ((s, num) <- a.states.zipWithIndex)
      yield (s | (aCharConstraint & AFStateVar(num)))
    val newBStates =
      for ((s, num) <- b.states.zipWithIndex)
      yield ((s | (bCharConstraint & AFStateVar(num)))
              .shiftStateVariables(a.states.size))
    val newInitial =
      a.initialStates &
      b.initialStates.shiftStateVariables(a.states.size)
    val newFinal =
      a.finalStates &
      b.finalStates.shiftStateVariables(a.states.size)

    new AFA (newInitial, newAStates ++ newBStates, newFinal)
  }

  /**
   * Transducer expressing that two words are distinct.
   */
  lazy val diffWordTransducer : AFA = {
    val vars0 = for (i <- 0 until widthOfChar) yield AFCharVar(i)
    val vars1 = for (i <- 0 until widthOfChar) yield AFCharVar(widthOfChar + i)
    val eqVars = AFormula.bvEq(vars0, vars1)
    
    val states = Vector(
      eqVars letIn (
        (AFDeBrujinVar(0) & ~AFSpecSymb(0) & ~AFSpecSymb(1) & AFStateVar(0)) |
        (~AFDeBrujinVar(0) & ~AFSpecSymb(0) & ~AFSpecSymb(1) & AFStateVar(1)) |
        (AFormula.createEpsilon(0) & ~AFSpecSymb(1) & AFStateVar(2)) |
        (AFormula.createEpsilon(1) & ~AFSpecSymb(0) & AFStateVar(3))
      ),
      (~AFSpecSymb(0) | ~AFSpecSymb(1)) & AFStateVar(1),
      ~AFSpecSymb(1) & AFStateVar(2),
      ~AFSpecSymb(0) & AFStateVar(3)
    )

    val finalStates =
      AFormula.and(for (n <- 0 until states.size; if !(Set(1, 2, 3) contains n))
                   yield ~AFStateVar(n))

    new AFA (AFStateVar(0), states, finalStates)
  }

  // I suppose that afa is transducer and therefore has only 2 tracks.
  def split(afa: AFA, vars: Seq[Map[Int, Int]]) = {
    def buildMemStates(num: Int, shift: Int): IndexedSeq[AFormula] = 
      (shift until (num + shift)) map AFStateVar
//    def createMapping(track1: Int, track2: Int) = 
//      Map((0 -> track1), (1 -> track2))
    def buildEpsTrans(mapping: Map[Int, Int]) = 
      mapping.foldLeft[AFormula](AFTrue) { case (res, (_, track)) => 
        res & AFormula.createEpsilon(track);
      }
      //AFormula.createEpsilon(track1) & AFormula.createEpsilon(track2)
    def buildStates(states: Seq[AFormula], 
                    mapping : Map[Int, Int], 
                    shift: Int, 
                    epsTrans: AFormula) = 
      states.zipWithIndex map { case (state, ind) => 
        state.renameVariables(shift, mapping) | 
        (AFStateVar(ind + shift) & epsTrans) 
      }
    def buildPartOfInit(states: Range, memStates: Range) = {
      val part1 = states.foldLeft[AFormula](AFFalse) (_ | AFStateVar(_))
      val part2 = states.view.zip(memStates).foldLeft[AFormula](AFTrue) { 
        case (res, (s, m)) => 
          res & (AFStateVar(s) ==> AFStateVar(m))
      }

      part1 & part2
    }
    def buildPartOfFinal(states: Range, memStates: Range) =
      states.view.zip(memStates).foldLeft[AFormula](AFTrue) { 
        case (res, (s, m)) => 
          res & (AFStateVar(s) ==> AFStateVar(m))
      }

    val oStates = afa.states // old states
    val size = oStates.size
    var initFormula = afa.initialStates
    var finalFormula: AFormula = AFTrue
    //var mapping = createMapping(vars.head._1, vars.head._2)
    var epsTrans = buildEpsTrans(vars.head)
    var states = oStates.zipWithIndex map { case (state, ind) =>
      (state permuteChars vars.head) | (AFStateVar(ind) & epsTrans) }

    vars.tail foreach { case mapping =>
      //mapping = createMapping(track1, track2)
      epsTrans = buildEpsTrans(mapping)
      finalFormula &= buildPartOfFinal((states.size - size) until states.size,
                                      states.size until (states.size + size))
      states ++= buildMemStates(size, states.size)
      initFormula &= buildPartOfInit(states.size until (states.size + size),
                                     (states.size - size) until states.size)
      states ++= buildStates(oStates, mapping, states.size, epsTrans)
    }

    finalFormula &= afa.finalStates.shiftStateVariables(states.size - size)
    new AFA(initFormula, states, finalFormula)
  }

  /**
   * Automaton expressing the universal language.
   */
  lazy val universalAutomaton : AFA =
    new AFA (AFStateVar(0), Vector(~AFSpecSymb(0) & AFStateVar(0)), AFTrue)

}

class AFA(val initialStates: AFormula,
          val states: Vector[AFormula],
          val finalStates: AFormula) {

  override def toString: String = {
    "numOfStates:   " + states.size + "\n" +
    "initialStates: " + initialStates + "\n" +
    "finalStates:   " + finalStates + "\n" +
    "States: \n" +
      states.view.zipWithIndex.foldLeft[String]("") { case (str, (transition, index)) =>
        str + "state " + index + ":\n" + transition + "\n"
      }
  }

  lazy val maxCharIndex =
    (for (s <- states.iterator) yield s.maxCharIndex).max max
    finalStates.maxCharIndex

  lazy val charClasses =
    (for (s <- states.iterator ++ (Iterator single finalStates);
          c <- s.charClasses.iterator) yield c).toSet

  lazy val specSyms =
    (for (s <- states.iterator; ind <- s.specSyms.iterator) yield ind).toSet

  lazy val parameters : Set[Int] =
    initialStates.parameters ++ finalStates.parameters

  lazy val finalStateSet = finalStates.getStates

  private def alwaysNonEps(f : AFormula, neg : Boolean,
                           offset : Int) : Boolean = f match {
    case AFAnd(f1, f2) if !neg =>
      alwaysNonEps(f1, neg, offset) || alwaysNonEps(f2, neg, offset)
    case AFOr(f1, f2) if !neg =>
      alwaysNonEps(f1, neg, offset) && alwaysNonEps(f2, neg, offset)
    case AFAnd(f1, f2) if neg =>
      alwaysNonEps(f1, neg, offset) && alwaysNonEps(f2, neg, offset)
    case AFOr(f1, f2) if neg =>
      alwaysNonEps(f1, neg, offset) || alwaysNonEps(f2, neg, offset)
    case AFSpecSymb(`offset`) if neg =>
      true
    case AFFalse if !neg =>
      true
    case AFTrue if neg =>
      true
    case AFNot(f1) =>
      alwaysNonEps(f1, !neg, offset)
    case AFLet(f1, f2) =>
      alwaysNonEps(f2, neg, offset)
    case _ =>
      false
  }

  def alwaysNonEps(offset : Int) : Boolean =
    states forall (alwaysNonEps(_, false, offset))

  /**
   * Transform to an AFA with state 0 as the unique initial state.
   */
  def normaliseInitial : AFA = initialStates match {
    case AFStateVar(0) => this
    case _ => {
      // add a new initial state, and turn previous initial state
      // formula into a transition
      val initStateTransition =
        (this.initialStates shiftStateVariables 1) &
        AFormula.and(for (c <- this.charClasses)
                     yield AFormula.createEpsilon(c))
      new AFA(AFStateVar(0),
              (List(initStateTransition) ++
               (this.states map (_ shiftStateVariables 1))).toVector,
              ~AFStateVar(0) & (this.finalStates shiftStateVariables 1))
    }
  }

  /**
   * Transform to an AFA without parameters, by adding additional states.
   * This corresponds to existential quantification of the parameters.
   */
  def eliminateParameters : AFA =
    if (parameters.isEmpty) {
      this
    } else {
      assert(parameters forall (_ >= 0))
      val paramSeq = parameters.toList.sorted
      val N = states.size

      // every parameter is mapped to one state for positive occurrences,
      // and a second state for negative occurrences
      val paramMapping = (for (p <- paramSeq.iterator)
                          yield (p -> (N + 2*p, N + 2*p + 1))).toMap

      val newStates =
        states ++
        (for (n <- 0 until 2*paramSeq.size) yield AFStateVar(N + n)).toVector
      val newInitial =
        initialStates.paramToState(paramMapping, false) &
        AFormula.and(for (n <- 0 until paramSeq.size)
                     yield (AFStateVar(N + 2*n) | AFStateVar(N + 2*n + 1)))
      val newFinal =
        finalStates.paramToState(paramMapping, true)

      new AFA(newInitial, newStates, newFinal)
    }

  /**
   * Split the AFA into n components, using parameters with index
   * >= paramStartIndex to specify how initial and final states of the
   * components are connected. The result are n AFAs, and a new
   * parameter start index (index where unused parameters start).
   */
  def parameterSplit(n : Int,
                     paramStartIndex : Int) : (Seq[AFA], Int) =
    if (n == 1) {
      (List(this), paramStartIndex)
    } else {
      assert(n >= 2)
      val N = states.size
  
      val splitParams =
        for (i <- 1 until n)
        yield ((paramStartIndex + (i-1)*N) until (paramStartIndex + i*N)).toSeq
  
      val initialStateSeq =
        List(initialStates) ++
        (for (params <- splitParams)
         yield AFormula.and(for (n <- 0 until N)
                            yield (AFParam(params(n)) ==> AFStateVar(n))))
  
      val finalStateSeq =
        (for (params <- splitParams)
         yield AFormula.and(for (n <- 0 until N)
                            yield (AFStateVar(n) ==> AFParam(params(n))))) ++
        List(finalStates)
  
      val afas =
        for ((init, fin) <- initialStateSeq zip finalStateSeq)
        yield new AFA(init, states, fin)
      (afas, paramStartIndex + (n-1)*N)
    }
  
  def shiftStateVariables(inc: Int): AFA =
    new AFA(initialStates shiftStateVariables inc,
            states.map(_.shiftStateVariables(inc)),
            finalStates shiftStateVariables inc)

  def And(afa: AFA): AFA = {
    def buildConstraint(c: Set[Int]) =
      c.foldLeft[AFormula](AFTrue) {
        case (res, c) => res & AFormula.createEpsilon(c)
      }

    val aCharConstraint = buildConstraint(this.charClasses)
    val bCharConstraint = buildConstraint(afa.charClasses)
    val newAStates =
      for ((s, num) <- this.states.zipWithIndex)
      yield ((s | (aCharConstraint & AFStateVar(num))))
    val newBStates =
      for ((s, num) <- afa.states.zipWithIndex)
      yield ((s | (bCharConstraint & AFStateVar(num)))
              .shiftStateVariables(this.states.size))
    val initFormula = this.initialStates & afa.initialStates.shiftStateVariables(this.states.size)
    val finalFormula = this.finalStates & afa.finalStates.shiftStateVariables(this.states.size)
    new AFA (initFormula,
             newAStates ++ newBStates,
             finalFormula)
  }

  def Or(afa: AFA): AFA = {
    val lAfa: AFA = shiftStateVariables(1)
    val rAfa: AFA = afa.shiftStateVariables(states.size + 1)
    val newFinalStates =
      if(lAfa.finalStateSet(0) && rAfa.finalStateSet(0))
        rAfa.finalStates | lAfa.finalStates | AFStateVar(0)
      else
        rAfa.finalStates | lAfa.finalStates

    val nstates: Vector[AFormula] =
      (lAfa.states.head | rAfa.states.head) +: (lAfa.states ++ rAfa.states)

    new AFA(AFStateVar(0), nstates, newFinalStates)
  }

  def |(afa: AFA): AFA = {
    Or(afa)
  }

  def &(afa: AFA): AFA = {
    And(afa)
  }

  def permuteChars(mapping : Map[Int, Int]) : AFA =
    new AFA(initialStates, 
            for (s <- states) yield (s permuteChars mapping),
            finalStates)
}