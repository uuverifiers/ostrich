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

import java.io.{BufferedReader, File, FileOutputStream, InputStreamReader, PrintWriter}
import scala.collection.mutable.{ArrayBuffer, BitSet => MBitSet}

object IsEmpty {
  def apply(afa : AFA) : Boolean = FindAcceptedWords(afa).isEmpty
}

object FindAcceptedWords {
  def apply(afa : AFA) : Option[Vector[Seq[Int]]] = {
    val normAFA = afa.eliminateParameters.normaliseInitial
    val aagFile = File.createTempFile("afa", ".aag")
    //    println("Writing AIGER to " + aagFile)

    val out = new FileOutputStream(aagFile)
    Console.withOut(out) {
      new AFA2AAG(normAFA)
    }
    out.close

    val res =
      if(Flags.isABC)
        abcChecker(aagFile)
      else
        nuXmvChecker(aagFile)

    aagFile.delete

    res
  }

  private val NUXMV_CMD = "nuXmv"
  //private val NUXMV_CMD = "nth/touXmv"
  private val NUXMV_INPUT = "read_aiger_model; go_bmc; check_invar_ic3 ; quit"

  private val NUXMV_EMPTY_STR     = """.*invariant +!NonAccepting +is +true""".r
  private val NUXMV_NON_EMPTY_STR = """.*invariant +!NonAccepting +is +false""".r
  private val NUXMV_INPUT_START   = """.*-> Input: (.*) <-""".r
  private val NUXMV_INPUT_CHAR    = """.*char ([0-9]*) = (.*)""".r
  private val NUXMV_INPUT_EPS     = """.*eps ([0-9]*) = (.*)""".r

  private val ABC_NON_EMPTY_STR = """Output 0.*""".r
  private val ABC_EMPTY_STR     = """Property proved.*""".r
  private val ABC_CMD           = "abc"
  private val ABC_AIGTOAIG_CMD  = "aigtoaig"

  private def abcChecker(aagFile : File) : Option[Vector[Seq[Int]]] = {
    val model = File.createTempFile("afa", ".aig")
    Runtime.getRuntime.exec(ABC_AIGTOAIG_CMD + " " + aagFile + " " + model)
    val p = Runtime.getRuntime.exec(ABC_CMD)
    val output = new BufferedReader(new InputStreamReader (p.getInputStream))
    val input = new PrintWriter (p.getOutputStream)

    input.println("read_aiger " + model + "; pdr; quit")
    input.close

    var emptyRes = false
    var nonEmptyRes = false

    val charInputs, epsInputs = new ArrayBuffer[MBitSet]
    var maxCharIndex = -1

    var str = output.readLine
    while (str != null) {
      str match {
        case ABC_EMPTY_STR() =>
          emptyRes = true
        case ABC_NON_EMPTY_STR() =>
          nonEmptyRes = true
        case _ => // ignore
      }
      str = output.readLine
    }

    p.waitFor
    output.close
    model.delete

    assert(emptyRes != nonEmptyRes)

    if (nonEmptyRes) {
      Some(Vector.empty[Seq[Int]])
    } else {
      None
    }
  }

