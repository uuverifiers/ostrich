package ostrich.cesolver.stringtheory

import ostrich.automata.{Automaton, BricsAutomaton}
import ostrich.preop.PreOp

import ap.SimpleAPI
import ap.parser.IFunction
import ap.terfor.{Term, TerForConvenience, ConstantTerm, OneTerm}
import ap.terfor.preds.Atom
import ap.terfor.linearcombination.LinearCombination
import ap.types.Sort
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.basetypes.IdealInt
import ostrich.cesolver.convenience.CostEnrichedConvenience.automaton2CostEnriched


import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet
}

import ostrich.cesolver.preop.{SubStringCEPreOp, IndexOfCEPreOp}
import ostrich.cesolver.automata.BricsAutomatonWrapper
import ostrich.cesolver.core.ParikhExploration
import ap.parser.Internal2InputAbsy
import ostrich.{OFlags, OstrichSolver}
import ostrich.cesolver.preop.ConcatCEPreOp
import ostrich.cesolver.util.ParikhUtil

class CESolver(theory: CEStringTheory, flags: OFlags) {

  import OstrichSolver._
  import theory.{
    str_len,
    str_in_re,
    str_char_count,
    str_in_re_id,
    str_to_re,
    re_from_str,
    re_from_ecma2020,
    re_from_ecma2020_flags,
    re_case_insensitive,
    str_prefixof,
    re_none,
    re_all,
    re_allchar,
    re_charrange,
    re_++,
    re_union,
    re_inter,
    re_diff,
    re_*,
    re_*?,
    re_+,
    re_+?,
    re_opt,
    re_opt_?,
    re_comp,
    re_loop,
    re_loop_?,
    re_eps,
    re_capture,
    re_reference,
    re_begin_anchor,
    re_end_anchor,
    FunPred,
    strDatabase
  }

  val rexOps: Set[IFunction] =
    Set(
      re_none,
      re_all,
      re_allchar,
      re_charrange,
      re_++,
      re_union,
      re_inter,
      re_diff,
      re_*,
      re_*?,
      re_+,
      re_+?,
      re_opt,
      re_opt_?,
      re_comp,
      re_loop,
      re_loop_?,
      re_eps,
      str_to_re,
      re_from_str,
      re_capture,
      re_reference,
      re_begin_anchor,
      re_end_anchor,
      re_from_ecma2020,
      re_from_ecma2020_flags,
      re_case_insensitive
    )

  private val p = theory.functionPredicateMap

  private val autDatabase = theory.ceAutDatabase

