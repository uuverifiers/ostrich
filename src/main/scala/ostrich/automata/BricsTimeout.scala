package ostrich.automata

import ap.util.Timeout
import dk.brics.automaton.AutomatonTimeoutException
import dk.brics.automaton.AutomatonTimeouts
import dk.brics.automaton.{Automaton => BAutomaton}

object BricsTimeout {

  private val globalChecker = new Runnable {
    override def run(): Unit = Timeout.check
  }

  def install(): Unit =
    AutomatonTimeouts.setExternalChecker(globalChecker)

  private def pushDeadline(timeoutMillis: Int): (Option[Long], Boolean) = {
    install()

    if (timeoutMillis <= 0) {
      (None, false)
    } else {
      val previousDeadline: Option[Long] =
        Option(AutomatonTimeouts.getDeadlineNanos)
          .map((deadline: java.lang.Long) => deadline.longValue)
      val nextDeadline = System.nanoTime + timeoutMillis.toLong * 1000000L
      val effectiveDeadline: Long = previousDeadline match {
        case Some(deadline) => math.min(deadline, nextDeadline)
        case None => nextDeadline
      }
      val introducedDeadline = previousDeadline.forall(_ > effectiveDeadline)

      AutomatonTimeouts.setDeadlineNanos(Long.box(effectiveDeadline))
      (previousDeadline, introducedDeadline)
    }
  }

  private def popDeadline(previousDeadline: Option[Long], timeoutMillis: Int): Unit =
    if (timeoutMillis > 0) {
      previousDeadline match {
        case Some(deadline) =>
          AutomatonTimeouts.setDeadlineNanos(Long.box(deadline))
        case None =>
          AutomatonTimeouts.clearDeadline()
      }
    }

  def withRecoverableTimeout[T](timeoutMillis: Int)(body: => T): Option[T] =
    {
      val (previousDeadline, introducedDeadline) = pushDeadline(timeoutMillis)
      try {
        Some(body)
      } catch {
        case _: AutomatonTimeoutException if introducedDeadline =>
          None
      } finally {
        popDeadline(previousDeadline, timeoutMillis)
      }
    }

  def check(location: String = "scala"): Unit = {
    install()
    AutomatonTimeouts.check(location)
  }

  def safeMinimize(aut: BAutomaton, timeoutMillis: Int): BAutomaton =
    withRecoverableTimeout(timeoutMillis) {
      val minimized = aut.clone()
      minimized.minimize()
      minimized
    }.getOrElse(aut)

  install()
}