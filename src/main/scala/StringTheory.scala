/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2017-2018  Philipp Ruemmer, Petr Janku
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

import ap._
import ap.parser._
import ap.theories._
import ap.basetypes.{IdealInt, Tree}
import ap.proof.theoryPlugins.Plugin
import ap.terfor.conjunctions.{Conjunction, Quantifier}
import ap.terfor._
import ap.terfor.preds.{PredConj, Predicate, Atom => PAtom}
import ap.terfor.linearcombination.LinearCombination
import ap.proof.goal.Goal
import ap.util.Seqs

import scala.collection.mutable
import scala.collection.mutable.{ArrayBuffer, LinkedHashMap, LinkedHashSet, HashMap => MHashMap, HashSet => MHashSet}

object StringTheory extends Theory {

  override def toString = "StringTheory"
  
  // TODO: use proper sorts for the operations

  val wordEps    = new IFunction("wordEps",    0, true, false)
  val wordCat    = new IFunction("wordCat",    2, true, false)
  val wordChar   = new IFunction("wordChar",   1, true, false)

  val wordLen    = new IFunction("wordLen",    1, true, false)

  // defined operation
  val wordSlice  = new IFunction("wordSlice",  3, true, false)

  val rexEmpty   = new IFunction("rexEmpty",   0, true, false)
  val rexEps     = new IFunction("rexEps",     0, true, false)
  val rexSigma   = new IFunction("rexSigma",   0, true, false)
  val rexCat     = new IFunction("rexCat",     2, true, false)
  val rexChar    = new IFunction("rexChar",    1, true, false)
  val rexUnion   = new IFunction("rexUnion",   2, true, false)
  val rexStar    = new IFunction("rexStar",    1, true, false)
  val rexNeg     = new IFunction("rexNeg",     1, true, false)
  val rexRange   = new IFunction("rexRange",   2, true, false)

  /// Constraints representing transducers
  val replaceall = new IFunction("replaceall", 3, true, false)
  val replace    = new IFunction("replace",    3, true, false)
  val reverse    = new IFunction("reverse",    1, true, false)
  val wordDiff   = new Predicate("wordDiff",   2)

  val member     = new Predicate ("member",    2)

  def word(ts : AnyRef*) = {
    import IExpression._
    val it = for (t <- ts.iterator;
                  s <- t match {
                         case t : String =>
                           for (c <- t.iterator) yield wordChar(c.toInt)
                         case t : IdealInt =>
                           Iterator single wordChar(t)
                         case t : Seq[_] =>
                           for (c <- t.iterator) yield c match {
                             case c : IdealInt => wordChar(c)
                             case c : Int      => wordChar(c)
                           }
                         case t : ITerm =>
                           Iterator single t
                         case t : ConstantTerm =>
                           Iterator single i(t)
                       }) yield s
    if (it.hasNext)
      it reduceLeft { (a, b) => wordCat(a, b) }
    else
      wordEps()
  }

  def rex(ts : AnyRef*) : ITerm = {
    import IExpression._
    val it = for (t <- ts.iterator;
                  s <- t match {
                         case t@IFunApp(`rexEmpty`, _) =>
                           return t
                         case IFunApp(`rexEps`, _) =>
                           Iterator.empty
                         case t : ITerm =>
                           Iterator single t
                         case t : ConstantTerm =>
                           Iterator single i(t)
                         case t : String =>
                           for (c <- t.iterator) yield rexChar(c.toInt)
                         case t : IdealInt =>
                           Iterator single rexChar(t)
                         case t : Seq[_] =>
                           for (c <- t.iterator) yield  c match {
                             case c : IdealInt => rexChar(c)
                             case c : Int      => rexChar(c)
                           }
                       }) yield s
    if (it.hasNext)
      it reduceLeft { (a, b) => rexCat(a, b) }
    else
      rexEps()
  }

  def union(ts : AnyRef*) : ITerm = {
    import IExpression._
    val it = for (t <- ts.iterator;
                  te = rex(t);
                  if (te != rexEmpty()))
             yield te
    if (it.hasNext)
      it reduceLeft { (a, b) => rexUnion(a, b) }
    else
      rexEmpty()
  }

