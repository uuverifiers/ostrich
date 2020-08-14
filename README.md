# OSTRICH [![Build Status](https://travis-ci.org/uuverifiers/ostrich.svg?branch=master)](https://travis-ci.org/uuverifiers/ostrich)
## An SMT Solver for String Constraints

OSTRICH is an SMT solver for string constraints.

For the POPL 2019 version, please use the popl2019 branch.

## Using Ostrich

After installing [the Scala Build tool (SBT)](https://www.scala-sbt.org/), you can assemble a JAR file using `sbt assembly`. To run it, use either the `ostrich` script in the root folder, or `ostrich-client`. The latter transparently spins up a server that continuously serves requests from the client script; useful to avoid cold-starting the JVM if you are running many instances.

See `./ostrich -help` for more options.