  private def nuXmvChecker(aagFile : File) : Option[Vector[Seq[Int]]] = {
    val p = Runtime.getRuntime.exec(NUXMV_CMD + " -int " + aagFile)
    val output = new BufferedReader(new InputStreamReader (p.getInputStream))
    val input = new PrintWriter (p.getOutputStream)

    input.println(NUXMV_INPUT)
    input.close

    var emptyRes = false
    var nonEmptyRes = false

    val charInputs, epsInputs = new ArrayBuffer[MBitSet]
    var maxCharIndex = -1

    var str = output.readLine
    while (str != null) {
      //      println(str)
      str match {
        case NUXMV_EMPTY_STR() =>
          emptyRes = true
        case NUXMV_NON_EMPTY_STR() =>
          nonEmptyRes = true

        // read the counterexample
        case NUXMV_INPUT_START(num) =>
          if (charInputs.isEmpty) {
            charInputs += new MBitSet
            epsInputs += new MBitSet
          } else {
            charInputs += charInputs.last.clone
            epsInputs += epsInputs.last.clone
          }
        case NUXMV_INPUT_CHAR(num, "TRUE") => {
          charInputs.last += num.toInt
          maxCharIndex = maxCharIndex max num.toInt
        }
        case NUXMV_INPUT_CHAR(num, "FALSE") => {
          charInputs.last -= num.toInt
          maxCharIndex = maxCharIndex max num.toInt
        }
        case NUXMV_INPUT_EPS(num, "TRUE") =>
          epsInputs.last += num.toInt
        case NUXMV_INPUT_EPS(num, "FALSE") =>
          epsInputs.last -= num.toInt

        case _ => // ignore
      }
      str = output.readLine
    }

    p.waitFor
    output.close

    assert(emptyRes != nonEmptyRes)

    if (nonEmptyRes) {
      // reconstruct words
      val W = AFormula.widthOfChar
      val numWords = (maxCharIndex + 1) / W
      val words = Array.fill(numWords)(new ArrayBuffer[Int])

      for ((chars, eps) <- charInputs.iterator zip epsInputs.iterator)
        for (n <- 0 until numWords)
          if (!(eps contains n)) {
            words(n) +=
              (for (k <- 0 until W; if (chars contains (n * W + k)))
                yield (1 << (W - k - 1))).sum
          }

      Some(words.toVector)
    } else {
      None
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class AFA2AAG(afa : AFA) {
  val specSyms = afa.specSyms.toList.sorted
  val numInputs = afa.states.size + (afa.maxCharIndex + 1) + specSyms.size
  val numLatches = afa.states.size + 1

  type Variable = Int
  type Literal = (Variable, Boolean)

  private var nextVar = 1

  private def reserveVar : Variable = {
    val res = nextVar
    nextVar = nextVar + 1
    res
  }

  private def reserveVars(n : Int) : Vector[Variable] = {
    val res = (nextVar until (nextVar + n)).toVector
    nextVar = nextVar + n
    res
  }

  //////////////////////////////////////////////////////////////////////////////

  val lines = new ArrayBuffer[String]

  // printing variables
  def p(ind : Variable) : String = "" + (ind*2)
  def n(ind : Variable) : String = "" + (ind*2 + 1)

  // printing literals
  def p(ind : Literal) : String = ind match {
    case (i, false) => p(i)
    case (i, true)  => n(i)
  }

  def n(ind : Literal) : String = p((ind._1, !ind._2))

  private def out(s : String*) =
    lines += (s mkString " ")

  //////////////////////////////////////////////////////////////////////////////

  val nextStateInd = reserveVars(afa.states.size)
  val inputBitInd  = reserveVars(afa.maxCharIndex + 1)
  val specSymInd   = reserveVars(specSyms.size)
  val oldStateInd  = reserveVars(afa.states.size)
  val noNewErrInd  = reserveVar
  val oldErrInd    = reserveVar
  val reachCheck   = reserveVar

  private def encodeFor(f : AFormula,
                        boundVars : List[Literal],
                        stateInd : Vector[Variable]) : Literal = f match {
    case AFAnd(s1, s2) => {
      val r1 = encodeFor(s1, boundVars, stateInd)
      val r2 = encodeFor(s2, boundVars, stateInd)
      val r = reserveVar
      out(p(r), p(r1), p(r2))
      (r, false)
    }
    case AFOr(s1, s2) => {
      val r1 = encodeFor(s1, boundVars, stateInd)
      val r2 = encodeFor(s2, boundVars, stateInd)
      val r = reserveVar
      out(p(r), n(r1), n(r2))
      (r, true)
    }
    case AFLet(s1, s2) => {
      val r1 = encodeFor(s1, boundVars, stateInd)
      encodeFor(s2, r1 :: boundVars, stateInd)
    }
    case AFNot(s) => {
      val (ind, b) = encodeFor(s, boundVars, stateInd)
      (ind, !b)
    }
    case AFStateVar(v) =>
      (stateInd(v), false)
    case AFCharVar(v) =>
      (inputBitInd(v), false)
    case AFSpecSymb(ind) =>
      (specSymInd(specSyms indexOf ind), false)
    case AFDeBrujinVar(ind) =>
      boundVars(ind)
    case AFFalse =>
      (0, false)
    case AFTrue =>
      (0, true)
  }

  private def exactlyOne(vars: Set[Int]): Literal = {
    def and(lit1: String, lit2: String): Variable = {
      val res = reserveVar

      out(p(res), lit1, lit2)
      res
    }

    if(vars.size < 2)
      return (0, true)

    var tail = vars
    var res: Literal =
      vars.tail.foldLeft[Literal]((nextStateInd(vars.head), true)) {
        case (r, e) => (and(p(r), n(nextStateInd(e))), false)
      }

    res = (res._1, true)
    for(x <- vars.init) {
      tail = tail.tail
      for(y <- tail) {
        res = (and(p(res), n(and(p(nextStateInd(x)), p(nextStateInd(y))))), false)
      }
    }

    res
  }

  //////////////////////////////////////////////////////////////////////////////

  // Print inputs

  // s'
  for (i <- nextStateInd)
    out(p(i))

  // l
  for (i <- inputBitInd)
    out(p(i))

  // specSyms
  for (i <- specSymInd)
    out(p(i))

  // Print latches

  // s <- s'
  for (((o, n), num) <-
       (oldStateInd.iterator zip nextStateInd.iterator).zipWithIndex)
    out(p(o), p(n), if (num == 0) "1" else "0")

  out(p(oldErrInd), n(noNewErrInd), "0")

  // Print property
  out(p(reachCheck))

  // Print transition formulas (AND gates)

  val andStartIndex = lines.size

  // T_i[s', l]
  val stateForInd =
    if(Flags.minimalSuccessors) {
      afa.states.zipWithIndex map {
        case (af, i) if i > 0 =>
          val res = reserveVar

          val tmp = exactlyOne(af.getStates)
          out(p(res), p(encodeFor(af, List(), nextStateInd)), p(tmp))
          (res, false)

        case (af, _) => encodeFor(af, List(), nextStateInd)
      }
    } else {
      afa.states map (encodeFor(_, List(), nextStateInd))
    }

  // s_i -> T_i[s', l]    (= !(s_i & !T_i[s', l]))
  val transitionConjuncts =
    for ((s, l) <- oldStateInd zip stateForInd) yield {
      val c = reserveVar
      out(p(c), p(s), n(l))
      (c, true)
    }

  // /\_i s_i -> T_i[s', l]
  val transitionConjunction =
    transitionConjuncts reduceLeft[Literal] {
      case (c1, c2) => {
        val c = reserveVar
        out(p(c), p(c1), p(c2))
        (c, false)
      }
    }

  // newErr <- oldErr | !transitionConjunction
  out(p(noNewErrInd), n(oldErrInd), p(transitionConjunction))

  // encoded final formula of AFA
  val allAccepting = encodeFor(afa.finalStates, List(), oldStateInd)

  // Configuration signalling non-emptiness
  out(p(reachCheck), n(oldErrInd), p(allAccepting))

  val numAnds = lines.size - andStartIndex

  //////////////////////////////////////////////////////////////////////////////

  // Print actual AIGER output

  println("aag " + (nextVar - 1) + " " +
    numInputs + " " + numLatches + " 0 " + numAnds + " 1")
  lines map println

  // Add symbol table
  println("b0 NonAccepting")
  for (v <- 0 until inputBitInd.size)
    println("i" + (afa.states.size + v) + " " + "char " + v)
  for ((sym, num) <- specSyms.iterator.zipWithIndex)
    println("i" + (afa.states.size + (afa.maxCharIndex + 1) + num)
      + " " + "eps " + sym)
}

////////////////////////////////////////////////////////////////////////////////

object EmptinessMain extends App {
  println("Test AFA:")

  val s = AFStateVar(0)
  val q0 = AFStateVar(1)
  val q1 = AFStateVar(2)
  val q2 = AFStateVar(3)

  val a = AFormula.createSymbol(0, 0)
  val b = AFormula.createSymbol(1, 0)

  val postS = (a & s) | (b & s & q0)
  val postQ0 = (a & q1) | (b & (q0 | q1))
  val postQ1 = (a & q0) | (b & (q1 | q2))
  val postQ2 = a & q2

  val finalStates = q0

  val afa = new AFA (AFStateVar(0),
    Vector(postS, postQ0, postQ1, postQ2),
    finalStates)

  println(afa)

  print("Checking emptiness ... ")

  if (IsEmpty(afa))
    println("empty")
  else
    println("not empty")
}