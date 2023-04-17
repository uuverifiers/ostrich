package ostrich.parikh

object OstrichConfig {

  sealed trait Backend
  case class Baseline() extends Backend
  case class Unary() extends Backend
  case class Catra() extends Backend

  var backend: Backend = Unary()
  var measureTime = false
  var useCostEnriched = false
  var debug = false
  var log = false
  var underApprox = true
  var underApproxBound = 15
  var overApprox = true
  var findStringHeu = false
  var simplifyAut = true

  def reset() = {
    backend = Unary()
    measureTime = false
    useCostEnriched = false
    debug = false
    log = false
    underApprox = true
    underApproxBound = 15
    overApprox = true
    findStringHeu = false
    simplifyAut = true 
  }
}
