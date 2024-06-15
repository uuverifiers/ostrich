/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2024 Matthew Hague, Philipp Ruemmer. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich.proofops

import ostrich._
import ostrich.automata.{Automaton, BricsAutomaton, AutomataUtils}
import ostrich.preop.{ConcatPreOp, PreOp}

import ap.parser.IFunction
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.Term
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.{Atom, PredConj}

import scala.collection.breakOut
import scala.collection.mutable.{
  ArrayBuffer,
  ArrayStack,
  BitSet => MBitSet,
  HashMap => MHashMap
}

object OstrichForwardsProp {
  case class TermConstraint(t : Term, aut : Automaton)
  type ConflictSet = Seq[TermConstraint]

  abstract class ConstraintStore {
    def push : Unit

    def pop : Unit

    /**
     * Add new automata to the store, return a sequence of term constraints
     * in case the asserted constraints have become inconsistent
     */
    def assertConstraint(aut : Automaton) : Option[ConflictSet]

    /**
     * Check whether input automaton is superset of current constraints
     * Not implemented for eager
     * @param aut
     * @return true if constraints.getComplete \subseteq aut
     */
    def isSuperSet(aut : Automaton) : Boolean

    /**
     * Return some representation of the asserted constraints
     */
    def getContents : List[Automaton]

    /**
     * Return all constraints that were asserted (without any modifications)
     */
    def getCompleteContents : List[Automaton]

    /**
     * Make sure that the exact length abstraction for the intersection of the
     * stored automata has been pushed to the length prover
     */
    def ensureCompleteLengthConstraints : Unit

    /**
     * Check whether some word is accepted by all the stored constraints
     */
    def isAcceptedWord(w : Seq[Int]) : Boolean

    /**
     * Produce an arbitrary word accepted by all the stored constraints
     */
    def getAcceptedWord : Seq[Int]

    /**
     * Produce a word of length <code>len</code> accepted by all the stored
     * constraints
     */
    def getAcceptedWordLen(len : Int) : Seq[Int]
  }
}

