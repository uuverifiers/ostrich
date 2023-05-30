package ostrich.cesolver.preprocess

import ap.basetypes.IdealInt
import ap.theories.Theory
import ap.terfor.{TermOrder, TerForConvenience}
import ap.terfor.conjunctions.{Conjunction, ReduceWithConjunction}
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.substitutions.VariableShiftSubst
import ap.types.SortedPredicate
import ap.parameters.{Param, ReducerSettings}
import ostrich.cesolver.stringtheory.CEStringTheory
import ostrich.OFlags
import ostrich.cesolver.stringtheory.CEStringFunctionTranslator
import ostrich.cesolver.util.ParikhUtil

class CEInternalPreprocessor(theory: CEStringTheory, flags: OFlags) {
  import theory.{
    FunPred,
    StringSort,
    str_len,
    _str_len,
    _str_char_count,
    str_++,
    _str_++,
    str_in_re_id,
    strDatabase,
    autDatabase
  }
  def preprocess(f: Conjunction, order: TermOrder): Conjunction = {
    // ParikhUtil.todo("CEInternalPreprocessor")
    f
  }
}
