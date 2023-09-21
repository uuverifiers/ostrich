package ostrich.cesolver.core.finalConstraints

import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.cesolver.util.ParikhUtil
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression._

class BaselineFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints 