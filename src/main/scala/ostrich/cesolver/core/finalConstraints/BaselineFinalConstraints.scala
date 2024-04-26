package ostrich.cesolver.core.finalConstraints

import scala.collection.mutable.{HashMap => MHashMap}
import ostrich.cesolver.automata.CostEnrichedAutomatonBase
import ap.parser.ITerm
import ap.parser.IFormula
import ap.parser.IExpression
import ap.parser.IExpression._
import scala.collection.mutable.ArrayBuffer
import ostrich.cesolver.util.TermGenerator
import scala.collection.mutable.{HashSet => MHashSet}
import ostrich.cesolver.util.ParikhUtil
import ap.parser.IBinJunctor
import ostrich.OFlags
import ap.basetypes.IdealInt
import ap.api.PartialModel
import ostrich.automata.AutomataUtils.findAcceptedWord

class BaselineFinalConstraints(
    override val strDataBaseId: ITerm,
    override val auts: Seq[CostEnrichedAutomatonBase],
    flags: OFlags
) extends FinalConstraints {
  val regsTerms: Seq[ITerm] = auts.flatMap(_.registers)

  lazy val getCompleteLIA: IFormula = {
    connectSimplify(
      Seq(ParikhUtil.parikhImage(auts.reduce(_ product _)), getRegsRelation),
      IBinJunctor.And
    )
  }

  def getRegsRelation: IFormula =
    connectSimplify(auts.map(_.regsRelation), IBinJunctor.And)

  def getModel(partialModel: PartialModel): Option[Seq[Int]] = {
    var registersModel = Map[ITerm, IdealInt]()
    for (term <- auts.flatMap(_.registers))
      registersModel += (term -> FinalConstraints.evalTerm(term, partialModel))
    ParikhUtil.findAcceptedWord(auts, registersModel, flags)
  }

}