  def star(ts : AnyRef*) : ITerm = {
    import IExpression._
    rex(ts : _*) match {
      case t@IFunApp(`rexEps`, _) => t
      case IFunApp(`rexEmpty`, _) => rexEps()
      case t                      => rexStar(t)
    }
  } 

  //////////////////////////////////////////////////////////////////////////////

  val functions = List(wordEps, wordCat, wordChar, wordLen, wordSlice,
                       rexEmpty, rexEps, rexSigma, rexCat, rexChar,
                       rexUnion, rexStar, rexNeg, rexRange, replaceall, replace)

  val iAxioms = {
    import IExpression._

    all(w => trig(wordLen(w) >= 0, wordLen(w))) &
//
    all(w => all(beg => all(end => trig(
      (beg >= 0 & beg <= end & end <= wordLen(w)) ==>
       ex(p => ex(s =>
         wordLen(p) === beg & wordLen(wordSlice(w, beg, end)) === (end - beg) &
                         word(p, wordSlice(w, beg, end), s) === w)),
                     wordSlice(w, beg, end))))) &
//
//    (wordLen(wordEps()) === 0) &
       all(c => trig(wordLen(wordChar(c)) === 1, wordLen(wordChar(c)))) &
      all(x => all(y => trig(wordLen(wordCat(x, y)) === wordLen(x) + wordLen(y),
                            wordLen(wordCat(x, y)))))

     /* all(x => all(y => all(z =>
          trig(wordCat(wordCat(x, y), z) === wordCat(x, wordCat(y, z)),
             wordCat(x, wordCat(y, z)))))), */
  }

  val (functionalPredicatesSeq, preAxioms, preOrder,
       functionPredicateMap) =
    Theory.genAxioms(theoryFunctions = functions,
                     theoryAxioms = iAxioms)

  val functionPredicateMapping = functions zip functionalPredicatesSeq
  val order = preOrder extendPred List(member, wordDiff)
  val functionalPredicates = functionalPredicatesSeq.toSet
  val predicates = List(member, wordDiff) ++ functionalPredicatesSeq
  val totalityAxioms = Conjunction.TRUE

  private val predFunMap =
    (for ((f, p) <- functionPredicateMap) yield (p, f)).toMap

  object FunPred {
    def unapply(p : Predicate) : Option[IFunction] = predFunMap get p
  }

  private val p = functionPredicateMap

  val axioms = {
    import TerForConvenience._
    implicit val _ = order

    val epsAxiom1 =
    forall(forall(
        (p(wordEps)(List(l(v(0)))) & p(wordLen)(List(l(v(0)), l(v(1)))))
        ==>
        (v(1) === 0)
    ))

    val epsAxiom2 =
    forall(forall(forall(
        (p(wordCat)(List(l(v(0)), l(v(1)), l(v(2)))) & p(wordEps)(List(l(v(2)))))
        ==>
        ((v(0) === v(2)) & (v(1) === v(2)))
    )))

    val epsAxiom3 =
    forall(forall(forall(
        (p(wordCat)(List(l(v(0)), l(v(1)), l(v(2)))) & p(wordEps)(List(l(v(0)))))
        ==>
        (v(1) === v(2))
    )))

    val epsAxiom4 =
    forall(forall(forall(
        (p(wordCat)(List(l(v(0)), l(v(1)), l(v(2)))) & p(wordEps)(List(l(v(1)))))
        ==>
        (v(0) === v(2))
    )))

    val charAxiom1 =
    forall(forall(forall(
        (p(wordChar)(List(l(v(0)), l(v(2)))) &
         p(wordChar)(List(l(v(1)), l(v(2)))))
        ==>
        (v(0) === v(1))
    )))

    val charAxiom2 =
    forall(forall(forall(forall(forall(forall(forall(
        (p(wordChar)(List(l(v(0)), l(v(1)))) &
         p(wordChar)(List(l(v(2)), l(v(3)))) &
         p(wordCat)(List(l(v(1)), l(v(4)), l(v(5)))) &
         p(wordCat)(List(l(v(3)), l(v(6)), l(v(5)))))
        ==>
        ((v(0) === v(2)) & (v(1) === v(3)) & (v(4) === v(6)))
    )))))))

    val charAxiom3 =
    forall(forall(forall(forall(forall(forall(forall(
        (p(wordChar)(List(l(v(0)), l(v(1)))) &
         p(wordChar)(List(l(v(2)), l(v(3)))) &
         p(wordCat)(List(l(v(4)), l(v(1)), l(v(5)))) &
         p(wordCat)(List(l(v(6)), l(v(3)), l(v(5)))))
        ==>
        ((v(0) === v(2)) & (v(1) === v(3)) & (v(4) === v(6)))
    )))))))

    conj(List(epsAxiom1, epsAxiom2, epsAxiom3, epsAxiom4,
              charAxiom1, charAxiom2, charAxiom3, preAxioms))
  }

