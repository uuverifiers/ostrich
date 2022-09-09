package ostrich.parikh
import pureconfig._
import pureconfig.generic.auto._

object Config {
  sealed trait ProductStrategy
  case class BasicProduct() extends ProductStrategy
  case class IC3Based() extends ProductStrategy

  sealed trait LengthAbstractStrategy
  case class Parikh() extends LengthAbstractStrategy
  case class Unary() extends LengthAbstractStrategy

  case class SyncSubstr(
      minSyncLen: Int =
        1, // min length to synchorinize, should greater than 0, 0 is meaningless and easy to lead `unknown`
      maxSyncLen: Int = 3, // max length to synchorinize
      repeatTimes: Int = 5 // max repeat times to find accepted word
  ) extends ProductStrategy

  // default strategy is `RegisterBased`
  case class ParikhConf(
      strategy: ProductStrategy = BasicProduct(),
      lengthAbsStrategy: LengthAbstractStrategy = Parikh()
  )

  lazy val config: ConfigReader.Result[ParikhConf] = ConfigSource.default.load[ParikhConf]

  lazy val strategy = config.right.get.strategy

  lazy val lengthAbsStrategy = config.right.get.lengthAbsStrategy

  strategy match {
    case IC3Based()      => println("IC3Based")
    case BasicProduct() => println("RegisterBased")
    case SyncSubstr(minSyncLen, maxSyncLen, repeatTimes) =>
      println(s"SyncSubstr($minSyncLen, $maxSyncLen, $repeatTimes)")
  }
}
