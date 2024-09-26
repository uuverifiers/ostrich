/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2024 Matthew Hague, Philipp Ruemmer. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
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

package ostrich

import ostrich.automata.{AutDatabase, Transducer}
import ostrich.preop.{PreOp, ReversePreOp, TransducerPreOp}
import ostrich.proofops.{BackwardsSaturation, ForwardsSaturation,
                         OstrichClose, OstrichNielsenSplitter,
                         OstrichPredtoEqConverter, OstrichStrInReTranslator,
                         OstrichCut, LengthAbstraction}
import ap.Signature
import ap.basetypes.IdealInt
import ap.parser.{IExpression, IFormula, IFunApp, IFunction, ITerm}
import IExpression.Predicate
import ap.theories.strings._
import ap.theories.{Incompleteness, ModuloArithmetic, Theory, TheoryRegistry}
import ap.types.{MonoSortedIFunction, MonoSortedPredicate, ProxySort, Sort}
import ap.terfor.{ConstantTerm, TerForConvenience, Term, TermOrder}
import ap.terfor.conjunctions.Conjunction
import ap.terfor.preds.Atom
import ap.proof.theoryPlugins.Plugin
import ap.proof.goal.Goal
import ap.parameters.Param
import ap.util.Seqs

import scala.collection.mutable.{HashMap => MHashMap}
import scala.collection.{Map => GMap}

object OstrichStringTheory {

  // TODO: at some point this has to be fixed, Unicode is
  // bigger. Seems to be a problem with the BRICS automata library;
  // use Unicode-16 encoding?
  val alphabetSize = 0x10000

  class OstrichStringSort extends ProxySort(Sort.Integer) {
    override val name = "String"

    private var theory : OstrichStringTheory = null

    protected[ostrich] def setTheory(_theory : OstrichStringTheory) : Unit =
      theory = _theory

    override lazy val individuals : Stream[ITerm] =
      IFunApp(theory.str_empty, List()) #::
      (for (t <- individuals;
            n <- theory.CharSort.individuals)
       yield IFunApp(theory.str_cons, List(n, t)))

    override def decodeToTerm(
                   d : IdealInt,
                   assignment : GMap[(IdealInt, Sort), ITerm]) : Option[ITerm] =
      Some(theory.strDatabase.id2ITerm(d.intValueSafe))

  }

}

////////////////////////////////////////////////////////////////////////////////

/**
 * The entry class of the Ostrich string solver.
 */
