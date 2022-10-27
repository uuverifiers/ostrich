package ostrich.parikh
import pureconfig._
import pureconfig.generic.auto._

object Config {

  sealed trait ProductStrategy
  case class Basic() extends ProductStrategy
  case class Lazy() extends ProductStrategy

  sealed trait Backend
  case class Baseline() extends Backend
  case class Unary() extends Backend
  case class Catra() extends Backend
  
  case class ParikhConf(
      strategy: ProductStrategy = Basic(),
      backend: Backend = Baseline(),
      measureTime: Boolean = true,
      useCostEnriched: Boolean = false
  )

  lazy val config: ConfigReader.Result[ParikhConf] = ConfigSource.default.load[ParikhConf]

  lazy val productStrategy = config.right.get.strategy

  var backend = config.right.get.backend

  lazy val measureTime = config.right.get.measureTime

  var useCostEnriched = config.right.get.useCostEnriched

  productStrategy match {
    case Basic() => Console.err.println("Basic product")
    case Lazy() => Console.err.println("Lazy product")
  }
}
