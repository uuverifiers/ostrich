lazy val commonSettings = Seq(
  name := "ostrich",
  organization := "uuverifiers",
  version := "1.0",
  scalaVersion := "2.11.12",
  crossScalaVersions := Seq("2.11.12", "2.12.12"),
  publishTo := Some(Resolver.file("file",  new File( "/home/wv/public_html/maven/" )) ),
   scalacOptions ++= Seq(
    "-deprecation",
    //"-Xfatal-warnings",
    "-unchecked",
    "-Xlint",
    "-Xelide-below", "FINE",
    // "-feature",
    // "-optimize",
    "-Ywarn-dead-code",
    "-Ywarn-unused"
  ),
  resolvers += ("uuverifiers" at "http://logicrunch.research.it.uu.se/maven/")
    .withAllowInsecureProtocol(true),
  libraryDependencies += "uuverifiers" %% "princess" % "nightly-SNAPSHOT",
  libraryDependencies += "uuverifiers" % "ecma2020-regex-parser" % "0.3-SNAPSHOT",
  libraryDependencies += "org.scalacheck" %% "scalacheck" % "1.14.0" % "test",
  libraryDependencies += "dk.brics.automaton" % "automaton" % "1.11-8",
  libraryDependencies += "uuverifiers" %% "parikh-theory" % "0.1.0-SNAPSHOT"
)

lazy val root = (project in file(".")).
  settings(commonSettings: _*).
  settings(
    mainClass in Compile := Some("ostrich.OstrichMain"),
    unmanagedSourceDirectories in Test += baseDirectory.value / "replaceall-benchmarks" / "src" / "test" / "scala"
  )


