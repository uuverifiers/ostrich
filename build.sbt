lazy val commonSettings = Seq(
  name                  := "ostrich",
  organization          := "uuverifiers",
  version               := "1.1",
  maxErrors             := 5,
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
  fork in run           := true,
  cancelable in Global  := true,
//
  publishTo := Some(Resolver.file("file",  new File( "/home/wv/public_html/maven/" )) )
)

// lazy val parserSettings = Seq(
// //    publishArtifact in packageDoc := false,
// //    publishArtifact in packageSrc := false,
//   exportJars := true,
//   crossPaths := true
// )

// lazy val ecma2020parser = (project in file("ecma2020"))
//   .settings(commonSettings: _*)
//   .settings(parserSettings: _*)
//   .settings(
//     name := "OSTRICH-ECMA2020-parser",
//     Compile / packageBin := baseDirectory.value / "ecma2020-regex-parser.jar"
//   )
//   .disablePlugins(AssemblyPlugin)

lazy val root = (project in file("."))
  // .aggregate(ecma2020parser)
  // .dependsOn(ecma2020parser)
  .settings(commonSettings: _*)
  .settings(
    Compile / mainClass := Some("ostrich.OstrichMain"),
    Test / unmanagedResources += baseDirectory.value / "replaceall-benchmarks" / "src" / "test" / "scala",
//
    resolvers += ("uuverifiers" at "http://logicrunch.research.it.uu.se/maven/")
      .withAllowInsecureProtocol(true),
//
//    libraryDependencies   += "io.github.uuverifiers" %% "princess" % "2022-07-01",
    libraryDependencies += "uuverifiers" %% "princess" % "nightly-SNAPSHOT",
     libraryDependencies   += "uuverifiers" %% "ostrich-ecma2020-parser" % "1.2",
    libraryDependencies += "org.sat4j" % "org.sat4j.core" % "2.3.1",
    libraryDependencies += "org.scalacheck" %% "scalacheck" % "1.14.0" % "test",
    libraryDependencies += "dk.brics.automaton" % "automaton" % "1.11-8",
    libraryDependencies += "com.github.pureconfig" %% "pureconfig" % "0.17.1",
    // libraryDependencies += "uuverifiers" % "catra_2.13" % "0.1.0-SNAPSHOT"
  )
