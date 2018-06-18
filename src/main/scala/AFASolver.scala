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
import dk.brics.automaton.{Automaton, BasicAutomata, BasicOperations, RegExp}

import scala.collection.mutable
import scala.collection.mutable.{ArrayBuffer, LinkedHashMap, LinkedHashSet, HashMap => MHashMap, HashSet => MHashSet}

/**
 * AFA-based string solving methods, used from the StringTheory
 */
class AFASolver {

  import StringTheory.{member, replaceall, replace,
                       wordEps, wordCat, wordChar, wordDiff}

  private val p = StringTheory.functionPredicateMap

    private val constraintPreds = Set(member, p(replaceall), p(replace))
    private val wordPreds = Set(p(wordEps), p(wordCat), p(wordChar))

    private val modelCache =
      new ap.util.LRUCache[Conjunction, Option[Map[Term, Word]]](3)

    def findStringModel(goal : Goal) : Option[Map[Term, Word]] =
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

}
