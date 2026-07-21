/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.proofops

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.proof.theoryPlugins.Plugin
import ap.terfor.Formula
import ap.terfor.RichPredicate
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.util.LRUCache
import ostrich.OstrichStringTheory
import ostrich.automata.{AutomataUtils, BricsAutomaton}
import ostrich.automata.relations.{AutomaticIslandCompiler,
                                  AutomaticIslandProblem,
                                  CompiledAutomaticIsland, ExactResult,
                                  Provenance, RelationMetrics, RelationSchema,
                                  Supported, SynchronizedHomomorphicImage,
                                  SynchronizedRelation, Tape,
                                  UnaryRefinement, Unsupported}

import scala.collection.mutable.{ArrayBuffer, HashMap => MHashMap,
                                 HashSet => MHashSet, Queue}

object AutomaticIslandRule {

  private val MaxWitnessTapes = 8
  private val MaxRelationalDepth = 16
  private val MaxRelationalFacts = 64

  private[proofops] def replaceAllWord(
      input : Vector[Int],
      matched : Vector[Int],
      replacement : Vector[Int]) : Option[Vector[Int]] = {
    if (matched.isEmpty)
      return None

    val result = Vector.newBuilder[Int]
    var index = 0
    while (index < input.size) {
      val matches =
        index + matched.size <= input.size &&
        input.slice(index, index + matched.size) == matched
      if (matches) {
        result ++= replacement
        index += matched.size
      } else {
        result += input(index)
        index += 1
      }
    }
    Some(result.result())
  }

  /** Partition tuples into the selected tuple and their first difference. */
  private[proofops] def witnessPartition[A](selected : Vector[A],
                                             excluded : Vector[A])
      : Vector[Vector[A]] = {
    require(selected.size == excluded.size)
    Vector(selected) ++ excluded.indices.map { index =>
      selected.take(index) :+ excluded(index)
    }
  }
}

/** Experimental exact proof rule for a certified automatic-relation island. */
class AutomaticIslandRule(theory : OstrichStringTheory) {
  import AutomaticIslandDetector._
  import AutomaticIslandRule._

  private val detector = new AutomaticIslandDetector(theory)
  private val logged = MHashSet[String]()
  private case class EvaluatedIsland(compiled : CompiledAutomaticIsland,
                                     refinements : Vector[UnaryRefinement],
                                     witness : Option[Map[String, Vector[Int]]],
                                     sourceWitnesses :
                                       Option[Map[String, Vector[Int]]])
  private case class WitnessSplit(branches : Vector[Conjunction],
                                  tapes : Int,
                                  branchCount : Int,
                                  key : String)
  private case class AvailableIsland(detected : DetectedIsland,
                                     evaluated : EvaluatedIsland,
                                     wasCached : Boolean)
  private case class HomomorphicStep(
      source : SynchronizedRelation,
      layer : DetectedHomomorphicLayer)
  private case class RelationalFact(
      relation : SynchronizedRelation,
      boundary : Vector[BoundaryTerm],
      assumptions : Vector[Formula],
      seedKey : String,
      pathKey : String,
      depth : Int,
      steps : Vector[HomomorphicStep])
  private val evaluationCache =
    new LRUCache[String, ExactResult[EvaluatedIsland]](8)
  private val imageCache =
    new LRUCache[String, ExactResult[SynchronizedRelation]](32)

  def handleGoal(goal : Goal) : Seq[Plugin.Action] =
    handleGoal(goal, allowWitnessSearch = false)

  def handleFinalGoal(goal : Goal) : Seq[Plugin.Action] =
    handleGoal(goal, allowWitnessSearch = true)

