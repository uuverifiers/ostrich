package ostrich.cesolver.core.finalConstraints


import ap.parser.ITerm

import ostrich.cesolver.automata.CostEnrichedAutomatonBase

class NuxmvFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase]
) extends FinalConstraints 