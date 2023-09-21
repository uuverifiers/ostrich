package ostrich.cesolver.core.finalConstraints

import ap.terfor.Formula
import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IExpression._
import ap.parser.IFormula
import ostrich.cesolver.util.ParikhUtil


class CatraFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints