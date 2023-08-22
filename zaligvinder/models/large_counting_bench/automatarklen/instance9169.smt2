(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z0-9\-]{2,80})$
(assert (str.in_re X (re.++ ((_ re.loop 2 80) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
