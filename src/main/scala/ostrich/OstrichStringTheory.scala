/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2021 Matthew Hague, Philipp Ruemmer. All rights reserved.
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

object OstrichStringTheory {

  val alphabetSize = 1 << 16

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
                          flags : OFlags) extends {

  val StringSort   = new OstrichStringTheory.OstrichStringSort
  val alphabetSize = OstrichStringTheory.alphabetSize
  val upperBound   = IdealInt(alphabetSize - 1)
  val CharSort     = ModuloArithmetic.ModSort(IdealInt.ZERO, upperBound)
  val RegexSort    = Sort.createInfUninterpretedSort("RegLan")

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
  val re_begin_anchor =
    MonoSortedIFunction("re.begin-anchor", List(), RSo, true, false)
  val re_end_anchor =
    MonoSortedIFunction("re.end-anchor", List(), RSo, true, false)
  val re_from_ecma2020 =
    MonoSortedIFunction("re.from_ecma2020", List(SSo), RSo, true, false)
  val re_case_insensitive =
    MonoSortedIFunction("re.case_insensitive", List(RSo), RSo, true, false)

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
    List(("str.reverse", str_reverse, ostrich.ReversePreOp,
          a => List(a(0)), a => a(1)))

  val extraRegexFunctions =
    List(re_begin_anchor, re_end_anchor, re_from_ecma2020, re_case_insensitive,
         str_replacecg, str_replaceallcg,
         re_*?, re_+?)

  val extraIndexedFunctions =
    List((re_capture, 1),
         (re_reference, 1),
         (str_match, 2),
         (str_extract, 1))

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
     (for (f <- extraRegexFunctions.iterator)
      yield (f.name, Left(f)))).toMap

  val extraIndexedOps : Map[(String, Int), Either[IFunction, Predicate]] =
    (for ((f, ind) <- extraIndexedFunctions.iterator)
     yield ((f.name, ind), Left(f))).toMap

  //////////////////////////////////////////////////////////////////////////////

  val autDatabase = new AutDatabase(this, flags.minimizeAutomata)

  val str_in_re_id =
    MonoSortedPredicate("str.in.re.id", List(StringSort, Sort.Integer))

  //////////////////////////////////////////////////////////////////////////////
  /* Modified by Riccardo */
  val strDatabase = new StrDatabase(this)

  //////////////////////////////////////////////////////////////////////////////

  val functions =
    predefFunctions ++ List(str_empty, str_cons, str_head, str_tail) ++
    (extraStringFunctions map (_._2)) ++
    extraRegexFunctions ++ (extraIndexedFunctions map (_._1))

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

  override val dependencies : Iterable[Theory] = List(ModuloArithmetic)

  val _str_empty = functionPredicateMap(str_empty)
  val _str_cons  = functionPredicateMap(str_cons)
  val _str_++    = functionPredicateMap(str_++)

  private val predFunMap =
    (for ((f, p) <- functionPredicateMap) yield (p, f)).toMap

  object FunPred {
    def apply(f : IFunction) : Predicate = functionPredicateMap(f)
    def unapply(p : Predicate) : Option[IFunction] = predFunMap get p
  }

  // Set of the predicates that are fully supported at this point
  private val supportedPreds : Set[Predicate] =
    Set(str_in_re, str_in_re_id) ++
    (for (f <- Set(str_empty, str_cons, str_at,
                   str_++, str_replace, str_replaceall,
                   str_replacere, str_replaceallre, str_replaceallcg, 
                   str_replacecg, str_to_re,
                   str_extract,
                   str_to_int, int_to_str,
                   re_none, re_eps, re_all, re_allchar, re_charrange,
                   re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?,
                   re_opt,
                   re_comp, re_loop, re_from_str, re_capture, re_reference,
                   re_begin_anchor, re_end_anchor, re_from_ecma2020,
                   re_case_insensitive))
     yield functionPredicateMap(f)) ++
    (for (f <- List(str_len); if flags.useLength != OFlags.LengthOptions.Off)
     yield functionPredicateMap(f)) ++
    (for ((_, e) <- extraOps.iterator) yield e match {
       case Left(f) => functionPredicateMap(f)
       case Right(p) => p
     })

  private val unsupportedPreds = predicates.toSet -- supportedPreds

  //////////////////////////////////////////////////////////////////////////////

  private val ostrichSolver      = new OstrichSolver (this, flags)
  private val equalityPropagator = new OstrichEqualityPropagator(this)

  def plugin = Some(new Plugin {
    // not used
    def generateAxioms(goal : Goal)
          : Option[(Conjunction, Conjunction)] = None

    private val modelCache =
      new ap.util.LRUCache[Conjunction,
                           Option[Map[Term, Either[IdealInt, Seq[Int]]]]](3)

    override def handleGoal(goal : Goal)
                       : Seq[Plugin.Action] = goalState(goal) match {

      case Plugin.GoalState.Final => { //  Console.withOut(Console.err) 

        breakCyclicEquations(goal) match {
          case Some(actions) =>
            actions
          case None =>
            modelCache(goal.facts) {
              ostrichSolver.findStringModel(goal)
            } match {
              case Some(m) =>
                equalityPropagator.handleSolution(goal, m)
              case None =>
                List(Plugin.AddFormula(Conjunction.TRUE))
            }
        }
      }

      case _ => List()
    }

    override def generateModel(goal : Goal) : Option[Conjunction] =
      if (Seqs.disjointSeq(goal.facts.predicates, predicates)) {
        None
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

        Some(stringAssignments & lenAssignments)
      }

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
    f
  }

  override def iPreprocess(f : IFormula, signature : Signature)
                          : (IFormula, Signature) = {
    val visitor1 = new OstrichPreprocessor (this)
    val visitor2 = new OstrichRegexEncoder (this)
    // Added by Riccardo
    val visitor3 = new OstrichStringEncoder(this)

    (visitor3(visitor2(visitor1(f))), signature)
  }

  override val reducerPlugin = new OstrichReducerFactory(this)

  TheoryRegistry register this
  StringTheory register this

}
