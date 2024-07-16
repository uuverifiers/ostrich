lazy val commonSettings = Seq(
  name                  := "ostrich",
  organization          := "uuverifiers",
  version               := "1.3.5",
//
  homepage              := Some(url("https://github.com/uuverifiers/ostrich")),
  licenses              := Seq("BSD-3-Clause" -> url("https://opensource.org/licenses/BSD-3-Clause")),
  scmInfo               := Some(ScmInfo(
                                url("https://github.com/uuverifiers/ostrich"),
                                "scm:git@github.com/uuverifiers/ostrich.git")), 
  description           := "OSTRICH is an SMT solver for string constraints.",
//
  developers            := List(
                             Developer(
                               id    = "matthew.hague",
                               name  = "Matthew Hague",
                               email = "matthew.hague@rhul.ac.uk",
                               url   = url("https://www.cs.rhul.ac.uk/home/uxac009/")
                             ),
                             Developer(
                               id    = "p_ruemmer",
                               name  = "Philipp Ruemmer",
                               email = "ph_r@gmx.net",
                               url   = url("https://philipp.ruemmer.org")
                             ),
                             Developer(
                               id    = "riccardo.de.masellis",
                               name  = "Riccardo De Masellis",
                               email = "demasellis@gmail.com",
                               url   = url("http://demasellis.x10host.com/")
                             ),
                             Developer(
                               id    = "zhilei.han",
                               name  = "Zhilei Han",
                               email = "hzl17@mails.tsinghua.edu.cn",
                               url   = url("https://www.linusboyle.cn/")
                             ),
                             Developer(
                               id    = "oliver.markgraf",
                               name  = "Oliver Markgraf",
                               email = "markgraf@cs.uni-kl.de",
                               url   = url("https://arg.cs.uni-kl.de/gruppe/markgraf/")
                             ),
                             Developer(
                               id    = "denghang.hu",
                               name  = "Denghang Hu",
                               email = "hudh@ios.ac.cn",
                               url   = url("https://tis.ios.ac.cn/?page_id=2451")
                             )
                          ),
//
  scalaVersion          := "2.11.12",
  crossScalaVersions    := Seq("2.11.12", "2.12.17"),
  scalacOptions         += "-deprecation",
  fork in run           := true,
  cancelable in Global  := true,
//
  publishTo := Some(Resolver.file("file",  new File( "/home/wv/public_html/maven/" )) )
)

lazy val parserSettings = Seq(
//    publishArtifact in packageDoc := false,
//    publishArtifact in packageSrc := false,
    exportJars := true,
    crossPaths := true 
)

lazy val ecma2020parser = (project in file("ecma2020")).
  settings(commonSettings: _*).
  settings(parserSettings: _*).
  settings(
    name := "OSTRICH-ECMA2020-parser",
    packageBin in Compile := baseDirectory.value / "ecma2020-regex-parser.jar"
  ).
  disablePlugins(AssemblyPlugin)

lazy val root = (project in file(".")).
  aggregate(ecma2020parser).
  dependsOn(ecma2020parser).
  settings(commonSettings: _*).
  settings(
    mainClass in Compile := Some("ostrich.OstrichMain"),
    test in assembly := {},
    unmanagedSourceDirectories in Test += baseDirectory.value / "replaceall-benchmarks" / "src" / "test" / "scala",
//
    resolvers             += "uuverifiers" at "https://eldarica.org/maven/",
//
//    libraryDependencies   += "uuverifiers" %% "princess" % "nightly-SNAPSHOT",
    libraryDependencies   += "io.github.uuverifiers" %% "princess" % "2024-03-22",
  //  libraryDependencies   += "uuverifiers" % "ecma2020-regex-parser" % "0.5",
    libraryDependencies   += "org.sat4j" % "org.sat4j.core" % "2.3.1",
    libraryDependencies   += "org.scalacheck" %% "scalacheck" % "1.14.0" % "test",
    libraryDependencies   += "dk.brics.automaton" % "automaton" % "1.11-8",
    libraryDependencies   += "com.lihaoyi" %% "fastparse" % "3.0.2",
  )


