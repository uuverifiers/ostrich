# OSTRICH
## An SMT Solver for String Constraints

OSTRICH is an SMT solver for string constraints.


## CertiStr: Certified String Analyzer

CertiStr (in certified-string-analyzer) certified backend for string constraint solving.
It uses OSTRICH front-end to parse SMT files.


## Running CertiStr

1. install OSTRICH by ``sbt assembly``

2. in the folder: certified-str-analyzer/code/forward_analysis,
    run ``make`` to generate executable ''forward_analysis'' file.
	and add the file ''forward_analysis" to your PATH.
	
3. you can run any test by the command ``CertiStr `` + inputfile.
    For example, ``./CertiStr tests/loop.smt2``

## Using Ostrich

After installing [the Scala Build tool (SBT)](https://www.scala-sbt.org/), you can assemble a JAR file using `sbt assembly`. To run it, use either the `ostrich` script in the root folder, or `ostrich-client`. The latter transparently spins up a server that continuously serves requests from the client script; useful to avoid cold-starting the JVM if you are running many instances.

See `./ostrich -help` for more options.

## Input Format

OSTRICH accepts constraints written using the [SMT-LIB theory of strings](http://smtlib.cs.uiowa.edu/theories-UnicodeStrings.shtml). At this point, most of the operators in the theory are supported, but inputs need to be straightline; see [this paper](https://dblp.uni-trier.de/rec/journals/pacmpl/ChenHLRW19.html?view=bibtex) for a definition.

In addition to the standardized SMT-LIB operators, OSTRICH can handle a number of further functions.

### Additional string functions

| Name        | Explanation      |
|-------------|------------------|
| str.reverse | Reverse a string |

### Unary transducers

Finite-state transducers are a general way to introduce further string functions. Examples of functions that can be represented as transducers are encoders, decoders, extraction of sub-strings, removal of white-space characters, etc.

Finite-state transducers can be defined as (mutually) recursive functions, see [this file](../master/tests/transducer1.smt2) for an example.

### Additional regular expression constructors

| Name        | Explanation      |
|-------------|------------------|
| re.from_ecma2020 | Parse a regular expression in textual ECMAScript 2020 format [(example)](../master/tests/parse-ecma-cases.smt2) |
| re.case_insensitive | Make any regular expression case insensitive [(example)](../master/tests/case-insensitive.smt2) |

