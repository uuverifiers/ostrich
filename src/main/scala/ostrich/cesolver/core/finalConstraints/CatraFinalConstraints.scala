package ostrich.cesolver.core.finalConstraints

import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ostrich.OFlags
import ap.basetypes.IdealInt
import ostrich.cesolver.util.ParikhUtil


class CatraFinalConstraints(
    strDataBaseId: ITerm,
    auts: Seq[CostEnrichedAutomatonBase],
    flags: OFlags
) extends BaselineFinalConstraints(strDataBaseId, auts, flags) {
    def getModel(termModel: Map[ITerm, IdealInt]): Option[Seq[Int]] = {
        ParikhUtil.findAcceptedWord(auts, termModel, flags)
    }
}