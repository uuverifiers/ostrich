package ostrich.parikh.core


import ap.terfor.Term
import ap.basetypes.IdealInt

object Model {
  sealed trait Value 
  case class IntValue(i: IdealInt) extends Value
  case class StringValue(str: Seq[Int]) extends Value
}
import Model._

trait Model {

  val name : String

  protected var model : Map[Term, Value] = Map.empty

  def update(term: Term, value: Value): Unit = model += (term -> value)
  
  def clear: Unit = model = Map.empty

  def isEmpty = model.isEmpty

  def getModel = model

} 


class OstrichModel extends Model {
  val name = "Ostrich Model"

  def update(term: Term, value: IdealInt): Unit = super.update(term, IntValue(value))

  def update(term: Term, value: Seq[Int]): Unit = super.update(term, StringValue(value))
}