package ostrich.cesolver.automata

import ostrich.OstrichStringTheory
import ostrich.automata.AutDatabase
import scala.collection.mutable.{HashMap => MHashMap}
import ap.parser.ITerm
import ostrich.automata.Automaton
import ostrich.automata.AutomataUtils

class CEAutDatabase(theory: OstrichStringTheory, minimizeAutomata: Boolean){

  import AutDatabase._

  private val regex2Aut  = new Regex2CEAut(theory)

  private var nextId     = 0

  private val regexes    = new MHashMap[ITerm, Int]
  private val id2Regex   = new MHashMap[Int, ITerm]
  private val id2Aut     = new MHashMap[Int, Automaton]
  private val id2CompAut = new MHashMap[Int, Automaton]

  private val subsetRel  =
    new MHashMap[(NamedAutomaton, NamedAutomaton), Boolean]

  /**
   * Query the id of a regular expression.
   */
  def regex2Id(regexTerm : ITerm) : Int =
    synchronized {
      regexes.getOrElseUpdate(regexTerm, {
                                val id = nextId
                                nextId = nextId + 1
                                id2Regex.put(id, regexTerm)
                                id })
    }

  /**
   * Add a new automaton to the database.
   */
  def automaton2Id(aut : Automaton) : Int =
    synchronized {
      val id = nextId
      nextId = nextId + 1
      id2Aut.put(id, aut)
      id
    }

  /**
   * Query the id of a regular expression.
   */
  def id2Regex(id : Int) : Option[ITerm] =
    synchronized {
      id2Regex get id
    }

  /**
   * Query the automaton that belongs to the regular expression with given id.
   */
  def id2Automaton(id : Int) : Option[Automaton] =
    synchronized {
      (id2Aut get id) match {
        case r@Some(_) => r
        case None =>
          (id2Regex get id) match {
            case Some(regex) => {
              val aut = regex2Aut.buildAut(regex, minimizeAutomata)
              id2Aut.put(id, aut)
              Some(aut)
            }
            case None =>
              None
          }
      }
    }

  /**
   * Query the automaton that belongs to the regular expression with given id;
   * return the automaton only if it is already in the database.
   */
  def id2AutomatonBE(id : Int) : Option[Automaton] =
    synchronized { id2Aut get id }

  /**
   * Query the complemented automaton that belongs to the regular
   * expression with given id.
   */
  def id2ComplementedAutomaton(id : Int) : Option[Automaton] =
    synchronized {
      (id2CompAut get id) match {
        case r@Some(_) => r
        case None =>
          id2Automaton(id) match {
            case Some(aut) => {
              val compAut = !aut
              id2CompAut.put(id, compAut)
              Some(compAut)
            }
            case None =>
              None
          }
      }
    }

  /**
   * Query the complemented automaton that belongs to the regular
   * expression with given id;
   * return the automaton only if it is already in the database.
   */
  def id2ComplementedAutomatonBE(id : Int) : Option[Automaton] =
    synchronized { id2CompAut get id }

  /**
   * Query the automaton that belongs to the regular expression with
   * given id.
   */
  def id2Automaton(id : NamedAutomaton) : Option[Automaton] = id match {
    case PositiveAut(id)     => id2Automaton(id)
    case ComplementedAut(id) => id2ComplementedAutomaton(id)
  }

  /**
   * Query the automaton that belongs to the regular expression with
   * given id;
   * return the automaton only if it is already in the database.
   */
  def id2AutomatonBE(id : NamedAutomaton) : Option[Automaton] = id match {
    case PositiveAut(id)     => id2AutomatonBE(id)
    case ComplementedAut(id) => id2ComplementedAutomatonBE(id)
  }

  /**
   * Check whether <code>aut1</code> specifies a subset of <code>aut2</code>.
   */
  def isSubsetOf(aut1 : NamedAutomaton, aut2 : NamedAutomaton) : Boolean =
    if (aut1.id < aut2.id) {
      synchronized {
        // aut1 <= aut2
        //  <==>
        // (aut1 & aut2.complement) = empty
        subsetRel.getOrElseUpdate((aut1, aut2),
                                  !AutomataUtils.areConsistentAutomata(
                                    List(id2Automaton(aut1).get,
                                         id2Automaton(aut2.complement).get)))
      }
    } else if (aut1.id > aut2.id) {
      isSubsetOf(aut2.complement, aut1.complement)
    } else {
      true
    }

  /**
   * Check whether <code>aut1</code> specifies a subset of <code>aut2</code>;
   * the check is only carried out when all required automata are already in
   * the database.
   */
  def isSubsetOfBE(aut1 : NamedAutomaton,
                   aut2 : NamedAutomaton) : Option[Boolean] =
    if (aut1.id < aut2.id) {
      synchronized {
        // aut1 <= aut2
        //  <==>
        // (aut1 & aut2.complement) = empty
        for (a1 <- id2AutomatonBE(aut1);
             a2 <- id2AutomatonBE(aut2.complement)) yield 
          subsetRel.getOrElseUpdate((aut1, aut2),
                                    !AutomataUtils.areConsistentAutomata(
                                      List(a1, a2)))
      }
    } else if (aut1.id > aut2.id) {
      isSubsetOfBE(aut2.complement, aut1.complement)
    } else {
      Some(true)
    }

  /**
   * Check whether <code>aut1</code> and <code>aut2</code> have empty
   * intersection.
   */
  def emptyIntersection(aut1 : NamedAutomaton,
                        aut2 : NamedAutomaton) : Boolean =
    isSubsetOf(aut1, aut2.complement)

  /**
   * Query the automaton that belongs to a regular expression.
   */
  def regex2Automaton(regexTerm : ITerm) : Automaton =
    id2Automaton(regex2Id(regexTerm)).get

  /**
   * Query the complemented automaton that belongs to a regular expression.
   */
  def regex2ComplementedAutomaton(regexTerm : ITerm) : Automaton =
    id2ComplementedAutomaton(regex2Id(regexTerm)).get

}
