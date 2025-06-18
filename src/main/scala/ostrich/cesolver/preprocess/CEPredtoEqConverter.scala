package ostrich.cesolver.preprocess

import ap.proof.goal.Goal
import ostrich.cesolver.stringtheory.CEStringTheory
import ap.proof.theoryPlugins.Plugin
import ap.terfor.linearcombination.LinearCombination

class CEPredtoEqConverter(goal: Goal, theory: CEStringTheory) {

  import theory.{str_to_int, int_to_str, FunPred}
  implicit val order = goal.order
  import ap.terfor.TerForConvenience._

  val predConj = goal.facts.predConj

  def lazyEnumeration: Seq[Plugin.Action] = {
    val a =
      (for (
        lit <- predConj.positiveLitsWithPred(FunPred(str_to_int));
        act <- enumIntValues(lit.last).toSeq
      ) yield act)

    val b =
      (for (
        lit <- predConj.positiveLitsWithPred(FunPred(int_to_str));
        act <- enumIntValues(lit.head).toSeq
      ) yield act)
    a ++ b
  }

  private def enumIntValues(lc : LinearCombination) : Option[Plugin.Action] =
    for (t <- Some(lc);
         if !t.isConstant;
         enumAtom = conj(theory.IntEnumerator.enumIntValuesOf(t, order));
         if !goal.reduceWithFacts(enumAtom).isTrue)
    yield Plugin.AddAxiom(List(), enumAtom, theory)
    
}
