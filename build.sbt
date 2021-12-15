lazy val commonSettings = Seq(
  name                  := "ostrich",
  organization          := "uuverifiers",
  version               := "1.1",
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
                             )
                          ),
//
  scalaVersion          := "2.11.12",
  crossScalaVersions    := Seq("2.11.12", "2.12.10"),
  scalacOptions         += "-deprecation",
  fork in run           := true,
  cancelable in Global  := true,
//
  resolvers             += ("uuverifiers" at "http://logicrunch.research.it.uu.se/maven/").withAllowInsecureProtocol(true),
  libraryDependencies   += "uuverifiers" %% "princess" % "nightly-SNAPSHOT",
  libraryDependencies   += "uuverifiers" % "ecma2020-regex-parser" % "0.5",
  libraryDependencies   += "org.sat4j" % "org.sat4j.core" % "2.3.1",
  libraryDependencies   += "org.scalacheck" %% "scalacheck" % "1.14.0" % "test",
  libraryDependencies   += "dk.brics.automaton" % "automaton" % "1.11-8",
//
  publishTo := Some(Resolver.file("file",  new File( "/home/wv/public_html/maven/" )) )
)

lazy val root = (project in file(".")).
  settings(commonSettings: _*).
  settings(
    mainClass in Compile := Some("ostrich.OstrichMain"),
    unmanagedSourceDirectories in Test += baseDirectory.value / "replaceall-benchmarks" / "src" / "test" / "scala"
  )


