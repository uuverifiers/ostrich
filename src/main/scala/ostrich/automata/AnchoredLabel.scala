/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2021 Zhilei Han. All rights reserved.
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

object AnchoredLabels {
  // an anchored label is normal label conjoined
  // with ^ and $
  abstract class AnchoredLabel

  // normal label
  case class NormalLabel(val l: (Char, Char)) extends AnchoredLabel

  // begin anchor
  case object BeginAnchor extends AnchoredLabel

  // end anchor
  case object EndAnchor extends AnchoredLabel

// the LabelOps counterpart
object AnchoredLabelOps extends TLabelOps[AnchoredLabel] {

  val vocabularyWidth : Int = 16; // meaningless

  /**
   * Check whether the given label accepts some letter
   */
  def isNonEmptyLabel(label : AnchoredLabel) : Boolean = {
    label match {
      case BeginAnchor => true
      case EndAnchor => true
      case NormalLabel(l) => BricsTLabelOps.isNonEmptyLabel(l)
    }
  }

  /**
   * Label accepting all letters
   */
  val sigmaLabel : AnchoredLabel =
    NormalLabel(BricsTLabelOps.sigmaLabel)

  /**
   * Intersection of two labels
   */
  def intersectLabels(l1 : AnchoredLabel,
                      l2 : AnchoredLabel) : Option[AnchoredLabel] = {
    (l1, l2) match {
      case (NormalLabel(ll1), NormalLabel(ll2)) => BricsTLabelOps.intersectLabels(ll1, ll2).map((c) => NormalLabel(c))
      case (BeginAnchor, BeginAnchor) => Some(BeginAnchor)
      case (EndAnchor, EndAnchor) => Some(EndAnchor)
      case _ => None
    }
  }

  /**
   * True if labels overlap
   */
  def labelsOverlap(l1 : AnchoredLabel,
                    l2 : AnchoredLabel) : Boolean = {
    (l1, l2) match {
      case (NormalLabel(ll1), NormalLabel(ll2)) => BricsTLabelOps.labelsOverlap(ll1, ll2)
      case (BeginAnchor, BeginAnchor) => true
      case (EndAnchor, EndAnchor) => true
      case _ => false
    }
  }

  /**
   * Can l represent a?
   */
  def labelContains(a : Char, l : AnchoredLabel) : Boolean = {
    l match {
      case (NormalLabel(l1)) => BricsTLabelOps.labelContains(a, l1)
      case _ => false
    }
  }

  /**
   * Enumerate all letters accepted by a transition label
   */
  def enumLetters(label : AnchoredLabel) : Iterator[Int] =
    label match {
      case (NormalLabel(l)) => BricsTLabelOps.enumLetters(l)
      case _ => Iterator.empty
    }

  /**
   * Remove a given character from the label.  E.g. [1,10] - 5 is
   * [1,4],[6,10]
   */
  def subtractLetter(a : Char, lbl : AnchoredLabel) : Iterable[AnchoredLabel] = {
    lbl match {
      case NormalLabel(l) => {
        val blbls = BricsTLabelOps.subtractLetter(a, l)
        blbls.map((c) => NormalLabel(c))
      }
      case _ => Iterable(lbl)
    }
  }

  /**
   * Remove a given character from the label.  E.g. [1,10] - 5 is
   * [1,4],[6,10]
   */
  def subtractLetters(as : Iterable[Char], lbl : AnchoredLabel) : Iterable[AnchoredLabel] = {
    lbl match {
      case NormalLabel(l) => {
        val blbls = BricsTLabelOps.subtractLetters(as, l)
        blbls.map((c) => NormalLabel(c))
      }
      case _ => Iterable(lbl)
    }
  }

  /**
   * Shift characters by n, do not wrap.  E.g. [1,2].shift 3 = [4,5]
   */
  def shift(lbl : AnchoredLabel, n : Int) : AnchoredLabel = {
    lbl match {
      case (NormalLabel(l)) => NormalLabel(BricsTLabelOps.shift(l, n))
      case _ => lbl
    }
  }

  /**
   * Get representation of interval [min,max]
   */
  def interval(min : Char, max : Char) : AnchoredLabel = {
    NormalLabel(BricsTLabelOps.interval(min, max))
  }

  def singleton(c : Char) : AnchoredLabel = interval(c, c)

  def weaken(lbl : AnchoredLabel) : Option[(Char, Char)] = {
    lbl match {
      case NormalLabel(l) => Some(l)
      case _ => None
    }
  }

  def print(lbl : AnchoredLabel) : String = {
    lbl match {
      case NormalLabel(l) => l.toString
      case BeginAnchor => "^"
      case EndAnchor => "$"
    }
  }
}
  
}

