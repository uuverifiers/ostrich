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

  override def id2ComplementedAutomaton(id: Int): Option[Automaton] =
    synchronized {
      (id2CompAut get id) match {
        case r @ Some(_) => r
        case None =>
          (id2Regex get id) match {
            case Some(regex) => {
              val aut =
                regex2Aut.buildComplementAut(regex)
              id2Aut.put(id, aut)
              Some(aut)
            }
            case None =>
              None
          }
      }
    }

}
