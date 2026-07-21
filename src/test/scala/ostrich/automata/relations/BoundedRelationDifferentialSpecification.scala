package ostrich.automata.relations

import org.scalacheck.Properties

object BoundedRelationDifferentialSpecification
    extends Properties("BoundedRelationDifferential") {

  private val alphabet = Vector('a'.toInt, 'b'.toInt)
  private val x = Tape("x", alphabet)
  private val y = Tape("y", alphabet)
  private val z = Tape("z", alphabet)

  private val words : Vector[Vector[Int]] =
    Vector(Vector.empty) ++
      alphabet.map(Vector(_)) ++
      (for (a <- alphabet; b <- alphabet) yield Vector(a, b))

  private def assignments(schema : RelationSchema)
      : Vector[Map[String, Seq[Int]]] = {
    def build(names : Vector[String])
        : Vector[Map[String, Seq[Int]]] = names match {
      case Vector() => Vector(Map.empty)
      case head +: tail =>
        for (word <- words; assignment <- build(tail))
        yield assignment + (head -> word)
    }
    build(schema.names)
  }

  private def agrees(relation : SynchronizedRelation)
                    (expected : Map[String, Seq[Int]] => Boolean) : Boolean =
    assignments(relation.schema).forall(assignment =>
      relation.accepts(assignment) == expected(assignment))

  property("finite relation membership agrees with tuple enumeration") = {
    val schema = RelationSchema(Vector(x, y))
    val tuples = Vector(
      Map[String, Seq[Int]]("x" -> Vector.empty, "y" -> Vector('a'.toInt)),
      Map[String, Seq[Int]]("x" -> Vector('a'.toInt, 'b'.toInt),
                            "y" -> Vector.empty))
    val relation = SynchronizedRelation.fromTuples(schema, tuples)
    agrees(relation)(tuples.contains)
  }

  property("alignment agrees with unconstrained added tapes") = {
    val base = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(x)),
      Vector(Map[String, Seq[Int]]("x" -> Vector('a'.toInt))))
    val aligned = base.align(RelationSchema(Vector(y, x)))
    agrees(aligned)(assignment => assignment("x") == Vector('a'.toInt))
  }

  property("join agrees with natural join on shared tape names") = {
    val leftTuples = Vector(
      Map[String, Seq[Int]]("x" -> Vector('a'.toInt), "y" -> Vector.empty),
      Map[String, Seq[Int]]("x" -> Vector('b'.toInt),
                            "y" -> Vector('a'.toInt)))
    val rightTuples = Vector(
      Map[String, Seq[Int]]("y" -> Vector.empty, "z" -> Vector('b'.toInt)),
      Map[String, Seq[Int]]("y" -> Vector('b'.toInt),
                            "z" -> Vector('a'.toInt)))
    val left = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(x, y)), leftTuples)
    val right = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(y, z)), rightTuples)
    val joined = left.join(right)

    agrees(joined) { assignment =>
      leftTuples.exists(leftTuple =>
        rightTuples.exists(rightTuple =>
          leftTuple("x") == assignment("x") &&
          leftTuple("y") == assignment("y") &&
          rightTuple("y") == assignment("y") &&
          rightTuple("z") == assignment("z")))
    }
  }

  property("multiway join agrees with a three-component natural join") = {
    val onlyA = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(x)),
      Vector(Map[String, Seq[Int]]("x" -> Vector('a'.toInt))))
    val equalXY = RelationConstructors.equality(x, y)
    val equalYZ = RelationConstructors.equality(y, z)
    val joined = SynchronizedRelation.joinAll(
      Vector(onlyA, equalXY, equalYZ))

    agrees(joined)(assignment =>
      assignment("x") == Vector('a'.toInt) &&
      assignment("x") == assignment("y") &&
      assignment("y") == assignment("z"))
  }

  property("projection agrees with existential tuple elimination") = {
    val tuples = Vector(
      Map[String, Seq[Int]]("x" -> Vector.empty,
                            "y" -> Vector('a'.toInt, 'b'.toInt)),
      Map[String, Seq[Int]]("x" -> Vector('a'.toInt),
                            "y" -> Vector.empty))
    val relation = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(x, y)), tuples).project(Vector("x"))
    agrees(relation)(assignment =>
      tuples.exists(tuple => tuple("x") == assignment("x")))
  }

  property("union, complement, and rename agree with set operations") = {
    val schema = RelationSchema(Vector(x))
    val onlyA = SynchronizedRelation.fromTuples(
      schema, Vector(Map[String, Seq[Int]]("x" -> Vector('a'.toInt))))
    val onlyB = SynchronizedRelation.fromTuples(
      schema, Vector(Map[String, Seq[Int]]("x" -> Vector('b'.toInt))))
    val relation = onlyA.union(onlyB).complement.rename(Map("x" -> "word"))
    agrees(relation)(assignment =>
      assignment("word") != Vector('a'.toInt) &&
      assignment("word") != Vector('b'.toInt))
  }
}
