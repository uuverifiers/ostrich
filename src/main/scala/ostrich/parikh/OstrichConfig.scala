package ostrich.parikh

object OstrichConfig {

  sealed trait Backend
  case class Baseline() extends Backend
  case class Unary() extends Backend
  case class Catra() extends Backend
  

  var backend : Backend = Unary()

  var measureTime = true

  var useCostEnriched = false 

  var debug = false

  var log = false 

  var underApprox = true 

  var underApproxBound = 15

  var overApprox = true 

  var findStringHeu = true 

}
