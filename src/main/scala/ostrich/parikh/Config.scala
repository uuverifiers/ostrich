package ostrich.parikh
import pureconfig._
import pureconfig.generic.auto._

object Config {

  sealed trait ProductStrategy
  case class BasicProduct() extends ProductStrategy

  sealed trait LengthAbstractStrategy
  case class Parikh() extends LengthAbstractStrategy
  case class Unary() extends LengthAbstractStrategy
  case class Catra() extends LengthAbstractStrategy

  case class SyncSubstr(
      minSyncLen: Int =
        1, // min length to synchorinize, should greater than 0, 0 is meaningless and easy to lead `unknown`
      maxSyncLen: Int = 3, // max length to synchorinize
      repeatTimes: Int = 5 // max repeat times to find accepted word
  ) extends ProductStrategy

  // default strategy is `RegisterBased`
  case class ParikhConf(
      strategy: ProductStrategy = BasicProduct(),
      lengthAbsStrategy: LengthAbstractStrategy = Parikh(),
      measureTime: Boolean = true,
      useCostEnriched: Boolean = false
  )

  lazy val config: ConfigReader.Result[ParikhConf] = ConfigSource.default.load[ParikhConf]

  lazy val productStrategy = config.right.get.strategy

  var lengthAbsStrategy = config.right.get.lengthAbsStrategy

  lazy val measureTime = config.right.get.measureTime

  var useCostEnriched = config.right.get.useCostEnriched

  productStrategy match {
    case BasicProduct() => Console.err.println("Basic product")
    case SyncSubstr(minSyncLen, maxSyncLen, repeatTimes) =>
      Console.err.println(s"SyncSubstr($minSyncLen, $maxSyncLen, $repeatTimes)")
  }
}
