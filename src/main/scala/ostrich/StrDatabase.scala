/* Added by Riccardo */

package ostrich

import ap.parser.ITerm
import ap.parser.smtlib.Absyn.StringConstant

import scala.collection.mutable.{HashMap => MHashMap}

class StrDatabase(theory : OstrichStringTheory) {

  private val ids2StrMap = new MHashMap[Int, ITerm]
  private val str2IdMap = new MHashMap[ITerm, Int]

  /** Query the id for a string */
  def id2Str(id : Int) : Option[ITerm] =
    synchronized {
      ids2StrMap get id
    }

  /** Query a string for an id (it adds str to database if not already present) */
  def Str2Id(str : ITerm) : Int =
    synchronized {
      str2IdMap.getOrElseUpdate(str, {
        val id = str2IdMap.size
        ids2StrMap.put(id, str)
        id })
    }

}
