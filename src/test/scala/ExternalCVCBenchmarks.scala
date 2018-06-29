
package strsolver

import ap.DialogUtil.asString

import org.scalacheck.{Arbitrary, Gen, Properties}
import org.scalacheck.Prop._

/**
 * Expects CVC benchmarks in external-benchmarks/cvc directory
 * These are not distributed with our code.
 */
object ExternalCVCBenchmarks extends Properties("ExternalCVCBenchmarks") {

  val IgnoreTests = false

  def expectResult[A](expResult : String)(computation : => A) : Boolean = {
    val result = asString {
      Console.withErr(ap.CmdlMain.NullStream) {
        computation
      }
    }

    (result split "\n") contains expResult
  }

  def checkFile(filename : String, result : String,
                extractOpts : String*) : Boolean =
    expectResult(result) {
      SMTLIBMain.doMain((List("+assert", "-timeout=10", filename) ++ extractOpts).toArray,
                        false)
//      SMTLIBMain.doMain((List("+assert", "+forward", filename) ++ extractOpts).toArray,
//                        false)
    }

  // TODO: commented out if we don't know if sat or not
  if (!IgnoreTests) {
    property("28") = checkFile("external-benchmarks/cvc/28/model", "sat")
    //property("30") = checkFile("external-benchmarks/cvc/30/model", "sat")
    property("31") = checkFile("external-benchmarks/cvc/31/model", "unsat")
    //property("32") = checkFile("external-benchmarks/cvc/32/model", "sat")
    property("36") = checkFile("external-benchmarks/cvc/36/model", "unsat")
    //property("38") = checkFile("external-benchmarks/cvc/38/model", "sat")
    property("39") = checkFile("external-benchmarks/cvc/39/model", "unsat")
    //property("40") = checkFile("external-benchmarks/cvc/40/model", "sat")
    property("44") = checkFile("external-benchmarks/cvc/44/model", "unsat")
    //property("46") = checkFile("external-benchmarks/cvc/46/model", "sat")
    property("47") = checkFile("external-benchmarks/cvc/47/model", "unsat")
    //property("48") = checkFile("external-benchmarks/cvc/48/model", "sat")
    property("52") = checkFile("external-benchmarks/cvc/52/model", "unsat")
    //property("54") = checkFile("external-benchmarks/cvc/54/model", "sat")
    property("55") = checkFile("external-benchmarks/cvc/55/model", "unsat")
    //property("56") = checkFile("external-benchmarks/cvc/56/model", "sat")
    property("60") = checkFile("external-benchmarks/cvc/60/model", "unsat")
    //property("62") = checkFile("external-benchmarks/cvc/62/model", "sat")
    property("63") = checkFile("external-benchmarks/cvc/63/model", "unsat")
    //property("64") = checkFile("external-benchmarks/cvc/64/model", "sat")
    //property("145") = checkFile("external-benchmarks/cvc/145/model", "sat")
    //property("147") = checkFile("external-benchmarks/cvc/147/model", "sat")
    property("149") = checkFile("external-benchmarks/cvc/149/model", "unsat")
    //property("150") = checkFile("external-benchmarks/cvc/150/model", "sat")
    property("151") = checkFile("external-benchmarks/cvc/151/model", "sat")
    property("152") = checkFile("external-benchmarks/cvc/152/model", "sat")
    property("153") = checkFile("external-benchmarks/cvc/153/model", "sat")
    //property("154") = checkFile("external-benchmarks/cvc/154/model", "sat")
    //property("252") = checkFile("external-benchmarks/cvc/252/model", "sat")
    //property("343") = checkFile("external-benchmarks/cvc/343/model", "sat")
    //property("346") = checkFile("external-benchmarks/cvc/346/model", "sat")
    property("518") = checkFile("external-benchmarks/cvc/518/model", "sat")
    property("519") = checkFile("external-benchmarks/cvc/519/model", "sat")
    property("520") = checkFile("external-benchmarks/cvc/520/model", "sat")
    property("521") = checkFile("external-benchmarks/cvc/521/model", "sat")
    property("522") = checkFile("external-benchmarks/cvc/522/model", "sat")
    property("523") = checkFile("external-benchmarks/cvc/523/model", "sat")
    property("524") = checkFile("external-benchmarks/cvc/524/model", "sat")
    property("525") = checkFile("external-benchmarks/cvc/525/model", "sat")
    property("526") = checkFile("external-benchmarks/cvc/526/model", "sat")
    property("527") = checkFile("external-benchmarks/cvc/527/model", "sat")
    property("528") = checkFile("external-benchmarks/cvc/528/model", "sat")
    property("529") = checkFile("external-benchmarks/cvc/529/model", "sat")
    property("530") = checkFile("external-benchmarks/cvc/530/model", "sat")
    property("531") = checkFile("external-benchmarks/cvc/531/model", "sat")
    property("532") = checkFile("external-benchmarks/cvc/532/model", "sat")
    property("534") = checkFile("external-benchmarks/cvc/534/model", "sat")
    property("535") = checkFile("external-benchmarks/cvc/535/model", "sat")
    property("536") = checkFile("external-benchmarks/cvc/536/model", "sat")
    property("537") = checkFile("external-benchmarks/cvc/537/model", "sat")
    property("538") = checkFile("external-benchmarks/cvc/538/model", "sat")
    property("539") = checkFile("external-benchmarks/cvc/539/model", "sat")
    property("540") = checkFile("external-benchmarks/cvc/540/model", "sat")
    property("1615") = checkFile("external-benchmarks/cvc/1615/model", "sat")
    property("1616") = checkFile("external-benchmarks/cvc/1616/model", "sat")
    property("1617") = checkFile("external-benchmarks/cvc/1617/model", "sat")
    property("1618") = checkFile("external-benchmarks/cvc/1618/model", "sat")
    property("1619") = checkFile("external-benchmarks/cvc/1619/model", "sat")
    property("1620") = checkFile("external-benchmarks/cvc/1620/model", "sat")
    property("1621") = checkFile("external-benchmarks/cvc/1621/model", "sat")
    property("1622") = checkFile("external-benchmarks/cvc/1622/model", "sat")
    property("1623") = checkFile("external-benchmarks/cvc/1623/model", "sat")
    property("1624") = checkFile("external-benchmarks/cvc/1624/model", "sat")
    property("1625") = checkFile("external-benchmarks/cvc/1625/model", "sat")
    property("1626") = checkFile("external-benchmarks/cvc/1626/model", "sat")
    property("1627") = checkFile("external-benchmarks/cvc/1627/model", "sat")
    property("1628") = checkFile("external-benchmarks/cvc/1628/model", "sat")
    property("1629") = checkFile("external-benchmarks/cvc/1629/model", "sat")
    property("1630") = checkFile("external-benchmarks/cvc/1630/model", "sat")
    property("1631") = checkFile("external-benchmarks/cvc/1631/model", "sat")
    property("1632") = checkFile("external-benchmarks/cvc/1632/model", "sat")
    property("1633") = checkFile("external-benchmarks/cvc/1633/model", "sat")
    property("1634") = checkFile("external-benchmarks/cvc/1634/model", "sat")
    property("1635") = checkFile("external-benchmarks/cvc/1635/model", "sat")
    property("1636") = checkFile("external-benchmarks/cvc/1636/model", "sat")
    property("1637") = checkFile("external-benchmarks/cvc/1637/model", "sat")
    property("1638") = checkFile("external-benchmarks/cvc/1638/model", "sat")
    property("1639") = checkFile("external-benchmarks/cvc/1639/model", "sat")
    property("1640") = checkFile("external-benchmarks/cvc/1640/model", "sat")
    property("1641") = checkFile("external-benchmarks/cvc/1641/model", "sat")
    property("1642") = checkFile("external-benchmarks/cvc/1642/model", "sat")
    property("1643") = checkFile("external-benchmarks/cvc/1643/model", "sat")
    //property("1820") = checkFile("external-benchmarks/cvc/1820/model", "sat")
    property("1821") = checkFile("external-benchmarks/cvc/1821/model", "sat")
    //property("1822") = checkFile("external-benchmarks/cvc/1822/model", "sat")
    //property("1828") = checkFile("external-benchmarks/cvc/1828/model", "sat")
    property("1830") = checkFile("external-benchmarks/cvc/1830/model", "sat")
    property("1832") = checkFile("external-benchmarks/cvc/1832/model", "sat")
    property("1834") = checkFile("external-benchmarks/cvc/1834/model", "sat")
    property("1835") = checkFile("external-benchmarks/cvc/1835/model", "sat")
    property("1836") = checkFile("external-benchmarks/cvc/1836/model", "sat")
    property("1837") = checkFile("external-benchmarks/cvc/1837/model", "sat")
    property("1838") = checkFile("external-benchmarks/cvc/1838/model", "sat")
    property("1839") = checkFile("external-benchmarks/cvc/1839/model", "sat")
    property("1840") = checkFile("external-benchmarks/cvc/1840/model", "sat")
    property("1841") = checkFile("external-benchmarks/cvc/1841/model", "sat")
    //property("1856") = checkFile("external-benchmarks/cvc/1856/model", "sat")
    property("2204") = checkFile("external-benchmarks/cvc/2204/model", "unsat")
    property("2648") = checkFile("external-benchmarks/cvc/2648/model", "unsat")
    property("2705") = checkFile("external-benchmarks/cvc/2705/model", "unsat")
    property("2728") = checkFile("external-benchmarks/cvc/2728/model", "unsat")
    property("2852") = checkFile("external-benchmarks/cvc/2852/model", "sat")
    //property("2884") = checkFile("external-benchmarks/cvc/2884/model", "sat")
    //property("2886") = checkFile("external-benchmarks/cvc/2886/model", "sat")
    property("2888") = checkFile("external-benchmarks/cvc/2888/model", "sat")
    //property("2889") = checkFile("external-benchmarks/cvc/2889/model", "sat")
    property("2890") = checkFile("external-benchmarks/cvc/2890/model", "sat")
    property("2891") = checkFile("external-benchmarks/cvc/2891/model", "sat")
    property("2892") = checkFile("external-benchmarks/cvc/2892/model", "sat")
    //property("2893") = checkFile("external-benchmarks/cvc/2893/model", "sat")
    property("3786") = checkFile("external-benchmarks/cvc/3786/model", "sat")
    //property("4062") = checkFile("external-benchmarks/cvc/4062/model", "sat")
    //property("4158") = checkFile("external-benchmarks/cvc/4158/model", "sat")
    //property("4200") = checkFile("external-benchmarks/cvc/4200/model", "sat")
    //property("4237") = checkFile("external-benchmarks/cvc/4237/model", "sat")
    property("4267") = checkFile("external-benchmarks/cvc/4267/model", "sat")
    //property("4308") = checkFile("external-benchmarks/cvc/4308/model", "sat")
    //property("4312") = checkFile("external-benchmarks/cvc/4312/model", "sat")
    property("4319") = checkFile("external-benchmarks/cvc/4319/model", "sat")
    property("4595") = checkFile("external-benchmarks/cvc/4595/model", "sat")
  }
}
