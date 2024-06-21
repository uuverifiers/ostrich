
package ostrich.proofops

import ap.SimpleAPI
import ap.parameters.GoalSettings
import ap.parser.IExpression.{toPredApplier}
import ap.proof.Vocabulary
import ap.proof.goal.Goal
import ap.terfor.conjunctions.Conjunction
import ap.terfor.linearcombination.LinearCombination
import ap.terfor.{ConstantTerm, Formula, RichPredicate, TermOrder}
import ostrich.automata.{BricsAutomaton, Automaton, IDState}
import ostrich.{OstrichStringTheory, OFlags}

import org.scalacheck.Properties
import org.scalacheck.Prop._

object OstrichForwardsPropSpecification
  extends Properties("OstrichForwardsProp") {

  private val oflags = OFlags()
  private val theory = new OstrichStringTheory(Seq(), oflags)
  import theory._

  property("Simple Test") = {
    val api = SimpleAPI.spawnWithAssertions
    api.addTheory(theory)
    val x = api.createConstant("x", StringSort)
    val y = api.createConstant("y", StringSort)
    var to = api.order
    val vocab = Vocabulary(to)

    val xEQy = str_in_re_id(x, 1)
    val fact1 = Conjunction.conj(api.asConjunction(xEQy), to)
    val facts = Seq(fact1)
    val goal = Goal(facts, Set.empty, vocab, GoalSettings.DEFAULT)

    val res = new OstrichForwardsProp(goal, theory, oflags).apply

    // TODO: add assertions about result
    println(res)

    true
  }
}
