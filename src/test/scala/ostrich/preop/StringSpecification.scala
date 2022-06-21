import org.scalacheck._

object StringSpecification extends Properties("String") {
  import Prop.forAll

  property("startsWith") = forAll { (a: String, b: String) =>
    (a + b).startsWith(a)
  }

  property("endsWith") = forAll { (a: String, b: String) =>
    (a + b).endsWith(b)
  }

  property("substring") = forAll { (a: String, b: String) =>
    (a + b).substring(a.length) == b
  }

  property("substring") = forAll { (m: Int, n: Int) =>
    val res = n + m
    (res >= m)  &&
    (res >= n)  &&
    (res < m + n) 
  }
}
