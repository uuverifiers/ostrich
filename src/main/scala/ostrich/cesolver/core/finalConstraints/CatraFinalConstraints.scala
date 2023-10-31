package ostrich.cesolver.core.finalConstraints

import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm


class CatraFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints