(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z]\x3D[0-9a-z]{100}$/Pm
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 100 100) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/Pm\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
