package ostrich.parikh

import scala.collection.mutable.{Map => MMap, HashSet => MHashSet, HashMap => MHashMap, ArrayStack}
import ap.terfor.Term
import ap.api.SimpleAPI
import CostEnrichedConvenience._
import ap.terfor.Formula
import ap.terfor.conjunctions.Conjunction
import ap.terfor.TerForConvenience._
import TermGeneratorOrder._
import SimpleAPI.ProverStatus
import ap.parser.SymbolCollector
import ostrich.parikh.automata.CostEnrichedAutomatonTrait

object ParikhUtil {
  def getAllConstantTerms(auts: Seq[CostEnrichedAutomatonTrait]): Seq[Term] = {
    val termsSet = new MHashSet[Term]
    auts.foreach(aut => termsSet ++= aut.getTransitionsTerms)
    termsSet.toSeq
  }

  /** Given lengthModel, check whether there is some word accepted by all of the
    * given automata. Note that this function heuristicly finds a word. It is
    * sound, but not complete.
    */
  def findAcceptedWord(
      auts: Seq[CostEnrichedAutomatonTrait],
      lengthModel: MMap[Term, Int]
  ): Option[Seq[Int]] = {
    type State = CostEnrichedAutomatonTrait#State
    type TLabel = CostEnrichedAutomatonTrait#TLabel

    val fisrtAut = auts(0)

    /** Check whether all states are accepted
      */
    def isAccepting(states: Seq[State]): Boolean =
      states forall (_.isAccept)

    /** One step of intersection
      */
    def enumNext(
        auts: Seq[CostEnrichedAutomatonTrait],
        states: Seq[State],
        lengthModel: MMap[Term, Int],
        intersectedLabels: TLabel
    ): Iterator[(Seq[State], MMap[Term, Int], Int)] =
      auts match {
        case Seq() =>
          Iterator(
            (
              Seq(),
              lengthModel,
              fisrtAut.LabelOps.enumLetters(intersectedLabels).next
            )
          )
        case aut +: otherAuts => {
          val state +: otherStates = states
          for (
            (to, label, term) <- aut.outgoingTransitionsWithTerm(
              state
            );
            newILabel <- aut.LabelOps
              .intersectLabels(
                intersectedLabels,
                label
              )
              .toSeq;
            if (lengthModel(term) > 0);
            (tailNext, updatedModel, let) <- enumNext(
              otherAuts,
              otherStates,
              lengthModel + ((
                term,
                lengthModel(term) - 1
              )), // update lengthModel
              newILabel
            )
          )
            yield (to +: tailNext, updatedModel, let)
        }
      }

    val initial = (auts map (_.initialState))

    if (isAccepting(initial) && lengthModel.forall(_._2 == 0))
      return Some(Seq())

    val visitedStates = new MHashSet[(Seq[State], MMap[Term, Int])]
    val todo = new ArrayStack[(Seq[State], MMap[Term, Int], Seq[Int])]

    visitedStates += ((initial, lengthModel))
    todo push ((initial, lengthModel, Seq()))

    while (!todo.isEmpty) {
      val (next, lengthModel, w) = todo.pop
      for (
        (reached, updatedModel, let) <-
          enumNext(
            auts,
            next,
            lengthModel,
            auts(0).LabelOps.sigmaLabel
          )
      ) {
        val a = 1
        if (visitedStates.add((reached, updatedModel))) {
          val newW = w :+ let
          val finishTrans = updatedModel.forall(_._2 == 0)
          if (isAccepting(reached) && finishTrans)
            return Some(newW)
          if (!finishTrans)
            todo push (reached, updatedModel, newW)
        }
      }
    }
    None
  }

  /** Given a sequence of automata, heuristicly product the parikh image of
    * them. This function is sound, but not complete.
    * @param auts
    *   the automata
    * @param lengthProver
    *   the prover to check the parikh image
    * @return
    *   true if find an accepted word, false otherwise
    */
  def checkConsistenceByParikh(
      auts: Seq[CostEnrichedAutomatonTrait],
      lengthProver: Option[SimpleAPI]
  ): Boolean = {
    val syncMaxLen = 2
    var syncCurrentLen = 0
    val p = lengthProver.getOrElse(
      SimpleAPI()
    )
    while (syncCurrentLen <= syncMaxLen) {
      checkConsistenceByParikhStep(auts, p, syncCurrentLen) match {
        case true  => {
          val lengthModel = new MHashMap[Term, Int]
          findAcceptedWord(auts, lengthModel) match {
            case Some(w) => return true
            case None => checkConsistenceByParikhStep(auts, p, syncCurrentLen + 1)
          }
        }
        case false => false
      }
    }
    false
  }

  /** Given a sequence of automata, heuristicly product the parikh image of
    * them. Guarantee that the number of substring of length `syncLen` are same
    * for every automaton.
    * @param auts
    *   the automata
    * @param lengthProver
    *   the prover to check the parikh image
    * @param syncLen
    *   the length of substring
    * @return
    *   true if the parikh image is satisfiable, false otherwise
    */
  def checkConsistenceByParikhStep(
      auts: Seq[CostEnrichedAutomatonTrait],
      lengthProver: SimpleAPI,
      syncLen: Int
  ): Boolean = {
    // TODO: implement it 
    true
  }

  /**
    * Given a sequence of automata, consider them as an infinite transition system.
    * The bad state is (q1, ..., qn, \varphi) where q1, ..., qn are accepted state and 
    * formula \varphi is consistent with other linear arithmetic constraints. 
    * Use algorithm **IC3** to solve this problem. 
    * @param auts
    *   the automata
    * @param lengthProver
    *   the prover to check whether \varphi is consistent
    * @return true if find a bad state; otherwise, false.
    */
  def checkConsistenceByIC3(
      auts: Seq[CostEnrichedAutomatonTrait],
      lengthProver: Option[SimpleAPI]
  ): Boolean = {
    // TODO: implement it 
    true
  }
}
