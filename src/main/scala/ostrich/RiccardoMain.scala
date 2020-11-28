package ostrich

//import ap.CmdlMain
import ostrich.OstrichMain.options

object RiccardoMain {

  def main(args: Array[String]): Unit = {
    val input = Array[String]("/Users/demas/Lavoro/Uppsala/Amazon/my_trials/easyTrial1.smt2")
    ap.CmdlMain.main((options ++ input).toArray)
  }

}
