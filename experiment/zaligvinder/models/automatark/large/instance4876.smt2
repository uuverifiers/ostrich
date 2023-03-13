(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \w{5,255}
(assert (str.in_re X (re.++ ((_ re.loop 5 255) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(check-sat)
