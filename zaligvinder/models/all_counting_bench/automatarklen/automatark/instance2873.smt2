(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[0-9A-Z]{8}\u{3a}bpass\u{0a}/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re ":bpass\u{0a}/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
