/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2026 Oliver Markgraf. All rights reserved.
 */

package ostrich.proofops

import ap.basetypes.IdealInt
import ap.proof.goal.Goal
import ap.terfor.Formula
import ap.terfor.TerForConvenience
import ap.terfor.equations.EquationConj
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.preds.{Atom, Predicate}
import ostrich.OstrichStringTheory
import ostrich.automata.{AtomicStateAutomaton, AutomataUtils, Automaton,
                        BricsAutomaton,
                        CertifiedModuloExtractor, ExtractorCertificate}
import ostrich.automata.relations._

import scala.collection.mutable.{HashMap => MHashMap, HashSet => MHashSet,
                                 Queue}

object AutomaticIslandDetector {
  sealed trait Detection {
    val structuralKey : String
  }
  case class BoundaryTerm(tape : Tape,
                          term : LinearCombination)
  case class SourceTerm(name : String,
                        term : LinearCombination)
  case class DetectedHomomorphicLayer(
      target : Vector[BoundaryTerm],
      homomorphisms : Vector[TapeHomomorphism],
      assumptions : Vector[Formula],
      structuralKey : String)
  case class DetectedBoundaryConnector(
      relation : SynchronizedRelation,
      assumptions : Vector[Formula],
      structuralKey : String)
  case class RejectedIsland(reason : String,
                            structuralKey : String) extends Detection
  case class DetectedIsland(problem : AutomaticIslandProblem,
                            boundary : Vector[BoundaryTerm],
                            sources : Vector[SourceTerm],
                            assumptions : Vector[Formula],
                            structuralKey : String) extends Detection
}

/** Translate connected exact relation components into pure island problems. */
class AutomaticIslandDetector(theory : OstrichStringTheory) {
  import AutomaticIslandDetector._
  import LinearCombination.Constant
  import TerForConvenience._
  import theory.{_str_++, _str_replaceall, autDatabase, strDatabase,
                 str_in_re_id}

  private case class CertifiedCall(atom : Atom,
                                   certificate : ExtractorCertificate)
  private case class Cluster(source : LinearCombination,
                             calls : Vector[CertifiedCall]) {
    val outputs : Vector[LinearCombination] = calls.map(_.atom(1))
    val atoms : Vector[Atom] = calls.map(_.atom)
    val stop : Int = calls.head.certificate.stop
  }
  private sealed trait Connector {
    val left : LinearCombination
    val right : LinearCombination
    val assumption : Formula
    def letters : Vector[Int] = Vector.empty
  }
  private case class EqualityConnector(left : LinearCombination,
                                       right : LinearCombination,
                                       assumption : Formula)
      extends Connector
  private case class DisequalityConnector(left : LinearCombination,
                                          right : LinearCombination,
                                          assumption : Formula)
      extends Connector
  private case class PrefixConnector(left : LinearCombination,
                                     right : LinearCombination,
                                     word : Vector[Int],
                                     assumption : Formula)
      extends Connector {
    override def letters = word
  }
  private case class SuffixConnector(left : LinearCombination,
                                     right : LinearCombination,
                                     word : Vector[Int],
                                     assumption : Formula)
      extends Connector {
    override def letters = word
  }
  private case class Candidate(clusters : Vector[Cluster],
                               connectors : Vector[Connector])
  private case class TermLanguage(automaton : AtomicStateAutomaton,
                                  atoms : Vector[Atom])
  private case class HomomorphicCall(input : LinearCombination,
                                     output : LinearCombination,
                                     matched : Int,
                                     replacement : Vector[Int],
                                     atom : Atom)

  private lazy val certifiedPredicates
      : Map[Predicate, ExtractorCertificate] =
    (for ((_, predicate, transducer) <- theory.transducersWithPreds;
          certificate <- CertifiedModuloExtractor.certify(transducer))
     yield predicate -> certificate).toMap

  /** Return one independent detection result per connected extractor island. */
  def detect(goal : Goal) : Vector[Detection] = {
    val regexGroups = goal.facts.predConj
      .positiveLitsWithPred(str_in_re_id).groupBy(_(0))
    findCandidates(goal).map(buildProblem(_, regexGroups))
  }

