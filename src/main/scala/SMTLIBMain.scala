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

import ap._
import ap.parser._
import ap.parameters.PreprocessingSettings
import ap.util.CmdlParser
import scala.collection.mutable.ArrayBuffer
import ap.theories.TheoryRegistry

object SMTLIBMain {

  class MainException(msg : String) extends Exception(msg)
  object TimeoutException extends MainException("timeout")
  object StoppedException extends MainException("stopped")

  def doMain(args: Array[String],
             stoppingCond : => Boolean) : Unit = try {
    val filenames = new ArrayBuffer[String]
    var timeout : Option[Long] = None
    var model = false
    var assertions = false

    for (str <- args) str match {
      case CmdlParser.ValueOpt("timeout", value) =>
        timeout = Some(value.toLong * 1000)
      case CmdlParser.Opt("model", value) =>
        model = value
      case CmdlParser.Opt("assert", value) =>
        assertions = value
      case CmdlParser.Opt("splitOpt", value) =>
        Flags.splitOptimization = value
      case CmdlParser.ValueOpt("modelChecker", mcs) =>
        try {
          mcs.split(",").foreach { mc =>
            val modelChecker = Flags.ModelChecker withName mc

            if (Flags.isABC && modelChecker == Flags.ModelChecker.nuxmv)
              Flags.modelChecker -= Flags.ModelChecker.abc

            Flags.modelChecker += modelChecker
          }
        } catch {
          case _ : NoSuchElementException =>
            throw new Exception("unknown model checker")
        }
      case CmdlParser.Opt("minimalSuccessors", value) =>
        Flags.minimalSuccessors = value
      case str =>
        filenames += str
    }

    if (filenames.size != 1)
      throw new Exception("expected a single filename as argument")

    val startTime = System.currentTimeMillis

    val timeoutChecker = timeout match {
      case Some(to) => () => {
        if (System.currentTimeMillis - startTime > to)
          throw TimeoutException
        if (stoppingCond)
          throw StoppedException
      }
      case None => () => {
        if (stoppingCond)
          throw StoppedException
      }
    }

    ap.util.Debug.enableAllAssertions(assertions)

    ////////////////////////////////////////////////////////////////////////////

    val fileName = filenames.head
    Console.err.println("Reading file " + fileName + " ...")

    val reader = new SMTReader(fileName)
    val bitwidth = reader.bitwidth
    if (reader.includesGetModel)
      model = true

    // just handle the problem using a normal solver
    val functionEnc =
      new FunctionEncoder (true, false)
    for (t <- reader.signature.theories)
      functionEnc addTheory t

    val (List(INamedPart(_, formula)), _, signature) =
    Preprocessing(reader.rawFormula,
      List(),
      reader.signature,
      PreprocessingSettings.DEFAULT,
      functionEnc)

    // tell the AFA store about introduced relations
    for ((p, f) <- functionEnc.predTranslation)
      if ((TheoryRegistry lookupSymbol f).isEmpty)
        RRFunsToAFA.addRel2Fun(p, f)

    val formulaWithoutQuans = SMTReader.eliminateUniQuantifiers(formula)
    val intFormula = StringTheoryTranslator(formulaWithoutQuans,
      reader.wordConstants)

    SimpleAPI.withProver(enableAssert = assertions) { p =>
      import IExpression._
      import SimpleAPI._
      import p._

      try {
        addConstantsRaw(SymbolCollector constantsSorted intFormula)
        addRelations(for (p <- signature.order.orderedPredicates.toSeq sortBy (_.name);
                          if ((TheoryRegistry lookupSymbol p).isEmpty))
                     yield p)

        ?? (intFormula)

        Console.err.println
        val res = {
          checkSat(false)
          while (getStatus(100) == ProverStatus.Running)
            timeoutChecker()
          ???
        }

        res match {
          case ProverStatus.Valid => println("unsat")
          case ProverStatus.Inconclusive => println("unknown")
          case ProverStatus.OutOfMemory => println("OOM")
          case ProverStatus.Invalid => {
            println("sat")

            if (model) {
              Console.err.println
              for (c <- reader.wordConstants)
                for (v <- evalPartial(c)) {
                  print("(define-fun " +
                        (SMTLineariser quoteIdentifier c.name) +
                        " () String ")
                  println("\"" +
                          SMTLIBStringParser.escapeString(
                            StringTheory.asString(v)(decoderContext)) +
                          "\")")
                }
              for (c <- reader.otherConstants)
                for (v <- evalPartial(c)) {
                  print("(define-fun " +
                        (SMTLineariser quoteIdentifier c.name) +
                        " () Int ")
                  println("" + v + ")")
                }
            }
          }
        }

      } finally {
        // Make sure that the prover actually stops. If stopping takes
        // too long, kill the whole process
        stop(false)
        if (getStatus((timeout getOrElse 10000.toLong) max 10000.toLong) ==
          ProverStatus.Running) {
          println("(error \"timeout, killing solver process\")")
          System exit 1
        }
      }
    }
  } catch {
    case t@(TimeoutException | StoppedException) =>
      println("unknown")
    case t : Throwable => {
      println("(error \"" + t.getMessage + "\")")
        t.printStackTrace
    }
  }

  def main(args: Array[String]) : Unit = {
    doMain(args, false)
  }

}
