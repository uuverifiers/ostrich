package ostrich.proofops

import org.scalacheck.Properties

object AutomaticIslandRuleSpecification
    extends Properties("AutomaticIslandRule") {

  property("witness partition is disjoint and exhaustive") = {
    val selected = Vector.tabulate(3)(index => (index, true))
    val excluded = Vector.tabulate(3)(index => (index, false))
    val cases = AutomaticIslandRule.witnessPartition(selected, excluded)
    val expected = Vector(
      Vector((0, true), (1, true), (2, true)),
      Vector((0, false)),
      Vector((0, true), (1, false)),
      Vector((0, true), (1, true), (2, false)))

    cases == expected && (0 until 8).forall { mask =>
      def value(index : Int) = (mask & (1 << index)) != 0
      cases.count(_.forall { case (index, required) =>
        value(index) == required
      }) == 1
    }
  }

  property("empty witness has one empty case") =
    AutomaticIslandRule.witnessPartition(
      Vector.empty[Int], Vector.empty[Int]) == Vector(Vector.empty)

  property("concrete replace_all uses non-overlapping matches") =
    AutomaticIslandRule.replaceAllWord(
      "aaa".map(_.toInt).toVector,
      "aa".map(_.toInt).toVector,
      "b".map(_.toInt).toVector) contains
      "ba".map(_.toInt).toVector

  property("concrete replace_all rejects the empty match") =
    AutomaticIslandRule.replaceAllWord(
      "a".map(_.toInt).toVector,
      Vector.empty,
      "b".map(_.toInt).toVector).isEmpty
}