  /**
   * Find maximal layers of constant, single-character replace_all calls.
   * Tapes without a call at this stage advance through an implicit identity.
   */
  def homomorphicLayers(boundary : Vector[BoundaryTerm], goal : Goal)
      : Vector[DetectedHomomorphicLayer] = {
    if (boundary.isEmpty || boundary.map(_.term).distinct.size != boundary.size)
      return Vector.empty

    val calls = goal.facts.predConj
      .positiveLitsWithPred(_str_replaceall).iterator.flatMap { atom =>
        for (matched <- strDatabase.term2List(atom(1));
             if matched.size == 1;
             replacement <- strDatabase.term2List(atom(2));
             if replacement.size <= MaxHomomorphicReplacementLength)
        yield HomomorphicCall(
          atom(0), atom(3), matched.head, replacement.toVector, atom)
      }.toVector.groupBy(_.input)

    val choices : Vector[Vector[Option[HomomorphicCall]]] =
      boundary.map { item =>
        val available = calls.getOrElse(item.term, Vector.empty)
          .sortBy(_.atom.toString)
        if (available.nonEmpty)
          available.map(Some(_))
        else
          Vector(None)
      }
    if (choices.forall(_.forall(_.isEmpty)))
      return Vector.empty

    val selections = Vector.newBuilder[Vector[Option[HomomorphicCall]]]
    var selectionCount = 0
    def enumerate(index : Int,
                  prefix : Vector[Option[HomomorphicCall]]) : Unit = {
      if (selectionCount < MaxHomomorphicLayers) {
        if (index == choices.size) {
          selections += prefix
          selectionCount += 1
        } else
          for (call <- choices(index);
               if selectionCount < MaxHomomorphicLayers)
            enumerate(index + 1, prefix :+ call)
      }
    }
    enumerate(0, Vector.empty)

    selections.result().flatMap { selected =>
      val outputs = boundary.zip(selected).map {
        case (_, Some(call)) => call.output
        case (item, None)    => item.term
      }
      if (outputs.distinct.size != selected.size) {
        None
      } else {
        try {
          val homomorphisms = boundary.zip(selected).map {
            case (item, Some(call)) =>
              val images = item.tape.alphabet.map { character =>
                character ->
                  (if (character == call.matched) call.replacement
                   else Vector(character))
              }.toMap
              val productiveAlphabet = images.valuesIterator.flatten.toSet
              val targetAlphabet =
                if (productiveAlphabet.nonEmpty)
                  productiveAlphabet.toVector.sorted
                else
                  Vector(item.tape.alphabet.head)
              TapeHomomorphism(
                item.tape,
                Tape(item.tape.name, targetAlphabet),
                images)
            case (item, None) =>
              TapeHomomorphism(
                item.tape,
                item.tape,
                item.tape.alphabet.map(character =>
                  character -> Vector(character)).toMap)
          }
          val assumptions = selected.flatten.map(_.atom : Formula).distinct
          val structuralKey = boundary.zip(selected).map {
            case (_, Some(call)) => "replace " + call.atom.toString
            case (item, None)    => "identity " + item.term.toString
          }.mkString("\n")
          Some(DetectedHomomorphicLayer(
            outputs.zip(homomorphisms).map { case (output, homomorphism) =>
              BoundaryTerm(homomorphism.target, output)
            },
            homomorphisms,
            assumptions,
            structuralKey))
        } catch {
          case _ : IllegalArgumentException => None
        }
      }
    }.distinct.sortBy(_.structuralKey)
  }

