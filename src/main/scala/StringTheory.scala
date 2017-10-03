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
import dk.brics.automaton.{Automaton, BasicAutomata, BasicOperations, RegExp}

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

    private val constraintPreds = Set(member, p(replaceall), p(replace))
    private val wordPreds = Set(p(wordEps), p(wordCat), p(wordChar))

    private val modelCache =
      new ap.util.LRUCache[Conjunction, Option[Map[Term, Word]]](3)

    private def findStringModel(goal : Goal) : Option[Map[Term, Word]] =
    modelCache(goal.facts) {
      println("Running AFA-based consistency check")
      import TerForConvenience._
      implicit val _ = goal.order

      val atoms = goal.facts.predConj
      val regex2AFA = new Regex2AFA(atoms)
      var auxVar = 0
      val sigmaStars = new mutable.LinkedHashSet[Term]

      def wordArguments(a : PAtom) : Iterator[Term] = a.pred match {
        case `member` =>
          Iterator(a(0))
        case pred if pred == p(replace) || pred == p(replaceall) =>
          Iterator(a(0), a(3))
        case pred if pred == p(wordChar) =>
          Iterator(a.last)
        case pred if pred == p(wordCat) =>
          sigmaStars ++= a.init
          Iterator(a.last)
        case _ =>
          a.iterator
      }


      val (constraintAtoms,
      wordVariables,
      wordAtoms,
      withConcat) =
        if(Flags.splitOptimization) {
          StringPreprocessing(goal)
        } else {
          val wordVariables = new LinkedHashSet[Term]

          val wordAtoms: PredConj = atoms filter {
            a => wordPreds contains a.pred
          }

          wordVariables ++=
            (for (a <- (atoms positiveLitsWithPred p(replaceall)).iterator ++
              (atoms positiveLitsWithPred p(replace)).iterator;
                  x <- wordArguments(a))
              yield x)

          wordVariables ++=
            (for (a <- (atoms positiveLitsWithPred member).iterator ++
              (atoms negativeLitsWithPred member).iterator;
                  x <- wordArguments(a))
              yield x)

          val preConstraintAtoms: PredConj = atoms filter {
            a => constraintPreds contains a.pred
          }

          val transducerAtoms: PredConj = atoms filter {
            a => (RRFunsToAFA get a.pred).isDefined
          }

          for (a <- transducerAtoms.positiveLits.iterator)
            wordVariables ++= a.init

          // XXX
          val stringVariables =
            (for (a <- (atoms positiveLitsWithPred p(wordEps)).iterator ++
              (atoms positiveLitsWithPred p(wordChar)).iterator ++
              (atoms positiveLitsWithPred p(wordCat)).iterator;
                  x <- wordArguments(a))
              yield x).toSet

          sigmaStars --= stringVariables
          sigmaStars --= wordVariables
          // XXX


          // add atoms for negated equations
          val diffAtoms = {
            val newAtoms = new LinkedHashSet[PAtom]

            var oldSize = -1
            while (newAtoms.size > oldSize) {
              oldSize = newAtoms.size
              for (Seq((IdealInt.ONE, c: ConstantTerm),
              (IdealInt.MINUS_ONE, d: ConstantTerm)) <-
                   goal.facts.arithConj.negativeEqs;
                   lc = l(c);
                   ld = l(d);
                   if ((wordVariables contains lc) ||
                     (wordVariables contains ld)) &&
                     !((stringVariables contains lc) &&
                       (stringVariables contains ld)) &&
                     !((sigmaStars contains lc) ||
                       (sigmaStars contains ld))) {
                newAtoms += wordDiff(List(lc, ld))
                wordVariables += lc
                wordVariables += ld
              }
            }

            PredConj(newAtoms.toList, List(), goal.order)
          }

          wordVariables ++= stringVariables
          wordVariables ++= sigmaStars

          val constraintAtoms =
            PredConj.conj(List(preConstraintAtoms, transducerAtoms, diffAtoms),
              goal.order)

          val wordVariablesInConstraints = new LinkedHashSet[Term]

          for (a <- constraintAtoms.positiveLits.iterator ++
            constraintAtoms.negativeLits.iterator;
               t <- wordArguments(a);
               if wordVariables contains t)
            wordVariablesInConstraints += t


          //////////////////////////////////////////////////////////////////////

          // check whether the problem contains genuine concatenation
          // of words
          val withConcat = {
            val concreteWordVars = new MHashSet[Term]

            var oldSize = -1
            while (concreteWordVars.size != oldSize) {
              oldSize = concreteWordVars.size
              for (a <- wordAtoms.positiveLits) a match {
                case a if a.pred == p(wordChar) =>
                  concreteWordVars += a.last
                case a if a.pred == p(wordEps) =>
                  concreteWordVars += a.last
                case a if a.pred == p(wordCat) &&
                  concreteWordVars(a(0)) &&
                  concreteWordVars(a(1)) =>
                  concreteWordVars += a.last
                case _ =>
                // nothing
              }
            }

            wordAtoms.positiveLits exists {
              a => a.pred == p(wordCat) && !concreteWordVars(a.last)
            }
          }

          (constraintAtoms, wordVariables, wordAtoms, withConcat)
        }

      if (withConcat) {

      println("Using straight-line solver")

      //////////////////////////////////////////////////////////////////////
      // Topological sorting to identify straightline formulas

      val depNodes : Seq[(Seq[Term], Seq[Term], PredConj)] =
        (for (l <- constraintAtoms.iterator ++ wordAtoms.iterator) yield {
           l.positiveLits.headOption match {
             case Some(a) if (RRFunsToAFA get a.pred).isDefined &&
                             a.size == 3 &&
                             a.last.isConstant && a.last.constant.isZero =>
               (List(a(0)), List(a(1)), l)
             case Some(a) if wordPreds contains a.pred =>
               (a.init filter wordVariables, List(a.last), l)
             case Some(a) if a.pred == member =>
               (a filter wordVariables, List(), l)
             case Some(a) if a.pred == p(replace) ||
                             a.pred == p(replaceall) =>
               (List(a.head), List(a.last), l)

// Not sure in which way wordDiff should be combined with splitting
//             case Some(a) if a.pred == wordDiff =>
//               (a.toList, List(), l)

             case None => l.negativeLits.head match {
               case a if a.pred == member =>
                 (a filter wordVariables, List(), l)
               case _ =>
                 throw new Exception("Don't know how to handle " + l)
             }

             case Some(a) =>
               throw new Exception("Don't know how to handle " + a)
           }
         }).toList

      val definedWordVars = new MHashSet[Term]

      for ((_, defs, _) <- depNodes)
        definedWordVars ++= defs

      val representedWords = new MHashMap[Term, Word]

      for (x <- wordVariables)
        if (!(definedWordVars contains x))
          representedWords.put(x, List(Right(x)))

      //////////////////////////////////////////////////////////////////////

      def constructModel(modelSeed : Map[Term, Word]) : Map[Term, Word] = {
        val result = new MHashMap[Term, Word]
        result ++= modelSeed

        val domain =
          (for ((t, w) <- representedWords.iterator;
                if (w match {
                  case Seq(Right(`t`)) => false
                  case _ => true
                }))
           yield t).toSet

        for ((t, w) <- representedWords.iterator;
             s <- Iterator(t) ++ (for (Right(s) <- w.iterator) yield s);
             if !(domain contains s) && !(result contains s))
          result.put(s, List())

        var oldSize = -1
        while (oldSize != result.size) {
          oldSize = result.size
          for ((t, w) <- representedWords)
            if (!(result contains t) &&
                (w forall { case Left(_) => true
                            case Right(t) => result contains t })) {
              val rhs = for (s <- w;
                             x <- s match {
                               case Left(_)  => List(s)
                               case Right(x) => result(x)
                             })
                        yield x
              result.put(t, rhs)
            }
        }

        result.toMap filterKeys wordVariables
      }

      //////////////////////////////////////////////////////////////////////
      // sort the nodes

      val nodeSequence = new ArrayBuffer[(Seq[Word], AFA)]

      {
        var oldSize = -1
        var nodes = depNodes
        var paramIndex = 0

        def splitUnaryTransducer(input : Term, output : Term,
                                 afa : AFA) : Unit = {
          val word = representedWords(input)
          val splitInput = splitWord(word)

          if (splitInput.size > 1) {
            // now need to split AFAs!

            val (afas, newParamIndex) =
              afa.parameterSplit(splitInput.size, paramIndex)
            paramIndex = newParamIndex

            val results =
              for (((el, num), afaComp) <-
                     splitInput.zipWithIndex zip afas) yield {
                val resVar =
                  new ConstantTerm("" + output + "_" + num)
                nodeSequence +=
                  ((List(el, List(Right(resVar))).reverse, afaComp))
                Right(resVar)
              }

            representedWords.put(output, results)
          } else {
            nodeSequence += ((List(word,
                                   List(Right(output))).reverse,
                              afa))
            representedWords.put(output, List(Right(output)))
          }
        }

        def splitMembership(input : Term, afa : AFA) : Unit = {
          val word = representedWords(input)
          val splitInput = splitWord(word)

          if (splitInput.nonEmpty) {
            val (afas, newParamIndex) =
              afa.parameterSplit(splitInput.size, paramIndex)
            paramIndex = newParamIndex

            for (((el, num), afaComp) <- splitInput.zipWithIndex zip afas)
              nodeSequence += ((List(el), afaComp))
          } else {  // Epsilon case
            nodeSequence += ((Seq(word), afa))
          }
        }

        ////////////////////////////////////////////////////////////////////

        while (nodes.size != oldSize) {
          oldSize = nodes.size
          nodes = nodes filter {
            case (deps, defs, l) =>
              if (deps forall (representedWords contains _)) {
                l.positiveLits.headOption match {

                  case Some(a) if a.pred == p(wordEps) =>
                    representedWords.put(defs.head, List())
                    //nodeSequence += ((Seq(List(Right(defs.head))), AFA.epsilonAutomaton))

                  case Some(a) if a.pred == p(wordCat) =>
                    representedWords get defs.head match {
                      case Some(word) =>
                        val it = regex2AFA buildStrings defs.head
                        if(it.hasNext) {
                          val afa = regex2AFA string2AFA it.next
                          val splitInput = splitWord(word)
                          val (afas, newParamIndex) =
                            afa.parameterSplit(splitInput.size, paramIndex)
                          paramIndex = newParamIndex

                          for (((el, _), afaComp) <- splitInput.zipWithIndex zip afas)
                            nodeSequence += ((List(el), afaComp))
                        }

                      case None =>
                        representedWords.put(defs.head,
                          representedWords(deps(0)) ++
                          representedWords(deps(1)))
                    }


                  case Some(a) if a.pred == p(wordChar) =>
                    representedWords.put(defs.head,
                                 List(Left(a.head.constant.intValueSafe)))

                  case Some(a) if a.pred == p(replace) => {
                    val pattern: String =
                      StringTheoryUtil.createString(
                        regex2AFA.buildStrings(a(1)))
                    val substitution: String =
                      StringTheoryUtil.createString(
                        regex2AFA.buildStrings(a(2)))
                    val afa = Replace(pattern, substitution, 1, 0)

                    splitUnaryTransducer(deps.head, defs.head, afa)
                  }

                  case Some(a) if a.pred == p(replaceall) => {
                    val pattern: String =
                      StringTheoryUtil.createString(
                        regex2AFA.buildStrings(a(1)))
                    val substitution: String =
                      StringTheoryUtil.createString(
                        regex2AFA.buildStrings(a(2)))
                    val (afa1, afa2) =
                      ReplaceAll.getAFAs(pattern, substitution)
                    val aux =
                      new ConstantTerm("" + deps.head + defs.head + "_" + auxVar)
                    auxVar += 1
//println(afa)
// this AFA should have two tracks (input + output), but apparently
// there is a third track?
                    splitUnaryTransducer(deps.head, aux, afa1)
                    splitUnaryTransducer(aux, defs.head, afa2)
                  }

                  // WordDiff
                  case Some(a) if a.pred == wordDiff =>

                  // Transducer
                  case Some(a) if (RRFunsToAFA get a.pred).isDefined => {
                    assert(deps.size == 1 && defs.size == 1)
                    val Some(afa) = RRFunsToAFA get a.pred
                    splitUnaryTransducer(deps.head, defs.head, afa)
                  }

                  // Positive membership query
                  case Some(a) if a.pred == member =>
                    splitMembership(deps.head, regex2AFA.buildAFA(a(1)))

                  // Negative membership query
                  case None => l.negativeLits.head match {
                    case a if a.pred == member =>
                      splitMembership(deps.head,
                                      regex2AFA.buildComplAFA(a(1)))
                  }
                }

                false
              } else {
                true
              }
          }
        }

        if (nodes.nonEmpty)
          throw new Exception("Formula is not straightline!")
      }

      println("After splitting and topological sorting: " +
              nodeSequence.size + " AFAs")

/*
      println
      println("Straight-line constraints:")
        for (n <- nodeSequence)
          println(n)
*/

      //////////////////////////////////////////////////////////////////////
      // Eliminate concrete words in the nodes

      val termNodeSequence = new ArrayBuffer[AFANode]

      for ((vars, afa) <- nodeSequence) {
        val newVars = for (v <- vars) yield v match {
          case Seq(Left(_), _*) | Seq() => {
            val stringVar =
              new ConstantTerm("temp_" + termNodeSequence.size)
            termNodeSequence += ((List(stringVar), regex2AFA string2AFA v))
            stringVar
          }
          case Seq(Right(t)) =>
            t
        }
        termNodeSequence += ((newVars, afa))
      }

      //////////////////////////////////////////////////////////////////////
      // Synchronise the AFAs by building a tree representing the
      // dependencies

      val allNodeVars =
        (for (n <- termNodeSequence.iterator; t <- containedVars(n))
         yield t).toList.distinct

      val afaTrees : Seq[AFATree] = {
        val handledVars = new MHashSet[Term]
        val remainingNodes = new LinkedHashSet[AFANode]

        remainingNodes ++= termNodeSequence

        def constructTreeFor(x : Term) : AFATree = {
          val relNodes =
            (remainingNodes.iterator filter {
               p => containedVars(p) contains x
             }).toList

          remainingNodes --= relNodes

          val subtrees =
            for (a <- relNodes) yield {
              val subtrees2 =
                (for (y <- containedVars(a);
                      if x != y;
                      t = {
                        if (!(handledVars add y))
                          throw new Exception("Not straightline!")
                        constructTreeFor(y)
                      })
                 yield t).toList
              Tree(Right(a), subtrees2)
            }

          Tree(Left(x), subtrees)
        }

        (for (x <- allNodeVars.iterator; if (handledVars add x)) yield {
           constructTreeFor(x)
         }).toList
      }

//      println
      println("After treeification: " + afaTrees.size + " trees")

//          for (t <- afaTrees) {
//            println
//            t.prettyPrint
//          }

      //////////////////////////////////////////////////////////////////////
      // merge the nodes to a single AFA

      if (afaTrees.isEmpty) {
        // then it has to be sat, choose a trivial model
        Some(constructModel(Map()))
      } else {
        val (afa, terms) = {
          var charOffset = 0
          val (afas, terms) =
            (for (t <- afaTrees) yield {
               val (afa, terms) = afaTree2AFA(t)
               val charMapping =
                 (for (n <- 0 until terms.size)
                  yield (n -> (n + charOffset))).toMap
               charOffset = charOffset + terms.size
               (afa permuteChars charMapping, terms)
             }).unzip
          (afas reduceLeft (AFA.conjoin(_, _)), terms.flatten)
        }

        print("Final AFA has " + afa.states.size + " states ")
//            println(afa)
//            println("over variables: " + terms)

        FindAcceptedWords(afa) match {
          case Some(words) => {
            println(" ... is non-empty!")
            val wordWords =
              words map { w => (w map (Left(_))).toList }
            Some(constructModel((terms zip wordWords).toMap))
          }
          case None => {
            println(" ... is empty!")
            None
          }
        }
      }

      //////////////////////////////////////////////////////////////////////

      } else {

      println("Using tree-based solver")

      //////////////////////////////////////////////////////////////////////
      val wordVariablesInConstraints = new LinkedHashSet[Term]

      for (a <- constraintAtoms.positiveLits.iterator ++
        constraintAtoms.negativeLits.iterator;
           t <- wordArguments(a);
           if wordVariables contains t)
        wordVariablesInConstraints += t

      def containedVars(conj : PredConj) : Iterator[Term] =
        for (a <- conj.positiveLits.iterator ++ conj.negativeLits.iterator;
             x <- wordArguments(a);
             if (wordVariables contains x))
        yield x

      type ConstraintTree = Tree[Either[Term, PredConj]]

      val constraintTrees : Seq[ConstraintTree] = {
        val handledVars = new MHashSet[Term]
        val remainingAtoms = new LinkedHashSet[PredConj]

        remainingAtoms ++= constraintAtoms.iterator

        def constructTreeFor(x : Term) : ConstraintTree = {
          val relAtoms =
            (remainingAtoms.iterator filter {
               p => containedVars(p) contains x
             }).toList

          remainingAtoms --= relAtoms

          val subtrees =
            for (a <- relAtoms) yield {
              val subtrees2 =
                (for (y <- containedVars(a);
                      if x != y;
                      t = {
                        if (!(handledVars add y))
                          throw new Exception(
                            "Regular constraints are not tree-shaped")
                        constructTreeFor(y)
                      })
                 yield t).toList
              Tree(Right(a), subtrees2)
            }

          Tree(Left(x), subtrees)
        }

        (for (x <- wordVariablesInConstraints.iterator;
              if (handledVars add x)) yield {
           constructTreeFor(x)
         }).toList
      }

      //////////////////////////////////////////////////////////////////////

      def encodeAtom(constraint : PredConj) : (AFA, Seq[Term]) = {
        val vars = containedVars(constraint).toList
        if (constraint.negativeLits.isEmpty) {
          val a = constraint.positiveLits.head
          if (a.pred == member) {
            (regex2AFA.buildAFA(a(1)), vars)
          } else if (a.pred == wordDiff) {
            (AFA.diffWordTransducer, vars)
          } else if(a.pred == p(replace)) {
            val pattern: String = 
              StringTheoryUtil.createString(regex2AFA.buildStrings(a(1)))
            val substitution: String = 
              StringTheoryUtil.createString(regex2AFA.buildStrings(a(2)))
            val afa = Replace(pattern, substitution)

            (afa, vars.head :: vars.last :: Nil)
          } else if(a.pred == p(replaceall)) {
            val pattern: String = 
              StringTheoryUtil.createString(regex2AFA.buildStrings(a(1)))
            val substitution: String = 
              StringTheoryUtil.createString(regex2AFA.buildStrings(a(2)))
//                println("str.replace(" + a.head + ", " + pattern + ", " + substitution + ")")
            val afa = ReplaceAll(pattern, substitution)
            val aux: Term = 
              new ConstantTerm("" + vars.head + vars.last + "_" + auxVar)

            auxVar += 1
//                println("result transducer representing as AFA has " +
//                  afa.states.size + " states")

            (afa, vars.head :: aux :: vars.last :: Nil)
          } else (RRFunsToAFA get a.pred) match {
            case Some(afa) => {
              if (!(a.last.isConstant && a.last.constant.isZero))
                throw new Exception (
                  "Only positive occurrences of transducers are supported at the moment, not " + a)
              (afa, vars.reverse)
            }
            case None =>
              throw new Exception ("Don't know how to handle " + constraint)
          }
        } else {
          val a = constraint.negativeLits.head
          if (a.pred == member) {
            (regex2AFA.buildComplAFA(a(1)), vars)
          } else {
            throw new Exception ("Don't know how to handle " + constraint)
          }
        }
      }

      def tree2AFA(tree : ConstraintTree) : (AFA, Seq[Term]) = tree match {
        case Tree(Right(constraint), List()) =>
          encodeAtom(constraint)
        case Tree(Left(x), children) => {
          val (childAFAs, childVars) = (children map tree2AFA).unzip
          val allVars = (List(x) ++ childVars.flatten).distinct
          val xInd = allVars indexOf x

          val regexAFA =
            if (childAFAs.isEmpty) {
              fixCharacters(AFA.universalAutomaton, List(x), allVars)
            } else {
              val shiftedAFAs =
                for ((afa, vars) <- childAFAs zip childVars)
                yield fixCharacters(afa, vars, allVars)

              shiftedAFAs reduceLeft (AFA.synchronise(_, _, xInd))
            }

          val completeAFA = (regex2AFA extractEqConstraints x) match {
            case Some(afa) =>
              AFA.synchronise(regexAFA,
                              fixCharacters(afa, List(x), allVars),
                              xInd)
            case None =>
              regexAFA
          }

          (completeAFA, allVars)
        }
        case Tree(Right(constraint), children) => {
          val (topAFA, topVars) = encodeAtom(constraint)
          val (childAFAs, childVars) = (children map tree2AFA).unzip
          val syncVars = for (Tree(Left(v), _) <- children) yield v

          assert(childAFAs.size == syncVars.size)

          val allVars = (topVars ++ childVars.flatten).distinct

          val shiftedTopAFA =
            fixCharacters(topAFA, topVars, allVars)
          val shiftedAFAs =
            for ((afa, vars) <- childAFAs zip childVars)
            yield fixCharacters(afa, vars, allVars)

          val completeAFA =
            (shiftedTopAFA /: (shiftedAFAs zip syncVars)) {
              case (afa1, (afa2, x)) =>
                AFA.synchronise(afa1, afa2, allVars indexOf x)
            }
          (completeAFA, allVars)
        }
      }

      //////////////////////////////////////////////////////////////////////

      val model = new MHashMap[Term, Word]

      val satisfiable = constraintTrees forall { tree =>
        println("Solving constraints:")
        tree.prettyPrint
        println

        val (afa, vars) = tree2AFA(tree)
        print("Resulting AFA over variables " +
              (vars mkString ", ") + " has " +
              afa.states.size + " states ")
//            println(afa)
//            println("over variables: " + vars)

        if(Flags.isSimpleModelChecker) {
          if(SimpleModelChecker(afa)) {
            println(" ... is non-empty!")
            true
          } else {
            println(" ... is empty!")
            false
          }
        } else {
          FindAcceptedWords(afa) match {
            case Some(words) => {
              println(" ... is non-empty!")
              val wordWords =
                words map { w => (w map (Left(_))).toList }
              model ++= vars zip wordWords
              true
            }
            case None => {
              println(" ... is empty!")
              false
            }
          }
        }
      }

      if (satisfiable)
        Some(model.toMap filterKeys wordVariables)
      else
        None

      }
    }

    ////////////////////////////////////////////////////////////////////////////

    override def handleGoal(goal : Goal) : Seq[Plugin.Action] = goalState(goal) match {

      case Plugin.GoalState.Final => Console.withOut(Console.err) {
        import TerForConvenience._
        implicit val _ = goal.order

//println("handleGoal:")
//println(goal)

        ////////////////////////////////////////////////////////////////////////
        // first check for cyclic word equations, and break those
        // e.g., equations x = yz & y = ax  ->  z = eps & a = eps & y = ax
        // Tarjan's algorithm is used to find all strongly connected components

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

        if (newAtoms.nonEmpty || removedAtoms.nonEmpty) {

//          println("new:     " + newAtoms.toList)
//          println("removed: " + removedAtoms.toList)
          List(Plugin.RemoveFacts(conj(removedAtoms)),
               Plugin.AddFormula(!conj(newAtoms)))

        } else {

          findStringModel(goal) match {
            case Some(model) => List()
            case None        => List(Plugin.AddFormula(Conjunction.TRUE))
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
        findStringModel(goal) match {
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

  private def fixCharacters(afa : AFA,
                            vars : Seq[Term], allVars : Seq[Term]) : AFA = {
            val mapping =
              (for ((v, i) <- vars.iterator.zipWithIndex)
               yield (i -> (allVars indexOf v))).toMap
            afa permuteChars mapping
          }

  private type Word = List[Either[Int, Term]]

  private def splitWord(w : Word) : List[Word] = w match {
            case (t@Right(_)) :: wr => List(t) :: splitWord(wr)
            case (f@Left(_)) :: wr => splitWord(wr) match {
              case (p@(Left(_) :: _)) :: rest => (f :: p) :: rest
              case rest => List(f) :: rest
            }
            case List() => List()
          }

  private type AFANode = (Seq[Term], AFA)
  private type AFATree = Tree[Either[Term, AFANode]]

  private def containedVars(n : AFANode) : Iterator[Term] = n._1.iterator

  private def afaTree2AFA(tree : AFATree) : (AFA, Seq[Term]) = tree match {
            case Tree(Right(node), List()) =>
              (node._2, node._1)
            case Tree(Left(x), children) => {
              val (childAFAs, childVars) = (children map afaTree2AFA).unzip
              val allVars = (List(x) ++ childVars.flatten).distinct
              val xInd = allVars indexOf x

              val regexAFA =
                if (childAFAs.isEmpty) {
                  fixCharacters(AFA.universalAutomaton, List(x), allVars)
                } else {
                  val shiftedAFAs =
                    for ((afa, vars) <- childAFAs zip childVars)
                    yield fixCharacters(afa, vars, allVars)

                  shiftedAFAs reduceLeft (AFA.synchronise(_, _, xInd))
                }

              (regexAFA, allVars)
            }
            case Tree(Right(node), children) => {
              val (topVars, topAFA) = node
              val (childAFAs, childVars) = (children map afaTree2AFA).unzip
              val syncVars = for (Tree(Left(v), _) <- children) yield v

              assert(childAFAs.size == syncVars.size)

              val allVars = (topVars ++ childVars.flatten).distinct

              val shiftedTopAFA =
                fixCharacters(topAFA, topVars, allVars)
              val shiftedAFAs =
                for ((afa, vars) <- childAFAs zip childVars)
                yield fixCharacters(afa, vars, allVars)

              val completeAFA =
                (shiftedTopAFA /: (shiftedAFAs zip syncVars)) {
                  case (afa1, (afa2, x)) =>
                    AFA.synchronise(afa1, afa2, allVars indexOf x)
                }
              (completeAFA, allVars)
            }
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
