(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([a-zA-Z]{2})([0-9]{6}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9"))))))
(check-sat)
