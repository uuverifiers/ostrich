#!/bin/bash
tPath=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat << EOF > "$tPath/toolconfig.json"
{
  "Binaries" : {
		"Z3" : {
			"path" : "$tPath/SolverBinaries/z3/z3"
		},
		"CVC5" : {
				"path" : "$tPath/SolverBinaries/cvc5/cvc5"
		},
		"OSTRICH2" : {
				"path" : "$tPath/SolverBinaries/ostrich2/ostrich"
		},
		"OSTRICH1" : {
				"path" : "$tPath/SolverBinaries/ostrich1/ostrich"
		},
		"Z3alpha" : {
				"path" : "$tPath/SolverBinaries/z3alpha/z3alpha.py"
		},
		"Z3noodler" : {
				"path" : "$tPath/SolverBinaries/z3-noodler/z3"
		}
  }
}
EOF