class OstrichForwardsProp(goal : Goal,
                          theory : OstrichStringTheory,
                          flags : OFlags) {
  import OstrichForwardsProp._
  import theory.{
    str_from_char, str_len, str_empty, str_cons, str_++, str_in_re,
    str_char_count, str_in_re_id, str_to_re, re_from_str,
    re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive,
    str_replace, str_replacere, str_replaceall, str_replaceallre,
    str_prefixof, re_none, re_all, re_allchar, re_charrange, re_++,
    re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt,
    re_opt_?, re_comp, re_loop, re_loop_?, re_eps, re_capture,
    re_reference, re_begin_anchor, re_end_anchor, FunPred, strDatabase
  }

  private val atoms = goal.facts.predConj
  private val regexExtractor = theory.RegexExtractor(goal)
  private val autDatabase = theory.autDatabase
  private val stringFunctionTranslator =
      new OstrichStringFunctionTranslator(theory, goal.facts)
  private val constraintStores = new MHashMap[Term, ConstraintStore]

  val rexOps : Set[IFunction] = Set(
    re_none, re_all, re_allchar, re_charrange, re_++, re_union,
    re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?,
    re_comp, re_loop, re_loop_?, re_eps, str_to_re, re_from_str,
    re_capture, re_reference, re_begin_anchor, re_end_anchor,
    re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive
  )

  private val (funApps, initialConstraints, lengthVars) = {
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes = new ArrayBuffer[(Term, Automaton)]
    val lengthVars = new MHashMap[Term, Term]

    def decodeRegexId(a : Atom, complemented : Boolean) : Unit
      = a(1) match {
        case LinearCombination.Constant(id) => {
          val autOption =
            if (complemented)
              autDatabase.id2ComplementedAutomaton(id.intValueSafe)
            else
              autDatabase.id2Automaton(id.intValueSafe)

          autOption match {
            case Some(aut) =>
              regexes += ((a.head, aut))
            case None =>
              throw new Exception ("Could not decode regex id " + a(1))
          }
        }
        case lc =>
          throw new Exception ("Could not decode regex id " + lc)
      }

    for (a <- atoms.positiveLits) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, false)
      case FunPred(`str_len`) => {
        lengthVars.put(a(0), a(1))
        if (a(1).isZero)
          regexes += ((a(0), BricsAutomaton fromString ""))
      }
      case FunPred(`str_char_count`) => {
        // ignore
      }
      case `str_prefixof` => {
        val rightVar = theory.StringSort.newConstant("rhs")
        funApps += ((ConcatPreOp, List(a(0), rightVar), a(1)))
      }
      case FunPred(f) if rexOps contains f =>
        // nothing
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(a) match {
          case Some((op, args, res)) =>
            funApps += ((op(), args, res))
          case _ =>
            throw new Exception ("Cannot handle literal " + a)
        }
      case _ =>
        // nothing
    }
    (funApps, regexes, lengthVars)
  }

  // TODO: these will likely need calculating externally and sharing
  // between backwards and forwards
  private val (allTerms, sortedFunApps, ignoredApps)
  : (Set[Term],
    Seq[(Seq[(PreOp, Seq[Term])], Term)],
    Seq[(PreOp, Seq[Term], Term)]) = {
    val argTermNum = new MHashMap[Term, Int]
    for ((_, _, res) <- funApps)
      argTermNum.put(res, 0)
    for ((t, _) <- initialConstraints)
      argTermNum.put(t, 0)
    for ((t, _) <- lengthVars)
      argTermNum.put(t, 0)
    for ((_, args, _) <- funApps; a <- args)
      argTermNum.put(a, argTermNum.getOrElse(a, 0) + 1)

    var ignoredApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    var remFunApps  = funApps
    val sortedApps  = new ArrayBuffer[(Seq[(PreOp, Seq[Term])], Term)]

    while (!remFunApps.isEmpty) {
      val (selectedApps, otherApps) =
        remFunApps partition { case (_, _, res) =>
          argTermNum(res) == 0 ||
            strDatabase.isConcrete(res) }

      if (selectedApps.isEmpty) {

        if (ignoredApps.isEmpty)
          Console.err.println(
            "Warning: cyclic definitions found, ignoring some function " +
              "applications")
        ignoredApps += remFunApps.head
        remFunApps = remFunApps.tail

      } else {

        remFunApps = otherApps

        for ((_, args, _) <- selectedApps; a <- args)
          argTermNum.put(a, argTermNum.getOrElse(a, 0) - 1)

        val appsPerRes = selectedApps groupBy (_._3)
        val nonArgTerms = (selectedApps map (_._3)).distinct

        for (t <- nonArgTerms)
          sortedApps +=
            ((for ((op, args, _) <- appsPerRes(t)) yield (op, args), t))

      }
    }

    (argTermNum.keySet.toSet, sortedApps.toSeq, ignoredApps.toSeq)
  }

  def apply : Seq[Plugin.Action] = {
    for (t <- allTerms)
      constraintStores.put(t, newStore(t))

    // check whether we have to add further regex constraints to ensure
    // completeness; otherwise not all pre-images of function applications might
    // be considered
    val allInitialConstraints = {
      val term2Index =
        (for (((_, t), n) <- sortedFunApps.iterator.zipWithIndex)
          yield (t -> n)).toMap

      val coveredTerms = new MBitSet
      for ((t, _) <- initialConstraints)
        for (ind <- term2Index get t)
          coveredTerms += ind

      val additionalConstraints = new ArrayBuffer[(Term, Automaton)]

      // check whether any of the terms have concrete definitions
      for (t <- allTerms)
        for (w <- strDatabase.term2List(t)) {
          val str : String = w.map(i => i.toChar)(breakOut)
          additionalConstraints += ((t, BricsAutomaton fromString str))
          for (ind <- term2Index get t)
            coveredTerms += ind
        }

      for (n <- 0 until sortedFunApps.size;
           if {
             if (!(coveredTerms contains n)) {
               coveredTerms += n
               additionalConstraints +=
                 ((sortedFunApps(n)._2, BricsAutomaton.makeAnyString()))
             }
             true
           };
           (_, args) <- sortedFunApps(n)._1;
           arg <- args)
        for (ind <- term2Index get arg)
          coveredTerms += ind

      initialConstraints ++ additionalConstraints
    }

    for ((t, aut) <- allInitialConstraints) {
      constraintStores(t).assertConstraint(aut) match {
        case Some(_) => List() // return conflict set?
        case None    => // nothing
      }
    }

    // TODO: return seq of AddAxiom for discovered constraints
    // so use constraint stores?
    val res = addForwardConstraints
    if (res.isDefined) {
      // return close with axiom?
      List()
    } else {
      // return seq of new constraints
      List()
    }
  }

  /**
   * Propagates approximate constraints forwards from the root, adds new
   * constraints to constraintStores
   */
  private def addForwardConstraints : Option[ConflictSet] = {
    for ((apps, res) <- sortedFunApps.reverseIterator;
         (op, args) <- apps) {
      val arguments = for (a <- args)
        yield constraintStores(a).getCompleteContents
      val resultConstraint = op.forwardApprox(arguments)
      if (constraintStores(res).isSuperSet(resultConstraint)){
        //println("Forward is saturated") TODO do something with that info?
      }
      else {
        val r = constraintStores(res).assertConstraint(resultConstraint)
        // Forward has found conlict
        if (r.isDefined) return r
      }
    }
    None
  }

  private def newStore(t : Term) : ConstraintStore = new ConstraintStore {
    private val constraints = new ArrayBuffer[Automaton]
    private var currentConstraint : Option[Automaton] = None
    private val constraintStack = new ArrayStack[(Int, Option[Automaton])]

    def push : Unit =
      constraintStack push (constraints.size, currentConstraint)

    def pop : Unit = {
      val (oldSize, lastCC) = constraintStack.pop
      constraints reduceToSize oldSize
      currentConstraint = lastCC
    }

    override def isSuperSet(aut: Automaton): Boolean = {
      false
    }

    def assertConstraint(aut : Automaton) : Option[ConflictSet] =
      if (aut.isEmpty) {
        Some(List(TermConstraint(t, aut)))
      } else {
        currentConstraint match {
          case Some(oldAut) => {
            val newAut = measure("intersection") { oldAut & aut }
            if (newAut.isEmpty) {
              Some(for (a <- aut :: constraints.toList)
                yield TermConstraint(t, a))
            } else {
              constraints += aut
              currentConstraint = Some(newAut)
              addLengthConstraint(TermConstraint(t, newAut),
                for (a <- constraints)
                  yield TermConstraint(t, a))
              None
            }
          }
          case None => {
            constraints += aut
            currentConstraint = Some(aut)
            val c = TermConstraint(t, aut)
            addLengthConstraint(c, List(c))
            None
          }
        }
      }

    def getContents : List[Automaton] =
      currentConstraint.toList
    def getCompleteContents : List[Automaton] =
      constraints.toList

    def ensureCompleteLengthConstraints : Unit = ()

    def isAcceptedWord(w : Seq[Int]) : Boolean =
      currentConstraint match {
        case Some(aut) => aut(w)
        case None      => true
      }

    def getAcceptedWord : Seq[Int] =
      currentConstraint match {
        case Some(aut) => aut.getAcceptedWord.get
        case None      => List()
      }

    def getAcceptedWordLen(len : Int) : Seq[Int] =
      currentConstraint match {
        case Some(aut) => AutomataUtils.findAcceptedWord(List(aut), len).get
        case None      => List()
      }
  }

  private def addLengthConstraint(constraint : TermConstraint,
                                    sources : Seq[TermConstraint]) : Unit = {
    // TODO: do we still want to track length constraints here?
    //for (p <- lengthProver) {
    //  lengthPartitions += sources
    //  p setPartitionNumber lengthPartitions.size
    //  val TermConstraint(t, aut) = constraint
    //  p addAssertion VariableSubst(0, List(lengthVars(t)), p.order)(
    //    aut.getLengthAbstraction)
    //}
  }

  private def measure[A](op : String)(comp : => A) : A =
    if (flags.measureTimes)
      ap.util.Timer.measure(op)(comp)
    else
      comp
}