  private def handleGoal(
      goal : Goal,
      allowWitnessSearch : Boolean) : Seq[Plugin.Action] = {
    if (!theory.theoryFlags.automaticIslands)
      return Seq.empty

    val propagationActions = new ArrayBuffer[Plugin.Action]
    val available = new ArrayBuffer[AvailableIsland]
    for (detection <- detector.detect(goal)) detection match {
      case RejectedIsland(reason, _) =>
        if (firstLog("rejected\n" + reason))
          log("candidate is outside the exact internal fragment: " + reason)

      case detected : DetectedIsland =>
        val cached = evaluationCache.get(detected.structuralKey)
        val start = System.nanoTime
        val evaluation = cached.getOrElse {
          val tapeCount = detected.problem.sources
            .flatMap(_.outputs).map(_.name).distinct.size
          log("compiling a certified " + tapeCount +
              "-tape island internally")
          val result = evaluate(detected.problem)
          evaluationCache += (detected.structuralKey -> result)
          result
        }
        evaluation match {
          case Unsupported(reason) =>
            if (firstLog("unsupported\n" + detected.structuralKey))
              log("internal compiler rejected the island: " + reason)

          case Supported(evaluated @ EvaluatedIsland(compiled, _, _, _)) =>
            if (cached.isEmpty) {
              val elapsedMs = (System.nanoTime - start) / 1000000L
              val finalMetrics = compiled.joins.last
              log("final relation " + render(finalMetrics) +
                  " in " + elapsedMs + "ms")
            }
            if (compiled.relation.isEmpty) {
              log("exact relation is empty; closing from " +
                  detected.assumptions.size + " proof facts")
              return Seq(Plugin.CloseByAxiom(detected.assumptions, theory))
            } else {
              available += AvailableIsland(
                detected, evaluated, cached.isDefined)
            }
        }
    }

    // Feed exact unary consequences back into the ordinary OSTRICH
    // saturation rules before committing to a concrete relational witness.
    // unaryRefinements only returns strict consequences, so this reaches a
    // fixed point instead of re-adding the same language indefinitely.
    for (island <- available;
         refinements = nativePropagationRefinements(island, goal);
         if refinements.nonEmpty) {
      val actions = unaryPropagation(
        island.detected, refinements, goal)
      log("relation implies " + actions.size +
          " strict unary projection" +
          (if (actions.size == 1) "" else "s") +
          "; propagating before relational witness search")
      propagationActions ++= actions
    }
    if (propagationActions.nonEmpty)
      return propagationActions.toVector

    relationalClosure(
      available.toVector, goal, allowWitnessSearch) match {
      case Some(action) => return Vector(action)
      case None         =>
    }

    var pendingSplit : Option[WitnessSplit] = None
    for (island <- available) {
      val detected = island.detected
      val EvaluatedIsland(_, _, witness, sourceWitnesses) =
        island.evaluated
      val split =
        if (allowWitnessSearch && pendingSplit.isEmpty)
          for (output <- witness;
               sources <- sourceWitnesses;
               split <- witnessSplit(detected, output, sources, goal))
          yield split
        else
          None
      if (split.isDefined) {
        pendingSplit = split
      } else if (allowWitnessSearch && pendingSplit.isEmpty &&
                 !island.wasCached) {
        if (allBoundaryLanguagesSingleton(detected))
          log("relation is nonempty and all public tapes are " +
              "singleton; handing model recovery back to OSTRICH")
        else
          log("relation is nonempty with no strict unary refinement; " +
              "the witness tuple is too wide to split")
      }
    }
    pendingSplit match {
      case Some(split) =>
        if (firstLog("witness\n" + split.key))
          log("trying an exact relational witness on " + split.tapes +
              " tapes in an exhaustive " + split.branchCount +
              "-branch split")
        Vector(Plugin.AxiomSplit(
          List(),
          split.branches.map(branch =>
            (branch, List[Plugin.Action]())),
          theory))
      case None =>
        Vector.empty
    }
  }

  /** Keep only projections that can unlock ordinary function propagation. */
  private def nativePropagationRefinements(
      island : AvailableIsland,
      goal : Goal) : Vector[UnaryRefinement] = {
    val boundary = island.detected.boundary
    val activeTapes = detector.homomorphicLayers(boundary, goal)
      .iterator.flatMap { layer =>
        boundary.iterator.zip(layer.target.iterator).collect {
          case (source, target) if source.term != target.term =>
            source.tape.name
        }
      }.toSet
    island.evaluated.refinements.filter(refinement =>
      activeTapes contains refinement.tape.name)
  }

