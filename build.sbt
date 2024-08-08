lazy val commonSettings = Seq(
  name := "ostrich",
  organization := "uuverifiers",
  version := "1.0",
  scalaVersion := "2.11.12",
  crossScalaVersions := Seq("2.11.12", "2.12.10"),
  publishTo := Some(Resolver.file("file",  new File( "/home/wv/public_html/maven/" )) ),
  scalacOptions += "-deprecation",
  resolvers += ("uuverifiers" at "https://eldarica.org/maven/").withAllowInsecureProtocol(true),
  libraryDependencies += "uuverifiers" %% "princess" % "2021-06-28",
  libraryDependencies += "uuverifiers" % "ecma2020-regex-parser" % "0.5",
  libraryDependencies += "org.sat4j" % "org.sat4j.core" % "2.3.1",
  libraryDependencies += "org.scalacheck" %% "scalacheck" % "1.14.0" % "test",
  libraryDependencies += "dk.brics.automaton" % "automaton" % "1.11-8"
)

lazy val root = (project in file(".")).
  settings(commonSettings: _*).
  settings(
    mainClass in Compile := Some("ostrich.OstrichMain"),
    unmanagedSourceDirectories in Test += baseDirectory.value / "replaceall-benchmarks" / "src" / "test" / "scala"
  )