  /**
   * Compile exact goal-level relations whose endpoints are both on the
   * current relational boundary.
   */
  def boundaryConnectors(boundary : Vector[BoundaryTerm], goal : Goal)
      : Vector[DetectedBoundaryConnector] = {
    if (boundary.isEmpty || boundary.map(_.term).distinct.size != boundary.size)
      return Vector.empty

    val byTerm = boundary.map(item => item.term -> item).toMap
    val owners = boundary.zipWithIndex.map { case (item, index) =>
      item.term -> Vector(index)
    }.toMap
    val concatAtoms =
      goal.facts.predConj.positiveLitsWithPred(_str_++).toVector
    val connectors = discoverConnectors(
      concatAtoms,
      goal.facts.arithConj.positiveEqs.toVector,
      goal.facts.arithConj.negativeEqs.toVector,
      owners,
      goal)

    val result = Vector.newBuilder[DetectedBoundaryConnector]
    result ++= connectors.flatMap { connector =>
      if (connector.left == connector.right)
        None
      else {
        val left = byTerm(connector.left).tape
        val right = byTerm(connector.right).tape
        val alphabet = (left.alphabet ++ right.alphabet ++ connector.letters)
          .distinct.sorted
        if (alphabet.isEmpty || alphabet.size > MaxFiniteAlphabet)
          None
        else {
          val alignedLeft = Tape(left.name, alphabet)
          val alignedRight = Tape(right.name, alphabet)
          val provenance = Vector(Provenance(
            "OSTRICH goal connector", connector.assumption.toString))
          try {
            val relation = connector match {
              case EqualityConnector(_, _, _) =>
                RelationConstructors.equality(
                  alignedLeft, alignedRight, provenance)
              case DisequalityConnector(_, _, _) =>
                RelationConstructors.disequality(
                  alignedLeft, alignedRight, provenance)
              case PrefixConnector(_, _, word, _) =>
                RelationConstructors.fixedPrefix(
                  alignedLeft, alignedRight, word, provenance)
              case SuffixConnector(_, _, word, _) =>
                RelationConstructors.fixedSuffix(
                  alignedLeft, alignedRight, word, provenance)
            }
            Some(DetectedBoundaryConnector(
              relation,
              Vector(connector.assumption),
              connector.assumption.toString))
          } catch {
            case _ : IllegalArgumentException => None
          }
        }
      }
    }

    // If only the concatenation result is on the current boundary, eliminate
    // the unconstrained tail.  Projecting `result = word ++ tail` gives the
    // exact unary prefix language needed by the relational emptiness check.
    for (atom <- concatAtoms) {
      val first = atom(0)
      val second = atom(1)
      val concatenated = atom(2)
      byTerm.get(concatenated).foreach { boundaryTerm =>
        val provenance = Vector(Provenance(
          "OSTRICH goal connector", atom.toString))

        def projectedAffix(word : Vector[Int], prefix : Boolean)
            : Option[DetectedBoundaryConnector] = {
          val alphabet = (boundaryTerm.tape.alphabet ++ word).distinct.sorted
          if (word.isEmpty || alphabet.isEmpty ||
              alphabet.size > MaxFiniteAlphabet)
            None
          else {
            val exposed = Tape(boundaryTerm.tape.name, alphabet)
            val hidden = Tape(boundaryTerm.tape.name + "#affix-tail", alphabet)
            try {
              val binary =
                if (prefix)
                  RelationConstructors.fixedPrefix(
                    exposed, hidden, word, provenance)
                else
                  RelationConstructors.fixedSuffix(
                    exposed, hidden, word, provenance)
              Some(DetectedBoundaryConnector(
                binary.project(Vector(exposed.name)),
                Vector(atom),
                (if (prefix) "prefix language " else "suffix language ") +
                  atom.toString))
            } catch {
              case _ : IllegalArgumentException => None
            }
          }
        }

        strDatabase.term2List(first) match {
          case Some(word) if !byTerm.contains(second) =>
            projectedAffix(word.toVector, prefix = true).foreach(result += _)
          case _ =>
        }
        strDatabase.term2List(second) match {
          case Some(word) if !byTerm.contains(first) =>
            projectedAffix(word.toVector, prefix = false).foreach(result += _)
          case _ =>
        }
      }
    }

    result.result().distinct.sortBy(_.structuralKey)
  }