  /** Carry exact relational facts through complete homomorphic layers. */
  private def relationalClosure(
      islands : Vector[AvailableIsland],
      goal : Goal,
      allowWitnessSearch : Boolean) : Option[Plugin.Action] = {
    if (islands.isEmpty)
      return None

    val queue = Queue[RelationalFact]()
    val islandsByKey = islands.map(island =>
      island.detected.structuralKey -> island).toMap
    for (island <- islands)
      queue.enqueue(RelationalFact(
        island.evaluated.compiled.relation,
        island.detected.boundary,
        island.detected.assumptions,
        island.detected.structuralKey,
        island.detected.structuralKey,
        0,
        Vector.empty))
    val visited = MHashSet[String]() ++ queue.map(_.pathKey)
    var pendingWitness : Option[WitnessSplit] = None

    var processed = 0
    while (queue.nonEmpty && processed < MaxRelationalFacts) {
      val fact = queue.dequeue()
      processed += 1
      var constrainedFact = fact
      val connectors = detector.boundaryConnectors(fact.boundary, goal)
      for (connector <- connectors) {
        val joined = joinBoundaryConnector(constrainedFact, connector)
        val assumptions =
          (constrainedFact.assumptions ++ connector.assumptions).distinct
        val pathKey = constrainedFact.pathKey +
          "\n-- goal connector --\n" + connector.structuralKey
        if (joined.isEmpty) {
          log("derived relational fact is disjoint from a goal connector; " +
              "closing from " + assumptions.size + " proof facts")
          return Some(Plugin.CloseByAxiom(assumptions, theory))
        } else {
          constrainedFact = constrainedFact.copy(
            relation = joined,
            assumptions = assumptions,
            pathKey = pathKey)
        }
      }
      if (allowWitnessSearch && connectors.nonEmpty &&
          pendingWitness.isEmpty)
        pendingWitness = for {
          witness <- constrainedFact.relation.shortestWitness
          split <- relationalWitnessSplit(
            constrainedFact,
            witness,
            islandsByKey(constrainedFact.seedKey),
            constrainedFact.pathKey,
            goal)
        } yield split
      for (island <- islands;
           if !(constrainedFact.depth == 0 &&
                constrainedFact.seedKey == island.detected.structuralKey);
           joined <- joinOnBoundary(constrainedFact, island).toVector) {
        if (joined.isEmpty) {
          val assumptions =
            (constrainedFact.assumptions ++ island.detected.assumptions).distinct
          log("derived relational fact is disjoint from an endpoint island; " +
              "closing from " + assumptions.size + " proof facts")
          return Some(Plugin.CloseByAxiom(assumptions, theory))
        } else if (allowWitnessSearch && pendingWitness.isEmpty) {
          pendingWitness = for (witness <- joined.shortestWitness;
                                split <- relationalWitnessSplit(
                                  constrainedFact,
                                  witness,
                                  islandsByKey(constrainedFact.seedKey),
                                  constrainedFact.pathKey +
                                    "\n-- endpoint island --\n" +
                                    island.detected.structuralKey,
                                  goal))
                           yield split
        }
      }

      if (constrainedFact.depth < MaxRelationalDepth)
        for (layer <- detector.homomorphicLayers(
               constrainedFact.boundary, goal)) {
          val key = constrainedFact.pathKey +
                    "\n-- homomorphic layer --\n" +
                    layer.structuralKey
          if (visited.size < MaxRelationalFacts && visited.add(key)) {
            val cached = imageCache.get(key)
            val result = cached.getOrElse {
              val provenance = layer.assumptions.map(assumption =>
                Provenance("OSTRICH replace_all fact", assumption.toString))
              val image = constrainedFact.relation.homomorphicImage(
                layer.homomorphisms, provenance)
              imageCache += (key -> image)
              image
            }
            result match {
              case Unsupported(reason) =>
                if (firstLog("homomorphic-image\n" + key + "\n" + reason))
                  log("relational image rejected: " + reason)
                if (allowWitnessSearch && pendingWitness.isEmpty)
                  pendingWitness = for {
                    witness <- constrainedFact.relation.shortestWitness
                    split <- concreteForwardWitnessSplit(
                      constrainedFact,
                      witness,
                      islandsByKey(constrainedFact.seedKey),
                      key + "\n-- concrete functional closure --",
                      goal)
                  } yield split
              case Supported(image) =>
                if (cached.isEmpty)
                  log("propagated a " + image.schema.arity +
                      "-tape relation through " +
                      layer.assumptions.size +
                      " synchronized replace_all applications to " +
                      render(RelationMetrics(
                        "homomorphic image",
                        image.stateCount,
                        image.transitionCount)))
                queue.enqueue(RelationalFact(
                  image,
                  layer.target,
                  (constrainedFact.assumptions ++ layer.assumptions).distinct,
                  constrainedFact.seedKey,
                  key,
                  constrainedFact.depth + 1,
                  constrainedFact.steps :+ HomomorphicStep(
                    constrainedFact.relation, layer)))
            }
          }
        }
    }
    pendingWitness.map { split =>
      if (firstLog("relational-counterexample\n" + split.key))
        log("trying an exact relational counterexample on " +
            split.tapes + " boundary tapes in an exhaustive " +
            split.branchCount + "-branch split")
      Plugin.AxiomSplit(
        List(),
        split.branches.map(branch =>
          (branch, List[Plugin.Action]())),
        theory)
    }
  }

