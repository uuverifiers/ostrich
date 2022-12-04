package ostrich.parikh.core

import ap.terfor.TerForConvenience._
import ostrich.parikh.TermGeneratorOrder.order
import ap.terfor.Formula
import scala.collection.mutable.{
  ArrayBuffer,
  HashMap => MHashMap,
  HashSet => MHashSet,
  Stack => MStack
}
import ap.terfor.Term
import ostrich.parikh.KTerm
import ap.terfor.conjunctions.Conjunction
import ostrich.parikh.ZTerm
import ap.terfor.linearcombination.LinearCombination
import ostrich.parikh.CostEnrichedConvenience._
import ap.terfor.preds.Atom
import ostrich.parikh.util.UnknownException
import ostrich.parikh.writer.TempWriter
import ostrich.parikh.writer.Logger
import ostrich.parikh.OstrichConfig
import ostrich.parikh.automata.CostEnrichedAutomatonTrait
import ostrich.parikh.automata.CEBasicOperations
import ostrich.parikh.automata.CostEnrichedAutomaton

class CatraAC(override val aut: CostEnrichedAutomatonTrait)
    extends BaselineAC(aut)