package ostrich.cesolver

import ap.ParallelFileProver
import ap.parameters.Param
import ostrich.cesolver.util.ParikhUtil
import ap.CmdlMain

/**
 * Wrapper around <code>ap.CmdlMain</code>, adding the option
 * <code>-stringSolver=ostrich.OstrichStringTheory</code>.
 */
object CEMain {

  val version = "unstable build (Princess: " + ap.CmdlMain.version + ")"

  /**
   * The options forwarded to Princess. They will be overwritten by options
   * specified on the command line, so it is possible to provide more specific
   * string solver options on the command line.
   */
  val options = List("-stringSolver=ostrich.cesolver.stringtheory.CEStringTheory", "-logo")

  ParallelFileProver.addPortfolio(
    "strings", arguments => {
                 import arguments._
                 val strategies =
                   List(ParallelFileProver.Configuration(
                          baseSettings,
                          "-stringSolver=" +
                            Param.STRING_THEORY_DESC(baseSettings),
                          1000000000,
                          2000),
                        ParallelFileProver.Configuration(
                          Param.STRING_THEORY_DESC.set(
                                  baseSettings,
                                  Param.STRING_THEORY_DESC.defau),
                          "-stringSolver=" +
                            Param.STRING_THEORY_DESC.defau,
                          1000000000,
                          2000))
                 ParallelFileProver(createReader,
                                    timeout,
                                    true,
                                    userDefStoppingCond(),
                                    strategies,
                                    1,
                                    2,
                                    runUntilProof,
                                    prelResultPrinter,
                                    threadNum)
               })

  def main(args: Array[String]) : Unit = try {
    ap.CmdlMain.main((options ++ args).toArray)
  } catch {
    case e: Throwable =>
      ParikhUtil.throwWithStackTrace(e)
  }

}
