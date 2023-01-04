package ostrich

import ap.CmdlMain
import ostrich.OstrichMain.options

object RiccardoMain {

  def main(args: Array[String]): Unit = {
    //val input = Array[String]("/Users/demas/Lavoro/Uppsala/ostrich/tests/concat-regex.smt2")
    val input = Array[String]("/Users/demas/Lavoro/Uppsala/ostrich/tests/parse-ecma-cases.smt2")
    //val input = Array[String]("/Users/demas/Lavoro/Uppsala/ostrich/tests/parse-ecma-riccardo.smt2")
    //val input = Array[String]("/Users/demas/Lavoro/Uppsala/ostrich/tests/parse-ecma-riccardo-2.smt2")
    ap.CmdlMain.stackTraces=true
    ap.CmdlMain.main((options ++ List("+assert", "+model") ++ input).toArray)
  }

}
