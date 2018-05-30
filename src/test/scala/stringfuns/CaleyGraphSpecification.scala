package stringfuns

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._
import dk.brics.automaton.{Automaton, State, Transition}
import scala.collection.mutable.Set

class PrintableState extends State {
    override def toString = "q" + hashCode
}

class IDState(val ident : Int) extends State {
    override def toString = "q" + ident
}

object CaleyGraphSpecification
	extends Properties("CaleyGraph"){

    val states = Seq.fill(10)(new PrintableState)

    property("Test compose") = {

        val b1 = new Box()
        val b2 = new Box()

        b1.addEdge(states(0), states(1))
        b2.addEdge(states(1), states(2))

        val box = b1 ++ b2

        box(states(0)) == Set(states(2))
    }

    implicit def arbBox : Arbitrary[Box] = Arbitrary {
        for (
            items <- Gen.listOf(Gen.listOfN(2, Gen.oneOf(states)))
        ) yield {
            // Can't figure out how to use Box(items) due to
            // PrintableState
            items.foldLeft(new Box)((box, qq) => box.addEdge(qq(0), qq(1)))
        }
    }

    property("Serious test compose") =
        forAll { (b1 : Box, b2 : Box) =>
            val bb = b1 ++ b2
            val dir1 = // in bb => in b1 and b2
                bb.edges.forall { case (q1, q3) =>
                    b1(q1).exists(q2 => b2.hasEdge(q2, q3))
                }
            val dir2 = // in b1 and b2 => in bb
                b1.edges.forall { case (q1, q2) =>
                    b2(q2).forall(q3 => bb.hasEdge(q1, q3))
                }
            dir1 && dir2
        }

    property("Caley graph nodes for empty aut") = {
        val aut = new Automaton
        val q = aut.getInitialState
        CaleyGraph(aut) == new CaleyGraph(aut, Set(Box((q, q))))
    }

    property("Caley graph nodes for q0 -a-> q1 -b-> q2") = {
        val q0 = new IDState(0)
        val q1 = new IDState(1)
        val q2 = new IDState(2)
        q0.addTransition(new Transition('a', q1))
        q1.addTransition(new Transition('b', q2))
        val aut = new Automaton
        aut.setInitialState(q0)

        val nodes = Set(Box(),
                        Box((q0, q1)),
                        Box((q1, q2)),
                        Box((q0, q2)),
                        Box((q0, q0), (q1, q1), (q2, q2)))

        CaleyGraph(aut) == new CaleyGraph(aut, nodes)
    }

    property("Caley graph for q0 -a-> q1 -b-> q2 -a-> q0") = {
        val q0 = new IDState(0)
        val q1 = new IDState(1)
        val q2 = new IDState(2)
        q0.addTransition(new Transition('a', q1))
        q1.addTransition(new Transition('b', q2))
        q2.addTransition(new Transition('a', q0))
        val aut = new Automaton
        aut.setInitialState(q0)

        val nodes = Set(Box((q0, q0), (q1, q1), (q2, q2)),
                        Box((q0, q1), (q2, q0)),
                        Box((q1, q2)),
                        Box((q2, q1)),
                        Box((q0, q2)),
                        Box((q1, q0)),
                        Box(),
                        Box((q2, q2)),
                        Box((q0, q0)),
                        Box((q1, q1)),
                        Box((q0, q1)),
                        Box((q0, q1)),
                        Box((q2, q0)))

        CaleyGraph(aut) == new CaleyGraph(aut, nodes)
    }

}
