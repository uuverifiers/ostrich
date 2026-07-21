package ostrich.automata.relations

import ostrich.automata.{BricsAutomaton, BricsAutomatonBuilder,
                        BricsTLabelOps}

import org.scalacheck.Prop._
import org.scalacheck.Properties

object SynchronizedRelationSpecification
    extends Properties("SynchronizedRelation") {

  private val alphabet = Vector('a'.toInt, 'b'.toInt)
  private val x = Tape("x", alphabet)
  private val y = Tape("y", alphabet)
  private val z = Tape("z", alphabet)

  private def word(value : String) : Vector[Int] =
    value.map(_.toInt).toVector

  property("convolution round trip preserves empty and unequal tapes") = {
    val codec = new ConvolutionCodec(RelationSchema(Vector(x, y, z)))
    val values = Map("x" -> word("ab"), "y" -> word(""), "z" -> word("a"))
    codec.decodeWord(codec.convolve(values)) == values
  }

  property("convolution decoder rejects characters after padding") = {
    val codec = new ConvolutionCodec(RelationSchema(Vector(x, y)))
    val malformed = Vector(
      codec.encode(Vector(None, Some('a'.toInt))).toInt,
      codec.encode(Vector(Some('a'.toInt), None)).toInt)
    throws(classOf[IllegalArgumentException]) {
      codec.decodeWord(malformed)
    }
  }

  property("normalisation rejects malformed padded automata") = {
    val schema = RelationSchema(Vector(x, y))
    val codec = new ConvolutionCodec(schema)
    val malformed = Seq(
      codec.encode(Vector(None, Some('a'.toInt))),
      codec.encode(Vector(Some('a'.toInt), None))).mkString
    SynchronizedRelation.fromAutomaton(
      schema, BricsAutomaton.fromString(malformed)).isEmpty
  }

  property("unary lift preserves its language") = {
    val relation = RelationConstructors.unary(
      x, BricsAutomaton.fromString("ab"))
    relation.accepts(Map("x" -> word("ab"))) &&
      !relation.accepts(Map("x" -> word("a")))
  }

  property("fixed prefix and suffix include empty boundary cases") = {
    val prefix = RelationConstructors.fixedPrefix(x, y, word("a"))
    val suffix = RelationConstructors.fixedSuffix(x, y, word("a"))
    prefix.accepts(Map("x" -> word("ab"), "y" -> word("b"))) &&
      prefix.accepts(Map("x" -> word("a"), "y" -> word(""))) &&
      !prefix.accepts(Map("x" -> word("aa"), "y" -> word("b"))) &&
      suffix.accepts(Map("x" -> word("ba"), "y" -> word("b"))) &&
      suffix.accepts(Map("x" -> word("a"), "y" -> word(""))) &&
      !suffix.accepts(Map("x" -> word("ab"), "y" -> word("b")))
  }

  property("join aligns shared tapes and projection eliminates them") = {
    val prefix = RelationConstructors.fixedPrefix(x, y, word("a"))
    val suffix = RelationConstructors.fixedSuffix(y, z, word("b"))
    val joined = prefix.join(suffix)
    val projected = joined.project(Vector("x", "z"))
    joined.schema.names == Vector("x", "y", "z") &&
      joined.accepts(Map("x" -> word("aab"),
                         "y" -> word("ab"),
                         "z" -> word("a"))) &&
      projected.accepts(Map("x" -> word("aab"), "z" -> word("a"))) &&
      !projected.accepts(Map("x" -> word("aa"), "z" -> word("a")))
  }

  property("unary projection decodes convolution symbols") = {
    val relation = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(x, y)),
      Vector(
        Map[String, Seq[Int]]("x" -> word(""), "y" -> word("b")),
        Map[String, Seq[Int]]("x" -> word("ab"), "y" -> word(""))))
    val projection = relation.unaryProjection("x")

    projection(word("")) && projection(word("ab")) &&
      !projection(word("a")) && !projection(Vector(0, 1))
  }

  property("complement is relative to well-formed convolutions") = {
    val unequal = RelationConstructors.equality(x, y).complement
    unequal.accepts(Map("x" -> word("a"), "y" -> word("b"))) &&
      !unequal.accepts(Map("x" -> word("ab"), "y" -> word("ab")))
  }

  property("renaming preserves the encoded relation") = {
    val relation = RelationConstructors.equality(x, y)
      .rename(Map("x" -> "left", "y" -> "right"))
    relation.accepts(Map("left" -> word("ab"), "right" -> word("ab")))
  }

  property("provenance is deduplicated through joins") = {
    val source = Provenance("test", "same fact")
    val left = RelationConstructors.fixedPrefix(x, y, Vector.empty, Vector(source))
    val right = RelationConstructors.fixedSuffix(y, z, Vector.empty, Vector(source))
    left.join(right).provenance == Vector(source)
  }

  property("shared tape alphabet conflicts are rejected") = {
    val incompatible = Tape("x", Vector('a'.toInt))
    throws(classOf[IllegalArgumentException]) {
      RelationSchema(Vector(x)).merge(RelationSchema(Vector(incompatible)))
    }
  }

  private def correlatedPrefixFixture = {
    val relationAlphabet = word("abc")
    val input = Tape("input", relationAlphabet)
    val output = Tape("output", relationAlphabet)
    val schema = RelationSchema(Vector(input, output))
    val codec = new ConvolutionCodec(schema)
    val builder = new BricsAutomatonBuilder
    builder.setAccept(builder.initialState, true)
    for (column <- Vector(
           Vector(Some('a'.toInt), Some('a'.toInt)),
           Vector(Some('b'.toInt), Some('a'.toInt)),
           Vector(Some('c'.toInt), Some('c'.toInt))))
      builder.addTransition(
        builder.initialState,
        BricsTLabelOps.singleton(codec.encode(column)),
        builder.initialState)
    val normalizer = SynchronizedRelation.fromAutomaton(
      schema, builder.getAutomaton)

    val inputStartsB = RelationConstructors.fixedPrefix(
      input, Tape("input-tail", relationAlphabet), word("b"))
      .project(Vector("input"))
    val outputStartsC = RelationConstructors.fixedPrefix(
      output, Tape("output-tail", relationAlphabet), word("c"))
      .project(Vector("output"))

    (normalizer, inputStartsB, outputStartsC)
  }

  property("a correlated input-prefix constraint is individually compatible") = {
    val (normalizer, inputStartsB, _) = correlatedPrefixFixture
    !normalizer.join(inputStartsB).isEmpty
  }

  property("a correlated output-prefix constraint is individually compatible") = {
    val (normalizer, _, outputStartsC) = correlatedPrefixFixture
    !normalizer.join(outputStartsC).isEmpty
  }

  property("join aligns a unary language on the second tape") = {
    val (normalizer, _, _) = correlatedPrefixFixture
    val output = normalizer.schema.tape("output")
    val exactC = RelationConstructors.unary(
      output, BricsAutomaton.fromString("c"))
    normalizer.join(exactC).accepts(Map(
      "input" -> word("c"), "output" -> word("c")))
  }

  property("the correlated normalizer fixture accepts its generators") = {
    val (normalizer, inputStartsB, outputStartsC) = correlatedPrefixFixture
    normalizer.accepts(Map("input" -> word("b"), "output" -> word("a"))) &&
    normalizer.accepts(Map("input" -> word("c"), "output" -> word("c"))) &&
    inputStartsB.accepts(Map("input" -> word("b"))) &&
    outputStartsC.accepts(Map("output" -> word("c")))
  }

  property("correlated prefix constraints are accumulated before emptiness") = {
    val (normalizer, inputStartsB, outputStartsC) = correlatedPrefixFixture
    normalizer.join(inputStartsB).join(outputStartsC).isEmpty
  }

  property("multiway join accumulates nondeterministic prefix projections") = {
    val (normalizer, inputStartsB, outputStartsC) = correlatedPrefixFixture
    !SynchronizedRelation.joinAll(
      Vector(normalizer, inputStartsB)).isEmpty &&
    SynchronizedRelation.joinAll(
      Vector(normalizer, inputStartsB, outputStartsC)).isEmpty
  }

  property("joining prefix constraints preserves the source relation") = {
    val (normalizer, inputStartsB, outputStartsC) = correlatedPrefixFixture
    val inputCompatible = !normalizer.join(inputStartsB).isEmpty
    val outputCompatible = !normalizer.join(outputStartsC).isEmpty
    val jointlyIncompatible =
      normalizer.join(inputStartsB).join(outputStartsC).isEmpty
    inputCompatible && outputCompatible && jointlyIncompatible
  }
}