class OstrichStringTheory(transducers : Seq[(String, Transducer)],
                          _flags : OFlags) extends {

  val StringSort   = new OstrichStringTheory.OstrichStringSort
  val alphabetSize = OstrichStringTheory.alphabetSize
  val upperBound   = IdealInt(alphabetSize - 1)
  val CharSort     = ModuloArithmetic.ModSort(IdealInt.ZERO, upperBound)
  val RegexSort    = Sort.createInfUninterpretedSort("RegLan")
  val theoryFlags = _flags

} with AbstractStringTheory {

  private val CSo = CharSort
  private val SSo = StringSort
  private val RSo = RegexSort

  def int2Char(t : ITerm) : ITerm =
    ModuloArithmetic.cast2Interval(IdealInt.ZERO, upperBound, t)

  def char2Int(t : ITerm) : ITerm = t

  //////////////////////////////////////////////////////////////////////////////

  import Sort.Integer

  val str_empty =
    new MonoSortedIFunction("str_empty", List(), SSo, true, false)
  val str_cons =
    new MonoSortedIFunction("str_cons", List(CSo, SSo), SSo, true, false)
  val str_head =
    new MonoSortedIFunction("str_head", List(SSo), CSo, true, false)
  val str_tail =
    new MonoSortedIFunction("str_tail", List(SSo), SSo, true, false)

  StringSort setTheory this

  //////////////////////////////////////////////////////////////////////////////

  val str_reverse =
    MonoSortedIFunction("str.reverse", List(SSo), SSo, true, false)
  val str_char_count =
    MonoSortedIFunction("str.char_count", List(Sort.Integer, SSo),
                        Sort.Nat, true, false)

  val re_begin_anchor =
    MonoSortedIFunction("re.begin-anchor", List(), RSo, true, false)
  val re_end_anchor =
    MonoSortedIFunction("re.end-anchor", List(), RSo, true, false)
  val re_from_ecma2020 =
    MonoSortedIFunction("re.from_ecma2020", List(SSo), RSo, true, false)
  val re_from_ecma2020_flags =
    MonoSortedIFunction("re.from_ecma2020_flags", List(SSo, SSo), RSo, true, false)
  val re_from_automaton =
    MonoSortedIFunction("re.from_automaton", List(SSo), RSo, true, false)
  val re_case_insensitive =
    MonoSortedIFunction("re.case_insensitive", List(RSo), RSo, true, false)
  val str_at_right =
    MonoSortedIFunction("str.at_right",
                        List(SSo, Sort.Integer), SSo, true, false)
  val str_trim =
    MonoSortedIFunction("str.trim",
                        List(SSo, Sort.Integer, Sort.Integer), SSo, true, false)

  // Replacement of the left-most, longest match
  val str_replacere_longest =
    new MonoSortedIFunction("str.replace_re_longest",
                            List(SSo, RSo, SSo), SSo, true, false)
  val str_replaceallre_longest =
    new MonoSortedIFunction("str.replace_re_longest_all",
                            List(SSo, RSo, SSo), SSo, true, false)

  // Replacement with regular expression and capture groups
  val str_replacecg =
    new MonoSortedIFunction("str.replace_cg",
                            List(SSo, RSo, RSo), SSo, true, false)
  val str_replaceallcg =
    new MonoSortedIFunction("str.replace_cg_all",
                            List(SSo, RSo, RSo), SSo, true, false)

  // Non-greedy quantifiers
  val re_*? =
    new MonoSortedIFunction("re.*?", List(RSo), RSo, true, false)
  val re_+? =
    new MonoSortedIFunction("re.+?", List(RSo), RSo, true, false)
  val re_opt_? =
    new MonoSortedIFunction("re.opt?", List(RSo), RSo, true, false)
  val re_loop_? =
    new MonoSortedIFunction("re.loop?", List(Integer, Integer, RSo), RSo,
                            true, false)

  // Capture groups and references
  val re_capture =
    new MonoSortedIFunction("re.capture", List(Integer, RSo), RSo,
                            true, false)
  val re_reference =
    new MonoSortedIFunction("re.reference", List(Integer), RSo,
                            true, false)

  val str_match =
    new MonoSortedIFunction("str.match", List(Integer, Integer, SSo, RSo), SSo,
                            true, false)
  val str_extract =
    new MonoSortedIFunction("str.extract", List(Integer, SSo, RSo), SSo,
                            true, false)

  // List of user-defined functions on strings that can be extended
  val extraStringFunctions : Seq[(String, IFunction, PreOp,
                                  Atom => Seq[Term], Atom => Term)] =
    List(("str.reverse", str_reverse, ReversePreOp,
          a => List(a(0)), a => a(1)))

  val extraRegexFunctions =
    List(re_begin_anchor, re_end_anchor,
         re_from_ecma2020, re_from_ecma2020_flags, re_from_automaton,
         re_case_insensitive,
         str_at_right, str_trim,
         str_replacere_longest, str_replaceallre_longest,
         str_replacecg, str_replaceallcg,
         re_*?, re_+?, re_opt_?)

  val extraIndexedFunctions =
    List((re_capture, 1),
         (re_reference, 1),
         (str_match, 2),
         (str_extract, 1),
         (re_loop_?, 2))

  // List of additional functions that can be provided by sub-classes
  protected def extraExtraFunctions : Seq[IFunction] = List()

  val extraFunctionPreOps =
    (for ((_, f, op, argSelector, resSelector) <- extraStringFunctions.iterator)
     yield (f, (op, argSelector, resSelector))).toMap

  val transducersWithPreds : Seq[(String, Predicate, Transducer)] =
    for ((name, transducer) <- transducers)
    yield (name, MonoSortedPredicate(name, List(SSo, SSo)), transducer)

  val transducerPreOps =
    (for ((_, p, transducer) <- transducersWithPreds.iterator)
     yield (p, TransducerPreOp(transducer))).toMap

  // Map used by the parser
  val extraOps : Map[String, Either[IFunction, Predicate]] =
    ((for ((name, f, _, _, _) <- extraStringFunctions.iterator)
      yield (name, Left(f))) ++
     (for ((name, p, _) <- transducersWithPreds.iterator)
      yield (name, Right(p))) ++
     (for (f <- extraRegexFunctions.iterator ++ extraExtraFunctions.iterator)
      yield (f.name, Left(f)))).toMap

  val extraIndexedOps : Map[(String, Int), Either[IFunction, Predicate]] =
    (for ((f, ind) <- extraIndexedFunctions.iterator)
     yield ((f.name, ind), Left(f))).toMap

  //////////////////////////////////////////////////////////////////////////////

  val autDatabase = new AutDatabase(this, theoryFlags.minimizeAutomata)

  val str_in_re_id =
    MonoSortedPredicate("str.in.re.id", List(StringSort, Sort.Integer))

  val strDatabase = new StrDatabase(this)

  //////////////////////////////////////////////////////////////////////////////

  val functions =
    predefFunctions ++
    List(str_empty, str_cons, str_head, str_tail, str_char_count) ++
    (extraStringFunctions map (_._2)) ++
    extraRegexFunctions ++
    (extraIndexedFunctions map (_._1)) ++
    extraExtraFunctions

  val (funPredicates, _, _, functionPredicateMap) =
    Theory.genAxioms(theoryFunctions = functions,
                     extraPredicates = List(str_in_re_id))
  val predicates =
    predefPredicates ++ funPredicates ++ (transducersWithPreds map (_._2))

  val functionPredicateMapping =
    for (f <- functions) yield (f, functionPredicateMap(f))
  val functionalPredicates =
    (for (f <- functions) yield functionPredicateMap(f)).toSet
  val predicateMatchConfig : Signature.PredicateMatchConfig = Map()
  val axioms = Conjunction.TRUE
  val totalityAxioms = Conjunction.TRUE
  val triggerRelevantFunctions : Set[IFunction] = Set()

  val IntEnumerator       = new IntValueEnumTheory("OstrichIntEnum", 50, 20)
  val forwardSaturation   = new ForwardsSaturation(this)
  val backwardsSaturation = new BackwardsSaturation(this)
  val lengthAbstraction   = new LengthAbstraction(this)

  override val dependencies : Iterable[Theory] =
    List(ModuloArithmetic,
         IntEnumerator,
         forwardSaturation,
         backwardsSaturation,
         lengthAbstraction
         )

  val _str_empty      = functionPredicateMap(str_empty)
  val _str_cons       = functionPredicateMap(str_cons)
  val _str_++         = functionPredicateMap(str_++)
  val _str_len        = functionPredicateMap(str_len)
  val _str_char_count = functionPredicateMap(str_char_count)

  private val predFunMap =
    (for ((f, p) <- functionPredicateMap) yield (p, f)).toMap

  object FunPred {
    def apply(f : IFunction) : Predicate = functionPredicateMap(f)
    def unapply(p : Predicate) : Option[IFunction] = predFunMap get p
  }

  // Set of the predicates that are fully supported at this point
  private val supportedPreds : Set[Predicate] =
    Set(str_in_re, str_in_re_id, str_prefixof, str_suffixof, str_<=) ++
    (for (f <- Set(str_empty, str_cons, str_at,
                   str_++, str_replace, str_replaceall,
                   str_replacere, str_replaceallre,
                   str_replacere_longest, str_replaceallre_longest,
                   str_replaceallcg, str_replacecg, str_to_re,
                   str_extract,
                   str_to_int, int_to_str,
                   str_indexof,
                   re_none, re_eps, re_all, re_allchar, re_charrange,
                   re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?,
                   re_opt, re_opt_?,
                   re_comp, re_loop, re_loop_?, re_from_str, re_capture,
                   re_reference,
                   re_begin_anchor, re_end_anchor,
                   re_from_ecma2020, re_from_ecma2020_flags, re_from_automaton,
                   re_case_insensitive))
     yield functionPredicateMap(f)) ++
    (for (f <- List(str_len); if theoryFlags.useLength != OFlags.LengthOptions.Off)
     yield functionPredicateMap(f)) ++
    (for ((_, e) <- extraOps.iterator) yield e match {
       case Left(f) => functionPredicateMap(f)
       case Right(p) => p
     })

  private val unsupportedPreds = predicates.toSet -- supportedPreds

  //////////////////////////////////////////////////////////////////////////////

  /**
   * Determine whether length reasoning should be switched on, given
   * some assertion.
   */
  def lengthNeeded(f : Conjunction) : Boolean = {
    theoryFlags.useLength match {
      case OFlags.LengthOptions.Off  => false
      case OFlags.LengthOptions.On   => true
      case OFlags.LengthOptions.Auto => f.predicates contains _str_len
    }
  }

  private val ostrichSolver      = new OstrichSolver (this, theoryFlags)
  private val ostrichClose       = new OstrichClose(this)
  private val equalityPropagator = new OstrichEqualityPropagator(this)
  private val strInReTranslator  = new OstrichStrInReTranslator(this)
  private val cutter             = new OstrichCut(this)

  def plugin = Some(new Plugin {

    private val modelCache =
      new ap.util.LRUCache[Conjunction,
                           Option[Map[Term, Either[IdealInt, Seq[Int]]]]](3)

    override def handleGoal(goal : Goal) : Seq[Plugin.Action] = {
      lazy val nielsenSplitter =
        new OstrichNielsenSplitter(goal, OstrichStringTheory.this, theoryFlags)
      lazy val predToEq =
        new OstrichPredtoEqConverter(goal, OstrichStringTheory.this, theoryFlags)

      goalState(goal) match {

        case Plugin.GoalState.Eager =>
          strInReTranslator.handleGoal(goal)           elseDo
          ostrichClose.handleGoal(goal)                elseDo
          breakCyclicEquations(goal).getOrElse(List()) elseDo
          nielsenSplitter.decompSimpleEquations        elseDo
          nielsenSplitter.decompEquations              elseDo
          predToEq.reducePredicatesToEquations

        case Plugin.GoalState.Intermediate =>
          nielsenSplitter.splitEquation

        case Plugin.GoalState.Final =>
          predToEq.lazyEnumeration                     elseDo
          cutter.handleGoal(goal, true)

      }
    }

    private def callBackwardProp(goal : Goal) : Seq[Plugin.Action] =
      try {
        modelCache(goal.facts) {
          ostrichSolver.findStringModel(goal)
        } match {
          case Some(m) =>
            equalityPropagator.handleSolution(goal, m)
          case None =>
            if (Param.PROOF_CONSTRUCTION(goal.settings))
              // TODO: only list the assumptions that were actually
              // needed for the proof to close.
              List(Plugin.CloseByAxiom(goal.facts.iterator.toList,
                                       OstrichStringTheory.this))
            else
              List(Plugin.AddFormula(Conjunction.TRUE))
        }
      } catch {
        case OstrichSolver.BlockingActions(actions) => actions
      }

      /*
    override def computeModel(goal : Goal) : Seq[Plugin.Action] = {
      println("computeModel")
      cutter.handleGoal(goal, true)
    }
*/
/*
    override def computeModel(goal : Goal) : Seq[Plugin.Action] =
      if (Seqs.disjointSeq(goal.facts.predicates, predicates)) {
        List()
      } else {
        val model = (modelCache(goal.facts) {
                       ostrichSolver.findStringModel(goal)
                     }).get
        implicit val order = goal.order
        import TerForConvenience._

        val stringAssignments =
          conj(for ((x, Right(w)) <- model)
               yield (x === strDatabase.list2Id(w)))

        import TerForConvenience._
        val lenAssignments =
          eqZ(for ((x, Left(len)) <- model;
                if x.constants subsetOf order.orderedConstants)
              yield l(x - len))

        val stringFormulas =
          conj(goal.facts.iterator filter {
             f => !Seqs.disjointSeq(f.predicates, predicates)
           })

        List(Plugin.RemoveFacts(stringFormulas),
             Plugin.AddAxiom(List(stringFormulas),
                             stringAssignments & lenAssignments,
                             OstrichStringTheory.this))
      }
 */
  })

  //////////////////////////////////////////////////////////////////////////////

  val asString = new Theory.Decoder[String] {
    def apply(d : IdealInt)
             (implicit ctxt : Theory.DecoderContext) : String =
      asStringPartial(d).get
  }

  val asStringPartial = new Theory.Decoder[Option[String]] {
    def apply(d : IdealInt)
             (implicit ctxt : Theory.DecoderContext) : Option[String] =
      d match {
        case IdealInt(v) if (strDatabase containsId v) =>
          Some(strDatabase id2Str v)
        case _ =>
          None
      }
  }

  //////////////////////////////////////////////////////////////////////////////

  override def toString : String = "OstrichStringTheory"

  override def isSoundForSat(
                 theories : Seq[Theory],
                 config : Theory.SatSoundnessConfig.Value) : Boolean =
    config match {
      case Theory.SatSoundnessConfig.Elementary  => true
      case Theory.SatSoundnessConfig.Existential => true
      case _                                     => false
    }

  override def preprocess(f : Conjunction, order : TermOrder) : Conjunction = {
    if (!Seqs.disjoint(f.predicates, unsupportedPreds))
      Incompleteness.set

    val preprocessor = new OstrichInternalPreprocessor(this, theoryFlags)
    preprocessor.preprocess(f, order)
  }

  override def iPreprocess(f : IFormula, signature : Signature)
                          : (IFormula, Signature) = {
    val visitor0 = new OstrichFactorizer   (this)
    val visitor1 = new OstrichPreprocessor (this)
    val visitor2 = new OstrichRegexEncoder (this)
    val visitor3 = new OstrichStringEncoder(this)

    (visitor3(visitor2(visitor1(visitor0(f)))), signature)
  }

  override val reducerPlugin = new OstrichReducerFactory(this)

  TheoryRegistry register this
  StringTheory register this

}
