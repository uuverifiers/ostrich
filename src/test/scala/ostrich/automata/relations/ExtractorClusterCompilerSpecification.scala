package ostrich.automata.relations

import ostrich.automata.{BricsAutomaton, ExtractorCertificate}

import org.scalacheck.Properties

object ExtractorClusterCompilerSpecification
    extends Properties("ExtractorClusterCompiler") {

  private val outputAlphabet = Vector('a'.toInt, 'b'.toInt)
  private val sourceAlphabet = outputAlphabet :+ 'p'.toInt
  private val tapes = Vector.tabulate(3)(phase =>
    Tape("out" + phase, outputAlphabet))
  private val certificates = Vector.tabulate(3)(phase =>
    ExtractorCertificate(3, phase, 'p'.toInt))

  private def word(value : String) : Vector[Int] =
    value.map(_.toInt).toVector

  private def expected(source : String) : Map[String, Vector[Int]] = {
    val outputs = Array.fill(3)(Vector.newBuilder[Int])
    val drained = Array.fill(3)(false)
    for ((character, position) <- source.zipWithIndex) {
      val phase = position % 3
      if (!drained(phase)) {
        if (character == 'p')
          drained(phase) = true
        else
          outputs(phase) += character.toInt
      }
    }
    tapes.zip(outputs).map {
      case (tape, output) => tape.name -> output.result()
    }.toMap
  }

  private def relationFor(source : String) : SynchronizedRelation =
    ExtractorClusterCompiler.compile(
      BricsAutomaton.fromString(source),
      sourceAlphabet,
      tapes,
      certificates) match {
      case Supported(relation) => relation
      case Unsupported(reason) =>
        throw new AssertionError("unexpected unsupported cluster: " + reason)
    }

  property("matches direct extraction including partial final blocks") = {
    Vector("", "a", "ab", "aba", "apba", "bapab").forall { source =>
      val relation = relationFor(source)
      val output = expected(source)
      val problem = AutomaticIslandProblem(
        Vector(IslandSource(
          "source", BricsAutomaton.fromString(source), sourceAlphabet,
          tapes, certificates, Vector(Provenance("test", "source")))),
        tapes.map(tape => IslandUnary(
          tape, BricsAutomaton.makeAnyString(),
          Vector(Provenance("test", "unary " + tape.name)))),
        Vector.empty)
      relation.accepts(output) &&
        relation.shortestWitness.contains(output) &&
        AutomaticIslandCompiler.sourceWitnesses(problem, output) ==
          Supported(Map("source" -> word(source)))
    }
  }

  property("all-padding source blocks are hidden by epsilon transitions") = {
    val source = "pppaaa"
    val relation = relationFor(source)
    relation.accepts(expected(source)) &&
      expected(source).values.forall(_.isEmpty)
  }

  property("productive alphabets are inferred independently per lane") = {
    val source = BricsAutomaton("axb|byx")
    val alphabet = Vector('a', 'b', 'p', 'x', 'y').map(_.toInt)
    val laneAlphabets = Vector("ab", "xy", "bx").map(word)
    val laneTapes = laneAlphabets.zipWithIndex.map {
      case (letters, phase) => Tape("local" + phase, letters)
    }

    val inferred = ExtractorClusterCompiler.productiveOutputAlphabets(
      source, alphabet, certificates)
    val compiled = ExtractorClusterCompiler.compile(
      source, alphabet, laneTapes, certificates)

    inferred == Supported(laneAlphabets) && (compiled match {
      case Supported(relation) =>
        relation.accepts(Map(
          "local0" -> word("a"),
          "local1" -> word("x"),
          "local2" -> word("b"))) &&
        relation.accepts(Map(
          "local0" -> word("b"),
          "local1" -> word("y"),
          "local2" -> word("x")))
      case _ => false
    })
  }

  property("productive alphabets ignore characters after lane drain") = {
    val source = BricsAutomaton.fromString("pxbaxb")
    val alphabet = Vector('a', 'b', 'p', 'x').map(_.toInt)
    val laneTapes = Vector(
      Tape("drain0", word("a")),
      Tape("drain1", word("x")),
      Tape("drain2", word("b")))

    val inferred = ExtractorClusterCompiler.productiveOutputAlphabets(
      source, alphabet, certificates)
    val compiled = ExtractorClusterCompiler.compile(
      source, alphabet, laneTapes, certificates)

    inferred == Supported(Vector(Vector.empty, word("x"), word("b"))) &&
      (compiled match {
        case Supported(relation) => relation.accepts(Map(
          "drain0" -> word(""),
          "drain1" -> word("xx"),
          "drain2" -> word("bb")))
        case _ => false
      })
  }

  property("rejects an incomplete certificate family") = {
    ExtractorClusterCompiler.compile(
      BricsAutomaton.fromString("a"),
      sourceAlphabet,
      tapes,
      certificates.dropRight(1)).isInstanceOf[Unsupported]
  }

  property("rejects certificates paired with the wrong output lanes") = {
    ExtractorClusterCompiler.compile(
      BricsAutomaton.fromString("a"),
      sourceAlphabet,
      tapes,
      Vector(certificates(1), certificates(0), certificates(2)))
      .isInstanceOf[Unsupported]
  }

  property("pure island compiler distinguishes the third shift") = {
    val x = Vector.tabulate(3)(phase => Tape("x" + phase, outputAlphabet))
    val y = Vector.tabulate(3)(phase => Tape("y" + phase, outputAlphabet))
    val universal = BricsAutomaton.makeAnyString()
    val sources = Vector(
      IslandSource("in", BricsAutomaton.fromString("a"), sourceAlphabet,
                   x, certificates, Vector(Provenance("test", "input"))),
      IslandSource("out", BricsAutomaton.fromString("pa"), sourceAlphabet,
                   y, certificates, Vector(Provenance("test", "output"))))
    val unary = (x ++ y).map(tape =>
      IslandUnary(tape, universal,
                  Vector(Provenance("test", "unary " + tape.name))))
    val firstTwo = Vector[IslandConnector](
      IslandPrefix(x(0), y(0), word("a"), Vector(Provenance("test", "prefix"))),
      IslandSuffix(y(1), x(1), word("a"), Vector(Provenance("test", "suffix1"))))
    val third = IslandSuffix(
      y(2), x(2), word("a"), Vector(Provenance("test", "suffix2")))

    val sat = AutomaticIslandCompiler.compile(
      AutomaticIslandProblem(sources, unary, firstTwo))
    val unsat = AutomaticIslandCompiler.compile(
      AutomaticIslandProblem(sources, unary, firstTwo :+ third))

    sat match {
      case Supported(compiled) if !compiled.relation.isEmpty =>
        compiled.relation.shortestWitness.contains(Map(
          "x0" -> word("a"), "x1" -> word(""), "x2" -> word(""),
          "y0" -> word(""), "y1" -> word("a"), "y2" -> word(""))) &&
          (unsat match {
            case Supported(result) => result.relation.isEmpty
            case _                 => false
          })
      case _ => false
    }
  }

  property("shared output tapes join independent source clusters") = {
    val shared = Vector.tabulate(3)(phase =>
      Tape("shared" + phase, outputAlphabet))
    val sources = Vector(
      IslandSource("left", BricsAutomaton.fromString("a"), sourceAlphabet,
                   shared, certificates, Vector(Provenance("test", "left"))),
      IslandSource("right", BricsAutomaton.fromString("b"), sourceAlphabet,
                   shared, certificates, Vector(Provenance("test", "right"))))
    val unary = shared.map(tape =>
      IslandUnary(tape, BricsAutomaton.makeAnyString(),
                  Vector(Provenance("test", "unary " + tape.name))))

    AutomaticIslandCompiler.compile(
        AutomaticIslandProblem(sources, unary, Vector.empty)) match {
      case Supported(compiled) => compiled.relation.isEmpty
      case _                   => false
    }
  }

  property("explicit equality joins distinct output tapes") = {
    val left = Vector.tabulate(3)(phase =>
      Tape("left" + phase, outputAlphabet))
    val right = Vector.tabulate(3)(phase =>
      Tape("right" + phase, outputAlphabet))
    val sources = Vector(
      IslandSource("left", BricsAutomaton.fromString("a"), sourceAlphabet,
                   left, certificates, Vector(Provenance("test", "left"))),
      IslandSource("right", BricsAutomaton.fromString("b"), sourceAlphabet,
                   right, certificates, Vector(Provenance("test", "right"))))
    val unary = (left ++ right).map(tape =>
      IslandUnary(tape, BricsAutomaton.makeAnyString(),
                  Vector(Provenance("test", "unary " + tape.name))))
    val equality = IslandEquality(
      left.head, right.head, Vector(Provenance("test", "equality")))

    AutomaticIslandCompiler.compile(
        AutomaticIslandProblem(sources, unary, Vector(equality))) match {
      case Supported(compiled) => compiled.relation.isEmpty
      case _                   => false
    }
  }

  property("explicit disequality excludes the diagonal") = {
    val left = Vector.tabulate(3)(phase =>
      Tape("diseqLeft" + phase, outputAlphabet))
    val right = Vector.tabulate(3)(phase =>
      Tape("diseqRight" + phase, outputAlphabet))
    val unary = (left ++ right).map(tape =>
      IslandUnary(tape, BricsAutomaton.makeAnyString(),
                  Vector(Provenance("test", "unary " + tape.name))))
    val disequality = IslandDisequality(
      left.head, right.head, Vector(Provenance("test", "disequality")))

    def compile(rightSource : String) =
      AutomaticIslandCompiler.compile(AutomaticIslandProblem(
        Vector(
          IslandSource("left", BricsAutomaton.fromString("a"), sourceAlphabet,
                       left, certificates, Vector(Provenance("test", "left"))),
          IslandSource("right", BricsAutomaton.fromString(rightSource),
                       sourceAlphabet, right, certificates,
                       Vector(Provenance("test", "right")))),
        unary,
        Vector(disequality)))

    (compile("a"), compile("b")) match {
      case (Supported(equal), Supported(different)) =>
        equal.relation.isEmpty && !different.relation.isEmpty
      case _ => false
    }
  }

  property("repeated extractor output lanes impose a diagonal") = {
    val shared = Tape("shared", outputAlphabet)
    val other = Tape("other", outputAlphabet)
    val unary = Vector(shared, other).map(tape =>
      IslandUnary(tape, BricsAutomaton.makeAnyString(),
                  Vector(Provenance("test", "unary " + tape.name))))

    def compile(word : String) =
      AutomaticIslandCompiler.compile(AutomaticIslandProblem(
        Vector(IslandSource(
          "repeated", BricsAutomaton.fromString(word), sourceAlphabet,
          Vector(shared, shared, other), certificates,
          Vector(Provenance("test", "repeated output")))),
        unary,
        Vector.empty))

    (compile("ab"), compile("aa")) match {
      case (Supported(impossible), Supported(possible)) =>
        impossible.relation.isEmpty &&
          possible.relation.accepts(Map(
            "shared" -> word("a"), "other" -> word("")))
      case _ => false
    }
  }

  property("strict unary refinements reach a semantic fixed point") = {
    val output = Vector.tabulate(3)(phase =>
      Tape("projection" + phase, outputAlphabet))
    val source = IslandSource(
      "projection", BricsAutomaton.fromString("ab"), sourceAlphabet,
      output, certificates, Vector(Provenance("test", "source")))
    val unary = output.map(tape =>
      IslandUnary(tape, BricsAutomaton.makeAnyString(),
                  Vector(Provenance("test", "unary " + tape.name))))
    val problem = AutomaticIslandProblem(
      Vector(source), unary, Vector.empty)

    AutomaticIslandCompiler.compile(problem) match {
      case Supported(compiled) =>
        AutomaticIslandCompiler.unaryRefinements(
            problem, compiled.relation) match {
          case Supported(refinements) if refinements.size == 3 =>
            val byTape = refinements.map(refinement =>
              refinement.tape.name -> refinement.language).toMap
            val refinedProblem = problem.copy(unary = unary.map(constraint =>
              constraint.copy(language = byTape(constraint.tape.name))))
            AutomaticIslandCompiler.compile(refinedProblem) match {
              case Supported(refined) =>
                AutomaticIslandCompiler.unaryRefinements(
                    refinedProblem, refined.relation) == Supported(Vector.empty)
              case _ => false
            }
          case _ => false
        }
      case _ => false
    }
  }

  property("unary refinement rejects a projection outside current facts") = {
    val tape = Tape("guard", outputAlphabet)
    val problem = AutomaticIslandProblem(
      Vector(IslandSource(
        "guard", BricsAutomaton.fromString("a"), sourceAlphabet,
        Vector(tape, tape, tape), certificates,
        Vector(Provenance("test", "source")))),
      Vector(IslandUnary(
        tape, BricsAutomaton.fromString("a"),
        Vector(Provenance("test", "current language")))),
      Vector.empty)
    val escaped = SynchronizedRelation.fromTuples(
      RelationSchema(Vector(tape)),
      Vector(
        Map[String, Seq[Int]]("guard" -> word("a")),
        Map[String, Seq[Int]]("guard" -> word("b"))))

    AutomaticIslandCompiler.unaryRefinements(
      problem, escaped).isInstanceOf[Unsupported]
  }
}