  private def findCandidates(goal : Goal) : Vector[Candidate] = {
    if (certifiedPredicates.isEmpty)
      return Vector.empty

    val predConj = goal.facts.predConj
    val calls = (for ((predicate, certificate) <- certifiedPredicates.toVector;
                      atom <- predConj.positiveLitsWithPred(predicate))
                 yield CertifiedCall(atom, certificate)).groupBy(_.atom(0))

    val clusters = calls.iterator.flatMap { case (source, sourceCalls) =>
      sourceCalls.groupBy(call =>
          (call.certificate.period, call.certificate.stop)).iterator.flatMap {
        case ((period, _), family) =>
          val byPhase = family.groupBy(_.certificate.phase)
          if ((0 until period).forall(phase =>
                byPhase.get(phase).exists(_.size == 1))) {
            val selected = (0 until period)
              .map(phase => byPhase(phase).head).toVector
            Some(Cluster(source, selected))
          } else {
            None
          }
      }
    }.toVector.sortBy(cluster =>
      (cluster.source.toString, cluster.atoms.map(_.toString).mkString("\n")))

    if (clusters.isEmpty)
      return Vector.empty

    val outputOwners : Map[LinearCombination, Vector[Int]] =
      (for ((cluster, index) <- clusters.zipWithIndex;
            output <- cluster.outputs)
       yield (output, index)).groupBy(_._1).map { case (term, occurrences) =>
        term -> occurrences.map(_._2).distinct.sorted.toVector
      }
    val connectors = discoverConnectors(
      predConj.positiveLitsWithPred(_str_++).toVector,
      goal.facts.arithConj.positiveEqs.toVector,
      goal.facts.arithConj.negativeEqs.toVector,
      outputOwners,
      goal)

    val adjacency = Array.fill(clusters.size)(MHashSet[Int]())
    def connect(left : Int, right : Int) : Unit = {
      adjacency(left) += right
      adjacency(right) += left
    }
    for (owners <- outputOwners.values;
         left <- owners;
         right <- owners;
         if left < right)
      connect(left, right)
    for (connector <- connectors;
         left <- outputOwners(connector.left);
         right <- outputOwners(connector.right))
      connect(left, right)

    val unseen = MHashSet[Int]() ++ clusters.indices
    val result = Vector.newBuilder[Candidate]
    while (unseen.nonEmpty) {
      val seed = unseen.min
      unseen -= seed
      val queue = Queue[Int](seed)
      val component = MHashSet[Int](seed)
      while (queue.nonEmpty) {
        val current = queue.dequeue()
        for (next <- adjacency(current); if unseen.remove(next)) {
          component += next
          queue.enqueue(next)
        }
      }

      val componentConnectors = connectors.filter { connector =>
        outputOwners(connector.left).exists(component) &&
        outputOwners(connector.right).exists(component)
      }
      result += Candidate(
        component.toVector.sorted.map(clusters), componentConnectors)
    }
    result.result().sortBy(_.clusters.head.source.toString)
  }

  /** Recognise exact equality and fixed-affix edges between output terms. */
  private def discoverConnectors(
      concatAtoms : Vector[Atom],
      positiveEqs : Vector[LinearCombination],
      negativeEqs : Vector[LinearCombination],
      outputOwners : Map[LinearCombination, Vector[Int]],
      goal : Goal)
      : Vector[Connector] = {
    implicit val order = goal.order
    val connectors = Vector.newBuilder[Connector]
    for (atom <- concatAtoms) {
      val first = atom(0)
      val second = atom(1)
      val result = atom(2)
      strDatabase.term2List(first) match {
        case Some(word)
            if outputOwners.contains(second) && outputOwners.contains(result) =>
          connectors += PrefixConnector(
            result, second, word.toVector, atom)
        case _ =>
      }
      strDatabase.term2List(second) match {
        case Some(word)
            if outputOwners.contains(first) && outputOwners.contains(result) =>
          connectors += SuffixConnector(
            result, first, word.toVector, atom)
        case _ =>
      }
    }
    for (lc <- positiveEqs;
         (left, right) <- equalityTerms(lc, goal).toVector;
         if left != right &&
            outputOwners.contains(left) && outputOwners.contains(right)) {
      connectors += EqualityConnector(
        left, right, EquationConj(lc, goal.order))
    }
    for (lc <- negativeEqs;
         (left, right) <- equalityTerms(lc, goal).toVector;
         if left != right &&
            outputOwners.contains(left) && outputOwners.contains(right)) {
      connectors += DisequalityConnector(
        left, right, conj(lc =/= 0))
    }
    connectors.result().distinct.sortBy(_.assumption.toString)
  }

