package ostrich.proofops

import ap.parser.IExpression
import org.scalacheck.Properties
import ostrich.automata.relations.Tape

object AutomaticIslandHomomorphismDetectorSpecification
    extends Properties("AutomaticIslandHomomorphismDetector")
       with TestProverUtils {

  import AutomaticIslandDetector.BoundaryTerm
  import IExpression._
  import prover._
  import theory._

  private val left0 = createConstant("left0", StringSort)
  private val right0 = createConstant("right0", StringSort)
  private val left1 = createConstant("left1", StringSort)
  private val right1 = createConstant("right1", StringSort)

  private val paired =
    (left1 === str_replaceall(left0, "a", "aa")) &
    (right1 === str_replaceall(right0, "b", "bb"))
  private val goal = createGoalFor(paired)
  private val calls = goal.facts.predConj
    .positiveLitsWithPred(_str_replaceall).toVector
  private val leftCall = calls.find(atom =>
    strDatabase.term2List(atom(1)).contains("a".map(_.toInt))).get
  private val rightCall = calls.find(atom =>
    strDatabase.term2List(atom(1)).contains("b".map(_.toInt))).get
  private val boundary = Vector(
    BoundaryTerm(Tape("left", "ac".map(_.toInt).toVector), leftCall(0)),
    BoundaryTerm(Tape("right", "bd".map(_.toInt).toVector), rightCall(0)))
  private val detector = new AutomaticIslandDetector(theory)
  private val layers = detector.homomorphicLayers(boundary, goal)

  private val incompleteGoal = createGoalFor(
    left1 === str_replaceall(left0, "a", "aa"))
  private val incomplete = detector.homomorphicLayers(
    boundary, incompleteGoal)

  private val disequalityGoal = createGoalFor(left0 =/= right0)
  private val disequalityConnectors = detector.boundaryConnectors(
    boundary, disequalityGoal)

  private val stagedGoal = createGoalFor(
    (right1 === str_replaceall(right0, "b", "a")) &
    (left1 === str_replaceall(right1, "d", "c")) &
    (left0 =/= left1))
  private val stagedCalls = stagedGoal.facts.predConj
    .positiveLitsWithPred(_str_replaceall).toVector
  private val stagedBoundary = Vector(
    BoundaryTerm(Tape("left", "ac".map(_.toInt).toVector),
                 makeInternal(left0).asInstanceOf[ap.terfor.Term]
                   .asInstanceOf[ap.terfor.linearcombination.LinearCombination]),
    BoundaryTerm(Tape("right", "bd".map(_.toInt).toVector),
                 makeInternal(right0).asInstanceOf[ap.terfor.Term]
                   .asInstanceOf[ap.terfor.linearcombination.LinearCombination]))
  private val firstDecode = detector.homomorphicLayers(
    stagedBoundary, stagedGoal)
  private val secondDecode = firstDecode.flatMap(layer =>
    detector.homomorphicLayers(layer.target, stagedGoal))
  private val decodedConnectors = secondDecode.flatMap(layer =>
    detector.boundaryConnectors(layer.target, stagedGoal))

  private val tail = createConstant("tail", StringSort)
  private val prefixedGoal = createGoalFor(
    _str_++(strDatabase.str2Id("b"), tail, left0))
  private val prefixedBoundary = Vector(BoundaryTerm(
    Tape("prefixed", "abc".map(_.toInt).toVector),
    makeInternal(left0).asInstanceOf[ap.terfor.Term]
      .asInstanceOf[ap.terfor.linearcombination.LinearCombination]))
  private val prefixedConnectors = detector.boundaryConnectors(
    prefixedBoundary, prefixedGoal)

  shutdown

  property("detects one complete paired constant layer") =
    layers.size == 1 &&
    layers.head.target.map(_.term) == Vector(leftCall(3), rightCall(3)) &&
    layers.head.homomorphisms(0).images('a'.toInt) ==
      "aa".map(_.toInt).toVector &&
    layers.head.homomorphisms(1).images('b'.toInt) ==
      "bb".map(_.toInt).toVector

  property("uses an exact identity for an untouched tape") =
    incomplete.size == 1 &&
    incomplete.head.target.map(_.term) ==
      Vector(leftCall(3), boundary(1).term) &&
    incomplete.head.homomorphisms(0).images('a'.toInt) ==
      "aa".map(_.toInt).toVector &&
    incomplete.head.homomorphisms(1).images('b'.toInt) ==
      Vector('b'.toInt) &&
    incomplete.head.assumptions.size == 1

  property("compiles a goal disequality over the current boundary") =
    disequalityConnectors.size == 1 &&
    disequalityConnectors.head.relation.accepts(Map(
      "left" -> "a".map(_.toInt),
      "right" -> "b".map(_.toInt))) &&
    !disequalityConnectors.head.relation.accepts(Map(
      "left" -> "a".map(_.toInt),
      "right" -> "a".map(_.toInt))) &&
    disequalityConnectors.head.assumptions.size == 1

  property("detects the first staged one-sided letter map") =
    firstDecode.size == 1

  property("normalizes two nested replacements into two calls") =
    stagedCalls.size == 2

  property("detects the second staged one-sided letter map") =
    secondDecode.size == 1

  property("finds a connector after staged one-sided letter maps") =
    decodedConnectors.size == 1

  property("projects a fixed prefix with a hidden tail") =
    prefixedConnectors.size == 1 &&
    prefixedConnectors.head.relation.schema.arity == 1 &&
    prefixedConnectors.head.relation.accepts(Map(
      "prefixed" -> "ba".map(_.toInt))) &&
    !prefixedConnectors.head.relation.accepts(Map(
      "prefixed" -> "a".map(_.toInt)))
}