  /** Intersect a fact with a relation over a subset of its boundary tapes. */
  private def joinBoundaryConnector(
      fact : RelationalFact,
      connector : DetectedBoundaryConnector) : SynchronizedRelation = {
    val connectorAlphabets = connector.relation.schema.tapes.map(tape =>
      tape.name -> tape.alphabet).toMap
    val targetSchema = RelationSchema(fact.relation.schema.tapes.map { tape =>
      connectorAlphabets.get(tape.name) match {
        case Some(alphabet) => Tape(tape.name, alphabet)
        case None           => tape
      }
    })
    fact.relation.widenAlphabets(targetSchema).join(connector.relation)
  }

  /** Join two facts after aligning tape names by their represented terms. */
  private def joinOnBoundary(
      fact : RelationalFact,
      island : AvailableIsland) : Option[SynchronizedRelation] = {
    val factByTerm = fact.boundary.map(item => item.term -> item.tape).toMap
    val targetBoundary = island.detected.boundary
    if (factByTerm.keySet != targetBoundary.map(_.term).toSet)
      return None

    val rename = targetBoundary.map(item =>
      item.tape.name -> factByTerm(item.term).name).toMap
    val target = island.evaluated.compiled.relation.rename(rename)
    if (fact.relation.schema.names.toSet != target.schema.names.toSet)
      return None

    val alphabets = (fact.relation.schema.tapes ++ target.schema.tapes)
      .groupBy(_.name).map { case (name, tapes) =>
        name -> tapes.iterator.flatMap(_.alphabet).toSet.toVector.sorted
      }
    def widen(relation : SynchronizedRelation) =
      relation.widenAlphabets(RelationSchema(
        relation.schema.tapes.map(tape =>
          Tape(tape.name, alphabets(tape.name)))))

    Some(widen(fact.relation).join(widen(target)))
  }

  private def evaluate(problem : AutomaticIslandProblem)
      : ExactResult[EvaluatedIsland] =
    AutomaticIslandCompiler.compile(problem) match {
      case unsupported : Unsupported => unsupported
      case Supported(compiled) if compiled.relation.isEmpty =>
        Supported(EvaluatedIsland(
          compiled, Vector.empty, None, None))
      case Supported(compiled) =>
        compiled.relation.shortestWitness match {
          case None =>
            Unsupported("a nonempty island has no decodable witness")
          case witness @ Some(output) =>
            (AutomaticIslandCompiler.unaryRefinements(
               problem, compiled.relation),
             AutomaticIslandCompiler.sourceWitnesses(problem, output)) match {
              case (unsupported : Unsupported, _) => unsupported
              case (_, unsupported : Unsupported) => unsupported
              case (Supported(refinements), Supported(sources)) =>
                Supported(EvaluatedIsland(
                  compiled, refinements, witness, Some(sources)))
            }
        }
    }

  private def unaryPropagation(
      detected : DetectedIsland,
      refinements : Vector[UnaryRefinement],
      goal : Goal) : Vector[Plugin.Action] = {
    val strInRe = new RichPredicate(theory.str_in_re_id, goal.order)
    val terms = detected.boundary.map(boundary =>
      boundary.tape.name -> boundary.term).toMap
    refinements.map { refinement =>
      val id = theory.autDatabase.automaton2Id(refinement.language)
      val atom = strInRe(Seq(
        terms(refinement.tape.name), LinearCombination(IdealInt(id))))
      Plugin.AddAxiom(
        detected.assumptions,
        Conjunction.conj(atom, goal.order),
        theory)
    }
  }

  private def witnessSplit(
      detected : DetectedIsland,
      witness : Map[String, Vector[Int]],
      sourceWitnesses : Map[String, Vector[Int]],
      goal : Goal) : Option[WitnessSplit] = {
    import ap.terfor.TerForConvenience._
    implicit val order = goal.order

    val currentLanguages = detected.problem.unary.map(constraint =>
      constraint.tape.name -> constraint.language).toMap
    val outputChoices = detected.boundary.flatMap { boundary =>
      val value = witness(boundary.tape.name)
      AutomataUtils.isSingleton(currentLanguages(boundary.tape.name)) match {
        case Some(current) =>
          require(current == value,
                  "an island witness escaped a singleton boundary language")
          None
        case None =>
          Some((boundary.term, value))
      }
    }
    val sourceLanguages = detected.problem.sources.map(source =>
      source.name -> source.language).toMap
    val sourceChoices = detected.sources.flatMap { source =>
      val value = sourceWitnesses(source.name)
      AutomataUtils.isSingleton(sourceLanguages(source.name)) match {
        case Some(current) =>
          require(current == value,
                  "an island source witness escaped its source language")
          None
        case None =>
          Some((source.term, value))
      }
    }
    makeWitnessSplit(
      outputChoices ++ sourceChoices, detected.structuralKey, goal)
  }