  /** Recognise a normalized equality between two terms, with no offset. */
  private def equalityTerms(lc : LinearCombination, goal : Goal)
      : Option[(LinearCombination, LinearCombination)] =
    lc match {
      case Seq((IdealInt.ONE, left), (IdealInt.MINUS_ONE, right)) =>
        Some((LinearCombination(left, goal.order),
              LinearCombination(right, goal.order)))
      case Seq((IdealInt.MINUS_ONE, left), (IdealInt.ONE, right)) =>
        Some((LinearCombination(left, goal.order),
              LinearCombination(right, goal.order)))
      case _ =>
        None
    }

  private def buildProblem(
      candidate : Candidate,
      regexGroups : Map[LinearCombination, _ <: Iterable[Atom]]) : Detection = {
    val sourceTerms = candidate.clusters.map(_.source)
    val outputTerms = candidate.clusters.flatMap(_.outputs).distinct
      .sortBy(_.toString)
    val terms = (sourceTerms ++ outputTerms).distinct
    val availableRegexAtoms = terms.flatMap(term =>
      regexGroups.get(term).toVector.flatMap(_.toVector))
    val structuralAssumptions : Vector[Formula] =
      (candidate.clusters.flatMap(_.atoms) ++
       candidate.connectors.map(_.assumption)).distinct
    val baseAssumptions : Vector[Formula] =
      (structuralAssumptions ++
       availableRegexAtoms).distinct
    val syntacticKey = baseAssumptions.map(_.toString).sorted.mkString("\n")

    def reject(reason : String) = RejectedIsland(reason, syntacticKey)

    if (sourceTerms.distinct.size != sourceTerms.size)
      return reject("multiple certified clusters share one source term")

    val languages = new MHashMap[LinearCombination, TermLanguage]
    for (term <- terms) {
      val atoms = regexGroups.get(term).toVector.flatMap(_.toVector)
      termLanguage(term, atoms) match {
        case Left(reason)    => return reject(reason)
        case Right(language) => languages.put(term, language)
      }
    }

    val languageKey = terms.sortBy(_.toString).map { term =>
      val id = autDatabase.automaton2Id(languages(term).automaton)
      term.toString + "=" + id
    }
    val semanticKey =
      structuralAssumptions.map(_.toString).sorted.mkString("\n") +
      "\n-- unary languages --\n" + languageKey.mkString("\n")

    val connectorLetters = candidate.connectors.flatMap(_.letters)
    if (connectorLetters.exists(character =>
          character < Char.MinValue.toInt || character > Char.MaxValue.toInt))
      return reject("a connector word is outside the OSTRICH alphabet")

    val tapeAlphabets = new MHashMap[LinearCombination, MHashSet[Int]]
    for (term <- outputTerms)
      tapeAlphabets.put(term, MHashSet.empty)
    for (term <- outputTerms)
      finiteAlphabet(languages(term).automaton, MaxFiniteAlphabet) match {
        case Some(letters) => tapeAlphabets(term) ++= letters
        case None =>
          return reject("an output language has no small finite alphabet")
      }
    for (connector <- candidate.connectors) {
      tapeAlphabets(connector.left) ++= connector.letters
      tapeAlphabets(connector.right) ++= connector.letters
    }

    val sourceAlphabets = new MHashMap[Cluster, Vector[Int]]
    for (cluster <- candidate.clusters) {
      finiteAlphabet(languages(cluster.source).automaton,
                     MaxFiniteAlphabet + 1) match {
        case Some(letters) =>
          val sourceAlphabet = (letters + cluster.stop).toVector.sorted
          sourceAlphabets.put(cluster, sourceAlphabet)
          ExtractorClusterCompiler.productiveOutputAlphabets(
              languages(cluster.source).automaton,
              sourceAlphabet,
              cluster.calls.map(_.certificate)) match {
            case Unsupported(reason) => return reject(reason)
            case Supported(laneAlphabets) =>
              for ((term, alphabet) <- cluster.outputs.zip(laneAlphabets))
                tapeAlphabets(term) ++= alphabet
          }
        case None =>
          return reject("a source language has no small finite alphabet")
      }
    }

    // The connector constructors compare tapes symbol by symbol, so every
    // connected component uses the union of its lane-local alphabets.
    var changed = true
    while (changed) {
      changed = false
      for (connector <- candidate.connectors) {
        val union = tapeAlphabets(connector.left).toSet ++
                    tapeAlphabets(connector.right)
        if (union.size > MaxFiniteAlphabet)
          return reject("a connected output alphabet is too large")
        if (union.size != tapeAlphabets(connector.left).size ||
            union.size != tapeAlphabets(connector.right).size) {
          tapeAlphabets(connector.left) ++= union
          tapeAlphabets(connector.right) ++= union
          changed = true
        }
      }
    }

    val fallbackCharacter = sourceAlphabets.valuesIterator
      .flatMap(_.iterator).toSeq.sorted.head
    for (term <- outputTerms) {
      if (tapeAlphabets(term).isEmpty)
        tapeAlphabets(term) += fallbackCharacter
      if (tapeAlphabets(term).size > MaxFiniteAlphabet)
        return reject("an output tape alphabet is too large")
    }

    val tapes = new MHashMap[LinearCombination, Tape]
    for ((term, index) <- outputTerms.zipWithIndex)
      tapes.put(term, Tape(
        "v" + index, tapeAlphabets(term).toVector.sorted))

    def factProvenance(formula : Formula) =
      Provenance("OSTRICH proof fact", formula.toString)

    val sources = candidate.clusters.zipWithIndex.map {
      case (cluster, index) =>
        IslandSource(
          "source" + index,
          languages(cluster.source).automaton,
          sourceAlphabets(cluster),
          cluster.outputs.map(tapes),
          cluster.calls.map(_.certificate),
          (cluster.atoms.map(factProvenance) ++
           languages(cluster.source).atoms.map(factProvenance)).distinct)
    }

    val unary = outputTerms.map { term =>
      IslandUnary(
        tapes(term), languages(term).automaton,
        languages(term).atoms.map(factProvenance).distinct)
    }
    val boundary = outputTerms.map { term =>
      BoundaryTerm(tapes(term), term)
    }
    val sourceBoundary = candidate.clusters.zipWithIndex.map {
      case (cluster, index) => SourceTerm("source" + index, cluster.source)
    }

    val connectors = candidate.connectors.map { connector =>
      val provenance = Vector(factProvenance(connector.assumption))
      connector match {
        case EqualityConnector(left, right, _) =>
          IslandEquality(tapes(left), tapes(right), provenance)
        case DisequalityConnector(left, right, _) =>
          IslandDisequality(tapes(left), tapes(right), provenance)
        case PrefixConnector(left, right, word, _) =>
          IslandPrefix(tapes(left), tapes(right), word, provenance)
        case SuffixConnector(left, right, word, _) =>
          IslandSuffix(tapes(left), tapes(right), word, provenance)
      }
    }

    DetectedIsland(
      AutomaticIslandProblem(sources, unary, connectors),
      boundary,
      sourceBoundary,
      baseAssumptions,
      semanticKey)
  }

