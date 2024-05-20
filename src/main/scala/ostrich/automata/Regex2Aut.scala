/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2018-2024 Matthew Hague, Philipp Ruemmer, Riccardo De Masellis. All rights reserved.
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

package ostrich.automata

import ostrich.{AutomatonParser, ECMARegexParser, OFlags, OstrichStringTheory}
import ap.basetypes.IdealInt
import ap.parser.IExpression.Const
import ap.parser._
import ap.theories.strings.StringTheory
import ap.theories.ModuloArithmetic
import dk.brics.automaton.{BasicAutomata, BasicOperations, RegExp, Automaton => BAutomaton}
import ostrich.automata.afa2.concrete.{AFA2, AFA2StateDuplicator, NFATranslator}
import ostrich.automata.afa2.symbolic.{SymbAFA2Builder, SymbEpsReducer, SymbExtAFA2, SymbMutableAFA2, SymbToConcTranslator}
import ostrich.automata.afa2.AFA2PrintingUtils

import scala.collection.mutable.{ArrayBuffer, ArrayStack}
import scala.collection.immutable.VectorBuilder
import collection.JavaConverters._

object Regex2Aut {

  val debug = false

  private val RegexClassSpecialChar = """\[[^\[\]]*(\\[wsd])""".r
  private val LookAheadBehind = """\(\?[=!<]""".r

  object SmartConst {
    import IExpression._
    def unapply(t : ITerm) : Option[IdealInt] = t match {
      case Const(value) =>
        Some(value)
      case IFunApp(ModuloArithmetic.mod_cast,
                   Seq(Const(lower), Const(upper), SmartConst(value))) =>
        Some(ModuloArithmetic.evalModCast(lower, upper, value))
      case _ =>
        None
    }
  }

  /**
   * A simple rewriter to eliminate <code>re.diff</code> and
   * <code>re.inter</code>.
   */
  class DiffEliminator(theory : OstrichStringTheory) {
    import IExpression._
    import theory.{re_none, re_all, re_eps, re_allchar, re_charrange,
                   re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?,
                   re_opt, re_comp, re_loop, str_to_re, re_from_str, re_capture,
                   re_begin_anchor, re_end_anchor,
                   re_from_ecma2020, re_from_ecma2020_flags}
    import theory.strDatabase.EncodedString

    def apply(t : ITerm) = Rewriter.rewrite(t, rewrTerm _).asInstanceOf[ITerm]

    private def rewrTerm(t : IExpression) : IExpression = t match {

      case IFunApp(`str_to_re`,
                   Seq(EncodedString(str))) if str.size == 1 =>
        re_charrange(str(0), str(0))

      case IFunApp(`re_inter`,
                   Seq(IFunApp(`re_charrange`,
                               Seq(Const(l1), Const(u1))),
                       IFunApp(`re_charrange`,
                               Seq(Const(l2), Const(u2))))) =>
        re_charrange(l1 max l2, u1 min u2)

      case IFunApp(`re_charrange`,
                   Seq(Const(l), Const(u))) if l > u =>
        re_none()

      case IFunApp(`re_inter`,
                   Seq(IFunApp(`re_union`, Seq(t1, t2)), s)) =>
        re_union(re_inter(t1, s), re_inter(t2, s))
      case IFunApp(`re_inter`,
                   Seq(s, IFunApp(`re_union`, Seq(t1, t2)))) =>
        re_union(re_inter(s, t1), re_inter(s, t2))

      case IFunApp(`re_inter`,
                   Seq(IFunApp(`re_none`, _), s)) =>
        re_none()
      case IFunApp(`re_inter`,
                   Seq(s, IFunApp(`re_none`, _))) =>
        re_none()

      case IFunApp(`re_union`,
                   Seq(IFunApp(`re_none`, _), s)) =>
        s
      case IFunApp(`re_union`,
                   Seq(s, IFunApp(`re_none`, _))) =>
        s

      case IFunApp(`re_diff`,
                   Seq(s, IFunApp(`re_union`, Seq(t1, t2)))) =>
        re_inter(re_diff(s, t1), re_diff(s, t2))

      case IFunApp(`re_diff`,
                   Seq(s, IFunApp(`re_inter`, Seq(t1, t2)))) =>
        re_union(re_diff(s, t1), re_diff(s, t2))

      case IFunApp(`re_diff`,
                   Seq(IFunApp(`re_allchar`, _),
                       IFunApp(`re_charrange`, Seq(Const(l), Const(u))))) =>
        re_union(re_charrange(0, l-1), re_charrange(u+1, theory.upperBound))

      case IFunApp(`re_diff`,
                   Seq(lhs@IFunApp(`re_charrange`, _),
                       IFunApp(`re_charrange`, Seq(Const(l), Const(u))))) =>
        re_union(re_inter(lhs, re_charrange(0, l-1)),
                 re_inter(lhs, re_charrange(u+1, theory.upperBound)))

      case t => t
    }

  }