  /** Pull a joined counterexample back to its seed and hidden source words. */
  private def relationalWitnessSplit(
      fact : RelationalFact,
      witness : Map[String, Vector[Int]],
      seed : AvailableIsland,
      key : String,
      goal : Goal) : Option[WitnessSplit] = {
    val finalChoices = boundaryChoices(fact.boundary, witness)
    val guidedChoices = for {
      seedWitness <- pullBackWitness(fact, witness)
      sourceWitnesses <-
        AutomaticIslandCompiler.sourceWitnesses(
          seed.detected.problem, seedWitness) match {
          case Supported(values) => Some(values)
          case _                 => None
        }
    } yield {
      val sourceLanguages = seed.detected.problem.sources.map(source =>
        source.name -> source.language).toMap
      val sourceChoices = seed.detected.sources.flatMap { source =>
        val value = sourceWitnesses(source.name)
        AutomataUtils.isSingleton(sourceLanguages(source.name)) match {
          case Some(current) =>
            require(current == value,
                    "a pulled-back source witness escaped its language")
            None
          case None =>
            Some((source.term, value))
        }
      }
      val completeChoices =
        finalChoices ++
        boundaryChoices(seed.detected.boundary, seedWitness) ++
        sourceChoices
      if (completeChoices.size <= MaxWitnessTapes)
        (completeChoices, false)
      else if (fact.steps.nonEmpty && sourceChoices.nonEmpty)
        (sourceChoices, true)
      else
        (finalChoices, false)
    }
    val (rawChoices, regularSelected) =
      guidedChoices.getOrElse((finalChoices, false))
    val choices = deduplicateChoices(rawChoices)
    for (selected <- choices;
         split <- makeWitnessSplit(
           selected, key, goal, regularSelected = regularSelected))
    yield split
  }

  private def pullBackWitness(
      fact : RelationalFact,
      witness : Map[String, Vector[Int]])
      : Option[Map[String, Vector[Int]]] = {
    var current = witness
    for (step <- fact.steps.reverseIterator) {
      SynchronizedHomomorphicImage.preimageWitness(
          step.source, step.layer.homomorphisms, current) match {
        case Some(preimage) => current = preimage
        case None           => return None
      }
    }
    Some(current)
  }

  /** Keep model construction moving when a functional image is not automatic. */
  private def concreteForwardWitnessSplit(
      fact : RelationalFact,
      witness : Map[String, Vector[Int]],
      seed : AvailableIsland,
      key : String,
      goal : Goal) : Option[WitnessSplit] = {
    for {
      seedWitness <- pullBackWitness(fact, witness)
      sourceWitnesses <- AutomaticIslandCompiler.sourceWitnesses(
        seed.detected.problem, seedWitness) match {
          case Supported(values) => Some(values)
          case _                 => None
        }
      sourceChoices <- sourceWitnessChoices(
        seed.detected, sourceWitnesses)
      initialChoices <- deduplicateChoices(
        boundaryChoices(fact.boundary, witness) ++
        boundaryChoices(seed.detected.boundary, seedWitness) ++
        sourceChoices)
      forwardChoices <- concreteReplaceAllClosure(initialChoices, goal)
      choices <- deduplicateChoices(initialChoices ++ forwardChoices)
      if choices.size <= MaxWitnessTapes
      split <- makeWitnessSplit(choices, key, goal)
    } yield split
  }

  private def sourceWitnessChoices(
      detected : DetectedIsland,
      sourceWitnesses : Map[String, Vector[Int]])
      : Option[Vector[(LinearCombination, Vector[Int])]] = {
    val sourceLanguages = detected.problem.sources.map(source =>
      source.name -> source.language).toMap
    val choices = Vector.newBuilder[(LinearCombination, Vector[Int])]
    for (source <- detected.sources) {
      val value = sourceWitnesses(source.name)
      AutomataUtils.isSingleton(sourceLanguages(source.name)) match {
        case Some(current) if current != value => return None
        case Some(_) =>
        case None    => choices += ((source.term, value))
      }
    }
    Some(choices.result())
  }

