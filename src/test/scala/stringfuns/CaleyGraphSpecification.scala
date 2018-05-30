package stringfuns

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop._
import dk.brics.automaton.State

class PrintableState extends State {
    override def toString = "(" + hashCode + ":" + super.toString + ")"
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

    val boxGen : Gen[Box] = for (
        items <- Gen.listOf(Gen.listOfN(2, Gen.oneOf(states)))
    ) yield {
        items.foldLeft(new Box)((box, qq) => box.addEdge(qq(0), qq(1)))
    }

    property("Serious test compose") = 
        forAll(boxGen, boxGen) { (b1 : Box, b2 : Box) =>
            val bb = b1 ++ b2
            val dir1 = // in bb => in b1 and b2
                bb.edges.forall { case (q1, q3) =>
                    b1.targetStates(q1).exists(q2 => b2.hasEdge(q2, q3))
                }
            val dir2 = // in b1 and b2 => in bb
                b1.edges.forall { case (q1, q2) =>
                    b2.targetStates(q2).forall(q3 => bb.hasEdge(q1, q3))
                }
            dir1 && dir2
        }
}
