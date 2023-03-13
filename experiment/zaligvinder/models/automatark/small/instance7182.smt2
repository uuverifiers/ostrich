(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(97(8|9))?\d{9}(\d|X)$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "97") (re.union (str.to_re "8") (str.to_re "9")))) ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "X")) (str.to_re "\u{0a}"))))
; onBetaHost\u{3a}youRootReferer\x3A
(assert (str.in_re X (str.to_re "onBetaHost:youRootReferer:\u{0a}")))
; /([etDZhns8dz]{1,3}k){3}[etDZhns8dz]{1,3}f[etDZhns8dz]{16}A/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "k"))) ((_ re.loop 1 3) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "f") ((_ re.loop 16 16) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "A/\u{0a}")))))
(check-sat)
