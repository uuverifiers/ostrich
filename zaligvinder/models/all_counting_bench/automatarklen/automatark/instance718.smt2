(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z][a-z]+((i)?e(a)?(u)?[r(re)?|x]?)$
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}") (re.opt (str.to_re "i")) (str.to_re "e") (re.opt (str.to_re "a")) (re.opt (str.to_re "u")) (re.opt (re.union (str.to_re "r") (str.to_re "(") (str.to_re "e") (str.to_re ")") (str.to_re "?") (str.to_re "|") (str.to_re "x"))))))
; ^\#?[A-Fa-f0-9]{3}([A-Fa-f0-9]{3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (re.opt ((_ re.loop 3 3) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
