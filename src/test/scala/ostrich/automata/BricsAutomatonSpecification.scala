
package ostrich.automata

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop.forAll

object BricsAutomatonSpecification extends Properties("BricsAutomaton") {

  val intervalsList = for {
    len <- Gen.choose(0, 10)
    lbs <- Gen.listOfN(len, Gen.choose('a', 'z'))
    ubs <- Gen.listOfN(len, Gen.choose('a', 'z'))
  } yield (lbs zip ubs) filter { case (lb, ub) => lb <= ub }

  property("Bug in disjoint labels") = {
    val builder = new BricsAutomatonBuilder

    val qi = builder.initialState
    val qf = builder.getNewState
    builder.setAccept(qi, true)
    builder.setAccept(qf, true)
    builder.addTransition(qi, (Char.MinValue, 'A'), qi)
    builder.addTransition(qi, ('D', Char.MaxValue), qi)
    builder.addTransition(qi, ('b', 'b'), qf)
    builder.addTransition(qf, (Char.MinValue, 'B'), qf)
    builder.addTransition(qf, ('D', Char.MaxValue), qf)

    val aut = builder.getAutomaton
    val disjoint = aut.labelEnumerator.enumDisjointLabels

    disjoint == Set(
      (Char.MinValue, 'A'),
      ('B', 'B'),
      ('D', 'a'),
      ('b', 'b'),
      ('c', Char.MaxValue)
    )
  }

  property("Check random disjoint label enumeration") = forAll(intervalsList) {
    intervals => checkIntervals(intervals)
  }

  property("Buggy label enumeration from random tests") = {
    checkIntervals(List(('e', 'r'), ('q', 'r'), ('i', 'o'), ('x', 'x')))
  }

  property("2nd Buggy label enumeration from random tests") = {
    checkIntervals(List(('f', 'z'), ('n', 'r'), ('g', 'r')))
  }

  /**
   * Check disjoint label enumeration with the given list of tran lbls
   *
   * Builds and automaton with the given intervals, and checks that
   * disjoint label enumeration returns a proper list of intervals that
   * covers the same characters.
   *
   * Only pass small intervals to this method as characters get
   * enumerated during testing.
   */
  private def checkIntervals(intervals : List[(Char, Char)]) : Boolean = {
    val builder = new BricsAutomatonBuilder
    var qprev = builder.initialState
    for (lbl <- intervals) {
      val qnext = builder.getNewState
      builder.setAccept(qnext, true)
      builder.addTransition(qprev, lbl, qnext)
      qprev = qnext
    }
    val aut = builder.getAutomaton
    val disjoint = aut.labelEnumerator.enumDisjointLabels

    val charsFull = getCharsFromIntervals(intervals)
    val charsDisjoint = getCharsFromIntervals(disjoint)

    (
      // same chars
      charsFull == charsDisjoint
      // each interval is proper
      && disjoint.forall({ case (lb, ub) => lb <= ub })
      // intervals don't overlap
      && (disjoint.isEmpty || (disjoint zip disjoint.tail).forall({
        case ((_, ub), (lb, _)) => ub < lb
      }))
    )
  }

  /**
   * Get set of chars covered by the intervals
   *
   * Careful you only send small intervals, or the enumeration will be
   * large!
   */
  private def getCharsFromIntervals(
    intervals : Iterable[(Char, Char)]
  ) : Set[Char] = {
    val chars = for (
      (lb, ub) <- intervals;
      a <- lb to ub
    ) yield a

    chars.toSet
  }
}