  private def concreteReplaceAllClosure(
      initial : Vector[(LinearCombination, Vector[Int])],
      goal : Goal) : Option[Vector[(LinearCombination, Vector[Int])]] = {
    val known = new MHashMap[LinearCombination, Vector[Int]]
    known ++= initial
    val added = Vector.newBuilder[(LinearCombination, Vector[Int])]
    val calls = goal.facts.predConj
      .positiveLitsWithPred(theory._str_replaceall)
      .toVector.sortBy(_.toString)

    var changed = true
    while (changed) {
      changed = false
      for (call <- calls;
           input <- known.get(call(0)).orElse(
             theory.strDatabase.term2List(call(0)).map(_.toVector));
           matched <- theory.strDatabase.term2List(call(1)).map(_.toVector);
           replacement <- theory.strDatabase.term2List(call(2)).map(_.toVector);
           output <- replaceAllWord(input, matched, replacement)) {
        val term = call(3)
        val current = known.get(term).orElse(
          theory.strDatabase.term2List(term).map(_.toVector))
        current match {
          case Some(value) if value != output => return None
          case Some(_) =>
          case None =>
            known.put(term, output)
            added += ((term, output))
            changed = true
        }
      }
    }
    Some(added.result())
  }

  private def boundaryChoices(
      boundary : Vector[BoundaryTerm],
      witness : Map[String, Vector[Int]])
      : Vector[(LinearCombination, Vector[Int])] =
    boundary.flatMap { item =>
      val value = witness(item.tape.name)
      theory.strDatabase.term2List(item.term) match {
        case Some(current) =>
          require(current.toVector == value,
                  "a relational witness disagrees with a literal boundary")
          None
        case None =>
          Some((item.term, value))
      }
    }

  private def deduplicateChoices(
      choices : Vector[(LinearCombination, Vector[Int])])
      : Option[Vector[(LinearCombination, Vector[Int])]] = {
    val seen = new MHashMap[LinearCombination, Vector[Int]]
    val result = Vector.newBuilder[(LinearCombination, Vector[Int])]
    for (choice @ (term, value) <- choices)
      seen.get(term) match {
        case Some(current) if current != value => return None
        case Some(_) =>
        case None =>
          seen.put(term, value)
          result += choice
      }
    Some(result.result())
  }

  private def makeWitnessSplit(
      choices : Vector[(LinearCombination, Vector[Int])],
      key : String,
      goal : Goal,
      regularSelected : Boolean = false) : Option[WitnessSplit] = {
    import ap.terfor.TerForConvenience._
    implicit val order = goal.order

    if (choices.isEmpty || choices.size > MaxWitnessTapes)
      return None

    val strInRe = new RichPredicate(theory.str_in_re_id, goal.order)
    val alternatives = choices.map { case (term, value) =>
      val word = value.iterator.map(_.toChar).mkString
      val complementId = theory.autDatabase.automaton2Id(
        !BricsAutomaton.fromString(word))
      def atom(id : Int) = strInRe(Seq(
        term, LinearCombination(IdealInt(id))))
      val selected =
        if (regularSelected) {
          val singletonId = theory.autDatabase.automaton2Id(
            BricsAutomaton.fromString(word))
          atom(singletonId)
        }
        else
          term === theory.strDatabase.list2Id(value)
      (selected, atom(complementId))
    }
    val branches = witnessPartition(
      alternatives.map(_._1), alternatives.map(_._2)).map { branch =>
        Conjunction.conj(branch, goal.order)
      }
    Some(WitnessSplit(
      branches,
      choices.size,
      branches.size,
      key))
  }

  private def allBoundaryLanguagesSingleton(
      detected : DetectedIsland) : Boolean = {
    val languages = detected.problem.unary.map(constraint =>
      constraint.tape.name -> constraint.language).toMap
    detected.boundary.forall(boundary =>
      AutomataUtils.isSingleton(languages(boundary.tape.name)).isDefined)
  }

  private def firstLog(key : String) : Boolean =
    logged.synchronized(logged.add(key))

  private def render(metrics : RelationMetrics) : String =
    metrics.states + " states / " + metrics.transitions + " transitions"

  private def log(message : String) : Unit =
    Console.err.println("[automatic-island] " + message)
}