  class SyntacticTransformations(theory: OstrichStringTheory, parser: ECMARegexParser) {

    import IExpression._
    import theory._
    import theory.strDatabase.EncodedString

    val isWordChar = re_union(parser.decimal,
                        re_union(parser.uppCaseChars,
                          re_union(parser.lowCaseChars, parser.underscore)))

    def apply(t: ITerm) = {
      val diffElimin = new Regex2Aut.DiffEliminator(theory)
      val de = diffElimin(t)
      if (debug)
        Console.err.println("After diff elimination:\n" + de + "\n")
      val res = transformNF(de)
      if (debug)
        Console.err.println("After transformation:\n" + res + "\n")
      res
    }

    /*
    It transform the input formula in NF for the 2AFA transformation.
    It reverses the lookbehinds and eliminate redundant operators.
     */
    def transformNF(t: ITerm, reverse: Boolean=false): ITerm = t match {
      //Base cases
      case IFunApp(`re_none` | `re_charrange` | `re_eps` | `re_all` | `re_allchar` | `re_range`,  _) => t

      // Recursive cases
      case IFunApp(`re_++`, Seq(l, r)) => if (reverse)
                                            re_++(transformNF(r, reverse), transformNF(l, reverse))
                                          else
                                            re_++(transformNF(l, reverse), transformNF(r, reverse))

      case IFunApp(parser.LookAhead, Seq(t)) => IFunApp(parser.LookAhead, Seq(transformNF(t, false)))

      case IFunApp(parser.NegLookAhead, Seq(t)) => IFunApp(parser.NegLookAhead, Seq(transformNF(t, false)))

      case IFunApp(parser.LookBehind, Seq(t)) => IFunApp(parser.LookBehind, Seq(transformNF(t, true)))

      case IFunApp(parser.NegLookBehind, Seq(t)) => IFunApp(parser.NegLookBehind, Seq(transformNF(t, true)))

      // Ad hoc, optimised translation. DOES NOT WORK!
      case IFunApp(parser.WordBoundary, x) => IFunApp(parser.WordBoundary, x)
      case IFunApp(parser.NonWordBoundary, x) => IFunApp(parser.NonWordBoundary, x)

      // Old, textbook translation
      /*
      case IFunApp(parser.WordBoundary, _) => transformNF(

        re_union(
          re_++(IFunApp(parser.LookAhead, Seq(isWordChar)), IFunApp(parser.NegLookBehind, Seq(isWordChar))),
          re_++(IFunApp(parser.NegLookAhead, Seq(isWordChar)), IFunApp(parser.LookBehind, Seq(isWordChar)))
        )

        ,reverse)

      case IFunApp(parser.NonWordBoundary, _) => transformNF(

          re_union(
            re_++(IFunApp(parser.LookAhead, Seq(isWordChar)), IFunApp(parser.LookBehind, Seq(isWordChar))),
            re_++(IFunApp(parser.NegLookAhead, Seq(isWordChar)), IFunApp(parser.NegLookBehind, Seq(isWordChar)))
          )

          ,reverse)
        */

      case IFunApp(`re_opt`, Seq(t)) => IFunApp(`re_union`, Seq(IFunApp(`re_eps`, Seq()), transformNF(t)))

      case IFunApp(`re_begin_anchor`, Seq()) => transformNF(IFunApp(parser.NegLookBehind, Seq(re_all())), reverse)

      case IFunApp(`re_end_anchor`, _) => transformNF(IFunApp(parser.NegLookAhead, Seq(re_all())), reverse)

      case IFunApp(`re_capture`, Seq(_, t)) =>
        Console.err.println("Warning: ignoring capture groups")
        transformNF(t, reverse)

      case IFunApp(`re_*?`, Seq(t)) =>
        Console.err.println("Warning: ignoring lazy star")
        IFunApp(`re_*`, Seq(transformNF(t, reverse)))

      case IFunApp(`re_+` | `re_+?`, Seq(t)) => transformNF(re_++(t, re_*(t)))

      case IFunApp(`re_loop` | `re_loop_?`, Seq(IIntLit(n1), IIntLit(n2), t)) => IFunApp(`re_loop`, Seq(IIntLit(n1), IIntLit(n2), transformNF(t, reverse)))

      case IFunApp(`str_to_re`, Seq(EncodedString(_str))) => {
        val str = if (reverse) _str.reverse else _str
        val charRegexes = for (c <- str) yield re_charrange(c, c)
        if (str.isEmpty) re_eps() else charRegexes.reduceLeft(re_++(_, _))
      }

      case IFunApp(x@(`re_*` | `re_union` | `re_inter`), y) =>
        IFunApp(x, y.map(transformNF(_, reverse)))

      case t =>
        throw new RuntimeException("Cannot normalize regular expression: " + t)
    }

  }

}


