lazy val commonSettings = Seq(
  name := "sloth",
  version := "1.0",
  scalaVersion := "2.11.8",
  resolvers += "uuverifiers" at "http://logicrunch.it.uu.se:4096/~wv/maven/",
  libraryDependencies += "uuverifiers" %% "princess" % "2018-02-26",
  libraryDependencies += "org.sat4j" % "org.sat4j.core" % "2.3.1"
)

lazy val root = (project in file(".")).
  settings(commonSettings: _*).
  settings(
    mainClass in Compile := Some("strsolver.SMTLIBMain")
  )


