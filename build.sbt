lazy val commonSettings = Seq(
  name := "sloth",
  version := "1.0",
  scalaVersion := "2.11.8",
  resolvers += "uuverifiers" at "http://logicrunch.it.uu.se:4096/~wv/maven/",
  libraryDependencies += "uuverifiers" %% "princess" % "2017-07-17"
)

lazy val root = (project in file(".")).
  settings(commonSettings: _*).
  settings(
    mainClass in Compile := Some("strsolver.SMTLIBMain")
  )


