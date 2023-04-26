lazy val commonSettings = Seq(
  name                  := "ostrich",
  organization          := "uuverifiers",
  version               := "1.2.1",
//
  homepage := Some(url("https://github.com/uuverifiers/ostrich")),
  licenses := Seq(
    "BSD-3-Clause" -> url("https://opensource.org/licenses/BSD-3-Clause")
  ),
  scmInfo := Some(
    ScmInfo(
      url("https://github.com/uuverifiers/ostrich"),
      "scm:git@github.com/uuverifiers/ostrich.git"
    )
  ),
  description := "OSTRICH is an SMT solver for string constraints.",
//
  developers := List(
    Developer(
      id = "matthew.hague",
      name = "Matthew Hague",
      email = "matthew.hague@rhul.ac.uk",
      url = url("https://www.cs.rhul.ac.uk/home/uxac009/")
    ),
    Developer(
      id = "p_ruemmer",
      name = "Philipp Ruemmer",
      email = "ph_r@gmx.net",
      url = url("https://philipp.ruemmer.org")
    ),
    Developer(
      id = "riccardo.de.masellis",
      name = "Riccardo De Masellis",
      email = "demasellis@gmail.com",
      url = url("http://demasellis.x10host.com/")
    ),
    Developer(
      id = "zhilei.han",
      name = "Zhilei Han",
      email = "hzl17@mails.tsinghua.edu.cn",
      url = url("https://www.linusboyle.cn/")
    ),
    Developer(
      id = "oliver.markgraf",
      name = "Oliver Markgraf",
      email = "markgraf@cs.uni-kl.de",
      url = url("https://arg.cs.uni-kl.de/gruppe/markgraf/")
    )
  ),
//
  scalaVersion          := "2.13.7",
//  scalacOptions         += "-deprecation",
  scalacOptions         += "-Ywarn-unused",
  run / fork           := true,
  // we have used some global objects, 
  // so that the test shound be taken serially.
  // Test / fork := true,
  Test / parallelExecution := false,
  semanticdbEnabled := true,
  semanticdbVersion := scalafixSemanticdb.revision,
  cancelable in Global  := true,
//
  publishTo := Some(Resolver.file("file",  new File( "/home/wv/public_html/maven/" )) )
)


lazy val root = (project in file("."))
  .settings(commonSettings: _*)
  .settings(
    Compile / mainClass := Some("ostrich.OstrichMain"),
    Test / unmanagedResources += baseDirectory.value / "replaceall-benchmarks" / "src" / "test" / "scala",
//
    resolvers += ("uuverifiers" at "http://logicrunch.research.it.uu.se/maven/")
      .withAllowInsecureProtocol(true),
//
    libraryDependencies += "uuverifiers" %% "princess" % "nightly-SNAPSHOT",
    libraryDependencies += "uuverifiers" %% "ostrich-ecma2020-parser" % "1.2",
    libraryDependencies += "org.sat4j" % "org.sat4j.core" % "2.3.1",
    libraryDependencies += "org.scalacheck" % "scalacheck_2.13" % "1.17.0"% "test",
    libraryDependencies += "dk.brics.automaton" % "automaton" % "1.11-8",
    libraryDependencies += "com.lihaoyi" %% "os-lib" % "0.8.1",
    libraryDependencies += "uuverifiers" % "catra_2.13" % "0.1.0-SNAPSHOT"
  )
