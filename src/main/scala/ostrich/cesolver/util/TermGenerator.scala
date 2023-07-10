/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2023 Denghang Hu. All rights reserved.
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

package ostrich.cesolver.util

import ap.parser.ITerm
import ap.terfor.ConstantTerm
import ap.terfor.TermOrder
import ap.parser.IExpression._


object TermGenerator {
  def apply(id: Int): TermGenerator = new TermGenerator(id)

  private var id_counter = 0

  private def nextId : Int = synchronized {
    id_counter = id_counter + 1
    id_counter - 1
  }

  def apply(): TermGenerator = new TermGenerator(nextId)
}

class TermGenerator private (val id: Int) {
  var count = 0
  def registerTerm: ITerm = {
    count = count + 1
    Sort.Integer.newConstant(s"R${count}_${id}")
  }

  def transitionTerm: ITerm = {
    count = count + 1
    Sort.Integer.newConstant(s"T${count}_${id}")
  }

  def zTerm: ITerm = {
    count = count + 1
    Sort.Integer.newConstant(s"Z${count}_${id}")
  }

  def lenTerm: ITerm = {
    count = count + 1
    Sort.Integer.newConstant(s"Len${count}_${id}")
  }

  def intTerm: ITerm = {
    count = count + 1
    Sort.Integer.newConstant(s"Int${count}_${id}")
  }
}