  val predicateMatchConfig : Signature.PredicateMatchConfig = Map()
  val triggerRelevantFunctions : Set[IFunction] = functions.toSet

  //////////////////////////////////////////////////////////////////////////////

  def plugin = Some(new Plugin {

    def asConst(lc : LinearCombination) = {
      assert(lc.size == 1 &&
             lc.leadingCoeff.isOne &&
             lc.leadingTerm.isInstanceOf[ConstantTerm])
      lc.leadingTerm.asInstanceOf[ConstantTerm]
    }

    ////////////////////////////////////////////////////////////////////////////

    // not used
    def generateAxioms(goal : Goal)
          : Option[(Conjunction, Conjunction)] = None

    ////////////////////////////////////////////////////////////////////////////

    private val afaSolver = new AFASolver

    private val prepropSolver = new PrepropSolver

    override def handleGoal(goal : Goal)
                       : Seq[Plugin.Action] = goalState(goal) match {

      case Plugin.GoalState.Final => Console.withOut(Console.err) {

//println("handleGoal:")
//println(goal)

        breakCyclicEquations(goal) match {
          case Some(actions) =>
            actions
          case None =>
            // TODO: run solvers after each other
            Flags.enabledSolvers.head match {
              case Flags.Solver.afa_mc =>
                afaSolver.findStringModel(goal) match {
                  case Some(model) => List()
                  case None        => List(Plugin.AddFormula(Conjunction.TRUE))
                }
              case Flags.Solver.preprop =>
                prepropSolver.findStringModel(goal) match {
                  case Some(model) => List()
                  case None        => List(Plugin.AddFormula(Conjunction.TRUE))
                }
            }

        }
      }

      case _ => List()
    }

    ////////////////////////////////////////////////////////////////////////////

    override def generateModel(goal : Goal)
                              : Option[Conjunction] = { // Console.withOut(Console.err) {

        import TerForConvenience._
        implicit val _ = goal.order
        val atoms = goal.facts.predConj

        ////////////////////////////////////////////////////////////////////////

        val definedStrings = new MHashMap[Seq[Int], Int]
        val stringDefPreds = new ArrayBuffer[Formula]

        def idFor(s : Seq[Int]) =
          definedStrings.getOrElseUpdate(s, definedStrings.size)

        def addString(s : List[Int]) : Int = s match {
          case List() => {
            val id = idFor(List())
            stringDefPreds += p(wordEps)(List(l(id)))
            id
          }
          case c :: rem => {
            val remId = addString(rem)
            val cId = idFor(List(c))
            val sId = idFor(s)
            stringDefPreds += p(wordChar)(List(l(c), l(cId)))
            stringDefPreds += p(wordCat)(List(l(cId), l(remId), l(sId)))
            sId
          }
        }

        ////////////////////////////////////////////////////////////////////////

        val stringMap = new MHashMap[ConstantTerm, Seq[Int]]

        for (a <- atoms positiveLitsWithPred p(wordEps))
          stringMap.put(asConst(a(0)), List())

        for (a <- atoms positiveLitsWithPred p(wordChar);
             if (a(0).isConstant))
          stringMap.put(asConst(a(1)), List(a(0).constant.intValueSafe))

        // Add solutions from the string solver, if there are any
        afaSolver.findStringModel(goal) match {
          case None => throw new IllegalArgumentException(
                         "string solver unexpectedly says unsat")
          case Some(stringModel) => {
            for ((t, w) <- stringModel) {
              val lhs = t match {
                case c : ConstantTerm => c
                case lh : LinearCombination if lh.size == 1 =>
                  lh.leadingTerm.asInstanceOf[ConstantTerm]
              }
              stringMap.put(lhs, w map (_.left.get))
            }
          }
        }

        // initially set all undefined variables to the empty string
        for (a <- (atoms positiveLitsWithPred p(wordCat)).iterator;
             c <- a.constants.iterator;
             if (!(stringMap contains c)))
          stringMap.put(c, List())

        // fixed-point computation taking care of concatenation
        var changed = true
        var maxIterationNum = (atoms positiveLitsWithPred p(wordCat)).size

        while (changed) {
          changed = false

          if (maxIterationNum < 0) {
            // we should not need this many iterations, something must be wrong
            println(goal.facts)
            println(stringMap.toList)
            throw new Exception("Could not construct satisfying assignment")
          }

          for (a <- atoms positiveLitsWithPred p(wordCat))
            for (s0 <- stringMap get asConst(a(0));
                 s1 <- stringMap get asConst(a(1)))
              if (stringMap(asConst(a(2))) != s0 ++ s1) {
                stringMap.put(asConst(a(2)), s0 ++ s1)
                changed = true
              }

          maxIterationNum = maxIterationNum - 1
        }

        // add definition for the resulting strings
        for ((c, s) <- stringMap)
          stringDefPreds += (c === addString(s.toList))

        // add definitions for characters used in atoms wordChar(a, b)
        for (a <- (atoms positiveLitsWithPred p(wordChar)).iterator;
             if (!a(0).isConstant))
          (stringMap get asConst(a(1))) match {
            case Some(Seq(c)) => stringDefPreds += (a(0) === c)
            case _ => assert(false)
          }

        // add values for word lengths
        for (a <- atoms positiveLitsWithPred p(wordLen))
          for (s <- stringMap get asConst(a(0)))
            stringDefPreds += (a(1) === s.size)

        val definingPreds = conj(stringDefPreds)
// println(definingPreds)
        val predsToRemove = predicates.toSet -- List(p(wordEps), p(wordCat), p(wordChar))
        val newAtoms =
          atoms.updateLitsSubset(atoms.positiveLits filterNot {
                                   a => predsToRemove contains a.pred },
                                 atoms.negativeLits filterNot {
                                   a => predsToRemove contains a.pred },
                                 goal.order)
        Some(goal.facts.updatePredConj(newAtoms) & definingPreds)
      }
  })

  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////
  // check for cyclic word equations, and break those
  // e.g., equations x = yz & y = ax  ->  z = eps & a = eps & y = ax
  // Tarjan's algorithm is used to find all strongly connected components

