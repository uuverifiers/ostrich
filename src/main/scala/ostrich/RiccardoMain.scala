package ostrich

//import ap.CmdlMain
import ostrich.OstrichMain.options

object RiccardoMain {

  def main(args: Array[String]): Unit = {
    val input = Array[String]("/Users/demas/Lavoro/Uppsala/ostrich/tests/yan-benchmarks/replaceAll-001.smt2")
    //val input = Array[String]("/Users/demas/Lavoro/Uppsala/ostrich/tests/test-replace-regex2.smt2")
    //val input = Array[String]("/Users/demas/Lavoro/Uppsala/ostrich/tests/test-replace-word2.smt2")
    //val input = Array[String]("/Users/demas/Lavoro/Uppsala/Amazon/my_trials/easyTrial1.smt2")
    //val input = Array[String]("/Users/demas/Lavoro/Uppsala/Amazon/benchmarks/carsten/non_termination_regular_expression3.smt2")
    ap.CmdlMain.main((options ++ List("+assert") ++ input).toArray)
  }

}