class ECMAToSymbAFA2(theory : OstrichStringTheory, parser: ECMARegexParser) {

  import ostrich.automata.afa2._
  import theory.{
    re_none, re_all, re_eps, re_allchar, re_charrange, re_range,
    re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?,
    re_opt_?, re_loop_?,
    re_opt, re_comp, re_loop, str_to_re, re_from_str, re_capture,
    re_begin_anchor, re_end_anchor,
    re_from_ecma2020, re_from_ecma2020_flags,
    re_case_insensitive
  }

  val builder = new SymbAFA2Builder(theory)

  // Just calls toMutableAFA2 with AFA2.Right direction and converts the result.
  def toSymbExt2AFA(t: ITerm) : SymbExtAFA2 = {
    val symbMutAut = toSymbMutableAFA2(Right, t)
    //println("Builder automaton:\n" + mutAut)
    val extSymbAFA2 = symbMutAut.builderToSymbExtAFA()
    //println("Ext2AFA automaton:\n" + extAFA2)
    extSymbAFA2
  }


  private def toSymbMutableAFA2(dir: Step, t: ITerm) : SymbMutableAFA2 = {
    //ap.util.Timeout.check
    t match {

      case IFunApp(`re_eps`, _) =>
        builder.epsAtomic2AFA(dir)

      case IFunApp(`re_none`, _) =>
        builder.emptyAtomic2AFA(dir)

      case IFunApp(`re_charrange`, Seq(Const(l), Const(u))) =>
        builder.charrangeAtomic2AFA(dir, Range(l.intValue, u.intValue+1, 1))

      case IFunApp(`re_allchar`, _) => builder.allcharAtomic2AFA(dir)

      case IFunApp(`re_all`, _) => builder.allAtomic2AFA(dir)

      case IFunApp(parser.WordBoundary, _) => builder.wordBoundary2AFA(dir)

      case IFunApp(parser.NonWordBoundary, _) => builder.nonWordBoundary2AFA(dir)

      case IFunApp(`re_++`, Seq(l, r)) =>
        builder.concat2AFA(dir, toSymbMutableAFA2(dir, l), toSymbMutableAFA2(dir, r))

      case IFunApp(`re_union`, Seq(l, r)) =>
        builder.alternation2AFA(dir, toSymbMutableAFA2(dir, l), toSymbMutableAFA2(dir, r))

      case IFunApp(`re_*`, Seq(t)) =>
        builder.star2AFA(dir, toSymbMutableAFA2(dir, t))

      case IFunApp(parser.LookAhead, Seq(t)) =>
        // Watch out here with the directions!
        builder.lookaround2AFA(dir, toSymbMutableAFA2(Right, t))

      case IFunApp(parser.LookBehind, Seq(t)) =>
        builder.lookaround2AFA(dir, toSymbMutableAFA2(Left, t))

      case IFunApp(parser.NegLookAhead, Seq(t)) =>
        builder.negLookaround2AFA(dir, toSymbMutableAFA2(Right, t))

      case IFunApp(parser.NegLookBehind, Seq(t)) =>
        builder.negLookaround2AFA(dir, toSymbMutableAFA2(Left, t))

      case IFunApp(`re_loop`, Seq(IIntLit(n1), IIntLit(n2), t)) =>
        builder.loop3Aut2AFA(dir, n1.intValue, n2.intValue, toSymbMutableAFA2(dir, t))

      case t => throw new RuntimeException("Cannot translate to 2AFA: " + t)
    }
  }

}

