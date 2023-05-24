package ostrich.cesolver.automata

import ostrich.OstrichStringTheory
import ostrich.automata.AutDatabase
import scala.collection.mutable.{HashMap => MHashMap}
import ap.parser.ITerm
import ostrich.automata.Automaton
import ostrich.automata.AutomataUtils

class CEAutDatabase(theory: OstrichStringTheory, minimizeAutomata: Boolean)
    extends AutDatabase(theory, minimizeAutomata) {

  import AutDatabase._
  override val regex2Aut = new Regex2CEAut(theory)
}
