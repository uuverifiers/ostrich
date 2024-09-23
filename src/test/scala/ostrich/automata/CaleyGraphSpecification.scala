package ostrich.automata

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._
import dk.brics.automaton.{Automaton => BAutomaton, State, Transition}
import scala.collection.mutable.Set
import scala.collection.JavaConversions.iterableAsScalaIterable

class PrintableState extends State {
  override def toString = "q" + hashCode
}

class IDState(val ident : Int) extends State {
  override def toString =
    getTransitions.foldLeft("q" + ident + '\n') { (s, t) =>
      val dest = t.getDest match {
        case d : IDState => "q" + d.ident
        case q => q.toString
      }
      s + "  --[" + t.getMin + ", " + t.getMax + "]--> " + dest + '\n'
    }
}

object CaleyGraphSpecification
	extends Properties("CaleyGraph"){

  val states = Seq.fill(10)(new PrintableState)

  property("Test compose") = {

    val b1 = new Box[BricsAutomaton]()
    val b2 = new Box[BricsAutomaton]()

    b1.addEdge(states(0), states(1))
    b2.addEdge(states(1), states(2))

    val box = b1 ++ b2

    box(states(0)) == Set(states(2))
  }

  implicit def arbBox : Arbitrary[Box[BricsAutomaton]] = Arbitrary {
    for (
      items <- Gen.listOf(Gen.listOfN(2, Gen.oneOf(states)))
    ) yield {
      // Can't figure out how to use Box(items) due to
      // PrintableState
      items.foldLeft(new Box[BricsAutomaton])((box, qq) =>
        box.addEdge(qq(0), qq(1))
      )
    }
  }

  def caleyGraphHasBoxes(baut : BricsAutomaton,
               boxes : Set[Box[BricsAutomaton]]) = {
    val cg = CaleyGraph(baut)
    cg.getNodes == boxes
  }

  property("Serious test compose") =
    forAll { (b1 : Box[BricsAutomaton], b2 : Box[BricsAutomaton]) =>
      val bb = b1 ++ b2
      val dir1 = // in bb => in b1 and b2
        bb.getEdges.forall { case (q1, q3) =>
          b1(q1).exists(q2 => b2.hasEdge(q2, q3))
        }
      val dir2 = // in b1 and b2 => in bb
        b1.getEdges.forall { case (q1, q2) =>
          b2(q2).forall(q3 => bb.hasEdge(q1, q3))
        }
      dir1 && dir2
    }

  property("Caley graph nodes for empty aut") = {
    val aut = new BAutomaton
    val q = aut.getInitialState
    val baut = new BricsAutomaton(aut)
    val nodes = Set(Box[BricsAutomaton](), Box[BricsAutomaton]((q, q)))
    caleyGraphHasBoxes(baut, nodes)
  }

  property("Caley graph nodes for q0 -a-> q1 -b-> q2") = {
    val q0 = new IDState(0)
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q0.addTransition(new Transition('a', q1))
    q1.addTransition(new Transition('b', q2))
    val aut = new BAutomaton
    aut.setInitialState(q0)
    val baut = new BricsAutomaton(aut)

    val nodes = Set(Box[BricsAutomaton](),
                    Box[BricsAutomaton]((q0, q1)),
                    Box[BricsAutomaton]((q1, q2)),
                    Box[BricsAutomaton]((q0, q2)),
                    Box[BricsAutomaton]((q0, q0), (q1, q1), (q2, q2)))

    caleyGraphHasBoxes(baut, nodes)
  }

  property("Caley graph for q0 -a-> q1 -b-> q2 -a-> q0") = {
    val q0 = new IDState(0)
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q0.addTransition(new Transition('a', q1))
    q1.addTransition(new Transition('b', q2))
    q2.addTransition(new Transition('a', q0))
    val aut = new BAutomaton
    aut.setInitialState(q0)
    val baut = new BricsAutomaton(aut)

    val nodes = Set(Box[BricsAutomaton]((q0, q0), (q1, q1), (q2, q2)),
                    Box[BricsAutomaton]((q0, q1), (q2, q0)),
                    Box[BricsAutomaton]((q1, q2)),
                    Box[BricsAutomaton]((q2, q1)),
                    Box[BricsAutomaton]((q0, q2)),
                    Box[BricsAutomaton]((q1, q0)),
                    Box[BricsAutomaton](),
                    Box[BricsAutomaton]((q2, q2)),
                    Box[BricsAutomaton]((q0, q0)),
                    Box[BricsAutomaton]((q1, q1)),
                    Box[BricsAutomaton]((q0, q1)),
                    Box[BricsAutomaton]((q0, q1)),
                    Box[BricsAutomaton]((q2, q0)))

    caleyGraphHasBoxes(baut, nodes)
  }

  property("Caley graph for q0 -[a,c]-> q1 -[f,j]-> q2 -[h,z]-> q0") = {
    val q0 = new IDState(0)
    val q1 = new IDState(1)
    val q2 = new IDState(2)
    q0.addTransition(new Transition('a', 'c', q1))
    q1.addTransition(new Transition('f', 'j', q2))
    q2.addTransition(new Transition('h', 'z', q0))
    val aut = new BAutomaton
    aut.setInitialState(q0)
    val baut = new BricsAutomaton(aut)

    val nodes = Set(Box[BricsAutomaton]((q0, q0), (q1, q1), (q2, q2)),
                    Box[BricsAutomaton]((q2, q0)),
                    Box[BricsAutomaton]((q0, q1)),
                    Box[BricsAutomaton]((q1, q2)),
                    Box[BricsAutomaton]((q1, q2), (q2, q0)),
                    Box[BricsAutomaton](),
                    Box[BricsAutomaton]((q0, q2)),
                    Box[BricsAutomaton]((q2, q1)),
                    Box[BricsAutomaton]((q1, q0)),
                    Box[BricsAutomaton]((q1, q1)),
                    Box[BricsAutomaton]((q2, q2)),
                    Box[BricsAutomaton]((q0, q0)))

    caleyGraphHasBoxes(baut, nodes)
  }
}