class Regex2Aut(theory : OstrichStringTheory) {

  import theory.{re_none, re_all, re_eps, re_allchar, re_charrange, re_range,
                 re_++, re_union, re_inter, re_diff, re_*, re_*?, re_+, re_+?,
                 re_opt_?, re_loop_?,
                 re_opt, re_comp, re_loop, str_to_re, re_from_str, re_capture,
                 re_begin_anchor, re_end_anchor,
                 re_from_ecma2020, re_from_ecma2020_flags, re_from_automaton,
                 re_case_insensitive}

  import Regex2Aut._

  def toBricsRegexString(t : ITerm) : String =
    Regex2BricsVisitor.visit(t, ())

  //////////////////////////////////////////////////////////////////////////////

  private object Regex2BricsVisitor extends CollectingVisitor[Unit, String] {

    override def preVisit(t : IExpression,
                          arg : Unit) : PreVisitResult = t match {
      case SmartConst(_) =>
        ShortCutResult("")

      case IFunApp(`re_charrange`,
                   Seq(SmartConst(IdealInt(a)), SmartConst(IdealInt(b)))) =>
        ShortCutResult(
          "[\\" + numToUnicode(a) + "-" + "\\" + numToUnicode(b) + "]")

      case IFunApp(`str_to_re`, Seq(a)) => {
        System.out.println(a);
        val res =
          StringTheory.term2List(a) match {
            case Seq() =>
              "()"
            case str =>
              (for (v <- str;
                    c <- "[\\" + numToUnicode(v) + "]")
               yield c).mkString
          }
        ShortCutResult(res)
      }

      case IFunApp(`re_from_str`, Seq(a)) => {
        System.out.println(a);
        // TODO: this translation has to be checked more carefully, there might
        // be problems due to escaping. The processing of regexes can also
        // only be done correctly within a proper regex parser.
  
        ShortCutResult(jsRegex2BricsRegex(StringTheory.term2String(a)))
      }

      case _ =>
        KeepArg
    }

