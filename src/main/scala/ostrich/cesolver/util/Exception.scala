package ostrich.cesolver.util

case class UnknownException(val info: String) extends Exception

case class TimeoutException(val time: Long) extends Exception
