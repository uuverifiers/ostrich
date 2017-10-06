# Sloth
An SMT Solver for String Constraints

Sloth is an implementation of decision procedure for several relevant
fragments of string constraints, including the straight-line fragment,
which is sufficiently expressive in practice for many
applications. The tool uses succinct alternating finite-state automata
(AFAs) as concise symbolic representations of string constraints, and
uses model checking algorithms like IC3 for solving emptiness of
the AFA.

For documentation, see https://github.com/uuverifiers/sloth/wiki
