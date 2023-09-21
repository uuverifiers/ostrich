package ostrich.cesolver.core.finalConstraints

import scala.collection.mutable.{HashMap => MHashMap}

import ap.parser.{ITerm, IFormula}
import ap.parser.IExpression._

import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.cesolver.util.ParikhUtil

class NuxmvFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints 