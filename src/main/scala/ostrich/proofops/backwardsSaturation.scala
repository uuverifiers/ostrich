package ostrich.proofops


import ostrich._
import ostrich.automata.{AtomicStateAutomaton, AutDatabase, Automaton, BricsAutomaton}
import ap.basetypes.IdealInt
import ap.parser.IFunction
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.proof.theoryPlugins.Plugin.{AddAxiom, AxiomSplit}
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
import ap.terfor.{RichPredicate, Term}

import scala.collection.{breakOut, mutable}
import ap.parser.IFunction
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.{Formula, Term}
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.Atom
import ap.theories.{SaturationProcedure, Theory}
import ostrich.OstrichStringFunctionTranslator
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.preop.{ConcatPreOp, PreOp}

import scala.collection.breakOut
import scala.collection.mutable.{ArrayBuffer, BitSet => MBitSet, HashMap => MHashMap, MultiMap => MMultiMap, Set => MSet}
class backwardsSaturation(theory: OstrichStringTheory) extends SaturationProcedure("backwardsPropagation") {

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

  private var termConstraintMap: MMultiMap[Term, (Automaton, Option[Atom])] =
    new MHashMap[Term, MSet[(Automaton, Option[Atom])]] with MMultiMap[Term, (Automaton, Option[Atom])]

  private val atomToId = new MHashMap[Atom, Int]()
  val autDatabase: AutDatabase = theory.autDatabase
  private var sortedFunAppsGlobal :  Seq[(Seq[(PreOp, Seq[Term], Atom)], Term)] = Seq()


  // Option for Sigma^*
  type ApplicationPoint = (Atom, Option[Atom])


  def extractApplicationPoints(goal : Goal) : Iterator[ApplicationPoint] = {

    processGoal(goal)
    val result : ArrayBuffer[(Atom, Option[Atom])] = new ArrayBuffer()
    for ((apps, res) <- sortedFunAppsGlobal.reverseIterator;
    (op, args, formula) <- apps){
      val regularExpressions = termConstraintMap(res).map(_._2)
      for (regex <- regularExpressions){
        result += ((formula, regex))
      }
    }
    result.toIterator
  }


  // atom str_in_re_id to aut
  def applicationPriority(goal : Goal, p : ApplicationPoint) : Int = {
    /*
    val stringFunctionTranslator =
      new OstrichStringFunctionTranslator(theory, goal.facts)

    Decide what to propagate first and which regex to propagate

    propagate good functions first
    propagate small aut first

    val atom = p._1
    val tmp : Term = atom.pred match {
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(atom) match {
          case Some((op, args, res)) =>
            print(res)
            res
          case _ =>
            throw new Exception ("Cannot handle literal " + atom)
        }
      case _ => throw new Exception ("Cannot handle literal " + atom)
      // nothing
    }
    val auts = termConstraintMap(tmp).map(_._1).toSeq
    */

    if (p._2.isEmpty){
       0
    }
    else {
      val autId = atomToId.get(p._2.get)
      val aut = autDatabase.id2Aut(autId.get)
      val priority = aut match {
        case automaton: AtomicStateAutomaton => automaton.states.size
        case base: CostEnrichedAutomatonBase => base.states.size
        case _ => 0
      }
       priority
    }
  }

  def handleApplicationPoint(goal : Goal, appPoint : ApplicationPoint) : Seq[Plugin.Action]= {
    /*
    easy: call extract application points first and check if fAtom is still in extractApplicationPoints
    hard: check if fAtom is in goal

    we have a candidate
    check if the candidate still exists -- both atoms still exist still in goal -- see above
    compute preop

    optimize: check if one branch has gained no new information -- throw away application point

    return AxiomSplit of the preop

     */
    val stringFunctionTranslator =
      new OstrichStringFunctionTranslator(theory, goal.facts)
    val allApplicationPoints = extractApplicationPoints(goal)
    if (!allApplicationPoints.toSet.contains(appPoint)){
      return List()
    }
    // atom to preop, args, res
    val atom = appPoint._1
    val (op, args, res)  = atom.pred match {
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(atom) match {
          case Some((op, args, res)) =>
            (op(), args, res)
          case _ =>
            throw new Exception ("Cannot handle literal " + atom)
        }
      case _ => throw new Exception ("Cannot handle literal " + atom)
      // nothing
    }
    val str_in_re_id_app = new RichPredicate(str_in_re_id, goal.order)

    val argAuts = for (a <- args) yield termConstraintMap(a).map(_._1).toSeq;
    // str_in_re to aut map
    if (appPoint._2.isEmpty){
      // concrete string or sigma^*
      val concrete = strDatabase.term2List(res)
      if (concrete.isDefined){
        val str : String = concrete.get.map(i => i.toChar)(breakOut)
        val concreteAut = BricsAutomaton.fromString(str)
        val (newConstraintsIt, _) = op(argAuts, concreteAut)
        val newConstraintsSeq = newConstraintsIt.toList

        val results = for {
          argCS <- newConstraintsSeq
        } yield {
          for {
            (a, aut) <-  args zip argCS
            autId = autDatabase.automaton2Id(aut)
            argTerm = LinearCombination(a, goal.order)
            lautId = LinearCombination(IdealInt(autId))
          } yield {
            //println(s"aut: $aut $counter")
            str_in_re_id_app(Seq(argTerm, lautId))}
        }
        val conjunctions = results.map{r => (Conjunction.conj(r,goal.order), Seq())}
        //println(Plugin.AxiomSplit(Seq(appPoint._1), conjunctions, theory))
        Seq(Plugin.AxiomSplit(Seq(appPoint._1), conjunctions, theory))

      }
      else{
        // Term is not concrete, but no regular constraint -> \Sigma^*
        val concreteAut = BricsAutomaton.makeAnyString()
        val (newConstraintsIt, argDependencies) = op(argAuts, concreteAut)
        val newConstraintsSeq = newConstraintsIt.toList

        val results = for {
          argCS <- newConstraintsSeq
        } yield {
          for {
            (a, aut) <- args zip argCS
            autId = autDatabase.automaton2Id(aut)
            argTerm = LinearCombination(a, goal.order)
            lautId = LinearCombination(IdealInt(autId))
          } yield {
            //println(s"aut: $aut $counter")
            str_in_re_id_app(Seq(argTerm, lautId))}
      }

        val conjunctions = results.map{r => (Conjunction.conj(r,goal.order), Seq())}
        //println(Plugin.AxiomSplit(Seq(appPoint._1), conjunctions, theory))
        Seq(Plugin.AxiomSplit(Seq(appPoint._1), conjunctions, theory))}
    }
    else{
      val l = atomToId(appPoint._2.get)
      println(l)
      val (newConstraintsIt, argDependencies) = op(argAuts, autDatabase.id2Aut(l))
      val assumptionRegex = str_in_re_id_app(Seq(LinearCombination(res, goal.order), LinearCombination(IdealInt(l))))

      val newConstraintsSeq = newConstraintsIt.toList

      val results = for {
        argCS <- newConstraintsSeq
      } yield {
        for {
          (a, aut) <- args zip argCS
          autId = autDatabase.automaton2Id(aut)
          argTerm = LinearCombination(a, goal.order)
          lautId = LinearCombination(IdealInt(autId))
        } yield {
          //println(s"aut: $aut $counter")
          str_in_re_id_app(Seq(argTerm, lautId))}
      }
      val conjunctions = results.map{r => (Conjunction.conj(r,goal.order), Seq())}
      //println(Plugin.AxiomSplit(Seq(appPoint._1, assumptionRegex), conjunctions, theory))
      Seq(Plugin.AxiomSplit(Seq(appPoint._1, assumptionRegex), conjunctions, theory))

    }
  }




  private def processGoal(goal: Goal) : Unit = {
    val atoms = goal.facts.predConj
    val regexExtractor = theory.RegexExtractor(goal)
    val stringFunctionTranslator =
      new OstrichStringFunctionTranslator(theory, goal.facts)

    val rexOps : Set[IFunction] = Set(
      re_none, re_all, re_allchar, re_charrange, re_++, re_union,
      re_inter, re_diff, re_*, re_*?, re_+, re_+?, re_opt, re_opt_?,
      re_comp, re_loop, re_loop_?, re_eps, str_to_re, re_from_str,
      re_capture, re_reference, re_begin_anchor, re_end_anchor,
      re_from_ecma2020, re_from_ecma2020_flags, re_case_insensitive
    )

    val (funApps, initialConstraints, lengthVars) = {
      val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term, Atom)]
      val regexes = new ArrayBuffer[(Term, Automaton, Atom)]
      val lengthVars = new MHashMap[Term, Term]

      def decodeRegexId(a : Atom, complemented : Boolean) : Unit
      = a(1) match {
        case LinearCombination.Constant(id) => {
          val autOption =
            if (complemented) {
              atomToId.put(a, id.intValueSafe)

              autDatabase.id2ComplementedAutomaton(id.intValueSafe)
            } else {
              atomToId.put(a, id.intValueSafe)

              autDatabase.id2Automaton(id.intValueSafe)

            }

          autOption match {
            case Some(aut) =>
              regexes += ((a.head, aut, a))

            case None =>
              throw new Exception ("Could not decode regex id " + a(1))
          }
        }
        case lc =>
          throw new Exception ("Could not decode regex id " + lc)
      }