  private def termLanguage(term : LinearCombination, atoms : Vector[Atom])
      : Either[String, TermLanguage] = {
    if (atoms.isEmpty) {
      strDatabase.term2List(term) match {
        case Some(word) =>
          val string = word.iterator.map(_.toChar).mkString
          return Right(TermLanguage(
            BricsAutomaton.fromString(string), Vector.empty))
        case None =>
          return Left("a selected island term has no unary language")
      }
    }
    val automata = atoms.map { atom =>
      atom(1) match {
        case Constant(IdealInt(id)) => autDatabase.id2Automaton(id)
        case _                      => None
      }
    }
    if (automata.exists(_.isEmpty))
      return Left("a selected regular-language identifier is unavailable")

    AutomataUtils.product(
        automata.flatten.map(_.asInstanceOf[Automaton])) match {
      case atomic : AtomicStateAutomaton => Right(TermLanguage(atomic, atoms))
      case _ => Left("a selected unary-language product is not atomic-state")
    }
  }

  private def finiteAlphabet(automaton : AtomicStateAutomaton,
                             limit : Int) : Option[Set[Int]] = {
    val letters = MHashSet[Int]()
    for ((_, label, _) <- automaton.transitions) {
      val iterator = automaton.LabelOps.enumLetters(label)
      while (iterator.hasNext) {
        letters += iterator.next()
        if (letters.size > limit)
          return None
      }
    }
    Some(letters.toSet)
  }

  private val MaxFiniteAlphabet = 16
  private val MaxHomomorphicLayers = 32
  private val MaxHomomorphicReplacementLength = 64
}