    def postVisit(t : IExpression,
                  arg : Unit,
                  subres : Seq[String]) : String = t match {
      case IFunApp(`re_none`, _) =>
        "#"
      case IFunApp(`re_eps`, _) =>
        "()"
      case IFunApp(`re_all`, _) =>
        ".*"
      case IFunApp(`re_allchar`, _) =>
        "."
      case IFunApp(`re_++`, _) =>
        subres(0) + subres(1)
      case IFunApp(`re_union`, _) =>
        "(" + subres(0) + "|" + subres(1) + ")"
      case IFunApp(`re_inter`, _) =>
        "(" + subres(0) + "&" + subres(1) + ")"
      case IFunApp(`re_*` | `re_*?`, _) =>
        "(" + subres(0) + ")*"
      case IFunApp(`re_+` | `re_+?`, _) =>
        "(" + subres(0) + ")+"
      case IFunApp(`re_opt` | `re_opt_?`, _) =>
        "(" + subres(0) + ")?"
      case IFunApp(`re_comp`, _) =>
        "~(" + subres(0) + ")"
      case IFunApp(`re_loop` | `re_loop_?`, Seq(IIntLit(n1), IIntLit(n2), _)) =>
        "(" + subres(2) + "){" + n1 + "," + n2 + "}"
      case IFunApp(`re_capture`, _) => // ignored here
        subres(1)

    case _ =>
      throw new IllegalArgumentException(
        "could not translate " + t + " to an automaton")
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  import theory.strDatabase.EncodedString

  /*
  New transformation from ECMARegex to 2AFA and then NFA.
   */
  private def to2AFA(t : ITerm, parser: ECMARegexParser) : BAutomaton = {
    /*
      Step 1: Building the symbolic extended 2AFA (the translation in
      the paper). This automaton has eps transitions and accepts at
      the beginning and end of string (with two different kind of
      final states).
    */
    var t1 = System.currentTimeMillis()
    val ecmaAFA = new ECMAToSymbAFA2(theory, parser)
    val aut = ecmaAFA.toSymbExt2AFA(t)
    if (debug)
      AFA2PrintingUtils.printAutDotToFile(aut, "extSymbAFA2.dot")

    /*
    Step 2:
    a) All epsilon transitions are removed: the existential with
    powerset construction and the universal by adding forward and
    backward transitions reading any symbols (word markers included).
    b) Also the resulting automaton accepts only at the right end of
    the word. This is done by adding beginning and end markers of the
    word and by adding some states.  The result is therefore a
    symbolic2AFA (no eps trans, accepts only at the end, reads word
    markers)
     */
    var t2 = System.currentTimeMillis()
    val epsRed = new SymbEpsReducer(theory, aut)
    val reducedAut = epsRed.afa
    var duration2 = (System.currentTimeMillis() - t2) / 1000d
    //println("Time for eps-reduction: " + duration2)

    // Used sometime for debugging...
    //throw new RuntimeException("Stop here.")

    /*
    Step 3: The symb2AFA, with ranges on the transitions, is
    transformed into a concrete one.  In order to do that, overlaps
    between ranges are eliminated and a map between ranges and
    concrete symbols is kept. This is needed because the 2AFA -> NFA
    translation works only on concrete automata.
     */
    t2 = System.currentTimeMillis()
    val transl = new SymbToConcTranslator(reducedAut)
    val concAut = transl.forth()
    duration2 = (System.currentTimeMillis() - t2) // / 1000d
    //println("Time for symbolic to concrete: " + duration2)
    if (debug)
      AFA2PrintingUtils.printAutDotToFile(concAut, "concAut.dot")
    var duration = (System.currentTimeMillis() - t1) // / 1000d

    /*
    Step 4: Naive minimization of the automata. Essentially states
    with same outgoing labels going to same states are merged. The
    procedure is iterative and reaches a fixpoint where no states can
    be merged anymore. Output: 2AFA (concrete, only accepts at the end
    of word)
     */
    //println("Eliminating redundant states in progress...")
    val redConcAut = concAut.minimizeStates()
    //val redConcAut = concAut
    //println("Total time for regex -> 2AFA translation: " + duration)
    if (debug)
      AFA2PrintingUtils.printAutDotToFile(redConcAut, "reducedConcAut.dot")
    if (debug)
      Console.err.println("2AFA #states: " + redConcAut.states.size + " #transitions: " + redConcAut.transitions.values.size)

    /*
    Step 5: 2AFA -> NFA translation
     */
    t1 = System.currentTimeMillis()
    val concNFA = NFATranslator(AFA2StateDuplicator(redConcAut), epsRed, Some(transl.rangeMap.map(_.swap)))
    duration = (System.currentTimeMillis() - t1) // / 1000d
    //println("Time for 2AFA -> NFA translation: " + duration)
    //println("BricsAutomaton:\n" + res)

    val symbNFA = transl.bricsBack(concNFA, Set(epsRed.beginMarker, epsRed.endMarker))

    symbNFA.underlying
  }

  private def regex2Automaton(parser   : ECMARegexParser,
                              str      : String,
                              minimize : Boolean) = {
      theory.theoryFlags.regexTranslator match {

        case OFlags.RegexTranslator.Hybrid => {
          val (s, incomplete) =
            Console.withErr(ap.CmdlMain.NullStream) {
              parser.string2TermWithReduction(str)
            }
          if (incomplete) {
            //println("Using complete method.")
            val s2 = parser.string2TermExact(str)
            val st = new SyntacticTransformations(theory, parser)
            val r = st(s2)
            to2AFA(r, parser)
          } else {
            //println("Partial method is exact, using it.")
            toBAutomaton(s, minimize)
          }
        }

        case OFlags.RegexTranslator.Approx => {
          //println("Using partial method.")
          val (s, _) = parser.string2TermWithReduction(str)
          toBAutomaton(s, minimize)
        }

        case OFlags.RegexTranslator.Complete => {
          //println("Using complete method.")
          val s = parser.string2TermExact(str)
          val st = new SyntacticTransformations(theory, parser)
          val r = st(s)
          to2AFA(r, parser)
        }
      }
  }

  protected def toBAutomaton(t : ITerm,
                           minimize : Boolean) : BAutomaton = t match {
    case IFunApp(`re_charrange`,
                 Seq(SmartConst(IdealInt(a)), SmartConst(IdealInt(b)))) =>
      BasicAutomata.makeCharRange(a.toChar, b.toChar)

    case IFunApp(`re_range`, _) =>
      throw new IllegalArgumentException(
        "re.range can only be applied to singleton strings" +
          ", cannot handle " + t)

    case IFunApp(`str_to_re`, Seq(EncodedString(str))) =>
      BasicAutomata.makeString(str)

    case IFunApp(`re_from_str`, Seq(EncodedString(str))) => {
      // TODO: this translation has to be checked more carefully, there might
      // be problems due to escaping. The processing of regexes can also
      // only be done correctly within a proper regex parser.
  
      val bricsPattern = jsRegex2BricsRegex(str)
      new RegExp(bricsPattern).toAutomaton(minimize)
    }

    case IFunApp(`re_from_ecma2020`, Seq(EncodedString(str))) => {
      val parser = new ECMARegexParser(theory)
      regex2Automaton(parser, str, minimize)
    }

    case IFunApp(`re_from_ecma2020_flags`,
                 Seq(EncodedString(str), EncodedString(flags))) => {
      val parser = new ECMARegexParser(theory, flags)
      regex2Automaton(parser, str, minimize)
    }

    case IFunApp(`re_case_insensitive`, Seq(a)) => {
      val aut = toBAutomaton(a, minimize)
      maybeMin(AutomataUtils.makeCaseInsensitive(
                 new BricsAutomaton(aut))
                 .asInstanceOf[BricsAutomaton].underlying,
               minimize)
    }

    case IFunApp(`re_none`, _) =>
      BasicAutomata.makeEmpty
    case IFunApp(`re_eps`, _) =>
      BasicAutomata.makeString("")
    case IFunApp(`re_begin_anchor` | `re_end_anchor`, _) => {
      Console.err.println("Warning: ignoring anchor")
      BasicAutomata.makeString("")
    }
    case IFunApp(`re_all`, _) =>
      BasicAutomata.makeAnyString
    case IFunApp(`re_allchar`, _) =>
      BasicAutomata.makeAnyChar

    case IFunApp(`re_++`, _) =>
      maybeMin(BasicOperations.concatenate(translateLeaves(t, re_++, minimize)),
               minimize)

    case IFunApp(`re_union`, _) => {
      val leaves = collectLeaves(t, re_union)
      val (singletons, nonSingletons) = leaves partition {
        case IFunApp(`str_to_re`, _) => true
        case _                       => false
      }

      val singletonAuts =
        if (singletons.isEmpty) {
          List()
        } else {
          val strings =
            (for (IFunApp(_, Seq(EncodedString(str))) <- singletons)
             yield str).toArray
          List(BasicAutomata.makeStringUnion(strings : _*))
        }

      val nonSingletonAuts =
        for (s <- nonSingletons) yield toBAutomaton(s, minimize)

      (singletonAuts, nonSingletonAuts) match {
        case (Seq(aut), Seq()) => aut
        case (Seq(), Seq(aut)) => aut
        case (auts1, auts2) =>
          maybeMin(BasicOperations.union((auts1 ++ auts2).asJava), minimize)
      }
    }

    case IFunApp(`re_inter`, _) => {
      val leaves = collectLeaves(t, re_inter)
      val leaveAuts = for (s <- leaves) yield toBAutomaton(s, minimize)
      leaveAuts reduceLeft {
        (aut1, aut2) =>
        maybeMin(BasicOperations.intersection(aut1, aut2), minimize)
      }
    }

    case IFunApp(`re_diff`, Seq(t1, t2)) =>
      maybeMin(BasicOperations.minus(toBAutomaton(t1, minimize),
                                     toBAutomaton(t2, minimize)), minimize)

    case IFunApp(`re_*` | `re_*?`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).repeat, minimize)
    case IFunApp(`re_+` | `re_+?`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).repeat(1), minimize)
    case IFunApp(`re_opt` | `re_opt_?`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).optional, minimize)
    case IFunApp(`re_comp`, Seq(t)) =>
      maybeMin(toBAutomaton(t, minimize).complement, minimize)
    case IFunApp(`re_loop` | `re_loop_?`,
                 Seq(IIntLit(IdealInt(n1)), IIntLit(IdealInt(n2)), t)) =>
      maybeMin(toBAutomaton(t, minimize).repeat(n1, n2), minimize)