  def findStringModel(
      goal: Goal
  ): Option[Map[Term, Either[IdealInt, Seq[Int]]]] = {
    ParikhUtil.log("CESolver.findStringModel")
    ParikhUtil.log("  goal.arithConj ... " + goal.facts.arithConj)
    ParikhUtil.log("  goal.predConj  ... " + goal.facts.predConj)

    val atoms = goal.facts.predConj
    val order = goal.order

    val containsLength = !(atoms positiveLitsWithPred p(str_len)).isEmpty
    flags.eagerAutomataOperations

    val useLength = flags.useLength match {

      case OFlags.LengthOptions.Off => {
        if (containsLength)
          Console.err.println(
            "Warning: problem uses the string length operator, but -length=off"
          )
        false
      }

      case OFlags.LengthOptions.On =>
        true

      case OFlags.LengthOptions.Auto => {
        if (containsLength)
          Console.err.println(
            "Warning: assuming -length=on to handle length constraints"
          )
        containsLength
      }

    }

    val regexExtractor =
      theory.RegexExtractor(goal)
    val stringFunctionTranslator =
      new CEStringFunctionTranslator(theory, goal.facts)

    // extract regex constraints and function applications from the
    // literals
    val funApps = new ArrayBuffer[(PreOp, Seq[Term], Term)]
    val regexes = new ArrayBuffer[(Term, Automaton)]
    val negEqs = new ArrayBuffer[(Term, Term)]
    val lengthVars = new MHashMap[Term, Term]

    ////////////////////////////////////////////////////////////////////////////

    def decodeRegexId(a: Atom, complemented: Boolean): Unit = a(1) match {
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
            throw new Exception("Could not decode regex id " + a(1))
        }
      }
      case lc =>
        throw new Exception("Could not decode regex id " + lc)
    }

    ////////////////////////////////////////////////////////////////////////////
    // Collect positive literals

    for (a <- atoms.positiveLits) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2Automaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, false)
      case FunPred(`str_char_count`) => {
        // ignore
      }
      case `str_prefixof` => {
        val rightVar = theory.StringSort.newConstant("rhs")
        funApps += ((ConcatCEPreOp, List(a(0), rightVar), a(1)))
      }
      case FunPred(f) if rexOps contains f =>
      // nothing
      case p if (theory.predicates contains p) =>
        stringFunctionTranslator(a) match {
          case Some((op, args, res)) =>
            funApps += ((op(), args, res))
          case _ =>
            throw new Exception("Cannot handle literal " + a)
        }
      case _ =>
      // nothing
    }

    ////////////////////////////////////////////////////////////////////////////
    // Collect negative literals

    for (a <- atoms.negativeLits) a.pred match {
      case `str_in_re` => {
        val regex = regexExtractor regexAsTerm a(1)
        val aut = autDatabase.regex2ComplementedAutomaton(regex)
        regexes += ((a.head, aut))
      }
      case `str_in_re_id` =>
        decodeRegexId(a, true)
      case pred if theory.transducerPreOps contains pred =>
        throw new Exception("Cannot handle negated transducer constraint " + a)
      case p if (theory.predicates contains p) =>
        // Console.err.println("Warning: ignoring !" + a)
        throw new Exception("Cannot handle negative literal " + a)
      case _ =>
      // nothing
    }

    ////////////////////////////////////////////////////////////////////////////
    // Check whether any of the negated equations talk about strings

    if (!goal.facts.arithConj.negativeEqs.isEmpty) {
      import TerForConvenience._
      implicit val o = order

      val strCostsInFun = ArrayBuffer[Term]()
      funApps.foreach {
        case (_: SubStringCEPreOp, args, res) => {
          strCostsInFun ++= args(0).constants ++ res.constants
        }
        case (_: IndexOfCEPreOp, args, _) => {
          strCostsInFun ++= args(0).constants ++ args(1).constants
        }
        case (_, args, res) => {
          for (t <- args.iterator ++ Iterator(res))
            strCostsInFun ++= t.constants
        }
      }

      val stringConstants =
        ((for (
          (t, _) <- regexes.iterator;
          c <- t.constants.iterator
        ) yield c) ++
          strCostsInFun.iterator ++
          (for (
            a <- (atoms positiveLitsWithPred p(str_len)).iterator;
            c <- a(0).constants.iterator
          ) yield c)).toSet
      val lengthConstants =
        (for (
          t <- lengthVars.values.iterator;
          c <- t.constants.iterator
        ) yield c).toSet

      for (lc <- goal.facts.arithConj.negativeEqs) lc match {
        case Seq((IdealInt.ONE, c: ConstantTerm))
            if (stringConstants contains c) && (strDatabase containsId 0) => {
          val str = strDatabase id2Str 0
          val negAut =
            if (flags.useCostEnriched) !(BricsAutomatonWrapper fromString str)
            else !(BricsAutomaton fromString str)
          regexes += ((l(c), negAut))
        }
        case Seq((IdealInt.ONE, c: ConstantTerm), (IdealInt(coeff), OneTerm))
            if (stringConstants contains c) &&
              (strDatabase containsId -coeff) => {
          val str = strDatabase id2Str -coeff
          val negAut =
            if (flags.useCostEnriched) !(BricsAutomatonWrapper fromString str)
            else !(BricsAutomaton fromString str)
          regexes += ((l(c), negAut))
        }
        case lc if useLength && (lc.constants forall lengthConstants) =>
        // nothing
        case Seq(
              (IdealInt.ONE, c: ConstantTerm),
              (IdealInt.MINUS_ONE, d: ConstantTerm)
            ) if stringConstants(c) && stringConstants(d) =>
          negEqs += ((c, d))
        case lc if lc.constants exists stringConstants =>
          throw new Exception(
            "Cannot handle negative string equation " +
              (lc =/= 0)
          )
        case _ =>
        // nothing
      }

      if (!negEqs.isEmpty) {
        // make sure that symbols mentioned in negated equations have some
        // regex constraint, and thus will be included in the solution
        val regexCoveredTerms = new MHashSet[Term]
        for ((t, _) <- regexes)
          regexCoveredTerms += t

        val anyString =
          if (flags.useCostEnriched) BricsAutomatonWrapper.makeAnyString()
          else BricsAutomaton.makeAnyString()
        for ((c, d) <- negEqs) {
          if (regexCoveredTerms add c)
            regexes += ((l(c), anyString))
          if (regexCoveredTerms add d)
            regexes += ((l(d), anyString))
        }
      }
    }

    val interestingTerms =
      ((for ((t, _) <- regexes.iterator) yield t) ++
        (for (
          (_, args, res) <- funApps.iterator;
          t <- args.iterator ++ Iterator(res)
        ) yield t)).toSet

    ////////////////////////////////////////////////////////////////////////////
    // Start the actual OSTRICH solver

    SimpleAPI.withProver { lengthProver =>
      val lProver = {
        lengthProver setConstructProofs true
        lengthProver.addConstantsRaw(order sort order.orderedConstants)

        lengthProver addAssertion goal.facts.arithConj

        for (t <- interestingTerms)
          lengthVars.getOrElseUpdate(
            t,
            lengthProver.createConstantRaw("" + t + "_len", Sort.Nat)
          )

        implicit val o = lengthProver.order
        lengthProver
      }

      val result = {
        val inputFuns = funApps.map { case (op, args, result) =>
          (op, args.map(Internal2InputAbsy(_)), Internal2InputAbsy(result))
        }
        val inputRegexes = regexes.map { case (t, aut) =>
          (Internal2InputAbsy(t), aut)
        }

        val inputCEAs = inputRegexes.map{case (id, aut) => (id, automaton2CostEnriched(aut))}
        val approxExp = new ParikhExploration(
          inputFuns.toSeq,
          inputCEAs.toSeq,
          strDatabase,
          flags,
          lProver,
          Internal2InputAbsy(goal.facts.arithConj)
        )
        approxExp.findModel
      }

      ////////////////////////////////////////////////////////////////////////////
      // Verify that the result satisfies all constraints that could
      // not be included initially

      for (model <- result) {
        import TerForConvenience._
        implicit val o = order

        for ((c, d) <- negEqs) {
          val Right(cVal) = model(l(c))
          val Right(dVal) = model(l(d))

          if (cVal == dVal) {
            Console.err.println(
              "   ... disequality is not satisfied: " +
                c + " != " + d
            )
            val strId = strDatabase.list2Id(cVal)
            throw new BlockingActions(
              List(
                Plugin.AxiomSplit(
                  List(c =/= d),
                  List(
                    (c =/= strId, List()),
                    (c === strId & d =/= strId, List())
                  ),
                  theory
                )
              )
            )
          }
        }
      }

      if (result.isDefined)
        Console.err.println("   ... sat")
      else
        Console.err.println("   ... unsat")

      result
    }
  }
}
