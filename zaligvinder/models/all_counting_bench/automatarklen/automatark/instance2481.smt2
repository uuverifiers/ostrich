(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([oO0]*)([|:;=X^])([-']*)([)(oO0\]\[DPp*>X^@])
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "o") (str.to_re "O") (str.to_re "0"))) (re.union (str.to_re "|") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "X") (str.to_re "^")) (re.* (re.union (str.to_re "-") (str.to_re "'"))) (re.union (str.to_re ")") (str.to_re "(") (str.to_re "o") (str.to_re "O") (str.to_re "0") (str.to_re "]") (str.to_re "[") (str.to_re "D") (str.to_re "P") (str.to_re "p") (str.to_re "*") (str.to_re ">") (str.to_re "X") (str.to_re "^") (str.to_re "@")) (str.to_re "\u{0a}"))))
; ^L[a-zA-Z0-9]{26,33}$
(assert (not (str.in_re X (re.++ (str.to_re "L") ((_ re.loop 26 33) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
