package ostrich.cesolver.preprocess

import ap.terfor.TermOrder
import ap.terfor.conjunctions.Conjunction
import ostrich.cesolver.stringtheory.CEStringTheory
import ostrich.OFlags
import ostrich.cesolver.util.ParikhUtil

class CEInternalPreprocessor(theory: CEStringTheory, flags: OFlags) {
  def preprocess(f: Conjunction, order: TermOrder): Conjunction = {
    ParikhUtil.todo("CEInternalPreprocessor does nothing now", 3)
    f
  }
}
