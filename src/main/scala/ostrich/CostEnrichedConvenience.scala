package ostrich

import ostrich.automata.Automaton
import ostrich.preop.PreOp
import ostrich.preop.costenrich.CostEnrichedPreOp
import ostrich.automata.costenrich.CostEnrichedAutomaton
import ap.terfor.conjunctions.Conjunction
import ap.parser.IExpression
import ap.parser.Internal2InputAbsy
import ap.terfor.Term
import ap.parser.ITerm
import ap.terfor.ConstantTerm
import ap.terfor.Formula
import ap.parser.IFormula
import ostrich.automata.BricsAutomaton
import scala.collection.mutable.HashMap
import ostrich.automata.AtomicStateAutomatonAdapter.intern
import ostrich.automata.AtomicStateAutomatonBuilder
import ostrich.automata.costenrich.CostEnrichedAutomatonBuilder
import ostrich.automata.AtomicStateAutomaton

object CostEnrichedConvenience {

  def isCostEnrich(aut : Automaton) : Boolean = {
    aut match {
      case _ : CostEnrichedAutomaton => true
      case _ => false
    }
  }
  // implicit def Internal2Input(c: Conjunction): IFormula =
  //   Internal2InputAbsy(c)

  implicit def Internal2Input(f: Formula): IFormula =
    Internal2InputAbsy(f)
    
  implicit def Internal2Input(t: Iterable[Term]): Iterable[ITerm] =
    t.map(Internal2InputAbsy(_))


  implicit def term2ConstTerm(t: Seq[Term]): Seq[ConstantTerm] = {
    t.map(t => term2ConstTerm(t))
  }

  implicit def term2ConstTerm(t: Term): ConstantTerm = {
    if(t.isInstanceOf[ConstantTerm]) {
      t.asInstanceOf[ConstantTerm]
    } else {
      val e = new Exception(s"Term $t is not a constant term")
      e.printStackTrace()
      throw e
    }
  }


  implicit def automaton2CostEnriched(aut: Automaton): CostEnrichedAutomaton = {
    val internAut = intern(aut)
    if(internAut.isInstanceOf[CostEnrichedAutomaton]) {
      internAut.asInstanceOf[CostEnrichedAutomaton]
    } else if(internAut.isInstanceOf[BricsAutomaton]){
      val underlying = internAut.asInstanceOf[BricsAutomaton].underlying
      new CostEnrichedAutomaton(underlying)
    } else {
      val e = new Exception(s"Automaton $aut is not a cost-enriched automaton")
      e.printStackTrace()
      throw e
    }
  }

  implicit def automaton2CostEnriched(auts: Seq[Automaton]): Seq[CostEnrichedAutomaton] =
    auts.map(automaton2CostEnriched(_))
  
  // implicit def automaton2CostEnriched(auts: Seq[Seq[Automaton]]): Seq[Seq[CostEnrichedAutomaton]] =
  //   auts.map(_.map(automaton2CostEnriched(_)))

  implicit def preOp2CostEnriched(op: PreOp): CostEnrichedPreOp = {
    if(op.isInstanceOf[CostEnrichedPreOp]) {
      op.asInstanceOf[CostEnrichedPreOp]
    } else {
      val e = new Exception(s"PreOp $op is not a cost-enriched pre-op")
      e.printStackTrace()
      throw e
    }
  }

}
