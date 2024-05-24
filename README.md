# OSTRICH
## An SMT Solver for String Constraints

OSTRICH is an SMT solver for string constraints.

## Using Ostrich

After installing [the Scala Build tool (SBT)](https://www.scala-sbt.org/), you can assemble a JAR file using `sbt assembly`. To run it, use either the `ostrich` script in the root folder, or `ostrich-client`. The latter transparently spins up a server that continuously serves requests from the client script; useful to avoid cold-starting the JVM if you are running many instances.

See `./ostrich -help` for more options.

The theory behind OSTRICH is explained in the slides of our [POPL'24 tutorial.](https://eldarica.org/ostrich-popl24/)

## Web Interface

For experiments, OSTRICH can also be used through its [web interface.](https://eldarica.org/ostrich/)

## Input Format

OSTRICH accepts constraints written using the [SMT-LIB theory of strings](http://smtlib.cs.uiowa.edu/theories-UnicodeStrings.shtml).

In addition to the standardized SMT-LIB operators, OSTRICH can handle a number of further functions.

### Additional string functions

| Name        | Explanation      |
|-------------|------------------|
| str.reverse | Reverse a string |

### Unary transducers

Finite-state transducers are a general way to introduce further string functions. Examples of functions that can be represented as transducers are encoders, decoders, extraction of sub-strings, removal of white-space characters, etc.

Finite-state transducers can be defined as (mutually) recursive functions, see [this file](../master/tests/transducer1.smt2) for an example.

It is also possible to use prioritised finite-state transducers: multiple outgoing transitions from a state can be given priorities, and the transducer will take the transition with highest priority that will lead to a successful run. See [this file](../master/tests/priorityTransducer.smt2) for an example.

### Additional regular expression constructors

| Name        | Explanation      |
|-------------|------------------|
| re.from_ecma2020 | Parse a regular expression in textual ECMAScript 2020 format [(example)](../master/tests/parse-ecma-cases.smt2) |
| re.from_ecma2020_flags | Parse a regular expression in textual ECMAScript 2020 format, with a second argument to specify flags [(example)](../master/tests/parse-ecma-cases.smt2) |
| re.case_insensitive | Make any regular expression case insensitive [(example)](../master/tests/case-insensitive.smt2) |
| re.from_automaton |  Parse a finite-state automaton [(example)](../master/tests/automata.smt2) |


### Handling of capture groups

OSTRICH can also process regular expressions that include capture groups, lazy quantifiers, and anchors, although this is more experimental. For this functionality, OSTRICH understands a number of additional regular expression operators:

| Name                 | Explanation                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| re.*?                | Non-greedy star: similar to re.* but matching as few characters as possible |
| re.+?                | Non-greedy plus                                                             |
| re.opt?              | Non-greedy option                                                           |
| (_ re.loop? a b)     | Non-greedy loop                                                             |
| (_ re.capture n)     | Capture group with index n                                                  |
| (_ re.reference n)   | Reference to the contents of capture group n                                |
| re.begin-anchor      | The anchor ^                                                                |
| re.end-anchor        | The anchor $                                                                |

Such augmented regular expressions can be used in combination with several new string functions. Those functions support in particular capture groups and references in the replacement strings:

| Name               | Explanation                                                                                          |
|--------------------|------------------------------------------------------------------------------------------------------|
| (_ str.extract n)  | Extract the contents of the n'th capture group ([example](../master/tests/extract-cg.smt2))          |
| str.replace_cg     | Replace the first match of a regular expression ([example](../master/tests/parse-ecma-replace.smt2)) |
| str.replace_cg_all | Replace all matches of a regular expression ([example](../master/tests/regex_cg_ref.smt2))           |
