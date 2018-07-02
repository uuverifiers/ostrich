lazy val commonSettings = Seq(
  name := "sloth",
  version := "1.0",
  scalaVersion := "2.11.8",
  scalacOptions += "-deprecation",
  resolvers += "uuverifiers" at "http://logicrunch.it.uu.se:4096/~wv/maven/",
//  libraryDependencies += "uuverifiers" %% "princess" % "2018-05-25",
  libraryDependencies += "uuverifiers" %% "princess" % "nightly-SNAPSHOT",
  libraryDependencies += "org.sat4j" % "org.sat4j.core" % "2.3.1",
  libraryDependencies += "org.scalacheck" %% "scalacheck" % "1.14.0" % "test"
)

lazy val root = (project in file(".")).
  settings(commonSettings: _*).
  settings(
    mainClass in Compile := Some("strsolver.SMTLIBMain"),
    unmanagedSourceDirectories in Test += baseDirectory.value / "replaceall-benchmarks" / "src" / "test" / "scala"
  )


