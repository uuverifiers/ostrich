package stringfuns

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop._
import scala.collection.mutable.{HashMap, MultiMap, Set}
import dk.brics.automaton.State

class PrintableState extends State {
    override def toString = "(" + hashCode + ":" + super.toString + ")"
}

object CaleyGraphSpecification
	extends Properties("CaleyGraph"){
    
    val states = Seq.fill(10)(new PrintableState)

    property("Test compose") = {
        val mm1 = new HashMap[State, Set[State]] with MultiMap[State,State]
        val mm2 = new HashMap[State, Set[State]] with MultiMap[State,State]

        mm1.addBinding(states(0), states(1))
        mm2.addBinding(states(1), states(2))

        val box1 = new Box(mm1)
        val box2 = new Box(mm2)
        val box = box1 ++ box2 
        
        box(states(0)) == Set(states(2))
    }

    val boxGen : Gen[Box] = for (
        items <- Gen.listOf(Gen.listOfN(2, Gen.oneOf(states)))
    ) yield {
        val mm = new HashMap[State, Set[State]] with MultiMap[State, State]
        for (ss <- items)
            mm.addBinding(ss(0), ss(1))
        new Box(mm)
    }

    property("Serious test compose") = 
        forAll(boxGen, boxGen) { (b1 : Box, b2 : Box) =>
            val bb = b1 ++ b2
            val dir1 = // in bb => in b1 and b2
                bb.arrows.forall { case (s1, ss) =>
                    ss.forall(s3 =>
                        b1.arrows.entryExists(s1, s2 =>
                            b2.arrows.entryExists(s2, _ == s3)
                        )
                    )
                }
            val dir2 = // in b1 and b2 => in bb
                b1.arrows.forall { case (s1, ss) =>
                    ss.forall(s2 =>
                        !b2.arrows.isDefinedAt(s2) || 
                        b2.arrows(s2).forall(s3 => bb.arrows.entryExists(s1, _ == s3))
                    )
                }
            dir1 && dir2
        }
}
