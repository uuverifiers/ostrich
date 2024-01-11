package ostrich.cesolver.automata

import ostrich.OstrichStringTheory
import ostrich.automata.AutDatabase
import ostrich.automata.Automaton
import ostrich.cesolver.util.ParikhUtil

class CEAutDatabase(theory: OstrichStringTheory, minimizeAutomata: Boolean)
    extends AutDatabase(theory, minimizeAutomata) {

  override val regex2Aut = new Regex2CEAut(theory)

  override def id2ComplementedAutomaton(id: Int): Option[Automaton] =
    synchronized {
      (id2CompAut get id) match {
        case r @ Some(_) => r
        case None =>
          (id2Regex get id) match {
            case Some(regex) => {
              val aut =
                regex2Aut.buildComplementAut(regex, minimizeAutomata)
              id2CompAut.put(id, aut)
              Some(aut)
            }
            case None =>
              None
          }
      }
    }

}
