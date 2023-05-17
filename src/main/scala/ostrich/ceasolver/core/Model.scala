package ostrich.ceasolver.core


import ap.basetypes.IdealInt
import ap.parser.ITerm

object Model {
  sealed trait Value 
  case class IntValue(i: IdealInt) extends Value
  case class StringValue(str: Seq[Int]) extends Value
}
import Model._

trait Model {

  val name : String

  protected var model : Map[ITerm, Value] = Map.empty

  def update(term: ITerm, value: Value): Unit = model += (term -> value)
  
  def clear: Unit = model = Map.empty

  def isEmpty = model.isEmpty

  def getModel = model

} 


class OstrichModel extends Model {
  val name = "Ostrich Model"

  def update(term: ITerm, value: IdealInt): Unit = super.update(term, IntValue(value))

  def update(term: ITerm, value: Seq[Int]): Unit = super.update(term, StringValue(value))
}