    case IFunApp(`re_capture`, Seq(_, t)) => {
      Console.err.println("Warning: ignoring capture group")
      toBAutomaton(t, minimize)
    }
  }

  private def maybeMin(aut : BAutomaton, minimize : Boolean) : BAutomaton = {
    if (minimize && !BricsAutomaton.neverMinimize(aut))
      aut.minimize
    aut
  }

  private def translateLeaves(t        : ITerm,
                              op       : IFunction,
                              minimize : Boolean)
                            : java.util.List[BAutomaton] = {
    val leaves = collectLeaves(t, re_++)
    val leaveAuts = for (s <- leaves) yield toBAutomaton(s, minimize)
    leaveAuts.asJava
  }

  private def collectLeaves(t : ITerm, op : IFunction) : Seq[ITerm] = {
    val todo = new ArrayStack[ITerm]
    todo push t

    val res = new VectorBuilder[ITerm]

    while (!todo.isEmpty)
      todo.pop match {
        case IFunApp(`op`, args) =>
          for (s <- args.reverseIterator)
            todo push s
        case s =>
          res += s
      }

    res.result
  }

  //////////////////////////////////////////////////////////////////////////////

  /**
   * Translate a string representing a JavaScript/ECMA regex to a
   * Brics regex.
   *  TODO: this translation has to be checked more carefully, there might
   *  be problems due to escaping. The processing of regexes can also
   *  only be done correctly within a proper regex parser.
   */
  private def jsRegex2BricsRegex(str : String) : String = {
    // BRICS cannot handle anchors, so currently we are just removing them
    // TODO: find a better solution for this
  
    var begin = 0
    while (begin < str.size && str(begin) == '^') {
      Console.err.println("Warning: ignoring anchor ^")
      begin = begin + 1
    }
  
    var end = str.size
    while (end > 0 && str(end - 1) == '$') {
      Console.err.println("Warning: ignoring anchor $")
      end = end - 1
    }
  
    val str2 = str.slice(begin, end)
  
    // handle some of the PCRE sequences, inside character classes
    // TODO: do this more systematically
    val str3 = {
      var curStr = str2
      var cont = true
      while (cont)
        RegexClassSpecialChar.findFirstMatchIn(curStr) match {
          case Some(m) => {
            val repl = m.group(1) match {
              case "\\w" => "A-Za-z0-9_"
              case "\\s" => " "
              case "\\d" => "0-9"
            }
            curStr = curStr.take(m.start(1)) + repl + curStr.drop(m.end(1))
          }
          case None =>
            cont = false
        }
      curStr
    }
  
    // handle some of the PCRE sequences, outside of character classes
    // TODO: do this more systematically
    val str4 = str3.replaceAll("""\\w""", "[A-Za-z0-9_]")
                   .replaceAll("""\\W""", "[^A-Za-z0-9_]")
                   .replaceAll("""\\s""", "[ ]")
                   .replaceAll("""\\S""", "[^ ]")
                   .replaceAll("""\\d""", "[0-9]")
                   .replaceAll("""\\D""", "[^0-9]")
                   .replaceAll("""\(\?:""", "(")
                   .replaceAll("""@""", "\\\\@")
                   .replaceAll("""<""", "\\\\<")
  
    // encode some simple cases of look-aheads, and eliminate the more
    // complicated cases
    val str5 = {
      val curStr = str4
      val lookAheads = new ArrayBuffer[String]
      var curInd = 0
  
      var cont = true
      while (cont) {
        curStr.substring(curInd, (curInd + 3) min curStr.size) match {
          case "(?=" => { // positive look-ahead
            val endInd = findRegexClosingParen(curStr, curInd)
            lookAheads += "(" + curStr.substring(curInd + 3, endInd) + "@)"
            curInd = endInd + 1
          }
          case "(?!" => { // negative look-ahead
            val endInd = findRegexClosingParen(curStr, curInd)
            lookAheads += "~(" + curStr.substring(curInd + 3, endInd) + "@)"
            curInd = endInd + 1
          }
          case _ =>
            cont = false
        }
        if (curInd >= curStr.size)
          cont = false
      }
  
      if (!lookAheads.isEmpty)
        lookAheads.mkString("&") + "&(" + curStr.substring(curInd) + ")"
      else
        curStr
    }
  
    // eliminate the more complicated cases of look-ahead/behind
    val str6 = {
      var curStr = str5
      var cont = true
  
      while (cont)
        LookAheadBehind.findFirstMatchIn(curStr) match {
          case Some(m) => {
            val ind = m.start
            curStr =
              curStr.take(ind) +
            curStr.drop(findRegexClosingParen(curStr, ind) + 1)
            Console.err.println(
              "Warning: ignoring look-ahead/behind in regular expression")
          }
          case None =>
            cont = false
        }

      curStr
    }

    str6
  }

  /**
   * Given an opening parenthesis at index <code>openInd</code> in a
   * regex string, find the matching closing parenthesis.
   */
  private def findRegexClosingParen(str : String, openInd : Int) : Int = {
    val N = str.size
    var nesting = 1
    var curInd = openInd
    var state = 0

    while (nesting > 0 && curInd < N - 1) {
      curInd = curInd + 1

      (str(curInd), state) match {
        case ('(', 0) =>            // opening paren
          nesting = nesting + 1
        case (')', 0) =>            // closing paren
          nesting = nesting - 1
        case ('[', 0) =>            // start of a character class
          state = 10
        case (']', 10) =>           // end of a character class
          state = 0
        case ('\\', 0) =>           // start of an escaped character
          state = 1
        case ('x', 1) =>            // pair of hex characters
          state = 4
        case ('u', 1) =>            // quadruple of hex characters
          state = 2
        case (_, 1) =>              // single escaped character
          state = 0
        case (_, n) if 2<=n && n<=4 => // hex characters
          state = n + 1
        case (_, 5) =>              // hex characters
          state = 0
        case _ =>
          // nothing
      }
    }

    curInd
  }

  def buildBricsAut(t : ITerm) : BAutomaton =
    toBAutomaton(t, true)

  def buildAut(t : ITerm,
               minimize : Boolean = true) : Automaton = t match
  {
    case IFunApp(`re_from_automaton`, Seq(EncodedString(str))) => {
      val parser = new AutomatonParser()
      val res = parser.parseAutomaton(str)
      res match {
        case Left(a) => throw new Exception("Automata parsing re.from_automata went wrong " + a)
        case Right(b) => b

      }
    }
    case _ => {
      new BricsAutomaton(toBAutomaton(t, minimize))
    }
  }
  private def numToUnicode(num : Int) : String =
    new String(Character.toChars(num))

}
