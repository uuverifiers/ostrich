package ostrich.automata.afa2

object Main extends App {

  val range1 = new Range(1, 10, 1)
  val range2 = new Range(2, 30, 1)
  val seq = Seq(range1, range2)

  //val boh = (for(rgs <- seq) yield rgs.flatten).toSet.toIndexedSeq.sorted

  //println(boh)


  /*
  val map = Map(1 -> Seq("uno", "unobis"), 2 -> Seq("due", "duebis"), 3 -> Seq("tre", "trebis"))
  val set = Set(8, 9, 5)

  val res = for (num <- set;
       seq <- map.get(num).iterator;
       str <- seq) yield str

  println(res)


  val input = Set(new Range(0, 1, 1),
    new Range(5, 9, 1),
    new Range(9, 10, 1),
    new Range(10, 12, 1),
    new Range(13, 21, 1),
    new Range(50, 51, 1))

  val toRem = new Range(20, 21, 1)


  val res = AFA2Utils.rangeDiff(input, toRem)

  println("Result:\n" + res)
*/

}
