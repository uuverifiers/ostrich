/* Added by Riccardo */

package ostrich

import ap.basetypes.IdealInt
import ap.parser.{IFunApp, IIntLit}

import scala.collection.mutable.{HashMap => MHashMap}

class StrDatabase(theory : OstrichStringTheory) {

  private val id2StrMap = new MHashMap[Int, (IFunApp, Option[Int])]
  private val str2IdMap = new MHashMap[IFunApp, Int]


  /** Query the id for a concrete string */
  def id2Str(id : Int) : List[Int] = {
    id2StrMap.get(id) match {
      case Some((IFunApp(this.theory.str_empty, _), None)) => Nil

      case Some((funApp, Some(nextId))) => funApp(2).asInstanceOf[IIntLit].value.intValueSafe :: id2Str(nextId)
    }
  }

  /** Query a string for an id (it adds str to database if not already present) */
  def str2Id(str : IFunApp) : Int = synchronized {
    str2IdMap getOrElseUpdate(str, {
      val id = str2IdMap.size
      str2IdMap.put(str, id)

      str match {
        case IFunApp(this.theory.str_empty, _) => {
          id2StrMap put(id, (str, None))
          return id
        }

        case IFunApp(this.theory.str_cons, _) => {
          val strHead = str.args(0).asInstanceOf[IFunApp]
          val strTail = str.args(1).asInstanceOf[IFunApp]
          str2IdMap get strTail match {
            case None => throw new RuntimeException("Riccardo, this should not happen!")
            case Some(s) => id2StrMap put (id, (strHead, Some(s)))
          }
          return id
        }
      }
    })
  }

}
