package ostrich.cesolver.stringtheory

import ostrich.automata.{Transducer}
import ostrich.preop.{PreOp, TransducerPreOp, ReversePreOp}
import ostrich.proofops.{OstrichNielsenSplitter, OstrichPredtoEqConverter}

import ap.Signature
import ap.basetypes.IdealInt
import ap.parser.{ITerm, IFormula, IExpression, IFunction, IFunApp}
import IExpression.Predicate
import ap.theories.strings._
import ap.theories.{Theory, ModuloArithmetic, TheoryRegistry, Incompleteness}
import ap.types.{Sort, MonoSortedIFunction, MonoSortedPredicate, ProxySort}
import ap.terfor.{Term, ConstantTerm, TermOrder, TerForConvenience}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.Atom
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.util.Seqs

import scala.collection.mutable.{HashMap => MHashMap}
import scala.collection.{Map => GMap}
import ostrich.cesolver.preprocess.CEPreprocessor
import ostrich.cesolver.core.FinalConstraints
import ostrich.cesolver.util.ParikhUtil
import ap.parser.Internal2InputAbsy
import ostrich.{OFlags, OstrichSolver, OstrichStringTheory}
import ostrich.OstrichEqualityPropagator
import ostrich.automata.AutDatabase
import ostrich.cesolver.automata.CEAutDatabase
import ostrich.OstrichInternalPreprocessor
import ap.terfor.conjunctions.IdentityReducerPluginFactory
import ostrich.cesolver.preprocess.CEInternalPreprocessor

object CEStringTheory {
  val alphabetSize = 0x10000
}

////////////////////////////////////////////////////////////////////////////////

/** The entry class of the Ostrich string solver.
  */
class CEStringTheory(transducers: Seq[(String, Transducer)], flags: OFlags)
    extends OstrichStringTheory(transducers, flags) {

  private val ceSolver = new CESolver(this, flags)
  private val equalityPropagator = new OstrichEqualityPropagator(this)

  lazy val ceAutDatabase = new CEAutDatabase(this, flags.minimizeAutomata)

  // Set of the predicates that are fully supported at this point
  private val supportedPreds : Set[Predicate] =
    Set(str_in_re, str_in_re_id, str_prefixof, str_suffixof) ++
    (for (f <- Set(str_empty, str_cons, str_at,
                   str_++, str_replace, str_replaceall,
                   str_replacere, str_replaceallre, str_replaceallcg, 
                   str_replacecg, str_to_re,
                   str_extract,
                   str_to_int, int_to_str,
                   re_none, re_eps, re_all, re_allchar, re_charrange,
                   re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?,
                   re_opt, re_opt_?,
                   re_comp, re_loop, re_loop_?, re_from_str, re_capture, re_reference,
                   re_begin_anchor, re_end_anchor,
                   re_from_ecma2020, re_from_ecma2020_flags,
                   re_case_insensitive,
                   str_substr, str_indexof))
     yield functionPredicateMap(f)) ++
    (for (f <- List(str_len); if flags.useLength != OFlags.LengthOptions.Off)
     yield functionPredicateMap(f)) ++
    (for ((_, e) <- extraOps.iterator) yield e match {
       case Left(f) => functionPredicateMap(f)
       case Right(p) => p
     })

  private val unsupportedPreds = predicates.toSet -- supportedPreds


  override def plugin = Some(new Plugin {

    private val modelCache =
      new ap.util.LRUCache[Conjunction, Option[
        Map[Term, Either[IdealInt, Seq[Int]]]
      ]](3)

    override def handleGoal(goal: Goal): Seq[Plugin.Action] = {

      goalState(goal) match {

        case Plugin.GoalState.Eager =>
          Seq()

        case Plugin.GoalState.Intermediate =>
          Seq()
//           try {
//             breakCyclicEquations(goal).getOrElse(List()) elseDo
//               nielsenSplitter.decompSimpleEquations elseDo
//               nielsenSplitter.decompEquations elseDo
//               predToEq.reducePredicatesToEquations

//           } catch {
//             case t: ap.util.Timeout => throw t
// //          case t : Throwable =>  { t.printStackTrace; throw t }
//           }

        case Plugin.GoalState.Final =>
          try { //  Console.withOut(Console.err)
            // nielsenSplitter.splitEquation elseDo
            //   predToEq.lazyEnumeration elseDo
            callBackwardProp(goal)

          } catch {
            case t: ap.util.Timeout => throw t
            // case t: Throwable       => { t.printStackTrace; throw t }
          }

      }
    }

    private def callBackwardProp(goal: Goal): Seq[Plugin.Action] =
      try {
        modelCache(goal.facts) {
          ceSolver.findStringModel(goal)
        } match {
          case Some(m) =>
            equalityPropagator.handleSolution(goal, m)
          case None =>
            List(Plugin.AddFormula(Conjunction.TRUE))
        }
      } catch {
        case OstrichSolver.BlockingActions(actions) => actions
      }

    override def computeModel(goal: Goal): Seq[Plugin.Action] =
      if (Seqs.disjointSeq(goal.facts.predicates, predicates)) {
        List()
      } else {
        val model = (modelCache(goal.facts) {
          ceSolver.findStringModel(goal)
        }).get
        implicit val order = goal.order
        import TerForConvenience._

        val stringAssignments =
          conj(
            for ((x, Right(w)) <- model)
              yield (x === strDatabase.list2Id(w))
          )

        import TerForConvenience._
        val lenAssignments =
          eqZ(
            for (
              (x, Left(len)) <- model;
              if x.constants subsetOf order.orderedConstants
            )
              yield l(x - len)
          )

        val stringFormulas =
          conj(goal.facts.iterator filter { f =>
            !Seqs.disjointSeq(f.predicates, predicates)
          })

        List(
          Plugin.RemoveFacts(stringFormulas),
          Plugin.AddAxiom(
            List(stringFormulas),
            stringAssignments & lenAssignments,
            CEStringTheory.this
          )
        )
      }

  })

  override def iPreprocess(
      f: IFormula,
      signature: Signature
  ): (IFormula, Signature) = {
    val visitor1 = new CEPreprocessor(this)
    (visitor1(f), signature)
  }

  override def preprocess(f : Conjunction, order : TermOrder) : Conjunction = {
    if (!Seqs.disjoint(f.predicates, unsupportedPreds))
      Incompleteness.set

    val preprocessor = new CEInternalPreprocessor(this, flags)
    preprocessor.preprocess(f, order)
  }

}
