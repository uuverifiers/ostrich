package ostrich.automata.relations

import ostrich.automata.{BricsAutomatonBuilder, BricsTLabelOps}

import org.scalacheck.Properties

object SynchronizedHomomorphicImageSpecification
    extends Properties("SynchronizedHomomorphicImage") {

  private def word(value : String) : Vector[Int] =
    value.map(_.toInt).toVector

  private val alphabet = word("abcd")
  private val left = Tape("left", alphabet)
  private val right = Tape("right", alphabet)
  private val schema = RelationSchema(Vector(left, right))

  private def renamingRelation : SynchronizedRelation = {
    val codec = new ConvolutionCodec(schema)
    val builder = new BricsAutomatonBuilder
    builder.setAccept(builder.initialState, true)
    for (column <- Vector(
           Vector(Some('a'.toInt), Some('b'.toInt)),
           Vector(Some('c'.toInt), Some('d'.toInt))))
      builder.addTransition(
        builder.initialState,
        BricsTLabelOps.singleton(codec.encode(column)),
        builder.initialState)
    SynchronizedRelation.fromAutomaton(schema, builder.getAutomaton)
  }

  private def homomorphisms(leftExpansion : Int, rightExpansion : Int) =
    Vector(
      TapeHomomorphism(
        left, left, alphabet.map(character =>
          character -> (if (character == 'a') word("a" * leftExpansion)
                        else Vector(character))).toMap),
      TapeHomomorphism(
        right, right, alphabet.map(character =>
          character -> (if (character == 'b') word("b" * rightExpansion)
                        else Vector(character))).toMap))

  property("constructs the exact paired replace image") = {
    renamingRelation.homomorphicImage(homomorphisms(2, 2)) match {
      case Supported(image) =>
        image.accepts(Map("left" -> word("aa"), "right" -> word("bb"))) &&
        image.accepts(Map("left" -> word("c"), "right" -> word("d"))) &&
        image.accepts(Map("left" -> word("aac"),
                          "right" -> word("bbd"))) &&
        !image.accepts(Map("left" -> word("a"), "right" -> word("b")))
      case _ => false
    }
  }

  property("recovers a source witness for a concrete paired image") = {
    val maps = homomorphisms(2, 2)
    SynchronizedHomomorphicImage.preimageWitness(
      renamingRelation,
      maps,
      Map("left" -> word("aac"), "right" -> word("bbd"))) match {
      case Some(witness) =>
        witness == Map("left" -> word("ac"), "right" -> word("bd")) &&
        maps.forall(homomorphism =>
          homomorphism(witness(homomorphism.source.name)) ==
            Map("left" -> word("aac"), "right" -> word("bbd"))(
              homomorphism.target.name))
      case None => false
    }
  }

  property("reports no preimage for a tuple outside the image") =
    SynchronizedHomomorphicImage.preimageWitness(
      renamingRelation,
      homomorphisms(2, 2),
      Map("left" -> word("a"), "right" -> word("b"))).isEmpty

  property("rejects unequal productive expansion") =
    renamingRelation.homomorphicImage(
      homomorphisms(2, 1)).isInstanceOf[Unsupported]

  property("ignores an unequal transition outside every accepting run") = {
    val codec = new ConvolutionCodec(schema)
    val builder = new BricsAutomatonBuilder
    builder.setAccept(builder.initialState, true)
    builder.addTransition(
      builder.initialState,
      BricsTLabelOps.singleton(codec.encode(
        Vector(Some('a'.toInt), Some('b'.toInt)))),
      builder.initialState)
    val dead = builder.getNewState
    builder.addTransition(
      dead,
      BricsTLabelOps.singleton(codec.encode(
        Vector(Some('a'.toInt), Some('c'.toInt)))),
      dead)
    val relation = SynchronizedRelation.normalized(
      schema, builder.getAutomaton, Vector.empty)

    relation.homomorphicImage(homomorphisms(2, 2)) match {
      case Supported(image) =>
        image.accepts(Map("left" -> word("aa"), "right" -> word("bb")))
      case _ => false
    }
  }

  property("arity one is ordinary regular homomorphic image") = {
    val source = Tape("source", word("ab"))
    val target = Tape("target", word("a"))
    val relation = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(source)),
      Vector(Map[String, Seq[Int]]("source" -> word("ab"))))
    val homomorphism = TapeHomomorphism(
      source, target, Map('a'.toInt -> word("aa"), 'b'.toInt -> Vector.empty))

    relation.homomorphicImage(Vector(homomorphism)) match {
      case Supported(image) =>
        image.accepts(Map("target" -> word("aa"))) &&
        !image.accepts(Map("target" -> word("a")))
      case _ => false
    }
  }

  property("alphabet widening preserves exactly the represented tuples") = {
    val narrowLeft = Tape("left", word("ac"))
    val narrowRight = Tape("right", word("bd"))
    val narrowSchema = RelationSchema(Vector(narrowLeft, narrowRight))
    val relation = SynchronizedRelation.fromTuples(
      narrowSchema,
      Vector(Map[String, Seq[Int]](
        "left" -> word("ac"), "right" -> word("bd"))))
    val widened = relation.widenAlphabets(schema)

    widened.accepts(Map("left" -> word("ac"), "right" -> word("bd"))) &&
      !widened.accepts(Map("left" -> word("ab"), "right" -> word("bd")))
  }
}
