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

import ap.basetypes.IdealInt
import ap.parameters.ParserSettings
import ap.parser._
import ap.terfor.preds.Predicate
import ap.theories._
import scala.collection.mutable.{HashSet => MHashSet}

object SMTLIBStringParser {

  import SMTParser2InputAbsy._
  import IExpression.{Sort => TSort}

  case class SMTSeq(element : SMTType)   extends SMTType {
    def toSort = TSort.Integer // TODO
  }
  case class SMTRegex(element : SMTType) extends SMTType {
    def toSort = TSort.Integer // TODO
  }

  private type Env =
    Environment[SMTType, VariableType, Unit, SMTFunctionType, SMTType]

  def apply(settings : ParserSettings) =
    new SMTLIBStringParser (new Env, settings)

  /// XXX
  private def deescapeSeq(it: Iterator[Char]) = {
    var res: List[Char] = List.empty
    var isEscape = false

    def isNumber(c: Int) = (c >= '0' && c <= '9')
    def isHex(c: Int) =
      (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F') || isNumber(c)
    def decode(body: List[Char] => List[Char],
               numeralSystem: Int => Boolean)
              (list: List[Char]) =
      if (it.hasNext) {
        val char = it.next

        if (numeralSystem(char)) {
          body(char :: list)
        } else if(char == '\\') {
          list
        } else {
          isEscape = false
          char :: list
        }
      } else {
        list
      }

    while(it.hasNext) {
      it.next match {
        case '\\' if isEscape=>
          res ::= 92  // \\
          isEscape = false
        case '\\' =>
          isEscape = true
        case 'a' if isEscape =>
          res ::= 7   // \a
          isEscape = false
        case 'b' if isEscape =>
          res ::= 8   // \b
          isEscape = false
        case 'e' if isEscape =>
          res ::= 27  // \e
          isEscape = false
        case 'f' if isEscape =>
          res ::= 12  // \f
          isEscape = false
        case 'n' if isEscape =>
          res ::= 10  // \n
          isEscape = false
        case 'r' if isEscape =>
          res ::= 13  // \r
          isEscape = false
        case 't' if isEscape =>
          res ::= 9   // \t
          isEscape = false
        case 'v' if isEscape =>
          res ::= 11  // \v
          isEscape = false
        case 'x' if isEscape => // \xNN
          res :::= decode(decode({ case list =>
            isEscape = false
            Integer.parseInt(list.reverse.tail mkString, 16).toChar :: Nil
          }, isHex), isHex) (List('x'))

        case c if isEscape && isNumber(c) =>
          res :::= decode(decode({ case list =>
            var oct: List[Char] = list.reverse
            oct = (oct.head + 48).toChar :: oct.tail
            isEscape = false

            if((oct mkString).toInt > 377)
              Integer.parseInt(oct.init mkString, 8).toChar :: oct.last :: Nil
            else
              Integer.parseInt(oct mkString, 8).toChar :: Nil
          }, isNumber), isNumber) (List((c - 48).toChar))

        case c =>
          isEscape = false
          res ::= c
      }
    }

    //    res foreach {c => print(c.toInt + " ")}
    //    println
    //    println(res.reverse mkString)
    //    println
    //    res.reverse foreach {c => print(escapeChar(c))}
    //    println
    //    println
    res.iterator
  }

  private def escapeChar(c: Int): String = {
    def int2hex(n: Int) = n match {
      case 10 => "A"
      case 11 => "B"
      case 12 => "C"
      case 13 => "D"
      case 14 => "E"
      case 15 => "F"
      case _  => "" + n
    }

    c match {
      case 7  => "\\a"
      case 8  => "\\b"
      case 27 => "\\e"
      case 12 => "\\f"
      case 10 => "\\n"
      case 13 => "\\r"
      case 9  => "\\t"
      case 11 => "\\v"
      case c if c > 31 && c < 127 =>
        "" + c.toChar
      case c =>
        val n1 = int2hex(c >> 4)
        val n2 = int2hex(c & 0x0f)

        "\\x" + n1 + n2
    }
  }
  /// XXX

  def escapeString(str : String) : String =
    for (c <- str; d <- escapeChar(c)) yield d

}

////////////////////////////////////////////////////////////////////////////////

class SMTLIBStringParser(_env : SMTLIBStringParser.Env,
                         _settings : ParserSettings)
  extends SMTParser2InputAbsy(_env, _settings, null) {

  import SMTLIBStringParser._
  import SMTParser2InputAbsy._
  import smtlib.Absyn._

  var includesGetModel : Boolean = false

  override protected def incrementalityMessage(
                                                thing : String, warnOnly : Boolean) =
    thing match {
      case "get-model" => {
        includesGetModel = true
        "get-model detected, producing model"
      }
      case _ =>
        thing + " is not supported yet"
    }

  override protected def symApp(
                                 sym : SymbolRef, args : Seq[Term], polarity : Int)
  : (IExpression, SMTType) = sym match {

    case PlainSymbol(n@"seq-unit") =>
      translateFun(n, SMTLIBStringTheory.seq_unit, args,
        x => SMTSeq(x.head))
    case PlainSymbol(n@"seq-empty") =>
      translateFun(n, SMTLIBStringTheory.seq_empty, args,
        _ => SMTSeq(defaultChar))
    case CastSymbol(n@"seq-empty", s) =>
      translateFun(n, SMTLIBStringTheory.seq_empty, args,
        _ => translateSort(s))
    case PlainSymbol(n@"seq-concat") =>
      translateFun(n, SMTLIBStringTheory.seq_concat, args,
        (_.head))
    case PlainSymbol(n@"str.++") =>
      translateNAryFun(n, SMTLIBStringTheory.seq_concat, args,
        (_.head))

    case PlainSymbol(n@"seq-cons") =>
      translateFun(n, SMTLIBStringTheory.seq_cons, args,
        (_.last))
    case PlainSymbol(n@"seq-rev-cons") =>
      translateFun(n, SMTLIBStringTheory.seq_rev_cons, args,
        (_.head))
    case PlainSymbol(n@"seq-head") =>
      translateFun(n, SMTLIBStringTheory.seq_head, args,
        { case Seq(SMTSeq(t)) => t })
    case PlainSymbol(n@"seq-tail") =>
      translateFun(n, SMTLIBStringTheory.seq_tail, args,
        (_.head))
    case PlainSymbol(n@"seq-last") =>
      translateFun(n, SMTLIBStringTheory.seq_last, args,
        { case Seq(SMTSeq(t)) => t })
    case PlainSymbol(n@"seq-first") =>
      translateFun(n, SMTLIBStringTheory.seq_first, args,
        (_.head))

    case PlainSymbol(n@"seq-prefix-of") =>
      translatePred(n, SMTLIBStringTheory.seq_prefix_of, args)
    case PlainSymbol(n@"seq-suffix-of") =>
      translatePred(n, SMTLIBStringTheory.seq_suffix_of, args)
    case PlainSymbol(n@"seq-subseq-of") =>
      translatePred(n, SMTLIBStringTheory.seq_subseq_of, args)

    case PlainSymbol(n@("seq-extract" | "str.substr")) =>
      translateFun(n, SMTLIBStringTheory.seq_extract, args,
        (_.head))
    case PlainSymbol(n@("seq-nth" | "str.at")) =>
      translateFun(n, SMTLIBStringTheory.seq_nth, args,
        { case Seq(SMTSeq(t), _) => t })

    case PlainSymbol(n@("seq-length" | "str.len")) =>
      translateFun(n, SMTLIBStringTheory.seq_length, args,
        _ => SMTInteger)

    case PlainSymbol(n@("re-empty-set" | "re.nostr")) =>
      translateFun(n, SMTLIBStringTheory.re_empty_set, args,
        _ => SMTRegex(defaultChar))
    case CastSymbol(n@("re-empty-set" | "re.nostr"), s) =>
      translateFun(n, SMTLIBStringTheory.re_empty_set, args,
        _ => translateSort(s))

    case PlainSymbol(n@"re-full-set") =>
      translateFun(n, SMTLIBStringTheory.re_full_set, args,
        _ => SMTRegex(defaultChar))
    case CastSymbol(n@"re-full-set", s) =>
      translateFun(n, SMTLIBStringTheory.re_full_set, args,
        _ => translateSort(s))

    case PlainSymbol(n@"re.allchar") =>
      translateFun(n, SMTLIBStringTheory.re_allchar, args,
        _ => SMTRegex(defaultChar))
    case CastSymbol(n@"re.allchar", s) =>
      translateFun(n, SMTLIBStringTheory.re_allchar, args,
        _ => translateSort(s))

    case PlainSymbol(n@"re-concat") =>
      translateFun(n, SMTLIBStringTheory.re_concat, args,
        (_.head))
    case PlainSymbol(n@"re.++") =>
      translateNAryFun(n, SMTLIBStringTheory.re_concat, args,
        (_.head))
    case PlainSymbol(n@("re-of-seq" | "str.to.re")) =>
      translateFun(n, SMTLIBStringTheory.re_of_seq, args,
        { case Seq(SMTSeq(t)) => SMTRegex(t) })

    case PlainSymbol(n@"re-empty-seq") =>
      translateFun(n, SMTLIBStringTheory.re_empty_seq, args,
        _ => SMTSeq(defaultChar))
    case CastSymbol(n@"re-empty-seq", s) =>
      translateFun(n, SMTLIBStringTheory.re_empty_seq, args,
        _ => translateSort(s))

    case PlainSymbol(n@("re-star" | "re.*")) =>
      translateFun(n, SMTLIBStringTheory.re_star, args,
        (_.head))
    case CastSymbol(n@("re-star" | "re.*"), s) =>
      translateFun(n, SMTLIBStringTheory.re_star, args,
        _ => translateSort(s))

    case IndexedSymbol(n@("re-loop" | "re.loop"), lower, upper) => {
      checkArgNum(n, 1, args)
      val subTerm = translateTerm(args.head, 0)
      (IFunApp(SMTLIBStringTheory.re_loop,
        IExpression.i(IdealInt(lower)) ::
          IExpression.i(IdealInt(upper)) ::
          List(asTerm(subTerm))),
        subTerm._2)
    }
    case PlainSymbol(n@("re-plus" | "re.+")) =>
      translateFun(n, SMTLIBStringTheory.re_plus, args,
        (_.head))
    case PlainSymbol(n@("re-option" | "re.opt")) =>
      translateFun(n, SMTLIBStringTheory.re_option, args,
        (_.head))
    case PlainSymbol(n@("re-range" | "re.range")) => {
      checkArgNum(n, 2, args)
      val (lower, lowerType) = translateTerm(args(0), 0) match {
        case (IFunApp(SMTLIBStringTheory.seq_unit, Seq(lower)), lowerType) =>
          (lower, lowerType)
        case (lower : ITerm, lowerType) =>
          (lower, lowerType)
      }
      val (upper, upperType) = translateTerm(args(1), 0) match {
        case (IFunApp(SMTLIBStringTheory.seq_unit, Seq(upper)), upperType) =>
          (upper, upperType)
        case (upper : ITerm, upperType) =>
          (upper, upperType)
      }
      (IFunApp(SMTLIBStringTheory.re_range, List(lower, upper)),
        SMTRegex(lowerType))
    }

    case PlainSymbol(n@("re-union" | "re.union")) =>
      translateFun(n, SMTLIBStringTheory.re_union, args,
        (_.head))
    case PlainSymbol(n@"re-difference") =>
      translateFun(n, SMTLIBStringTheory.re_difference, args,
        (_.head))
    case PlainSymbol(n@("re-intersect" | "re.inter")) =>
      translateFun(n, SMTLIBStringTheory.re_intersect, args,
        (_.head))
    case PlainSymbol(n@"re-complement") =>
      translateFun(n, SMTLIBStringTheory.re_complement, args,
        (_.head))

    case PlainSymbol(n@"re-of-pred") =>
      translateFun(n, SMTLIBStringTheory.re_of_pred, args,
        { case Seq(SMTArray(List(t), SMTBool)) => SMTRegex(t) })

    case PlainSymbol(n@("re-member" | "str.in.re")) =>
      translatePred(n, SMTLIBStringTheory.re_member, args)

    case PlainSymbol(n@("seq-replace-all" | "str.replaceall")) =>
      translateFun(n, SMTLIBStringTheory.seq_replace_all, args, (_.head))

    case PlainSymbol(n@("seq-replace" | "str.replace")) =>
      translateFun(n, SMTLIBStringTheory.seq_replace, args, (_.head))

    case PlainSymbol(n@("seq-reverse" | "str.reverse")) =>
      translateFun(n, SMTLIBStringTheory.seq_reverse, args, (_.head))

    case _ =>
      super.symApp(sym, args, polarity)
  }

  private def translateFun(name : String, f : IFunction, args : Seq[Term])
  : (IExpression, SMTType) = {
    checkArgNum(name, f.arity, args)
    (IFunApp(f, for (a <- args) yield asTerm(translateTerm(a, 0))),
      SMTInteger)
  }

  private def translateFun(name : String, f : IFunction, args : Seq[Term],
                           typeCtor : Seq[SMTType] => SMTType)
  : (IExpression, SMTType) = {
    checkArgNum(name, f.arity, args)
    val transArgs = for (a <- args) yield translateTerm(a, 0)
    (IFunApp(f, for (a <- transArgs) yield asTerm(a)),
      typeCtor(transArgs map (_._2)))
  }

  private def translateNAryFun(name : String, f : IFunction, args : Seq[Term])
  : (IExpression, SMTType) = {
    val subTerms = for (a <- args) yield asTerm(translateTerm(a, 0))
    (subTerms.reduceLeft[ITerm] { case (s1, s2) => IFunApp(f, List(s1, s2)) },
      SMTInteger)
  }

  private def translateNAryFun(name : String, f : IFunction, args : Seq[Term],
                               typeCtor : Seq[SMTType] => SMTType)
  : (IExpression, SMTType) = {
    val transArgs = for (a <- args) yield translateTerm(a, 0)
    val subTerms = for (a <- transArgs) yield asTerm(a)
    (subTerms.reduceLeft[ITerm] { case (s1, s2) => IFunApp(f, List(s1, s2)) },
      typeCtor(transArgs map (_._2)))
  }

  private def translatePred(name : String, p : Predicate, args : Seq[Term])
  : (IExpression, SMTType) = {
    checkArgNum(name, p.arity, args)
    (IAtom(p, for (a <- args) yield asTerm(translateTerm(a, 0))),
      SMTBool)
  }

  var observedBitwidth : scala.Option[Int] = None

  private def setBitwidth(b : Int) = observedBitwidth match {
    case Some(b2) if (b != b2) =>
      throw new Parser2InputAbsy.TranslationException(
        "Currently only problems with uniform bitwith are supported")
    case _ =>
      observedBitwidth = Some(b)
  }

  private def defaultChar : SMTType =
    observedBitwidth match {
      case Some(w) => SMTBitVec(w)
      case None => SMTBitVec(8)
    }

  /** Implicit conversion so that we can get a Scala-like iterator from a
    * a Java list */
  import scala.collection.JavaConversions.asScalaBuffer

  override protected def translateSort(s : Sort) : SMTType = s match {
    case s : IdentSort => s.identifier_ match {
      case id : IndexIdent if (asString(id.symbol_) == "BitVec") => {
        val width = id.listindexc_.head.asInstanceOf[Index].numeral_.toInt
        setBitwidth(width)
        SMTBitVec(width)
      }
      case id : SymbolIdent if (asString(id.symbol_) == "String") => {
        setBitwidth(8)
        SMTSeq(SMTBitVec(8))
      }
      case _ =>
        super.translateSort(s)
    }
    case s : CompositeSort => asString(s.identifier_) match {
      case "Seq" => {
        val args = for (t <- s.listsort_) yield translateSort(t)
        SMTSeq(args.head)
      }
      case "RegEx" => {
        val args = for (t <- s.listsort_) yield translateSort(t)
        SMTRegex(args.head)
      }
      case _ =>
        super.translateSort(s)
    }
  }

  override protected def translateSpecConstant(c : SpecConstant)
  : (ITerm, SMTType) = c match {
    case c : HexConstant => {
      val width = (c.hexadecimal_.size - 2) * 4
      setBitwidth(width)
      (IExpression.i(IdealInt(c.hexadecimal_ substring 2, 16)),
        SMTBitVec(width))
    }

    case c : BinConstant => {
      val width = c.binary_.size - 2
      setBitwidth(width)
      (IExpression.i(IdealInt(c.binary_ substring 2, 2)),
        SMTBitVec(width))
    }

    case c : StringConstant => {
      import IExpression._
      setBitwidth(8)

      val it =
        deescapeSeq(c.smtstring_.substring(1, c.smtstring_.size - 1).iterator)

      if (it.hasNext) {
        val res = SMTLIBStringTheory.seq_unit(it.next)
        ((res /: it) {
          case (s, c) => SMTLIBStringTheory.seq_cons(c, s)
        },
          SMTSeq(defaultChar))
      } else {
        (SMTLIBStringTheory.seq_empty(), SMTSeq(defaultChar))
      }
    }

    case c => super.translateSpecConstant(c)
  }

  //////////////////////////////////////////////////////////////////////////////
  // Translation of transducers in SMT-LIB syntax to AFAs

  private object BitWidth {
    def unapply(t : ITerm) : Boolean = t match {
      case IIntLit(IdealInt(w)) => {
        setBitwidth(w)
        true
      }
      case _ =>
        false
    }
  }

  private object BVLit {
    def unapply(t : ITerm) : scala.Option[Int] = t match {
      case IFunApp(ModuloArithmetic.mod_cast,
                   Seq(IIntLit(lower), IIntLit(upper),
                       IIntLit(IdealInt(v)))) => {
        val ModuloArithmetic.UnsignedBVSort(w) =
          ModuloArithmetic.ModSort(lower, upper)
        setBitwidth(w)
        Some(v)
      }
      case _ =>
        None
    }
  }

  override protected def registerRecFunctions(
                                               funs : Seq[(IFunction, (IExpression, SMTType))]) : Unit = {
    import IExpression._

    val states = funs map (_._1)
    val tracks = states.head.arity

    // XXX
    val funsToState: Map[IFunction, Int] = states.view.zipWithIndex.toMap
    val aStates: collection.mutable.Seq[AFormula] =
      collection.mutable.Seq.fill(states.size)(AFFalse)
    val acceptingStates = new MHashSet[Int]
    // XXX

    if (!(states forall { f => f.arity == tracks }))
      throw new Parser2InputAbsy.TranslationException(
        "Inconsistent arities in transducer")

    Console.withOut(Console.err) {
    println("Parsing transducer (" + funs.head._1.arity + " tracks):")
    println

    for ((f, transitions) <- funs) {
      println("State " + f.name + ":")

      for (trans <- LineariseVisitor(Transform2NNF(asFormula(transitions)),
        IBinJunctor.Or)) {
        val conjuncts = LineariseVisitor(trans, IBinJunctor.And)

        val (targetConds, otherCondsH) = conjuncts partition {
          case EqZ(IFunApp(f, _)) if (states contains f) =>
            true
          case _ =>
            false
        }

        val (emptinessConds, otherConds) = otherCondsH partition {
          case Eq(_ : IVariable, IFunApp(seq_empty, _)) => true
          case Eq(IFunApp(seq_empty, _), _ : IVariable) => true
          case _ => false
        }

        //        println("emptinessConds: " + emptinessConds)
        //        println("targetConds: " + targetConds)
        //        println("otherConds: " + otherConds)

        if (conjuncts.size == emptinessConds.size &&
          (SymbolCollector variables and(emptinessConds)) ==
            ((0 until tracks) map (v(_))).toSet) {

          println("  (accepting)")
          // XXX
          acceptingStates += funsToState(f)
          // XXX

        } else targetConds match {

          case Seq(EqZ(IFunApp(target, args)))
            if args.iterator.zipWithIndex forall {
              case (IVariable(ind), n)
                if (ind + n + 1 == tracks) => true
              case (IFunApp(SMTLIBStringTheory.seq_tail,
              Seq(IVariable(ind))), n)
                if (ind + n + 1 == tracks) => true
              case _ =>
                false
            } => {
            // XXX
            // TODO: this code ignores the actual bit-widths!

            def buildVars(track: Int): Seq[AFormula] =
              for (i <- 0 until AFormula.widthOfChar) yield
                AFCharVar(i + track * AFormula.widthOfChar)

            def functionToAFormula(ie: IExpression): Seq[AFormula] = ie match {

              case BVLit(v) =>
                AFormula.nat2bv(v)

              case IFunApp(ModuloArithmetic.bv_sub,
                           Seq(BitWidth(),
                               IFunApp(SMTLIBStringTheory.seq_head,
                                       Seq(IVariable(t))),
                               BVLit(v))) =>
                AFormula.bvSub(buildVars(t), AFormula.nat2bv(v))

              case IFunApp(ModuloArithmetic.bv_add,
                           Seq(BitWidth(),
                               IFunApp(SMTLIBStringTheory.seq_head,
                                       Seq(IVariable(t))),
                               BVLit(v))) =>
                AFormula.bvAdd(buildVars(t), AFormula.nat2bv(v))

              case IFunApp(SMTLIBStringTheory.seq_head, Seq(IVariable(t))) =>
                buildVars(t)

              case mf =>
                throw new Exception(
                  "Unexpected function " + mf + " in functionToAFormula")
            }

            def expressionToAFormula(ie: IExpression,
                                     track: Int = -1): AFormula = ie match {
              case Eq(t1: IFunApp, t2: IFunApp) =>
                AFormula.bvEq(functionToAFormula(t1), functionToAFormula(t2))

              case Eq(IFunApp(SMTLIBStringTheory.seq_head, Seq(IVariable(v))),
                      subterm) =>
                expressionToAFormula(subterm, v)

              case Eq(subterm,
                      IFunApp(SMTLIBStringTheory.seq_head,
                              Seq(IVariable(v)))) =>
                expressionToAFormula(subterm, v)

              case INot(subformula) =>
                ~expressionToAFormula(subformula)

              case IBinFormula(IBinJunctor.And, f1, f2) =>
                expressionToAFormula(f1) &
                  expressionToAFormula(f2)

              case IBinFormula(IBinJunctor.Or, f1, f2) =>
                expressionToAFormula(f1) |
                  expressionToAFormula(f2)

              case IAtom(ModuloArithmetic.bv_ule, Seq(BitWidth(), f1, f2)) =>
                AFormula.bvLeq(functionToAFormula(f1), functionToAFormula(f2))

              case IAtom(ModuloArithmetic.bv_ult, Seq(BitWidth(), f1, f2)) =>
                AFormula.bvLt(functionToAFormula(f1), functionToAFormula(f2))

              case ITermITE(cond, left, right) => {
                val i = expressionToAFormula(cond)
                val t = functionToAFormula(left)
                val e = functionToAFormula(right)

                (i & AFormula.bvEq(buildVars(track), t)) |
                  (~i & AFormula.bvEq(buildVars(track), e))
              }

              case term =>
                throw new Exception(
                  "Unexpected term " + term + " " + term.getClass)
            }

            val s = funsToState(f)
            val t = funsToState(target)
            val ss = args.foldLeft[AFormula](AFTrue) { case (formula, arg) =>
              formula & (arg match {
                case IFunApp(SMTLIBStringTheory.seq_tail, Seq(IVariable(v))) =>
                  ~AFSpecSymb(v)

                case IVariable(v) =>
                  AFormula.createEpsilon(v)
              })
            }

            val sym =
              otherConds.foldLeft[AFormula](AFTrue) {
                case (formula, term) =>
                  formula & expressionToAFormula(term)
              }

            aStates(s) = aStates(s) | (AFStateVar(t) & ss & sym)
            // XXX
            print("  -> " + target.name + ": ")
            PrincessLineariser printExpression and(otherConds)
            println
          }

          case _ =>
            throw new Parser2InputAbsy.TranslationException(
              "Every transition needs exactly one target state")
        }
      }

      println
    }
    }

    var aFinalStates: AFormula =
      AFormula.and(for (n <- 0 until aStates.size;
                        if !(acceptingStates contains n))
        yield ~AFStateVar(n))

    // XXX
    val res = new AFA(AFStateVar(0), aStates.toVector, aFinalStates)

    RRFunsToAFA.addFun2AFA(states.head, res)
    //    println(res)
    //    println
    // XXX
  }
}
