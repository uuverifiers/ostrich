(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z]\u{3d}[a-f\d]{80,140}$/Pi
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 80 140) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Pi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
