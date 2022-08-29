package ostrich.parikh
import pureconfig._
import pureconfig.generic.auto._

object Config {
  sealed trait ProductStrategy
  case class RegisterBased() extends ProductStrategy
  case class IC3Based() extends ProductStrategy

  case class ParikhBased(
      minSyncLen: Int =
        1, // min length to synchorinize, should greater than 0, 0 is meaningless and easy to lead `unknown`
      maxSyncLen: Int = 4, // max length to synchorinize
      repeatTimes: Int = 5  // max repeat times to find accepted word
  ) extends ProductStrategy

  // default strategy is `RegisterBased`
  case class ParikhConf(strategy: ProductStrategy = RegisterBased())

  lazy val config = ConfigSource.default.load[ParikhConf]

  lazy val strategy = config.right.get.strategy
}
