package ostrich.cesolver.core.finalConstraints


import ap.parser.ITerm

import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ostrich.OFlags

class NuxmvFinalConstraints(
    strDataBaseId: ITerm,
    auts: Seq[CostEnrichedAutomatonBase],
    flags: OFlags
) extends CatraFinalConstraints(strDataBaseId, auts, flags)