  private def breakCyclicEquations(goal : Goal)
                    : Option[Seq[Plugin.Action]] = {

      import TerForConvenience._
      implicit val _ = goal.order

      val newAtoms = new ArrayBuffer[PAtom]
      val removedAtoms = new ArrayBuffer[PAtom]

      {
        val wordCatAtoms = goal.facts.predConj positiveLitsWithPred p(wordCat)
        val successors = wordCatAtoms groupBy (_(2))

        val index, lowlink = new MHashMap[LinearCombination, Int]
        val stack = new LinkedHashSet[LinearCombination]
        val component = new MHashSet[LinearCombination]
        val cycle = new LinkedHashMap[LinearCombination, (PAtom, LinearCombination)]

        def connect(v : LinearCombination) : Unit = {
          val vIndex = index.size
          index.put(v, vIndex)
          lowlink.put(v, vIndex)
          stack += v

          for (a <- successors.getOrElse(v, List()).iterator;
               w <- Seqs.doubleIterator(a(0), a(1)))
            (index get w) match {
              case Some(wIndex) =>
                if (stack contains w)
                  lowlink.put(v, lowlink(v) min index(w))
              case None => {
                connect(w)
                lowlink.put(v, lowlink(v) min lowlink(w))
              }
            }

          if (lowlink(v) == vIndex) {
            // found a strongly connected component
            var next = stack.last
            stack remove next
            component += next
            while (next != v) {
              next = stack.last
              stack remove next
              component += next
            }

//              println(component.toList)

            // check whether we can construct a cycle within the
            // component
            var curNode = v
            while (curNode != null && !(cycle contains curNode)) {
              val it = successors.getOrElse(curNode, List()).iterator
              var atom : PAtom = null
              var nextNode : LinearCombination = null
              var sideNode : LinearCombination = null

              while (atom == null && it.hasNext) {
                val a = it.next
                if (component contains a(0)) {
                  atom = a
                  nextNode = a(0)
                  sideNode = a(1)
                } else if (component contains a(1)) {
                  atom = a
                  nextNode = a(1)
                  sideNode = a(0)
                }
              }

              if (atom != null)
                cycle.put(curNode, (atom, sideNode))
              curNode = nextNode
            }

            if (curNode != null) {
              // then we have found a cycle
              var started = false
              for ((v, (a, w)) <- cycle) {
                if (!started && v == curNode) {
                  removedAtoms += a
                  started = true
                }

                if (started)
                  newAtoms += p(wordEps)(List(w))
              }
            }

            component.clear
            cycle.clear
          }
        }

        for (v <- successors.keysIterator)
          if (!(index contains v))
            connect(v)
      }

      ////////////////////////////////////////////////////////////////////////

      if (newAtoms.nonEmpty || removedAtoms.nonEmpty)
        Some(List(Plugin.RemoveFacts(conj(removedAtoms)),
                  Plugin.AddFormula(!conj(newAtoms))))
      else
        None
    
  }

  //////////////////////////////////////////////////////////////////////////////

  override def isSoundForSat(
         theories : Seq[Theory],
         config : Theory.SatSoundnessConfig.Value) : Boolean =
    theories.size == 1 &&
    (Set(Theory.SatSoundnessConfig.Elementary,
         Theory.SatSoundnessConfig.Existential) contains config)

  case class DecoderData(m : Map[IdealInt, Seq[IdealInt]])
       extends Theory.TheoryDecoderData

  val asSeq = new Theory.Decoder[Seq[IdealInt]] {
    def apply(d : IdealInt)
             (implicit ctxt : Theory.DecoderContext) : Seq[IdealInt] =
      (ctxt getDataFor StringTheory.this) match {
        case DecoderData(m) => m(d)
      }
  }

  val asString = new Theory.Decoder[String] {
    def apply(d : IdealInt)
             (implicit ctxt : Theory.DecoderContext) : String =
      asStringPartial(d).get
  }

  val asStringPartial = new Theory.Decoder[Option[String]] {
    def apply(d : IdealInt)
             (implicit ctxt : Theory.DecoderContext) : Option[String] =
      (ctxt getDataFor StringTheory.this) match {
        case DecoderData(m) =>
          for (s <- m get d)
          yield ("" /: s) { case (res, c) => res + c.intValueSafe.toChar }
      }
  }

  override def generateDecoderData(model : Conjunction)
                                  : Option[Theory.TheoryDecoderData] = {
    val atoms = model.predConj

    val stringMap = new MHashMap[IdealInt, Seq[IdealInt]]

    for (a <- atoms positiveLitsWithPred p(wordEps))
      stringMap.put(a(0).constant, List())

    for (a <- atoms positiveLitsWithPred p(wordChar))
      stringMap.put(a(1).constant, List(a(0).constant))

    var oldMapSize = 0
    while (stringMap.size != oldMapSize) {
      oldMapSize = stringMap.size
      for (a <- atoms positiveLitsWithPred p(wordCat)) {
        for (s0 <- stringMap get a(0).constant;
             s1 <- stringMap get a(1).constant)
          stringMap.put(a(2).constant, s0 ++ s1)
      }
    }

    Some(DecoderData(stringMap.toMap))
  }

  TheoryRegistry register this

  //////////////////////////////////////////////////////////////////////////////

  object NullStream extends java.io.OutputStream {
    def write(b : Int) = {}
  }
}