      for (a <- atoms.positiveLits) a.pred match {
        case `str_in_re_id` =>
          decodeRegexId(a, false)
        case FunPred(`str_len`) => {
          lengthVars.put(a(0), a(1))
          if (a(1).isZero)
            regexes += ((a(0), BricsAutomaton fromString "", a))
        }
        case FunPred(`str_char_count`) => {
          // ignore
        }
        case `str_prefixof` => {
          val rightVar = theory.StringSort.newConstant("rhs")
          funApps += ((ConcatPreOp, List(a(0), rightVar), a(1), a))
        }
        case FunPred(f) if rexOps contains f =>
        // nothing
        case p if (theory.predicates contains p) =>
          stringFunctionTranslator(a) match {
            case Some((op, args, res)) =>
              funApps += ((op(), args, res, a))
            case _ =>
              throw new Exception ("Cannot handle literal " + a)
          }
        case _ =>
        // nothing
      }
      for (a <- atoms.negativeLits) a.pred match {
        case `str_in_re_id` =>
          decodeRegexId(a, true)
        case pred if theory.transducerPreOps contains pred =>
          throw new Exception ("Cannot handle negated transducer constraint " + a)
        case p if (theory.predicates contains p) =>
          // Console.err.println("Warning: ignoring !" + a)
          throw new Exception ("Cannot handle negative literal " + a)
        case _ =>
        // nothing
      }
      (funApps, regexes, lengthVars)
    }

    // TODO: these will likely need calculating externally and sharing
    // between backwards and forwards
    // allTerms -- all of the terms in the formula
    // sortedFunApps -- the funApps above but grouped by result. I.e. (op,
    // args, result, formula) becomes ([(op, args, formula)], result). The
    // sorted.
    // ignoredApps -- what was missed.
    val (allTerms, sortedFunApps, ignoredApps)
    : (Set[Term],
      Seq[(Seq[(PreOp, Seq[Term], Atom)], Term)],
      Seq[(PreOp, Seq[Term], Term, Atom)]) = {
      val argTermNum = new MHashMap[Term, Int]
      for ((_, _, res, _) <- funApps)
        argTermNum.put(res, 0)
      for ((t, _, _) <- initialConstraints)
        argTermNum.put(t, 0)
      for ((t, _) <- lengthVars)
        argTermNum.put(t, 0)
      for ((_, args, _, _) <- funApps; a <- args)
        argTermNum.put(a, argTermNum.getOrElse(a, 0) + 1)

      var ignoredApps = new ArrayBuffer[(PreOp, Seq[Term], Term, Atom)]
      var remFunApps  = funApps
      val sortedApps  = new ArrayBuffer[(Seq[(PreOp, Seq[Term], Atom)], Term)]

      while (!remFunApps.isEmpty) {
        val (selectedApps, otherApps) =
          remFunApps partition { case (_, _, res, _) =>
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

          for ((_, args, _, _) <- selectedApps; a <- args)
            argTermNum.put(a, argTermNum.getOrElse(a, 0) - 1)

          val appsPerRes = selectedApps groupBy (_._3)
          val nonArgTerms = (selectedApps map (_._3)).distinct

          for (t <- nonArgTerms)
            sortedApps +=
              ((for ((op, args, _, f) <- appsPerRes(t)) yield (op, args, f), t))

        }
      }

      (argTermNum.keySet.toSet, sortedApps.toSeq, ignoredApps.toSeq)
    }
    def getTermConstraints : MMultiMap[Term, (Automaton, Option[Atom])] = {
      val termConstraints = new MHashMap[Term, MSet[(Automaton, Option[Atom])]]
        with MMultiMap[Term, (Automaton, Option[Atom])]

      for ((t, aut, atom) <- initialConstraints) {
        termConstraints.addBinding(t, (aut, Some(atom)))
      }

      // Make sure "implicit" constraints are taken care of also (e.g. x
      // in Sigma*)
      val term2Index =
        (for (((_, t), n) <- sortedFunApps.iterator.zipWithIndex)
          yield (t -> n)).toMap

      val coveredTerms = new MBitSet
      for ((t, _, _) <- initialConstraints)
        for (ind <- term2Index get t)
          coveredTerms += ind

      // check whether any of the terms have concrete definitions
      for (t <- allTerms) {
        for (w <- strDatabase.term2List(t)) {
          val str : String = w.map(i => i.toChar)(breakOut)
          termConstraints.addBinding(
            t, (BricsAutomaton fromString str, None)
          )
          for (ind <- term2Index get t)
            coveredTerms += ind
        }
        if (!termConstraints.contains(t)){
          termConstraints.addBinding(t, (BricsAutomaton.makeAnyString(), None))
        }
      }

      termConstraints
    }

    // Update Contents

    sortedFunAppsGlobal = sortedFunApps
    termConstraintMap = getTermConstraints
  }
}