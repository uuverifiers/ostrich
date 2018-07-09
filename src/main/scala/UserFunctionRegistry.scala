/*
 * This file is part of Sloth, an SMT solver for strings.
 * Copyright (C) 2018  Matthew Hague, Philipp Ruemmer
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

import scala.collection.mutable.{HashMap => MHashMap}

import ap.parser._

import preprop.PreOp

/**
 * Object to manage simpler definitions of "user" functions
 *
 * To easily add a new function, define a PreOp object for the function,
 * then call UserFunction.registerFunction(name, arity, preOp) before
 * any calls to main are made
 */
object UserFunctionRegistry {
  // from StringTheory names to preops
  val preOpMap = new MHashMap[String, PreOp]
  // from SMTLIBString theory names to StringTheory names
  val smtlibTranslate = new MHashMap[String, String]
  // from StringTheory name to StringTheory IFunction
  val strFuns = new MHashMap[String, IFunction]
  // from SMTLIBStringTheory name to StringTheory IFunction
  val smtFuns = new MHashMap[String, IFunction]

  /**
   * Call before main function.  Register a new function.
   */
  def registerFunction(name : String, arity : Integer, preOp : PreOp) : Unit = {
    val smtname = name
    val strname = "user_" + name
    val smtfun = new IFunction(smtname, arity, true, false)
    val strfun = new IFunction(strname, arity, true, false)

    preOpMap += (strname -> preOp)
    smtlibTranslate += (smtname -> strname)
    strFuns += (strname -> strfun)
    smtFuns += (smtname -> smtfun)
  }

  def getPreOp(name : String) : Option[PreOp] = preOpMap.get(name)

  def isUserDefinedSMTLIBFun(name : String) : Boolean = smtlibTranslate.contains(name)

  def isUserDefinedStringTheoryFun(name : String) : Boolean = preOpMap.contains(name)

  /**
   * Translate from an SMTLIBStringTheory name to a StringTheory name
   */
  def getStringTheoryName(name : String) : Option[String] = smtlibTranslate.get(name)

  def getSMTLIBStringTheoryFun(name : String) : Option[IFunction] = smtFuns.get(name)

  def getStringTheoryFun(name : String) : Option[IFunction] = strFuns.get(name)

  //////////////////////////////////////////////////////////////////
  // Load from UserFunctions

  for ((n, a, p) <- UserFunctions.functions)
    registerFunction(n, a, p)

  val stringTheoryFuns : Iterable[IFunction] = strFuns.values

  val SMTLIBStringTheoryFuns : Iterable[IFunction] = smtFuns.values
}
